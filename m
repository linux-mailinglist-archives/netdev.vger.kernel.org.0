Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8053B5E59E4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiIVECV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiIVEBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:01:47 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A74ABF34;
        Wed, 21 Sep 2022 21:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPEUeJ9id+zndVNEaXCh5x7Va8JfDD0tH9NWtzzP/E7q02OaBu0Va6LwfxmoK1taiwyKCzC196Pt01s6ae3m8sopl1SvPDLl0ULq3iNH12+Plgqv+IfEMhy4WFCTCQFrTy9OFyqvFAMR8X74N4IFDQbzWMKFsi/hH+O5y7F62gk30GSkwfoBqOXs3avrXv3As4VGVO2HjE9g9EDL9YqL5wy7X7ZMCRLJcRL7cEqjyWpBNb0/iylbq0GugmzvITDTdW4kOL3G2JGKqqMPZdXuJmuXu9Jy8RX2qrJ5hZMgHO5ftLlpTal+xsoIRHqZDalKcV5mYiNeFTltsaJ/OMhJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZIdQp0VoRTiPr0r5rBFo3Bz4Idl+gY1W7OMLzeIMzI=;
 b=jEykubIrloIRTLixoPfk86zU0Msty70sDDfG38wMn0DZlcBiK79QDVLTwRX0suM0InfvlxUEIR2L5jVtW9m2E82zobYddm4sPCWzg4PWJbJpZzzkgZUxMMEpLhs2biO5BaX4a3U1YCKh7jC2tehT9/XmmGL6iC74uJYWVwyey/I/R9Oi1Fp6ElBY3s5SoB8b9eHJjz+fH6lBZ93f84SHDjydIQOQyEEqgjFv1Inqdagpu5X8kZfFlAiRSQIpH7X670eIefGGjXJ5j+ibQdAy39VynBKD70xt03lKgsB5fsou/I+tY6f62zVBmxyWJHThp7MKvfc73SBvZpQ21nz9Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZIdQp0VoRTiPr0r5rBFo3Bz4Idl+gY1W7OMLzeIMzI=;
 b=MeLvxELVkf0kOC6a/sdnnVS0jKHSF6dQWeC1HwyVQf1yR00qcpp7iQjMZaqjmx2N27FZV4olBZPPaGl3peSnpLWgoc2B8sQocJi7kGChyaItuOxqqLBIee6eYlW5rL3OUIWqXJOu5Oc2j0Ml57LvEYNVBE2ytzhfPSDtSouUgic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:25 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:25 +0000
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
Subject: [PATCH v2 net-next 05/14] net: mscc: ocelot: expose ocelot_reset routine
Date:   Wed, 21 Sep 2022 21:00:53 -0700
Message-Id: <20220922040102.1554459-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 72f1c559-4c46-4f59-c858-08da9c4f1e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XxhRcPXCiWMbrrLcEIQwRVNiUEUUYzSv4eVJzAVGRiU16fJRm78mdvFFDbmyJvzGx6VuyvHzJO0nTdXeDh/eMz/wzc10A7QrH0q76d6NlYG4QgQWarwdslZH4ahdPLGimvE8uQy4bvs3S3Nd/RN5b5u8QPKT+As2m4+SQeIfbiu94TQ81hZnQosYASwlCbF1FHbPBpNkdjGAHZd6+MZgQF05PIJ69lvQssyviF0S+hzQskV+QWo6djAoJrx3DlwZshLiiAKnANygwaIzrEpjNpmXVe8EmxxsvFjfpIMNlVD1LXxBRCg8FnfEnjhUJfcIQv35dOjx0lN/OzpJn9NeRH8w2ZmTB/uoO8b8Mk4U5bSSPbU6rhKDcwl3lttW1LjpGPc71Lh9aoylmHiZDI/RWjSMWiaVfxKQ8k8nRT1VqaRJl4lC3aciImlWQdhp28LSTPECl6c2fzsw0AlIpbqV7EfNZNPjeqt2Me2cBAeAjMQipM7RfG0koQIr6oDXKNbviTQVZkZ41iYOQSxPCrwfKE9zNQmZJy76DGdSyxn8AmmCsISDRyohCywX5vzuNFd/z27yqOo4WwjsIPZKUFRwfO1zP5gsi1x28qoyRpxdvpsr5RZHcWdLoWfzqrO1LhGrFJVfgoHJBwfzCk0T/iaHV98cwZGPdVsnKJKcsmW0AeejZh9/CWMi7wLuIcCMN0uLyYSVNL2r53+N/aEDf6BWnHwGb5wPUtTFH/Yg8Qy/jRN0kC7I/2GttAGWgnOiSCa9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZVjV25Zb0bMk/mnY0URxTCEuPJBQwoeddK0v4aSij+TgScZCYwp9O2044Rx6?=
 =?us-ascii?Q?2VsyVT5T3vicVasZKWG6iUFRTPZBjfISbfquIpd722nI/VaiBcRSvqOnpQ7+?=
 =?us-ascii?Q?jxw3ZbifXwzHkliJGM2znQLnqTN8IIsj3SRORFLBo6loPEZJWFSAbIpwPu8i?=
 =?us-ascii?Q?j3q3E6HaBuDRLUaLaBF0vvYte9NdAmygse+4c6qRL+w+Ro8YBA1Z7WIMc8Px?=
 =?us-ascii?Q?KqtV9yNLOQ1L7G35NvwAvPEwEZ5DEUO6sFZ7e70xZFtLIOXI7aSCnELzSIHz?=
 =?us-ascii?Q?u7Fs+mTezgkdVnyM4zpnug0LNtYnvHO2Lm6PqNJdkT3+PtHljLTvbv56Q0cV?=
 =?us-ascii?Q?QGypCBvZ5LjLAsUH+uZ6GxTCY7RlHC6h8FnTcKR2oX0Ls7+WUaXehFlV3MkO?=
 =?us-ascii?Q?vSg4i6i6NcorGbnrREeNJmbYIOZe5TbiWS87l+qHk/T8E1qLPDeuh6iqul38?=
 =?us-ascii?Q?rke+Oj/jNxDv/99yrRLj6izKDD9ZJLnUliM9IXkyB4KanEnqwP4hYLJKMXCi?=
 =?us-ascii?Q?gTws5mKVlrXMRCq+Ha2zWNSKQdvNtDd7VroNR7B9ZHBI5l7a/5uP4N12UK4g?=
 =?us-ascii?Q?FG/x4MeK0SvpHOp4JMS+qC06Obq0D02m00UJHQjB6xGwejywwAPGH8crOXXl?=
 =?us-ascii?Q?Iyp/FuOviXsaQnVP6Ywj16ppCSpglFdxv6eHWhADodM7SBr4/hoOPdK9geos?=
 =?us-ascii?Q?VRl8RaVmj6extW7Y2hMSoxkjMakl1u5e4WINN3KXhIHK+/660lUPEOQKFvFa?=
 =?us-ascii?Q?UQfJVBPmb4Bu2MIkCXIEBRkcnKAQND2QYKYxjBBT/0xKtAB/TCHknpiPQIOk?=
 =?us-ascii?Q?nqWrYUBVNJ2kNPnnoM1H0MqLaGeZk6kwv08wkkWTEMucf51K8n5Nj5/+dSHR?=
 =?us-ascii?Q?oN7d5qaGfGn3SjraPM8tlGHyNoiHnUI1Rqjr/+8VN8Dkr6rVuIgMO2oXls6t?=
 =?us-ascii?Q?WunyHKT3GYCKvBRNMVxzH94zngfraWXORvoKjhh7mg7GqEMC7OW8BjoK14d6?=
 =?us-ascii?Q?UFg3NBSiIxe0xoYfP8W8Xtt9oJQwApBx1meHnzmH0qfxT7V94aFXrkfPYQvR?=
 =?us-ascii?Q?ykhwmuDP2+Ntt5A5KCJGrgDcz68fg+Vvds1Hahx/7bygeUj8IzDX2xBorFQm?=
 =?us-ascii?Q?s5xsLOJPM5IgvZierDf/Zm8hMU28RH3kpD2QP97K05XYqo5OS8zHvOdCbA4e?=
 =?us-ascii?Q?VLaDMM9puaA8h/AGiXIOpL6Gp7GmIBE6opSDhtPU0ynJcjQq1oMk8Yssd30S?=
 =?us-ascii?Q?QBNZ4tAxOu0kSqVkGykUYQttyPpzVjwkhJN5nJrx6DqVEzkTf72bIQ4InWnv?=
 =?us-ascii?Q?OVnO9dB4iJBwyKGxA1YXavjq2oZVbj1bZKo2C+f6TBbv/jz91NI96r+fVJr8?=
 =?us-ascii?Q?MVqseL1Akvgrzq6tWkobqOdE7AhU/GoZ0OZim9Iqo4/ElW+8qW8GFcergiz5?=
 =?us-ascii?Q?sRufF/q96fxHleyFrtkaPoAgRWSpYNduEYk6NnCAqPkkRWq3FsJ6vP8B1p4e?=
 =?us-ascii?Q?F9U8smUCPXLEiqkaZ2yUx0ivHwtebe+emJ0dc+cm4jFocdoDyST86SG/k62C?=
 =?us-ascii?Q?JgWEUwfVuDu/psNyhCrsynsFitjusAV+l4WgEGPRcsIseBWR/z9QhILgUiw3?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f1c559-4c46-4f59-c858-08da9c4f1e3e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:25.1845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+uLbH6Np1uxZR2omdC8qxbxUFrhDXGnfXJ3sXyvsSmsy6WC/+AIR5uKzw8sBG4hR1P77EQSsN+6ascgqCKp0EqN8Tz2mL0sqdq8Sp98d2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resetting the switch core is the same whether it is done internally or
