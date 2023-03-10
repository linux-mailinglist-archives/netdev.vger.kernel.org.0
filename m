Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2248F6B3C31
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjCJKc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCJKcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:32:19 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41169111B05;
        Fri, 10 Mar 2023 02:32:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C680520654;
        Fri, 10 Mar 2023 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678444334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKAQjtPeEdruvdiu+k5gGLS8R7rVo9ZpEqr34/mOg1w=;
        b=jM/aSqo5eeEsG1bbB+HEHDUxiDbo5qCgxkS1lMdG/LTijo7v609GwIH6wOGPK5ENW25w5B
        aLm6T/mGGqOwcuE9DxA+GKqD2ccwar2W9/NBSOeEe5sv4m5mnrq+A1XLnPFkk6V8+rT26N
        0xdaTOXfF4GxqANU4uwlYiu8VUgjyOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678444334;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKAQjtPeEdruvdiu+k5gGLS8R7rVo9ZpEqr34/mOg1w=;
        b=ZxQ4ujXvWDQr+knM1ffeWycdMvA+7Hpc5bwayOqfox5fa6vKydvQWhBrjfL8vVJIsvKsYZ
        ruYlhz5R2udyovCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89A8813592;
        Fri, 10 Mar 2023 10:32:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UIQAIS4HC2SsXQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Mar 2023 10:32:14 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 2/7] net: skbuff: remove SLOB-specific ifdefs
Date:   Fri, 10 Mar 2023 11:32:04 +0100
Message-Id: <20230310103210.22372-3-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the comment for HAVE_SKB_SMALL_HEAD_CACHE says:

> skb_small_head_cache and related code is only supported
> for CONFIG_SLAB and CONFIG_SLUB.
> As soon as SLOB is removed from the kernel, we can clean up this.

With CONFIG_SLOB removed, remove HAVE_SKB_SMALL_HEAD_CACHE and make all
code that it guards unconditional.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/core/skbuff.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index eb7d33b41e71..8bba4e91d0d5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -90,15 +90,6 @@ static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
 static struct kmem_cache *skbuff_ext_cache __ro_after_init;
 #endif
 
-/* skb_small_head_cache and related code is only supported
- * for CONFIG_SLAB and CONFIG_SLUB.
- * As soon as SLOB is removed from the kernel, we can clean up this.
- */
-#if !defined(CONFIG_SLOB)
-# define HAVE_SKB_SMALL_HEAD_CACHE 1
-#endif
-
-#ifdef HAVE_SKB_SMALL_HEAD_CACHE
 static struct kmem_cache *skb_small_head_cache __ro_after_init;
 
 #define SKB_SMALL_HEAD_SIZE SKB_HEAD_ALIGN(MAX_TCP_HEADER)
@@ -115,7 +106,6 @@ static struct kmem_cache *skb_small_head_cache __ro_after_init;
 
 #define SKB_SMALL_HEAD_HEADROOM						\
 	SKB_WITH_OVERHEAD(SKB_SMALL_HEAD_CACHE_SIZE)
-#endif /* HAVE_SKB_SMALL_HEAD_CACHE */
 
 int sysctl_max_skb_frags __read_mostly = MAX_SKB_FRAGS;
 EXPORT_SYMBOL(sysctl_max_skb_frags);
@@ -514,7 +504,6 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 	void *obj;
 
 	obj_size = SKB_HEAD_ALIGN(*size);
-#ifdef HAVE_SKB_SMALL_HEAD_CACHE
 	if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
 	    !(flags & KMALLOC_NOT_NORMAL_BITS)) {
 
@@ -530,7 +519,6 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
 			goto out;
 		}
 	}
-#endif
 	*size = obj_size = kmalloc_size_roundup(obj_size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
@@ -852,11 +840,9 @@ static bool skb_pp_recycle(struct sk_buff *skb, void *data)
 
 static void skb_kfree_head(void *head, unsigned int end_offset)
 {
-#ifdef HAVE_SKB_SMALL_HEAD_CACHE
 	if (end_offset == SKB_SMALL_HEAD_HEADROOM)
 		kmem_cache_free(skb_small_head_cache, head);
 	else
-#endif
 		kfree(head);
 }
 
@@ -4692,7 +4678,6 @@ void __init skb_init(void)
 						0,
 						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 						NULL);
-#ifdef HAVE_SKB_SMALL_HEAD_CACHE
 	/* usercopy should only access first SKB_SMALL_HEAD_HEADROOM bytes.
 	 * struct skb_shared_info is located at the end of skb->head,
 	 * and should not be copied to/from user.
@@ -4704,7 +4689,6 @@ void __init skb_init(void)
 						0,
 						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
-#endif
 	skb_extensions_init();
 }
 
-- 
2.39.2

