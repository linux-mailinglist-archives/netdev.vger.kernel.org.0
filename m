Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18B515ECBE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390788AbgBNQHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:07:50 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:10762 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390768AbgBNQHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581696467;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=QeKv3h6vRqJ4wCD4+A7gbij8dajmVYg9hOuzCvCzqmo=;
        b=nuijQscJhPn8JCg+cNCVkD3gDvPqs3lQTxvPAmAk/HBZkedfnBTtckAwF5XDylUt5p
        w+WQ/brEVOSKOYVNVzkThCcJ9Rrbqu/BrSEQwj6dePmJvpDDiTucXAkqUgWQppPrPcwC
        DlUolY0z4lg5xdibIM30BNbgkMaNXcQIaGIPaXfmQfc7kXtmBu+h2fAeunVaBVc4e1d4
        G7ndPSVbGV2g/1Qcvj/yOZk77fZH9q7jZ9KnzTjHnku246EBZmwJ1NdmPhGWrsydNg0f
        CNNzamnDsEmaA/wiHWVBd51Ewlt/3nar96MZGzp1X65S6WbOfIWocGtOKNvhs4Cs0B+1
        x32g==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7OMfsfQx3"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1EG7ZFkL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 14 Feb 2020 17:07:35 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Andrew Lunn <andrew@lunn.ch>, Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH v2] net: davicom: dm9000: allow to pass MAC address through mac_addr module parameter
Date:   Fri, 14 Feb 2020 17:07:35 +0100
Message-Id: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MIPS Ingenic CI20 board is shipped with a quite old u-boot
(ci20-v2013.10 see https://elinux.org/CI20_Dev_Zone). This passes
the MAC address through dm9000.mac_addr=xx:xx:xx:xx:xx:xx
kernel module parameter to give the board a fixed MAC address.

This is not processed by the dm9000 driver which assigns a random
MAC address on each boot, making DHCP assign a new IP address
each time.

So we add a check for the mac_addr module parameter as a last
resort before assigning a random one. This mechanism can also
be used outside of u-boot to provide a value through modprobe
config.

To parse the MAC address in a new function get_mac_addr() we
use an copy adapted from the ksz884x.c driver which provides
the same functionality.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/net/ethernet/davicom/dm9000.c | 42 +++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 1ea3372775e6..7402030b0352 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1409,6 +1409,43 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 	return pdata;
 }
 
+static char *mac_addr = ":";
+module_param(mac_addr, charp, 0);
+MODULE_PARM_DESC(mac_addr, "MAC address");
+
+static void get_mac_addr(struct net_device *ndev, char *macaddr)
+{
+	int i = 0;
+	int j = 0;
+	int got_num = 0;
+	int num = 0;
+
+	while (j < ETH_ALEN) {
+		if (macaddr[i]) {
+			int digit;
+
+			got_num = 1;
+			digit = hex_to_bin(macaddr[i]);
+			if (digit >= 0)
+				num = num * 16 + digit;
+			else if (':' == macaddr[i])
+				got_num = 2;
+			else
+				break;
+		} else if (got_num) {
+			got_num = 2;
+		} else {
+			break;
+		}
+		if (got_num == 2) {
+			ndev->dev_addr[j++] = (u8)num;
+			num = 0;
+			got_num = 0;
+		}
+		i++;
+	}
+}
+
 /*
  * Search DM9000 board, allocate space and register it
  */
@@ -1679,6 +1716,11 @@ dm9000_probe(struct platform_device *pdev)
 			ndev->dev_addr[i] = ior(db, i+DM9000_PAR);
 	}
 
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		mac_src = "param";
+		get_mac_addr(ndev, mac_addr);
+	}
+
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		inv_mac_addr = true;
 		eth_hw_addr_random(ndev);
-- 
2.23.0

