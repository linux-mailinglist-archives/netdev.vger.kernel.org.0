Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC97716ABD1
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBXQk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:40:59 -0500
Received: from gateway20.websitewelcome.com ([192.185.47.18]:31855 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbgBXQk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:40:59 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id B4B5F400CF48D
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 09:26:44 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6GmwjSLet8vkB6GmwjNtWW; Mon, 24 Feb 2020 10:40:58 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hrfWrD6ykmYXrxjHBKM7oBIe+cgO0ZcseOe1AAzELdc=; b=K1iCDa4e5FalKLdAawEbGuW9TP
        sRwhpe6Qj4yKM0L/PnEnuBGZ4tjqt4zTy1sKf4NJ6t+w74Kfz1VAL8ZhwrWnpoW0PbXshJXes5vSq
        9EwkNrm6K5RuStGG3twEYNy+MV8xXcly/T3+EQFzsDbICVQR9qCRhMy6y8TL+47pvcFQeWozXWbbS
        d1+0KO0Q7u/qFVZA16ED2HOcoz34k3GpE7RmEPc8f1XghOPrt2jaWA09Hx9cdK+3SaRCll0PTnNse
        +LsJWWBpxh1Xa2nQEq+6ATwhFdyvoiYM6azb0zh8Y7RnHyG3fa2vDHp4JlI0dmYNeokTpRxEBOzT7
        aBCiXl9Q==;
Received: from [200.68.140.135] (port=31080 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6Gmu-002uiO-NN; Mon, 24 Feb 2020 10:40:56 -0600
Date:   Mon, 24 Feb 2020 10:43:46 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] freescale: Replace zero-length array with
 flexible-array member
Message-ID: <20200224164346.GA4488@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.135
X-Source-L: No
X-Exim-ID: 1j6Gmu-002uiO-NN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.135]:31080
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 89
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h    | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 2 +-
 drivers/net/ethernet/freescale/fec.h            | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index dd4a227ffc7a..9938f7a5fc0a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -163,7 +163,7 @@ struct enetc_int_vector {
 	char name[ENETC_INT_NAME_MAX];
 
 	struct enetc_bdr rx_ring ____cacheline_aligned_in_smp;
-	struct enetc_bdr tx_ring[0];
+	struct enetc_bdr tx_ring[];
 };
 
 struct enetc_cls_rule {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 62554f28ce07..da134e211c1a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -588,7 +588,7 @@ struct tgs_gcl_data {
 	__le32		bth;
 	__le32		ct;
 	__le32		cte;
-	struct gce	entry[0];
+	struct gce	entry[];
 };
 
 struct enetc_cbd {
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index f79e57f735b3..bd898f5b4da5 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -584,7 +584,7 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
-	u64 ethtool_stats[0];
+	u64 ethtool_stats[];
 };
 
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
-- 
2.25.0

