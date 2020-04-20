Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E2D1B18C8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgDTVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:51:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:51152 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgDTVv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:51:27 -0400
IronPort-SDR: xCtAvb3ln136SJI1LxUN9gJ58Oj09vVGgFwU08i6HrnXodnOWbfmV9kQlanU3Zh6RRrlMG7bZX
 gETkaHCOOs/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:51:26 -0700
IronPort-SDR: kItuYl/Jut0UTPu0t1YwviQESi6eTk8cWhkq0xz/PSQ6DeiOGgMJrIAaF9zCgN6wW1GdZ7Mkni
 JtqIpkAW8h2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="243965762"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2020 14:51:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id ECBF429A; Tue, 21 Apr 2020 00:51:22 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 4/5] net: bcmgenet: Use get_unligned_beXX() and put_unaligned_beXX()
Date:   Tue, 21 Apr 2020 00:51:20 +0300
Message-Id: <20200420215121.17735-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's convenient to use get_unligned_beXX() and put_unaligned_beXX() helpers
to get or set MAC instead of open-coded variants.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 86666e9ab3e7..2c9881032a24 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2702,9 +2702,8 @@ static void bcmgenet_umac_reset(struct bcmgenet_priv *priv)
 static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
 				 unsigned char *addr)
 {
-	bcmgenet_umac_writel(priv, (addr[0] << 24) | (addr[1] << 16) |
-			(addr[2] << 8) | addr[3], UMAC_MAC0);
-	bcmgenet_umac_writel(priv, (addr[4] << 8) | addr[5], UMAC_MAC1);
+	bcmgenet_umac_writel(priv, get_unaligned_be32(&addr[0]), UMAC_MAC0);
+	bcmgenet_umac_writel(priv, get_unaligned_be16(&addr[4]), UMAC_MAC1);
 }
 
 static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
@@ -2713,13 +2712,9 @@ static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
 	u32 addr_tmp;
 
 	addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC0);
-	addr[0] = addr_tmp >> 24;
-	addr[1] = (addr_tmp >> 16) & 0xff;
-	addr[2] = (addr_tmp >>	8) & 0xff;
-	addr[3] = addr_tmp & 0xff;
+	put_unaligned_be32(addr_tmp, &addr[0]);
 	addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC1);
-	addr[4] = (addr_tmp >> 8) & 0xff;
-	addr[5] = addr_tmp & 0xff;
+	put_unaligned_be16(addr_tmp, &addr[4]);
 }
 
 /* Returns a reusable dma control register value */
-- 
2.26.1

