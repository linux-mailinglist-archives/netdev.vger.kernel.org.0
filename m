Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507B7688C5C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 02:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjBCBQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 20:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBCBQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 20:16:21 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5656D5E5;
        Thu,  2 Feb 2023 17:16:20 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id z5so4068819qtn.8;
        Thu, 02 Feb 2023 17:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nFAnq6N6CAX1RafppIK7r9HHDISJYsdHFwwQTcNSrdI=;
        b=pcIFoSMf9+LSDj5O5Sb+BS4H+u35pMw3rEK0hZntyx2tPZw58sbRhZXxQf0kiUHbaj
         cXj/4P2ct8+87bhU+3seaoEIG1M2k0zZgMMKfk1bgfSUhXxx9dT7UeTbCc+mwFtlYxL1
         sl37Yz7/WCeaw61hwaIs0oX5FtV0cXZ9p3MlQBOuvORIhY30b7l387fchn0NBFscKgf+
         eG6N9IdSppgjfMEGkKXZRlK4Wyzt/u1iu7EroidhuAw+jM5UmoGk4bi0+teeuBa1JsA/
         TJ31xsYZTdBahHi51YzWr1uYvmhY1kEJrfdAwuS1aGSJk+aZ4Wkeh5tBLHPajhWTRHYu
         uvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nFAnq6N6CAX1RafppIK7r9HHDISJYsdHFwwQTcNSrdI=;
        b=vf0Z4XSd8pwv2H2jr7gFOD7xWgwp6yicGsgZcb4e6d6KIVFePPGc5/Je/0mTvLf1Bt
         4CrJg7mqbFOh0+D9yUOkDnLCjZKslt3ctnGKr9bUxBU9OwKOEa9gGSK6+Ba0mME8LlFm
         9wx8CZn+T3Nw7eTWWd30mc+2la3XQnCdT7ih7raXIaGodo1knHthtBI3e9XbfRuzmerr
         4UeP1vj/sQ0VWZ6eJX9sztUVx632CBurJ3Mxwp8x9rvjsnWbW4WPi8shciXzUfKObIFz
         jkkifSgmG5sPDPybXh7d3Su9rH9xGTYQyXk7U3423RMQXiURpPGH2x40UUv5vIPOh8SO
         XVxw==
X-Gm-Message-State: AO0yUKXdp/HMsDEZScOzGZDsn1cPFIDoxh8c5KHVhFznri5kU5VQMq/l
        0c5hstXnZT1agvoXm15BHvM=
X-Google-Smtp-Source: AK7set+cmjA2PEtlPSvWMDr4Ub8OIy3gZrZ5NVK9qDT0rUcOIVtroxxiz7EM4V5SwXm2HosbbUAyZg==
X-Received: by 2002:a05:622a:134c:b0:3b8:283f:8a64 with SMTP id w12-20020a05622a134c00b003b8283f8a64mr15889990qtk.16.1675386979428;
        Thu, 02 Feb 2023 17:16:19 -0800 (PST)
Received: from localhost.localdomain ([2001:470:f2c0:1000::53])
        by smtp.gmail.com with ESMTPSA id s20-20020a05622a019400b003b860983973sm650546qtw.60.2023.02.02.17.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 17:16:18 -0800 (PST)
From:   Qingfang DENG <dqfext@gmail.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next v2] net: page_pool: use in_softirq() instead
Date:   Fri,  3 Feb 2023 09:16:11 +0800
Message-Id: <20230203011612.194701-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qingfang DENG <qingfang.deng@siflower.com.cn>

We use BH context only for synchronization, so we don't care if it's
actually serving softirq or not.

As a side node, in case of threaded NAPI, in_serving_softirq() will
return false because it's in process context with BH off, making
page_pool_recycle_in_cache() unreachable.

Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
---
v1 -> v2: 
Drop the Fixes tags and repost against net-next.

 include/net/page_pool.h | 4 ++--
 net/core/page_pool.c    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..34bf531ffc8d 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -386,7 +386,7 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 static inline void page_pool_ring_lock(struct page_pool *pool)
 	__acquires(&pool->ring.producer_lock)
 {
-	if (in_serving_softirq())
+	if (in_softirq())
 		spin_lock(&pool->ring.producer_lock);
 	else
 		spin_lock_bh(&pool->ring.producer_lock);
@@ -395,7 +395,7 @@ static inline void page_pool_ring_lock(struct page_pool *pool)
 static inline void page_pool_ring_unlock(struct page_pool *pool)
 	__releases(&pool->ring.producer_lock)
 {
-	if (in_serving_softirq())
+	if (in_softirq())
 		spin_unlock(&pool->ring.producer_lock);
 	else
 		spin_unlock_bh(&pool->ring.producer_lock);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b203d8660e4..193c18799865 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -511,8 +511,8 @@ static void page_pool_return_page(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 {
 	int ret;
-	/* BH protection not needed if current is serving softirq */
-	if (in_serving_softirq())
+	/* BH protection not needed if current is softirq */
+	if (in_softirq())
 		ret = ptr_ring_produce(&pool->ring, page);
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
@@ -570,7 +570,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 			page_pool_dma_sync_for_device(pool, page,
 						      dma_sync_size);
 
-		if (allow_direct && in_serving_softirq() &&
+		if (allow_direct && in_softirq() &&
 		    page_pool_recycle_in_cache(page, pool))
 			return NULL;
 
-- 
2.34.1

