Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631F35E974C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiIZAb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbiIZAbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:31:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2103.outbound.protection.outlook.com [40.107.96.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC0929806;
        Sun, 25 Sep 2022 17:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZsdWCK8LXZe81sA+nUFA0V7qdP1024StrqJ/PDa5xMN9bMhZ32/pG11R/32RnUp/pYJmQ1es2ZaleNak7mFto7THWaMvBeFZaJA6/51FzHDFZJydmKPzdlxmI5ld5ZY0DqNb05JndYN2fUB8NCXw71CKKj1542wa7QWGKNWCx3Q7z5c8ifmE2NUsIEc6TtKeiFerBUMoMeUJokl69jUT1i4G63SbcX8z04txX0iWXaooEMBYm7ivEuAz4Jp+dV8fnrAz5CZMt/WDFPBULtahhkM98ia+rvRBkofPFoClIQybIdceDAibjPEfb9bhqXeoi3Iao+Ow4sOEkaByA1DEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5tmzslR0SqH4/hm51ye/UVs3IbfFpheM1Wdxer4/BA=;
 b=iAJrSl3J8aYQt2XpAuACmx8YFVzCsAYeCyxOP705twpbUJ6raMCYdUVZb/N0n52jSkxSZOO2TMTiVZfyfOTMtjnU1t+slgrvLV1/FaUT04wyj1QBTXx0VrmvMsIioFaCdTF2cNnbPe521tpHPQv9ML2/Llyy2biVGOWJdTjxImnb0NhW/rlh9oWpLt7qChiTTfBsbaLwFdanGMl6UlfxRQYMAJcrFndPmMTpHx7rGwHXBfJLo7vraEFX4dg/AyZS0ys0qpHhzusze/M2brMqLGlJDbh4T9DZ31da6C3gQgLcbFy4EAPvvR1GF3HQdkJ4WmnocgCKAyUb99YYsjeAjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5tmzslR0SqH4/hm51ye/UVs3IbfFpheM1Wdxer4/BA=;
 b=btgwBTCwti/3M9d2VS7fKYztf3FiNMaunHhcjAQWjg+ZqpfO0es7ifxQKholbrbc8RS+e0bB5BlXHwPNce0cn+HpzykcxjKAPfUeqou75njFjpWbL2tdW3pqJuJ3UP2xss+dU5GRpWrLwdJoWITNTaaEAC+OaId188E//TzTx8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 06/14] net: dsa: felix: add configurable device quirks
Date:   Sun, 25 Sep 2022 17:29:20 -0700
Message-Id: <20220926002928.2744638-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c25ded-3bc0-4413-db45-08da9f564c02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nj+Gcg9X4EdiU0bc55Ff5E8u4Ig31LhFMJY0x86leXvNFlRQlpzpXWH0OEiHmTawz9+oGVo4C94ROVInob/PpFG4+GaWID+W63ookYtOMa0x1/GSJO+WJJ814b57L3JR10jo2TUm668XKrsUzNK1EQ7Qc73kauM5gvdsNKt7SL0z5sErmKAYE06S3f4caL7C7wJH6AovTI4ZLPTPzs6QGuZZ2Xa2ciNB0XsnjrWdd5k8hWqR4hZdkJA9iqTExRhR97h1SiJEfRrxssXfG3d4GZyfp/zihwS2o7mqLKdClhfOigsQ6NO4/U6EhUe2Althx393XeOn0A+MtDQUQGU0+/ZcflH5QkVCGg0yT/357VuWlk05CCnlIkPBk2GW4xAU9sjbqOpOcRKJN5F49lM1JAXyBVgTYkkITAAPNn0qUHSWqpqnane53qBQevz85CmJU/GoP6L2Qa1STSbDxsM3/D9zK9M5EhKIe2jPqJJ6VOA7DuGxMIi5u+VEpSdN/mpCCn7kcybApwqABBlwaStQIOjK5GAyuOxqgQtTbXB6jUBwBmFlyUuIPIAWqXCnbk+R4GQEUwJ6gRUOFVyQgfq1KXxezR3baUElo2UH8CyP4UicoEalbHpl0ZqIq7hv7wKvmE/vR6xPTdj1IWX3Z7DuAnLrzFo4/pVMl+Tat56Airt6M9AIG3PBUSMLJWxpm9lR8wh82iXaNt6H3g/OW7YFT93URNOFYozf28Jy5BfjgFqdcZsUe3wDry2TT934uqw7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uBkVwnNvdErNVBM4O1H/JG7IQVZCAXPL9gvWmgh18jrPwSCtlyPIKL8aHzb6?=
 =?us-ascii?Q?dYsU8FkL6zQmZ0lILPtUyfWnyPiX2zpIQB8MlZ8J7IzZuhS3b070Ppl/+gJo?=
 =?us-ascii?Q?9X9AjThWMUhQp3yV4oNjhtBqwLKTOFkXOfD5fEnksgI8uTYuAdqt7/mj12XI?=
 =?us-ascii?Q?RqCIZQ4Hof773z5wHYlBUAfx1S3kMdeOcMmAqDrhmprWjPfJxgEc2znd/YKi?=
 =?us-ascii?Q?bopzhruobZ7H7VVHYyuRVSiYqWxqSMYJfqCxt5Nc4vrvvwc+jFTmkD/raw6+?=
 =?us-ascii?Q?WEqkQNxONs+tz9uQckWT4XkSXv6ftAK03UAOt0MjdOUvK7oE0XrMfO0JAroB?=
 =?us-ascii?Q?76+Nxr/2eLP3XdrBfYIH2i4Sv6Cjts1DSUZPUwpvedWR1zV9bN+Hk34Cx9Wg?=
 =?us-ascii?Q?SocHJMxNACb/eTsYbY58G8ePF/3pqSLv2mMbcr5VE12PnrKtQ87gUZnBFxav?=
 =?us-ascii?Q?kgl3ITua6aQ3mEyvLzmOQBjUlas1wF+zGuHbiGZdMnFICqQAb0XFJALBwtoc?=
 =?us-ascii?Q?WWEsPvcH4UOJym08Jur5KjVxQa/W5vyZRvWI7+cHBRRa+Q8/aqEbmfDTy+fI?=
 =?us-ascii?Q?vmg9wBG62hr84T/LBPNu8y6+GiiSUoJQ/Xhb/yN1nUOy3aFgOg6uIHkTnds+?=
 =?us-ascii?Q?JwS6AmO00vYo15iuKfYOB6i04evr9cfky0NswKpN30lwb7ytprvhT3ubtXvF?=
 =?us-ascii?Q?93I/Z5Ux4qAkDFhXNYCfrqI+18K0OWNVuSR5lUVkuXyoasQWrZtGuFnT0Oli?=
 =?us-ascii?Q?LE+sucEknR5NbC5fa9gqeZ9FWhZ5xG1wS2xOjgtDNSS/GiiYvbobH2QDXSAU?=
 =?us-ascii?Q?ZC9NhjOhQi8LUXQQxstwQDdrhG4zcUodok7Q2k0WDLh/ELxVmHfXO6pJuzA+?=
 =?us-ascii?Q?hksGTV7rGwFDOoI3vf0/eyRaD92MIZDw5KJauPHo1kBclMhuO0rQlpNY/reI?=
 =?us-ascii?Q?5ukQ0SQkfwkphPzk5mM39C+gH0KrZ/SeJmgo8G7yIXv2eC0nAxpmQ+crRC2V?=
 =?us-ascii?Q?GBIlr6qlpeXXhgmmNvWq7RO7Xpe/vTMl5q9vNDFtMjz2SJ7bbmAfM6xC5+bq?=
 =?us-ascii?Q?BGYsFaxV97VSfoqpnD1MzQYje9mCwINrCID649OQ/N+iF+4fSxYU0XRgjmuV?=
 =?us-ascii?Q?ceivW9Dw1YeXj1+SzjM0QZMqFNWpXqyPyQyryUgRrOCSC1lCyCGJWmubFffv?=
 =?us-ascii?Q?ZSWUKZk7gIi4+BLrx/5B97GQZJPBS4u9OGDhiff+9JEfwAD1qut4Dk3zXCj/?=
 =?us-ascii?Q?TXQoxgM6o/dEoYspsGDzWZly6YfoVhm5EYPGdZB0zDmCk3NVrfwHT8k6pQy9?=
 =?us-ascii?Q?3xj2It9TAEIOWXYHo8LDeawzSnXOUZsePm41Qvs47mhjdiRirwFLD2RxriRa?=
 =?us-ascii?Q?L2oJTzx8PrUg59ee3bSPgoCVkpULDEX8ECJA2feLJzANh/1PvZ9YayjlnsBa?=
 =?us-ascii?Q?UTm1th31o7Th3fyv/uwLHRtPk9ZXJqzBf0/AYW9fU1+PIXQ/zHztvBhgDJ57?=
 =?us-ascii?Q?WTO688McQxxQv68q1PkDMm5mq5jZpjPLNluASOf7uryEr3Ui+09E6x4yeMB7?=
 =?us-ascii?Q?1cpthoX+Rv84caNLRUCIebvYePkt6w45Qpxo0+RRZBD67T6Q1+anXNm0Npph?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c25ded-3bc0-4413-db45-08da9f564c02
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:22.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cb0NEcsLnoE6seWf5STenbBBYaxEaWt9GkBE6BdDalBLxl6cQtn8c/mSBKXvAiU8PgPTiC2U7umy2Hw8d1Q/GacbkKGoBYa3IyqPmiK8w34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v2 & v3
    * No changes

v1 from previous RFC:
    * No changes

---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d2a9d292160c..07c2f1b6913d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1082,9 +1082,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1099,7 +1102,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index e4fd5eef57a0..f94a445c2542 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -33,6 +33,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2ec49e42b3f4..2fd2bb499e9c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2605,6 +2605,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 5b29fa930627..e589d07f84db 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1071,6 +1071,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

