Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0298FFF952
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 13:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfKQMHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 07:07:54 -0500
Received: from www62.your-server.de ([213.133.104.62]:54472 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfKQMHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 07:07:54 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWJLK-0000cq-B8; Sun, 17 Nov 2019 13:07:50 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWJLJ-0004Ft-Va; Sun, 17 Nov 2019 13:07:50 +0100
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net>
 <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
 <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net>
 <fe46c471-e345-b7e4-ab91-8ef044fd58ae@fb.com>
 <c79ca69f-84fd-bfc2-71fd-439bc3b94c81@iogearbox.net>
 <3eca5e22-f3ec-f05f-0776-4635b14c2a4e@fb.com>
 <CAEf4BzZHT=Gwor_VA38Yoy6Lo7zeeiVeQK+KQpZUHRpnV6=fuA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3a99d3af-97e7-3d6d-0a9c-46fb8104a211@iogearbox.net>
Date:   Sun, 17 Nov 2019 13:07:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZHT=Gwor_VA38Yoy6Lo7zeeiVeQK+KQpZUHRpnV6=fuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25636/Sun Nov 17 10:57:06 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/19 6:57 AM, Andrii Nakryiko wrote:
> On Fri, Nov 15, 2019 at 5:18 PM Alexei Starovoitov <ast@fb.com> wrote:
>> On 11/15/19 4:13 PM, Daniel Borkmann wrote:
>>>>> Yeah, only for fd array currently. Question is, if we ever reuse that
>>>>> map_release_uref
>>>>> callback in future for something else, will we remember that we earlier
>>>>> missed to add
>>>>> it here? :/
>>>>
>>>> What do you mean 'missed to add' ?
>>>
>>> Was saying missed to add the inc/put for the uref counter.
>>>
>>>> This is mmap path. Anything that needs releasing (like FDs for
>>>> prog_array or progs for sockmap) cannot be mmap-able.
>>>
>>> Right, I meant if in future we ever have another use case outside of it
>>> for some reason (unrelated to those maps you mention above). Can we
>>> guarantee this is never going to happen? Seemed less fragile at least to
>>> maintain proper count here.
> 
> I don't think we'll ever going to allow mmaping anything that contains
> not just pure data. E.g., we disallow mmaping array that contains spin
> lock for that reason. So I think it's safe to assume that this is not
> going to happen even for future maps. At least not without some
> serious considerations before that. So I'm going to keep it as just
> plain bpf_map_inc for now.

Fair enough, then keep it as it is. The purpose of the uref counter is to
track whatever map holds a reference either in form of fd or inode in bpf
fs which are the only two things till now where user space can refer to the
map, and once it hits 0, we perform the map's map_release_uref() callback.

The fact that some maps make use of it and some others not is an implementation
detail in my opinion, but the concept itself is generic and can be used by
whatever map implementation would need it in future. From my perspective not
breaking with this semantic would allow to worry about one less issue once
this callback gets reused for whatever reason.

As I understand, from your PoV, you think that this uref counter is and will
be exactly only tied to the fd based maps that currently use it and given
they understandably won't ever need a mmap interface we don't need to inc/dec
it there.

Fair enough, but could we add some assertion then which adds a check if a map
ever uses both that we bail out so we don't forget about this detail in a few
weeks from now? Given complexity we have in our BPF codebase these days, I'm
mainly worried about the latter if we can catch such details with a trivial
check easily, for example, it would be trivial enough to add a test for the
existence of map_release_uref callback inside bpf_map_mmap() and bail out in
order to guarantee this, similar as you do with the spinlock.

> I'm going to convert bpf_prog_add/bpf_prog_inc, though, and will do it
> as a separate patch, on top of bpf_map_inc refactor. It touches quite
> a lot drivers, so would benefit from having being separate.

Yeah, sounds good to me. Thanks for converting!

>> I'm struggling to understand the concern.
>> map-in-map, xskmap, socket local storage are doing bpf_map_inc(, false)
>> when they need to hold the map. Why this case is any different?

(See above.)
