Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BAC51EF66
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiEHTGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382489AbiEHS5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2110.outbound.protection.outlook.com [40.107.223.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A3A1B1;
        Sun,  8 May 2022 11:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epFBlAWC0q3uYzWWb8a66+4Ymot1xqQy5CGF/Psu/ESykmr09yBWO59VgVy8NazaQZZcjpnsMIsbepGmBECHPY1pzDmf2wSru86scHpkUkRNGLlDcMgmvwQn/ZuR2PHcTsfAHakiwD57/TrOWL2QIGxT72sE4fsNNwr5DslhArJUzmHYgnBNcKXeaqmXbppv+O4Ntq/bIOpErputlweZ/amyTu6HtMtDYXlyef/Zj3cuaFWtG6btDq1ZmOhU1Rh93tjt/sWMlzXTRoKZsjYefdV2ziaG8M/BJwEAreyoG9nGjrzVSpz8V3ZTifoxdAnDIFV7jcd2SaCEvpjosnST2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gr3RrEyb/DUf/WdSeJx7VBv1lpuyEPZzjfYuaGTuTz4=;
 b=HfQ0BHm8Sr//68qVPzrOO0jvb+dF0aI/P3mJJ4T1deBK3JnglXFvZnLS6Ahg+cFeZC5i2ltK0SMnMexdY9xIY/2wIdfDeQEb1AkyYJXu6e4e8blOD3BR/WvHFFYUxAjf3up6zR1e0nGg2eZG7LEPCTA6Dkr6C5kOcBfrxHYmcdoSIKv5Miq3JDUeT+2APwR7Ewrm728+NNTvwwNVMIB9FfCvOicWCshrk5rfn91F83V6NZ1hxS1C6/jgOWjz1pw1ZoIQI61XaEFFJZwbpF6/V5yZnWEAkTTt1dVQ0TtLoDhaHTDMPK0TpCv1kCAhvfr1qGOD7ltBl0x8J7SRGKI+pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gr3RrEyb/DUf/WdSeJx7VBv1lpuyEPZzjfYuaGTuTz4=;
 b=nExIePods8S6XRxxPkKIvAD2ZTrQCvaUjCGYQeSVb+7/G7M9xcnrP8Pd6upqmfZhjy9s3SxELMcp/5HHxsApPaD7jtMnzY6G3LgkErV6VD+0homoJBzed3z7x3uqy4JIz3JndbeywOG88Jzn6dX/ucgaXE8iHZHRDuC/340FOt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 06/16] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Sun,  8 May 2022 11:53:03 -0700
