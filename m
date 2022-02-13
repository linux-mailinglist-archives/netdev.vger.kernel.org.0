Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309344B3D14
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbiBMTN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:13:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237941AbiBMTNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:13:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2130.outbound.protection.outlook.com [40.107.236.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C7B593BC;
        Sun, 13 Feb 2022 11:13:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4C8VSePQBYrAeNL41t1aNly6xfji0iC2a/JTySLjZhjXMvfXK4DjEZFTNEvkzVPd6lv/M5FgKgRQBAFYbaBW25iVWsr+cEqTIFysS0cWVvrtCPfIyusvUkUOpNCHBeiVmIDszIpFP51QV7qlIk7fURiTgJSsShSrgGlotZqVz5F/rbR0LNEVJRiYre8MFyx8TyhnpL8z5HsqLNiA3oZT4hbl8TKv+133nrSvPUMXvkdLRujSJS3f7IkqSJvBhHU6RFDJpDXgkQDqstj52mmXGzgi78v43pI/Ts8MoVfKaP0kjANfbpq0ULkQzfImf8dmyoU7cY+WQMpqOvBYt6xvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nv5AjNp/bsPNTC6KiiFtIi7/+Szne1J4+M/2V0nzN8=;
 b=NFhk6mP7LGLDiVtTqM3UKkXSpk2nOLi20TmewCz2i/LhsKEURQaG3zK65JzL4u8c/yAs9eeEmujF8TjdzkqVyUPPCez8bpxoAOw3i0HSilxROqEu6Dq/o5vcoweQLSFnSDwCdP7Vqx7e3RxJ6r1uG7x8c9ZiiYP1fPILvJ6eFavAq7XFhZ9EVidYxNHeAYF+n8sHai/3GBqZl0Xs0FSALQ2AGR+61FGIkiq/Ha86SHyqo5wa/NBgqtqLzssVG29N0CwNp+ckHxYZCxb/9re4YyAFuidVW0t8lszj9+9BnKX3ZwtdvJx+py+5VdEmp/3xMMnQHAD3CBptaz+Dbf783g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nv5AjNp/bsPNTC6KiiFtIi7/+Szne1J4+M/2V0nzN8=;
 b=mKAF4RetFHvD3js6GL95XaijUEJgi8bFRJaqCcrWXQ12nc+PP5eG8w6nrOavnbsFQ5NsMApuEMU6vloa+QSaI3XEyWjLvVOwHVRXG5vY48gHQDcv7c/PbyCxxPxLV47GvKnrJtfCEDAqctzQHRZJTtlw8fEip8Ulqj1o+fMSCNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3315.namprd10.prod.outlook.com
 (2603:10b6:408:c8::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 19:13:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Sun, 13 Feb 2022
 19:13:08 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v7 net-next 3/4] net: mscc: ocelot: add ability to perform bulk reads
Date:   Sun, 13 Feb 2022 11:12:53 -0800
Message-Id: <20220213191254.1480765-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220213191254.1480765-1-colin.foster@in-advantage.com>
References: <20220213191254.1480765-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71411400-7bd6-4783-f53c-08d9ef24dce2
X-MS-TrafficTypeDiagnostic: BN8PR10MB3315:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB33154C2894C901F05DA78889A4329@BN8PR10MB3315.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dYepqvpusFGjj4HoyFxVfDUBf7nR9tuFP/ZnU1ZRUKkD5gufd/pD6oQ72kEQzcO5Z0UmxphJzUvKItoMRnnnGmuuhaTKDrDuD/RUVrFoM2AAjJTw4USefoZibYOdxNsJgZuW7/8eJSS6fWkOwdsTIOizBU4nL8BNZc3Fb1A6x8ILQ+O1OaomEq/DhM3obb2Q7Hde4QZM8DbJ5E8GDqplbg0khkPXnMF9aaKB6JboHF0q0k65d28cJ+OkVGPaJxp8Dv5mMSnNUCbZU2cCXUrpVqlFXEi05FY0x3nYlH+T0MSPOwT5WrXEPvH1gbLrmNSPtq22OTthXSpwrlTYZNdP3qQydx1eWhocscl3BEmnWugpPShHIglLhjqu6/p03oQMBAs2/m8w42QYyScgK2tjjEsgF2RmEqbVoqCETN7YsaYtgtpJlwDmEYWqWqYLdVG3VN7fcSSs5gSgtmJwSRnUBwwFja4qbPYKQYF37YDkE3uKY5BWFY4SaqTjdQMSC5ay9WmpHi4rN9rAheNz3tDb3H2TjaAL+HeIN1eiArIp8yBvZkW2ZjN95xcfM2c7Urj3APK9844Gc4WU0imNfuQu8er+mJmP/l+3glBIpTKaDxRMOArTx4NGiv6oUCM0TSbLfhrGpDvNl88VxDp5RXrQ8JOt8/9cBz+wWZwOcgzE7AL8TMoQE4yPN/Pw42mfLPiG+/3920fF6t2qYe673m6gZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(376002)(39830400003)(346002)(396003)(26005)(186003)(2616005)(508600001)(6486002)(6512007)(66556008)(66476007)(38100700002)(4326008)(66946007)(44832011)(1076003)(38350700002)(5660300002)(8676002)(36756003)(83380400001)(52116002)(6506007)(86362001)(6666004)(8936002)(2906002)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUZAwI4yCEEIZKuV5/DgwQlPPAuaxNUsVM9g3dDNjFqct0/FnY57Rhig+ViS?=
 =?us-ascii?Q?OjK11kvKOhGfyayXXOGG80vpwIclXgMJHOWWBEZ3hdO446VlJ+WZblOjh4Yt?=
 =?us-ascii?Q?tIdWiaUTC++DNqeIfW+yk423CwCao7T0UQX4jAVchcwAau3iAUD14Cx3rUhq?=
 =?us-ascii?Q?V6eNYJOhg3hcR1z8MkqhBpGTL0HmLW+YzpXYc2RFeixqGuMpERhsV7hvjnem?=
 =?us-ascii?Q?5AejV6ApjRWYTJ1cN4HDmyaLKqMH+etvM8S/AuFRuFbvCo/NOYSgXFy7QwIh?=
 =?us-ascii?Q?eaHKm9kWCNszDNNejhjlEaNksX5uoR7iE2daPjIPYF4syEnLaeEuiP2DKOyy?=
 =?us-ascii?Q?vm+7hUWf2YEW5z1OSaD7yKRvRbhotMaAOplYEfwn3E9y5R5sBftPKktu3nhu?=
 =?us-ascii?Q?FSIMuf+8/AYIJ9/d+8fLllzXuSNBMef+KxpN5r/C+WLBAJfsvtnP5cgDnKXJ?=
 =?us-ascii?Q?GEEhrRFuEH3rfdy5dCtND0i6BKJg/june476lNNTXendGwxhCQG6/yIhRUOR?=
 =?us-ascii?Q?Ei1TMBMznSwlg5MVqRx2/J6lo1j0eRk+2CcYQ2bFU+CUMlN/BHKKox5yphrm?=
 =?us-ascii?Q?BxjZk2v/BwsNEt2yXSgqk4LttOVPcakCGtQLeFtEkNTqDfKKmJ+lRhQIv2NC?=
 =?us-ascii?Q?5H0uQYGK3O/kLbaVko7HCtARZyGVQebT2yki/IQ3R/b9liRnaM8A8dJk6xRB?=
 =?us-ascii?Q?VXlvINxYMrKluzEI/13r/W2koPe7sCrzJl5Wpyop+FNRY9JbQbp8Pzi5lkVZ?=
 =?us-ascii?Q?55dmVqWNUZcnoU0CgRA5zG3t6PWc7HQVBtKKKCt4ILp7bMk4gPNMXDhNTg0S?=
 =?us-ascii?Q?j+tUTCpm9Oio21iK0tD5PM8tnxtz4wMFVkonH4WXXUuCya9jXoQk3fR6lD27?=
 =?us-ascii?Q?nvMEW2g9nIDxChPSdQLTs1hwhnWAGfP9NQ8CFObtIrLtv5Ocr6nLoIKmgOgN?=
 =?us-ascii?Q?Jawom/qcTqsBW8ql2Ix1LiqcwdWTkdE9kLBch5BTIhXZvcj2BU4amwjfFS1a?=
 =?us-ascii?Q?FsO00lRIipCb7R6rn7ScByAMDrMGR57yDtcJ9HPpVFcbZdpsoeHqfS1oDtdr?=
 =?us-ascii?Q?PZc1GYSUGV87g8BuB64yIjSAGRIi5pUF+fP4gSdR10w/J16iUXzkCqHsC+Ym?=
 =?us-ascii?Q?w5K3kd3XBKR59jzPbimNR6sdcjGZ4mz0gczzMcxwe+AKOiWNQQpHD5K8BVlE?=
 =?us-ascii?Q?VmYuF/IgkZV2ODjAyiumi3QuX29EvJr1Idwel5wpelnV+ZCNLrY2laPU1bPz?=
 =?us-ascii?Q?XLUQSILdYXwLbiWvYAZflC6ikuCOr6jC8joBx677iF06Ka7pJDS9qCzMNhAt?=
 =?us-ascii?Q?7yeIh9etvgi3W1TcGgzA1v29COjwIPIjMpkVxVSgpz4WPOYORXyPnVeg6y7Z?=
 =?us-ascii?Q?vc9GQcbL/kUzhHJ2OTaUvWscMFisc7fx4DKl4sFMwRA4GyrA4p4ublozpd5X?=
 =?us-ascii?Q?hZ76GSqHgCt2+gy50Gl4EkD2gUkmS2THEn6XxRPNaUSuyg3V9jQDT1q5AN75?=
 =?us-ascii?Q?Wses4htn2JAwnMRn4VzzmmYR8U+mgeAyTg+sqtGkbGNSV/YEoPN9kp3gFQBj?=
 =?us-ascii?Q?G459xDeChHwrlOJBT6C3fyzfXxB03If/BUdRem5dcUzzN+Im1VBLZ14Ubzdc?=
 =?us-ascii?Q?tKSk+E/lSoDxqZdwyCVfCfmCEbMKJHdgw/KrxeY5h3DCj5ZZhkA55z8ppLp4?=
 =?us-ascii?Q?bpOLEQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71411400-7bd6-4783-f53c-08d9ef24dce2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 19:13:05.4452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h41jt6jzMSKJwo3uIUlnW2cKJqo542SjIdKCs5cZiGZlT4TrZ/F/KsOF78jHdnKMY6f6z0awT03dcFSxQDVumP+n7ifix5BCPREIG+Ieo+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3315
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap supports bulk register reads. Ocelot does not. This patch adds
support for Ocelot to invoke bulk regmap reads. That will allow any driver
that performs consecutive reads over memory regions to optimize that
access.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h             |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 7390fa3980ec..2067382d0ee1 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -10,6 +10,19 @@
 
 #include "ocelot.h"
 
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
+			  int count)
+{
+	u16 target = reg >> TARGET_OFFSET;
+
+	WARN_ON(!target);
+
+	return regmap_bulk_read(ocelot->targets[target],
+				ocelot->map[target][reg & REG_MASK] + offset,
+				buf, count);
+}
+EXPORT_SYMBOL_GPL(__ocelot_bulk_read_ix);
+
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 {
 	u16 target = reg >> TARGET_OFFSET;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 14a6f4de8e1f..312b72558659 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -744,6 +744,9 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+#define ocelot_bulk_read_rix(ocelot, reg, ri, buf, count) \
+	__ocelot_bulk_read_ix(ocelot, reg, reg##_RSZ * (ri), buf, count)
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) \
 	__ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) \
@@ -800,6 +803,8 @@ struct ocelot_policer {
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg);
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
+			  int count);
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
-- 
2.25.1

