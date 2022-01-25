Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75E649AD85
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442662AbiAYHVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:21:04 -0500
Received: from mail-co1nam11on2118.outbound.protection.outlook.com ([40.107.220.118]:4612
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1443677AbiAYHQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 02:16:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdaaOvJYiOj49gdDRZWeUW6y/3TV9vdH8D1EAc3nExC/aIezUyru4PgZi+jv6gUVqhsk/DDxpLGtNE03hTkUfD8vOxGyjS9EgIe8WyQqElLeeEgcVLpXoVXc69oRC3LYKskAvEZVg9bZfdGTR/+uKmJRXf0OyZ+zDnSGaJEdofLGEUcdSMheF4D4AcNZPbj/pfUyc49TWxaolgTK0Htzr+WD695YV0k479ldJiEKsfyxJ9a2/BGPrj1qvo2JrkU4HvXjv6gCJ3xQMCQukAjxoJNhdCn0gmIK2gBrnEHuGaZnCIApKF7ccOzIFHimWyGaMc3QGoPb9sRmWYFls8mBOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQDF4oCS4oyLJbH4+gGFq/wxc013Q8C8cVc0ZWNaAXo=;
 b=D0NRkBZ8wjdQAEg+qYamDAaU1gWcDzqIvd82mb+QF+8jLzbWpfOC6rMVIEqovz5SINFWU68VCbHkemLIXNlalcE5iUnmHBg2ZootEibtNJkg6UqeTtD6Nsvpi6r8qQ5cuzVO/Jo6AQKpgswFqJlUAxU1MC31l+fTIN0z5Be+sDvO5Q27C+9uoojmredYxz3I6Nm6cS1zMyDspeFSalSprAzJnKqedIPgehWT09Aqq1QFibulsCA/dG8UyQcQbeLZY7Tkhi1m9vnAAshdlUcfslpvucN4GcmfqS2NiqJMcDdI3DJxMurLMnvz3Kge4dWQre7aey9Ikw5xCilLIBj4kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQDF4oCS4oyLJbH4+gGFq/wxc013Q8C8cVc0ZWNaAXo=;
 b=D0PP4/2FAQz3LEI7BA3XWqRexOYPBlu3IB5YkjT3Tw9aFSVjiK0ESFwo2FzKjKsJOfxoAez+SNhb5jv0TLdwEZHOkB3hBM0snhf9V/ogaXjKIH8Y+SIkon+KyAqM6ghV1IKrxSzPR4a6noxbUkunZ7iZt5Og7d0Y0TgaSWY6iEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB2538.namprd10.prod.outlook.com
 (2603:10b6:5:b3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 07:15:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 07:15:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 1/2] net: mscc: ocelot: add ability to perform bulk reads
Date:   Mon, 24 Jan 2022 23:15:30 -0800
Message-Id: <20220125071531.1181948-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125071531.1181948-1-colin.foster@in-advantage.com>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR20CA0028.namprd20.prod.outlook.com
 (2603:10b6:300:ed::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93ed2847-8f81-42a7-6591-08d9dfd27f7b
X-MS-TrafficTypeDiagnostic: DM6PR10MB2538:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB253878C1AC0D78B19F4A9F40A45F9@DM6PR10MB2538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwyfB7bc9HWRE5uXAYhclfGLk3oGQO1omoL8G1o4vflz4cxGas8plmQ7CA4uiRVgfhmrKVoI7yLUUR9Hk8gkmZ21q1ZXCos2yJ8VL4mX0JwOa7LP7anopfiNDy47hO7VgUX4NI+Wt7CdUKXnoBEfyXAQwWb8Z4kjwxe9Ya5UyL113QFLKY0CVfVxdweHXycjL5Hw+sZUYdXUuD0eFO6AQ8HnMZe4ni6rkMwefkB1QDLNpk+rTwdZ2+6RZkowh8njYwuC87VHNpPUN/HIx6HQsQWIkoc0r89xF2sEl+jKxeTLTK2deM4WWCH1nryMPbGxbM2kb4WgIyRZx9PH+2pI34vLBDf2dKYucMsP9PSXfi1ZlVH4xQ5R8Uh/wjXs5nU6JN9VRGRoYWzk26WGj9fZX+47ztLfqtYbmrIVA3yvgnEhOHDJpyz4WpAKNa3hH0E0o2FUoRfIiAhGnguCyRsdwPRJ4H5c3D/QP1UoyGo9eRNOBWdc8nlLKM8yZaUDe3eJcKfzf4P64ezxAFEibvaIbkxdETCtKz6cqPtqDdYMyYakyrMKc9WV3Zej9UFEWfiqB2UWTVeAVtkVRJdulJV9SaVQS9cMfZvn+TakiUhDCVl5SNqNA7yDGVnCf1M5FKhZ3emSq4y3eWlzahkYL3U/S5+JEzNseEEq9aTUazO6ko/ScigcmefS7wMGHxaZNdC2c8qYhhEfJqi/f9hZnRCkSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(42606007)(366004)(39830400003)(66946007)(38350700002)(6666004)(2906002)(8936002)(36756003)(38100700002)(508600001)(6512007)(2616005)(8676002)(5660300002)(316002)(4326008)(44832011)(6506007)(52116002)(54906003)(86362001)(83380400001)(26005)(66556008)(186003)(66476007)(1076003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f9+CK+Hl77m5X+vu82aJqu7CwmC0IZJaJmQjd19M9JRrPTg15KeYZD9T7fTQ?=
 =?us-ascii?Q?VRVvqa9M7l8fhZM8wTSD0ZGD87YAOsaiKpwUtc0zh/PjcjBRSeRcXx4oV21D?=
 =?us-ascii?Q?LTNVFrOrRZPw4+l2ih03KGaDdFvQ3U3qDL/Wz/apKIx+WzSNSHOrlQA07jVN?=
 =?us-ascii?Q?moYli8t3wRkzDNNGU8k8MigGltkoJeh5e3jUC/DP5DeHostC0u+GywcM+sGV?=
 =?us-ascii?Q?Sm2gFevEPSb6UsM1p7qs5lguAu8vNl/YJDUs4tPnwaBBH8o+5J1btEC0b9S3?=
 =?us-ascii?Q?DvxXNBrOKWdepOWgRP6t7FQyrg4DyByH6zk0SuPl3dXKZlf+ggRkyOhO/Jui?=
 =?us-ascii?Q?Br6hH2HedKqt+bh3tHv7nMr1H23Gb21Uj+O9PmpYlp5XUuy4kSmUgFHwlyre?=
 =?us-ascii?Q?oyLbqiYvCVhsM1O29UuS4gZkBZ30aUYh8eOeDallGLed1nOWWrXLPevytCfV?=
 =?us-ascii?Q?eyCwVfSngg57axYQQYJRaoUuUeYBekqqhUyjOMTHhoCUHrTiUwDtEmpwYMpF?=
 =?us-ascii?Q?+cKXMf4jjhzIZlfdEUYGMruCVHEpXEeqlGl75R8Lhxg9ZvkTweViorCqmVr3?=
 =?us-ascii?Q?1hI3epOaVEvP9HrK5VutgFGlIG9p4Ql8IbjDTg1RC0q6H0APH03sdkoQ7qEE?=
 =?us-ascii?Q?kSPvdzoaXH2Rjm0McFCBTMUQ556YS6oyEwtqo7Owr2VHVCW7Q5WSLo74QmGA?=
 =?us-ascii?Q?y2XgPZXbAqVCHUUzchK9VY1OS6Om+rwfxpwYgOyHS0M1s5tXGyAvhLyHCmcW?=
 =?us-ascii?Q?x8g6OlqlHsAAUMU/zDGeyaW3sSxD04NO7b57O7u7/dXBLKQjbbF31bM/WyFZ?=
 =?us-ascii?Q?2vNKMudJjJ5lN3IQztFg32l6rA2Hk0NnBLtlQZOTWtpnMI7R+SnL0B+Emx5b?=
 =?us-ascii?Q?JybgYr1GSNzr8R/hAfpgUEfwwJFlcQU4IdmYs6Ey5VBq1UxWool+DCJXte/s?=
 =?us-ascii?Q?GNu5v7gYATYb9OCCjTzQPdnpJvD0S7A2v0yI7DVjF63a1q8IbwBChwTheG7b?=
 =?us-ascii?Q?0bICDyxylEb3kShuR1ocM9yAy4PRT43XiUxoQ/7fEV3IMZltriso8oLSQPB4?=
 =?us-ascii?Q?tAzB7OF22BxyzclL0ovYs1HshzWazk52DvyQRJ9++9vZvswdpGSKaCmnWstw?=
 =?us-ascii?Q?mtji/b8hO9LRQgYJkyJWbXfx7ENmGqCBn4dniWPYraFEYMygYsglAkzJnVk3?=
 =?us-ascii?Q?XXrEJrXB19DYObPP+rGdy9iFirdznCqGDXfFzwyF2CutByhjdPaMruuVDfCi?=
 =?us-ascii?Q?sFSDVoMNX6xa8svJ2gtypFvGsh54heVQ9CMyiepuQVPNSzh8iTuC/SzmbICe?=
 =?us-ascii?Q?XrMDFWIeM7aaXCL50g5ct1n+IGkckaPuIGL1eg7p9V7x6kxL9diYRUHaKw8Q?=
 =?us-ascii?Q?kxJTreViZmH1PbOsq+WtFHl5grxL7SCPB3UngtQX+Nv0yYe7bUJ+mkENQiZd?=
 =?us-ascii?Q?nGdApDeqQR8DMOKturiL07hRe5HmTVMvTT2ejF+P2g2tpgCLqXNZa3mIl9zu?=
 =?us-ascii?Q?kx7sLl/LC8d291pIcNkxN7IrM+Xsr8n0Qj1LbeUNCShyYpI16NcwwIuRtlBT?=
 =?us-ascii?Q?Bo8DnM1BwHBTkUFptR+6VhgMrVh/ZmewdZd4YkHSsK2CQAR3hLQ8eF5SL10O?=
 =?us-ascii?Q?lvyK3r5ooSilIegKn+uXjAvQ/8Mp9bV6BiM3T4JIlC6sXp5eCW8GNpZtaUSZ?=
 =?us-ascii?Q?bi1ihbFHGKHAgbeHcidXtSLdwaY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ed2847-8f81-42a7-6591-08d9dfd27f7b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 07:15:42.6586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Scwc8LsM9dT7UPtJWX6D3MSswX6Ic90MB63lmD47XTLi+kstJwiwafgPANZlvl11cKe+qdizsitL539PuMLWbNbCcE+qEHdWPMPmLpca5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2538
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

