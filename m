Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90ACD1006C7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKRNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:50:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:34948 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfKRNuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 08:50:23 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWhQ3-00021M-4I; Mon, 18 Nov 2019 14:50:19 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWhQ2-000OGJ-G8; Mon, 18 Nov 2019 14:50:18 +0100
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
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
 <3a99d3af-97e7-3d6d-0a9c-46fb8104a211@iogearbox.net>
 <CAEf4BzbyHn5JOf6=S6g=Qr15evEbwmMO3F4QCC9hkU0hpJcA4g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6cb3f3f4-cc08-8280-8d72-f2fdc58ad034@iogearbox.net>
Date:   Mon, 18 Nov 2019 14:50:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbyHn5JOf6=S6g=Qr15evEbwmMO3F4QCC9hkU0hpJcA4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/19 6:17 PM, Andrii Nakryiko wrote:
> On Sun, Nov 17, 2019 at 4:07 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 11/17/19 6:57 AM, Andrii Nakryiko wrote:
>>> On Fri, Nov 15, 2019 at 5:18 PM Alexei Starovoitov <ast@fb.com> wrote:
>>>> On 11/15/19 4:13 PM, Daniel Borkmann wrote:
>>>>>>> Yeah, only for fd array currently. Question is, if we ever reuse that
>>>>>>> map_release_uref
>>>>>>> callback in future for something else, will we remember that we earlier
>>>>>>> missed to add
>>>>>>> it here? :/
>>>>>>
>>>>>> What do you mean 'missed to add' ?
>>>>>
>>>>> Was saying missed to add the inc/put for the uref counter.
>>>>>
>>>>>> This is mmap path. Anything that needs releasing (like FDs for
>>>>>> prog_array or progs for sockmap) cannot be mmap-able.
>>>>>
>>>>> Right, I meant if in future we ever have another use case outside of it
>>>>> for some reason (unrelated to those maps you mention above). Can we
>>>>> guarantee this is never going to happen? Seemed less fragile at least to
>>>>> maintain proper count here.
>>>
>>> I don't think we'll ever going to allow mmaping anything that contains
>>> not just pure data. E.g., we disallow mmaping array that contains spin
>>> lock for that reason. So I think it's safe to assume that this is not
>>> going to happen even for future maps. At least not without some
>>> serious considerations before that. So I'm going to keep it as just
>>> plain bpf_map_inc for now.
>>
>> Fair enough, then keep it as it is. The purpose of the uref counter is to
>> track whatever map holds a reference either in form of fd or inode in bpf
>> fs which are the only two things till now where user space can refer to the
>> map, and once it hits 0, we perform the map's map_release_uref() callback.
> 
> To be honest, I don't exactly understand why we need both refcnt and
> usercnt. Does it have anything to do with some circular dependencies
> for those maps containing other FDs? And once userspace doesn't have
> any more referenced, we release FDs, which might decrement refcnt,
> thus breaking circular refcnt between map FD and special FDs inside a
> map? Or that's not the case and there is a different reason?

Yes, back then we added it to break up circular dependencies in relation to
tail calls which is why these are pinned before the loader process finishes
(e.g. as in Cilium's case).

> Either way, I looked at map creation and bpf_map_release()
> implementation again. map_create() does set usercnt to 1, and
> bpf_map_release(), which I assume is called when map FD is closed,
> does decrement usercnt, so yeah, we do with_uref() manipulations for
> cases when userspace maintains some sort of handle to map. In that
> regard, mmap() does fall into the same category, so I'm going to
> convert everything mmap-related back to
> bpf_map_inc_with_uref()/bpf_map_put_with_uref(), to stay consistent.

Ok, fair enough, either way would have been fine.

Thanks a lot,
Daniel