externally. Move this routine to the ocelot library so it can be used by
other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 drivers/net/ethernet/mscc/ocelot.c         | 48 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 44 +-------------------
 include/soc/mscc/ocelot.h                  |  1 +
 3 files changed, 48 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7a613b52787d..d43106e386e6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -6,12 +6,16 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
+#include <linux/iopoll.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
-#define TABLE_UPDATE_SLEEP_US 10
-#define TABLE_UPDATE_TIMEOUT_US 100000
+#define TABLE_UPDATE_SLEEP_US	10
+#define TABLE_UPDATE_TIMEOUT_US	100000
+#define MEM_INIT_SLEEP_US	1000
+#define MEM_INIT_TIMEOUT_US	100000
+
 #define OCELOT_RSV_VLAN_RANGE_START 4000
 
 struct ocelot_mact_entry {
@@ -2708,6 +2712,46 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 	ocelot->num_frame_refs = QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(eq_ctrl);
 }
 
+static int ocelot_mem_init_status(struct ocelot *ocelot)
+{
+	unsigned int val;
+	int err;
+
+	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				&val);
+
+	return err ?: val;
+}
+
+int ocelot_reset(struct ocelot *ocelot)
+{
+	int err;
+	u32 val;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
+	 * 100us) before enabling the switch core.
+	 */
+	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
+				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+}
+EXPORT_SYMBOL(ocelot_reset);
+
 int ocelot_init(struct ocelot *ocelot)
 {
 	int i, ret;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 19e5486d1dbd..822b11d33288 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -6,7 +6,6 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/interrupt.h>
-#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/netdevice.h>
@@ -17,6 +16,7 @@
 #include <linux/skbuff.h>
 #include <net/switchdev.h>
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include <soc/mscc/vsc7514_regs.h>
@@ -26,9 +26,6 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
-#define MEM_INIT_SLEEP_US				1000
-#define MEM_INIT_TIMEOUT_US				100000
-
 static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
 	[QS] = vsc7514_qs_regmap,
@@ -133,45 +130,6 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
-static int ocelot_mem_init_status(struct ocelot *ocelot)
-{
-	unsigned int val;
-	int err;
-
-	err = regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
-				&val);
-
-	return err ?: val;
-}
-
-static int ocelot_reset(struct ocelot *ocelot)
-{
-	int err;
-	u32 val;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
-	if (err)
-		return err;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	if (err)
-		return err;
-
-	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
-	 * 100us) before enabling the switch core.
-	 */
-	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
-				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
-	if (err)
-		return err;
-
-	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	if (err)
-		return err;
-
-	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 55bbd5319128..9c1c9b8c43f5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1134,6 +1134,7 @@ void ocelot_ptp_rx_timestamp(struct ocelot *ocelot, struct sk_buff *skb,
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
 struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
+int ocelot_reset(struct ocelot *ocelot);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
-- 
2.25.1

