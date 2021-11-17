Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94A1454EF8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbhKQVI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240374AbhKQVI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:27 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CE2C061570;
        Wed, 17 Nov 2021 13:05:28 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so17019640edd.3;
        Wed, 17 Nov 2021 13:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=d+SVoTAK5C5wl38ctM2piKl8MvU2Rt+cFsxV/drb/dE=;
        b=PQncZbT1J4amBfAODMyQjDAzKPhvlbV6i4e4tLMf91PR2hDXKNK8uBNh7ADgk5OjOj
         IZaILl1ZvN7BcBkf9ihslBh07biYh4vxjKDWPKJv55mlWmFt6zsUqANGf9HSD4a5WvKg
         WICFtcBVrnf74+NLbtVdjusRa+F9sVhCvpNFjCH/p327rHpMaGROE+uTa1Jyv6Raja/V
         W9ZvjTPDoO485HkrK3krBmWcS0KQVBFuV3CNpXlC0jj3HMNAsx7Ijye9ZuPMrDghOgAB
         RbUXRXDkQDwCr1InoQO8Bx0tkQ0XBdhmRokJsIVCrjZHKZWtIS7lONgSjh62lYuGUvqU
         5VeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+SVoTAK5C5wl38ctM2piKl8MvU2Rt+cFsxV/drb/dE=;
        b=tnwYvS8ZsA0z+ETAHxt50UryrjI7sE/y7rfOgpSuVFnLtd6K94OSHPmtM7KLdeUrfe
         f/Bp3fHtrnECvMMWanAZedUZh0+HnC1bVygFULJuWnHNLX8fq7FbKCyqf0xD45PjTEiE
         sUygSUmcwkomxuBrNWSQNeWCM67lDfeQ5crtUsceTdktJ+ttqdNj2Mbb5K6Otrpq4sJA
         izQpEwuup7nREF2mf4gJOlIJdh9jHxeSflkH6n/JtyCgtsfjjKjNfIR4eShfY1wV+kpc
         lSJgU5qxL82z6+A2ZUCobeKyJGD0GLzb4QICIpQ1ZDsxGe8SI0Ug/Onijgh7E6DwovNX
         JULw==
X-Gm-Message-State: AOAM532dSVC75sVtJ8twwKrUpaJF30va96NTi5dqCWL95RdfVBSAGHen
        qytTz6G+hW+qurYQyBP0/Dc=
X-Google-Smtp-Source: ABdhPJxlXdSLOpdcWeTLvlkdwjgRIMP6De05oHi6jyDKTpdy0hqeHSeZjIWV8pvpsjNbtQQjmbzxog==
X-Received: by 2002:a05:6402:516c:: with SMTP id d12mr2652815ede.391.1637183127332;
        Wed, 17 Nov 2021 13:05:27 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:26 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 09/19] net: dsa: qca8k: add additional MIB counter and make it dynamic
Date:   Wed, 17 Nov 2021 22:04:41 +0100
Message-Id: <20211117210451.26415-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are currently missing 2 additional MIB counter present in QCA833x
switch.
QC832x switch have 39 MIB counter and QCA833X have 41 MIB counter.
Add the additional MIB counter and rework the MIB function to print the
correct supported counter from the match_data struct.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 ++++++++++++++++++++---
 drivers/net/dsa/qca8k.h |  4 ++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7f71607bec3f..cf4f69b36b47 100644
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
@@ -1638,12 +1640,16 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
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
@@ -1653,12 +1659,15 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
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
 
@@ -1681,10 +1690,15 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
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
@@ -2143,14 +2157,17 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
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
index 3722fbb6b461..c5d83514ad2e 100644
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

