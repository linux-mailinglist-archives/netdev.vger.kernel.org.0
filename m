Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220C28157A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgJBOml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:42:38 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08E20206FA;
        Fri,  2 Oct 2020 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649757;
        bh=S/93yEwe9N0oMZRZSBWUZ2mWvYgyKCZBmf9CGEZiUhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4MToq/YVevcVPqy4LCiSEW3uaTD5SzGqeEQC6c1hAAqRZ/MGxMn3etpST9q6ePg7
         GuGjfwrmPi1C1muSaTcVAJGqauXWzkJOonzEuIHHdwCsVy6vnl+MJhsTs3X0xhaFFu
         l92cEYL5ejr51oLYOhQEj2o9ij609G8BHMS1kEzA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 04/13] xdp: add multi-buff support to xdp_return_{buff/frame}
Date:   Fri,  2 Oct 2020 16:42:02 +0200
Message-Id: <e9eea8664769bd6d27e12574580655845de2d1eb.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

