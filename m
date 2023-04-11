Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9DD6DE4F0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 21:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjDKT1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 15:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDKT1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 15:27:01 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0DE12B;
        Tue, 11 Apr 2023 12:26:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngkOEjPp5ILnZvJjrWpfbKItN2UHwb0R4fCZ8VXjz8isWTdZMqCjqY/NTwSbtZnL7NTWiMMwNtgyFaY0ElDWWDbziJE3uk41k5FPpIXlkSzYizhtoFLHi0T/QK8PBGhHk3RpMVVfDktIjvuJ/uOBaekkqEswm/poSOzNKmtNbxI4WGG9rGv7EocnShio38qrmHwo0dxKUh/ygBoB2T2bg500hdsP6wuHdDXS8+wo727c1rfkp5m7B2zkI+oO9Fjzn3iwe89NHsCeXAq5FQI55rzVwjxlD2zkP73oGEvCSufPfAknqts6+JbynAZ3U24RMu4L9S+zOOOPUbMhGxoyUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ki2Ke+B+gy2S/bIMYwcuLofFFxWjRr3kvQbSkzdJsG8=;
 b=CEtFlUr0hzu9HpwY13gT6HXL9xKoQFR/+vyROJQaOKOY5LdLv3Nnw7Ewd2EQXuEd4RUwNBdyWrC0TvCVNF+JRwWNGM5S+n+MxDk8QLl06o1VGykLu7VXa8mNfFvtqd/T2GqFdjhfgTPMIXzCil060ogJlA4zoH+AFKGKfmJYhq7ci8ph+PO2LqKhD4z0Rc4odLBM1sqXzH8jr/J95WlYNQ7cdhhiiqyMrXpWla1bVHhONQgV/OkuBMUGvAc+YmbPV6ejYmXU3CWNLwhxUSNXr5/Y0uV0HDpDfmr/AE0xb6//tPIGitScjqJ/z/GHo8qZtrz2mFJttbrtR/kXTkO1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ki2Ke+B+gy2S/bIMYwcuLofFFxWjRr3kvQbSkzdJsG8=;
 b=eyTMBGi6leEs1vdWKmbVQXdG7EYssyUWQJLWL+QkkZZGisfRnlLkxTNhzwedgiPZgDJOYBDBn5XMsa51sZTsos2Ucwh1FVsskGJLL9g1RflXlv3jtot84tZLa18hHVpLhgrg5Dv8c7pGbHK2baZvwuPsZ7s8cyoo4GtSmQ3whE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PR3PR04MB7450.eurprd04.prod.outlook.com (2603:10a6:102:8a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 19:26:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 19:26:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: workaround for unresponsive pMAC after receiving express traffic
Date:   Tue, 11 Apr 2023 22:26:45 +0300
Message-Id: <20230411192645.1896048-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0241.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PR3PR04MB7450:EE_
X-MS-Office365-Filtering-Correlation-Id: cd9ecacd-9edb-44bb-22d3-08db3ac2b54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/jd+2IiAFVOJQhNFDQru5Lq36Fb2uJczeZjC7ak2BkisaeuNL3SSVDgFA7B/cSJx8dSBjq7HvLZd9uzf2xxlo7CchFZ4X9c8Ga5tP1Y+81CzACAvZ33WHpcxo6ANBVLsOmP2LYCN6Ryqp6GySy3FkQImHcz4DpqPoNi2Z6V/3KPxrNFFaPGx5J+alabdlKRvrhGls0nBBQX+d6o8JAmA2M0Wl4Uxoy62TdfUw2NUiitw9jfRdSe6pQF+WpDSKmXdTTDbvb/qeXOFZVdGU0IJU/pr/T4wNfTmR2/1M7hOK4y2JKXuimad6NUs8x6fPbX5w1HbSo4tNnuSJrGkZ9SZ6j9bTs0aTK77o4bY3rniU/rn2mdUnlSXfd62P08Re57P+VSOH3EHC+BWahrDm8m5xUfDYbo5qtizFaBhveHztMrtQt2HqzfgUK13UlaAkeaZ8+RJeXMrq5FecgmBEQkjaezxxScbfeNIPuMaWFcbzN/pfJiUsIbQd3G2kJFAY5YaQ9NrmVqAHZ+m5WZ2CmzyK6koYlq9rIQdIGnRyGZV2e+o75Vn8P6/UTznK0nJmmLvZ9DBHYO8mQcSbsFWfzKCA5HZ7SbzSs+lvu+YmhhnBd1W5N4adLMn7rA+F2IJVX+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199021)(478600001)(52116002)(1076003)(26005)(316002)(6506007)(186003)(44832011)(54906003)(2906002)(5660300002)(4326008)(66946007)(8676002)(6916009)(6666004)(66476007)(6486002)(41300700001)(8936002)(66556008)(38350700002)(83380400001)(86362001)(36756003)(6512007)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k36rGFlTLtRVL74bVF8qEPABJ4Y0vSrBlo7hJ1myTYcPlO3hdU+ZCOvVmu0t?=
 =?us-ascii?Q?vB1I1FiC6ZgeZruq6D0Ixs0MllAvel2Jv5wrPQgj1cponGsftxUEUJpmO/Pc?=
 =?us-ascii?Q?LPtJU6v5Hi6BujQc2HGfQz1MSuFESP5ErsfHEBo5WDAjMs4/TuZTgB6tBvce?=
 =?us-ascii?Q?fNQ79kO471JjONFp8892AmawtdhLc3RXD506+zZkpbCYYX13ppOO0Dc67TbN?=
 =?us-ascii?Q?FUe0EPcpD34zh+gMElFbcEqNqWKi2DpdLFunolp0auUQQkSj9fU6F5XLGr8A?=
 =?us-ascii?Q?FASRFpolREj4oBCydrKKVrmP3Lzv32zVUdaIbGA2oXtOiXx24FkLfjLnHfqT?=
 =?us-ascii?Q?qg0Di8Q8Do7p2btMcuec9VoYYMSTgRXhaBOlcV7TBIQ8MwqtVjo5o6D3/xMA?=
 =?us-ascii?Q?AGdNw+KcLbBLDnNpphZi071bL3zZZmwE23HWu7idZ5mudJ6teZr0Czbk4YZT?=
 =?us-ascii?Q?0DM7rGAe9aAM7DQVLzTfqgrcKyGvERaBW1By0cW2xWNm2aSayTq0bu3hr4zH?=
 =?us-ascii?Q?aYdAbKfpdYZ9YtCKk1E3yBLVk/iOWKsnTlGfN8bqkYrmLdem+RyfeZH4xmg2?=
 =?us-ascii?Q?kf9p06byDCb4p+blKY1zbD22VLP/jC2+qYWmI7cy1plO5Ml9IemUXrV6OE5w?=
 =?us-ascii?Q?+FRi2+8Qa3wY68iRIV9+MNzo4NpEfItNQzZMMqxjdTB/hri2YoGSo4T6aUVp?=
 =?us-ascii?Q?8OD3vX1yCoz5cU+i8uNGKP39ZnQ6vSporaOWWl0Ga06u0cLnxUta+7t7W9D6?=
 =?us-ascii?Q?wy2qeQOkp9NdqJTl46eeHZtk1CDrEp6Fgkya6pVikboo3bTu6SkjWCvbvMps?=
 =?us-ascii?Q?TvHZbOPT5fSm1pi8e9PLDpmVYGe1IgnJYMduqqfVuSZh8B63J5CCuuVQXrhG?=
 =?us-ascii?Q?l+IyZXMWH4L1wH8NhsVXXSfYdhsNuHLkYOrMlAFm91Eef6k463OMKFXcsnSn?=
 =?us-ascii?Q?gX7f10IyAi62wI15LXy8zdJ/PoH+P5pA/rCtzGkWUT8fJP26vdj1L61Z8kTn?=
 =?us-ascii?Q?SfB3nDN0t21caLlErHBMdTO316782Cm84Vh/d1cyHcWfHveKYbffcsg67wCj?=
 =?us-ascii?Q?kkUHGcIZBSWOgT/NcNTZD8reUs5pkr5LgmUHItOcIH/3znHOlLu0ae2oH0Y2?=
 =?us-ascii?Q?cV4kgp+FFsVZUBd3j/fY6QhgK3YuHvBgCJbFfrz4kglZkJ62K2nVZMzo9kQk?=
 =?us-ascii?Q?djq+3R2IJmSYZHUlIhtTmeZ/ALjL/bfAX2G8iew6um+vKFSaUs9xWMiPrJpB?=
 =?us-ascii?Q?eLnAjEoe8ViugHtAw66O7JeKE4vZ5p2vTDwk+ZdjpG8LAZnbFfrSMT1u3bFD?=
 =?us-ascii?Q?nOeNi88Czn9ECVghBYTO5vnkufMKlEeas2HBuMul4PBHNaqRwUlBzei1gMrG?=
 =?us-ascii?Q?EPWaJelMbtlwxkKRhd+1qMnHqF2RntFX32kveXiCGThtVg+4ys+uUWJq7bxZ?=
 =?us-ascii?Q?IarCHbAscxs+2cVbl4Ix/XrsV+j9g/1cKLfhI3T3g5HRZyrSLHCdZabPIuGV?=
 =?us-ascii?Q?MropDgyrF2jKUEMNnuwbpO2fu6zTEKy6zD4dhr+OB0dr5pS9e9UOgiHAVLg0?=
 =?us-ascii?Q?6XmwXfs4G1q4MfAGTodYj/ndE+DrxZJccp7VrKmavBT28GUstjgaoNfYm9Hf?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9ecacd-9edb-44bb-22d3-08db3ac2b54e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 19:26:54.4853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pe94Q7861ps+35Sps4qYZ4J1FoMmxg8qMCPpX9JqFWsCCxfc2AaZsW69eS3tbVYJ76X08j4UmT1/ZkO+34wGSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7450
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have observed an issue where the RX direction of the LS1028A ENETC pMAC
seems unresponsive. The minimal procedure to reproduce the issue is:

