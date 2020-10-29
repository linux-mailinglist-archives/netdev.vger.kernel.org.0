Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5787429F485
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 20:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgJ2TJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 15:09:36 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58626 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2TJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 15:09:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09TJ9AYE086622;
        Thu, 29 Oct 2020 14:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603998550;
        bh=98LQ/K/4JWA4RQGtsstxjKLqHusEqhxMQVJCpeQvN10=;
        h=From:To:CC:Subject:Date;
        b=fXaqcHV29wwJ/Z2yafPDiBzOT7CUhLr+Pv0eD5pnDoxDeRi99mjSoyJlgUn1/12qH
         aTiu5GD8Z0ltj63WeIEE/ZH/gnQQdy0tVBhWqXPm5DJZIeVOo1VhKbQK6DY1J5MuIU
         2w74HG/dfb7AkiDvYgCiXvv5+g7NpUeFziHA/vFo=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09TJ9Aj8118103
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 14:09:10 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 29
 Oct 2020 14:09:10 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 29 Oct 2020 14:09:10 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09TJ99s1083876;
        Thu, 29 Oct 2020 14:09:09 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: cpsw: disable PTPv1 hw timestamping advertisement
Date:   Thu, 29 Oct 2020 21:09:10 +0200
Message-ID: <20201029190910.30789-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TI CPTS does not natively support PTPv1, only PTPv2. But, as it
happens, the CPTS can provide HW timestamp for PTPv1 Sync messages, because
CPTS HW parser looks for PTP messageType id in PTP message octet 0 which
value is 0 for PTPv1. As result, CPTS HW can detect Sync messages for PTPv1
and PTPv2 (Sync messageType = 0 for both), but it fails for any other PTPv1
messages (Delay_req/resp) and will return PTP messageType id 0 for them.

The commit e9523a5a32a1 ("net: ethernet: ti: cpsw: enable
HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter") added PTPv1 hw timestamping
advertisement by mistake, only to make Linux Kernel "timestamping" utility
work, and this causes issues with only PTPv1 compatible HW/SW - Sync HW
timestamped, but Delay_req/resp are not.

Hence, fix it disabling PTPv1 hw timestamping advertisement, so only PTPv1
compatible HW/SW can properly roll back to SW timestamping.

Fixes: e9523a5a32a1 ("net: ethernet: ti: cpsw: enable HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 1 -
 drivers/net/ethernet/ti/cpsw_priv.c    | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 4d02c5135611..4619c3a950b0 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -728,7 +728,6 @@ int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 		(1 << HWTSTAMP_TX_ON);
 	info->rx_filters =
 		(1 << HWTSTAMP_FILTER_NONE) |
-		(1 << HWTSTAMP_FILTER_PTP_V1_L4_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 51cc29f39038..31c5e36ff706 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -639,13 +639,10 @@ static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_NTP_ALL:
-		return -ERANGE;
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
-		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		break;
+		return -ERANGE;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-- 
2.17.1

