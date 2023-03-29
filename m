Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031636CF1D4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjC2SI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjC2SIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:08:10 -0400
Received: from mail-ed1-x563.google.com (mail-ed1-x563.google.com [IPv6:2a00:1450:4864:20::563])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240DE5FC2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:09 -0700 (PDT)
Received: by mail-ed1-x563.google.com with SMTP id b20so66833248edd.1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680113287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dzO052dGHWeBZdELVfH7B7joY5VP7975N6/Li8m1jQ=;
        b=EprDCvXLlTiI9UyKrKEjJnaenWktfcfP4sbr4LTn+u54wlnAkUh2E6EOmE6zL6YkoD
         TSLbJFocbAPpaB4Jidft1D5nqbrWVPJUAH9INkezlprFiF7+b7YoFH3y6MhdotDylCec
         /J2zE+GzdOcc+5SRdUh4A5004wSucduisqiwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0dzO052dGHWeBZdELVfH7B7joY5VP7975N6/Li8m1jQ=;
        b=A6XF02l4aGQOjZyFemTEpjL/tulRtodd7hdxHbxcea9Hr4WMOq2rIq/QBuuEp06uED
         +Mz7iK4Y/IAHpLvpK6yheVZY3VR8kbvmDI+Lw6x6D2WuITp/t7IjFgN52HzusunRlZZq
         SpgSW5kd27yd93EJB+HOiAuNv18XJEa/3nWf1FQ+/N8ZPQ3xV6ikuCHLkDHeEGXk8DVi
         vdOLRY7Z3oaJVAGbfNRWXs8RJfwE/5FhspbWHfc8SDY6xpc0kNb/rWqG4k9Ci57ripxv
         A+ics112Py70Am+X3YcXeiJaJAjL+4TMXpkFWkyO8inQuE6J24mBGytlMPk28IqZSx4e
         s6tA==
X-Gm-Message-State: AAQBX9eBMA/+6sChkh95jazKKobXW7Lg+mEE3FDhIdsBFzCcqap7ik43
        sgiLzZcx+pxi+lVTwBqp9KdDL/aQp/KqYPrbfkmSJfTy50km
X-Google-Smtp-Source: AKy350YhzL8uuzk3K2T+4Yc9JiuPxL6e9Dx1ufdIaEG6jZEpryDjnRUspNjGKFIoJP1Raw67Bg6sxqFcJq/k
X-Received: by 2002:a17:906:3806:b0:931:fdf0:7eee with SMTP id v6-20020a170906380600b00931fdf07eeemr19323784ejc.56.1680113287594;
        Wed, 29 Mar 2023 11:08:07 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m10-20020a1709066d0a00b00920438f59b3sm12072998ejr.154.2023.03.29.11.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 11:08:07 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 06/10] xsk: Add check for unaligned descriptors that overrun UMEM
Date:   Wed, 29 Mar 2023 20:04:58 +0200
Message-Id: <20230329180502.1884307-7-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230329180502.1884307-1-kal.conley@dectris.com>
References: <20230329180502.1884307-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure unaligned descriptors that straddle the end of the UMEM are
considered invalid. This check needs to happen before the page boundary
and contiguity checks in xp_desc_crosses_non_contig_pg(). Check this in
xp_unaligned_validate_desc() instead like xp_check_unaligned() already
does.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 include/net/xsk_buff_pool.h | 9 ++-------
 net/xdp/xsk_queue.h         | 1 +
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 3e952e569418..d318c769b445 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -180,13 +180,8 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 	if (likely(!cross_pg))
 		return false;
 
-	if (pool->dma_pages_cnt) {
-		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
-			 XSK_NEXT_PG_CONTIG_MASK);
-	}
-
-	/* skb path */
-	return addr + len > pool->addrs_cnt;
+	return pool->dma_pages_cnt &&
+	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
 }
 
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index bfb2a7e50c26..66c6f57c9c44 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -162,6 +162,7 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
 		return false;
 
 	if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
+	    addr + desc->len > pool->addrs_cnt ||
 	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
 		return false;
 
-- 
2.39.2

