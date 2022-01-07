Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDB448792A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbiAGOml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:42:41 -0500
Received: from mail-eopbgr50076.outbound.protection.outlook.com ([40.107.5.76]:24654
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230012AbiAGOml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 09:42:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZarD5PPhLHR8fCXD5E0SyVuGNqm6TMUXETihVXBRFPB8g46mZP5gSVtxLyXcNbhNNL4XkncsINW92ErVjOc/t3HfDqRj9FTLX0drXFg3UMfRsphcPG7AuTauWjNKtlSq6DEVZIyt1JyTyG6lHzW8zcyGQDqwm7shqaRW1PG2JlrydWwPvPei72R15Yr96wV1tK9Hwy5Bn3EXJCNt12Ft6562BACIFbwGYHaNPspxVuhyTIY+UYqGWvFNiucBvy66OOunS/qYj7pFkt4msOyKDM7mbd11yJpR9SlmEqCt6wYr+KOKsb/gCH8ZeYeImDvJQVRbAcH3mLr3gS7+nUNO+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5Al8FxbUPsuLseYKOVUGMpczOvO774jEeqAbqJzIPs=;
 b=J82ruxv8oAoAs/59am3txbmKlbZKxDlshMlxGK2VZpgYKrurJin3xiWnXOlzFhRm+RLkYr2b5YC9kaufrslwlBFV32tAnlC2lUxVzedCoZoE4mADH6gkXXoVDF0RYPtFn3dlZRRoj289C/DkmJ9YcAz47EAgXRE0z69AwjoXGSf9gCftcfesdGzIaLPWNNqQ2GzwuJ4Kxifqlas4mqKza9TyGsKagGHRBOUpg9M9iMplDm0CYqcmOrIzC2iEr3Hr44sMI+ojyfjmKF+LSCuGBu3th4A/RO5Djwn9DF+njLvfHt5IaqVM55mNdofmTId34gTXoJCHLzIoq4yUCG92Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5Al8FxbUPsuLseYKOVUGMpczOvO774jEeqAbqJzIPs=;
 b=Dy9ai9v2IdbV+sn+qp84jgVGHHsAWX+/YCWIY55EpB4+rXvxaoJsAOOh4q5/uo/pdHWCQHwNzwvFxRxSeRK1fjS+e146AmSfS/j2UWuW0zzAOxFx4AJjD4goTPGzjjvdqGVqRitl037s6zlb4ic9HSq8uQVrmUg+zTH+mp/aEIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 14:42:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 14:42:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: dsa: felix: add port fast age support
Date:   Fri,  7 Jan 2022 16:42:29 +0200
Message-Id: <20220107144229.244584-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0101CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b450c551-8413-4192-96ed-08d9d1ebf3e8
X-MS-TrafficTypeDiagnostic: VI1PR04MB6944:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6944266061D8BB9CAA2DA395E04D9@VI1PR04MB6944.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZrgZlKg8wpXEyaBpn8cjReWTSFMaL4c96i6TWxjSkHiGeb+u9ub33qR4k2c+oIQIBLHCjktGa/Y1xg2X/2FJJ1YhD88WrA4nR8wdD9n8FGkkLJ/10875Q+xSvbtaj1xEZZUf/4EPx8LqYAEHUvjIKBePG+y+7aeYWlVq5XprvQHoLCFK0VXGHCvQ9j+0xBQMiTpnMg1xYlk8B8D1G8ljbv0Y9LunCdTllFE5gKqLZQv/NPAbaX0FjZagXC4WNs1/Tw2bqTF95KzFP9Y4vk6KQzMa6VDnN2qiL7FM7Nv5rl07NH3C/f2jPb30ewxGCgEXSK2RLyYTeJqJGH8lb2PqyquGDN5m+mKMAyo+yjnuGRbVICaA15xoIQbPbVqKTy2wnzwJ6IOY9Knp7GpksFbid8C7PhDvmolgTt5A1vQ7NCmuTUVKPhYXk8+7MXEsSMmW4n6xd56typIfhTynpzBeLJ9dDZ1liS9BVjfvOIA601VmAFoEgKryY9FaRGmLvfCfnS9bcHfK2RlDSzDn6BNORPo7/wE2kbwYmL7n91Qw96IkN9UbX2MMp325tiWlPZhxslqp+dqz5zFgtNe7+LxV6TSYCDOZXD5krZN9nWoqzmdADhZ33Heom7szhAGobgMcFLDitOps2pkcqp7MTshb1eri6oOSGXC7TYMVJ93E2IpaHm3H346zvoIlRkH79MDsjHmPbAcS4OWexUbmZylKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(1076003)(2616005)(44832011)(8676002)(8936002)(52116002)(4326008)(508600001)(2906002)(66946007)(6486002)(66556008)(66476007)(316002)(6506007)(36756003)(38100700002)(83380400001)(6916009)(38350700002)(26005)(5660300002)(54906003)(186003)(6512007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZdeTK2J2LJJwA1Y0jZTW6wAZ+QwbK04ro58OA0g2RR6HV2txXJ0XztJFMc9K?=
 =?us-ascii?Q?WU8OCWhmknDPHz5/K4WGyXwkUNgowIpBHQAHYu/l9/9h3MqOF5f37kQEuj7x?=
 =?us-ascii?Q?XKq4T96mW8CjeXmKWuOBZ8aXLubeDVJpyvcXynmCxFbX/2MsJXx9UIBF76+A?=
 =?us-ascii?Q?KvenpjAs2UkDc+kqBpgrrR2B0JiiAKwSJ+Dm6MNjNHfJy1/1pQ1GYTWgKlaq?=
 =?us-ascii?Q?k5pvrjBhdhneSPuVvhQOTSdOIPNRd28ajTMzJz8Wrptv9s43l3AXLug87EYX?=
 =?us-ascii?Q?3vi8Tujxgp++F9phy7tSdLMjUORnqoNdQJuZwnlfl9HCGLhZBmA5fVHMr0i8?=
 =?us-ascii?Q?fqZKYUUNzhuek/2o6b/mPUd2HFYeHpntwQGB3Kw/jlyAmwYIfOmrQPoqzJlV?=
 =?us-ascii?Q?uUq3W9CQHxDcam5y5j1/P6NK9hi7OJ6ue1YSJc0QLnJUEnDGytuiHupxKZlP?=
 =?us-ascii?Q?fbD/Ahrbm1dACsNKQkyb6RGWAJuLEZYydn3T6UC48fK6sGymnKznGv0Tg/Pn?=
 =?us-ascii?Q?ixGYHhTQw5lQWdilFvhnWPQevNN7CL8erkc/KDbLp70xwxx5eo04X6J+HO1r?=
 =?us-ascii?Q?I9WxeKgeXBCq+cYdzstu7EyRV6QaL+q+KSbThNPL9a+X5I1Q8s6GLoOZD1lx?=
 =?us-ascii?Q?TLwQue+01IFPWV24pd+m7H2CloZLAC/pTIggzZ+W4V3/GYSv9SGftBGdwfOk?=
 =?us-ascii?Q?gA2pm4GRH7g0nnZzUZ/rpbADr8TGRyemBssRHTuVTsUnJ/wWvnT7ushS7L+i?=
 =?us-ascii?Q?3kwLGYwjCS07PFdcVWG6RXcnFwiGtc0g+GFs7EP/3YBEIk8NrYUhlRdMxXKx?=
 =?us-ascii?Q?cfjiiNYhlmIvye8AGzKlMtrD9HvGc+5osLhGevff4iXXw7qhFSs/D+bZ84tE?=
 =?us-ascii?Q?iLkgB2whV3bRDYrBtnDtCk+yeRFZyoADVOiEr7EEKaTF5WejJ/v/mOkFNI5q?=
 =?us-ascii?Q?G4maX8AmvQbG8iQRBwmIdbqjDJJs1si/qcKD6b1diKXRfwGiufi+yr6tj9NS?=
 =?us-ascii?Q?XiUV0TcVlbAMdKeV8HBm6SzHg+j+n2R9HnKh+1/TCGIcX7jwSw2KFkMY9OPX?=
 =?us-ascii?Q?+Us83GzQ2paUICZGTVjnjCBuCteE4BFc2TL9N8bZLcLWm6nfEScrMySbNXMj?=
 =?us-ascii?Q?yhRlkRLooWgNEpQAcfA015NAIxDPR4EShiRpPe63fgJHf0qIKfeMMHN824FP?=
 =?us-ascii?Q?y8cIoHyM2+NpW1Gyx7m+S32BBE15Xhvlq60qmqHgPmvvq84cmA6Xu3wU6DZw?=
 =?us-ascii?Q?894mJVPMHzkGFhKfxuBYmfZUbjLSbApiCuedce+l5a3k/8rbSMsMuA5ogAJh?=
 =?us-ascii?Q?wPe1R/rv1Z1VycXcZt4t1R4J10o5EbHosvtHBYyldEjwLoWXpcP+yZkaM+GO?=
 =?us-ascii?Q?UUbueZ5d7SKbAm7u0WAp22cYpHiV7m66F7eVcEgtEWsjiGkFXegZPwoP3Klc?=
 =?us-ascii?Q?xV1cTV/RoBF/kz2IUNpu44g4wjTN72jikeYIjVLfglNrinfrBnh84EMtCN2F?=
 =?us-ascii?Q?YOCmwLMqM3XaYpl9oFBHzo4wQboVhcCJGind1O1rIvo7G4caE1hxH+v+5G/e?=
 =?us-ascii?Q?xsRwunA56cEZX0QPiHc7wK0caiNypbGiQ0rhbSL9GEeGFHWDYcuZyHiEzv4U?=
 =?us-ascii?Q?rGUfzXjSGNMEbAf10DISbj4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b450c551-8413-4192-96ed-08d9d1ebf3e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 14:42:39.0824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JypGACzwoyW4uMT6erFmTPOT3KUgk77kNp9kjfxrJBqTq4ZJcYF4wHz5nDBWNNDbY4MsEfew3/je297Wcn8Eaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for flushing the MAC table on a given port in the ocelot
switch library, and use this functionality in the felix DSA driver.

This operation is needed when a port leaves a bridge to become
standalone, and when the learning is disabled, and when the STP state
changes to a state where no FDB entry should be present.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 12 ++++++++++
 drivers/net/ethernet/mscc/ocelot.c | 37 ++++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h          |  1 +
 3 files changed, 50 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index bb2a43070ea8..9957772201d5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -639,6 +639,17 @@ static int felix_set_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
+static void felix_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+	int err;
+
+	err = ocelot_mact_flush(ocelot, port);
+	if (err)
+		dev_err(ds->dev, "Flushing MAC table on port %d returned %pe\n",
+			port, ERR_PTR(err));
+}
+
 static int felix_fdb_dump(struct dsa_switch *ds, int port,
 			  dsa_fdb_dump_cb_t *cb, void *data)
 {
@@ -1622,6 +1633,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.phylink_mac_config		= felix_phylink_mac_config,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
+	.port_fast_age			= felix_port_fast_age,
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
 	.port_fdb_del			= felix_fdb_del,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 79e7df837740..b1311b656e17 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1341,6 +1341,43 @@ static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 	return 0;
 }
 
+int ocelot_mact_flush(struct ocelot *ocelot, int port)
+{
+	int err;
+
+	mutex_lock(&ocelot->mact_lock);
+
+	/* Program ageing filter for a single port */
+	ocelot_write(ocelot, ANA_ANAGEFIL_PID_EN | ANA_ANAGEFIL_PID_VAL(port),
+		     ANA_ANAGEFIL);
+
+	/* Flushing dynamic FDB entries requires two successive age scans */
+	ocelot_write(ocelot,
+		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_AGE),
+		     ANA_TABLES_MACACCESS);
+
+	err = ocelot_mact_wait_for_completion(ocelot);
+	if (err) {
+		mutex_unlock(&ocelot->mact_lock);
+		return err;
+	}
+
+	/* And second... */
+	ocelot_write(ocelot,
+		     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_AGE),
+		     ANA_TABLES_MACACCESS);
+
+	err = ocelot_mact_wait_for_completion(ocelot);
+
+	/* Restore ageing filter */
+	ocelot_write(ocelot, 0, ANA_ANAGEFIL);
+
+	mutex_unlock(&ocelot->mact_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ocelot_mact_flush);
+
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3e9454b00562..5c3a3597f1d2 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -833,6 +833,7 @@ void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			     struct net_device *bridge);
 void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge);
+int ocelot_mact_flush(struct ocelot *ocelot, int port);
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data);
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
-- 
2.25.1