1. Connect ENETC port 0 with a loopback RJ45 cable to one of the Felix
   switch ports (0).

2. Bring the ports up (MAC Merge layer is not enabled on either end).

3. Send a large quantity of unidirectional (express) traffic from Felix
   to ENETC. I tried altering frame size and frame count, and it doesn't
   appear to be specific to either of them, but rather, to the quantity
   of octets received. Lowering the frame count, the minimum quantity of
   packets to reproduce relatively consistently seems to be around 37000
   frames at 1514 octets (w/o FCS) each.

4. Using ethtool --set-mm, enable the pMAC in the Felix and in the ENETC
   ports, in both RX and TX directions, and with verification on both
   ends.

5. Wait for verification to complete on both sides.

6. Configure a traffic class as preemptible on both ends.

7. Send some packets again.

The issue is at step 5, where the verification process of ENETC ends
(meaning that Felix responds with an SMD-R and ENETC sees the response),
but the verification process of Felix never ends (it remains VERIFYING).

If step 3 is skipped or if ENETC receives less traffic than
approximately that threshold, the test runs all the way through
(verification succeeds on both ends, preemptible traffic passes fine).

If, between step 4 and 5, the step below is also introduced:

4.1. Disable and re-enable PM0_COMMAND_CONFIG bit RX_EN

