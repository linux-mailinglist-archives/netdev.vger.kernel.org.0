Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2372A616C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 11:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgKDKWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 05:22:16 -0500
Received: from www62.your-server.de ([213.133.104.62]:52618 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbgKDKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 05:22:16 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kaFvM-0005pb-Nm; Wed, 04 Nov 2020 11:21:52 +0100
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kaFvM-000I5b-Bt; Wed, 04 Nov 2020 11:21:52 +0100
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
 <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
Date:   Wed, 4 Nov 2020 11:21:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25977/Tue Nov  3 14:18:27 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 4:11 AM, Alexei Starovoitov wrote:
> On Wed, Nov 04, 2020 at 10:17:30AM +0800, Hangbin Liu wrote:
>> On Tue, Nov 03, 2020 at 02:55:54PM -0800, Alexei Starovoitov wrote:
>>>> The scope of bpf in iproute2 is tiny - a few tc modules (and VRF but it
>>>> does not need libbpf) which is a small subset of the functionality and
>>>> commands within the package.
>>>
>>> When Hangbin sent this patch set I got excited that finally tc command
>>> will start working with the latest bpf elf files.
>>> Currently "tc" supports 4 year old files which caused plenty of pain to bpf users.
>>> I got excited, but now I've realized that this patch set will make it worse.
>>> The bpf support in "tc" command instead of being obviously old and obsolete
>>> will be sort-of working with unpredictable delay between released kernel
>>> and released iproute2 version. The iproute2 release that suppose to match kernel
>>> release will be meaningless.
>>> More so, the upgrade of shared libbpf.so can make older iproute2/tc to do
>>> something new and unpredictable.
>>> The user experience will be awful. Not only the users won't know
>>> what to expect out of 'tc' command they won't have a way to debug it.
>>> All of it because iproute2 build will take system libbpf and link it
>>> as shared library by default.
>>> So I think iproute2 must not use libbpf. If I could remove bpf support
>>> from iproute2 I would do so as well.
>>> The current state of iproute2 is hurting bpf ecosystem and proposed
>>> libbpf+iproute2 integration will make it worse.
>>
>> Please take it easy. IMHO, it always very hard to make a perfect solution.
>> From development side, it's easier and could get latest features by using
>> libbpf as submodule. But we need to take care of users, backward
>> compatibility, distros policy etc.
>>
>> I like using iproute2 to load bpf objs. But it's not standardized and too old
>> to load the new BTF defined objs. I think all of us like to improve it by
>> using libbpf. But users and distros are slowly. Some user are still using
>> `ifconfig`. Distros have policies to link the shared .so, etc. We have to
>> compromise on something.
>>
>> Our purpose is to push the user to use new features. As this patchset
>> does, push users to try libbpf instead of legacy code. But this need time.
> 
> My problem with iproute2 picking random libbpf is unpredictability.
> Such roll of dice gives no confidence to users on what is expected to work.
> bpf_hello_world.o will load, but that's it.
> What is going to work with this or that version of "tc" command? No one knows.
> The user will do 'tc -V'. Does version mean anything from bpf loading pov?
> It's not. The user will do "ldd `which tc`" and then what?
> Such bpf support in "tc" is worse than the current one.
> At least the current one is predictably old.

User experience will be crappy and predictability worse, agree on that. For libbpf
it's the same as with rest of iproute2 code in that features are developed along
with the kernel. Distros so far are more or less used to upgrade iproute2 along
with new kernel releases though it's not the first time that some major ones have
been shipping old iproute2 for several releases until we pinged them to finally
get their act together to upgrade. With libbpf dynamically linked it's one more
moving target and it's not clear whether distros will upgrade with same cadence
as iproute2 (or even add libbpf as dependency to their packaging). Only option
users might have if they were to rely on iproute2 and to have predictability is
to ship their stuff via container with current libbpf approach which is probably
not the goal of this set.

> There are alternatives though.
> Forking the whole iproute2 because of "tc" is pointless, of course.
> My 'proposal' was a fire starter because people are too stubborn to
> realize that their long term believes could be incorrect until the fire is burning.
> "bpftool prog load" can load any kind of elf. It cannot operate on qdiscs
> and shouldn't do qdisc manipulations, but may be we can combine them into pipe
> of some sort. Like "bpftool prog load file.o | tc filter ... bpf pipe"
> I think that would be better long term. It will be predictable.

We've been thinking about 'bpftool prog load' as well given we build it right of
the kernel tree and bpftool + libbpf are predictable since they are both built out
of the same git tree and with latest features. I don't think it needs to pipe, it
would be enough to just specify where the loaded progs should be pinned in bpf fs
and tc/ip(xdp) already has the option to pick fd of the entry point from pinned
file. But should be doable as well to just pass fd via pipe to avoid later potential
cleanup. Either way I think it makes sense to do 'bpftool prog load' regardless
since it's generic and useful also for other (non-networking) prog types that can
be attached elsewhere in the system.

> When we release new version of libbpf it goes through rigorous testing.
> bpftool gets a lot of test coverage as well.
> iproute2 with shared libbpf will get nothing. It's the same random roll of dice.
> New libbpf may or may not break iproute2. That's awful user experience.
> So iproute2 has to use git submodule with particular libbpf sha.

Alternatively, you have an uapi sync script already in order to not rely on the
distro system headers installed by the distro and to copy latest uapi ones from
kernel tree. Could as well be extended to have similar fixed built-in situation as
with the current lib/bpf.c in iproute2. Back in the days when developing lib/bpf.c,
it was explicitly done as built-in for iproute2 so that it doesn't take years for
users to actually get to the point where they can realistically make use of it. If
we were to extend the internal lib/bpf.c to similar feature state as libbpf today,
how is that different in the bigger picture compared to sync or submodule... so far
noone complained about lib/bpf.c.

> Then libbpf release process can incorporate proper testing of libbpf
> and iproute2 combination.
> Or iproute2 should stay as-is with obsolete bpf support.
> 
> Few years from now the situation could be different and shared libbpf would
> be the most appropriate choice. But that day is not today.

Yep, for libbpf to be in same situation as libelf or libmnl basically feature
development would have to pretty much come to a stop so that even minor or exotic
distros get to a point where they ship same libbpf version as major distros where
then users can start to rely on the base feature set for developing programs
against it.

Thanks,
Daniel
