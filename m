Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4AE646A35
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLHINw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiLHINp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:13:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE20B1F;
        Thu,  8 Dec 2022 00:13:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5971A33697;
        Thu,  8 Dec 2022 08:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670487222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jL4y5FJYbDHm9XGKTrDmZ6J5zAhRaZRJLpsFAXD4/0o=;
        b=bUmI0w3LiRlTcWoMMsF7HYKbPvEOxVnb/AfLz53RFL8tnZy/0vujoh8ukqEXQcwRpYPmbc
        /VFErUGzHPbzt3R6Zbs5PnXdb9qeh+kbcoJMHj7PCiTtgEmhq4qLWmhc3ilNKMRFF8bPf6
        oX45AMzM5tF0aP4WF7jcEd34tw2+ctw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670487222;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jL4y5FJYbDHm9XGKTrDmZ6J5zAhRaZRJLpsFAXD4/0o=;
        b=CE+RarLm/bXrKJ8p4njmXUm5YCYVHkyy0c4d8Pu/EfDrnoSBRnq823VqlWiVYbr3DJyaRh
        cz+2/WxKhqY8SGBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D55BD138E0;
        Thu,  8 Dec 2022 08:13:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NGJkM7WckWPMHQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 08 Dec 2022 08:13:41 +0000
Message-ID: <6923d6a9-7728-fc71-f963-3617e5361732@suse.cz>
Date:   Thu, 8 Dec 2022 09:13:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v3] skbuff: Introduce slab_build_skb()
To:     Kees Cook <keescook@chromium.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        pepsipu <soopthegoop@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, martin.lau@linux.dev,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Rasesh Mody <rmody@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Richard Gobert <richardbgobert@gmail.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        David Rientjes <rientjes@google.com>,
        GR-Linux-NIC-Dev@marvell.com, linux-hardening@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
