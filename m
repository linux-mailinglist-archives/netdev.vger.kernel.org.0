Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2222D0CFD
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgLGJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:27:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:20076 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLGJ1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 04:27:33 -0500
IronPort-SDR: a8WIbuNHgOCu+O1teYgz589xkxl0cKSe4Yf4halXgbQGC0g6WBFffsaY29SoIpLt4OLG0H8aPa
 Bc61j8pVeT/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="258380259"
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="258380259"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 01:26:41 -0800
IronPort-SDR: OoCEfBo+4cO5i8M49VOtwRIdqSJTMorUHmQ4SgaVw/l/hNQaRBzLLGtF0ZwloghvjNL7ACq1W8
 dU0A91Ag65fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="317047999"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.154.69])
  by fmsmga008.fm.intel.com with ESMTP; 07 Dec 2020 01:26:39 -0800
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     zyjzyj2000@gmail.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Subject: [PATCH 1/1] xdp: avoid calling kfree twice
Date:   Tue,  8 Dec 2020 01:50:36 -0500
Message-Id: <20201208065036.9458-1-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

In the function xdp_umem_pin_pages, if npgs != umem->npgs and
npgs >= 0, the function xdp_umem_unpin_pages is called. In this
function, kfree is called to handle umem->pgs, and then in the
function xdp_umem_pin_pages, kfree is called again to handle
umem->pgs. Eventually, umem->pgs is freed twice.

Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 net/xdp/xdp_umem.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 56a28a686988..ff5173f72920 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -97,7 +97,6 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 {
 	unsigned int gup_flags = FOLL_WRITE;
 	long npgs;
-	int err;
 
 	umem->pgs = kcalloc(umem->npgs, sizeof(*umem->pgs),
 			    GFP_KERNEL | __GFP_NOWARN);
@@ -112,20 +111,14 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 	if (npgs != umem->npgs) {
 		if (npgs >= 0) {
 			umem->npgs = npgs;
-			err = -ENOMEM;
-			goto out_pin;
+			xdp_umem_unpin_pages(umem);
+			return -ENOMEM;
 		}
-		err = npgs;
-		goto out_pgs;
+		kfree(umem->pgs);
+		umem->pgs = NULL;
+		return npgs;
 	}
 	return 0;
-
-out_pin:
-	xdp_umem_unpin_pages(umem);
-out_pgs:
-	kfree(umem->pgs);
-	umem->pgs = NULL;
-	return err;
 }
 
 static int xdp_umem_account_pages(struct xdp_umem *umem)
-- 
2.18.4

