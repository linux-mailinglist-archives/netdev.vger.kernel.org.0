Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4000B132F85
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgAGTa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:30:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:47852 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbgAGTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 14:30:46 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iouYs-0007tt-62; Tue, 07 Jan 2020 20:30:42 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iouYr-000DeW-Nz; Tue, 07 Jan 2020 20:30:41 +0100
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>, bjorn.topel@intel.com
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp>
 <fab5466e-95e7-8abf-c416-6a6f7b7151ba@iogearbox.net>
 <20200107131554.GJ290055@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5a0fbe29-a9ec-a917-b52f-c81c96672ae8@iogearbox.net>
Date:   Tue, 7 Jan 2020 20:30:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200107131554.GJ290055@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25687/Tue Jan  7 10:56:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 2:15 PM, Jiri Olsa wrote:
> On Tue, Jan 07, 2020 at 09:30:12AM +0100, Daniel Borkmann wrote:
>> On 1/7/20 12:46 AM, Alexei Starovoitov wrote:
>>> On Sun, Dec 29, 2019 at 03:37:40PM +0100, Jiri Olsa wrote:
>>>> When unwinding the stack we need to identify each
>>>> address to successfully continue. Adding latch tree
>>>> to keep trampolines for quick lookup during the
>>>> unwind.
>>>>
>>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ...
>>>> +bool is_bpf_trampoline(void *addr)
>>>> +{
>>>> +	return latch_tree_find(addr, &tree, &tree_ops) != NULL;
>>>> +}
>>>> +
>>>>    struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>>>>    {
>>>>    	struct bpf_trampoline *tr;
>>>> @@ -65,6 +98,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>>>>    	for (i = 0; i < BPF_TRAMP_MAX; i++)
>>>>    		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
>>>>    	tr->image = image;
>>>> +	latch_tree_insert(&tr->tnode, &tree, &tree_ops);
>>>
>>> Thanks for the fix. I was thinking to apply it, but then realized that bpf
>>> dispatcher logic has the same issue.
>>> Could you generalize the fix for both?
>>> May be bpf_jit_alloc_exec_page() can do latch_tree_insert() ?
>>> and new version of bpf_jit_free_exec() is needed that will do latch_tree_erase().
>>> Wdyt?
>>
>> Also this patch is buggy since your latch lookup happens under RCU, but
>> I don't see anything that waits a grace period once you remove from the
>> tree. Instead you free the trampoline right away.
> 
> thanks, did not think of that.. will (try to) fix ;-)
> 
>> On a different question, given we have all the kallsym infrastructure
>> for BPF already in place, did you look into whether it's feasible to
>> make it a bit more generic to also cover JITed buffers from trampolines?
> 
> hum, it did not occur to me that we want to see it in kallsyms,
> but sure.. how about: bpf_trampoline_<key> ?
> 
> key would be taken from bpf_trampoline::key as function's BTF id

Yeap, I think bpf_trampoline_<btf_id> would make sense here.

Thanks,
Daniel
