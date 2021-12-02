Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD82465A53
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 01:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354033AbhLBAHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 19:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354032AbhLBAHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 19:07:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638403440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDXI2dfRgWUXP7V439OsHy/fTRVufq6CwTbb4xhL8Gk=;
        b=Po3SWBSNwINeUuOoxXesRm1KGsP190LaxCUeXBYdo1qveqRQoXlI5wrmu+Nj391p5H/j4S
        FjwQ+i6p6CDgCvtcvJQv5wf1HIVS/pYf+qU/fbt9f0GOi9+lChdNGBvnOYj2A4+jQ75t0z
        D8hd/Z7z0c4cgrP7etnfI6XBEXeDWgI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-l6UfRk4nOsiNjoY_oWja2Q-1; Wed, 01 Dec 2021 19:03:59 -0500
X-MC-Unique: l6UfRk4nOsiNjoY_oWja2Q-1
Received: by mail-ed1-f70.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so21785376eds.23
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 16:03:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDXI2dfRgWUXP7V439OsHy/fTRVufq6CwTbb4xhL8Gk=;
        b=SXAq/0urTAOazq/OFM/Bs2qAmn2nJYAmOESegGqG/od/Sx3uciVSpxC5hXM9lBZ8DW
         fJRlwVQp4KJJ/urH0A06l2WTXUMrmzeHmsN4YHNRH8UrylMGlXtH/cSIL+bsKl+kb2Eg
         G/dhQ1C0L4pj5U+kiakGDvxF1X5+A5pqAxKDc1iTSnGbFHGnN5NNiMJu5/vCbBkc+822
         R3Iq/mUuveOEBTSCKtMNDHws0Sc/8GRi0Aooci5z+ZlRGUjS3YDsI7yNlYrMuCjMGT3M
         8vT10JonB4dw80bFBh/CKlVq12dN7WS1YD//HKTEPONaJ2KfOt+anKtmvsYF3W3nzpRL
         b1rg==
X-Gm-Message-State: AOAM530vjUSfPCkfR50ubIzt5Qq45N3cHso/jKo40+oWNDRzxecGlsPb
        CPcjUScXZS+RBk1DFxG5HkeAoZXRzldjiiy3F6+uGA7G07fWRIz7WhXeAP6m1mjkAhovarfaGer
        CkIkq8VEkVwQF3z3n
X-Received: by 2002:a17:906:3085:: with SMTP id 5mr10705857ejv.365.1638403437914;
        Wed, 01 Dec 2021 16:03:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEEM3I9IYJgFZKYnyZ+to/tY9V079Mc7mCeD/f4tsRiwkPVmnLg07hOTYahOEa4Roy/ipWLw==
X-Received: by 2002:a17:906:3085:: with SMTP id 5mr10705810ejv.365.1638403437569;
        Wed, 01 Dec 2021 16:03:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ne33sm692644ejc.6.2021.12.01.16.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 16:03:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 95C1C1802A0; Thu,  2 Dec 2021 01:03:56 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/8] xdp: Allow registering memory model without rxq reference
Date:   Thu,  2 Dec 2021 01:02:24 +0100
Message-Id: <20211202000232.380824-4-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202000232.380824-1-toke@redhat.com>
References: <20211202000232.380824-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions that register an XDP memory model take a struct xdp_rxq as
parameter, but the RXQ is not actually used for anything other than pulling
out the struct xdp_mem_info that it embeds. So refactor the register
functions and export variants that just take a pointer to the xdp_mem_info.

This is in preparation for enabling XDP_REDIRECT in bpf_prog_run(), using a
page_pool instance that is not connected to any network device.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/xdp.h |  3 ++
 net/core/xdp.c    | 92 +++++++++++++++++++++++++++++++----------------
 2 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 447f9b1578f3..8f0812e4996d 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -260,6 +260,9 @@ bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator);
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq);
+int xdp_reg_mem_model(struct xdp_mem_info *mem,
+		      enum xdp_mem_type type, void *allocator);
+void xdp_unreg_mem_model(struct xdp_mem_info *mem);
 
 /* Drivers not supporting XDP metadata can use this helper, which
  * rejects any room expansion for metadata as a result.
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 143388c6d9dd..2901bb7004cc 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -110,20 +110,15 @@ static void mem_allocator_disconnect(void *allocator)
 	mutex_unlock(&mem_id_lock);
 }
 
-void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
+void xdp_unreg_mem_model(struct xdp_mem_info *mem)
 {
 	struct xdp_mem_allocator *xa;
-	int type = xdp_rxq->mem.type;
-	int id = xdp_rxq->mem.id;
+	int type = mem->type;
+	int id = mem->id;
 
 	/* Reset mem info to defaults */
