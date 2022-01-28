Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C944A0160
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351057AbiA1UGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:06:05 -0500
Received: from mail-dm6nam12on2138.outbound.protection.outlook.com ([40.107.243.138]:24992
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234456AbiA1UGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 15:06:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtyvyelrZACqVQKzxuNrJB9pdIxwVapRavHtmUydhRewYTBXjBUys/LdoILsQpcRzvAf6IXyVojDZ3eybin5WnLmjdaVyR5W0CBVhZznz73PQmShg24njLBijGhBpxrcHgZn/R20Po/PSVHrnUuQeLDoR9sIuQa3WHFmGyXGfxLajyVfJWaD74WTzUwSs0+HUEbwuHuZWRwqiOKd7seoJ9l4UPFMqi6jFmclmkzdoFgm2Y59oqRchS8G7gHn+cdS/ClsvBxDQl/COMuUj2nqQQcKxjs+FUPIt0iPK6lzjsRhrsMMgbRTFMql9jfU6Cd4hKFDwFlOF+NaOkziOw2B/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQDF4oCS4oyLJbH4+gGFq/wxc013Q8C8cVc0ZWNaAXo=;
 b=Are2QZZiGFcgXriZO74I7Bk5PsQfIgf/vAFhsa+cS+2mqyKvm5oX/ImEaL3PWjxdq42dGsOy6FHFUy+DTfkX0XlKgiuJw2RU149AH4e6hNuD3/H2J/ru96r34oMhDgmZX8WlSjlnfTCUHxGzPP7QkdUfo9MYSPq9fEReDdaNns1MtZJtnEmoN8zd19Nn+OnLxPgjPKOk/rxyGEf1kMArzSoUMLpi3jil4LB73UVn5Oix4fiKsjC78ekOxDSVAi5RdrQ3IX5WPkKih5Ys8QQ+xTqZcBEwa3UzZMvl9hZiY5GOXC/QL8za8MeL8wVNPYCkF0lEUm9Dkb8a1iXAWxNr1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQDF4oCS4oyLJbH4+gGFq/wxc013Q8C8cVc0ZWNaAXo=;
 b=jRmmy2gBvKuPH362BrGYGxQ+tiGjvChW5qUYqYO0blLHbcWLVbZULl3nbTbp1dM1rLpT4UZ01fvTnWrquPHnU862M1jEd8IbJIW8hk4g/nubT1o+20ftsyGx84W3V0v6Hh3gkvN2NQ1w+UKWEpFinn9R7hxImOyB6jXgYRGFfMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4969.namprd10.prod.outlook.com
 (2603:10b6:610:c8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Fri, 28 Jan
 2022 20:06:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Fri, 28 Jan 2022
 20:06:02 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 1/2] net: mscc: ocelot: add ability to perform bulk reads
Date:   Fri, 28 Jan 2022 12:05:48 -0800
Message-Id: <20220128200549.1634446-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128200549.1634446-1-colin.foster@in-advantage.com>
References: <20220128200549.1634446-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:303:8d::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48ea875b-850c-401e-fdc5-08d9e2999be4
X-MS-TrafficTypeDiagnostic: CH0PR10MB4969:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB4969CD5B4E81D2F254925643A4229@CH0PR10MB4969.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Oza6eEQxEBDSYqRGE3vIDmOGv1RW89jVBiVMihPbGZyOHp58SFn/KlvYsp0tMUi0hD6fwjGaMK27roBipi91Nnm46VPoSkTqD8r2cpqU9uXVTEvflxfEJKkXp+ERxIYWwGx++6Y0Z3lcfu/Hl/BfkhXntPnwL0VY7JJCiLcxYp+cXpqI2VYDK3+OWMkhpjQE6xvWOBUijhWCBIANSe9DzO7BbOHBy4Sb2hIR6IqEaC5BCaepbZZrARijpSC9ppxPDobY9d0E+bJBz8JDDNw9dXvrUSXNMEbB09jpumy2mtGLpoWUr0fzfKd545vwPNZ+ygorzjwurg8ktNRgA0sFEe41jLFcDSjpLFXXjCaU6qZlcDZJ86pKRismmfv6I7Ksl7WX8RLUHp0mB+dk1oe47eoeu+BBxQLvPdiR63m7TH8L0ExCCiFHF5nbF6bYXBefvBWc5n0sUN4Z/5zLe8lcJWSgzM5Bl7xXGhx1ZcXw9nw4qxHXQpethNM8KIiA0s6sHUoWndrQChS2TyTFJXVIwW/0mn25eAGxg5DMjDBCLCXYSMIcro4ZSDosHdMl8NkiIc+sAUL9BJ8SBfq/V9+cYwGDOP/kdTMC9g5Sw8I6qObzZA/bvRBRgjzzeKu4vim7q19sdo4P9+LhXNrdVINLi6wfP11XT1iT8RNz9/yQeNpegH1SYwGaz5HqqjaVO3pvpVAz6vo9B1IlEQdKJQ3mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(136003)(42606007)(346002)(366004)(83380400001)(2616005)(66556008)(66946007)(66476007)(36756003)(6506007)(6512007)(8676002)(6666004)(4326008)(8936002)(52116002)(38100700002)(38350700002)(26005)(44832011)(54906003)(5660300002)(316002)(508600001)(86362001)(6486002)(2906002)(186003)(1076003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H1HFo8xhpWfjx1Yi4NTvxGquk1DcxM9XNnEXnim35N/6+ueY/lX9FlawG9uJ?=
 =?us-ascii?Q?eCjGwBY7fPf3nVwsjgbf78Y6t2dU3EwKMsycP3vrFCWF5HtbliyqwMzr6nwW?=
 =?us-ascii?Q?K8LA4a8q/rAnNg/dSiQGfGWim7eyJLSqEwe0DeFcoQKn7pgMga88MBwdNbcl?=
 =?us-ascii?Q?Dg6vMGpLg51yHjQQv3Q+DoPTqr5kkJ9izIM1PteVXilbxM21xQyJGb+eP3Bp?=
 =?us-ascii?Q?xSTQonHOuL59Gx7GtdsiOq/igxK5SWgR42OzPLXf56iFOWYdIFNP6mkGWVd0?=
 =?us-ascii?Q?OIWnqDOGAtDW1eL7AZ/UJys+V7FKdPFUrDGPVfWeOC5iGSketnxYaaNiKF/N?=
 =?us-ascii?Q?ulzDLL9IHrLg+d9stqrAVkExlHxPnvHRxDU76htzI0/WytTPFq1d64ZvTL18?=
 =?us-ascii?Q?a59T7a5PE20oVP53XYhnZfkgL0T6C+KgHuQXK0wE2NfCrrGZSMqUserLJ+xR?=
 =?us-ascii?Q?OFwXVK5IZNWVg7DKDS84kDRhuKZmaL2FTGhlKf1lauNkseHVLhkKNjTwveHH?=
 =?us-ascii?Q?dS66CuoE2Bn5Ufs0afXfI+sAthOVhRZW7HCdiwifJSjmbQElohCgzNd9lJZ7?=
 =?us-ascii?Q?CRHuOBTevu0h27rBOuS/Cd5dzz0wmUidmNvdmf7q1QXoeZM1FeXVWHD63olR?=
 =?us-ascii?Q?hPQS7JyuY6FnNvUPDXeudbdX7G7CmeHdbiCXT5IT7xYvlCXcxyu7w+2Tz2G8?=
 =?us-ascii?Q?5pETI+wmeLwAV3HTaqJUlGR8yOu9V5XAEeys1z1O7SlVt2BQIXzrnvk7Oxq6?=
 =?us-ascii?Q?o+OoVXWWvw7aYUg6Tzsgd2UkKh8kOs8p370HwJ/2eQEdcs+4v5cUlpWBgZY0?=
 =?us-ascii?Q?yjXxqrNUuQQc1BwMqvA/U7LXWANQ1kaST/IMxU1sWD5ImEDbbxpQnxApJwkN?=
 =?us-ascii?Q?VSHv4bxh1sJLZNJJKbP2ivmeqYo0RbDJ4Kdnxws9hGXfRyJ66HAmST4zZjq/?=
 =?us-ascii?Q?EZvzIzbvMszuV/3cGx8koZuPEuEgV7GjVSdUajKunvYENEoRJJY/Vj/RgCF2?=
 =?us-ascii?Q?1qGdWH6Dvc5kcu9nKdTNlRZ42lGRWW1s1QoQbHEDCBDV/yk6xbTy6LNjCSRu?=
 =?us-ascii?Q?ctVzs2t7MEBQuOBXBEP54B1UKhTy9FViycCTLu2XHGeu1oPG96mJpMYqgQHN?=
 =?us-ascii?Q?W3pQfgROfGPzp6X+gyKIavkq4GhiHUCNGEekbmfMmCVKtw38T0p9bYBDFyNv?=
 =?us-ascii?Q?f19RtFABkrJL9N5CPk78lO4pBPnIhaqNbC7G7H4ZWsbQejRI4UudUSovhZFq?=
 =?us-ascii?Q?sENDqTu0WYcZNRNRdKvN+2paaVTtt925ZHUmc2VlsKaz93/MlIB6MIW4eTEn?=
 =?us-ascii?Q?3WjD2Z5u7koLrIMcqK3yeJAnZF90E1Bp1xVI3Us89IFEfUgM68+eZIiaanZp?=
 =?us-ascii?Q?+7WiNcRNKv7FLzbyAXuvcWYBV3043QEtTzSTNkCgOlsqWSjnT3+eWj7fjfrX?=
 =?us-ascii?Q?6czmSOjhzyMlnS0dZHe1TrDyRgoM1YVawTxkBM1bj+55xH6ex78h4VHaGE2J?=
 =?us-ascii?Q?VyNiBq/Qry2TO1DBdrOCqkToCzyNybz5VDJQcO4ohvngkafwRCUofOVBEkMr?=
 =?us-ascii?Q?vZ1Rcd0qNCKauWyccfnrE1GVcK9rID1oOdSyZVA9OAtcy8gPaX6nTi81Rfii?=
 =?us-ascii?Q?g5hyLB30Tsh41EqPI8CAbnIX0iEt1YFYJsHEI0kZzs2EQbDgEPKYW2XSwjpw?=
 =?us-ascii?Q?HzmQSQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ea875b-850c-401e-fdc5-08d9e2999be4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 20:06:02.5484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvho/WcSSQZ9+tg5QaPdjbWURjqDMPwenYB1QE8c6ZYqjkAIuOZtOu3RP/olDfwU/jiIenHBN8TnxMr097AvU9bJfM7Gv/Dhi44LmmNfiFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4969
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap supports bulk register reads. Ocelot does not. This patch adds
support for Ocelot to invoke bulk regmap reads. That will allow any driver
that performs consecutive reads over memory regions to optimize that
access.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h             |  4 ++++
 2 files changed, 17 insertions(+)

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
index 62cd61d4142e..b66e5abe04a7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -744,6 +744,8 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+#define ocelot_bulk_read_rix(ocelot, reg, ri, buf, count) __ocelot_bulk_read_ix(ocelot, reg, reg##_RSZ * (ri), buf, count)
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -786,6 +788,8 @@ struct ocelot_policer {
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

