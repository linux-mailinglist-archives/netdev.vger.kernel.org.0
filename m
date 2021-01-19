Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED65B2FBE1D
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387840AbhASRiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391610AbhASPvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:51:08 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27AAC0613C1;
        Tue, 19 Jan 2021 07:50:27 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o17so29743047lfg.4;
        Tue, 19 Jan 2021 07:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RO1GdsGe/CwUlFc4QGSwFYrVwnR9WPHVNLK3C1RF8Gk=;
        b=Y43ogcA0T7mowGKBBsoPEaxGpomJKy6sPzMxJtlf6Npk+qKyuRcB5PODYduiE+nqv2
         MAwyeJvbXt0wxUfukFNe0MMN8frdtwqyrTmYmdeqmGfNA+jY6oo3qdUoy5anrPLvFbIx
         GXkJzPII4xNWvplxyKgpHuT6K+/1XT/o4m5nzhlXjHP+4VDJ3eXUPvqbe72SGZ/5HLcI
         0w8wmLrfDLdXFSRufPHeNmmLtVYzOidqgPzGQLRJiRgA2qPfG9cjEPtMUsoSfwy7Omgv
         2jBh1XCfBD8QlTr36J5QgzHyzwEFbhYe/pwCr5rY3802YoD/6WSOYOaqDL0O7s/Nfkee
         BRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RO1GdsGe/CwUlFc4QGSwFYrVwnR9WPHVNLK3C1RF8Gk=;
        b=Kbv3Fc1yW4obHhyTfcff4Amd8/2emVJxHEPGjd2XOIDhsigfA5BBcmDSlDbhpajo1g
         eRtd0IO9IM+SC4PlOUh8ryXzDtK+b0bJUKpVIVy4oa8Yh9R7II1ktZIBcy3Xcspr5FGJ
         /NBZuU3YyaJvcsoag0b/jrUyYS+vjZrfiU8VJWxuXLyp9sSsfZhyrGeCFiKVp2O/PStg
         QUA4yuJjJDP3i/mmuulHpDSD7SeHA/BkGBvosIrqIq3n9qoFwTYnz6ieK50JZNVluxUj
         GDWitAhMeKtu8jQj9/6gSg3nB41Zwk6gZ1GMhymq5UyGnvK3Y6rDcE14EmtQUvNjhNAK
         c3hw==
X-Gm-Message-State: AOAM533bNHyV9ArPLcI95nNWSklabbBc8KYXNYJL05lQrpKfsXWT/YN5
        nqvaNJ+Y/+nvwLVkfDagE2Y=
X-Google-Smtp-Source: ABdhPJygJVw7HZDZZ/Z0AOuzXAxR9QPmYmtGIp/0H/ljPVkSWFLds3klVcvRh/sIPMI5uxQ+yrASjA==
X-Received: by 2002:a05:6512:706:: with SMTP id b6mr2318934lfs.115.1611071426257;
        Tue, 19 Jan 2021 07:50:26 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id h20sm2309249lfc.239.2021.01.19.07.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:50:25 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next v2 2/8] xsk: remove explicit_free parameter from __xsk_rcv()
Date:   Tue, 19 Jan 2021 16:50:07 +0100
Message-Id: <20210119155013.154808-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119155013.154808-1-bjorn.topel@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
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
index 8037b04a9edd..5820de65060b 100644
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