then again, the sequence of steps runs all the way through, and
verification succeeds, even if there was the previous RX traffic
injected into ENETC.

Traffic sent *by* the ENETC port prior to enabling the MAC Merge layer
does not seem to influence the verification result, only received
traffic does.

The LS1028A manual does not mention any relationship between
PM0_COMMAND_CONFIG and MMCSR, and the hardware people don't seem to
know for now either.

The bit that is toggled to work around the issue is also toggled
by enetc_mac_enable(), called from phylink's mac_link_down() and
mac_link_up() methods - which is how the workaround was found:
verification would work after a link down/up.

Fixes: c7b9e8086902 ("net: enetc: add support for MAC Merge layer")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_ethtool.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index da9d4b310fcd..838750a03cf6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -989,6 +989,20 @@ static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
 	return 0;
 }
 
+/* FIXME: Workaround for the link partner's verification failing if ENETC
+ * priorly received too much express traffic. The documentation doesn't
+ * suggest this is needed.
+ */
+static void enetc_restart_emac_rx(struct enetc_si *si)
+{
+	u32 val = enetc_port_rd(&si->hw, ENETC_PM0_CMD_CFG);
+
+	enetc_port_wr(&si->hw, ENETC_PM0_CMD_CFG, val & ~ENETC_PM0_RX_EN);
+
+	if (val & ENETC_PM0_RX_EN)
+		enetc_port_wr(&si->hw, ENETC_PM0_CMD_CFG, val);
+}
+
 static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
 			struct netlink_ext_ack *extack)
 {
@@ -1040,6 +1054,8 @@ static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
 
 	enetc_port_wr(hw, ENETC_MMCSR, val);
 
+	enetc_restart_emac_rx(priv->si);
+
 	mutex_unlock(&priv->mm_lock);
 
 	return 0;
-- 
2.34.1

