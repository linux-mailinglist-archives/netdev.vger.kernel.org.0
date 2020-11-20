Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895302BA99D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgKTLxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKTLxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 06:53:52 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E029C0613CF;
        Fri, 20 Nov 2020 03:53:52 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 62so7087349pgg.12;
        Fri, 20 Nov 2020 03:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fTyws4Wcb8JbJ0XNofEOfF91urRPW0CoPidlACaoz7U=;
        b=D7H/6ge4iO+I7BL0bZUHJ1rNLYXA3vNFtQHbUev1Zxkwiz25SlE7lrzhPqzrqYKh4+
         kvkiJUoYaNoAjpAGTR4lbeg2xdSYyw1HSk8L7NnF1GYHtyUZmtXijdlvSu/RtrQWXkGh
         sU+5unlzZuxnmL0343wpnPa5TkRvftH6OXSb8XJLSzrQ64XaAVCe8ROjfhtA+UHvoLsG
         Y0vqwtQoiCV1akveocp6VeIEkxExyKa/4ZJAX/G8KuIX+jU7O0TDDOlvwgZ/KYFYpBIE
         eTTQEU8Ze9W+HvT97HowEATrY6elejEIDbEsnD6jim9BiDA9JRS/Mnldtekuyn5ZYJKV
         L8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fTyws4Wcb8JbJ0XNofEOfF91urRPW0CoPidlACaoz7U=;
        b=IZS4ABtREusNGOuZCiKqtOb8CldOlHVNMOAigpdoECNgMWllqXuZfJiCrbG4vpN/hC
         XtEaYXWWo63hImLUAfBbNNMSOPs8xizsTpuQjaFGl+5pCT8gDlUtpdK+v+vmi5hX45Iv
         +Zx2PHTn29vW+Fo56FtNZObXywH1dsy2u75hp0vMz25vSN4EqnaZg7RPMV5jQr12nOUv
         uhdIhdC2O+6JWBOnVStWyZJzp1hzz1iI7l/fmG863DyQpcb9tySQ8YMm7Zt2q4zW7ozo
         9TbzZW0KkHaS+AIpWaDicJNwWBFpy4kCSsirWHhzQZsN0Tvg32q8CcUX5j4ObcduCNXQ
         IIdQ==
X-Gm-Message-State: AOAM532nHC1Wi/5WB/cCUWpumf01u//B4eDlFV0VSp0zzgDnBwR663cV
        k4miibV7fMQz6fqPK49zohK+PsA19CsMqyzEucQ=
X-Google-Smtp-Source: ABdhPJx06t1DqEmP6ElG5P45hXR8UNJ3PeAPO2bEgLkM9yDPDgzcWDEH50z7gF2UFVaqxy6BMzjJuQ==
X-Received: by 2002:a17:90a:f0f:: with SMTP id 15mr9865390pjy.127.1605873231683;
        Fri, 20 Nov 2020 03:53:51 -0800 (PST)
Received: from localhost.localdomain ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id k25sm3349155pfi.42.2020.11.20.03.53.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2020 03:53:51 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     alardam@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix umem cleanup bug at socket destruct
Date:   Fri, 20 Nov 2020 12:53:39 +0100
Message-Id: <1605873219-21629-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a bug that is triggered when a partially setup socket is
destroyed. For a fully setup socket, a socket that has been bound to a
device, the cleanup of the umem is performed at the end of the buffer
pool's cleanup work queue item. This has to be performed in a work
queue, and not in RCU cleanup, as it is doing a vunmap that cannot
execute in interrupt context. However, when a socket has only been
partially set up so that a umem has been created but the buffer pool
has not, the code erroneously directly calls the umem cleanup function
instead of using a work queue, and this leads to a BUG_ON() in
vunmap().

As there in this case is no buffer pool, we cannot use its work queue,
so we need to introduce a work queue for the umem and schedule this for
the cleanup. So in the case there is no pool, we are going to use the
umem's own work queue to schedule the cleanup. But if there is a
pool, the cleanup of the umem is still being performed by the pool's
work queue, as it is important that the umem is cleaned up after the
pool.

Fixes: e5e1a4bc916d ("xsk: Fix possible memory leak at socket close")
Reported-by: Marek Majtyka <marekx.majtyka@intel.com>
Tested-by: Marek Majtyka <marekx.majtyka@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h  |  1 +
 net/xdp/xdp_umem.c      | 19 ++++++++++++++++---
 net/xdp/xdp_umem.h      |  2 +-
 net/xdp/xsk.c           |  2 +-
 net/xdp/xsk_buff_pool.c |  2 +-
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 1a9559c..4f4e93b 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -31,6 +31,7 @@ struct xdp_umem {
 	struct page **pgs;
 	int id;
 	struct list_head xsk_dma_list;
+	struct work_struct work;
 };
 
 struct xsk_map {
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 56d052b..56a28a6 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -66,18 +66,31 @@ static void xdp_umem_release(struct xdp_umem *umem)
 	kfree(umem);
 }
 
+static void xdp_umem_release_deferred(struct work_struct *work)
+{
+	struct xdp_umem *umem = container_of(work, struct xdp_umem, work);
+
+	xdp_umem_release(umem);
+}
+
 void xdp_get_umem(struct xdp_umem *umem)
 {
 	refcount_inc(&umem->users);
 }
 
-void xdp_put_umem(struct xdp_umem *umem)
+void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
 {
 	if (!umem)
 		return;
 
-	if (refcount_dec_and_test(&umem->users))
-		xdp_umem_release(umem);
+	if (refcount_dec_and_test(&umem->users)) {
+		if (defer_cleanup) {
+			INIT_WORK(&umem->work, xdp_umem_release_deferred);
+			schedule_work(&umem->work);
+		} else {
+			xdp_umem_release(umem);
+		}
+	}
 }
 
 static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
index 181fdda..aa9fe27 100644
--- a/net/xdp/xdp_umem.h
+++ b/net/xdp/xdp_umem.h
@@ -9,7 +9,7 @@
 #include <net/xdp_sock_drv.h>
 
 void xdp_get_umem(struct xdp_umem *umem);
-void xdp_put_umem(struct xdp_umem *umem);
+void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup);
 struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr);
 
 #endif /* XDP_UMEM_H_ */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cfbec39..5a6cdf7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1147,7 +1147,7 @@ static void xsk_destruct(struct sock *sk)
 		return;
 
 	if (!xp_put_pool(xs->pool))
-		xdp_put_umem(xs->umem);
+		xdp_put_umem(xs->umem, !xs->pool);
 
 	sk_refcnt_debug_dec(sk);
 }
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8a3bf4e..3c5a142 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -242,7 +242,7 @@ static void xp_release_deferred(struct work_struct *work)
 		pool->cq = NULL;
 	}
 
-	xdp_put_umem(pool->umem);
+	xdp_put_umem(pool->umem, false);
 	xp_destroy(pool);
 }
 
-- 
2.7.4

