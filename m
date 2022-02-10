Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E751E4B0459
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 05:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiBJEPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 23:15:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiBJEPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 23:15:39 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2134.outbound.protection.outlook.com [40.107.243.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A97272D;
        Wed,  9 Feb 2022 20:15:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBeUBeacs5vzvXsFTRaHcZPnDEP7n5Iym45qhJfZGTcozEYRGO8+GG+nOFfBL2AdhjT7Rn6JtF3OfI5rFFnFjb5S9SMhyqkWArJ7KpnMzmkm4at6PbEDDwJkUUBqfXGsSjfqQF1NWyiyXasQqzpguM2fdeoo3Jz9P4ncIt4qnyysnpWvKHHaL1mFFUBi/SmZehdhxtINGABzjf4CQUzizU5xbN8mWRdkQ9PI1nsQz22RSCrKmyM/yvhgeGS3ek1bJzIwp4YtGaUluyYuFFMzCdUrjGrpDFJAcyA5EJdsEQ1+NirugK6Hf/RaBie9QX28mIMrjBX9wTt0Y3h+iBi8Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nv5AjNp/bsPNTC6KiiFtIi7/+Szne1J4+M/2V0nzN8=;
 b=i5wqJf3sh6Iq6nPFpldFxMBEKWNECJ/tJ3RdClF/jbpi7+5L0o6+YLtpNvxpgq6URUYyzoRkG07ZGtH7SISWdCaLKBnOcxMNtRp7r9odXqPyiqKSh+ZOg9aj2C38xGNFsHtFQKmkEwcG1qFAROvrt6kpK/7N65BvSFkouBBFMPehAAWiMhDzXEbuszBUDdQnWwIYopFLWqZpPUymFXIcgX5LJt7q2fT95lj9M9vumzMrPAiWAErytfifcXqbOX20ty0E6tc7GHAsimwYanRZWi0s1J3wCtwZdLiFmffZOsK97U6M3dFc4NCdSLg7KI8YUun+MVYHGaVtQbRtfM0mBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nv5AjNp/bsPNTC6KiiFtIi7/+Szne1J4+M/2V0nzN8=;
 b=zWOiNrW1ws2OwB0Zx/bQkZeg1v/8UnMcKsIyRehWosktzPPpuTUes4g1TinZxcL0G3Rcfm4HmGNzPXhi/XiRQ+ZAT4FtylsX/YdTG83UudeSYGEtUVrcjagVoNVJK26EuYBZ9nSSkA9B9ZAzT2/tie1Kl9ASYcz+FxQCvgAlm8I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 04:15:37 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::bcda:8606:7c7a:b1d4%3]) with mapi id 15.20.4951.017; Thu, 10 Feb 2022
 04:15:37 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v6 net-next 4/5] net: mscc: ocelot: add ability to perform bulk reads
