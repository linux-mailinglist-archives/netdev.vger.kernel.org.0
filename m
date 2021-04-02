Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B86352ABF
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhDBMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:43:05 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58022 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBMnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617367381; x=1648903381;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v/XBwblsk6ka4r034i2TV6vSLD16TeoQ1aF/DeH7Blk=;
  b=Bo+1ANKg622Os+X/1ccWjmaoRUHad7cBcks02+lOYJKpFmqK6md3rkFv
   ffX3mWccHeq8kzje0lIbmW0tNMX8nizD74EKGOWL7o2pYcKjegWCuZc2U
   /hwk5DCqMA9mJbVNqSbpxAn04HKGgxKCBxsay8Pt8ys9cNs0txUIyV18m
   TEp8KlVJQhV0em8jL24IoSMlcdsGk+lI85b0pNGw7vrBuvKblO8nSZSgk
   m9eQYnSYUHYz+Z5/YPiQgbRFf6QYn3c41E7JlaxEmrGqsoTN7+bisUtzC
   A3aFiC5O5iRJExUYZzDgyppc7gKkeOpR7ORlkpZCGh6JgpqH1NPCaUEW0
   A==;
IronPort-SDR: SG0acqpU11YVby3uKUqMG37KIKljEPir/udTX+/zlgx8gdvKVZT9H4aBo3HgNXCGKyX3pJNjoj
 KgM65HHbC6um+AlilDhDIsihb+qaL328YTY4FaR+fB7WbEZZqiAPSYusGxgqD84KWfHCNYTvB4
 9wAfOUcpYMd1Qnjp5xSJZxK0AcGP6Wp2FUyl9PIKdJJKKCa2Pn277aPlOsWBPfE0IWJIZUfIy3
 1Hw5OD0RQT1aVMwlDiKfLbAPbaMhElUZoJpYZFMSGH8Xu842suQhtUc/gCDDHRdHueIec5QGJx
 l8Y=
X-IronPort-AV: E=Sophos;i="5.81,299,1610434800"; 
   d="scan'208";a="121558690"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2021 05:43:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 05:43:01 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 2 Apr 2021 05:42:59 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 1/1] net: macb: restore cmp registers on resume path
Date:   Fri, 2 Apr 2021 15:42:53 +0300
Message-ID: <20210402124253.3027-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restore CMP screener registers on resume path.

Fixes: c1e85c6ce57ef ("net: macb: save/restore the remaining registers and features")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f56f3dbbc015..ffd56a23f8b0 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3269,6 +3269,9 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	bool cmp_b = false;
 	bool cmp_c = false;
 
+	if (!macb_is_gem(bp))
+		return;
+
 	tp4sp_v = &(fs->h_u.tcp_ip4_spec);
 	tp4sp_m = &(fs->m_u.tcp_ip4_spec);
 
@@ -3637,6 +3640,7 @@ static void macb_restore_features(struct macb *bp)
 {
 	struct net_device *netdev = bp->dev;
 	netdev_features_t features = netdev->features;
+	struct ethtool_rx_fs_item *item;
 
 	/* TX checksum offload */
 	macb_set_txcsum_feature(bp, features);
@@ -3645,6 +3649,9 @@ static void macb_restore_features(struct macb *bp)
 	macb_set_rxcsum_feature(bp, features);
 
 	/* RX Flow Filters */
+	list_for_each_entry(item, &bp->rx_fs_list.list, list)
+		gem_prog_cmp_regs(bp, &item->fs);
+
 	macb_set_rxflow_feature(bp, features);
 }
 
-- 
2.25.1

