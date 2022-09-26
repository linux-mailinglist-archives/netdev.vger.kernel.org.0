Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B451A5E975C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiIZAcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiIZAb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:31:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2103.outbound.protection.outlook.com [40.107.96.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B002BB2A;
        Sun, 25 Sep 2022 17:30:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPq+GLN0iteNFYRa1VsjSL/JPHsigd+olCYE9uaqCNrjRfnTJixmEmMfPIcNrWWvvmWOGzj8yu7eI5ElDchfzTM+Mnin4XI7I8q22sza+/+h0bnZLUlWfD3d9fDUNiQDttC8g3l+OGOPuUUBFY5yQ5Gud2AERlcEeUzLj3jqxZRU/5QSPr2R/9t2nou4fR1zD3pQf0j78O8gRN95ZOGiVm1Cp0/LFig8hchrv/nsRDRGa1IgMFZbdwEBdBREspuJO5/VwGbtg5CRUNohykALpX0FXcO6sUs/I1Ty1vOKf4/p07y55pri98iTn9g6jn2xA7LceyAFBLFN76GGPLvLnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnbrng3C39HxQG17YiICGr64osjT34z8DO2fFxIDC4Q=;
 b=aHLYflVUjULdlbAhQoj9dEArYBoMzSFMCB7YYNsgRKEcdkup3QgR8A7pgc4TiwN2g3fRJg4hZ41BD8cqeW+/e5H2X69zHldX3AoLW5TD8Q5xEzNZS2yi5RCdMurMzG3KfT/hWmSbaTdoi48xfXzQRm9bC1dBjmdFdAlw6r3IFiosAMh0MdlTngIhHv/UYf5KAERlo9/8P1FALnJy1/+uqgS20w2zehTzsfp5ZyihsMc7B4n6dVqT3KCAUHQwzkd881XzJKrtDfoMDu5t5kluoM+b07fSSM16GTkLP4/seNj1CTOd6yiQO8RY0E87ur0v1AzBuKwMIVdB/hE3dqRgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnbrng3C39HxQG17YiICGr64osjT34z8DO2fFxIDC4Q=;
 b=iTox6RNmrDc0EGvtSe72rbWpF1NBMIMt+SawLCNyN50s9s5zX9g1sxWkeADu6zktV9bKJPfOtms0ZRH6nEaHHeL3ec9oj1keprO29IoFumpR7ohyqyOX33Qgm8rl1xCrp15ZFxFvDDjaG89OSe2rLEzv4u8Lul4eT9NKOXQ+dHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:26 +0000
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
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 11/14] mfd: ocelot: add regmaps for ocelot_ext
Date:   Sun, 25 Sep 2022 17:29:25 -0700
Message-Id: <20220926002928.2744638-12-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: b4dd2333-fa3b-46e1-40e8-08da9f564e3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: unwSLHwhjFsYyPQxSjPHCo10IIa2YVpfa5EcoGexHegwCfIbeHCMXHZCoXHxpNKoCQhZE80YTG889vzotXqHbboR5cev8i/3e2bcoIeT4AAGBDisVXRgFZyo+PQUxNfdy9PidRUjFa2tIlsIlO5e3l/9MhMCYWyjl75rUsoRkYh5xdi1dkDd1SxifthXUxCUnk4hQK/kbnGp0bqMldsOY7yrZpQDftxgixkHtSo3FrOyRbViJf9vT469+A9CvDDF/GqqTZsorJiVe+HBtNI7WqzsfDJ5bRm26o3UnSY+y9ApRL4+DWmZYmpKhAOlwYLhXDLU15CCJaAnkiC6Obck75i2dCgjtpJ2Eq+pIhAOH977cOz7a6J+ZdK1+4DAz0b50cGbPNpL7y7geGksd0xmf14jI98n6Zm6V2QcIu1uJjb0N7sdcqmZ5t5QqLyP1+NPyBkilzTFRIaVHXxiOwXrQ74rxqUeG+QtU7sQ1BaA341ubRBMTNwG/63b8vgu77A/O07e//R0LMYKl+Gsr2+Z9ppqhVYoFDBwuPAt2F6Us/XrvQ75993CaGqr8xO44wKsbWq3ADFAV3X3z86UdUGgQW7hNk3y6Lu3sRruB2WkqaRQva8stU/xrq82BzYdt4LJi50n6+TK4GQ4Y0LsogELFYk7lMtuhxyD3Wb3svf2D0IjMDa1fRMRnx/YBhM47PfDwkFp4PRPl9siW91SRKqXTaDqXAkCDYA2humoG8TVZRVaFTYojrMRAPN7s0ExmqgB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/fnGFz7+9HYuzcLdZ5NoJSEEshoB8aiQh05VcBNZXkZ7nUE8JkmkZCzociK1?=
 =?us-ascii?Q?bkE/wcGxxJ+LhquySzsL0jzlXitcU2ojHFFkVBeeurAWce21aXRNB0YY22S8?=
 =?us-ascii?Q?9Vq89QHHNDQ9yW9c40hp4p8OV9gNdf4xaKN9pn/pTKGVYwYl2KJqhzE4nijx?=
 =?us-ascii?Q?+mFcZCl//t8n49f7JogXeHxj+o/WXOzYazpmv80/4vZou9HCLco1gf3rmz2O?=
 =?us-ascii?Q?BGCiTMYXheJmvfU+dZqUSU7p28+ZYamdTHehImR0lwSj+iyutC99kA6S9Hic?=
 =?us-ascii?Q?/XBQj49UP+Uoq2Hsl7tEZ2ibNvewpy5ecbvHAwDNEMrbfRmKVbHeaYEm1mwD?=
 =?us-ascii?Q?owcP1fziDdftaOqMXQFxx8W4MbdVQp7Uqcg4DbU9TB1bo2xP4sPOAAd1wmep?=
 =?us-ascii?Q?NfxyY4zaRL+uslbSLlrIzli+6AiNi+QDtlrD6QC0ggCif6+fBtuByqw1Cy7+?=
 =?us-ascii?Q?NFsoHZHt9rOqrVjFJhicI3Ih96FK0FtrOtXoHIRwLALGbMC17qzO+p4039SG?=
 =?us-ascii?Q?nOhrKoRvvwHb/v9NB74NpnRU2HbrxaoAaAzT6bj5iM8GLCiQ0501HhJISx7Q?=
 =?us-ascii?Q?3yD3k6BJuCcrqrQMiFC3bj0uNXYkupRqPrVwjJXOE/AIHTgRhJgH2mLJiUu7?=
 =?us-ascii?Q?9R3NZsEuvDJgkfLsvGVtUyN15ihQO3VopVxpV7Ck3qcxt4RmR/vtTJcjylJs?=
 =?us-ascii?Q?H8CBxXPTKb+rD7chMVHgMVLoEVTmvGAoIkd9bbWpl6arpKrVG5Otlhd2uciK?=
 =?us-ascii?Q?RSehiEyfHfL+9iXxFQCXMsR92j88hMFNhGVrvcHDmgXZnqVs0XPXdsof8s4m?=
 =?us-ascii?Q?dGhEqVb8oy+yjwrmVBhIIoVOYDM64jNHnlYTvIY/3Fu4ERVv6BwrlRmodPiK?=
 =?us-ascii?Q?haO7NZCQn37KBE6tk7KiVHI7qxKV+fljmkfw/Az2k1qd8loCU0zve/E72zEZ?=
 =?us-ascii?Q?kTvGcfzkDXargZ6o2KeLbrJM+rKuuN8EoL3iWQn64TJZFKfd1iYN2ta8GC+k?=
 =?us-ascii?Q?cjapSGQdp5ViMz/s0UiCvE2xIo0YvP1jYouphyHM2ynbQmJ8DolCpGhKAmc6?=
 =?us-ascii?Q?13sREgbw+tDTk560q2OyySYql3+tDRJxsqHcP1WTRU+IQMAQOieddTC2DFZQ?=
 =?us-ascii?Q?4Ix3UcUuOHFE8rWOUjiG1CCvCwG6mzYlZSr9kn2l1/qlC3BZTSsbQ0rnB+PB?=
 =?us-ascii?Q?IODJ2Mu5TniQwhtfQALJy2ZT2ZhSgSMQ+LbLHrrKJ+qFLJIsjkFMkJi12nd/?=
 =?us-ascii?Q?WjySk8l/HgbG034O0oAhX37dAVV5XogDETpvInNlz9us23sAUgDSMuSN2mYQ?=
 =?us-ascii?Q?JcI28slNXCKxRfyK7TGpUv4BEbRz9TWPN3yMc5lJdh0c3KZHzLA6/+e5k58l?=
 =?us-ascii?Q?US8iCKFgrALTqfXyOVPxjDeDBdg2AHlkd0B3xIud0Ibvb8nXJ2VOwtllNwMe?=
 =?us-ascii?Q?MRD17bmPWe0wyD12IG1ikb5EVDrtrzSlIEpJzjUwAZTCJ6ZoO0n5XCP0Zzrq?=
 =?us-ascii?Q?m3quKT0d1VQDHEpn1rmBMj4wGIKm7LYKS6lS/Np/AN2/DEjXdh42Ad9NTrhx?=
 =?us-ascii?Q?Z2e7u391bDhxXX3RtIpPIgtzu7kg3tlOS38Z4a/JzacWq92YR62wqCw+F26z?=
 =?us-ascii?Q?7bTKnE1bV7wtCP4ZHPbXurg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4dd2333-fa3b-46e1-40e8-08da9f564e3a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:25.6353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOx792GIKyKyHs9MtnyFBkgwRZLwNbk2Uz4ivK12irKgk0mOK2SG8r/LYiqe9oEJcPdc5qbbdcEpR7wX551x6M3Y/klAnRIpZgQosCQyJXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

