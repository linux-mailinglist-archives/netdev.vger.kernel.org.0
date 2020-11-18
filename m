Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4842B85C2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgKRUie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:38:34 -0500
Received: from mailout02.rmx.de ([62.245.148.41]:46406 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgKRUid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:38:33 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4Cbvll6pCgzNljV;
        Wed, 18 Nov 2020 21:38:27 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CbvkC0SJxz2xDh;
        Wed, 18 Nov 2020 21:37:07 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.25) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 18 Nov
 2020 21:33:17 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 05/12] net: dsa: microchip: ksz9477: move chip reset to ksz9477_switch_init()
Date:   Wed, 18 Nov 2020 21:30:06 +0100
Message-ID: <20201118203013.5077-6-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201118203013.5077-1-ceggers@arri.de>
References: <20201118203013.5077-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.25]
X-RMX-ID: 20201118-213715-4CbvkC0SJxz2xDh-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The next patch will add basic interrupt support. Chip reset must be
performed before requesting the IRQ, so move this from ksz9477_setup()
to ksz9477_init().

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
index abfd3802bb51..c0b4cf66c904 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -1345,19 +1345,12 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 static int ksz9477_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	int ret = 0;
 
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
 				       dev->num_vlans, GFP_KERNEL);
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
-	ret = ksz9477_reset_switch(dev);
-	if (ret) {
-		dev_err(ds->dev, "failed to reset switch\n");
-		return ret;
-	}
-
 	/* Required for port partitioning. */
 	ksz9477_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
 		      true);
@@ -1537,10 +1530,16 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
-	int i;
+	int i, ret;
 
 	dev->ds->ops = &ksz9477_switch_ops;
 
+	ret = ksz9477_reset_switch(dev);
+	if (ret) {
+		dev_err(dev->dev, "failed to reset switch\n");
+		return ret;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(ksz9477_switch_chips); i++) {
 		const struct ksz_chip_data *chip = &ksz9477_switch_chips[i];
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

