Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421CB1A8B51
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504949AbgDNToJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:44:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:51170 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440638AbgDNToE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:44:04 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORTV-0002Nv-5Z; Tue, 14 Apr 2020 21:44:01 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORTU-0005al-RS; Tue, 14 Apr 2020 21:44:00 +0200
Subject: Re: [PATCH v2 bpf 1/2] bpf: prevent re-mmap()'ing BPF map as writable
 for initially r/o mapping
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jann Horn <jannh@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200410202613.3679837-1-andriin@fb.com>
 <CAG48ez1xuZyOLVkxsjburqjf3Tm4TR8X6pnavUf=pm_woAxLkw@mail.gmail.com>
 <CAEf4Bza2=_OM_yxu3FAyf=mRoDmQC6KmFQ-5qKu0bxxX0PkzgQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <900084f0-e435-b2e5-6ef1-06db90ceac94@iogearbox.net>
Date:   Tue, 14 Apr 2020 21:44:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza2=_OM_yxu3FAyf=mRoDmQC6KmFQ-5qKu0bxxX0PkzgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 8:28 PM, Andrii Nakryiko wrote:
> On Tue, Apr 14, 2020 at 9:58 AM Jann Horn <jannh@google.com> wrote:
>> On Fri, Apr 10, 2020 at 10:26 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>> VM_MAYWRITE flag during initial memory mapping determines if already mmap()'ed
>>> pages can be later remapped as writable ones through mprotect() call. To
>>> prevent user application to rewrite contents of memory-mapped as read-only and
>>> subsequently frozen BPF map, remove VM_MAYWRITE flag completely on initially
>>> read-only mapping.
>>>
>>> Alternatively, we could treat any memory-mapping on unfrozen map as writable
>>> and bump writecnt instead. But there is little legitimate reason to map
>>> BPF map as read-only and then re-mmap() it as writable through mprotect(),
>>> instead of just mmap()'ing it as read/write from the very beginning.
>>>
>>> Also, at the suggestion of Jann Horn, drop unnecessary refcounting in mmap
>>> operations. We can just rely on VMA holding reference to BPF map's file
>>> properly.
>>>
>>> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
>>> Reported-by: Jann Horn <jannh@google.com>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Reviewed-by: Jann Horn <jannh@google.com>
>>
>> (in the sense that I think this patch is good and correct, but does
>> not fix the entire problem in the bigger picture)
> 
> I agree, we'll continue discussion on the other thread, but this
> should be applied as a bug fix anyways.

Applied, thanks!
