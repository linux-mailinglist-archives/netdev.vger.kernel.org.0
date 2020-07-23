Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1978D22ADF0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgGWLnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgGWLnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:43:01 -0400
Received: from lore-desk.redhat.com (unknown [151.48.142.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9721B2086A;
        Thu, 23 Jul 2020 11:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595504580;
        bh=D0Cio1tQM+aIdvgA4bobhr8cRVjSx3kh/xhDo6EfaSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7sCghhtXm46uqE8SUlUPcTXDFpdLsN8vgC1XdQxZgolPmINKzna/z8SDylCKIscd
         VBSqLkjNC4Tq2HKpWADgghKtmkRo6yLnHJx+/lvrH7R9NnOwKkF63/vi0wJvVbRT8d
         gkfd4z+cQEyf2cTI5YOgIFjSqjzWu9Y+9RMBqnKs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org
Subject: [RFC net-next 01/22] xdp: introduce mb in xdp_buff/xdp_frame
Date:   Thu, 23 Jul 2020 13:42:13 +0200
Message-Id: <1d3c0f39d41fd8268523c190c36fa7934d3b2e01.1595503780.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1595503780.git.lorenzo@kernel.org>
References: <cover.1595503780.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
if shared_info area has been properly initialized for non-linear
xdp buffers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index dbe9c60797e1..2ef6935c5646 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -72,7 +72,8 @@ struct xdp_buff {
 	void *data_hard_start;
 	struct xdp_rxq_info *rxq;
 	struct xdp_txq_info *txq;
-	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
+	u32 mb:1; /* xdp non-linear buffer */
 };
 
 /* Reserve memory area at end-of data area.
@@ -96,7 +97,8 @@ struct xdp_frame {
 	u16 len;
 	u16 headroom;
 	u32 metasize:8;
-	u32 frame_sz:24;
+	u32 frame_sz:23;
+	u32 mb:1; /* xdp non-linear frame */
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
@@ -141,6 +143,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 	xdp->data_end = frame->data + frame->len;
 	xdp->data_meta = frame->data - frame->metasize;
 	xdp->frame_sz = frame->frame_sz;
+	xdp->mb = frame->mb;
 }
 
 static inline
@@ -167,6 +170,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
 	xdp_frame->frame_sz = xdp->frame_sz;
+	xdp_frame->mb = xdp->mb;
 
 	return 0;
 }
-- 
2.26.2

