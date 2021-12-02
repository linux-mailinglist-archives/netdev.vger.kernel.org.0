Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D83465A63
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354016AbhLBAH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:07:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354044AbhLBAHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:07:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638403441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ds6QTVDpGNxBUDXmv5+fit0E/Kglxb7++rnaRLkBHbc=;
        b=KPAUVwgP4Q/PfFYyStlO/hwY7JWK+TSBUMhO4zFik4h24jRpapv0y0ZP52h3U9ePJj+OqO
        AoCKUcu26tem1xv7u0FPCiBOTEPRQsuSwr/E+KQV8QGmI2PLQDKAnPBfO/c6whuSIgFZmO
        0U9jyKGGTeckeXTdG4JHk9MPLe0okaY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-DxidAPJ4OB2JO0zJE0lwXw-1; Wed, 01 Dec 2021 19:04:00 -0500
X-MC-Unique: DxidAPJ4OB2JO0zJE0lwXw-1
Received: by mail-ed1-f71.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so21785401eds.23
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ds6QTVDpGNxBUDXmv5+fit0E/Kglxb7++rnaRLkBHbc=;
        b=yYyc0MfWMWOvXzCw2TgfbEf+ZpdjHA/hwSAcJSKSBBBRT7NM2O8uBvgsZxQyXeg9iN
         T7Fg9XTEanA7cXC52uV+5CmkoNhGAUhlz41mHJPiNuXzBPfjR/dm5l8co5J0R9UfEKAU
         dLj+mDESsr5CPBXMllfjd36E93cRWnIb4FKGQXv0az2Lc1XBQ0PJhH1rRSWljne0DYPG
         Khfe7Xtiy0xkveKx+fhQAB818D0YNYYCJ3hfiD+DD3w5p7edzusDFtZzj+Zj/mdW5UFs
         021GT7eRCDy1C+Q1etQxcV71mYjwenPZYsSe5ljuZn3Hl0pq/67Fo4FROXotkBjyW7Yf
         T3hw==
X-Gm-Message-State: AOAM531BaryzUkiKVyPU+wvf++Mr/CYgi9JJOPL5ww0XMNWCXwR7M+j2
        w0myOFpYXqY78sh4wyrMlP/igKi3xRknFc+k+omUwINH5ghpLRTZLsNGnL+1T4OzjiXZY/taI9G
        W9r48Br/Rrbl6r6Rm
X-Received: by 2002:a17:906:3b54:: with SMTP id h20mr10892759ejf.468.1638403437206;
        Wed, 01 Dec 2021 16:03:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoufdJJICk1VnB2bgN091I/pO0LQ6Z0sm63QuEmHyms076/9FNiAEOYKSR6KhAIhKoEjjgUg==
X-Received: by 2002:a17:906:3b54:: with SMTP id h20mr10892689ejf.468.1638403436491;
        Wed, 01 Dec 2021 16:03:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q7sm796702edr.9.2021.12.01.16.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 16:03:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8C1FB1802A0; Thu,  2 Dec 2021 01:03:54 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/8] page_pool: Store the XDP mem id
Date:   Thu,  2 Dec 2021 01:02:23 +0100
Message-Id: <20211202000232.380824-3-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202000232.380824-1-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store the XDP mem ID inside the page_pool struct so it can be retrieved
later for use in bpf_prog_run().

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/page_pool.h | 9 +++++++--
 net/core/page_pool.c    | 4 +++-
 net/core/xdp.c          | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a71201854c41..6bc0409c4ffd 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -96,6 +96,7 @@ struct page_pool {
 	unsigned int frag_offset;
 	struct page *frag_page;
 	long frag_users;
+	u32 xdp_mem_id;
 
 	/*
 	 * Data structure for allocation side
@@ -170,9 +171,12 @@ bool page_pool_return_skb_page(struct page *page);
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
+struct xdp_mem_info;
+
 #ifdef CONFIG_PAGE_POOL
 void page_pool_destroy(struct page_pool *pool);
-void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
+			   struct xdp_mem_info *mem);
 void page_pool_release_page(struct page_pool *pool, struct page *page);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
@@ -182,7 +186,8 @@ static inline void page_pool_destroy(struct page_pool *pool)
 }
 
 static inline void page_pool_use_xdp_mem(struct page_pool *pool,
-					 void (*disconnect)(void *))
+					 void (*disconnect)(void *),
+					 struct xdp_mem_info *mem)
 {
 }
 static inline void page_pool_release_page(struct page_pool *pool,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index fb5a90b9d574..2605467251f1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -695,10 +695,12 @@ static void page_pool_release_retry(struct work_struct *wq)
 	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
 }
 
-void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *))
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
+			   struct xdp_mem_info *mem)
 {
 	refcount_inc(&pool->user_cnt);
 	pool->disconnect = disconnect;
+	pool->xdp_mem_id = mem->id;
 }
 
 void page_pool_destroy(struct page_pool *pool)
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 5ddc29f29bad..143388c6d9dd 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -318,7 +318,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	}
 
 	if (type == MEM_TYPE_PAGE_POOL)
-		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
+		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect, mem);
 
 	mutex_unlock(&mem_id_lock);
 
-- 
2.34.0

