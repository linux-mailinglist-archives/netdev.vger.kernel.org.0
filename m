Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0C3300257
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbhAVMCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbhAVKyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:54:41 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC17C061788;
        Fri, 22 Jan 2021 02:53:59 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id q8so6898890lfm.10;
        Fri, 22 Jan 2021 02:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hulAWX+ID8YP+M6DcfsfFj0NnmiYbEjBVbQTiIzCsk4=;
        b=NZ8aRhVoaCdab80d5xvYYaI+TzNQeCtkPqQIxzbiRgU8W/RBlhRUQDZy72XZUHvCAO
         zbi+kQ3PRY0VNDHNOjRE82PeWA3jvn84poUjEm7OUbUKWUg88gu1qitg0kN8R9uWt5WV
         Vu0gJzfwHI9dppO3xnQMBIKxHolbhhoCCLlKphIPbQoAX7FHKXvvFYYRpTzSXh4wrJ//
         QVxciSmsKqmod8KROMYoRK/aVtE1RuDzIwqz2qrEz67KSP6ysjHpz8MI98qwtiHUmDsu
         R9pDbw4HTCd0mu6IUSiNMhIzo62KOoxPqkVLQJhgrfwajTIyxC8oTr2m8r+lInCMr1Hr
         olXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hulAWX+ID8YP+M6DcfsfFj0NnmiYbEjBVbQTiIzCsk4=;
        b=Ba+4tYfC+uk1fajlWBp0xTmimiKzzE4lp8FffPD0s7jmVq6hp75k3IGHdWKOzR0iav
         ief2KUX56AUNcJ7X83whttQKuOS9xmVcXsW8CNroHmtS6O+h5H+/YK/rUDiKk0Q2tvG3
         hz/jzHSSvwFoBCt8ruK8wp1EN/vJJftxyedJsJcf5rY2n0f9Xmxf2Cs1kF05/lvVgKXp
         lPKzY+PeokzEnIM4j36TYlj/IdszFNGRvDGJU9AEga5Av6SeUf5COfTW5kooP1+S+Nh0
         nrStjzcQXVqfTJD3qqlFBivwf2Zst8v09wv8RxS1mhu4dcWc95YOFTFFOlaVjU7n8hvm
         6ecQ==
X-Gm-Message-State: AOAM531xtW1Ajp/BiozWPrCKOXSyrja+K1cL/AjFXEnQSDCihN5lWrQy
        3nJXg1nIeKzDqH+gD8/9zM4=
X-Google-Smtp-Source: ABdhPJy7BraNJ3krdVL9aTq2ZksfYJJL5JIvF3LqrPnxBf+VE1pTH//WysbQw6QnKp+GcK26xp3hag==
X-Received: by 2002:a19:c787:: with SMTP id x129mr431505lff.211.1611312838299;
        Fri, 22 Jan 2021 02:53:58 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id g14sm409580lja.120.2021.01.22.02.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 02:53:57 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 1/3] xsk: remove explicit_free parameter from __xsk_rcv()
Date:   Fri, 22 Jan 2021 11:53:49 +0100
Message-Id: <20210122105351.11751-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122105351.11751-1-bjorn.topel@gmail.com>
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The explicit_free parameter of the __xsk_rcv() function was used to
mark whether the call was via the generic XDP or the native XDP
path. Instead of clutter the code with if-statements and "true/false"
parameters which are hard to understand, simply move the explicit free
to the __xsk_map_redirect() which is always called from the native XDP
path.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4a83117507f5..4faabd1ecfd1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -184,12 +184,13 @@ static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 	memcpy(to_buf, from_buf, len + metalen);
 }
 
-static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
-		     bool explicit_free)
+static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	struct xdp_buff *xsk_xdp;
 	int err;
+	u32 len;
 
+	len = xdp->data_end - xdp->data;
 	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
 		xs->rx_dropped++;
 		return -ENOSPC;
@@ -207,8 +208,6 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 		xsk_buff_free(xsk_xdp);
 		return err;
 	}
-	if (explicit_free)
-		xdp_return_buff(xdp);
 	return 0;
 }
 
@@ -230,11 +229,8 @@ static bool xsk_is_bound(struct xdp_sock *xs)
 	return false;
 }
 
-static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
-		   bool explicit_free)
+static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
-	u32 len;
-
 	if (!xsk_is_bound(xs))
 		return -EINVAL;
 
@@ -242,11 +238,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
 		return -EINVAL;
 
 	sk_mark_napi_id_once_xdp(&xs->sk, xdp);
-	len = xdp->data_end - xdp->data;
-
-	return xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL ?
-		__xsk_rcv_zc(xs, xdp, len) :
-		__xsk_rcv(xs, xdp, len, explicit_free);
+	return 0;
 }
 
 static void xsk_flush(struct xdp_sock *xs)
@@ -261,18 +253,41 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	int err;
 
 	spin_lock_bh(&xs->rx_lock);
-	err = xsk_rcv(xs, xdp, false);
-	xsk_flush(xs);
+	err = xsk_rcv_check(xs, xdp);
+	if (!err) {
+		err = __xsk_rcv(xs, xdp);
+		xsk_flush(xs);
+	}
 	spin_unlock_bh(&xs->rx_lock);
 	return err;
 }
 
+static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+{
+	int err;
+	u32 len;
+
+	err = xsk_rcv_check(xs, xdp);
+	if (err)
+		return err;
+
+	if (xdp->rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL) {
+		len = xdp->data_end - xdp->data;
+		return __xsk_rcv_zc(xs, xdp, len);
+	}
+
+	err = __xsk_rcv(xs, xdp);
+	if (!err)
+		xdp_return_buff(xdp);
+	return err;
+}
+
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
 	int err;
 
-	err = xsk_rcv(xs, xdp, true);
+	err = xsk_rcv(xs, xdp);
 	if (err)
 		return err;
 
-- 
2.27.0

