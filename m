Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FCD3F1F4A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhHSRlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:41:20 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:62067
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232481AbhHSRlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:41:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw8G5Bxg1swaGvHDkdk00vpvM8I0AUbmaeIV0X2UXIeEt5s6+8QiO88NLHCoEKDi9akvCTk5MAnpVksf2sdByBr4moiFWyn3NIeB9yC2SgjxniMbcLN1YBvWtaQWwHbpidUvwZTeaig2Isk1Ovq5sdWlwbrIzAW81FN6rI5Z8+kmAwD/oOonSUUeuYi3tRJXT1LuAC7xjPgzMt7pTLN1rwLkhU2IK4wkdk9iuL0werLVfJIPNf6S54RFL/hbdoUtOIVNXQ8V5xVCe36eorvVdqlsp6jdaWkvb96eZ4sBw/BHQsX9eRZ/hG5LnPL4oDzPE0eWY/mLsJoiCml+A29juQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhImt1syFqdWJrYlFm96xbsLOURwpTwXQrNslGfzI0M=;
 b=cdLfAXwHzWEQhBpCrGQy5UUdFqyYUaXjfCOywFEjI/yZKmXeN9HMev3L1/6lx9IXvVG8CvdVmaDwxjwRyFC9wzjJ5YSPg/0F7GrobbdgH5LIQ0Az6p+Ib8f1kpEKtuNDdzoiZqRNWiRW4zBJx1IMW6XCYBS0xAvemqeKaIc8TQRFlm4aDiSiO4Q+NxmxrljjDt7r89oHyzzYty52pqYSDoMfTWo6meSgXEXBCqxmp6MCYtS8X8n6tS66X18GBO51OAmi9P/vczVqx1brcmfhor0DETopZpDtkCVGEdOxx37aMzLHeRW2pulC3WMRLQezp2z8kirKdMOM2Q+VZ5JeZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhImt1syFqdWJrYlFm96xbsLOURwpTwXQrNslGfzI0M=;
 b=QhF39yBu234W2lZaUUOyIMvW7AWsplxVuR/e7tx1xlXfN524O7YeQgogFIBoBKFPwr3mMC24zyxfHVgfSPsOKVUNGjzY9NLnxfWwogF7gPhudEmypRpJdsqSSrifABFFIKkh1fDJ8PxljtmkhJ3odfuveosIBRS42+JlYbgnTU0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 17:40:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 17:40:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 3/3] net: mscc: ocelot: use helpers for port VLAN membership
