Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25631E6CCC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407365AbgE1Urs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407361AbgE1Urq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 16:47:46 -0400
Received: from lore-desk.lan (unknown [151.48.140.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F2402088E;
        Thu, 28 May 2020 20:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590698865;
        bh=w10Hmpqu9fr3hUoGCGZl8tVD/9eC0Vkd9vt0iw6giag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbj66C6K/Qgp1JC4A+gTDOKk/9F1tV/lN953kbNr/+VIn4ub5M8a8en1uWNxO3jTX
         VUqmqQ987aDP2dwATeLnMhyEkLitRLebVMiP65j5gAjn0MiMmb3sgIly0HyBK86CNk
         bUu/vaGQglFpiox26mVYrsFi5ZowEfunB8J7QEDk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 bpf-next 1/2] xdp: introduce xdp_convert_frame_to_buff utility routine
Date:   Thu, 28 May 2020 22:47:28 +0200
Message-Id: <87acf133073c4b2d4cbb8097e8c2480c0a0fac32.1590698295.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590698295.git.lorenzo@kernel.org>
References: <cover.1590698295.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_convert_frame_to_buff utility routine to initialize xdp_buff
fields from xdp_frames ones. Rely on xdp_convert_frame_to_buff in veth xdp
code.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c |  6 +-----
 include/net/xdp.h  | 10 ++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b586d2fa5551..fb5c17361f64 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -575,11 +575,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 		struct xdp_buff xdp;
 		u32 act;
 
-		xdp.data_hard_start = hard_start;
-		xdp.data = frame->data;
-		xdp.data_end = frame->data + frame->len;
-		xdp.data_meta = frame->data - frame->metasize;
-		xdp.frame_sz = frame->frame_sz;
+		xdp_convert_frame_to_buff(frame, &xdp);
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 90f11760bd12..96d4d4a9d27b 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, const int line);
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
+static inline
+void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
+{
+	xdp->data_hard_start = frame->data - frame->headroom - sizeof(*frame);
+	xdp->data = frame->data;
+	xdp->data_end = frame->data + frame->len;
+	xdp->data_meta = frame->data - frame->metasize;
+	xdp->frame_sz = frame->frame_sz;
+}
+
 /* Convert xdp_buff to xdp_frame */
 static inline
 struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
-- 
2.26.2

