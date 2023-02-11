Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A34569330B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 19:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBKSnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 13:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBKSny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 13:43:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2055.outbound.protection.outlook.com [40.107.14.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4C9E3B9;
        Sat, 11 Feb 2023 10:43:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kj38hfv+wbX/FLZhtUDVuAXUbUmdSHftim0WDNIQnf1H/Ub7jTSvCKIoCT1UQ8q8yKtLy/IrXjNmXfipQt1AhphpHjTWT+9roi08QUXLBGGrT2UdNNg7xoy/A7p6ecEstqyTFhjB/mwWR5yBETVGuJMtCR4y4m9YKzynwxxqCGjQn4A01LsYm8P7ly5PnkUpKIUOaMe6LvbXMbjYvCdxWV9E9ssALO72DWrMm7ttgClKsvnNu5MqnKHYsSCn1ccNNX4plHSKQoExV0I5eZzlSchfoByhslZDWstIDi4BVzAsRE0GnaO9IcuCKiaF/aKHz6fnXTptPzxQEr45O4517A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojblXnJZtQ5Nuzx6m+joOQlP2UKppSKbvBR1vJPNz8s=;
 b=i1bkE1d6bqQklSPyJ6C3v23AXFtw/nhCYAPnAzbUEvLrO5kTWczX3UVd5XO6EXvmWIebwJUdREAUpAtRQ0W9WPdOl23fFEC49O7KNaibmzuovYkvUObkYVMQb1qFJ4651Ctbd20pskCbHySMXnaxa7JWqwfxFYgebY2i3hnTcbPmUgRAGAQXxFx7gHhBUVwnMG4P9LeFaFsZMdUbuIZgfm95n+6Un0S7ocL2ydTh8x9BRzhWJmQ+dsacSDCCrGte0Wb5wywRJBx5Wh8/EdpY1VHmxS5jpZiiC7wON7W2KzLUEbkq925SuQK53tHgSQk+b2CHDyha4kZsiqY8iOCxxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=routerhints.com; dmarc=pass action=none
 header.from=routerhints.com; dkim=pass header.d=routerhints.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=routerhints.com;
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 by AM9PR04MB8413.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 18:43:50 +0000
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd]) by VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd%7]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 18:43:50 +0000
From:   Richard van Schagen <richard@routerhints.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next v2] net: dsa: mt7530: add support for changing DSA master
Date:   Sat, 11 Feb 2023 19:41:01 +0100
Message-Id: <20230211184101.651462-1-richard@routerhints.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0224.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::31) To VE1PR04MB7454.eurprd04.prod.outlook.com
 (2603:10a6:800:1a8::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7454:EE_|AM9PR04MB8413:EE_
X-MS-Office365-Filtering-Correlation-Id: da0f8893-9450-48e7-174f-08db0c5fea61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PRcxnX1m7rRzmO6EMr3LzKLCEkdyYOU4TBttahFlBKIgBUNxM/lbM3JmG1EV4rNh5WW8zb/m2qVSZ2nFRwBEt5kJQwoNEjLenwkLLRoC6IsBb34Q+yUHORdNkE+r9Dvzg9B4L5G4iaxlMoHjfb/fhaXmVaf8St8j7iP6f/Vd3rG3el4t1jfelV0zXBA8+e6V/Oh7pcXLx2LUvCK+/pLVEgbxHEBBw3PNdeJbwg+hynAxcdQb1QeRvRLze2obYktBX8GNzEafnxA9iJzFCWBgktxbKMkuJQDHWG/a/ze+ZVz3kML4JIfLm1MVd9MSz0KIp2me+CHCU6M7GpBflksqCGp2QK1v0nEO1J+8xPlkCwRNUQLVnVs55Vj+TtQw5/nHcxJLJSbBrIpYpgMFlQR7FhkkosZyfk4VWnjLWCPxtEByd7TuzEaSPw5hb6Kcbw/S682HIRuFAJ+5Tw9Swe6uK99/e5IuSITHuF0p9tZdk3BO6gKv+zi9VilEtCzLlDa4Lw9m/ZeUq5iKve2wuK8jira0/rS4ysPQCphKMdHiQF2tMsOWLsk6QAcg2KniCTY0OilIUqyG3gdM098BBQwC56N8K+H6U+HsyzM+1IMRNBZTzducYsUgZl3n4EvTQ1hc1ZofBO60d8cRXUwqJ3mUzBCWBvDWt+YQJXqP/Oz19q7VvJKyBPgJLHLz2Mf32v4d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7454.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39830400003)(396003)(136003)(346002)(451199018)(186003)(6512007)(52116002)(5660300002)(6486002)(2616005)(478600001)(66476007)(66946007)(66556008)(66574015)(83380400001)(6506007)(6666004)(1076003)(8676002)(4326008)(7416002)(2906002)(41300700001)(8936002)(38100700002)(921005)(86362001)(36756003)(110136005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S21Pbkt5SUpQWnV0NUFaNjlBbjk0NlJPekJpR25iSG8wOVhCSWpLZ2U0ekF5?=
 =?utf-8?B?V2RkSDIvL2RUUzkwa04vSEVCR29TdnRCblJFT0tXSVZWRG1LczRIL2dDRElz?=
 =?utf-8?B?dEJjb2cvZGh6Q1B3cXhIR2RmdHlLTklZd0pSQVgxOWowVVdkdjE3OFBCQWh5?=
 =?utf-8?B?d091cEdkNEM1RmlIeEFzbXo5VG1aZ2dkcEFhRjJIRTUxSDRTWXRScGxHOWRt?=
 =?utf-8?B?Y1EvY0J3eXhWdzNLRU93VVJ0bFAvQytXMlVBdkhiWVhrclRVN2hpd3pqYmYv?=
 =?utf-8?B?MHBlRUlPSUJBeGVmZ21GTmNYbnFYSXZEc1diYmhBeDZEc1A4MXBMUXg3WitG?=
 =?utf-8?B?WTVZR3RQRmd5bEVhWVR4UUl2RFFneEhtMC9QaE1aQWhVMlR2aDUybkFONzN5?=
 =?utf-8?B?M3F1VjNGcmp2bVZDa3d4Ni9XWkNGQXhYVTU0V2Y3d2pLZXZqNE1wQ2lka1lh?=
 =?utf-8?B?NzY2ZW9NSGtOcEZIcklhMUhBYktkZFlMMldsWDlTdTJ5OGh2Qkd1dFp4SXdL?=
 =?utf-8?B?NmxtSitYODB6aFFEWGd1dzNBZVBTeU5IMTZseGVkZXp4bkxxeHNBckhPYW5Z?=
 =?utf-8?B?QXB5QTR0U0JFNXREV0dadTlYTUMrWjhZZkh0N2xaQ0I2M1llRXFXbzg1K25i?=
 =?utf-8?B?MXJWNWpKM2VtUWJYTzNWWjdrbXB3MUFqWHhFbkZxdUJ0aU9lZUZSRGpRdHA2?=
 =?utf-8?B?OXRxaEptZFJ1L0taeXNZaVdBRGpPenYvdVkxblJza3kwN1JNcko4WnZaeldX?=
 =?utf-8?B?NVpZQVpmZWNmaGlRdW9LNGFiWkRZMFFNL0o5Qk1NdWtJYUFsSFBlVmpYQUVG?=
 =?utf-8?B?bEJsNld6OElMSHZWWDM1UUxsaHFBb0FmTDFXcDhjQU03cjZZOVZXNWZEcFlQ?=
 =?utf-8?B?ODhoVGVJcUg5emxKMndMTEgyNVZIeHNWNmxQMm16ZFpWT1M1c0daVlNaV3p4?=
 =?utf-8?B?WGdkdDdMTHBhdkNmcXdJTXVBSUgrVlBMRHZnSzk4N3Z4dmFRb1RZL0k4QlFa?=
 =?utf-8?B?M1RmWERucjk0RGZXSHhOdW5yU2d1TnFZVG1ZZHIvVVcvL1BGeVlSNHZIb2dn?=
 =?utf-8?B?cmhKZmp4UVNwUVhsMmVCa09hTm9Da1hNVlg5MktzS3BNVmpzQjlHMiswSzJX?=
 =?utf-8?B?QVNyN3ZZcnhyQnZlNWNZNG85R0pBbGVRWW1wVU1HNldETzdoeThvOWloVXNU?=
 =?utf-8?B?aHhsbkRhRlNWd3B0eXIwTkhmcklRdlBDeUpBOXhQdEV0N1J3azd3WlA5T3hC?=
 =?utf-8?B?MU9FK0VxUlFpRUNIS1U5OUlrMzE2TSsyUTdteDJWak0vN0kyejI5a2psY2hy?=
 =?utf-8?B?T2FMYWFkRVVveXRGcjJIRStSM01BZUUyK1lCM0U2UUF4WXMwWG1RUm01eCtu?=
 =?utf-8?B?YWoxVWYvS1duT0I3QTh2VWVuZktMQllVOXdZMlhiTFBDV3JJZU9GWmplblBS?=
 =?utf-8?B?VGwzdzJsTFNjYmZCNmpxdkM3cTRuLzEzVkEwUHBrN1Y1a0RidEFoSnFpdDd1?=
 =?utf-8?B?c0lPUnVtSi9FeFFOU2NhcHI0SGtGVjBheHpERk9wdHNYWFNyRTY3NWlLeHNJ?=
 =?utf-8?B?UDM4MmV6R041THVzZ3Q1RkdFa2l6MXJPU2JpTUhjbDFvYzlrZFBJSkh4Y1Rv?=
 =?utf-8?B?SDNLSm5nREF6NnFhbFBMeEtMVSs4dll1eDF1RW41TTF3T1FuTXpXY2xRemNq?=
 =?utf-8?B?SURYZlFtUzB0TWM0eStLZm1LWFRna2k2SXFVVm5najJGOThkMXdNYmRPV3Ex?=
 =?utf-8?B?cWVXaUk1d0RObWQ2cWdJdExUT09wRTd4dzRJMWlKRkc2c0pLeVJIRC9rRzRr?=
 =?utf-8?B?R09ZSGhOT0s4WlBybXlEaXJWcURrWU05dGl4ei8xYk9mYzhMREFjRXU5a1Y1?=
 =?utf-8?B?Y0djZmkyNDVMSUF4V2FlbjUrNTNGMWJPd3dhRmNYWll1czV4b0JxU1JrK2d0?=
 =?utf-8?B?dTVZbjdvL1J4V1hUS3J4eDlFdVBGOElqcVE2d2N6UGJQbG55cFhRQnlkUnYv?=
 =?utf-8?B?MW5WZVVBS25FbVdHcVUrUXgzVXhqeFlKZU04a005S2VzY05ydWxEbFlkOFN3?=
 =?utf-8?B?OVRTTUY5anB5dXRLQ0NWc0hoT1pQNmdJVFlkUmhNZFJnbmFmemVsZVBtZzBr?=
 =?utf-8?B?U1RCS3A2QS9BOFpYdVRDVjBPUU92dFVtK1VvWUxwYTBnSmZNeEFzVzVKSmR3?=
 =?utf-8?B?VVZDZ2hmTDhuVGFES3RkTGtEWlYvRlgzdVVqa0VmTElBTW9XdGkxNXNpclhS?=
 =?utf-8?B?dkMycVdRZi85SFRVZDFuY21LNG9BPT0=?=
X-OriginatorOrg: routerhints.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da0f8893-9450-48e7-174f-08db0c5fea61
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7454.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 18:43:49.9214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 28838f2d-4c9a-459e-ada0-2a4216caa4fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZdTjZ8Nw9iqiyP+TmjjUiUtH6lumvKjzjHK3Xq/NKF338CJSH/hQzNgdE4117VhYMx5pgLVe9z/22QTnjJ3Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8413
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for changing the master of a port on the MT7530 DSA subdriver.


Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Richard van Schagen <richard@routerhints.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b5ad4b4fc00c..2374166c4858 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1072,6 +1072,35 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+mt7530_port_change_master(struct dsa_switch *ds, int port,
+			  struct net_device *master,
+			  struct netlink_ext_ack *extack)
+{
+	struct mt7530_priv *priv = ds->priv;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+
+	if (netif_is_lag_master(master)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "LAG DSA master not supported");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&priv->reg_mutex);
+
+	/* Move old to new cpu on User port */
+	priv->ports[port].pm &= ~PCR_MATRIX(BIT(dp->cpu_dp->index));
+	priv->ports[port].pm |= PCR_MATRIX(BIT(cpu_dp->index));
+
+	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
+		   priv->ports[port].pm);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	return 0;
+}
+
 static int
 mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
@@ -3157,6 +3186,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.set_ageing_time	= mt7530_set_ageing_time,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
+	.port_change_master	= mt7530_port_change_master,
 	.port_change_mtu	= mt7530_port_change_mtu,
 	.port_max_mtu		= mt7530_port_max_mtu,
 	.port_stp_state_set	= mt7530_stp_state_set,
-- 
2.30.2

