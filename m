Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEF318781A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCQDW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:22:29 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35921 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgCQDW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:22:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id i13so11141122pfe.3
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6p7ORemOwYnN5GBVOw0yO88C+wuJH7M87JpzoyT6uZo=;
        b=b7nBsuIYSf8w++pqmSQlaIoH4LlsU0TFE3UbaTzSnhscMNBL2YLMtUCpYzvFkedP1d
         Wdy8jbnAi4PsSR/cdA1nA9X0RERtmDjuNm/fSRtJhq2+XIbxATuCfdo/7wAZn8g56KPj
         olFcBCew4TZ1GpRTWidiepUYKaOEYHLxOSEaBAkXnPo13sHhGrbNWjyebjGbT6H9DpBK
         otC+/deVj9eD80jOZfXGxSgCKBQ9pZHIMDb3IPKYdNUnibpe3vOCr+vXJ+yD2mkC4iTU
         gxUFrOagpSlHEtDXN3vFw5VllQbCfG8enTOa11vQiZxqIIoJD9HGcgZ1Fzy2E1CauRg7
         000Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6p7ORemOwYnN5GBVOw0yO88C+wuJH7M87JpzoyT6uZo=;
        b=qDAZNGhYlMKPXskMPmYaooi62+DhPZ/WOZNdk/NIt7zXlYl66m2xTURNNuSmT7oz0q
         JwSCBNso8DwEGtOr8PGBeqHVQPI6RtscyIUAPlXmy6B25fIcb5ZmuGh8l/ejcyQOfRTl
         knSVsZPDATMj7ipd/YR73J5ICAcyd+/YvKZ7p5QcFlndjO8leiV5raxpud24WFUaQ1b/
         Ed2Y7u0w5Oc+iyDp/aRCsoug3II5eE24qDxnqfj1W18d1zczaVgHbwpteKX6AebJg3LC
         ZIDrQii5hzw0llycR7/GGcodkYnSAvvvveyxQ4MbxKTLULsrIgWp7ssXz5wB+K6aqf/x
         s21g==
X-Gm-Message-State: ANhLgQ1bwE1MjvqXqLaGfXzweRy4F2szhwxr+ubOV3tPa5MCkeuOvY6d
        zrpD1eWLImJ+p/8cwzKd7WTwuRMlszk=
X-Google-Smtp-Source: ADFU+vsW5qrwb3Llg5DbdXNdzEhsSqSiVxx9rMALIuKZw0BuoIZBNJw0BJdcafJzRibsoKyKks4+Hg==
X-Received: by 2002:a63:fc18:: with SMTP id j24mr2895776pgi.16.1584415346941;
        Mon, 16 Mar 2020 20:22:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f8sm1185639pfq.178.2020.03.16.20.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:22:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 4/5] ionic: print data for unknown xcvr type
Date:   Mon, 16 Mar 2020 20:22:09 -0700
Message-Id: <20200317032210.7996-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't recognize the transceiver type, set the xcvr type
and data length such that ethtool can at least print the first
256 bytes and the reader can figure out why the transceiver
is not recognized.

While we're here, we can update the phy_id type values to use
the enum values in sfp.h.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index a233716eac29..6996229facfd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -3,6 +3,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/sfp.h>
 
 #include "ionic.h"
 #include "ionic_bus.h"
@@ -677,23 +678,27 @@ static int ionic_get_module_info(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_dev *idev = &lif->ionic->idev;
 	struct ionic_xcvr_status *xcvr;
+	struct sfp_eeprom_base *sfp;
 
 	xcvr = &idev->port_info->status.xcvr;
+	sfp = (struct sfp_eeprom_base *) xcvr->sprom;
 
 	/* report the module data type and length */
-	switch (xcvr->sprom[0]) {
-	case 0x03: /* SFP */
+	switch (sfp->phys_id) {
+	case SFF8024_ID_SFP:
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 		break;
-	case 0x0D: /* QSFP */
-	case 0x11: /* QSFP28 */
+	case SFF8024_ID_QSFP_8436_8636:
+	case SFF8024_ID_QSFP28_8636:
 		modinfo->type = ETH_MODULE_SFF_8436;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
 		break;
 	default:
 		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
 			    xcvr->sprom[0]);
+		modinfo->type = 0;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 		break;
 	}
 
-- 
2.17.1

