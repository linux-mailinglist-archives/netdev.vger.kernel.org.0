Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD04B2807
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 15:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350924AbiBKOfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 09:35:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239104AbiBKOfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 09:35:38 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1177188;
        Fri, 11 Feb 2022 06:35:36 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIX1H-0005ZS-U3; Fri, 11 Feb 2022 15:35:31 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIX1H-0003vn-Ip; Fri, 11 Feb 2022 15:35:31 +0100
Subject: Re: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@suse.com>
References: <20220210064108.1095847-1-song@kernel.org>
 <20220210064108.1095847-3-song@kernel.org>
 <34d0ed40-30cf-a1a2-f4eb-fa3d0a55bce8@iogearbox.net>
 <A3FB68F3-34DC-4598-8C6B-145421DCE73E@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dd6dee71-94d7-5393-8fe6-c667938ebfac@iogearbox.net>
Date:   Fri, 11 Feb 2022 15:35:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <A3FB68F3-34DC-4598-8C6B-145421DCE73E@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26450/Fri Feb 11 10:24:09 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 5:51 PM, Song Liu wrote:
>> On Feb 10, 2022, at 12:25 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 2/10/22 7:41 AM, Song Liu wrote:
>>> bpf_prog_pack uses huge pages to reduce pressue on instruction TLB.
>>> To guarantee allocating huge pages for bpf_prog_pack, it is necessary to
>>> allocate memory of size PMD_SIZE * num_online_nodes().
>>> On the other hand, if the system doesn't support huge pages, it is more
>>> efficient to allocate PAGE_SIZE bpf_prog_pack.
>>> Address different scenarios with more flexible bpf_prog_pack_size().
>>> Signed-off-by: Song Liu <song@kernel.org>
>>> ---
>>>   kernel/bpf/core.c | 47 +++++++++++++++++++++++++++--------------------
>>>   1 file changed, 27 insertions(+), 20 deletions(-)
>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>> index 42d96549a804..d961a1f07a13 100644
>>> --- a/kernel/bpf/core.c
>>> +++ b/kernel/bpf/core.c
>>> @@ -814,46 +814,53 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>>>    * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>>>    * to host BPF programs.
>>>    */
>>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> -#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
>>> -#else
>>> -#define BPF_PROG_PACK_SIZE	PAGE_SIZE
>>> -#endif
>>>   #define BPF_PROG_CHUNK_SHIFT	6
>>>   #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>>>   #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
>>> -#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
>>>     struct bpf_prog_pack {
>>>   	struct list_head list;
>>>   	void *ptr;
>>> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>>> +	unsigned long bitmap[];
>>>   };
>>>   -#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
>>>   #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
>>>     static DEFINE_MUTEX(pack_mutex);
>>>   static LIST_HEAD(pack_list);
>>>   +static inline int bpf_prog_pack_size(void)
>>> +{
>>> +	/* If vmap_allow_huge == true, use pack size of the smallest
>>> +	 * possible vmalloc huge page: PMD_SIZE * num_online_nodes().
>>> +	 * Otherwise, use pack size of PAGE_SIZE.
>>> +	 */
>>> +	return get_vmap_allow_huge() ? PMD_SIZE * num_online_nodes() : PAGE_SIZE;
>>> +}
>>
>> Imho, this is making too many assumptions about implementation details. Can't we
>> just add a new module_alloc*() API instead which internally guarantees allocating
>> huge pages when enabled/supported (e.g. with a __weak function as fallback)?
> 
> I agree that this is making too many assumptions. But a new module_alloc_huge()
> may not work, because we need the caller to know the proper size to ask for.
> (Or maybe I misunderstood your suggestion?)
> 
> How about we introduce something like
> 
>      /* minimal size to get huge pages from vmalloc. If not possible,
>       * return 0 (or -1?)
>       */
>      int vmalloc_hpage_min_size(void)
>      {
>          return vmap_allow_huge ? PMD_SIZE * num_online_nodes() : 0;
>      }

And that would live inside mm/vmalloc.c and is exported to users ...

>      /* minimal size to get huge pages from module_alloc */
>      int module_alloc_hpage_min_size(void)
>      {
>          return vmalloc_hpage_min_size();
>      }

... and this one as wrapper in module alloc infra with __weak attr?

>      static inline int bpf_prog_pack_size(void)
>      {
>          return module_alloc_hpage_min_size() ? : PAGE_SIZE;
>      }

Could probably work. It's not nice, but at least in the corresponding places so it's
not exposed / hard coded inside bpf and assuming implementation details which could
potentially break later on.

Thanks,
Daniel
