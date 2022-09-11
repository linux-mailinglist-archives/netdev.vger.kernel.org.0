Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B245B5111
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiIKUDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiIKUDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0827FEE;
        Sun, 11 Sep 2022 13:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4Dzs9PN0poK2bdW1Lizgd1NgG2BpzMKikJxr+0KycXByOd3YmR2c/pb24eIchERXmjhWWXxr5z6IU4xXDPheHb0/aHSsmG0sG55e/PFSm2XLHF88yaUykaGu3aUNU1UT/caaPNCTIf/273+nx1BbT9wZzoB2S4mpQAEtI6Sar0t9x1R3TUTXe6cGmHUVL0PrfO6Cw4eyofX+Brr2lnEgKZXqL9jfGhFV1Gc1iB04fmFxuSQxD5QWUZZEtOZYiNmvcRF8l5UNiPac2ZJJDfNVhEElQl8NlOu7IJHWW/quK7onlh7gwOKKgEdWGJ8mNJqIZHRd564Bhjx09NzyCNaJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toccuXRpC9GIrGKziX5sBEWXnnDtbF9gLspgZwGNLTk=;
 b=j0iGE08zlFDKuHPmGhT3uFOw8DsH6N5YTZgvXg4rJAYQsj07LvzaF4qW/ceP/j/AVhEgMatzt0+lwQMWozhck6DAgiGmh2eT5jnz5KDvzOVbElwiIk3fn05G2TEpe8gBTdx5kVAZx7P3cjTWiZWPIYW+D/kduX8tDeVfpnVa3tnTL7M/YWUeYjfmF90bYrRoUiwIf3S9yLqr8/qol2U2q6avuuFvH2qyiNxyXOfhE3Z+BGQWBKQRELOkwWX9h1ipugCoX2TdsByV05lXV+rrtYQlv1wzQKc4a32sdT8+J6jD4bKuGbLR+8WkMYG0aeLMa4048lDxmbR8CgXT6P4byA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toccuXRpC9GIrGKziX5sBEWXnnDtbF9gLspgZwGNLTk=;
 b=VYhbE/SsIm0tfOBBlvnBLUvwvKa0/WiP611T5e5MFNTCedaqFBpF01s0mrlw3kj2lV7wWXU4PQZyicdK2cGUcu8ZQhSSPYMW6BcoIbOIq/1XZO4U08mCmHs9+VVcFZDtQxRBGF+dRsioVDY/CPKPb2epW+VgCKv4E9mkBKy114g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:59 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Date:   Sun, 11 Sep 2022 13:02:43 -0700
