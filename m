Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D819435F23F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348962AbhDNLWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:22:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:42582 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348949AbhDNLWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618399332; x=1649935332;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3hsmB1pC45gEMTmJOeR/FghN72S4zw/MUaNuw40oaz4=;
  b=jPXOdNseZL9H9WXc5YV7jIjSed7BsuqcaHmyRqXjV3pMw2yHFZYjd85F
   z0ql+O1O99V9z0eQNgTpuXH43NwquMsCaP/Q7hDUtHtxgG8Wu+g94KGlr
   4rwZkYzot0GUlYUEt/cleeeg8ZLfksG3N+13VJFaHeW65Fuj2XDo3sK33
   r3LdOE2svDpPllx4eAe6PzhmwiCR+DUItrzpm6zgryEJLDVnAn9Zo/iPN
   i+mqseEgtz0ESEeuZyp8XokJaacPHfzyzsQgXEzd8uzfmZzSHZSpdoO//
   5BgKpZEGDSHFXNQ2qo6a4pQjvNUeRfxgTqJQ4VSQ1ktnx/gayFsBhH6pg
   g==;
IronPort-SDR: t8rSU63WkdyYxoNSKygb1K3HD2vZX5+ql9Qfxnrlx5Bres0j8sgEPlUVLm8lOi/tdjZ2nwA19H
 wLrV5kyX03Z5dtMHlZvnJVPXrazAIN2eFpESeL2bL/x/AmOS1uRSLIBd6DXQOIYbUq7PVmqH2/
 q12kvSu7x0klniH28as2vr8DOyzH+JWCDDopm72dOMmmr86eYZss60pS71hHjgaBR4TRtUJ7zS
 +NTSSD0Lg86r6htWt0mbVxPKO8Xj77awD135oqejnUta8lPE/f4P9w7BZmARHh54oN36QVxRc9
 h0E=
X-IronPort-AV: E=Sophos;i="5.82,221,1613458800"; 
   d="scan'208";a="51077078"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2021 04:22:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 04:22:10 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 14 Apr 2021 04:21:54 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] net: macb: fix the restore of cmp registers
Date:   Wed, 14 Apr 2021 14:20:29 +0300
Message-ID: <20210414112029.86857-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a14d273ba159 ("net: macb: restore cmp registers on resume path")
introduces the restore of CMP registers on resume path. In case the IP
doesn't support type 2 screeners (zero on DCFG8 register) the
struct macb::rx_fs_list::list is not initialized and thus the
list_for_each_entry(item, &bp->rx_fs_list.list, list) loop introduced in
commit a14d273ba159 ("net: macb: restore cmp registers on resume path")
will access an uninitialized list leading to crash. Thus, initialize
the struct macb::rx_fs_list::list without taking into account if the
IP supports type 2 screeners or not.

Fixes: a14d273ba159 ("net: macb: restore cmp registers on resume path")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c36722541bc4..0db538d089b1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3926,6 +3926,7 @@ static int macb_init(struct platform_device *pdev)
 	reg = gem_readl(bp, DCFG8);
 	bp->max_tuples = min((GEM_BFEXT(SCR2CMP, reg) / 3),
 			GEM_BFEXT(T2SCR, reg));
+	INIT_LIST_HEAD(&bp->rx_fs_list.list);
 	if (bp->max_tuples > 0) {
 		/* also needs one ethtype match to check IPv4 */
 		if (GEM_BFEXT(SCR2ETH, reg) > 0) {
@@ -3938,7 +3939,6 @@ static int macb_init(struct platform_device *pdev)
 			/* Filtering is supported in hw but don't enable it in kernel now */
 			dev->hw_features |= NETIF_F_NTUPLE;
 			/* init Rx flow definitions */
-			INIT_LIST_HEAD(&bp->rx_fs_list.list);
 			bp->rx_fs_list.count = 0;
 			spin_lock_init(&bp->rx_fs_lock);
 		} else
-- 
2.25.1

