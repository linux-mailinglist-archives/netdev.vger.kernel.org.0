Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B92A2D5450
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 08:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387745AbgLJHC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 02:02:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:62298 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbgLJHCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 02:02:43 -0500
IronPort-SDR: huzRDa0wOCzOplFyX6Eflwf1dfQNKtQZ4Bo2pV5gYg54fg/Y4f+CN6oLKjXWYs0qOQBCEEf3IM
 /NElaC/igY+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="161258205"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="161258205"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 23:02:20 -0800
IronPort-SDR: aNChuEw80pHWnwSbfDCPRNe/E5BtThRYwKLQ39drUC9NUGH1fEHRtqqHBQeXxg/tFiyebfylLI
 CzFQJWqISTkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="438230442"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.154.69])
  by fmsmga001.fm.intel.com with ESMTP; 09 Dec 2020 23:02:18 -0800
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     zyjzyj2000@gmail.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>, Ye Dong <dong.ye@intel.com>
Subject: [PATCH v3 1/1] xdp: avoid calling kfree twice
Date:   Thu, 10 Dec 2020 23:26:10 -0500
Message-Id: <20201211042610.71081-1-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function xdp_umem_pin_pages, if npgs != umem->npgs and
npgs >= 0, the function xdp_umem_unpin_pages is called. In this
function, kfree is called to handle umem->pgs, and then in the
function xdp_umem_pin_pages, kfree is called again to handle
umem->pgs. Eventually, to umem->pgs, kfree is called twice.

Since umem->pgs is set to NULL after the first kfree, the second
kfree would not trigger call trace.

Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
CC: Ye Dong <dong.ye@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>
---
 net/xdp/xdp_umem.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 56a28a686988..01b31c56cead 100644
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
+		return (int)npgs;
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

