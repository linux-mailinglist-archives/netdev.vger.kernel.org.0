Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D294587A0
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhKVBHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhKVBHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24550C061574;
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y13so69264913edd.13;
        Sun, 21 Nov 2021 17:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6L5oKXbq8MCgfLI2yCkOrPoPOSwlqoaQgKhJTEzW6j8=;
        b=JPFvhW2MITnbezig9d8OQ2xf622Sk55AVVMBXUZShdJd/eBfKykjMgu6iwSH9dq1L8
         mKH2Ngv92jjSoLRkmASxY0MYHKjcDLXw7PDTPUYlV5HadBG5If1Tg6zZFHAYuP6Z4TG5
         RnBiH5D06X3BOilHHT57+AsnFMxbCvfdALq6LyOmpzcQce//C0GSpO/pQYlwWTXn2pFP
         iduXhVOIt5lsNRDw5DQnEgQgaWFXtVlyf2Tyeh61ajlr5x7oo53CfbPDz6UThdP35oqX
         T+hG9vVpohWFVcN8F39Rx+eYGKNnoSXPksmAMF73t77iBxzAH+Zt1PPn3xrcHmQvudrY
         UT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6L5oKXbq8MCgfLI2yCkOrPoPOSwlqoaQgKhJTEzW6j8=;
        b=k8PxylRBvc4xQPCSmZqTQXMKS/4Ojxx+ighE/nuAJGsKjs55jV2YIIBkYB86FaiJSU
         I6Bd2p6T8zPT0IAY0CPxs6789HqunYCPlnnHE+lYW5l4I9HEbDSph6QS/CNSaJdIiuyb
         vMGnmweQ/ujbcXNQB6V99JfDnzjyf1IVt3OppAQx7VAzTc7MJGZcky6jtILcEoDs/g1A
         UzMZASoOwLKRx2F2xBAu84QPvoAByUZBMajAsDiptCx+hhXyO0p6rnMlBfWR1/jGo9t2
         +x8CKz683CC8CuMNBSLdmelCvq4u5Se55uVc9myno3Veg81+/7riI3EReSouKUqlzhj5
         nUgg==
X-Gm-Message-State: AOAM530XS/PbYEZxB8MaKq3mEfvOrMejqkGK5cPAn2BMBPps39TiowNc
        /c9DwE3cx1ejfqGcATyLYnc=
X-Google-Smtp-Source: ABdhPJyuZE7bW5Cu6KnSQJ6NNAmpFQ9PZnT3iamMmG+uaLm9VhYXZjmJg53mRzO/ceyizhk2+8XAEQ==
X-Received: by 2002:a17:906:689a:: with SMTP id n26mr24473913ejr.305.1637543044580;
        Sun, 21 Nov 2021 17:04:04 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:04 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 6/9] net: dsa: qca8k: add additional MIB counter and make it dynamic
Date:   Mon, 22 Nov 2021 02:03:10 +0100
Message-Id: <20211122010313.24944-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are currently missing 2 additionals MIB counter present in QCA833x
switch.
QC832x switch have 39 MIB counter and QCA833X have 41 MIB counter.
Add the additional MIB counter and rework the MIB function to print the
correct supported counter from the match_data struct.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 ++++++++++++++++++++---
 drivers/net/dsa/qca8k.h |  4 ++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 159a1065e66b..57ba387a4aa1 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -70,6 +70,8 @@ static const struct qca8k_mib_desc ar8327_mib[] = {
 	MIB_DESC(1, 0x9c, "TxExcDefer"),
 	MIB_DESC(1, 0xa0, "TxDefer"),
 	MIB_DESC(1, 0xa4, "TxLateCol"),
+	MIB_DESC(1, 0xa8, "RXUnicast"),
+	MIB_DESC(1, 0xac, "TXUnicast"),
 };
 
 /* The 32bit switch registers are accessed indirectly. To achieve this we need
@@ -1591,12 +1593,16 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 static void
 qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 {
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
 	int i;
 
 	if (stringset != ETH_SS_STATS)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++)
+	match_data = of_device_get_match_data(priv->dev);
+
+	for (i = 0; i < match_data->mib_count; i++)
 		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
 			ETH_GSTRING_LEN);
 }
@@ -1606,12 +1612,15 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			uint64_t *data)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	const struct qca8k_match_data *match_data;
 	const struct qca8k_mib_desc *mib;
 	u32 reg, i, val;
 	u32 hi = 0;
 	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++) {
+	match_data = of_device_get_match_data(priv->dev);
+
+	for (i = 0; i < match_data->mib_count; i++) {
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
@@ -1634,10 +1643,15 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 static int
 qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
 {
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+
 	if (sset != ETH_SS_STATS)
 		return 0;
 
-	return ARRAY_SIZE(ar8327_mib);
+	match_data = of_device_get_match_data(priv->dev);
+
+	return match_data->mib_count;
 }
 
 static int
@@ -2140,14 +2154,17 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 static const struct qca8k_match_data qca8327 = {
 	.id = QCA8K_ID_QCA8327,
 	.reduced_package = true,
+	.mib_count = QCA8K_QCA832X_MIB_COUNT,
 };
 
 static const struct qca8k_match_data qca8328 = {
 	.id = QCA8K_ID_QCA8327,
+	.mib_count = QCA8K_QCA832X_MIB_COUNT,
 };
 
 static const struct qca8k_match_data qca833x = {
 	.id = QCA8K_ID_QCA8337,
+	.mib_count = QCA8K_QCA833X_MIB_COUNT,
 };
 
 static const struct of_device_id qca8k_of_match[] = {
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 085885275398..91c94dfc9789 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -21,6 +21,9 @@
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
+#define QCA8K_QCA832X_MIB_COUNT				39
+#define QCA8K_QCA833X_MIB_COUNT				41
+
 #define QCA8K_BUSY_WAIT_TIMEOUT				2000
 
 #define QCA8K_NUM_FDB_RECORDS				2048
@@ -279,6 +282,7 @@ struct ar8xxx_port_status {
 struct qca8k_match_data {
 	u8 id;
 	bool reduced_package;
+	u8 mib_count;
 };
 
 enum {
-- 
2.32.0