References: <20221208060256.give.994-kees@kernel.org>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20221208060256.give.994-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 07:02, Kees Cook wrote:
> syzkaller reported:
> 
>   BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
>   Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295
> 
> For bpf_prog_test_run_skb(), which uses a kmalloc()ed buffer passed to
> build_skb().
> 
> When build_skb() is passed a frag_size of 0, it means the buffer came
> from kmalloc. In these cases, ksize() is used to find its actual size,
> but since the allocation may not have been made to that size, actually
> perform the krealloc() call so that all the associated buffer size
> checking will be correctly notified (and use the "new" pointer so that
> compiler hinting works correctly). Split this logic out into a new
> interface, slab_build_skb(), but leave the original 0 checking for now
> to catch any stragglers.
> 
> Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> Link: https://groups.google.com/g/syzkaller-bugs/c/UnIKxTtU5-0/m/-wbXinkgAQAJ
> Fixes: 38931d8989b5 ("mm: Make ksize() a reporting-only function")
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: pepsipu <soopthegoop@gmail.com>
> Cc: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: kasan-dev <kasan-dev@googlegroups.com>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: ast@kernel.org
> Cc: bpf <bpf@vger.kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: jolsa@kernel.org
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: martin.lau@linux.dev
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: song@kernel.org
> Cc: Yonghong Song <yhs@fb.com>
> Cc: netdev@vger.kernel.org
> Cc: LKML <linux-kernel@vger.kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
> - make sure "resized" is passed back so compiler hints survive
> - update kerndoc (kuba)
> v2: https://lore.kernel.org/lkml/20221208000209.gonna.368-kees@kernel.org
> v1: https://lore.kernel.org/netdev/20221206231659.never.929-kees@kernel.org/
> ---
>  drivers/net/ethernet/broadcom/bnx2.c      |  2 +-
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c |  2 +-
>  include/linux/skbuff.h                    |  1 +
>  net/bpf/test_run.c                        |  2 +-
>  net/core/skbuff.c                         | 70 ++++++++++++++++++++---
>  5 files changed, 66 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index fec57f1982c8..b2230a4a2086 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -3045,7 +3045,7 @@ bnx2_rx_skb(struct bnx2 *bp, struct bnx2_rx_ring_info *rxr, u8 *data,
>  
>  	dma_unmap_single(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
>  			 DMA_FROM_DEVICE);
> -	skb = build_skb(data, 0);
> +	skb = slab_build_skb(data);
>  	if (!skb) {
>  		kfree(data);
>  		goto error;
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> index ed274f033626..e5116a86cfbc 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> @@ -200,7 +200,7 @@ static void qed_ll2b_complete_rx_packet(void *cxt,
>  	dma_unmap_single(&cdev->pdev->dev, buffer->phys_addr,
>  			 cdev->ll2->rx_size, DMA_FROM_DEVICE);
>  
> -	skb = build_skb(buffer->data, 0);
> +	skb = slab_build_skb(buffer->data);
>  	if (!skb) {
>  		DP_INFO(cdev, "Failed to build SKB\n");
>  		kfree(buffer->data);
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7be5bb4c94b6..0b391b635430 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1253,6 +1253,7 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
>  void skb_attempt_defer_free(struct sk_buff *skb);
>  
>  struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
> +struct sk_buff *slab_build_skb(void *data);
>  
>  /**
>   * alloc_skb - allocate a network buffer
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..611b1f4082cf 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -1130,7 +1130,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	}
>  	sock_init_data(NULL, sk);
>  
> -	skb = build_skb(data, 0);
> +	skb = slab_build_skb(data);
>  	if (!skb) {
>  		kfree(data);
>  		kfree(ctx);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1d9719e72f9d..ae5a6f7db37b 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -269,12 +269,10 @@ static struct sk_buff *napi_skb_cache_get(void)
>  	return skb;
>  }
>  
> -/* Caller must provide SKB that is memset cleared */
> -static void __build_skb_around(struct sk_buff *skb, void *data,
> -			       unsigned int frag_size)
> +static inline void __finalize_skb_around(struct sk_buff *skb, void *data,
> +					 unsigned int size)
>  {
>  	struct skb_shared_info *shinfo;
> -	unsigned int size = frag_size ? : ksize(data);
>  
>  	size -= SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  
> @@ -296,15 +294,71 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
>  	skb_set_kcov_handle(skb, kcov_common_handle());
>  }
>  
> +static inline void *__slab_build_skb(struct sk_buff *skb, void *data,
> +				     unsigned int *size)
> +{
> +	void *resized;
> +
> +	/* Must find the allocation size (and grow it to match). */
> +	*size = ksize(data);
> +	/* krealloc() will immediately return "data" when
> +	 * "ksize(data)" is requested: it is the existing upper
> +	 * bounds. As a result, GFP_ATOMIC will be ignored. Note
> +	 * that this "new" pointer needs to be passed back to the
> +	 * caller for use so the __alloc_size hinting will be
> +	 * tracked correctly.
> +	 */
> +	resized = krealloc(data, *size, GFP_ATOMIC);

Hmm, I just realized, this trick will probably break the new kmalloc size
tracking from Feng Tang (CC'd)? We need to make krealloc() update the stored
size, right? And even worse if slab_debug redzoning is enabled and after
commit 946fa0dbf2d8 ("mm/slub: extend redzone check to extra allocated
kmalloc space than requested") where the lack of update will result in
redzone check failures.

> +	WARN_ON_ONCE(resized != data);
> +	return resized;
> +}
> +
> +/* build_skb() variant which can operate on slab buffers.
> + * Note that this should be used sparingly as slab buffers
> + * cannot be combined efficiently by GRO!
> + */
> +struct sk_buff *slab_build_skb(void *data)
> +{
> +	struct sk_buff *skb;
> +	unsigned int size;
> +
> +	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	memset(skb, 0, offsetof(struct sk_buff, tail));
> +	data = __slab_build_skb(skb, data, &size);
> +	__finalize_skb_around(skb, data, size);
> +
> +	return skb;
> +}
> +EXPORT_SYMBOL(slab_build_skb);
> +
> +/* Caller must provide SKB that is memset cleared */
> +static void __build_skb_around(struct sk_buff *skb, void *data,
> +			       unsigned int frag_size)
> +{
> +	unsigned int size = frag_size;
> +
> +	/* frag_size == 0 is considered deprecated now. Callers
> +	 * using slab buffer should use slab_build_skb() instead.
> +	 */
> +	if (WARN_ONCE(size == 0, "Use slab_build_skb() instead"))
> +		data = __slab_build_skb(skb, data, &size);
> +	__finalize_skb_around(skb, data, size);
> +}
> +
>  /**
>   * __build_skb - build a network buffer
>   * @data: data buffer provided by caller
> - * @frag_size: size of data, or 0 if head was kmalloced
> + * @frag_size: size of data (must not be 0)
>   *
>   * Allocate a new &sk_buff. Caller provides space holding head and
> - * skb_shared_info. @data must have been allocated by kmalloc() only if
> - * @frag_size is 0, otherwise data should come from the page allocator
> - *  or vmalloc()
> + * skb_shared_info. @data must have been allocated from the page
> + * allocator or vmalloc(). (A @frag_size of 0 to indicate a kmalloc()
> + * allocation is deprecated, and callers should use slab_build_skb()
> + * instead.)
>   * The return is the new skb buffer.
>   * On a failure the return is %NULL, and @data is not freed.
>   * Notes :