Message-Id: <20220911200244.549029-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 411269ed-8e74-4608-ae74-08da94309f5c
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZuCdRCmVBBXTgR0uWD7xyRAO40MryP/7D7XQsKb7gLKyghDXnvLo2jDtqS7sYgphJwf82Sj59I5B+6jy7PGiB7GN6wRf5nQ74E/EUCbXkrMfs+cHiPPyA51QvapR6+ShCEZRWm3qaEJVgPsPjIBgy4d3rMD4m+HfGTuPBuOLUv8RoUn9EG0uvQM1cnoNpf4U9rdJ1IxRWtndh+w7u7hFpyOJvEpeEg9Obml2JQoepmIAV4SWkebptod1Jw+IlxypjeQns1aFm3Hb1ZDKRMxpdosjy5uyfM9+QLXgsvprZMYj4hQ7xWLbaBxtJ8gQJRnL9/01Z+ooBHeUG73HqiBvsczRpXX2zbdKTwIXeUmUVnwXQntw5hpk0kagvUfAU0Q/ugbH9R87JxC8z2ZnVWHW2NE7lgQ5BvHOnoIiORKT5azZD/GHQ8ouRnTY4i+Xl3Mi9P7kheVMLa4+RG7mdG5pviONQPSR4Bwg7XinNzv0CkMaYA4/RkP7GhEB8bJfJ7FpPf97ja4illAHUDcKAa3ujlpiZueoivjts7jstUgEA3OamohaWgPHr/DhZLyQQAcxXpO52YhYgjG16Hu1tIi0rav/fVekDjyYWTfrIpJxNm+ZZvlSTSe+fbzND/szDW0XLFZ70hjcLF4cgRZ4yPJVNPGsjAKgrJuHZVIymUHY4iKatZ54bm1iQX/k8IUGeFy9n6+k82e5ABChhSlvWEr5MW0L7KRCUY7v59lgmTiXul5gWDXyB04jic1sa5v+YdHMtdlJKTL8cZytj0HTI5XOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nZA4ZNXE/GHMPNx1Ms7D/onahZAodHQzvE+hcEzybbuUL9QdbPbLoVJAuKCc?=
 =?us-ascii?Q?+SFOl6kQczvNKljlMz+JX+cXK1yT1OsXoEJ82LhAc11bKs/NMKkQzLcX7Q1V?=
 =?us-ascii?Q?STYhkX4jP82rlzGVUKcytZ22geARyikAdk/7+TO1GmnJ9xMIL0G3cV83IEXS?=
 =?us-ascii?Q?irJNIaifosvpYfnJed42PUmInRz1mqcNF7175wVRBxMP3VbfjlKSNoAFL5kp?=
 =?us-ascii?Q?RK1Iv+/rnJdypo+PtwLpF1OyVkw24JEfEpaBxKzfl+BKPS7M9ME78Phjojrw?=
 =?us-ascii?Q?0shO1ShZGysX5Ji6Iq7OW+VIWFamMWYjXVZvZXFDddpf4XkqhR1VjYAmWBo7?=
 =?us-ascii?Q?2a4N9x+/TR0d6eKon31ricDZueAI7SoJJtK34wohraYueBWx/iD2FvEIg9R7?=
 =?us-ascii?Q?fukgcpsFuexe7hYADCCu27FIkE1+IhUfexncpvE7No0/1LvRxFUD8SJNuuBa?=
 =?us-ascii?Q?Fk/WwWqb4kU6mv8AkWSWD4TY0F5kmroklQ0pPvg+v6z4sDKl/6gFZOaEqQkC?=
 =?us-ascii?Q?jSdVJN/yeJKEwn6ZQBy/AxqxBU6nwxV0vnh/YeHhpKj9jbtFltLQeNlhbCWg?=
 =?us-ascii?Q?G3CoqshVuR1h80n9rjHSZ+kxG+dZltq9vuoC0JO5w7dOHlVvB3xevE9/m+Vq?=
 =?us-ascii?Q?9T3NUQmDYq7M93nvm0ZJg+JbB4Ig20SeEua1LhhUM5iX4aTZIbanguPdO0A0?=
 =?us-ascii?Q?XFVt/ksAArxlyBnwYOrLG3SpwF8kFYodYo6b4mB3SE8WFAy3TQuGq64PRQQ2?=
 =?us-ascii?Q?B/yIzMV6CQFXwD2kGR3pK0myazZlPyn+9KyKxBcssewDYEqFBSsnRbI1SiOr?=
 =?us-ascii?Q?JYUEYCMqZ50uMUWuKojunDvXxaAHW1e3GSYT1cgXizrsz5QYzZcOOPtq5CAK?=
 =?us-ascii?Q?yvwiBINlAfJOZf+Ke7J0CBuMEj7kMed+Safnm4rJ5Zrbu1qgQGGPWeMmOdo/?=
 =?us-ascii?Q?L5cwPZMo1S3HojAMws2B17eZ1p/paM8dzePRZMXfxHsuckYviGtJbZiz5E0d?=
 =?us-ascii?Q?LnJ/e3XpXu7jbZxrDZYnKkVlLfgtPRE/DRlP2SrkcxzoC8h+WfVTFsWbfi/w?=
 =?us-ascii?Q?sW9LZSNs25PIsJcJ23idnwyzcytCnSpI8xtUEk1yT9JqSwl6Vfghn546K3ZB?=
 =?us-ascii?Q?YWiKMDTiRNHuP0Z8NKmFGZUB9B30bYyzpRi8+Dwf+BdvinBOFY4e3ZHiArHq?=
 =?us-ascii?Q?k+Wc90xoi+Wv/4O6m+h/HG7dWGzOGtdmtJRbR9aBsyhIMTg9v3Q0qsjqRXze?=
 =?us-ascii?Q?A3A9uOzYzmwv0kQ8v71QK7iUQyXRHYLd4XClVjoO/gSJGqF5W5eqw6PBIEsG?=
 =?us-ascii?Q?6Cq9Jg2OiRK4bf9C409XUMKD8E1YV5XSrypYJwNQt6kpkVvRYzY1H4OL9b3h?=
 =?us-ascii?Q?laEP8hQWiVfkNpz+iSqsldg8YBoc391+NcUOGUQwKPk4do2M273PkYYukoj3?=
 =?us-ascii?Q?jkoDTyDwQGmFJBi60M2toJchWxv4DR0Q2OY22lL2ll4P3ILDQ2cp3z8OHvTL?=
 =?us-ascii?Q?9SaLNd3UBK5GWf4LmrvSpzW3KMBTyxHdJS9stBycwNYOR+c/ET8CONKAz8Yw?=
 =?us-ascii?Q?ybN2kWeRzwc33SE3xN2vKE5i1YNz1n3TzlWdNaOSBAxkuk53XenhUWFx5Iwm?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 411269ed-8e74-4608-ae74-08da94309f5c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:58.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mZWWhUm8uZbRC6cESMlZK0/660TCP5rdXT6Ykc+PI67i82EOwjVyNJQK+qGDgzdQSqrzdPGlBoIq+4ncyZaUa0HqsLKVVLqXjRujSTbpOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ocelot switch core driver relies heavily on a fixed array of resources
