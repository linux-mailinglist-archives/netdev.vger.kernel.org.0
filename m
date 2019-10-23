Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0311E1A34
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 14:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391346AbfJWMam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 08:30:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:51794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389735AbfJWMam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 08:30:42 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iNFmZ-0003sD-9j; Wed, 23 Oct 2019 14:30:31 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iNFmZ-000VID-0w; Wed, 23 Oct 2019 14:30:31 +0200
Subject: Re: [PATCH bpf-next 2/3] libbpf: Support configurable pinning of maps
 from BTF annotations
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <157175668770.112621.17344362302386223623.stgit@toke.dk>
 <157175668991.112621.14204565208520782920.stgit@toke.dk>
 <CAEf4BzaM32j4iLhvcuwMS+dPDBd52KwviwJuoAwVVr8EwoRpHA@mail.gmail.com>
 <875zkgobf3.fsf@toke.dk>
 <CAEf4BzY-buKFadzzAKpCdjAZ+1_UwSpQobdRH7yQn_fFXQYX0w@mail.gmail.com>
 <87r233n8pl.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6c0e6ebf-aebc-5e80-0e32-aa81857f3a74@iogearbox.net>
Date:   Wed, 23 Oct 2019 14:30:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87r233n8pl.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25611/Wed Oct 23 10:58:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/19 10:53 AM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> 
>>>> 4. Once pinned, map knows its pinned path, just use that, I don't see
>>>> any reasonable use case where you'd want to override path just for
>>>> unpinning.
>>>
>>> Well, unpinning may need to re-construct the pin path. E.g.,
>>> applications that exit after loading and are re-run after unloading,
>>> such as iproute2, probably want to be able to unpin maps. Unfortunately
>>> I don't think there is a way to get the pin path(s) of an object from
>>> the kernel, though, is there? That would be kinda neat for implementing
>>> something like `ip link set dev eth0 xdp off unpin`.

Yep, there is no way to get the pinned path(s) of an object from the
kernel, there could be multiple bpf fs mounts (note that /sys/fs/bpf is
just one/default location but not limited to that) where the map is pinned,
even in different mount namespaces (e.g. container A has its own private
mount ns and container B as well, both independent from each other, but
in both could be pinned map X under some path), there could be various
hard links etc, so the only way would be to query *all* system-wide bpf
fs mounts for that given map id.

>> Hm... It seems to me that if application exits and another instance
>> starts, it should generate pin path using the same logic, then check
>> if map is already pinned. Then based on settings, either reuse or
>> unpin first. Either way, pin_path needs to be calculated from map
>> attributes, not "guessed" by application.
> 
> Yeah, ideally. However, the bpf object file may not be available (it's
> not for iproute2, for instance). I'm not sure there's really anything we
> *can* do about that, though, other than have the application guess.
> Unless we add more state to the kernel.
> 
> Would it make sense to store the fact that a map was auto-pinned as a
> flag in the kernel map info? That way, an application could read that
> flag along with the name and go looking in /sys/fs/bpf.

Don't think it makes sense, see above. I'm not 100% certain I'm following
the use case. You are worried about the case where an application should
be able to unpin the map before loading a new one so it doesn't get reused?
We have similar use-case in Cilium: iproute2 bails out if map properties
mismatch from the pinned map and the map in the object file. In some cases
like tail call maps where they can be fully reloaded and state wouldn't
need to be preserved across Cilium agents restarts, we simply move the
currently active and pinned tail call map to a temp location in the BPF fs
instance, reload the new program into the kernel and upon success just
delete the old tail call map so kernel can recycle its resources, but in
case the new program failed to load, we move the old map back to the old
location thus the data path is kept alive and can be re-upgraded at a later
point in time. Most of the map management in terms of cleanup or reuse is
handled by the Cilium agent; iproute2 is mostly acting dumb on purpose in
that it first probes whether the map name is present in BPF fs, if so, it
retrieves the fd and reuses it, and it not, it creates a new one and pins
it to the location.

> Hmm, but I guess it could do that anyway; so maybe what we need is just
> a "try to find all pinned maps of this program" function? That could
> then to something like:
> 
> - Get the maps IDs and names of all maps attached to that program from
>    the kernel.
> 
> - Look for each map name in /sys/fs/bpf
> 
> - If a pinned map with the same name exists, compare the IDs, and unlink
>    if they match
> 
> I don't suppose it'll be possible to do all that in a race-free manner,
> but that would go for any use of unlink() unless I'm missing something?
