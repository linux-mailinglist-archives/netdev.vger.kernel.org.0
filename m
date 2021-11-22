Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C36245914F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbhKVP1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbhKVP1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E63C06174A;
        Mon, 22 Nov 2021 07:24:31 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so34155252eds.10;
        Mon, 22 Nov 2021 07:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Acy+CCG8Qx+rTmEcW5HZrHb4eU8LXBMN6cdY1u2MLbs=;
        b=TRYNLdNDvi2oFFwkWxxiibHu5jDrN0wPBP+9IVjz72KoTRwj1kEc6Ltloyu6VY/27n
         p6MBM4fajYPEURRUwdVT1fOWWHRzEYcZhmW9kfmp4tVaEIq4PxGFZ62oex6VZ+3nJw+4
         YsIpfbqAGXFx7I8L7HH/6fh/8nQH+6ufO9uAzC+jNX9oh8OQXSUKEXRyIsVZGGUTpp3M
         Fq1QkJ5iT++8y6lBmV1xK1uXQmfXiLmPI9kWEONPeOWC7T5Jc9R/jzVOKk/FqJf1BkWF
         i7WP9iVCLrppyX5tI92A12RZPp6/G31nYX2K36apD6id9pbBwGX/GKZYcycPpcMFhj2E
         BQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Acy+CCG8Qx+rTmEcW5HZrHb4eU8LXBMN6cdY1u2MLbs=;
        b=2bwOA+W7WtDwXpDrJf7NH4Kj1mALcFIsB4wxHf2AFMYRAw6PRc/S/530i6htmxvJlV
         DrBDVDRiDz5+JYnN11+cl7x5xiKdd6F0UTnbmaB5siWkN+ZKwVFKQtaVcb7ZQ8gI6MYE
         GS8+BMPfoCH9S6AXJX2/KbG/J8C7Gek9WrWgQYHXcZiDEROHEE17M0ygDIeaLTbxVYtw
         2XJSu5vKmZfThBVDiUTYYrRg0D+3BOqA8RzTuNWcZ8tUgDShhMpuZjm5l+CycuhlxHQB
         6gMKfaH1vzKABzwX/wTUpgMK3TQqZRTF9dgUlN9AtQpeh8gt1TW0T0iRMqLOe5wQHVU4
         MfhA==
X-Gm-Message-State: AOAM530YlL4nPotWfhMsZHax75+0wYmYVGeSJ64dtDvi8KiRm04gd3ww
        VWmdm1zxvc5JCJAoQ6Ws7Gs=
X-Google-Smtp-Source: ABdhPJye4fi8jlx2vogU8pYTSsDYSlfzsVh6xtNbNogRMtrnBGFP8cr7ORAQCsfW3yvdUY22N9hjLA==
X-Received: by 2002:a17:907:c0c:: with SMTP id ga12mr44157578ejc.417.1637594661939;
        Mon, 22 Nov 2021 07:24:21 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:21 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 6/9] net: dsa: qca8k: add additional MIB counter and make it dynamic
Date:   Mon, 22 Nov 2021 16:23:45 +0100
Message-Id: <20211122152348.6634-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
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
index d64a9af186be..bedaaa6b9a1d 100644
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
@@ -1601,12 +1603,16 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
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
@@ -1616,12 +1622,15 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
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
 
@@ -1644,10 +1653,15 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
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
@@ -2150,14 +2164,17 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
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