for both ports and peripherals. This is in contrast to existing peripherals
- pinctrl for example - which have a one-to-one mapping of driver <>
resource. As such, these regmaps must be created differently so that
enumeration-based offsets are preserved.

Register the regmaps to the core MFD device unconditionally so they can be
referenced by the Ocelot switch / Felix DSA systems.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 from previous RFC:
    * New patch

---
 drivers/mfd/ocelot-core.c  | 88 +++++++++++++++++++++++++++++++++++---
 include/linux/mfd/ocelot.h |  5 +++
 2 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 1816d52c65c5..aa7fa21b354c 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -34,16 +34,55 @@
 
 #define VSC7512_MIIM0_RES_START		0x7107009c
 #define VSC7512_MIIM1_RES_START		0x710700c0
-#define VSC7512_MIIM_RES_SIZE		0x024
+#define VSC7512_MIIM_RES_SIZE		0x00000024
 
 #define VSC7512_PHY_RES_START		0x710700f0
-#define VSC7512_PHY_RES_SIZE		0x004
+#define VSC7512_PHY_RES_SIZE		0x00000004
 
 #define VSC7512_GPIO_RES_START		0x71070034
-#define VSC7512_GPIO_RES_SIZE		0x06c
+#define VSC7512_GPIO_RES_SIZE		0x0000006c
 
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
-#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+#define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
+
+#define VSC7512_HSIO_RES_START		0x710d0000
+#define VSC7512_HSIO_RES_SIZE		0x00000128
+
+#define VSC7512_ANA_RES_START		0x71880000
+#define VSC7512_ANA_RES_SIZE		0x00010000
+
+#define VSC7512_QS_RES_START		0x71080000
+#define VSC7512_QS_RES_SIZE		0x00000100
+
+#define VSC7512_QSYS_RES_START		0x71800000
+#define VSC7512_QSYS_RES_SIZE		0x00200000
+
+#define VSC7512_REW_RES_START		0x71030000
+#define VSC7512_REW_RES_SIZE		0x00010000
+
+#define VSC7512_SYS_RES_START		0x71010000
+#define VSC7512_SYS_RES_SIZE		0x00010000
+
+#define VSC7512_S0_RES_START		0x71040000
+#define VSC7512_S1_RES_START		0x71050000
+#define VSC7512_S2_RES_START		0x71060000
+#define VSC7512_S_RES_SIZE		0x00000400
+
+#define VSC7512_GCB_RES_START		0x71070000
+#define VSC7512_GCB_RES_SIZE		0x0000022c
+
+#define VSC7512_PORT_0_RES_START	0x711e0000
+#define VSC7512_PORT_1_RES_START	0x711f0000
+#define VSC7512_PORT_2_RES_START	0x71200000
+#define VSC7512_PORT_3_RES_START	0x71210000
+#define VSC7512_PORT_4_RES_START	0x71220000
+#define VSC7512_PORT_5_RES_START	0x71230000
+#define VSC7512_PORT_6_RES_START	0x71240000
+#define VSC7512_PORT_7_RES_START	0x71250000
+#define VSC7512_PORT_8_RES_START	0x71260000
+#define VSC7512_PORT_9_RES_START	0x71270000
+#define VSC7512_PORT_10_RES_START	0x71280000
+#define VSC7512_PORT_RES_SIZE		0x00010000
 
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
@@ -96,6 +135,34 @@ static const struct resource vsc7512_sgpio_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
 };
 