-	xdp_rxq->mem.id = 0;
-	xdp_rxq->mem.type = 0;
-
-	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
-		WARN(1, "Missing register, driver bug");
-		return;
-	}
+	mem->id = 0;
+	mem->type = 0;
 
 	if (id == 0)
 		return;
@@ -135,6 +130,17 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 		rcu_read_unlock();
 	}
 }
+EXPORT_SYMBOL_GPL(xdp_unreg_mem_model);
+
+void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
+{
+	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
+		WARN(1, "Missing register, driver bug");
+		return;
+	}
+
+	xdp_unreg_mem_model(&xdp_rxq->mem);
+}
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
 
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
@@ -259,28 +265,24 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
-int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
-			       enum xdp_mem_type type, void *allocator)
+static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
+						     enum xdp_mem_type type,
+						     void *allocator)
 {
 	struct xdp_mem_allocator *xdp_alloc;
 	gfp_t gfp = GFP_KERNEL;
 	int id, errno, ret;
 	void *ptr;
 
-	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
-		WARN(1, "Missing register, driver bug");
-		return -EFAULT;
-	}
-
 	if (!__is_supported_mem_type(type))
-		return -EOPNOTSUPP;
+		return ERR_PTR(-EOPNOTSUPP);
 
-	xdp_rxq->mem.type = type;
+	mem->type = type;
 
 	if (!allocator) {
 		if (type == MEM_TYPE_PAGE_POOL)
-			return -EINVAL; /* Setup time check page_pool req */
-		return 0;
+			return ERR_PTR(-EINVAL); /* Setup time check page_pool req */
+		return NULL;
 	}
 
 	/* Delay init of rhashtable to save memory if feature isn't used */
@@ -290,13 +292,13 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		mutex_unlock(&mem_id_lock);
 		if (ret < 0) {
 			WARN_ON(1);
-			return ret;
+			return ERR_PTR(ret);
 		}
 	}
 
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&mem_id_lock);
 	id = __mem_id_cyclic_get(gfp);
@@ -304,15 +306,15 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		errno = id;
 		goto err;
 	}
-	xdp_rxq->mem.id = id;
-	xdp_alloc->mem  = xdp_rxq->mem;
+	mem->id = id;
+	xdp_alloc->mem = *mem;
 	xdp_alloc->allocator = allocator;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
 	if (IS_ERR(ptr)) {
-		ida_simple_remove(&mem_id_pool, xdp_rxq->mem.id);
-		xdp_rxq->mem.id = 0;
+		ida_simple_remove(&mem_id_pool, mem->id);
+		mem->id = 0;
 		errno = PTR_ERR(ptr);
 		goto err;
 	}
@@ -322,13 +324,43 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 	mutex_unlock(&mem_id_lock);
 
-	trace_mem_connect(xdp_alloc, xdp_rxq);
-	return 0;
+	return xdp_alloc;
 err:
 	mutex_unlock(&mem_id_lock);
 	kfree(xdp_alloc);
-	return errno;
+	return ERR_PTR(errno);
+}
+
+int xdp_reg_mem_model(struct xdp_mem_info *mem,
+		      enum xdp_mem_type type, void *allocator)
+{
+	struct xdp_mem_allocator *xdp_alloc;
+
+	xdp_alloc = __xdp_reg_mem_model(mem, type, allocator);
+	if (IS_ERR(xdp_alloc))
+		return PTR_ERR(xdp_alloc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xdp_reg_mem_model);
+
+int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
+			       enum xdp_mem_type type, void *allocator)
+{
+	struct xdp_mem_allocator *xdp_alloc;
+
+	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
+		WARN(1, "Missing register, driver bug");
+		return -EFAULT;
+	}
+
+	xdp_alloc = __xdp_reg_mem_model(&xdp_rxq->mem, type, allocator);
+	if (IS_ERR(xdp_alloc))
+		return PTR_ERR(xdp_alloc);
+
+	trace_mem_connect(xdp_alloc, xdp_rxq);
+	return 0;
 }
+
 EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 
 /* XDP RX runs under NAPI protection, and in different delivery error
-- 
2.34.0

