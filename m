Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2C14833ED
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiACPI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:08:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233807AbiACPI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:08:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641222505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sq80IA6Io1TllpaI+PVx+jt1JVKEdqHlykzwRmU9cEY=;
        b=a/+AmGUj6mpAlatmhWtQeTuYLr9NGoAfRTiDDpy7qxWBJsXsrcEu+Y3/7ixBSEzgiADZ6H
        bcMyn9/TsKjZDvE3kOa647cs1OGzwCtg59ORlWtsS/9e0Uyc2NUhFUwzapqJQxS5r6nRJW
        H+vBr4z2Pubz7vP4euQ4QSBWIrUcN1c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-mlVQfIdZPSGoi9OGH1eSng-1; Mon, 03 Jan 2022 10:08:24 -0500
X-MC-Unique: mlVQfIdZPSGoi9OGH1eSng-1
Received: by mail-ed1-f71.google.com with SMTP id eg23-20020a056402289700b003f80a27ca2bso23033962edb.14
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 07:08:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sq80IA6Io1TllpaI+PVx+jt1JVKEdqHlykzwRmU9cEY=;
        b=3jn66BA9ntd6E3VjolGJQ8hEMY5QISOIYsOf3wV2JWMKKHNHZ+bbcnnM5SVhmTUfHU
         9evt3lEBF38k66ty0hV0i9Th5X0MmGA9vk5iK/Nl3Nh19cBPgi8r6xfVCRQv0PHl7Wax
         7emAf6anw3rtVqh17CIWV0HZVhxw8P7V7haYTUCTW2/MfIhTWGdX7x3NUHB8MdHheYBY
         9UeefyZ+QMaK/Qz3pTuOwGwOGv/xqOBBlSFYLUuJgkKpbGJKJV0l+hVN5IkL1xhVFeit
         zNLToeil2JU64YRDd+QXq7GM65aWxMMoSOLFw+c0sTksOHdO4NF/DtWFFYEowv0oqljj
         VAjQ==
X-Gm-Message-State: AOAM532475myEVU9dYdh1LByIuHar0BkNpmj1vM8CAfAXEmBGVX7Eop/
        CsdMNNeAjPF2pcMMgyxzoW5f5esU4W5usAUwDdGEkq6WMyt8gqek/KSvSkGuVKxjlJ8MpjM/pUC
        Rkid8UyhImdfFTz6K
X-Received: by 2002:a05:6402:27d1:: with SMTP id c17mr43849716ede.128.1641222502351;
        Mon, 03 Jan 2022 07:08:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnA/WIPaTJV/pMImx+DCYnjy8IZQ3jV3GCmmKS5YaF7+NN1UFL3az5p0l2yPu4kXU4XImrKQ==
X-Received: by 2002:a05:6402:27d1:: with SMTP id c17mr43849647ede.128.1641222501374;
        Mon, 03 Jan 2022 07:08:21 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h11sm7761316edb.59.2022.01.03.07.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 07:08:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4EEE2180300; Mon,  3 Jan 2022 16:08:20 +0100 (CET)
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
Subject: [PATCH bpf-next v5 3/7] page_pool: Store the XDP mem id
Date:   Mon,  3 Jan 2022 16:08:08 +0100
Message-Id: <20220103150812.87914-4-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103150812.87914-1-toke@redhat.com>
References: <20220103150812.87914-1-toke@redhat.com>
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
index d807b6800a4a..79a805542d0f 100644
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
index f53786f6666d..7347d5c7dbe0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -693,10 +693,12 @@ static void page_pool_release_retry(struct work_struct *wq)
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
index 58089f6d2c7a..7aba35504986 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -320,7 +320,7 @@ static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
 	}
 
 	if (type == MEM_TYPE_PAGE_POOL)
-		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
+		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect, mem);
 
 	mutex_unlock(&mem_id_lock);
 
-- 
2.34.1

