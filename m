Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1527174DBF
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCAOpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgCAOpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:14 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4054F222C2;
        Sun,  1 Mar 2020 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073913;
        bh=Hrmtvo27/AI0RWBvbv240QwSJGJBpABFA/h/m48SisE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s62uVjNf/jparlAfWLHlNnVy1sxcY5V+gvbRZf++o5vsMSC3nBGpvh4vjtSNZSCZU
         vodGvrTthLopXwvGgzIT/tOIYBriXiu3QrZL8TmgFALEqQHPBUKgjIAN/bnSLEWRLk
         SiYrxr/DQQR4KRAnbEwQfdICS4RwAuxlgp0rKQO0=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Derek Chickles <dchickles@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>, netdev@vger.kernel.org,
        Raghu Vatsavayi <rvatsavayi@caviumnetworks.com>,
        Satanand Burla <sburla@marvell.com>
Subject: [PATCH net-next 05/23] net/liquidio: Delete non-working LIQUIDIO_PACKAGE check
Date:   Sun,  1 Mar 2020 16:44:38 +0200
Message-Id: <20200301144457.119795-6-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Size of LIQUIDIO_PACKAGE is 0 and it means that checks of package
version never worked, delete dead code.

Fixes: 3258124534f6 ("liquidio: Consolidate common functionality")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/cavium/liquidio/liquidio_common.h |  1 -
 drivers/net/ethernet/cavium/liquidio/octeon_console.c  | 10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/liquidio_common.h b/drivers/net/ethernet/cavium/liquidio/liquidio_common.h
index 2d61790c2e51..4da90757cd3f 100644
--- a/drivers/net/ethernet/cavium/liquidio/liquidio_common.h
+++ b/drivers/net/ethernet/cavium/liquidio/liquidio_common.h
@@ -25,7 +25,6 @@
 
 #include "octeon_config.h"
 
-#define LIQUIDIO_PACKAGE ""
 #define LIQUIDIO_BASE_MAJOR_VERSION 1
 #define LIQUIDIO_BASE_MINOR_VERSION 7
 #define LIQUIDIO_BASE_MICRO_VERSION 2
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
index dfc77507b159..cecc7642ad09 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
@@ -840,17 +840,11 @@ int octeon_download_firmware(struct octeon_device *oct, const u8 *data,
 		return -EINVAL;
 	}
 
-	if (strncmp(LIQUIDIO_PACKAGE, h->version, strlen(LIQUIDIO_PACKAGE))) {
-		dev_err(&oct->pci_dev->dev, "Unmatched firmware package type. Expected %s, got %s.\n",
-			LIQUIDIO_PACKAGE, h->version);
-		return -EINVAL;
-	}
-
-	if (memcmp(LIQUIDIO_BASE_VERSION, h->version + strlen(LIQUIDIO_PACKAGE),
+	if (memcmp(LIQUIDIO_BASE_VERSION, h->version,
 		   strlen(LIQUIDIO_BASE_VERSION))) {
 		dev_err(&oct->pci_dev->dev, "Unmatched firmware version. Expected %s.x, got %s.\n",
 			LIQUIDIO_BASE_VERSION,
-			h->version + strlen(LIQUIDIO_PACKAGE));
+			h->version);
 		return -EINVAL;
 	}
 
-- 
2.24.1

