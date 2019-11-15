Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A736DFE8CD
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfKOXov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:44:51 -0500
Received: from www62.your-server.de ([213.133.104.62]:58544 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfKOXov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:44:51 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVlGg-0004xi-FY; Sat, 16 Nov 2019 00:44:46 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVlGg-0007qB-4D; Sat, 16 Nov 2019 00:44:46 +0100
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
To:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
 <888858f7-97fb-4434-4440-a5c0ec5cbac8@iogearbox.net>
 <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3287b984-6335-cacb-da28-3d374afb7f77@iogearbox.net>
Date:   Sat, 16 Nov 2019 00:44:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <293bb2fe-7599-3825-1bfe-d52224e5c357@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/19 12:37 AM, Alexei Starovoitov wrote:
> On 11/15/19 3:31 PM, Daniel Borkmann wrote:
>> On 11/15/19 5:02 AM, Andrii Nakryiko wrote:
>>> Add ability to memory-map contents of BPF array map. This is extremely
>>> useful
>>> for working with BPF global data from userspace programs. It allows to
>>> avoid
>>> typical bpf_map_{lookup,update}_elem operations, improving both
>>> performance
>>> and usability.
>>>
>>> There had to be special considerations for map freezing, to avoid having
>>> writable memory view into a frozen map. To solve this issue, map
>>> freezing and
>>> mmap-ing is happening under mutex now:
>>>     - if map is already frozen, no writable mapping is allowed;
>>>     - if map has writable memory mappings active (accounted in
>>> map->writecnt),
>>>       map freezing will keep failing with -EBUSY;
>>>     - once number of writable memory mappings drops to zero, map
>>> freezing can be
>>>       performed again.
>>>
>>> Only non-per-CPU plain arrays are supported right now. Maps with
>>> spinlocks
>>> can't be memory mapped either.
>>>
>>> For BPF_F_MMAPABLE array, memory allocation has to be done through
>>> vmalloc()
>>> to be mmap()'able. We also need to make sure that array data memory is
>>> page-sized and page-aligned, so we over-allocate memory in such a way
>>> that
>>> struct bpf_array is at the end of a single page of memory with
>>> array->value
>>> being aligned with the start of the second page. On deallocation we
>>> need to
>>> accomodate this memory arrangement to free vmalloc()'ed memory correctly.
>>>
>>> One important consideration regarding how memory-mapping subsystem
>>> functions.
>>> Memory-mapping subsystem provides few optional callbacks, among them
>>> open()
>>> and close().  close() is called for each memory region that is
>>> unmapped, so
>>> that users can decrease their reference counters and free up
>>> resources, if
>>> necessary. open() is *almost* symmetrical: it's called for each memory
>>> region
>>> that is being mapped, **except** the very first one. So bpf_map_mmap does
>>> initial refcnt bump, while open() will do any extra ones after that. Thus
>>> number of close() calls is equal to number of open() calls plus one more.
>>>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Rik van Riel <riel@surriel.com>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> [...]
>>> +/* called for any extra memory-mapped regions (except initial) */
>>> +static void bpf_map_mmap_open(struct vm_area_struct *vma)
>>> +{
>>> +    struct bpf_map *map = vma->vm_file->private_data;
>>> +
>>> +    bpf_map_inc(map);
>>
>> This would also need to inc uref counter since it's technically a reference
>> of this map into user space as otherwise if map->ops->map_release_uref
>> would
>> be used for maps supporting mmap, then the callback would trigger even
>> if user
>> space still has a reference to it.
> 
> I thought we use uref only for array that can hold FDs ?
> That's why I suggested Andrii earlier to drop uref++.

Yeah, only for fd array currently. Question is, if we ever reuse that map_release_uref
callback in future for something else, will we remember that we earlier missed to add
it here? :/
