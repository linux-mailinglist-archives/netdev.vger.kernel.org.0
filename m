Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FC75675D3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiGERcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiGERcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:32:09 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8403DE0A
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dERSu/T7kyRx1s4YD6jw97FCwL78ewN8ASBqq/o/udRh+RPRUROvrsIeKuNM4ajnUpbeX+krlgMUBGj3i5+uzExzYxuk/UkdgL9tTfV9eqclli7uU8oyZmTUlHPHknUQCtX6KUOmSDEqdRNmD9DJDlVh/5Mnc6x8ghZv67E7DB912DhXPP76Zvs7eF+iSUsW1c88H7rtH6bxGQchwR1ppQMvU/9S9cjUTC9TkK7cGNR4z8pfmQBXtxbr5oMSCt3EBkYwpv4j5vRN+3YcYTNJdu/V2XmxzjI6Fn9wmjXWpVwNKd7IhcHbANEOWLvbJkx1rEHbrvMr+OCZ8/D2d8XZxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MAwjsv48YBYcRl+gTTMadEue5r/65p8TxNblQRAX9c=;
 b=ZDC/Ukg5Cce+fur6yCHT5jCt4/4jrpmnxY46cyBAQv+ey2PVG5j9yeQo3PZs2Q00rJejv9kYTQWmXsLN993R66eTxFZwxzlmGNma6HYXH1C+om2f0z1+yqRwdUEFqcAE+kNYnN8749VevOhvIre1dTsl1+ElR/8dBMtGgCPDIVkLgfRCo59Tc3mlUIfd1TON39qc3WyEATaJbOeA4F8UXOFXdegkITaoi+csPJXRPC7pIes1KhFHgmhC9N82UK867DCkrGOJRXC6MqP0r1n78fJ702zJqVV44w8Oqc3rHTsGqMH4PVOvWWvx2JJgbAS1etkzmIyhG9dBP9m7+ydgaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MAwjsv48YBYcRl+gTTMadEue5r/65p8TxNblQRAX9c=;
 b=D7/JvUldd/n6QWDMFz14zyb2c296cp5Hzftn3RxqwZe5YaMJRVEcnclY40Z6bNfTqd2+LzALMd74IjIbV9owylbCpiLxmri1JMhR3LGqCwdETx1sePpxTgGtd/B6WRC23yrQKYEhDNnWJxwFZr+P5dUhHSXSkcAuPXZMcGI7tt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4251.eurprd04.prod.outlook.com (2603:10a6:5:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 17:32:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 17:32:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH net-next 2/3] net: dsa: ar9331: remove ds->configure_vlan_while_not_filtering