v3
    * No change

v2
    * Alignment of variables broken out to a separate patch
    * Structs now correctly use EXPORT_SYMBOL*
    * Logic moved and comments added to clear up conditionals around
      vsc7512_target_io_res[i].start

v1 from previous RFC:
    * New patch

---
 drivers/mfd/ocelot-core.c  | 87 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ocelot.h |  5 +++
 2 files changed, 92 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 013e83173062..702555fbdcc5 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -45,6 +45,45 @@
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
 #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
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
+
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
 
@@ -96,6 +135,36 @@ static const struct resource vsc7512_sgpio_resources[] = {
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
+EXPORT_SYMBOL_NS(vsc7512_target_io_res, MFD_OCELOT);
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
+EXPORT_SYMBOL_NS(vsc7512_port_io_res, MFD_OCELOT);
+
 static const struct mfd_cell vsc7512_devs[] = {
 	{
 		.name = "ocelot-pinctrl",
@@ -144,6 +213,7 @@ static void ocelot_core_try_add_regmaps(struct device *dev,
 
 int ocelot_core_init(struct device *dev)
 {
+	const struct resource *port_res;
 	int i, ndevs;
 
 	ndevs = ARRAY_SIZE(vsc7512_devs);
@@ -151,6 +221,23 @@ int ocelot_core_init(struct device *dev)
 	for (i = 0; i < ndevs; i++)
 		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
 
+	/*
+	 * Both the target_io_res and the port_io_res structs need to be referenced directly by
+	 * the ocelot_ext driver, so they can't be attached to the dev directly and referenced by
+	 * offset like the rest of the drivers. Instead, create these regmaps always and allow any
+	 * children look these up by name.
+	 */
+	for (i = 0; i < TARGET_MAX; i++)
+		/*
+		 * The target_io_res array is sparsely populated. Use .start as an indication that
+		 * the entry isn't defined
+		 */
+		if (vsc7512_target_io_res[i].start)
+			ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);
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