Date:   Wed,  9 Feb 2022 20:13:44 -0800
Message-Id: <20220210041345.321216-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210041345.321216-1-colin.foster@in-advantage.com>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8d0da1a-ec18-4e4c-76d6-08d9ec4bfdaf
X-MS-TrafficTypeDiagnostic: BN0PR10MB5048:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB5048BBD98468A891E0C34D1FA42F9@BN0PR10MB5048.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEaMtEUSzfFQa+35YOEOOG65UayMK9W8ZOK0J1UvzDHJNu8f26qlGMJcB+qlWiTzObAubhIvt1/KcY1SON4TnjanUjoFRQzWFygdgrKj45mZcHfTYkoqJuPImVsE16+0jhfD84VFKkFcxxCJVtXeTPzW9Nlt0hggPr7ghWZWSw0RkDLxmsu2HDkymhGnoQgmNWVQQmHZB/dGK6uv3EJCCpI9uqOSORWGUaMWGuK/+mLOI8sKPfFSVnYf8WcalmpbN0+U6Vjt4painzZKINQC+6DvSiNlbd9nQqZUeV3i1Ja4/ZlRN/CrJZuLdd9KMWhnfRMiDaHu1in5+YSJKbPda6QHyv1jTOvSfwNApbenO+8GJ4x+NM9IVojPftGn4Sn8nZkWAii7t18IeAp2KkSz0Ko9SGb1R3OGPM70O7dJRvgrZSgAwlWPGLTAreRqB0Rb7gDRLEybeZekxI1QhVcRCpPEygWtT7LcF8fOivWXlBoiDM/sUuhpQKQFkKkw7Vd7/sTeWWakCSpE8nZ3bbNkcfGq/xUJslbPO3GA0LiwneacKvGnjmF1Z1vpjd6TIY5eX2iO1t+YNIjSEgPJVX9jWPgBgsebPwnm7KejP0Liu2/F63D3ozMq34r4FLFfrgJhVesT9hAEqJjwoPKPwNfxFHIBSQUa8+BWetjKczYD8piTKmWM0ptO/pMaprbEBt8UyFpXHXmpTAmpRjqpvmvjwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(42606007)(136003)(39830400003)(396003)(376002)(316002)(4326008)(44832011)(66946007)(6512007)(86362001)(52116002)(66476007)(8936002)(6506007)(66556008)(54906003)(83380400001)(8676002)(1076003)(36756003)(2906002)(186003)(2616005)(5660300002)(26005)(38350700002)(38100700002)(6486002)(508600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FkX6hErs5t8jncaHoA7nJaSM43s39VWrOad7sgHDFqBYCYhOXby68pjT0cLy?=
 =?us-ascii?Q?C2bfcBvb1Db4JqMdp/aGiom5mIFwnNN8VlsG+jYpAlMCa9ETrmL3SfF3Ui6s?=
 =?us-ascii?Q?0xI059PnpTincp1Ocq80nvUN5pPWB/fN6h+ZoprCPZoSiewxhZiH3jCvSAEf?=
 =?us-ascii?Q?JQgPidhS3JyfRINndm4iiPIRa737GKZOG8SBt0Qtxoi9J+NeWECAvp5CSmFC?=
 =?us-ascii?Q?VNQpHIPLbKGEQaEJ846URN/PBi7EJkb0Wg2Fc6ScH0OpwErbmV5/1qIa58i0?=
 =?us-ascii?Q?zll++WdoC4LMVx5bqyJxFO/voJBKN0jt1djeyWtJz2v/7Mtvqz97CH1Mu0Xc?=
 =?us-ascii?Q?Y9nXa8UpY6a8JvG6HHLzsLcb9q9YWend7WHe2MFhCn99F4tXNYdTdtxIZvjo?=
 =?us-ascii?Q?xEARcXXoeCDD+8hhGVfUZne+vyClBq+g4Ou6e2s7EwptZJEudaB17sSyjyYR?=
 =?us-ascii?Q?BYAgZKkGRoy8eYjrtWodn8A5Or+F3YED3tGyFkOC/IDJ0v0AH7EZPGqS/dza?=
 =?us-ascii?Q?DplBzGXLtDao2JeiUPuKYdVfElk0JRDLEhQVPNapoS+xu5Bq7SnyPSQCzbkY?=
 =?us-ascii?Q?+XFoMWtoEc/W3AczP25iWKpTBKPwOOg4mwgZpxQhocQxbmHJP9ohDmYv28Vt?=
 =?us-ascii?Q?QTBzbK6MPgRvtE4zteoXDW8h8C63dfAxeo8X2UL2/n5NAvMc9esYti/nKIxF?=
 =?us-ascii?Q?Ryp3xoVl4RnXL5VXbJaDxDuPMgADRY972goThcsCe5U9KEUva9MvCV1Qlpqo?=
 =?us-ascii?Q?RdAqNUY6rzo6pKenkaK7cDaAgQ3KlzxTeAV6mIGRRopFNpV5zAglj+tpbJ/F?=
 =?us-ascii?Q?vWydwjWQiyFDI+OsSSLlGXBYfPACMlOLPRg9ofUlTbMVSWpxOfziJE2FBKRN?=
 =?us-ascii?Q?u6JbG/kX7i06Hv00VgR4cPY40ma2RPcHL4sv4Hb7EQCmdvO0amoWwaPEQbFT?=
 =?us-ascii?Q?mcESYCiT5lTLRDSZMlDpBI9qseqoBRKgCdXYZs8LWnzftEdHvvwXMv2+Zs7E?=
 =?us-ascii?Q?XLlcFomEocI40n/4LLXDdeoWrH2ThMLDxm7camAmpo9qhKP1c8owivQnJdnH?=
 =?us-ascii?Q?rHaqkXzB9svpoEheX63WXUSxidsb1yMif5UHhFiwe46BlQ/y7W6L7at1SKwc?=
 =?us-ascii?Q?Hwin6GTEbkwRVtyiFXY+uGZpZHURFzZ5gG7mxLzJN8hR7fKtidvcltUVbtB4?=
 =?us-ascii?Q?gw5FQUIdVjYFl/xdUEjt0JBjVB6oFYeg6FzJXnwU1mzjQSY/Ki+8KC+zkjIU?=
 =?us-ascii?Q?c433jtP+PUA4SFYrRa+0DBctVrsjPr4RKjjvRz1p+ADP/43xmg31jfM8w/Vr?=
 =?us-ascii?Q?6nEBKweWtxv6fj/PQSuhoOYYW2HHj8DIcEAXINwtpuEsuPBk1WbNu5jHpNgL?=
 =?us-ascii?Q?5hIB0hgSkLRoZ5/AzQ6v+gTQ2nQpZClVI8Mk8ovL+I+a+wVROglxfgfcWmGd?=
 =?us-ascii?Q?yESZHF6xlfCwY4tqeTPCXQu85k515KVRGrm5ufzsKGu8VA3mRoY2f93PPCs1?=
 =?us-ascii?Q?PinNxDj5s0/1l7Vd0dAO8yqm9c5TajBei9nbHoWDTJLAU52dbAOob1t/zeh2?=
 =?us-ascii?Q?oAkxFNLqTRJP/mTyuEaIwX/ZVsJyTEaZuM+/IFZHL1k/My9gJZopwdq1J8X9?=
 =?us-ascii?Q?eTOhX0JhfVPux77rdeE+/A1bdSrfq1L4X4TvE/pFI0bKTCix9xu3uabc031h?=
 =?us-ascii?Q?v76tNQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d0da1a-ec18-4e4c-76d6-08d9ec4bfdaf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 04:15:37.5910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7dW+pRO8RGVLs/X2CFwt4T0loEzBE/1ehlhjKMDSupoJ6RvaZ+0VZPPR7e142DaQoHWa/r+GBSS5a+lc5hTAvpMaGmoTF7bYshdJnYw/lkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
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

