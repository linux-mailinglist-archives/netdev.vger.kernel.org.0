Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AB73459DA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCWIgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:36:14 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62071 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhCWIfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616488541; x=1648024541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eP8Cr4YL2a0w4yi+/hKrPPiwiCM67cN8kXpAO4EXfHk=;
  b=QnV544ynisfdBu1mZsQ3ws27VkyJj7Xmeo/foOawyjLpqcAoXkqTpQ8q
   UNeyXuTZQInTinNDhOvNnaasXP3O9wu5OxTS4yCFih+CfwwhVEDLDB8BP
   1b8VURN4jGXWD6mfUoMi8HpCWdVYov2UXESpE5p3LnXz30/Qbwd6DZ+YP
   a+RNRfYKWOM89RXcqKIsUAR2wmSkUODU1JvS74Wq1JJBQXe1zQSNVb+wj
   svWJIwKqr1IAk/QHkJ2VYnVSrjpLeNi3hcpjIEkstsHrwfrSpvTi3KpIc
   a3BDvPhJNiIWgL1tNWYuLy2t2FmCE7oQicY1P8CVGGgEk9MjfYRRgqA0J
   w==;
IronPort-SDR: JManP+JtJBQ0goaqSvSS9fR0qYHupoIfOzEivi6ZKW2BCW4C7frnFzR/KLmie3225VqH5edhc9
 7lgeZe7L2JD8KPs7q+3FE/29OnJLgPhKnZ3AwiShoo8yakkAD39SegLjWtlylBCXFWvYg5k/TC
 dSfhf1ekEddoND05nfT+InAoFxgoAGZS23luzcdrLhFA3xvT9ujCjqBVwhc8HrkBF+HuUAVOdp
 w76p2d4EcaBYNCmknp0XyQ2WtKvxa0UjjAklsH+/yJFBHMltU5ua8XMYMsJ8TkL4x8FBcOP6s3
 ET8=
X-IronPort-AV: E=Sophos;i="5.81,271,1610434800"; 
   d="scan'208";a="120052736"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2021 01:35:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 01:35:40 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 23 Mar 2021 01:35:37 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/2] net: ocelot: Simplify MRP deletion
Date:   Tue, 23 Mar 2021 09:33:47 +0100
Message-ID: <20210323083347.1474883-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
References: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the driver will always be notified that the role is deleted
before the ring is deleted, then we don't need to duplicate the logic of
cleaning the resources also in the delete function.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_mrp.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index c3cbcaf64bb2..08b481a93460 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -154,7 +154,6 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int i;
 
 	if (!ocelot_port)
 		return -EOPNOTSUPP;
@@ -162,23 +161,8 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
 	if (ocelot_port->mrp_ring_id != mrp->ring_id)
 		return 0;
 
-	ocelot_mrp_del_vcap(ocelot, port);
-	ocelot_mrp_del_vcap(ocelot, port + ocelot->num_phys_ports);
-
 	ocelot_port->mrp_ring_id = 0;
 
-	for (i = 0; i < ocelot->num_phys_ports; ++i) {
-		ocelot_port = ocelot->ports[i];
-
-		if (!ocelot_port)
-			continue;
-
-		if (ocelot_port->mrp_ring_id != 0)
-			goto out;
-	}
-
-	ocelot_mrp_del_mac(ocelot, ocelot->ports[port]);
-out:
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_mrp_del);
-- 
2.30.1