Date:   Tue,  5 Jul 2022 20:31:13 +0300
Message-Id: <20220705173114.2004386-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f108c6ac-1aa8-4ee9-a826-08da5eac477f
X-MS-TrafficTypeDiagnostic: DB7PR04MB4251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t712uOdNx4s6shz40oM6rwiN7B9fZhttRAZ8eEMAQHfCXTgc9Lb/tVD+X8vpWM3M7aCE6yV3mi4NrGn67WR7asL5YhqL1gTY83b4tTcA9Wy6UqXgb2GJyGaJRhkL+easKXTtmBfcljrg8bcFqe1T5aZDHgrZNrPIHrqJX4IU/3D15i6xNr7J6CjznL/YJpJhkIcF4WPp+3olqp2qd4b2VjwlbALMBRtyMvIU71hGl64ZGl5sHnmZtN4qr5O9mxPlef0oMfD1m93s77mxFlq54n1Q2ywHZqMIcBAL0R64U3eGBl4RyFq9hEdPS5QfyJDIq6YyOzuV1xiv1dhOb6v1OO12jRxQv1AUVp7AryGUHsHcknBkMHQ7JIF5I6MMmthNHd5fQEqdf8z4dj8qVV+yIRjoIZ1uYAX7hBMh4TCPhKiBp8qvN6cKP40hPrSVByXkrkWMBlZU5v+0ztujyXsjifVPQMl3art4GB0G4QCXgIYopeRUPlIDStkstS0NLngBdHFsv3K3UcuTFrDQOkxMRxTBjXzir+zQUJfDHIsITu2iwg0iebjDW2qyC1e7ozgQ1wi+XFnWY+0xt21i14lEeyYAz7nPLXFH0WbPjWxX04ttIqlUl7ZlvneyU2W5Kfeq4sOH61KFOU5hOyoqgfQHLjJCwhuLddyv9wQBhCzcdP2SFL8XMHxsq6PLAq4bn4lM8k18e2JFrtndmE2E672o8FiFhiG+qDuCPQ3/IzuscgLvegbN/zJbm8Ivd45su/ac0QVmRQmpp/xOJlcsMkRjEht/iXnTDy5ZI4NfP3ctartndrt0A2/FjjsD9ISmG6Ps
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(8676002)(4326008)(66946007)(66556008)(1076003)(478600001)(66476007)(6486002)(186003)(6666004)(52116002)(6506007)(41300700001)(2616005)(54906003)(6916009)(83380400001)(316002)(26005)(86362001)(6512007)(2906002)(38100700002)(38350700002)(36756003)(4744005)(8936002)(7416002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5EdWM7ypm/T9lL4cpN/akr6DDMM/mNSvL5NR4FeIEibFXiFtXtb/LVcUKEU?=
 =?us-ascii?Q?0xFMheScGPzIQj6bHvou/dU1R9uqXMY/+em5Rofys8LGxleDkSEeq4YZD+ZO?=
 =?us-ascii?Q?uGtLl0o3LDb4sL21QgLBUXbkq4liW02pja/rsUBiAYxQAs18VC08uErmgNqt?=
 =?us-ascii?Q?TqgjVpW2Tca14vpjMI5n/RfNaeTO61OlEF/FU5ElgKNtz7FIGhOpaQ/c9oNP?=
 =?us-ascii?Q?Yp3yM0f070XUtnEG1OxoOBdqcktwWBCWzTOWwY9/qYBdsKilsiinGgM/VbRf?=
 =?us-ascii?Q?q6QjufMCfK7LaStBMWxxWFtYWhunvODdtCsHhaNEMOSQQIlLKdQPqwU800Tw?=
 =?us-ascii?Q?mUk9xe+D2OWTILMVS3CZ77ZQsLypZetDrd3j1bIksBeSot2iln5+UWoEOO88?=
 =?us-ascii?Q?/4CpEh2f2Pf/VDTy/77iqNki9W90Zd8VvGtRb9JnyNpc7vJ8m4keet5ElM38?=
 =?us-ascii?Q?Tt8AuK7jGDJJf4ROHRkwSIyIJmCwvHs2BtdMxLJBY84VtWzM5KxODwrFXbEJ?=
 =?us-ascii?Q?ISkrcu9jkIVLsBsiA1MVWT36093wfBtHquNa0mvZV3d/fUrDep/s39ECKKfU?=
 =?us-ascii?Q?2KF/K9SQdUzAdmmW/wgRPQctcGfG4jMUlfS2Cb8PbyU3QYbvXbzvK8l5r1rs?=
 =?us-ascii?Q?i5rDLyBoo1SrOj5I52gi5mzzQ+989CIPnRY9u7ZPIgAgzBIQOEVhh1WknpuJ?=
 =?us-ascii?Q?UwBQYDN+376UjFE+fTWFC/L1qwGbeLsm5dmpC2aGmsdWZA4c1MxR5g8menYg?=
 =?us-ascii?Q?xjWv/vPEbw5I5+0c+SByAtVwP0rYXODrZQHcDke7rywdpkG1QdlOMWVVZ+UQ?=
 =?us-ascii?Q?hwblsjtpJ/pOFsx9LemCbLB0D6vvAqL+TaDI4H9veW+10R24HA08PPH9+jnF?=
 =?us-ascii?Q?2ybs9s922b+OlKyXaV57HT5N81YnMgo+alMLiib0gBBVuIgPfVtOYpn8mIZJ?=
 =?us-ascii?Q?h7h+3zF1pDKLhwXAXHmExWDLxjW0e7M4zmn5mNTlkXVdQ6Ih3exA81H6l2bh?=
 =?us-ascii?Q?gdzFaKAV0Cx+s6OH5j6MtC7asXDXFo8wVvrZ2lXnm/JaMw13ei+JE+DNivnk?=
 =?us-ascii?Q?UGUcSzgn8jAooYI9+gMWYY7ozrvBCAIXnSSwCsYVzD/5Y5v9rb/GJsSPfK0X?=
 =?us-ascii?Q?17Uh69ognWSp4YDa1ZFZmZYpzDKpVuiTXTg2TjkkkPwDtUBSNsBxAlaD+sUT?=
 =?us-ascii?Q?pCW2VMKL2P1hgwqGgdhnV8eFTXAiXu/QiUJzvqLwipBhIMhbBc8pEg907C4x?=
 =?us-ascii?Q?fdPY8gxLsQynFGzBBYqwvdE6VoBgurrWO5BNKZdHq3vZU8eto6hr0CTl1Hgx?=
 =?us-ascii?Q?/05PHk5hdC4MksOA7frmi5T1CoakGppCYJadONrg29Z2MwOPbTsTtBEs1iUV?=
 =?us-ascii?Q?WBLWobPV+OOSDhN82hfAqU3/2dORezH5jvJrLzSOiuwqjjrLipxdnEB+NG/r?=
 =?us-ascii?Q?2wdzztkyB7l2xs6D+o9h5GkOBAdf7YE6bJkFHfRdrXAAMNQgek+ifbXJol31?=
 =?us-ascii?Q?6jxm+lcDLDqkT/JjioidXtufMY5Ebun/+qhNjuab0xY564ZKNas5FTYYEEfO?=
 =?us-ascii?Q?JQi70ND9Kf5r9j7KoXfIlCGmyL78EuV+doNsnAdN2cV/gWPJzYeGrX1eTsRn?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f108c6ac-1aa8-4ee9-a826-08da5eac477f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 17:32:05.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xtk5mPCIEVE3Xw1SbPwxLaDahOmXlmUJq2HAJdW8bZJ4y6ce2x7HtojknoUMZy1zPqiuQljf1p0xBCOV1WIe9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver does not need the DSA legacy opt-in, because it offloads
neither port_bridge_join() nor port_vlan_add(), so all bridging happens
in software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/qca/ar9331.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 0796b7cf8cae..049127758eaf 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -474,8 +474,6 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
 			goto error;
 	}
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 error:
 	dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
-- 
2.25.1

