Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C003159B66
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 22:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgBKVly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 16:41:54 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.104]:10098 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgBKVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 16:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581457309;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=v3anE5b2foHTOj2GJ8iyGcibKBz905Yhze/9YVRQ/TQ=;
        b=T7u/i1e3RmfgbspBSEr7DxIzL7WVAgF3PK3cr45pNCDLR/23YnmLoZ9ROXwnwLeju2
        m9vsIr9VrBkUUA8pD7pWA0LIY4/vBX4TAV4c15hhdK09QY0rAPJxnjBAwDyMdC8O1HIk
        g2JNinDEhm5nO1/klr8qxKr74GoSdUy1KcIA8OeHMFPm5PODfOGzSgQ9KcCVMRrkQEZl
        iRW/W67nTFUIzqVrirgz758Pefbi/+K0oBwtZSDJKZ/YBgEbPaUuIenUg5nukXC/6eAQ
        S+JgLDJqu/cQNK2ZtmD+r9GFQqgOIZ9u8cMhs1ASfOjZeyFYh1bFZVp+W5YIFhcMm2vQ
        xyDg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M0P2mp10IM"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1BLfZ0EJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 11 Feb 2020 22:41:35 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: [PATCH 03/14] net: davicom: dm9000: allow to pass MAC address through mac_addr module parameter
Date:   Tue, 11 Feb 2020 22:41:20 +0100
Message-Id: <4e11dd4183da55012198824ca7b8933b1eb57e4a.1581457290.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1581457290.git.hns@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is needed to give the MIPS Ingenic CI20 board a stable MAC address
which can be optionally provided by vendor U-Boot.

For get_mac_addr() we use an adapted copy of from ksz884x.c which
has very similar functionality.

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

