Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59446AE57E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjCGPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjCGPyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:54:43 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2077.outbound.protection.outlook.com [40.107.103.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCC98DCDB;
        Tue,  7 Mar 2023 07:54:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhmbvJ7ej+2jR6TMuuQLtAjbZkGPGQxumP3DQ+gDeu7s6J3nrefZDkBt6R6khBBPa3coMpQKx2f9JqIOKnRWnYczdyKrW6nvDqE4BQP5jZ9InvMAp5iYULM5Cq2J8DHrsTY6JcR5OK+BLpXuKFwx75cXxlrgZRJBVR8M5tLNdydaSZrA4wcqD6gG8AbqF1YEipcJsCv+H181L3vew5WG6nJ6a20tjjX/uXsrY7TGGoZeqdJzEM60cONjHY/yP4ii+Jt+p1MlAU4WXTmtZohoOg7hXgh8aC/KhWTYH3mB4RmgUu9FUcjtmdihYJq3lORt3FGC3QADGsp3XGt8SLDIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JreJ/ToUY3xijsocCVxeGcjs8TwnvGQep1b07cuiX6s=;
 b=eOBM2fP2IcYx1ExEEWE5hWGhzIobSOHoC0bqwYNXLQwgY0CAJnJdSR68nETQuNOlgzRwtUQtxoXKRhG/u3CU0RGv49YZTaHo4X/U4ZvMSvB9xgBZXagEAmSy7NGka1Th2iQrAgCmuHWME3+KLQePNVWVOVctjYLwohBFPRYptXG9JZ9NkNuef/57bb3VlJHV3L5qB/ohLBD6Rplio1pVZMxI7egxb7rrBj5RqjI8+1dcdGrjL20IxRhcYYfoTJsNezMjelYPsOKYY4kAIG6EdMKuLmGCxybvEychxMZEcCBB2k41gtmVOSO6+IVI0nEvLDNqeW/+ib2B4ysEFbC0jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JreJ/ToUY3xijsocCVxeGcjs8TwnvGQep1b07cuiX6s=;
 b=SaB5AIxkffPgmAWBivdl6gOvka87dRGYtFqA+eDf/KXUhZp9rCpyHCNlvfHMgx1LEhP1NYH8BcPOC0Q4VDg52scVilgL+OKkuF81F20i9x8y0YBkb9ErrHIX8QGL52/r5oGzvJ0V6eJt9KB1O7V0bS1/yrl3Xx0X/tqOEBnGwxI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9513.eurprd04.prod.outlook.com (2603:10a6:150:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 15:54:24 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:54:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, Greg Ungerer <gerg@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, arinc9.unal@gmail.com,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net] net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC
Date:   Tue,  7 Mar 2023 17:54:11 +0200
Message-Id: <20230307155411.868573-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P193CA0021.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::31) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9513:EE_
X-MS-Office365-Filtering-Correlation-Id: 804dd4ca-ec8d-416f-c66a-08db1f243922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbKV7HCNcwo54sK4fh1GzH3R/M83+lkaXxCnpsjiFa2pCIV2pMvB9tHS3zkaaqWnn/HBRq91orCck8Gs+4XLRm+ejyWdpjyrb2qxln98ikjY4kCXlDHVyFa3kyRsn4Bkh/AlkXq5Qycj/f7EYt2WJ7lOtvtVxZje1Chz7ddCIP99KXV3wkTcS6OBwJhF4bS6Ng6V8B89jcoecAypHCaMznUFMK65U7bDOCc8mTlYOpBZ+B9OXmgDSabQ5PAvpNXfKgWbEhHp4+UzakVjKsIddb/3dUrBGd/ZYTIJvYBYLv+yLsSMl2acaQXAa6lx7F721IN0sQlsXvSE0f292LWenpu6HGnGwiW/aWB58Wt9TwyxBJVEXPYtGWKajHMAPsFrkH/H6eBYePOG/Q1+S37VD9gqUaj71J2z1kOqznvMn+Z7MK3GcTbx6XimBG8mIkj7ZGffqSOLsyl3Vo8Xpr+ssNyHF+h8HiXdMJMIJA2EMviVDmv2gG+rv3t27uuydEA7qCYs5wcAKqGHrglMGWX1bDK5tCxdhnS8hC1F7At1akdcuQGzUNdvwlqbwKjXWy1PgF0j3tQweo/qHg/WTZzorZIu4SZ+j28h+f0uGqp39ct27beKczncrYsC4G0XHqvsw6r2NUoss58FazfuHgTSOLSJPmAC+ObOVLC9Iy4mITZpJxEa8S4Pit7CS/q1UxF4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(66574015)(316002)(54906003)(36756003)(38100700002)(38350700002)(86362001)(6506007)(26005)(6512007)(1076003)(83380400001)(186003)(2616005)(52116002)(5660300002)(8936002)(7416002)(966005)(478600001)(6486002)(4326008)(41300700001)(6666004)(2906002)(44832011)(66556008)(66476007)(66946007)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUxvR2czelR0MlhyeDZyb1dZbXdDWkdMVkZiOHczaGg5eENDKzNBcXV3eDdY?=
 =?utf-8?B?WWl1d0x5eWlnZU1iQ00ySHljcSt3N2dmeExKVkUzQUxUTElheDVlNkhnZEpM?=
 =?utf-8?B?WHZJalE4bURGWkZFRUNKRG1GblRSdG51NlFEV1VGYWkwTUErdkVEMFY4NFhF?=
 =?utf-8?B?azR5N0hUMXBQYjVzS0JadEh5VUJyNTZ3QjZFbnZnYkRKaEdqQVlaQ1N0eTJX?=
 =?utf-8?B?dnpLaHBLa3lPY1ovcnFEL2VXVEMzNGVIUTAySjJkU1RnNytMYlIvYURzV2lB?=
 =?utf-8?B?dDNMR0ZoYm85V0ltRWQ4T1ROUzhsRnhZaGhmVEl0RHo5Njc0Y0dRLzZETFY2?=
 =?utf-8?B?ZlRPUzBTS3o3U0dvRjVUY2k5RkYvNVAvRjJvN1Z4VWFSYlFuN2NPMVhoS1R6?=
 =?utf-8?B?dDZxK3paRjRIZWRlTlc4OE1DUGp1bk5DenJlcTduRGRtVkVJLzdlVjY2dWsy?=
 =?utf-8?B?a3BFKyt0a09iTlcweklYTzR5V3pNMUFWUzJsY1E4SG1YbmZxRVl1ODNTWDhT?=
 =?utf-8?B?RzZUbTZUVGxvZ1BlZjdBeHBWZGE5UFU0Skk0NG5JcDUwZDlTVHJzWE9ucmVl?=
 =?utf-8?B?Z2k1eWtYSVB6eWdLQ1p4eGFoWm0xcXU0ZUVqL1RPU2RHai9VL0dYVDdNcGF3?=
 =?utf-8?B?bC81QkhIc3JsWlZCcWNKUG5tVlNHSE1NNWRQcjkvVDRYdXAxUTZGT1VocWxh?=
 =?utf-8?B?SHYzZ2c1aE9mWDhCS1FKb1lNL2J5b2w0Ri9TTEtrNk9pWVBmR1d0RUNZUnlL?=
 =?utf-8?B?MFZ1U2FuR1J6cjVkMTNJVE5EYkZHbWorcFgyQ1l3SkEwSktvb1ZzOXV6TDc0?=
 =?utf-8?B?SC9NcE9FcHA1UGY0Y0FSb3dNeUFvU1FxUkxzN0dOUjg3S2dTWlNoYm1tTnAr?=
 =?utf-8?B?VkNtRWxXYWVOcm5BdklEK0lNVThZRWxpcDdJUlNqTXA3azVLUUpJa3hJVlA1?=
 =?utf-8?B?aFFOZHNxNFJJL0laOWpkLzdWUW95UDdwSTBQazcvbTFadzBkM1pnc0EwYy9Y?=
 =?utf-8?B?cWU4SzVGTGlyN3hJQklCSnJoeEtUSklINVVvU2JoWDVubW5FQWxreUdsRHAx?=
 =?utf-8?B?RklQTFZPUHU4TmxrdkxJQWpVRmovUVVEOU5sNG5JdXBnR1p5aUp3OGZxeVQ3?=
 =?utf-8?B?TjFUcjVrbUU3Q3RvM1dCUTZkS3NXN2VOdjhYQ240SEhkZ0tjMVFTemFhQ3I0?=
 =?utf-8?B?em5RdkYxU2trUmVsc2pNNXcyQUVZVm9rSDZrSDcrUlkvMWIwL3VBV2J0S25T?=
 =?utf-8?B?N1A4REE4NFdlUTBzNWcrblpRNEFIejBMKy9VWlpqMmszL0JxbzREK2lnbnpz?=
 =?utf-8?B?dVhZUTVsbUlvL0N6bDBNNzVMeVYvaU5UUUZybEljTXd5UmUvT2JyUE5RNGJn?=
 =?utf-8?B?UEloelI2bnp6M1B5ZXlVaEJZeVNvRlVPNzdhV2x3UlE1ZTdCdzVHcGt2SkxU?=
 =?utf-8?B?bmpaUk5ZUXRxOEdLMnBhMnh5RjZKWFRMMk8reXczMmdZcURnZjcrSkUxbndo?=
 =?utf-8?B?aE9mWEJ6blZTWmhnZk8wbGxxN0tqNTlJUEJPS3hWYlliTWhpTklSUzVKbG1P?=
 =?utf-8?B?eHF5SVh5MGVtUnB1d2JMVGpkN2xlR1RmVkUweHBEZnJ5ZHlvQzFYcHJqZCtR?=
 =?utf-8?B?ZWRNelRuckoyOXE1c2FVdXlaTUNRYlZ5RkdyRVc1VHpLWVBmaFpHMmJlS3Qr?=
 =?utf-8?B?KzBTcXorSVBBdGN2RFp6U1hUNHdYSWo2c05UbUxFTFZsMnBaSFJ5NU1rQitL?=
 =?utf-8?B?MXY5V3dBU3FwbjE3Vm9nUDMvb0hadXlSSVI5N1Z5U091OGlwcW9Jb0VYRkN6?=
 =?utf-8?B?djVJS2N1alJBSjRHeW5FNW9CeTRjMk1ZYURsNDlCMFM2Tkt4RzVWRGtjWnVz?=
 =?utf-8?B?WjRXZDZYSC8yYUlIby9rYnNpNnlDdlVnRnh3STBxS09RbjFtbFIyVUhGYkRK?=
 =?utf-8?B?OGVWZlBWRFR6S3FvRDVIY2xMOE9WclpGM0RBNVFkenlmRG9YM2RiVW5ESFlw?=
 =?utf-8?B?bTg3bVRQRE5CbW41Z1h4MFphYlhvNENJZElSaHZscEduMnFVbktiZlhWTXdL?=
 =?utf-8?B?c2hWUkpnaisyL3NUMCtqdnZvQjhldUI0RXFlTmlZY3J0VlVTV0tDbnRmYzZD?=
 =?utf-8?B?dDRLVG9IdmNwTkVjazJHYVYxN29uRWpJaVN2NmRIMXBTZEdUM29peDZWSTZP?=
 =?utf-8?B?bXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804dd4ca-ec8d-416f-c66a-08db1f243922
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:54:24.3264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hglSc9ofxVbI0fzDio1SPQlWPMDxLCN83AJoGd0AHCkjG365ovRUCXNv0ndFqpQMarNDCKfyhHCSXflG1Jk6GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MT7530 switch from the MT7621 SoC has 2 ports which can be set up as
internal: port 5 and 6. Arınç reports that the GMAC1 attached to port 5
receives corrupted frames, unless port 6 (attached to GMAC0) has been
brought up by the driver. This is true regardless of whether port 5 is
used as a user port or as a CPU port (carrying DSA tags).

