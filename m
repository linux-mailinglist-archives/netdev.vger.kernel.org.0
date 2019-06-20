Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207964D4E6
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbfFTRYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:24:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:64663 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732013AbfFTRYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 13:24:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 10:24:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="359020335"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.110])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2019 10:24:39 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc:     bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH 03/11] xdp: add offset param to zero_copy_allocator
Date:   Thu, 20 Jun 2019 09:09:50 +0000
Message-Id: <20190620090958.2135-4-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620090958.2135-1-kevin.laatz@intel.com>
References: <20190620090958.2135-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an offset parameter for zero_copy_allocator.

This change is required for the unaligned chunk mode which will come later
in this patch set. The offset parameter is required for calculating the
original handle in unaligned mode since we can't easily mask back to it
like in the aligned case.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
---
 include/net/xdp.h |  3 ++-
 net/core/xdp.c    | 11 ++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0f25b3675c5c..ea801fd2bf98 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -53,7 +53,8 @@ struct xdp_mem_info {
 struct page_pool;
 
 struct zero_copy_allocator {
-	void (*free)(struct zero_copy_allocator *zca, unsigned long handle);
+	void (*free)(struct zero_copy_allocator *zca, unsigned long handle,
+			off_t off);
 };
 
 struct xdp_rxq_info {
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194f4f1f..a77a7162d213 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -322,7 +322,7 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
  * of xdp_frames/pages in those cases.
  */
 static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
-			 unsigned long handle)
+			 unsigned long handle, off_t off)
 {
 	struct xdp_mem_allocator *xa;
 	struct page *page;
@@ -353,7 +353,7 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		rcu_read_lock();
 		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
-		xa->zc_alloc->free(xa->zc_alloc, handle);
+		xa->zc_alloc->free(xa->zc_alloc, handle, off);
 		rcu_read_unlock();
 	default:
 		/* Not possible, checked in xdp_rxq_info_reg_mem_model() */
@@ -363,19 +363,20 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 
 void xdp_return_frame(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, false, 0);
+	__xdp_return(xdpf->data, &xdpf->mem, false, 0, 0);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame);
 
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
 {
-	__xdp_return(xdpf->data, &xdpf->mem, true, 0);
+	__xdp_return(xdpf->data, &xdpf->mem, true, 0, 0);
 }
 EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
 
 void xdp_return_buff(struct xdp_buff *xdp)
 {
-	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle);
+	__xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle,
+			xdp->data - xdp->data_hard_start);
 }
 EXPORT_SYMBOL_GPL(xdp_return_buff);
 
-- 
2.17.1

