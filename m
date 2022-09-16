Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA55BB2AC
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiIPTOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIPTOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:14:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE9CB95BE;
        Fri, 16 Sep 2022 12:14:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyMiUYS8c5NRCml19fM1BlWFkmiLzXtTpjDfjwlM0F8nqwdcl6qvASIyt94cV1LWxiLh4C0YZ6tvR4O6Mw2GaM2RxFPtDLhLtc2ZvKVYNA9Xb0wdU9HoWM/g5ZeohkRKDg4Rb8dhmtQXI+DLLoSN6CT5ffM6MIo5hGC9S3JRPpHoy7rK8QylyGRqhlrmekWKSSlL+faiF2pd3hCEMY/7ddSFQr1FFcqoAhI5KRuMUcKS6aTOY5JCChDrWzDYPBlbOUpUvP9KBUNREn1edcvtvZEjTPvART41gLIn5yHjrpejIiHPzFSawxBhL8oLmU9uGtjyrP9H0JZxTlcqor05Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJIKaxTzzSw8cnqP4ZShA8X2sgUoJbY5qtHCbUbPKu0=;
 b=fkUSZwYgt3F0jzJmwP976hm2Qv9sGCl6ria427JWlfr/YJDto598A2nFw+BCuOX57OSFqgKsHv+2B4P3YJFEed/vxZoLvGM2dK23VZeCo7DKlfNC+RrFqrmSQl/NEro4ugk2XCrooh7QnJoMXlkmHj5zI0/QqXBv42ghRG98rf8RXFJTtFSEefRgC4d8+JJwTKMwyMZpMiLim5MSGl+DCZufgYxMvuyHjj26jseZEto1Y9aGFADZVZzzpZQ2XJRHN5viokyRA/NG4+wNA8Xgmu+rRxEOSEM438YbcGPMNiRo454iC8ZqEQV4csUxr+7VRC3iSky0NKnlXe8SFunMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJIKaxTzzSw8cnqP4ZShA8X2sgUoJbY5qtHCbUbPKu0=;
 b=qed+chpos+TrMJkBn4g8SrKOaeCz63AmB8AGWvU89jYfJmK3l95NG2HHo8VQ99lOQi/Zq/AFV/dbyriBIr9sElci0hF3jSow2fj9IvxfTGliwc1qjx24SE4SHd+6VQ7yxwqLQ1cSA1hLHjG+vdH1PHS43PScZIHDG8zv31pGdfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4492.namprd10.prod.outlook.com
 (2603:10b6:806:11f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Fri, 16 Sep
 2022 19:14:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 19:14:01 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 1/2] net: mscc: ocelot: utilize readx_poll_timeout() for chip reset
