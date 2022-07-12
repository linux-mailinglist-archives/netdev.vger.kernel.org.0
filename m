Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E965F572181
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiGLRAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiGLRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:00:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DFFCC031;
        Tue, 12 Jul 2022 10:00:24 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C884C22239;
        Tue, 12 Jul 2022 19:00:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657645222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HOAwmVQszaxxnTCQjg7ogOxAJJ9GlApKgxO5vP/luoM=;
        b=JWb7gi1lnqey1XfCQFXgNPtgb2P/lsdshHffdkfifUemQkE/RzpJYJsd3+Du7eZjndoyhl
        ZLHfWxgibKzfDHiYO7DDCTu9f1eE+YtBapY4bm+0Ex93PnvgIVRw6jLtR7kuStw9Xszdc8
        3DI0qElzEx5otJ5veddliJ9wiL0DQPc=
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] NFC: nxp-nci: add error reporting
Date:   Tue, 12 Jul 2022 19:00:10 +0200
Message-Id: <20220712170011.2990629-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
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

The PN7160 supports error notifications. Add the appropriate callbacks.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nfc/nxp-nci/core.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 518e2afb43a8..7c93d484dc1b 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -27,6 +27,9 @@
 			       NFC_PROTO_ISO14443_B_MASK | \
 			       NFC_PROTO_NFC_DEP_MASK)
 
+#define NXP_NCI_RF_PLL_UNLOCKED_NTF nci_opcode_pack(NCI_GID_RF_MGMT, 0x21)
+#define NXP_NCI_RF_TXLDO_ERROR_NTF nci_opcode_pack(NCI_GID_RF_MGMT, 0x23)
+
 static int nxp_nci_open(struct nci_dev *ndev)
 {
 	struct nxp_nci_info *info = nci_get_drvdata(ndev);
@@ -83,11 +86,42 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	return r;
 }
 
+static int nxp_nci_rf_pll_unlocked_ntf(struct nci_dev *ndev,
+				       struct sk_buff *skb)
+{
+	nfc_err(&ndev->nfc_dev->dev,
+		"PLL didn't lock. Missing or unstable clock?\n");
+
+	return 0;
+}
+
+static int nxp_nci_rf_txldo_error_ntf(struct nci_dev *ndev,
+				      struct sk_buff *skb)
+{
+	nfc_err(&ndev->nfc_dev->dev,
+		"RF transmitter couldn't start. Bad power and/or configuration?\n");
+
+	return 0;
+}
+
+static const struct nci_driver_ops nxp_nci_core_ops[] = {
+	{
+		.opcode = NXP_NCI_RF_PLL_UNLOCKED_NTF,
+		.ntf = nxp_nci_rf_pll_unlocked_ntf,
+	},
+	{
+		.opcode = NXP_NCI_RF_TXLDO_ERROR_NTF,
+		.ntf = nxp_nci_rf_txldo_error_ntf,
+	},
+};
+
 static const struct nci_ops nxp_nci_ops = {
 	.open = nxp_nci_open,
 	.close = nxp_nci_close,
 	.send = nxp_nci_send,
 	.fw_download = nxp_nci_fw_download,
+	.core_ops = nxp_nci_core_ops,
+	.n_core_ops = ARRAY_SIZE(nxp_nci_core_ops),
 };
 
 int nxp_nci_probe(void *phy_id, struct device *pdev,
-- 
2.30.2

