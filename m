Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26241C4082
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgEDQwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729724AbgEDQwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:52:51 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2AC061A0E;
        Mon,  4 May 2020 09:52:51 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 190E822FF5;
        Mon,  4 May 2020 18:52:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588611169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s3MJel5dUV3iL+D3nK/MzZnYREoru8RurZpnEykOVsQ=;
        b=t9zuEan8+Y5jKryk55vfcPI5vOFxLGri2s2STZlooSNGGkQqD/3NuI4nMpimzXixTW0zlu
        8oIX9gF/JCn5vb2Ww1SDCUEq0HP98Pe7rGQyHQo0QgmmFx6DOUB7RvIhfwXlFBCqdQiGu4
        H/PN+kTxkxOReVCPH8UZFx7FloB72i4=
From:   Michael Walle <michael@walle.cc>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RESEND net-next] net: dsa: felix: allow the device to be disabled
Date:   Mon,  4 May 2020 18:52:28 +0200
Message-Id: <20200504165228.12787-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 190E822FF5
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.858];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[11];
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
This was part of a two patch series. The second patch is already merged.
This patch was never picked up, although it was Acked-by: David Miller,
see:
https://lore.kernel.org/netdev/20200314.205335.907987569817755804.davem@davemloft.net/

Since there is no more dependency, this patch could go through the
net-next queue.

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

