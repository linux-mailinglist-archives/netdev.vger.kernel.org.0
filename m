Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19DB4AD0D6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346994AbiBHFcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347019AbiBHErB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:47:01 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2125.outbound.protection.outlook.com [40.107.244.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2B5C0401DC;
        Mon,  7 Feb 2022 20:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kdc8MDTi5Zp2uounsgcJS/NjUh+jPJcfNi8XEkg2Ub5E3tEqZ5ksloXIR/QfSxO5yf/nHR6frYFjLr58IQQf8x8rh30ZdGdEhxGjXEvKF+tI1YVz3evWphMdKa4BENqvhTzACHekVVWefsCQxGNvPOfY7b9j9HXLgZYv6OFkSo0btPVK2oN/erFOxEbUVUzN+YAhBtZKYUu7qr1Pgza5QKIFveL8SSeSx/lm276/agvJ9saYmiCv+BvoSNLAKCPfGSS4etx4TqGNpdIwl8f4YStYpfy6XzZ22vKrizQP7h7dF/fk6z41bjDwjzXkk9wlWgNRwWIVgLAqCcFTBeEekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw3CFL0LhDMQEJy0xv5ELwfu7cQIQ3X/C9+1ecOuKEA=;
 b=RmDuMuaXinOq36xNVtngfcGkw2QjrkcU8D1JoLjCKV9eCtv7aTFdkLCSkXyixagbTH7H6garwG5vTHKQII5FY/TOJdAhPvGW41e/H3smEikE0qTGufH/Rsak3JCjRnMGVTaFttBWO+v30QpTsLu5btoL7HSyODnEehX5WByu2AbONEv/C3cTrs1Rnzb81cernoz5MKg8Fm3mxGxEdphu7/2eFmS51aQtZfBWCjucywM4Q84cOUBfTSp/IYBYO3k/ESP8obx5q5vsgNWppJhbBM6DNP9SgWqKzaMdnhDB5RPb5e9tUh3zDtT1855kfprT0gFJt87+veC/y5/jLs2bXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw3CFL0LhDMQEJy0xv5ELwfu7cQIQ3X/C9+1ecOuKEA=;
 b=m7AnT4Ob+4kkG2zvLjeWWn7alkxmEsppTUPqVZduGSBmU2X7bx/QT2pl5LvzIJBISbM5YMg7vCOSkP2+e/7bcjb9auTPVOiQKV5rd5QqOA9eDIhfPsGM8VQZg21CD4W3XSQ9OdrWazKG0eGKtVQA+RPLk0ycee0PIX50FNTP6hM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4394.namprd10.prod.outlook.com
 (2603:10b6:5:221::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 04:46:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 04:46:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 2/3] net: mscc: ocelot: add ability to perform bulk reads
Date:   Mon,  7 Feb 2022 20:46:43 -0800
Message-Id: <20220208044644.359951-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220208044644.359951-1-colin.foster@in-advantage.com>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0090.namprd17.prod.outlook.com
 (2603:10b6:300:c2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a712c7f-e351-45d5-d402-08d9eabe0843
X-MS-TrafficTypeDiagnostic: DM6PR10MB4394:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4394BD917BB9E9E3038D42DCA42D9@DM6PR10MB4394.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B8sQFA6KCgTs8St6lF9GDzXHpV+M9QKX1ksNv/hLs7HwQ4eCiF1+ybqIGOtzk99dd1hwFcInCRVf/VE3sFLyIp8CqfQ7pCEyuszE1/Lw5VJcwtY/myx8v0PBrvxIn0Yh9IPigLExz6VwwlvThP/3J8R0E5EidYyfhgDm0Dh1UrK+b2oCqq57Z0E+DNPQA0x74wZNaF9booH7Ea8n7/nmfZLRnzr6lxB/DuhCvM2R3NtZkjODLCIvWXsGPk2fXnd1/qYlBQMadG5WQyyTeJdoATKJG7F+tkLB3DE9fLebWArO1r4Av/r3PgqIP6Iwo4BbFuqqkrGp7KERyTm5/JmTFq566frRnaxs+n9hPAoeQopURqVkcTQj6HkpUv6RlstF7iJ48LtdEY61sTS2YtgrQv0fIlXvwVQFuKk1Vd584zFDcMzm3k2whU+KMBRywfc5YhznrsgRIIhApqLIB0w2H7AW3/9eQkTE5RX0TCsG83LX5iHnd68/l03MXaqsGq5WA2cPxJ9/bm+icpgxdLRfrs//8mff87uW8nMnXZ9u7UP4qpIRpW6i2sDA9/LK9SsOhIdFeFc6NuhXfM2Hhz8yCDMOtLElTnaqgSLsttJXgZElJOboab02BOmjtuY+lisKhDvKvVm/eyE+eqM3iBZAeJF7acE5BMBI3gwyPc48Oi1GrsX7v5gIW5o+gtZ8cw/n2aWxTv20yJf1DX3Wyun1Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(376002)(39830400003)(42606007)(136003)(366004)(52116002)(1076003)(186003)(6486002)(6506007)(508600001)(86362001)(26005)(36756003)(2616005)(6666004)(6512007)(54906003)(83380400001)(5660300002)(66946007)(8936002)(2906002)(4326008)(66556008)(8676002)(66476007)(38350700002)(44832011)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SgU87+OKS7RtWQYMIRCr6TjO6ADlVLnAhXomyVm/jF0tpFVITKZRsYvQyo06?=
 =?us-ascii?Q?LtlIV8vuXwJa3LEF9VRZSuPxBp7GioF0ATS/gZTXODvQ3JqKWs/64amXAdvl?=
 =?us-ascii?Q?sA4hxIAnjrFthuEUqCdaorVvpndmEZGSsGzVPBZk7Vyc2jUtrlUFWOzMTMPx?=
 =?us-ascii?Q?ZHeF0pwvUL0arZ1WHNMRhfiVe53S54DmQSH++cgHM6cCH1u3oQRuMk9Bgfce?=
 =?us-ascii?Q?wByNI9kQxZAhrGrwlzPY4a9+dbjmsVr+HXYsqFMskFLNwJdu+Fn0XjafIyv0?=
 =?us-ascii?Q?hTTFR6D48T82sPI9NKqf16+Zot3kVtk+UOWRB+26md2fXPSuorFPt+PyL6QK?=
 =?us-ascii?Q?iv78BFC0eqobARGVCOgsAn+ghFRwvdynwrhhjxHCoUL8fFIV8OhPg4+mjXby?=
 =?us-ascii?Q?IM9p9ZhNkrjxs5b3b9O4r5a4fIzV7OC5745L6+tPvnA2Y1FESt1yBy03ZdZQ?=
 =?us-ascii?Q?U1U6/wZvI96SQXdd94JQXMHwZy+7O0agSf5WEAhyCOeVSjXEIFidLQdDP5jJ?=
 =?us-ascii?Q?mUA50LEYiwYDHCxB0g5/0IuzK0LNOHSeBUOZY/8mF6USz0S5Vb41D+lQlY5x?=
 =?us-ascii?Q?Tqd3GG+hOKOdSz+vGo4MwO8kfZ55UnNJ5sv14UwXuWY58pXJvGKo1vySFZon?=
 =?us-ascii?Q?rAG6aIdRaCW/yHUCIvd8JjRT5RYM1KDm/yWnCk/IISBSWKTuAmTcYbbgac19?=
 =?us-ascii?Q?xYrAv/H68kbf/P1F6yiE1r/n7WvbKc7dTG/Q/B0rQDzR7pv1lwYvPBGtpXFn?=
 =?us-ascii?Q?d8C+YmdaiBgcHIBgqxWsyyNeJUhm1g3ju4I/SYr7Aj2Uk/jRqcLD8Lc9vo6V?=
 =?us-ascii?Q?ZGDvn7X/rATUICxwHS2eEZVV3j0GOJg5CgNhF/vOUrX7+ZaMuZvfBNHF4gAK?=
 =?us-ascii?Q?djok++vyo31wU2ks8p7NVyZtzbTeT8mx0ExOKCWCH5BB51XKBeH3xDdoE0aL?=
 =?us-ascii?Q?kSmBCsy59S3rusgn5iaUh0C7JDH34Ct5krUlnzdEDIChiSq5pUlviANa81aX?=
 =?us-ascii?Q?7mz9o+9s1NnJx26lAQb9aoUwS85cza+pQmu2wbyTNbzXTU94E463U6tWllAv?=
 =?us-ascii?Q?Xdne0Z5JYcOypw7RtLYjKwphvIUB0ADZ15Uqv1MkGJpx3rioIfvDvmaHK7v2?=
 =?us-ascii?Q?O1F/gDaBBxEK3CgvcvVcCOJozfSDPaorMwokpKz9hEoiUdu7avmopIrxXV5s?=
 =?us-ascii?Q?xn1ILr2Und7K7jKR4x/K9/UmdMnj8H2M0g1eJToyuGcIKHUOS4bFrIxTJCNG?=
 =?us-ascii?Q?AN7W+gfrdjbC/XDt1lpLrtKrd2qR+pumyIwxFT6YewIswpPTQ5VRGWRvDp4m?=
 =?us-ascii?Q?oeq37NO8lCR9cEWEkYzt4IO9b9NmyFRwafBk8hnl10h/g2w63MaBY1XH7IZa?=
 =?us-ascii?Q?LNjZN25RFE0Xs1J1U8WGJpfJCJnPSQseUUMEQCB7utKPakkJggnPwnFKo8We?=
 =?us-ascii?Q?dyRoI6aVNVzf/vMIzT+m5r71qGIYDE3PMWLcSmNQUZqBGUGYeIB93mnYGgi1?=
 =?us-ascii?Q?7/7pgsXxE2BmcKJSA3s2aIjrKy0Don8GyPe43p52Cx+nu8uZcFrVTsuRgh/f?=
 =?us-ascii?Q?l4zoTZo4y3LnIv09X1WbeRRPIROmoffyZ23LUM2Q/RBWHj8W42i4pehn0zF3?=
 =?us-ascii?Q?FxfKGz3vUmwjmj4J4oYt8r0CZjmr/hE06iUXUEDeJVslj9iK9eHVJbeo9XWZ?=
 =?us-ascii?Q?dSIHhQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a712c7f-e351-45d5-d402-08d9eabe0843
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:46:55.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmPmHVyfohUrX5rz8Rgr3H6CdPMtCRV4veJu/ahOoPf00w5bSQpuMhM6wb8zHcpUBJ6mEoCrOE3WMA0m2b37cLbOWmDuRRUIkZLqVWL1QGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4394
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

