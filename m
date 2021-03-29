Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8A34CC02
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhC2Iy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235965AbhC2IwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 04:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41EA960234;
        Mon, 29 Mar 2021 08:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617007944;
        bh=Hlopmtsyvj627ObnwAtg6OK1EI2+m3QH4PNmFvmzOEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge+fha9gZEttMCR9Vvgm9HoOX6KalFNLKLs5E/HZ5RgvS4cd0Q8Kbe2AkQT3bKSBQ
         1p5FcYcqgETfLsiUXl5YRVq1anHCj1pJFciZr8LaCmewEfi3eydO6nfsQKK25yQ1hB
         8YBG378Rsi7Zfwr8lDtv1RANdrEpJF4aQZ6YY4sSl4RAxeHi2koz9NOSaiuJGftdsN
         zu8Aj8kU3i5VMe98hdBBqOiSS0G8ocGD6uPzt30ZaAnO6wOrqsvOQzABzM0a32JgXY
         WHT/YmO/gObiDLWTZXtwERQLBAgeZ1039Op3SxxOKoP5XAqkIW36+yY/MQyW7LbgLY
         S6837mhlVGDNQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-next v1 2/5] RDMA/bnxt_re: Create direct symbolic link between bnxt modules
Date:   Mon, 29 Mar 2021 11:52:09 +0300
Message-Id: <20210329085212.257771-3-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329085212.257771-1-leon@kernel.org>
References: <20210329085212.257771-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Convert indirect probe call to its direct equivalent to create
symbols link between RDMA and netdev modules. This will give
us an ability to remove custom module reference counting that
doesn't belong to the driver.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 7 +------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 2 --
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 1 +
 4 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index b30d37f0bad2..140c54ee5916 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -610,15 +610,10 @@ static void bnxt_re_dev_unprobe(struct net_device *netdev,
 
 static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
 {
-	struct bnxt *bp = netdev_priv(netdev);
 	struct bnxt_en_dev *en_dev;
 	struct pci_dev *pdev;
 
-	/* Call bnxt_en's RoCE probe via indirect API */
-	if (!bp->ulp_probe)
-		return ERR_PTR(-EINVAL);
-
-	en_dev = bp->ulp_probe(netdev);
+	en_dev = bnxt_ulp_probe(netdev);
 	if (IS_ERR(en_dev))
 		return en_dev;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a680fd9c68ea..3f0e4bde5dc9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12859,8 +12859,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!BNXT_CHIP_P4_PLUS(bp))
 		bp->flags |= BNXT_FLAG_DOUBLE_DB;
 
-	bp->ulp_probe = bnxt_ulp_probe;
-
 	rc = bnxt_init_mac_addr(bp);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to initialize mac address.\n");
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 1259e68cba2a..eb0314d7a9b1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1745,7 +1745,6 @@ struct bnxt {
 	(BNXT_CHIP_P4(bp) || BNXT_CHIP_P5(bp))
 
 	struct bnxt_en_dev	*edev;
-	struct bnxt_en_dev *	(*ulp_probe)(struct net_device *);
 
 	struct bnxt_napi	**bnapi;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 64dbbb04b043..a918e374f3c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -491,3 +491,4 @@ struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
 	}
 	return bp->edev;
 }
+EXPORT_SYMBOL(bnxt_ulp_probe);
-- 
2.30.2