Date:   Fri, 16 Sep 2022 12:13:48 -0700
Message-Id: <20220916191349.1659269-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220916191349.1659269-1-colin.foster@in-advantage.com>
References: <20220916191349.1659269-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: df35bd9c-b11f-4e2e-a15e-08da98179cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+oGlCp/9vv11v2RepUb7fL/xvc9AAJmndu0RaT+joZ3upmVRV4lT73EkAyDeH0UWcviSoESCC4dJjdmBxhGI8NVBNTc/FT1O4o/8QVXYbjd9qd1pOJw0CsTiZyMftF5lm4ccHO5B9tF5ozsvtMEM03sxn5g+9N0wkgysPY6H4eh3ZF6MKoxXZAZXW6SvDB2d/RLwueu8r920eNAjgRP0ZjXKF1GXuAYSSK/L/44/jvwmR47PHj2zNETf/xBjXSTN99NpDUKexvpQ3vhJHN6hwnoWy4O/iiuDVNoPoj9CjtEOr+Kozc+FCPSmh7sUDCEVVTADUHa6dLojyiGUHcTEB5muPIBHn7VVgWOY0dYJCfuvaHXckkl18B4DGbXpxDD6hr7bnSJd6TvvUoG2du5toMZSKz9yxJER+t32Ezy1KOfMN1cHEGYnSyxGGhC10NkzVDadVqigDx0wO7J+Fhw+ZznZJV+w2Io9J8LZuN2MoshZtLmyWIsYXSxGflfctjE7IVQHqoFPpNtXFwFzKd6bCO2IoxAq7Egqv3ODvID/6rShMr4/qsPcL3QYBckzJC+8Gwqbm3Dktq9HGhQKPvQyGi+7cgVcIrBVuwTdHEmZpxvZuJgU3OTCObxDyOHLYXDll2jBeeCuK4Uh1FBKEL8rrwlWVLhJ4WgFYA7cgINTyjwgq3xSmGXZQZeSvE29ltS5tu2V8iTO5iP9psc8hmJXQf4/HUJodf0dC2n4sax74AY62AO4NyccsUZnvzTgTGMP6ESIs8rDArsObBbnIZSyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(396003)(376002)(136003)(346002)(451199015)(38350700002)(38100700002)(86362001)(36756003)(83380400001)(44832011)(6512007)(26005)(2906002)(478600001)(41300700001)(186003)(6486002)(6506007)(2616005)(1076003)(6666004)(52116002)(4326008)(66556008)(316002)(54906003)(66946007)(5660300002)(8676002)(7416002)(8936002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YjCzXdVLlkvA1jGqvK3JvpgBYwwudSLCOUTHsQQ4VL9DXbRmHVtCFsyXSG6s?=
 =?us-ascii?Q?zD+AeOe7TiuzvVQ/xU72rPWW9Im3LTxzHZEOZxznmu8D7ei0Ff9pJsdcCnzy?=
 =?us-ascii?Q?8sCFfrsk3hIYgPbhPlcTkf3w4eQCB7fGJ9Z4CW9VWZSWdHu6SPlj7xpJaqI5?=
 =?us-ascii?Q?nrv51idRtfEB8cvGncOXn0IbuyF0UbdFeTKyK6s39jhEXiqpfspo/AhV9kA7?=
 =?us-ascii?Q?oViUD/rzZuIuDvNwA5+VMtJhIAN1OX3zrLdpPY0q47ZMu64g6yQk/Ur3i4j+?=
 =?us-ascii?Q?sKDFrVviNHW9slY+DTP/+5L54vfayLj0ARRkmD2Js0Bci0PK3hDUn0yHPBfx?=
 =?us-ascii?Q?QbYobXxtG2JaufKlmr0OzVv/H4rhVR5js/n3UwAWc502bT+ADBFYjh/Kg5Fo?=
 =?us-ascii?Q?THirOqAZgDeRV+HoGmjbYe1TautPNFNESO7Uxej+PQ9aHUh3XDhrB/3kPlH4?=
 =?us-ascii?Q?XK++R5eRnmugd+a0Eqcd/ViWk5tnTvBSrzqns49rErUzARTX8nsBZaTT3vqm?=
 =?us-ascii?Q?whKBDviLofb3BEELwu1kjLKZABJXLiq8LIvyWqs7mKlPsdXSctgDk6PQdpUE?=
 =?us-ascii?Q?cj/lvtPK2zR+nZ/+mU+H7ATAf4s+Pgw67QiGTtDnxw1mt+DX2uf9HwCECc83?=
 =?us-ascii?Q?p+wtKaGHR5SWV8tui7Ip47CXnfu6dFQmBFx54vDo+NwarVTR2RNCoVbct82r?=
 =?us-ascii?Q?haeBgO3IZ7AE29BwHJ1RdWDWKGFZ0yNejallLgOSlunRsBl8Y+CXSG3yjfhU?=
 =?us-ascii?Q?8hzht8x9GJPOYzq+nOLI5prr0216ZUbcjI+bT9J6pmEqyhESdhpbFfcyyKTj?=
 =?us-ascii?Q?LovF1GJ6yLCLj0V2FHKKeES5naaloRu+A6MH8ZpXs6g9nL9vhNkeXo+bVmMH?=
 =?us-ascii?Q?liNo31gGD6Tz6VbfbY431IzWJDZbzXKyS0dP1M5pYjy6GVnCkK2R7wDs2d8X?=
 =?us-ascii?Q?8UcnqzBljjukTbg3aE8ZzUAqW6sTWHnnFwj8YA2GtYOCqrMQG3pLXucUohwr?=
 =?us-ascii?Q?kc35G8ZF/axRlK165KDAjS3JZmv8d1ehtSwkuglQO5ExXN/531QFc5q8PCNj?=
 =?us-ascii?Q?e9BP2fk/j521LN2QKq0R5LTRUNEzOhQUoxvaLh0hnUG1bq5ODvy8sBtoBOhh?=
 =?us-ascii?Q?1ElWkkT67sFykgBRf1eAghQ+6ptDkupcRxjihaZhphfkSilHQId706lQVlX2?=
 =?us-ascii?Q?7R0K/F/FKqxjI+boB09eE51cHrFFOrURe3m5tKzq2aBmNgi3KoVIij2gpKtd?=
 =?us-ascii?Q?arcCDtWzu2HdopRWtCawZCu+N1O9QEZybEq0yDcCGZaPAhPg8U8umvVrZWsf?=
 =?us-ascii?Q?9EjH4BlJIxf8ACHXmuiyw5T4O5eRDjJvg7PnSyuIBEJT7d39HQPO3pdZxtWG?=
 =?us-ascii?Q?JqzRm6hrXl0ZIs5+WMDicQEK5iGcX4DPFPvN9NCU2qoIf16dkqZ12Zx9gzVg?=
 =?us-ascii?Q?fiuczMp2+eRhIDPHg5rqz2rm3prkS8fdBb5tCbX3yqUZ9Y1tBNKBTMTlXBrf?=
 =?us-ascii?Q?uUytdxi4mco037sEuaGYqnHFTBga4QAKWVDmnKTvodNWlf2+IYlnOYZHDehx?=
 =?us-ascii?Q?50jwzmpYKqg0mOJOiT/7Kj4Cy8sRBDG1zam9w0p38Nm/u2L7X4hqYKn7vsPa?=
 =?us-ascii?Q?VCFTxTmQUZuwgInR8rpDm2M=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df35bd9c-b11f-4e2e-a15e-08da98179cfc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 19:14:01.3693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc4qf+GjUt2vq8eXGm4ALbR3ESGs+Pmv4DaJMP1PZLd7jIXwk7gBEyf2DyPnaNvUDXiU4Aw2+yBvmqzLS8HMrzu7uzMzXkHFcPhWWaLAE2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the reset code by utilizing readx_poll_timeout instead of a custom
loop.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 32 ++++++++++++++++------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ae42bbba5747..79b7af36b4f4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -6,6 +6,7 @@
  */
 #include <linux/dsa/ocelot.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/netdevice.h>
@@ -25,6 +26,9 @@
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
+#define MEM_INIT_SLEEP_US				1000
+#define MEM_INIT_TIMEOUT_US				100000
+
 static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = vsc7514_ana_regmap,
 	[QS] = vsc7514_qs_regmap,
@@ -191,22 +195,32 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
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
 static int ocelot_reset(struct ocelot *ocelot)
 {
-	int retries = 100;
+	int err;
 	u32 val;
 
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
 
-	do {
-		msleep(1);
-		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
-				  &val);
-	} while (val && --retries);
-
-	if (!retries)
-		return -ETIMEDOUT;
+	/* MEM_INIT is a self-clearing bit. Wait for it to be cleared (should be
+	 * 100us) before enabling the switch core.
+	 */
+	err = readx_poll_timeout(ocelot_mem_init_status, ocelot, val, !val,
+				 MEM_INIT_SLEEP_US, MEM_INIT_TIMEOUT_US);
+	if (IS_ERR_VALUE(err))
+		return err;
 
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
 	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
-- 
2.25.1

