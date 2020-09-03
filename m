Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C5125CBAA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgICU7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbgICU7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:59:30 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82F5206C9;
        Thu,  3 Sep 2020 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599166770;
        bh=S/93yEwe9N0oMZRZSBWUZ2mWvYgyKCZBmf9CGEZiUhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AITN7qgkeKzWaKuPPQYLjn4nDmooZiHOWxTOuGqI9sdzm8ey0i6bbhWoZu4redXS/
         Y7uzx6m6IZYFobCPQ3xJwPycNwODSMg56QnyAgCEc2IoNfueGYFP2STQReBBsEmL8a
         k+MZsii6rD27YstZIHljgyoH8nmNOUkl9txCu/Wo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: [PATCH v2 net-next 4/9] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Thu,  3 Sep 2020 22:58:48 +0200
Message-Id: <96eafcce5015798dbadfee4cebc93effd3bba2e6.1599165031.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
References: <cover.1599165031.git.lorenzo@kernel.org>
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
 include/net/xdp.h | 18 ++++++++++++++++--
 net/core/xdp.c    | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 42f439f9fcda..4d47076546ff 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -208,10 +208,24 @@ void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
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
+	if (likely(!xdpf->mb))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_release_frame(page_address(page), mem);
+	}
+out:
+	__xdp_release_frame(xdpf->data, mem);
 }
 
 int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 884f140fc3be..6d4fd4dddb00 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -370,18 +370,57 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct)
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
+	if (likely(!xdpf->mb))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, false);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, false);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
+	if (likely(!xdpf->mb))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_frame(xdpf);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdpf->mem, true);
+	}
+out:
 	__xdp_return(xdpf->data, &xdpf->mem, true);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
+	struct skb_shared_info *sinfo;
+	int i;
+
+	if (likely(!xdp->mb))
+		goto out;
+
+	sinfo = xdp_get_shared_info_from_buff(xdp);
+	for (i = 0; i < sinfo->nr_frags; i++) {
+		struct page *page = skb_frag_page(&sinfo->frags[i]);
+
+		__xdp_return(page_address(page), &xdp->rxq->mem, true);
+	}
+out:
 	__xdp_return(xdp->data, &xdp->rxq->mem, true);
 }
 
-- 
2.26.2

