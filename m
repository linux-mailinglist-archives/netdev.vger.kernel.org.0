Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F218B68A722
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 01:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjBDAM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 19:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjBDAMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 19:12:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDBD79F00;
        Fri,  3 Feb 2023 16:12:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhtCDZ62NbWt3P+9cwtW5BFaTxNqQXD3iyN1DYL2Zk9J7zFRy1NNA5n32hNH3hrMD5gpPyZQRNdW/5h/OqOl8X7IrWFCMF3XfvlCa0mLHu37sI3DRsRklu5bwEfvAKbzdf2SEbrmMz/a224aZhte1TFoLg3zqg+sYTZUdD4FwHY+GXEDZDoFH2BoYS80iDuYYVseDJuQOC8CicRCTaxMJSBFIDEUfKUK/VD6VqauYfmIIUJeaxlsPvg5rSjGFQDsvl8CSDCnPydGKdA8i4Gzb9Tuw7CipwJCM/lHjkRyVBlS/Tb6fW5dYzxaIAjFmHhPefhloCcFFtuGni6ecI8H+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fe8aL8paniNwa4D9aRosJj0Yh764CiSGygypWRBa7OY=;
 b=gFzt72HKkn2YGTsRIF9zkv78BHWfK6BfCVJp1DZ/q0iKGFoE7ovWQNqmKevaXhwvUb6rk/XvLIgjqRbZUZgTGmq4pJ1dzyLJlMe1GgJsZBLbSy34OqdvkbyGHfMUJOQeD3bdqqYrQ0HPTgKK1EtdQlOvtgtVYZr65oVxs2LY++q4Gs+sewHzU00j9FGgIICVhcGnhUUh6Y8RRGK7iSEBiRP8nGNUTMtCNgyDoWWVTBHEgDkStN4YTvzrhB1eAqPCezXO4+HBbd37GwSMR94ZsjMcsdVJhEfwpUOtkw6bLoIH18u9cKOwSgYmsgTP302L9PDiSvCvkofepsPZNhXi0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fe8aL8paniNwa4D9aRosJj0Yh764CiSGygypWRBa7OY=;
 b=JBwvOMCzcqW33+j4kEWz5pn43EFoNabGP24U3rBcc2IB63v4gmRkoHwp8iAMFWCIpN1/bZ6gZUTPR8NJ81gbrWzgKOlHcITt8/bplOBo89anap5eFitiAGAyKMk0QCwUKQqZaujTN7NvyCdEANHrjcdw78jQtwhNlYScq9VYXSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS0PR10MB7271.namprd10.prod.outlook.com
 (2603:10b6:8:f6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7; Sat, 4 Feb
 2023 00:12:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6064.019; Sat, 4 Feb 2023
 00:12:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next] net: mscc: ocelot: un-export unused regmap symbols