Offline debugging (blind for me) which began in the linked thread showed
experimentally that the configuration done by the driver for port 6
contains a step which is needed by port 5 as well - the write to
CORE_GSWPLL_GRP2 (note that I've no idea as to what it does, apart from
the comment "Set core clock into 500Mhz"). Prints put by Arınç show that
the reset value of CORE_GSWPLL_GRP2 is RG_GSWPLL_POSDIV_500M(1) |
RG_GSWPLL_FBKDIV_500M(40) (0x128), both on the MCM MT7530 from the
MT7621 SoC, as well as on the standalone MT7530 from MT7623NI Bananapi
BPI-R2. Apparently, port 5 on the standalone MT7530 can work under both
values of the register, while on the MT7621 SoC it cannot.

The call path that triggers the register write is:

mt753x_phylink_mac_config() for port 6
-> mt753x_pad_setup()
   -> mt7530_pad_clk_setup()

so this fully explains the behavior noticed by Arınç, that bringing port
6 up is necessary.

The simplest fix for the problem is to extract the register writes which
are needed for both port 5 and 6 into a common mt7530_pll_setup()
function, which is called at mt7530_setup() time, immediately after
switch reset. We can argue that this mirrors the code layout introduced
in mt7531_setup() by commit 42bc4fafe359 ("net: mt7531: only do PLL once
after the reset"), in that the PLL setup has the exact same positioning,
and further work to consolidate the separate setup() functions is not
hindered.

Testing confirms that:

- the slight reordering of writes to MT7530_P6ECR and to
  CORE_GSWPLL_GRP1 / CORE_GSWPLL_GRP2 introduced by this change does not
  appear to cause problems for the operation of port 6 on MT7621 and on
  MT7623 (where port 5 also always worked)

- packets sent through port 5 are not corrupted anymore, regardless of
  whether port 6 is enabled by phylink or not (or even present in the
  device tree)

My algorithm for determining the Fixes: tag is as follows. Testing shows
that some logic from mt7530_pad_clk_setup() is needed even for port 5.
Prior to commit ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK
API"), a call did exist for all phy_is_pseudo_fixed_link() ports - so
port 5 included. That commit replaced it with a temporary "Port 5 is not
supported!" comment, and the following commit 38f790a80560 ("net: dsa:
mt7530: Add support for port 5") replaced that comment with a
configuration procedure in mt7530_setup_port5() which was insufficient
for port 5 to work. I'm laying the blame on the patch that claimed
support for port 5, although one would have also needed the change from
commit c3b8e07909db ("net: dsa: mt7530: setup core clock even in TRGMII
mode") for the write to be performed completely independently from port
6's configuration.

Thanks go to Arınç for describing the problem, for debugging and for
testing.

Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/netdev/f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com/
Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3a15015bc409..a508402c4ecb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -393,6 +393,24 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 		mt7530_write(priv, MT7530_ATA1 + (i * 4), reg[i]);
 }
 
+/* Set up switch core clock for MT7530 */
+static void mt7530_pll_setup(struct mt7530_priv *priv)
+{
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
+
+	/* Set core clock into 500Mhz */
+	core_write(priv, CORE_GSWPLL_GRP2,
+		   RG_GSWPLL_POSDIV_500M(1) |
+		   RG_GSWPLL_FBKDIV_500M(25));
+
+	/* Enable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1,
+		   RG_GSWPLL_EN_PRE |
+		   RG_GSWPLL_POSDIV_200M(2) |
+		   RG_GSWPLL_FBKDIV_200M(32));
+}
+
 /* Setup TX circuit including relevant PAD and driving */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -453,21 +471,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
 		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	/* Setup core clock for MT7530 */
-	/* Disable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1, 0);
-
-	/* Set core clock into 500Mhz */
-	core_write(priv, CORE_GSWPLL_GRP2,
-		   RG_GSWPLL_POSDIV_500M(1) |
-		   RG_GSWPLL_FBKDIV_500M(25));
-
-	/* Enable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1,
-		   RG_GSWPLL_EN_PRE |
-		   RG_GSWPLL_POSDIV_200M(2) |
-		   RG_GSWPLL_FBKDIV_200M(32));
-
 	/* Setup the MT7530 TRGMII Tx Clock */
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
@@ -2196,6 +2199,8 @@ mt7530_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7530_pll_setup(priv);
+
 	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
-- 
2.34.1

