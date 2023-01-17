Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7901B66D91D
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjAQJB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbjAQJBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:25 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432DA2ED59;
        Tue, 17 Jan 2023 01:00:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtSViqJjzdKyUAzcOnbgsQIWHuFuHojy1Q6sCbJ2jjflFuUg+0p1OJ/uQXZItHcFTHv0MJ+EeTP2A0ERvLLHffmPNFDcwIdgXCUrbtXOekboFu+mbcwn5tQPnUl2/TPLe+dRdyHn0dBkyuPI8Al0n+gQ6FQKdk8FurQOn1XVEKUmKYXezzLxIPUOjKA14maJqDSPz7ttUgqTZSvGVGJ1JUIYzwC8ojn1neqbuunIJcpfp3eLYsEni/VUkFC3ewBDZGp3sFO5QbXJ2VrwKc+e06Aehr/T2Ywv8G7kDsgKlNwokwAN/IN8xxikXBRYv5iWiQvAWKGjLlx99hLZYeJ8oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uJmd2lCj+WdnhRTPB8Dv9xjQZn/5spjmP2627kp/1zw=;
 b=D0LPSkXLJkq3wnQB6EjnX/FIgVzs4h90TxgKgzfSkXsgG4QyGZ7WLWF6t/4kgKvAllaeTjPJJOwAkOZ/aFAvNRZvRMq7KJnF+SRpl7ydEBdo5FO7os8YeloY5Dv0I+5JFlXxl5pcTErKJMs8qtEeaji/KfOt+hsAXkHeKw++DycWXfD/fMagV7UBm6LUbZ8EFpJYec+OwwAZFbPIP5AmK5zlIutG8x7SUdirNQwCrjpSG+QYLV6EUean+gbF2NOIYl6d/l4RJHNJ2eHn6IWgIJej+qNcc3fm+y3htT4tycwB2EzIm8y2mMWo1oOGfXiSu8VKHCGx9KgnLP7h8M9udA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJmd2lCj+WdnhRTPB8Dv9xjQZn/5spjmP2627kp/1zw=;
 b=k4BwBqDURB6vsMwLKqhhG0PKmjreX64ETaVNHRpIzJ3I2hfGFDX5+tapaHORcAo0/W4nwqEyJSruZtgbEqToB49B9ndphRD10TMEXJLPUsXl59kLV9Y6W28TW64pa43Ctw54F0eCXAQRfhNNTTDrr/gowxbv8qV6kFF7M1R0/LQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9304.eurprd04.prod.outlook.com (2603:10a6:102:2b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 09:00:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 net-next 01/12] net: ethtool: netlink: introduce ethnl_update_bool()
