Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1E4F9DEB
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbiDHUHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiDHUHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CC8129868
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:04:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIsRD2uH0nlSmkeV2jFAevuMkzO1IRkodK2MSIQDzjEO3+bdt85JaOYC7jCtRB/V1X+n+WT9wYRvRFaDWsib1c5ij65Emkall/s1qhYL2wRrxCmowpmFFq3rP4geLAGFDC91GvAz9qA1wePw46KwchhKZVJ762I3fyWRaEmrzTT/qTCIDYdt0i82+rd1afJFTZrik6TjOT9S/RU+Jsva0xUMH108Zfr8HTGuEmT6P4QfyEjokS/ElmD6864dWwacu6wcJq9MnNjUea5c/08Q28ZJmPw0fdWgxP39iEXsMr0x/D0kC6YilcsZHiWwVcr/MWVx7Oq4cBuLTp7FtzSjxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5EtAGRAbTNZKhRAuqjoPNIclaroI/Fptzgk0LiV/J0=;
 b=MT/6R4JLabRu6tivMga60nC4tSebfDO94LatU3eXPKXTgvXJCsQ3xNOSo5EyT2soJ4dhR+73mjBm7ddF2t6i82vUkLQHfFzNX9f/rS6ZMu9LJh2jQlaoYVtpIBjR8QgNm1Tdt01GNvf9AwAF3zqbPsxaKzUoKVEBANfJs9ZVa4FnGbiBEvHxtEqPEoRUZD86AiRYsKK8oUC9L98IlqvH+kvB71KSUKekdRA7DLH2WT5IIZbF/VfhAv8Nqy/XYxa0WlLLWokizSQDg5Cgi1nMGABZHHTVXSCbY4Bj1IWekGIwgSxEKoU1DWHQ08mFZAQZdVcVmZ3p8jzsnn6bnDD0kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5EtAGRAbTNZKhRAuqjoPNIclaroI/Fptzgk0LiV/J0=;
 b=FLNtBR9LMduXuW5hMzEm+UMqcqpYyqHNuSi5BxFCAHvqrQ45QcSn2YhUyM2ELpzu4RlHoIrcRDDsplhS4QYDltiN5GFv1yKOF1DdsxKcd06wUiiUAKVZzjJVdF0zFS8k5B6RRJopwtxdMP1TfukgEVgbJXIXlpjFUEqcKHzqIeM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:04:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:04:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 1/6] net: refactor all NETDEV_CHANGE notifier calls to a single function