+const struct resource vsc7512_target_io_res[TARGET_MAX] = {
+	[ANA] = DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
+	[QS] = DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
+	[QSYS] = DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
+	[REW] = DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
+	[SYS] = DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_SIZE, "sys"),
+	[S0] = DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VSC7512_S_RES_SIZE, "s0"),
+	[S1] = DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VSC7512_S_RES_SIZE, "s1"),
+	[S2] = DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VSC7512_S_RES_SIZE, "s2"),
+	[GCB] = DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE, "devcpu_gcb"),
+	[HSIO] = DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
+};
+
+const struct resource vsc7512_port_io_res[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_0_RES_START, VSC7512_PORT_RES_SIZE, "port0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_1_RES_START, VSC7512_PORT_RES_SIZE, "port1"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_2_RES_START, VSC7512_PORT_RES_SIZE, "port2"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_3_RES_START, VSC7512_PORT_RES_SIZE, "port3"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_4_RES_START, VSC7512_PORT_RES_SIZE, "port4"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_5_RES_START, VSC7512_PORT_RES_SIZE, "port5"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_6_RES_START, VSC7512_PORT_RES_SIZE, "port6"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_7_RES_START, VSC7512_PORT_RES_SIZE, "port7"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_8_RES_START, VSC7512_PORT_RES_SIZE, "port8"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_9_RES_START, VSC7512_PORT_RES_SIZE, "port9"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_10_RES_START, VSC7512_PORT_RES_SIZE, "port10"),
+	{}
+};
+
 static const struct mfd_cell vsc7512_devs[] = {
 	{
 		.name = "ocelot-pinctrl",
@@ -127,7 +194,7 @@ static const struct mfd_cell vsc7512_devs[] = {
 static void ocelot_core_try_add_regmap(struct device *dev,
 				       const struct resource *res)
 {
-	if (dev_get_regmap(dev, res->name))
+	if (!res->start || dev_get_regmap(dev, res->name))
 		return;
 
 	ocelot_spi_init_regmap(dev, res);
@@ -144,6 +211,7 @@ static void ocelot_core_try_add_regmaps(struct device *dev,
 
 int ocelot_core_init(struct device *dev)
 {
+	const struct resource *port_res;
 	int i, ndevs;
 
 	ndevs = ARRAY_SIZE(vsc7512_devs);
@@ -151,6 +219,16 @@ int ocelot_core_init(struct device *dev)
 	for (i = 0; i < ndevs; i++)
 		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
 
+	/*
+	 * Both the target_io_res and tbe port_io_res structs need to be referenced directly by
+	 * the ocelot_ext driver, so they can't be attached to the dev directly
+	 */
+	for (i = 0; i < TARGET_MAX; i++)
+		ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);
+
+	for (port_res = vsc7512_port_io_res; port_res->start; port_res++)
+		ocelot_core_try_add_regmap(dev, port_res);
+
 	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, ndevs, NULL, 0, NULL);
 }
 EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
index dd72073d2d4f..439ff5256cf0 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -11,8 +11,13 @@
 #include <linux/regmap.h>
 #include <linux/types.h>
 
+#include <soc/mscc/ocelot.h>
+
 struct resource;
 
+extern const struct resource vsc7512_target_io_res[TARGET_MAX];
+extern const struct resource vsc7512_port_io_res[];
+
 static inline struct regmap *
 ocelot_regmap_from_resource_optional(struct platform_device *pdev,
 				     unsigned int index,
-- 
2.25.1

