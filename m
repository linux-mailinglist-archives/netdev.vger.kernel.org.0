Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50B1E3D8D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgE0J2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgE0J2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 05:28:32 -0400
Received: from lore-desk.lan (unknown [151.48.148.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E70A20890;
        Wed, 27 May 2020 09:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590571712;
        bh=NCIcF/aN6YMziToxCMz9vHqC8BzCusF3Ikf1iEZXrP0=;
        h=From:To:Cc:Subject:Date:From;
        b=YEEPhdZ+avzBIFB/R3U5P9UMMBhEwEjXjbbO+dAdoVjJ2ORsv2RfMAAC3fQSc4Dpg
         DHa6aZ7uvvjz/rtO/UkUn76Y0N6eSYqSB3opz0npaZqePm9xIvLULNtJVxFezXBC17
         lH/6M99SjoILImYM/Ow6jA1awjaqNq5drvnspE+Y=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, toshiaki.makita1@gmail.com
Subject: [PATCH v2 bpf-next] xdp: introduce convert_to_xdp_buff utility routine
Date:   Wed, 27 May 2020 11:28:03 +0200
Message-Id: <80a0128d78f6c77210a8cccf7c5a78f53c45e7d3.1590571528.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce convert_to_xdp_buff utility routine to initialize xdp_buff
fields from xdp_frames ones. Rely on convert_to_xdp_buff in veth xdp
code

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rely on frame->data pointer to compute xdp->data_hard_start one
---
 drivers/net/veth.c |  6 +-----
 include/net/xdp.h  | 10 ++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b586d2fa5551..9f91e79b7823 100644
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
+		convert_to_xdp_buff(frame, &xdp);
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 90f11760bd12..df99d5d267b2 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -106,6 +106,16 @@ void xdp_warn(const char *msg, const char *func, const int line);
 
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
+static inline
+void convert_to_xdp_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
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

