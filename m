Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8525F183666
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 17:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgCLQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 12:43:39 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:37841 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCLQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 12:43:39 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4213522FAC;
        Thu, 12 Mar 2020 17:43:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1584031416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HS9Jluiw3aH4k9JB9HHtP7Vj2kevfscXj08g+xTVVFY=;
        b=g+uHbd3j4G8NKRgBCj3beTqKYGvZi/44UY29w7C1ZPxkdnBtQdiwWgoROMyCpoxtejYd7V
        T1diw/OyZs9D1AQdxOhb+Ftq5R8ydxUnSIvowKfRY0htWDNm12ok3DfUa+qVR2YTRfNhbx
        zAFprAgr3ByJV8kqKYSgvskzqy2sBFc=
From:   Michael Walle <michael@walle.cc>
To:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 1/2] net: dsa: felix: allow the device to be disabled
Date:   Thu, 12 Mar 2020 17:43:19 +0100
Message-Id: <20200312164320.22349-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 4213522FAC
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWELVE(0.00)[14];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[davemloft.net,gmail.com,lunn.ch,nxp.com,kernel.org,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no specific configuration of the felix switch in the device
tree, but only the default configuration (ie. given by the SoCs dtsi
file), the probe fails because no CPU port has been set. On the other
hand you cannot set a default CPU port because that depends on the
actual board using the switch.

[    2.701300] DSA: tree 0 has no CPU port
[    2.705167] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
[    2.711844] mscc_felix: probe of 0000:00:00.5 failed with error -22

Thus let the device tree disable this device entirely, like it is also
done with the enetc driver of the same SoC.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/dsa/ocelot/felix.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 69546383a382..531c7710063f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -699,6 +699,11 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	struct felix *felix;
 	int err;
 
+	if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
+		dev_info(&pdev->dev, "device is disabled, skipping\n");
+		return -ENODEV;
+	}
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "device enable failed\n");
-- 
2.20.1

