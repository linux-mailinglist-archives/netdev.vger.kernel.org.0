Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF49D340E60
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhCRTfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:35:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3700 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhCRTfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616096122; x=1647632122;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hcAX1VIJNIQGdBt4c4fzQbY2cP7BNQHp0GpCszwR51o=;
  b=ag3G88vPY3Y5K7VYAAvFbRP2jHuMeGy0zkhlbfwBSIpEt3manpJjalQ2
   UZIapNZv3pm7meWlMHNBm0+SjZOupXBPlxtf0LiFtmkS7y+Se54Li8gip
   IbZIteUchhloKBTRB7EROyklzVbC3i/yarC0wtzTXUT2EB0E8Yo4KE6tp
   cL+XRz/DJzxCf3IYs+mtr/fpTjMbypuRuiTg6oSUDhWkNn32PNE67n8nO
   1MwyoQhxIz/h41EMzvxeiizzqiwNiwej3NII3DPkOodRCGHmJnmTWfgFy
   +rHqZDIc7OTAufngydHTj+ml2NKQY+zn8pSRJb+NBwUk4mliG6TVWjB9u
   Q==;
IronPort-SDR: IzIT7yhQHQYGT9W8wtUL0eKsAAa3908GD+MVGxcCAKe/oXhXpX9KjhvTNdwWbnRheBCq4qySYo
 KVPQQljZd4/wXaYSDhEvihRzdklZiKWph1pQlAM3mparGa+AYY/e7c0WhKMHXPs19DYH78Z9Eh
 M7lS+RaF2+cQSV68RLt4pXNnq5P+uzt7IpuS1avXuNe6YQYcCvNpxjMqHDK71rKyci+p/odG3x
 6bbmrCh1aQnVFAOU2nRbTj2PlXNKynwJDKE2jOmunTkVxzYcFsu1qYk9WQjMwrQovGNUdHjGlu
 pBI=
X-IronPort-AV: E=Sophos;i="5.81,259,1610434800"; 
   d="scan'208";a="119553925"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2021 12:35:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 12:35:21 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 18 Mar 2021 12:35:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: ocelot: Fix deletetion of MRP entries from MAC table
Date:   Thu, 18 Mar 2021 20:29:38 +0100
Message-ID: <20210318192938.504549-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a MRP ring was deleted or disabled, the driver was iterating over
the ports to detect if any other MPR rings exists and in case it didn't
exist it would delete the MAC table entry. But the problem was that it
used the last iterated port to delete the MAC table entry and this could
be a NULL port.

The fix consists of using the port on which the function was called.

Fixes: 7c588c3e96e9733a ("net: ocelot: Extend MRP")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_mrp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 439129a65b71..c3cbcaf64bb2 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -177,7 +177,7 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
 			goto out;
 	}
 
-	ocelot_mrp_del_mac(ocelot, ocelot_port);
+	ocelot_mrp_del_mac(ocelot, ocelot->ports[port]);
 out:
 	return 0;
 }
@@ -251,7 +251,7 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 			goto out;
 	}
 
-	ocelot_mrp_del_mac(ocelot, ocelot_port);
+	ocelot_mrp_del_mac(ocelot, ocelot->ports[port]);
 out:
 	return 0;
 }
-- 
2.30.1