Message-Id: <20220508185313.2222956-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd86c6ff-6fbe-43e3-719c-08da31241131
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55332D278CF5032C0874BAEFA4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGHGFKiKcF7m5e5Gp+Y8FIsVv4iVu6JBYZv2XgNaRbIR/wg5MmDrZEcIeZfqmr+cxMtgWxxrvk9Yn9IF5vHqtEC/m90DZlc14ye36o3Z29SuY+VCzm5xcHo+OhOiM6Mm8AavI845Bhfuo0jcsHF3QJcqlOfSwBXF3VIYanCxCrNwSUD1U3n80VhUdUfB+nnsX2cJRuDokSIWxSezDCmc0Rm+qGHe9maPT49SOSl4niJo4CCQkouQyaVg1c/2ov8b/i8JNTp45VkVIRd4lExYxt4Fc5U72gnGWkG3AU0l7kvIEimUn9FLuvJskcZ1fMTvqkgn2dI2BeTl3EO70CyJfiqhL8T0t1dPHbgm/crXGNB6WWzpvS/kNF7QIHKnoZBU/53i8hIy2Q17UgKuQ+7AGeoU7z1TVyaCM/Bse1HOt3aZuUtoquTkG/DoFrFaQ/MC3ehNt6jnt9u4IvUyWPUjODj8GEMk3x9wiZLZnsDA6Q7upbt2oANsEKVwyrmWOyt8TUIBBuCTogaKG/uXnUJulM0V5CA1Eml+0rUZHb3BquFUHHX2umPk46Wg9vYdxKe9SRdRm+sNYbYXDiK6REgXPZVOmN1TjffpvmFvgawRiTyUons0JHONMbJPHk+LEFTiwG66hvic/mCTKy1qpFWDS7/4/cLCAhGkZENjMNmj6PQateFhwafZlykdvkgOCKZWuzcfBmatFBzEGEYa/J+0Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zNCtRUddtzAw5l+w0NmOiHE/kkXIxbU4TXpRtbceV2z+Ca76Q+bMIVzOvdxa?=
 =?us-ascii?Q?HdHy2gB1guhq2oyEbDEa32zZgud6GWFLrvz6EcoLevmop77xRNXJjTM7NUJO?=
 =?us-ascii?Q?8jp3n6Cd5aFKOHiQUS/UQAKNfYL6Ak8jUPEVevt71bOy+/i0QtmfSgIP2W2l?=
 =?us-ascii?Q?Abvu5+XR3DR9m56lnft9Eh+FZXjEyTo9T5v/7kc/fNPHGVkckTjx5uethdWI?=
 =?us-ascii?Q?2ee9d0go+TN0fVob9Ud9zbgZO7SWItGBZfkzb/12wjzCTobe7pYeQaGm4vPk?=
 =?us-ascii?Q?UPWicW2Bo7KTZl84DKLMExeF1N2dHrL3VZKZrCGaqXU/1N3K4bz6YgzpBy8a?=
 =?us-ascii?Q?EIo3tz/z2UL6scedZPrv9yQ+UaBSl17+Za/ZXNk7qL3Mr/llKOQCxArsyYaQ?=
 =?us-ascii?Q?rHA615ukV5Sy1/U3Baql9Tx/8i6ZfSAScJ7Bmz6o9xdfMpx6/UucNIP/AyiG?=
 =?us-ascii?Q?eDoHxYNAYcmyVqOYGHZgOmNiGZbSD3nyAQRgpCvDs99qK+ZcAzTcfIv3vNPR?=
 =?us-ascii?Q?t7pYngkWpw/Jq1gPj+baxLTEYOJxFDN2Zm56fWlR7FlLBi7C8xOPbbNhRLDM?=
 =?us-ascii?Q?cFucPxv+WefWX2oNfFCrCNqfgI6bU+0wQkVPQ6IxR03tMW7mwtP/wNdNxz6y?=
 =?us-ascii?Q?daCYLUZGhPPU7ZIkx5nZrnywkp2zvMUxLFYP/L2UsGOWBIXWAEt3ZKApppPW?=
 =?us-ascii?Q?cqbSf1MIfd/Xht7iP/UoIIf3II/AiqdAeeoo8FcWoi/SNa4Ws4H6X+NpfkGS?=
 =?us-ascii?Q?52C/NcLwhWOWMH5f6h0IC9eNDzecSuRpVKbF3CAl5Fc7IiRfqVDSsjL1Uk//?=
 =?us-ascii?Q?8RoIhk1zQ/qFVlGTqcAVIiXX4TLVBXAqcHHiNTWD6W+RumWV455v7EQaonki?=
 =?us-ascii?Q?WbgO0GmIIlQHuUhcYSIMfM+Dob18njh/wNyzHRfmIqJNtrtm0yJX3iIgSShQ?=
 =?us-ascii?Q?LgTXF9W/464pIKcEVA4lgz8ua+bTlWEMobfx+4/Dh/aTNYY7khpV2E8GKou3?=
 =?us-ascii?Q?WiLkCWUlU/hk0LFUAYNUNIFVwyt/+4GfEia0w5rMA2glTkw3fLWM/q54W52/?=
 =?us-ascii?Q?2Smwgc8Mi7F6zkavZQGilhM3JOKTBzx8mvieZ2MipZAOHgFHuNCj3Wvcxx+t?=
 =?us-ascii?Q?rWfxrPDOLF8Z7iWkDC3OFV/wmmqa7LK6UWFJNc2mvxY9I2XCrq+Qzfjq6RR/?=
 =?us-ascii?Q?5Qu0sYEsvjr6XbLXG19zozJwLSq+t4Ci1YNiuSF1mHKqVI+m5eNSIYK8F2Cp?=
 =?us-ascii?Q?u+MNRGCLiqGy+HJ+nzntqJCkZf8ayJYu9mBv1dGEqECDv90S8IiUVfxfEmeG?=
 =?us-ascii?Q?WJLeXPt9qFLFt6cy4xSxHMHIRjB0daGmkYo2U+KL8MPEn7tQ5aCgkRKRCmmU?=
 =?us-ascii?Q?Nc9mJWifze39xBfaFw9vEHcIzzWBfvRGMV637VkzkTpoGzeyF0gpsJrrVChs?=
 =?us-ascii?Q?4ty5krxnR94nUWcvx+NzxxInWKHnVr+WJ+rEU1oqitVAA8GZHfmgrVUhhh9E?=
 =?us-ascii?Q?5t5NTQVK+2nB5us3zp46SBtLrRjeG9g/PM4Lhc6lBhBEp7X3cB6tCTgDIQV+?=
 =?us-ascii?Q?10YXqPGa4CrjqlIN+12vzwRlGV5jnBiL6f+775HU9egsHdr04UdaTkV0Dz45?=
 =?us-ascii?Q?14TTHB8Kdb7t55Rq54tOv9akYmd4RfsedK9/cmp+GO9iHA8N5yzjzXbCIUl5?=
 =?us-ascii?Q?O2JQu9Cp96bnA/H5E69lahn55V4fPMN2CD2BwS9NFc2gviXAaii46HKSQ1f/?=
 =?us-ascii?Q?f7T6Ol8AQul6zVX/VXEZbA/WuDmLE+I0pk/9IdVgRYFkHPPYZUtp?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd86c6ff-6fbe-43e3-719c-08da31241131
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:40.5570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiDZHoHF+CQsxnSU073MauWii8uWFuDBV/BP5mGUF9oc1SRfj2iP8r2ShoD3orI5MLmUXOBxfnUI/K5ZeHL67jRK1tdcCewFd8mVWL3RSC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that can contain SGPIO logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 8953175c7e3e..88ab961cc5b9 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -20,6 +20,7 @@
 #include <linux/regmap.h>
 #include <linux/reset.h>
 #include <linux/spinlock.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -899,6 +900,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	struct fwnode_handle *fwnode;
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
+	struct resource *res;
 	struct clk *clk;
 	u32 __iomem *regs;
 	u32 val;
@@ -933,11 +935,23 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
+	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(regs)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res) {
+			dev_err(dev, "Failed to get resource\n");
+			return -ENODEV;
+		}
+
+		priv->regs = ocelot_init_regmap_from_resource(dev, res);
+	} else {
+		priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	}
 
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
-- 
2.25.1

