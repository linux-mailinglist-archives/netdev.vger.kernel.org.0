Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1919F13279F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgAGNap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:30:45 -0500
Received: from mga18.intel.com ([134.134.136.126]:5777 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgAGNap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 08:30:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 05:30:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="222577449"
Received: from mjaganna-mobl1.amr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.36.63])
  by orsmga006.jf.intel.com with ESMTP; 07 Jan 2020 05:30:36 -0800
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
To:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp> <20200107130546.GI290055@krava>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <76a10338-391a-ffca-9af8-f407265d146a@intel.com>
Date:   Tue, 7 Jan 2020 14:30:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107130546.GI290055@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-07 14:05, Jiri Olsa wrote:
> On Mon, Jan 06, 2020 at 03:46:40PM -0800, Alexei Starovoitov wrote:
>> On Sun, Dec 29, 2019 at 03:37:40PM +0100, Jiri Olsa wrote:
>>> When unwinding the stack we need to identify each
>>> address to successfully continue. Adding latch tree
>>> to keep trampolines for quick lookup during the
>>> unwind.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> ...
>>> +bool is_bpf_trampoline(void *addr)
>>> +{
>>> +	return latch_tree_find(addr, &tree, &tree_ops) != NULL;
>>> +}
>>> +
>>>   struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>>>   {
>>>   	struct bpf_trampoline *tr;
>>> @@ -65,6 +98,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>>>   	for (i = 0; i < BPF_TRAMP_MAX; i++)
>>>   		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
>>>   	tr->image = image;
>>> +	latch_tree_insert(&tr->tnode, &tree, &tree_ops);
>>
>> Thanks for the fix. I was thinking to apply it, but then realized that bpf
>> dispatcher logic has the same issue.
>> Could you generalize the fix for both?
>> May be bpf_jit_alloc_exec_page() can do latch_tree_insert() ?
>> and new version of bpf_jit_free_exec() is needed that will do latch_tree_erase().
>> Wdyt?
> 
> I need to check the dispatcher code, but seems ok.. will check
>

Thanks Jiri! The trampoline and dispatcher share the image allocation, 
so putting it there would make sense.

It's annoying that the dispatcher doesn't show up correctly in perf, and 
it's been on my list to fix that. Hopefully you beat me to it! :-D


Björn