Date:   Fri,  8 Apr 2022 23:03:32 +0300
Message-Id: <20220408200337.718067-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 042de13a-76cf-4712-66c3-08da199b0d5c
X-MS-TrafficTypeDiagnostic: AM0PR04MB4275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4275FCC32D8A2028917C049CE0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rE1wFdx5MzC3PIkZ39B5mZrOxX7s+kUXQTfhkO+vHwwS+7XnG2n2V47mpWPPb9ylOEjQgwrg9SFJBtL12ptEs/XJlv7yqXcgmlM7qwUfmGY9o2tPuWYRIamQqdxYtCL4EiMCQZFfrXFaLQecZ28fDnpkRqfdGrFz/c8QcBp8718e1piXQLfn/1yWc04cJc6JR4vnUbVLUPOAqQnx/4t5jy639kGBoaaZdyCj/CcDfV2omux3QkzwYFQWi6PVDZAGClgo0zsApLdTYMgf7eCsmBAesfgepHcVLrhNCCoWpKtDiI2AATbZSbyU0NiyvL+O8Oh0veU/69Yz6Nl/UtLJhfrgKCajQ615zvhlAY0WDLKFlPz20IvEkXGHNW3rQX80kWm/HOG2V7bkmEBBe7gDOxcyZ51lD1eYvgULQSPdhKnN0cLlM7JjAW6UZPbPe3pwYXaMuWkQsci5Brvz0PZtAgSk+h+ufvPi+Vp8dP0auUT80X5isF4jZY6yP6U5+uKuT4KA+q4oZcuoHpyhs+iAB8yigSArbxm1+hFrkiQje7+ER1Ln5kg4BrxpWoSW94ygEW+wz74gvKEpbNFPZHk2VOZfqf6mMBtVLw0lSjJytr7mfSh9yBnbC3x3T9ArDmmMp29CBAqlx7SylR8m9A1Dz847J7evlMvPqOtUGzUweVaB5XqhcSolyqlNa3IsBAUtObufMasnaYCYUK/CMWYHrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(44832011)(54906003)(66476007)(66556008)(7416002)(6916009)(5660300002)(86362001)(6486002)(508600001)(4326008)(52116002)(38100700002)(6512007)(66946007)(6666004)(6506007)(26005)(38350700002)(186003)(36756003)(2906002)(1076003)(316002)(2616005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QtJnVlMRQ+2dE1ilNoyJQumUyVxajYKksBroJq/pB0yfl/NuxXu4PGJ9jVn2?=
 =?us-ascii?Q?aNOXVTFotMVDs2X5td39iZ0oK55OvwaP29+7naCiCh1pYSM18Jalshyxc+Nq?=
 =?us-ascii?Q?mttw0KYQkFVIlUH5009nXJqBFbqadnR9WNk9PqESpWSgzcUZ3qnq6qMBNCZG?=
 =?us-ascii?Q?4J5iB5qSSfXtkskem4C/rFXoSG76l4zzBXV/kJDMKrucXoI2HTGQNgMPwh6u?=
 =?us-ascii?Q?Bs37UTiymFw8Mslu4OsQPWeZZA/6snMeM7IyNi/BJZFcqhuV50v7wz5kUvry?=
 =?us-ascii?Q?OC4wu2P6gh+KyJWOT1rKd3M3kVktKBdmxljyu9NO3fOocW94RQn02UeCq/VC?=
 =?us-ascii?Q?MJahufFD/5rSjqHqKbkk7n/nKM1HOlN/CcQEsfu40+LUTJZ2Xk18Eb8yKpGw?=
 =?us-ascii?Q?cuN+D/dYMraJGktlxDpw1KAHWU1AC79e2xmS4hx+oBnNL17USbnFz3A4hYEc?=
 =?us-ascii?Q?ozATxSHevqDSI+U49+VaEgvhzhXnygluWnk4WyTkUMRxYzuhwj30erBi5nmC?=
 =?us-ascii?Q?WDvAH25pEVJ4QAmcN0GazRCMn65NLOC3GQbxdWqPYWOmUeMzT7lgzKAU5v2t?=
 =?us-ascii?Q?GnzsChIPyYE4ClSdC+ORNTTrilHFxn/0+gDkpiZekxU4wzeiLEE7YXWk3SQw?=
 =?us-ascii?Q?O4urszosRLfnsLH42de9n/jVFlj9LKCCRNf+8qpH0KtUF+FlW5ULepKwcVct?=
 =?us-ascii?Q?BDoLVUsgXRmPKSJvFljipn3qKaGPHC7EgfWmywZtTsHyvfoQEI8HFR0AKg6a?=
 =?us-ascii?Q?ViK0+5kTYpTFHNmuLZZIYqhcxg7f5kCjEnz2j8DCuseIIWfLaHL/XPWRU1Aj?=
 =?us-ascii?Q?ag2d7V3bNdvKcMAeUax+GHwqQqL7QaYbNwMo/cTKiECEj5uW0hHtlUbSUxZ8?=
 =?us-ascii?Q?1mMzuJzuNrTrqyV1QqDhJ4bwm1qLSv1Stq+XqHWYI6nahqAtnxaDCQcJNzqO?=
 =?us-ascii?Q?XnSrpho7pf/XOf1MYDJ93tloYUmJqGENmQ/xNly8ZCGRA1MEQyq+e8CnXeMa?=
 =?us-ascii?Q?CSVMUNpNxaUKJ4OR+4qUWcLPTG1aesMNcD4xpLbAROC0IjQaP3uuVNCv7zxo?=
 =?us-ascii?Q?x3EDZMDinbSl6KViOUijd01a68f6z21U21T8UjJJT2uOULZZhMwi3q4VBAXY?=
 =?us-ascii?Q?SPm8aWDPs8rQ0Q5Mf5QQWQ8acgMov0do1vr5WHCPNrXmYJiO3OMJm8nhkenE?=
 =?us-ascii?Q?bJESll8NabuscAvV/gT9Sy8PliOibilHOZtQ5F+kWyvjvUPePFT7eoUluQhr?=
 =?us-ascii?Q?Yu/jNR/sPW4wi9rEEWes0y4gUpiJPDJcMFkproVHmCDaLMmEZnb+y7+Njege?=
 =?us-ascii?Q?VBqHPMSlJVDOnDb+lwnuKto50tMXRJg9m39HriLwowQ2ds/q1mLd+/uCUNo8?=
 =?us-ascii?Q?InwZqxsHmquxBQ59SyHwgCheeTRtpxv4HmWFkp8b5EjmG3DdVb2qCXaVgj0d?=
 =?us-ascii?Q?/maM11cERaT5UWTozexjDlvSrCu22m14ZBCvcbqfy2T4biz0zl+lHR6TYsoN?=
 =?us-ascii?Q?aGx6DS4KT4Au5o5nebYbxduWDYmgH5kNQpibcrPRyoTm8GGKyxS6SJS2QGxE?=
 =?us-ascii?Q?uVxJjlT53aKiJQ6vKgU0F6nCcGkq4ZzLOKnudUhYKHITe/vsrS1hQZtkP6/b?=
 =?us-ascii?Q?sleXYWioaiKYA8ddyjTJRAjaW5ruyvlZ/NPIR77mA90Bp5XvEwKRJQR9se8b?=
 =?us-ascii?Q?3wStTQS5AvvE0zUUDlQ3BumP+xmuGu8J9DimE3zn2/+fPoiQaee+nzyxtuJ3?=
 =?us-ascii?Q?z4ajINnSao/y663oaWesCsJRdwUb0D8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 042de13a-76cf-4712-66c3-08da199b0d5c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:04:56.4724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFRY+uceYa3Gcw0vLh0pdnqewFDDLZci5OabSSDIjJTxybLTurYP2D0WD42v+DOcZBqHMCU0s/eT0sWMhVqGqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a __netdev_state_change() helper function which emits a
NETDEV_CHANGE notifier with the given changed flags as argument.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e027410e861b..433f006a796b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1314,6 +1314,19 @@ void netdev_features_change(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_features_change);
 
+static void __netdev_state_change(struct net_device *dev,
+				  unsigned int flags_changed)
+{
+	struct netdev_notifier_change_info change_info = {
+		.info = {
+			.dev = dev,
+		},
+		.flags_changed = flags_changed,
+	};
+
+	call_netdevice_notifiers_info(NETDEV_CHANGE, &change_info.info);
+}
+
 /**
  *	netdev_state_change - device changes state
  *	@dev: device to cause notification
@@ -1325,12 +1338,7 @@ EXPORT_SYMBOL(netdev_features_change);
 void netdev_state_change(struct net_device *dev)
 {
 	if (dev->flags & IFF_UP) {
-		struct netdev_notifier_change_info change_info = {
-			.info.dev = dev,
-		};
-
-		call_netdevice_notifiers_info(NETDEV_CHANGE,
-					      &change_info.info);
+		__netdev_state_change(dev, 0);
 		rtmsg_ifinfo(RTM_NEWLINK, dev, 0, GFP_KERNEL);
 	}
 }
@@ -8479,16 +8487,8 @@ void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
 	}
 
 	if (dev->flags & IFF_UP &&
-	    (changes & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI | IFF_VOLATILE))) {
-		struct netdev_notifier_change_info change_info = {
-			.info = {
-				.dev = dev,
-			},
-			.flags_changed = changes,
-		};
-
-		call_netdevice_notifiers_info(NETDEV_CHANGE, &change_info.info);
-	}
+	    (changes & ~(IFF_UP | IFF_PROMISC | IFF_ALLMULTI | IFF_VOLATILE)))
+		__netdev_state_change(dev, changes);
 }
 
 /**
-- 
2.25.1

