Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9780555B3D4
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiFZTm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 15:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFZTmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 15:42:55 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B273208;
        Sun, 26 Jun 2022 12:42:53 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A327922248;
        Sun, 26 Jun 2022 21:42:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656272571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DG1TtMgcwFPG6kIPYW21bB1MOFqKbpqr3fn3fLeFTcU=;
        b=TSj13tGk7jUP8vRP1Keg1Griw5QTYTnm7tjZixfTJWAaz481wHvxRxCZ/EaaRMXQRGW6AK
        9PkFzlr8jpnOL9mthTHK+LSt6NGempahXaef/Ljcue9YYJ2yeYhm7s8uSjSp6NwLwJQ2UX
        IwaeqsdgHG+MjZp1iEsFeHu+CirzN1U=
From:   Michael Walle <michael@walle.cc>
To:     Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= <clement.perrochaud@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 2/2] NFC: nxp-nci: Don't issue a zero length i2c_master_read()
Date:   Sun, 26 Jun 2022 21:42:43 +0200
Message-Id: <20220626194243.4059870-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220626194243.4059870-1-michael@walle.cc>
References: <20220626194243.4059870-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are packets which doesn't have a payload. In that case, the second
i2c_master_read() will have a zero length. But because the NFC
controller doesn't have any data left, it will NACK the I2C read and
-ENXIO will be returned. In case there is no payload, just skip the
second i2c master read.

Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nfc/nxp-nci/i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 9c80d5a6d56b..c9361b5249b7 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -162,6 +162,9 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 
 	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
 
+	if (!header.plen)
+		return 0;
+
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
 	if (r < 0) {
 		nfc_err(&client->dev, "I2C receive error %pe\n", ERR_PTR(r));
-- 
2.30.2