Date:   Fri,  3 Feb 2023 16:12:11 -0800
Message-Id: <20230204001211.1764672-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS0PR10MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: c94257f9-b4e5-490f-f49e-08db06447c6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbBH29NuA0bprJkF7DP6PpOjOyi/SYSlkqWW5aWNBtH+GrRlhx0m5JjVk/iagZvhhRIOUyCojKE+os6qyIDBgB41i0fs9Bo8hJmpUdN5VDCdKJMxDjxtaVl9kBfDzrBnE3wTc4XVaT9J6YYyrI24ksJJfPNuFvkA7oJu1V3qpRc4W/7UsHVIW9/HCOt5Gt2X8lnSLtKR4ZtfTgXhp6v0z/1zlXEEy3D5XSQTDFI+r6SHs7E9jElqIO+QxTynGMwu7UzvAT6bUMOK2yHOiyh6APavMWXQrjOsNxWcEX47+USF5W4iosasgEbAHNZxbrcxUj2c36gjPZfutPOzja9TM0Q1MLOr2x3ndvFWHc4YI9A/c/0ODcPNykhV/04zA+KTHV/ndn/1AHJFNuWxcDTyKd8mesJqnOXrLYv/YUTBlO3XKAjINHiDLh+Geyo6mVQyPqKzPlqWXw/MBQvhgjJizX1gNmxh3Je34PZiQC88zVRTsFIEEypvuCuEYcNOU1uJ4SjY/F7EZZG5/BhRQqRlgvVvPadgOHK6IPE5sSxzM2DTKHaYrelxT/YTKSOF4C8Ophani6knwiqrVywwcxbgBNLj7hLjnBhlCV56kQ1wl7x4/czRybuvUHitIn/oiK0Po/6mcQpztaItEp1A3s6+4NE1cvVTo09vxGK3GHzlHcVckqjXvJC2zXeGujWoXfVqgeLHwY5lcSQ+XJLjgAp3Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(39840400004)(346002)(451199018)(36756003)(44832011)(66556008)(316002)(38100700002)(6506007)(54906003)(66946007)(8676002)(4326008)(83380400001)(38350700002)(5660300002)(6512007)(186003)(478600001)(1076003)(26005)(7416002)(6486002)(86362001)(41300700001)(66476007)(52116002)(2616005)(8936002)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FX8IUh5jgV4/rsctcEwPRtDmdtB2GJVX33m8Pv3R41jnqGbAxQ+aPZyQFrn/?=
 =?us-ascii?Q?gaGtdxCAz49lLgIjTzs3B/byawDcLibt6iU85NIemNA8KpOfB8CPLxlBhV1Z?=
 =?us-ascii?Q?iKJams+ZK/j3kcGX7QYE75/UgLeGMksdYKtNfUAWR5NEx7Iex6qXwG3Iz6hg?=
 =?us-ascii?Q?XKCgVVXwkd+0CMryXMR12DCQdPhEOApLqq/pO21deXFW1P4z/j7/MKpc6beZ?=
 =?us-ascii?Q?hl66v1IwYPWL3ArR6dQYPTx4NF/gGupW0pT8wK9PQ8gIi/PSN6Ir2ZoJUO0y?=
 =?us-ascii?Q?pRInAKP17KU+pPFo0eCP/I6cuC0c3d9vx259mbG6hSLUHbUZu0Snc6BFUTIh?=
 =?us-ascii?Q?pvNGf04DkgZKhESu+LO3lrDKHy9tjc3xrbajHr/mTsFYAEKHgB3+tQX32+dn?=
 =?us-ascii?Q?8iTM/upKYrL6brkIzMO0Js/zBbbxJsoXcqRscQbfX+ruBxV2HmgKlh2PGmgG?=
 =?us-ascii?Q?rToyHALIYezLzNdHMPuz/d9CQ9TctHX+zEfrQtDkjTp9Dl86Nfgziw8jk8+O?=
 =?us-ascii?Q?JZS+3JDbApYz057YLdX5woOpjdyFfG1B6MvCrofgiM7qhtD0h7ag8qUkwjXA?=
 =?us-ascii?Q?d2tfV4KEsof+VgjIQiEjr0drVF4GEBcG5oUZeSih9iMxg1nzju0+rxIzqfyb?=
 =?us-ascii?Q?uq0DB3JHYMF5GNs8eCGuEHWKuKjw68a94d10HRftofUz409CjKFP9sehMvLO?=
 =?us-ascii?Q?47ig11WHH3yTBGcCJnKiiuET3X2QsYDuDIS0tfVFZoLgCZ8+j5Y+bMg2Bbad?=
 =?us-ascii?Q?Ck8MFHsL7dvfSkOz+CSh7aEizfVGpihg6QvfYn1HlXM+E2toMu2Axb4se2fC?=
 =?us-ascii?Q?HHewU+gfj6Qvh6ijZNYregoGNiIoUgtubBAntb6+fDkojkODwrzxcnP4TpGX?=
 =?us-ascii?Q?JEE009cNVRYfuvIYQKgi2uFmoY6oeIwIOwxhxKkJCQELOieD7zzhTxmBj9Qo?=
 =?us-ascii?Q?a7/TtQ83ykpGbtxm5e14UZwECWKswkuiECE9W0NjLHSu4RIN2LcI/irBuRzD?=
 =?us-ascii?Q?x8gW15ESu1tjn6kRax2zbCVd047I1CH4eEcxHYm/tUKd8LHtn0EBLguNd2fW?=
 =?us-ascii?Q?5rOK9/RX1BqXZC5Swrp8GV/kFrQkODoS80xt8S6GLWNnbfnCDCMH/jejz8Co?=
 =?us-ascii?Q?hnuYDVjq/B3F1uh+YzLmfno/90QSFx3ZuN50c8hFFO6vBbuz4QB9TxAPmGal?=
 =?us-ascii?Q?k4vsPFFDuoY0gVxFKBTJf8ipitGTrycecVlWf4f27ejZ4hqDwFOqegXVnuHU?=
 =?us-ascii?Q?1dWLTZ4ubDOodEguCWc5Yctm0P9f6heqoqBVP3N3LxcKqej6SXqVESWVl927?=
 =?us-ascii?Q?CaTPI8S1BptE0ZPx6MwjLCSl1+0czASb9nM2YOY0GrLkF6cM1z/EoIL5vY01?=
 =?us-ascii?Q?Ci/XLyxk+MxicjYbkXpPsugrXR2qlFJkDParH12tlwmEcJ2x5dYWuajLC+mU?=
 =?us-ascii?Q?+Jwjfw1GjjuY795D2NAguMydTpFW37d5eDUTTGbq1rZSIoOWhGckWzj/hzzs?=
 =?us-ascii?Q?jx3YmyoEbsmP5XNO4lLYqZIFlSFAyX7ttnmVwBt9dKmwYFp0hwA6DdGE7+pe?=
 =?us-ascii?Q?KBe93lsJBeTrDatTRugF1hwL6rRTHiAOWgznfp/bjkJ0Y+QayLqQEpbnHnWg?=
 =?us-ascii?Q?AaRN/wBB9VLr3bnq6kZk5Ac=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94257f9-b4e5-490f-f49e-08db06447c6f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 00:12:22.0342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jp1aGrGBBkDbPgOZsLWRqy5GnfmZAQmRn8WhRMA4I45605c07Xu8E7baWx/TCXSp44ZHM3WeVMR/P6ouzUMhstLRABQ7XKSaa9uGvKxfkOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7271
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no external users of the vsc7514_*_regmap[] symbols. They were
exported in commit 32ecd22ba60b ("net: mscc: ocelot: split register
definitions to a separate file") with the intention of being used, but the
actual structure used in commit 2efaca411c96 ("net: mscc: ocelot: expose
vsc7514_regmap definition") ended up being all that was needed.

Bury these unnecessary symbols.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/vsc7514_regs.c | 24 ++++++++----------------
 include/soc/mscc/vsc7514_regs.h          |  9 ---------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index da0c0dcc8f81..9938f04aeefc 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -68,7 +68,7 @@ const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
 };
 EXPORT_SYMBOL(vsc7514_regfields);
 
-const u32 vsc7514_ana_regmap[] = {
+static const u32 vsc7514_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
 	REG(ANA_PORT_B_DOMAIN,				0x009008),
@@ -148,9 +148,8 @@ const u32 vsc7514_ana_regmap[] = {
 	REG(ANA_POL_HYST,				0x008bec),
 	REG(ANA_POL_MISC_CFG,				0x008bf0),
 };
-EXPORT_SYMBOL(vsc7514_ana_regmap);
 
-const u32 vsc7514_qs_regmap[] = {
+static const u32 vsc7514_qs_regmap[] = {
 	REG(QS_XTR_GRP_CFG,				0x000000),
 	REG(QS_XTR_RD,					0x000008),
 	REG(QS_XTR_FRM_PRUNING,				0x000010),
@@ -164,9 +163,8 @@ const u32 vsc7514_qs_regmap[] = {
 	REG(QS_INJ_ERR,					0x000040),
 	REG(QS_INH_DBG,					0x000048),
 };
-EXPORT_SYMBOL(vsc7514_qs_regmap);
 
-const u32 vsc7514_qsys_regmap[] = {
+static const u32 vsc7514_qsys_regmap[] = {
 	REG(QSYS_PORT_MODE,				0x011200),
 	REG(QSYS_SWITCH_PORT_MODE,			0x011234),
 	REG(QSYS_STAT_CNT_CFG,				0x011264),
@@ -209,9 +207,8 @@ const u32 vsc7514_qsys_regmap[] = {
 	REG(QSYS_SE_STATE,				0x00004c),
 	REG(QSYS_HSCH_MISC_CFG,				0x011388),
 };
-EXPORT_SYMBOL(vsc7514_qsys_regmap);
 
-const u32 vsc7514_rew_regmap[] = {
+static const u32 vsc7514_rew_regmap[] = {
 	REG(REW_PORT_VLAN_CFG,				0x000000),
 	REG(REW_TAG_CFG,				0x000004),
 	REG(REW_PORT_CFG,				0x000008),
@@ -224,9 +221,8 @@ const u32 vsc7514_rew_regmap[] = {
 	REG(REW_STAT_CFG,				0x000890),
 	REG(REW_PPT,					0x000680),
 };
-EXPORT_SYMBOL(vsc7514_rew_regmap);
 
-const u32 vsc7514_sys_regmap[] = {
+static const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_RX_OCTETS,			0x000000),
 	REG(SYS_COUNT_RX_UNICAST,			0x000004),
 	REG(SYS_COUNT_RX_MULTICAST,			0x000008),
@@ -347,9 +343,8 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_PTP_NXT,				0x0006c0),
 	REG(SYS_PTP_CFG,				0x0006c4),
 };
-EXPORT_SYMBOL(vsc7514_sys_regmap);
 
-const u32 vsc7514_vcap_regmap[] = {
+static const u32 vsc7514_vcap_regmap[] = {
 	/* VCAP_CORE_CFG */
 	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
 	REG(VCAP_CORE_MV_CFG,				0x000004),
@@ -371,9 +366,8 @@ const u32 vsc7514_vcap_regmap[] = {
 	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
 	REG(VCAP_CONST_IF_CNT,				0x0003bc),
 };
-EXPORT_SYMBOL(vsc7514_vcap_regmap);
 
-const u32 vsc7514_ptp_regmap[] = {
+static const u32 vsc7514_ptp_regmap[] = {
 	REG(PTP_PIN_CFG,				0x000000),
 	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
 	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
@@ -384,9 +378,8 @@ const u32 vsc7514_ptp_regmap[] = {
 	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
 	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
 };
-EXPORT_SYMBOL(vsc7514_ptp_regmap);
 
-const u32 vsc7514_dev_gmii_regmap[] = {
+static const u32 vsc7514_dev_gmii_regmap[] = {
 	REG(DEV_CLOCK_CFG,				0x0),
 	REG(DEV_PORT_MISC,				0x4),
 	REG(DEV_EVENTS,					0x8),
@@ -427,7 +420,6 @@ const u32 vsc7514_dev_gmii_regmap[] = {
 	REG(DEV_PCS_FX100_CFG,				0x94),
 	REG(DEV_PCS_FX100_STATUS,			0x98),
 };
-EXPORT_SYMBOL(vsc7514_dev_gmii_regmap);
 
 const u32 *vsc7514_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index dfb91629c8bd..79a9152cd08d 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -14,15 +14,6 @@ extern struct vcap_props vsc7514_vcap_props[];
 
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
-extern const u32 vsc7514_ana_regmap[];
-extern const u32 vsc7514_qs_regmap[];
-extern const u32 vsc7514_qsys_regmap[];
-extern const u32 vsc7514_rew_regmap[];
-extern const u32 vsc7514_sys_regmap[];
-extern const u32 vsc7514_vcap_regmap[];
-extern const u32 vsc7514_ptp_regmap[];
-extern const u32 vsc7514_dev_gmii_regmap[];
-
 extern const u32 *vsc7514_regmap[TARGET_MAX];
 
 extern const struct vcap_field vsc7514_vcap_es0_keys[];
-- 
2.25.1

