Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F025249FC3
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHSN01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgHSNPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:15:51 -0400
Received: from lore-desk.redhat.com (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5179120855;
        Wed, 19 Aug 2020 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597842893;
        bh=KNhS+XgSQFMkxqqK71xmMmn8OOeheh+Ve42J2rRDFN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bA8LG/Ig3abwY4e74b+g2To0mxIaMH/iSeZ41Q030KQLi4wRx4FA0nZl1x/4kNWku
         9YPX1pubVc9a3HTAg3UGb/gD6io8EfKkoln28ezvaeYmgSexT/rA8pOe4xhw/aBY6a
         0pEuds2zOAnSzU0LhMQA3BDcU8NYLV6C6kd+6LR0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org
Subject: [PATCH net-next 4/6] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Wed, 19 Aug 2020 15:13:49 +0200
Message-Id: <7ff49193140f3cb5341732612c72bcc2c5fb3372.1597842004.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1597842004.git.lorenzo@kernel.org>
References: <cover.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account if the received xdp_buff/xdp_frame is non-linear
recycling/returning the frame memory to the allocator

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/net/xdp.h | 17 +++++++++++++++--
 net/core/xdp.c    | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 42f439f9fcda..37c4522fc1bb 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -208,10 +208,23 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
 static inline void xdp_release_frame(struct xdp_frame *xdpf)
 {
 	struct xdp_mem_info *mem = &xdpf->mem;
+	struct skb_shared_info *sinfo;
+	int i;
 
 	/* Curr only page_pool needs this */
-	if (mem->type == MEM_TYPE_PAGE_POOL)
-		__xdp_release_frame(xdpf->data, mem);
+	if (mem->type != MEM_TYPE_PAGE_POOL)
+		return;
+
+	__xdp_release_frame(xdpf->data, mem);
+	if (!xdpf->mb)
+		return;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_release_frame(page_address(page), mem);
+	}
 }
 
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 884f140fc3be..006b24b5d276 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -370,19 +370,55 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
 	__xdp_return(xdpf->data, &xdpf->mem, false);
+	if (!xdpf->mb)
+		return;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, false);
+	}
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
 	__xdp_return(xdpf->data, &xdpf->mem, true);
+	if (!xdpf->mb)
+		return;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, true);
+	}
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
 	__xdp_return(xdp->data, &xdp->rxq->mem, true);
+	if (!xdp->mb)
+		return;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdp->rxq->mem, true);
+	}
 }
 
 /* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
-- 
2.26.2