Date:   Thu, 19 Aug 2021 20:40:08 +0300
Message-Id: <20210819174008.2268874-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
References: <20210819174008.2268874-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0191.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0191.eurprd02.prod.outlook.com (2603:10a6:20b:28e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 17:40:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e23fb2a2-c62f-446b-5d60-08d963387319
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686FF9552E04F59FA479E7EE0C09@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7itYSFm3bKmtoRrVBkSQVovLFz+qTFFqXAvnDetzWGwjRy1NDUx22fqo6JvKmRDf5uegJciI+itvjnlKdQQ1dYhMOdUNGcSJDxe09NBuSZXZWyxBJDXYW74sqwmV4hflLCUn3DZiPTYrAWF1W1UfZ3fLRG1juVdHKoeAcfUI7bHdBkp3PbhrlV8hqF+nmTJWy3NwxYJlaLF91+qEdCqV4WYjoZXJoGU6AcAM7+dQ0IAg2WLYQxyFVPKyjwCkfsg+OjaLejL+zyDfLW/oUgxC/ghx87jMmw8TsHZbSellHpbfpk/d8GdCuSGHG+c768kqyJUKJ8a8ufoWpj55Q/EH3U/pcjTpedAww1tz5Zp/qq5MTbC3uxTeEjrM+jnsU8wZJ/L02TooAWr08yXtWzbZBVjeTwWZ4AA0iJ2q3mqbJ4Uke3IDv959IcZ4vGNl+w0sJwH4GwTIBYU60q4n+qOyBO9lJQ8z7M8PDHJ8VHR8LabtMKtoXnXyEANGJRQP4EEP9/P2UMWHZGxxDPJlua41WQ6cFC6kmiq2/SUnE2skT3bf9K06QRfjLyKvduq1UMpuiXB+7KwDsVrS4MD5cTIURoRjT7qFP7nQfxO4wrPZ0t2OViEO1dEg6105ciH1Kw0FDKi7iSOwZtGf2PkQkc5xlGoNnonVlVmBkDp0ofzuvl/7A1NgpFIMh+2Wcp68d5Sc8LAwew4J87Ji30PdtiRPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(6486002)(316002)(6666004)(44832011)(83380400001)(110136005)(54906003)(1076003)(8936002)(36756003)(186003)(26005)(38350700002)(8676002)(5660300002)(6506007)(6512007)(86362001)(38100700002)(4326008)(956004)(2616005)(478600001)(66476007)(66556008)(66946007)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LBvS9s8B+UdGjCCDFSLYNo3VRtAOqL8YZP8AxG/sgxbQFPw4WqfiSB4/rph+?=
 =?us-ascii?Q?8s2Kv81kicu45qItHHmsiPHcJbIaJfA98G7MDDpJiD/+IwukTtzQLZjfluCd?=
 =?us-ascii?Q?uJmt9b9CcCErYMm/3i6OUAlZPhSkJ9K7ly5x3DQTxq1SbkeYr/458a5/0Nty?=
 =?us-ascii?Q?QBLnY6LztsiGNh9UHhupbpj8dWL6DbBbyRY+hliV4pRepzXnzkAPOJoSQUCW?=
 =?us-ascii?Q?bVFuLXpu8aXfM+FZmHbI7AY7b0yZjpaVkEp5OX1UJ9+jamaHzHyld8A+Ka4r?=
 =?us-ascii?Q?A3LrLWQ5NpQ+GAxkpnH9RrDCx1J24L6twQi4yOfdTCbVQaMgHhEb4F68jS9V?=
 =?us-ascii?Q?I8ZwxzYTeUByZPEWooYycn5FHOjoq54OhlxounoN4sTIMtdSylbfgUpK4AML?=
 =?us-ascii?Q?TEyPE6wf1uBjKzd2xJMBTlhLweymldMscQigD41gSf0lipeXrDgOW4Qc5qBy?=
 =?us-ascii?Q?gIanHtP7jbk/lRDr8qWx+hoD1IEE1hH12OzwpgeWL5myyFp9jf4Cf9ujRL2J?=
 =?us-ascii?Q?nyL2ddKDt9F+mBkzLIQC64v1Aj6DaBbait5gLW1mk32XO6vOPAlusagSRxiV?=
 =?us-ascii?Q?tvLnLu2U3aNqObXk7ANX2cwvnjUlrohCQCzjihQMDzQM4kEUf5iZZKKmXrzj?=
 =?us-ascii?Q?prBOjo78B6Bbq4b3OYdcGWTTgjSXyinWX+k1RDZXD3LD8RwRLkDBZCRREke0?=
 =?us-ascii?Q?6LMLQcXhxsr9f42a+lN5NmxPR2sQ4745nqXa/iqzKa8RRA+1uS/Fiw4cGMUQ?=
 =?us-ascii?Q?iSd9ck/R33I+Ur//LEGQypwGqK3F7v0MeEOL2yGPTmxW0Dlz+vU6Jz1TvMfl?=
 =?us-ascii?Q?8gZISZQBA/J7mOyakieJBjpGS3LrLDb27+niP+dKd5zTscUg2RYJwP+Csb4Q?=
 =?us-ascii?Q?HXM2EL3rIZmUtQRIMolREAITmtAxi3P4IU4/IwSY0rUh/4H6pc6bTwRIbF89?=
 =?us-ascii?Q?WJRLpjbrTijnQsMgsAfaTMTvun/4pACCRLLcXXMk3HYYGiDBkZei9A6Htcqx?=
 =?us-ascii?Q?S9Kzd97dyADRaup/zF9pTJqT5vLwK2pat/wO0DPaM0CQ601SG7TvZS3Fn8gn?=
 =?us-ascii?Q?nc/A82/Re/LNT9Fzn31snZzz/o7+osgk3FWOAYXMPWB6v5gDc/q857kxJ/bI?=
 =?us-ascii?Q?+UuRFybBTxDRAgmLmPkz6egqFDgsZoTu8uxyMQQAlDs4mZfMnPKfLBBktlK7?=
 =?us-ascii?Q?eT8BvBvOIrqjKbO3Ls+3hXZV1UZvVHgNdFQgHiCRaOqDDm5RW/6ogTkC/sIs?=
 =?us-ascii?Q?+JRGvXJtsFE88vX8Iba4TMkQEQ6VbgunZ8xgd79ruq/VLtjNSco/6dAZbomC?=
 =?us-ascii?Q?07B/SpA0oPHQUeLU/JPg8gEV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e23fb2a2-c62f-446b-5d60-08d963387319
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 17:40:35.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKkkzPGKqgQ/Qg7QYKGYH869s9Yb5FYV+cdFgq5ec8UUQIVn1C6MfUOZEtrrvqFj1X0i2pxVfwgv0ZF4d5Fl4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a mostly cosmetic patch that creates some helpers for accessing
the VLAN table. These helpers are also a bit more careful in that they
do not modify the ocelot->vlan_mask unless the hardware operation
succeeded.

Not all callers check the return value (the init code doesn't), but anyway.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 60 ++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e848e0379b5a..c581b955efb3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -222,6 +222,33 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 		       ANA_PORT_DROP_CFG, port);
 }
 
+static int ocelot_vlan_member_set(struct ocelot *ocelot, u32 vlan_mask, u16 vid)
+{
+	int err;
+
+	err = ocelot_vlant_set_mask(ocelot, vid, vlan_mask);
+	if (err)
+		return err;
+
+	ocelot->vlan_mask[vid] = vlan_mask;
+
+	return 0;
+}
+
+static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
+{
+	return ocelot_vlan_member_set(ocelot,
+				      ocelot->vlan_mask[vid] | BIT(port),
+				      vid);
+}
+
+static int ocelot_vlan_member_del(struct ocelot *ocelot, int port, u16 vid)
+{
+	return ocelot_vlan_member_set(ocelot,
+				      ocelot->vlan_mask[vid] & ~BIT(port),
+				      vid);
+}
+
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 			       bool vlan_aware, struct netlink_ext_ack *extack)
 {
@@ -278,13 +305,11 @@ EXPORT_SYMBOL(ocelot_vlan_prepare);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
-	int ret;
+	int err;
 
-	/* Make the port a member of the VLAN */
-	ocelot->vlan_mask[vid] |= BIT(port);
-	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
-	if (ret)
-		return ret;
+	err = ocelot_vlan_member_add(ocelot, port, vid);
+	if (err)
+		return err;
 
 	/* Default ingress vlan classification */
 	if (pvid) {
@@ -311,13 +336,11 @@ EXPORT_SYMBOL(ocelot_vlan_add);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int ret;
+	int err;
 
-	/* Stop the port from being a member of the vlan */
-	ocelot->vlan_mask[vid] &= ~BIT(port);
-	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
-	if (ret)
-		return ret;
+	err = ocelot_vlan_member_del(ocelot, port, vid);
+	if (err)
+		return err;
 
 	/* Ingress */
 	if (ocelot_port->pvid_vlan.vid == vid) {
@@ -339,6 +362,7 @@ EXPORT_SYMBOL(ocelot_vlan_del);
 
 static void ocelot_vlan_init(struct ocelot *ocelot)
 {
+	unsigned long all_ports = GENMASK(ocelot->num_phys_ports - 1, 0);
 	u16 port, vid;
 
 	/* Clear VLAN table, by default all ports are members of all VLANs */
@@ -347,23 +371,19 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	ocelot_vlant_wait_for_completion(ocelot);
 
 	/* Configure the port VLAN memberships */
-	for (vid = 1; vid < VLAN_N_VID; vid++) {
-		ocelot->vlan_mask[vid] = 0;
-		ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
-	}
+	for (vid = 1; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_set(ocelot, 0, vid);
 
 	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
 	 * traffic.  It is added automatically if 8021q module is loaded, but
 	 * we can't rely on it since module may be not loaded.
 	 */
-	ocelot->vlan_mask[0] = GENMASK(ocelot->num_phys_ports - 1, 0);
-	ocelot_vlant_set_mask(ocelot, 0, ocelot->vlan_mask[0]);
+	ocelot_vlan_member_set(ocelot, all_ports, 0);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
 	 */
-	ocelot_write(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
-		     ANA_VLANMASK);
+	ocelot_write(ocelot, all_ports, ANA_VLANMASK);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		ocelot_write_gix(ocelot, 0, REW_PORT_VLAN_CFG, port);
-- 
2.25.1