Date:   Tue, 17 Jan 2023 10:59:36 +0200
Message-Id: <20230117085947.2176464-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9304:EE_
X-MS-Office365-Filtering-Correlation-Id: 60030366-33b7-4fe1-2650-08daf869369f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33tA+yRvxOC1Cx3O3moT+ercUt9jgR8jgw3IBaxDAIYj2PDrMXoy5X5qbmDp+44DnLuQtwgCRYmATNTOSyARQtQFNIL4Qvzp2eYW4t0W3SQw275BRG1VdmNPs5N7Q3grJ3Y2DEScOOTvJjur6JF2CdSqJOsYl4SJVO6SCTT7lYhmbmayyScre/lhKgQ5ui6Ea4bYMamx4ZIS9ajTAUcWn6u4LE5r/Ecao6Esw1tKayR4UjBvpeMJ9CKMVF9f6yELV7hvz5B2so5kDEwPHAIRMiGXo1yiZcKU4QGR7Bo/Lz+nZmR/25ay8Gn4Y4HM7W03vahYA5BxvRDc+8SUKfT8oFmznPa1/rES0Bt2buDTYd9cfcp20aFxqh7iU+D3kGwXDpQJYDZoXyz5xqtvtLqyfv0wnVYOH0do/p1eY2E1HeqtyKLwpRlLo3EHxD/R7UnTpwwMAwQZkPOIZQVr/4MLCKpZdYNERXfsxTE7a67yrvjTgWP048fv0hRP3LR/qOOVJONOhwvDGwNh5K+8t5Dup6TuUPb3kIf4WGpNDCnOMTFP1+UZ1q9VciCAWaRK63IEtpXiby2s627G2lXY7A0TvYXKnMfApvgFP/yyGwrlriQw+fP72YjSuG5ucZY8YfHMInjQEOiaYwl+RvhMmjGZjuqCR+u7+BcYmmxo6wzQfa7iH7aCihgBrt8lAmB5NSendgRziN7aOWUXPgo22QBFRPls67XlqFSrKNajgP4WdOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(6486002)(6512007)(478600001)(186003)(26005)(6666004)(52116002)(6506007)(66556008)(2616005)(66946007)(66476007)(316002)(54906003)(8676002)(6916009)(4326008)(36756003)(83380400001)(41300700001)(8936002)(44832011)(1076003)(2906002)(7416002)(38350700002)(38100700002)(5660300002)(86362001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+N+Aj83vqoY8vpEWp/DVTOV7iMEKNtg5WTb/ae10d2aF9FH2qlc8CPMvAddY?=
 =?us-ascii?Q?WoGKsiM2boM2EAuCHul8vidNScOeA0Bkdn9agINR8sLAUURcYxdhfTrXR3c+?=
 =?us-ascii?Q?Rp9dv00jYwNhM4pMBed0M5XKaG2dvyckxfqDM7Cy7WqpIj624p3niZqECHy2?=
 =?us-ascii?Q?trbh2AcJ3+hf0QqP9Zc9T4tXnNFWh+V3U6pMBsGOd/PUf8EvXRPzKin3CHyo?=
 =?us-ascii?Q?VSzHgkmWsImzSYqzQhIamYH62iCGx68S29tBtZhShrmY9m0fAo/kLaaxtJNc?=
 =?us-ascii?Q?Zl0HrcXDhtEMH0xMUaoOMuWWQ79AGdYZGD4+SwFUumeCpCoiOpgfn1FQURJ0?=
 =?us-ascii?Q?bDNITOH9GlPqBJXAH9TbL70XoaDUcoSAegK1JKmIATuZOhpILft6fCMZvOqu?=
 =?us-ascii?Q?lkxEJJ4BT5c5wmW8PD7OBVjDLoxyugr01X3NaEjnt4+TBPFsE8+0QG6I88AN?=
 =?us-ascii?Q?PJR4EyuO0HctmkyMkq+id2cAG6wA0j5TTOvuejmVNIrPZEYS23TPVlK2xzGs?=
 =?us-ascii?Q?QKs5+f55R9uwA/uGqDdJcNOg2eC1mWBKNQySoIKskv5Lr9KfvFn4Qb0qECul?=
 =?us-ascii?Q?pSpLBm77wpZK8ZKPXAh6dnVTb9UqGVuO7VWnlsCrphbxx65SvunzBd9j7I2d?=
 =?us-ascii?Q?IYZgJzlmZyRDSYzVcE5hBeIS1a6TwZziLn2EaZd0Ka0aeQRje3nTzK4Kqnu6?=
 =?us-ascii?Q?MlQwS3j+5vPUk9hObyWCwT8sWLhflnmPmApFN7YtJTI01V3aaVKUknoDMo3D?=
 =?us-ascii?Q?W3rfZ10CfyIeSpm3cWid5+0+oOW33zyDA1tyJxkBrDo/LnlBFjmoOC5R5fs+?=
 =?us-ascii?Q?ToJ38/dq9oSTphurG3//+9Y+AhPrYrAP/ziqH4eakmceUl/NGbAbfwO+dBe0?=
 =?us-ascii?Q?EW1Cs7uViXtO6D1IXWf+g++zpexmpStukaFPCkYSnhtVSYpAEM5bwqyDXb07?=
 =?us-ascii?Q?/caNs/m015NbySstHgdvDXQPEAg0Xm4FZLKU2qrFgVjSLFi5swwEk0LTPBic?=
 =?us-ascii?Q?UrlqcMXwVzcOrw2LpYrzUtBSnU+ySJlu+Co6W6ApagbSR+giP+rQsCS6i0+y?=
 =?us-ascii?Q?0M9fM676dGrFIgKHr+WSZIhObENr66BWUAHxpHwAGfiZYKjIlqd+0pX3TmM7?=
 =?us-ascii?Q?HqR01v0o422HFOOQAlwdZft1HKhaktXIjA4tgvEtJhk8bVEgu3j/LfwnafdO?=
 =?us-ascii?Q?ATLM33VfsJXIirssEi+B14eEITheOOq6vRY9ZjY5Vvmf8rjPt96TvIhJNga9?=
 =?us-ascii?Q?ehe+0knzsmIOXseDQjyF2zeL/ATlo+7AGqVKXoZwBnapt1TdePrhGlO8tTUM?=
 =?us-ascii?Q?mUe7LFaSaMIhd/3ixC7xkqkkqJaAeS2W9NYgX7Ur3q1RM5HHH0s/l3MPmaJy?=
 =?us-ascii?Q?dCojwtiJmj1ZAv73zLu30MnZxfpTl7fQRRY6NyFYjJ1yLK9+hkxdpcKzLldM?=
 =?us-ascii?Q?4EcErBpPpEXLxUD7N9MOwjEHLCOlfH75IVRLrjksbazhtQccO09f6oHHkE5l?=
 =?us-ascii?Q?kjxfGOOvJJAxkYgbYtrVsv7D+EerRITiuzSHydb9AdIOlOEovv6H8KO5dMUE?=
 =?us-ascii?Q?rU08OaJTaSqD7mBwRsX9gHFtjOvZYFobIRlK6OgBhL5o1Y/aJN5ObzjiVvH5?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60030366-33b7-4fe1-2650-08daf869369f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:00.3781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMGMvovirdrUyOgbF7X4k9D4XYibNn2xBCAkrvSYnHctil9ZPKEsNFE6Yf0HCXo6popzdv6U9AV/zfBRPPFbEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the fact that the kernel-side data structures have been carried
over from the ioctl-based ethtool, we are now in the situation where we
have an ethnl_update_bool32() function, but the plain function that
operates on a boolean value kept in an actual u8 netlink attribute
doesn't exist.

With new ethtool features that are exposed solely over netlink, the
kernel data structures will use the "bool" type, so we will need this
kind of helper. Introduce it now; it's needed for things like
verify-disabled for the MAC merge configuration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: rewrite commit message

 net/ethtool/netlink.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f271266f6e28..f675f62fe181 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -111,6 +111,32 @@ static inline void ethnl_update_u8(u8 *dst, const struct nlattr *attr,
 	*mod = true;
 }
 
+/**
+ * ethnl_update_bool() - update bool from NLA_U8 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ * @mod:  pointer to bool for modification tracking
+ *
+ * Use the u8 value from NLA_U8 netlink attribute @attr to set bool variable
+ * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @attr is
+ * null. Bool pointed to by @mod is set to true if this function changed the
+ * logical value of *dst, otherwise it is left as is.
+ */
+static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
+				     bool *mod)
+{
+	u8 val;
+
+	if (!attr)
+		return;
+	val = !!nla_get_u8(attr);
+	if (*dst == val)
+		return;
+
+	*dst = val;
+	*mod = true;
+}
+
 /**
  * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
  * @dst:  value to update
-- 
2.34.1

