Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E96562588
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiF3VrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiF3VrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:47:08 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDBB53EDD;
        Thu, 30 Jun 2022 14:47:08 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7205-00061y-QU; Thu, 30 Jun 2022 23:47:01 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o7205-000743-FL; Thu, 30 Jun 2022 23:47:01 +0200
Subject: Re: [PATCH bpf-next 1/4] bpf: Make non-preallocated allocation low
 priority
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, quentin@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>
References: <20220629154832.56986-1-laoar.shao@gmail.com>
 <20220629154832.56986-2-laoar.shao@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ede2c8ea-693d-fe70-12a2-bf8ccca97eb0@iogearbox.net>
Date:   Thu, 30 Jun 2022 23:47:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220629154832.56986-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26589/Thu Jun 30 10:08:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yafang,

On 6/29/22 5:48 PM, Yafang Shao wrote:
> GFP_ATOMIC doesn't cooperate well with memcg pressure so far, especially
> if we allocate too much GFP_ATOMIC memory. For example, when we set the
> memcg limit to limit a non-preallocated bpf memory, the GFP_ATOMIC can
> easily break the memcg limit by force charge. So it is very dangerous to
> use GFP_ATOMIC in non-preallocated case. One way to make it safe is to
> remove __GFP_HIGH from GFP_ATOMIC, IOW, use (__GFP_ATOMIC |
> __GFP_KSWAPD_RECLAIM) instead, then it will be limited if we allocate
> too much memory.
> 
> We introduced BPF_F_NO_PREALLOC is because full map pre-allocation is
> too memory expensive for some cases. That means removing __GFP_HIGH
> doesn't break the rule of BPF_F_NO_PREALLOC, but has the same goal with
> it-avoiding issues caused by too much memory. So let's remove it.
> 
> __GFP_KSWAPD_RECLAIM doesn't cooperate well with memcg pressure neither
> currently. But the memcg code can be improved to make
> __GFP_KSWAPD_RECLAIM work well under memcg pressure.

Ok, but could you also explain in commit desc why it's a specific problem
to BPF hashtab?

Afaik, there is plenty of other code using GFP_ATOMIC | __GFP_NOWARN outside
of BPF e.g. under net/, so it's a generic memcg problem?

Why are lpm trie and local storage map for BPF not affected (at least I don't
see them covered in the patch)?

Thanks,
Daniel

> It also fixes a typo in the comment.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>   kernel/bpf/hashtab.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 17fb69c0e0dc..9d4559a1c032 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -61,7 +61,7 @@
>    *
>    * As regular device interrupt handlers and soft interrupts are forced into
>    * thread context, the existing code which does
> - *   spin_lock*(); alloc(GPF_ATOMIC); spin_unlock*();
> + *   spin_lock*(); alloc(GFP_ATOMIC); spin_unlock*();
>    * just works.
>    *
>    * In theory the BPF locks could be converted to regular spinlocks as well,
> @@ -978,7 +978,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
>   				goto dec_count;
>   			}
>   		l_new = bpf_map_kmalloc_node(&htab->map, htab->elem_size,
> -					     GFP_ATOMIC | __GFP_NOWARN,
> +					     __GFP_ATOMIC | __GFP_NOWARN |
> +					     __GFP_KSWAPD_RECLAIM,
>   					     htab->map.numa_node);
>   		if (!l_new) {
>   			l_new = ERR_PTR(-ENOMEM);
> @@ -996,7 +997,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
>   		} else {
>   			/* alloc_percpu zero-fills */
>   			pptr = bpf_map_alloc_percpu(&htab->map, size, 8,
> -						    GFP_ATOMIC | __GFP_NOWARN);
> +						    __GFP_ATOMIC | __GFP_NOWARN |
> +						    __GFP_KSWAPD_RECLAIM);
>   			if (!pptr) {
>   				kfree(l_new);
>   				l_new = ERR_PTR(-ENOMEM);
> 

