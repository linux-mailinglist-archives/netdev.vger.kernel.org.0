Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244D14833EE
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiACPI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:08:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233800AbiACPI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:08:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641222506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBJQlk17VYpNq3XuagcLluTSgGk2Y5vu3pcY1OdBztc=;
        b=Hov9CiIWpJi1wFn22iVFYp8RqT4tUS3Spjqkb4cogBjBgp2LkusnGceV0wZnWh2keVlIkM
        iYv+NFiJf3jQmjlhPx/LJ6zneB83EFd0ToF6q8r54pAJKP0OanpeIilrlRY26AJFqe7ZfJ
        v49N1cJMKSlEU4q9DFJjDb0gGzVzotM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-GO667bn4Nh-TMqCp_pDpdQ-1; Mon, 03 Jan 2022 10:08:25 -0500
X-MC-Unique: GO667bn4Nh-TMqCp_pDpdQ-1
Received: by mail-ed1-f70.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso16224535edb.7
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 07:08:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eBJQlk17VYpNq3XuagcLluTSgGk2Y5vu3pcY1OdBztc=;
        b=lAYGWF6zfJ9Z4zyZFjMMvUpETJxBzGkMYfl1kRPekrh+H00BN2K70NdgARE3aXzmIW
         UE+wXoyE3xB4Xmb/XeCu7NoCRuWMkwLdqbchuEyNFEHhzIueCmFzH8PfhO99aNnRghsc
         H8fHssFLAJCqDh9pNf/cdA3qcmkd4zIV0saBAof1EjrvK1c0CdMFce/tL7gokLLcPm5e
         pGN5NDP9eWXnda7czK/xD9BzHUdHZ+SGbiU9xhj16fuyTHY9hzRFy77YUnrBnF8F2FTZ
         hDGwFCEkZyzuODvru30+fRBP2AtsFsS0fRC6sIxm9PSvlJNRbD5BNGWikuRjoScFJNHz
         R6fw==
X-Gm-Message-State: AOAM533qJ+TXG9eAiyMcuf6tgKe8I0DX2dyymqVCyNTyTj9zQbXWWim5
        213L7iAYJkgMqts2hTIXp+c//7Zt0oSAOEwEtV32wr0Shfh8EkpIeBAtmANDqRCYRFeBXlvdvxf
        RTi6Oeo/ZuKrSvgUw
X-Received: by 2002:a17:907:76f4:: with SMTP id kg20mr36370190ejc.54.1641222502198;
        Mon, 03 Jan 2022 07:08:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3UVivIiXO5HAhMxK4JvFAQJHcTWVmqehl+Z8texCiZlBu1MGEgxUXYlcSQB0jCmGiMR8OtQ==
X-Received: by 2002:a17:907:76f4:: with SMTP id kg20mr36370062ejc.54.1641222500412;
        Mon, 03 Jan 2022 07:08:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ht14sm10685790ejc.64.2022.01.03.07.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 07:08:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 675E2181F2A; Mon,  3 Jan 2022 16:08:19 +0100 (CET)
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
Subject: [PATCH bpf-next v5 1/7] xdp: Allow registering memory model without rxq reference
Date:   Mon,  3 Jan 2022 16:08:06 +0100
Message-Id: <20220103150812.87914-2-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103150812.87914-1-toke@redhat.com>
References: <20220103150812.87914-1-toke@redhat.com>
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
index 7fe1df85f505..58089f6d2c7a 100644
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
2.34.1

