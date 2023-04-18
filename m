Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F056E5F86
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjDRLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjDRLPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABAC131;
        Tue, 18 Apr 2023 04:15:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hk8gW1f1ucnp5Ay7YwWOq4k1AZlL7Tz6BguG4jjYD7914+0CStr/wEX2u75WbHBKKDK6oIBfuZkOVBKtHOXcb0V+kiCuFHKbGTJTa/YxB4RS+S23Kd7K0e5G1vG71+I55xQ3sLXR+5L33ahfwV1GqpwZpGIH3hg2NEE29Ju20BvRE/DS+pOnvrHpmCU/MRtepGwvYo4WH77umdWZkHgISvG2zsGu/jGBuve0ZIbijkJGlQH2GwolcHYjxOGpM7tLbxKb3Du+aiw5WsEjaXirrO/iEfwjtfUvS1ZlcR1DuaN/ZF/pHBPtEzuXCnLwOPc3JDo/u1TmlJCD76B+Ff1Z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZjUA7315lPdf2IMj2yyXjYZ08dOVjBQffQl85JGoFs=;
 b=dmx17KhWeh9ClOPpJv0if41XOzWVWcyUNaKGmgJbaxx5xU0APmAJwwSf+AWSkz8bOAMd1viW9dJgWnL5cHLue1pVs+N5oB6r9KufuCxOuqkYjZ6hmwaZftDBBDInBqV6p74z56LeQdltF/0HZPx/u83TIU9zvcd67U7v4veExrSfxBuDcqIE6G7lxrgM+hzgJ0EJQux24UK68QR3en0ulnjWjbLQsXl4dqc7IUaMfHA25VEZ2UzOulsIa8JMnBPk2jUVEGSVynzYtrvjNjhqpmdwVqdNA9CLopQ8xDpWGQ48otD6J5Eu81+g7kBj717zKA/0NTCVhlOumXl5vLBlJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZjUA7315lPdf2IMj2yyXjYZ08dOVjBQffQl85JGoFs=;
 b=Y27qcEQci60D7Q9wqywusQLYHegrZk+mEib18Fc1Vpuy8PsQO6UlCmjm5Ly+SOX3+XdPKWCDpS1MCy+OqH0PCYEGu87zZ3KgftudzgZ1bZp9z1of/Dg5yuwKc3vcSFgsF0tLbRw8azavtrR66BF6jYzteZHk7uCq7d2chcpQawg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7863.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:17 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/9] net: enetc: fix MAC Merge layer remaining enabled until a link down event
Date:   Tue, 18 Apr 2023 14:14:51 +0300
Message-Id: <20230418111459.811553-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 33d3fdc7-0760-40fb-2923-08db3ffe304e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IcAdhzOLD/f56UpyiMCJOoonpOlnbVm3tlcflPmRqOLG7c6Zlk1g43mPCn0V2CpWgB42u3uA1G/IItYpoJuzinod7EqfzbjuzFoFkGJn8CwkG3ElTLdWo35ag6HtRlEDqkV+kg02Sdrqx1pO9u5bdopcJzBXHYI6WaARzZ/meJKHkoNRkLGf7pMqvcE1gwcWVt1VJidC5kYxu6iJR+2N05iL0SMCr2ObHWTB8N6YxP1FUtu76aPikMMcYO1kY1JQ+xK9EhmhOaSlvmhFlC4zKGQMT8UDirZDRDTK7qNC+wX8F16iEDPrPQg1TPCoV7NvxrVOykqPhbRSd0KRxGoxm5UGNtjCmxASdyxvP74Z8Y6yuwCQbau3WpGXnOPRzuQvmh5mjscLzOPI2NDq1BPv+7+ERH85JZsLvg04BBg0OUViFxyYwPpNd+bpO6H7ueY4mVsgBQpaxC6kyuxMVxpfr/uYaGH+kw26YvA3jY8DgpJeEOhck7AtNa1p9ERZAFgg+5hbG7jM+cPaslM96ZOs9kv4hrgvUg1vMFBow1cAUbZZ1XOBQhZSn2kUZV7y2V7eAsvsKKvTJ6CoFxlA0QwOE7vYZBOo4gynSu0Nqa/Z5pXG0ERCk9lqHYWxPiYa1HyW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(7416002)(5660300002)(44832011)(86362001)(2616005)(6512007)(83380400001)(186003)(1076003)(26005)(6506007)(38100700002)(38350700002)(8676002)(8936002)(478600001)(54906003)(6486002)(6666004)(316002)(52116002)(41300700001)(36756003)(66476007)(66556008)(4326008)(6916009)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9zDqS0Nw8ZHMb91/0h5FCNsvWNwqslNnp6xbGXxcSgoqmpOerxxsskqXh9HW?=
 =?us-ascii?Q?vI+eZIzaZNYtQhPAQxAeKjmjZuFsFte/Uo+74FFWPu/JT6kT5sxNaOHjOAIG?=
 =?us-ascii?Q?LfOs48/57U60+a58hhKuM/l+tcbOM8zitWUcoilsXpTU3k+hbFsoK3Ye5QUP?=
 =?us-ascii?Q?4Rr3mmTzmCTF7uD5a9KyPCmEcK5MHRboqYgncARsaQGm9So5H6O5PIXPdvFp?=
 =?us-ascii?Q?nCPKW2BXCmXrZV2QfURuk9z4pSYQQCtVBtzIB31fK2AQoPivt+Jtk67Lo1pW?=
 =?us-ascii?Q?xC3WCNEtZj0VpuKvWjW6i6doE0rGSOPOmP/CaC4F1V6w6PiP2S9sYZ5K0KVs?=
 =?us-ascii?Q?hL71FKBBkipbbtCuq+YiOKWriME4wk7w/wEfM5CO2UcIdXfBz8BSeO7Fwt/m?=
 =?us-ascii?Q?Igu97vTNYVxXFWB/BvKGXNq5/hKf+6CyhAyMznnXO4ysgflqwexA8kIpwT2U?=
 =?us-ascii?Q?t679WpTvh26l1af6urNii1EXkBkr09GAXcWn8wG/vMFfDe1wBV2UlHzbzoTR?=
 =?us-ascii?Q?WhxE4h7O2AVhyPu2UYs+TH1D90wqb3Bc0z1hDv/u/sasM2EeW+zZHMyCtlkz?=
 =?us-ascii?Q?zlQSNWeVlj9JTSKTcDuIrZzUhcuxk7RkFg8KRQ4XFc1nwezNUQuGf9lna9IC?=
 =?us-ascii?Q?xozmsokgk9dbGkOOck+FjgJEX1r2AMW9g2rRB2y697uswKwXe1fBW/TO5kr3?=
 =?us-ascii?Q?5c5sxj/Zzyw7YSCdUOZdCTHSXLXZSUslC2mswyOkaaKWmZayiuwS+mBZqVAX?=
 =?us-ascii?Q?WqpfMlqg56UucG0QBorcUu3fb4sc3PdJEoHdsInYrtOdHdcgt4exViE9Lj8U?=
 =?us-ascii?Q?9uEUn0sGrp14+jSXYQ2DIeb6Vx+dTgT+u5wzC6QnhXvtljJpl5iQ38Iceqdk?=
 =?us-ascii?Q?XJMTLgovUk5sKioAB1lYCYcN4F1ZiWrbSu4cWc1+FI5QdFF1n8izdcASK5PH?=
 =?us-ascii?Q?ltSp6D9GkogMuHhgtMylzSGv5Hwr6dohi/Vdu/DdbM1e7IU/xcOZz3KiZCYd?=
 =?us-ascii?Q?gdBAouJj4l37w4VRhD6eWqXUJQufwoDkpfg/Z6xM7IjBHjGwHgnFT36CvEjd?=
 =?us-ascii?Q?93QR5jeIaH5BPd1rsWBkT5Uh89LfbTm8DYzp3lYYw2Wif/DPvZ8jQOmcEvEj?=
 =?us-ascii?Q?CPQYiILNh0AmZ0dw+lh6UrSbgm8JcgJvt2mJtuZ3ds3mKX7Pw/9iLiKOWAbQ?=
 =?us-ascii?Q?EpnFu6RYzWfd6w9xYms9/0MBhbhrZp/c7K6hdk+ZFUhW4rVZFTDUTW0HC0vA?=
 =?us-ascii?Q?r0odPK0t2gQvw9ID8a+kdBP+CDqYppWf6Ly7MGQvtdrVvCXmqvmOo4XvbSBT?=
 =?us-ascii?Q?taTccZJHRNSIzTsCojtT04lZmin4mjm6xDQOA5bitm0XFgtahEvS0IEW+BMo?=
 =?us-ascii?Q?/1m9bq3lnIKg4w4k1E00bP3o3teIpnPyhO59df/Zc1H7jhd2wiigZgxMAMmL?=
 =?us-ascii?Q?tJkdUbVsEoUWKhUx3KRJHAAZftn0Ab5PiTg68NKBqlTRDSScpGAJavh2SQgg?=
 =?us-ascii?Q?1USskxCViX7pYnXH9p6Y7AjGq/TfHk3Wq8Ohl/vhM0yFxJtGufCuEra3JsNa?=
 =?us-ascii?Q?Ng4zAIhiI8rFARmWM3CW3l5/bdpiLSo8FXxAPibgwF8G0VU6pQ5IZy8DwYAj?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d3fdc7-0760-40fb-2923-08db3ffe304e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:16.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdRcqIHMuCeUrQPPAoocNdIBSIVNXhgGT+NJgETVXNwYHkt8Lb1j6REcQfWbcZc7IpUnHJ5qEhGCLsFw9jYpTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current enetc_set_mm() is designed to set the priv->active_offloads bit
ENETC_F_QBU for enetc_mm_link_state_update() to act on, but if the link
is already up, it modifies the ENETC_MMCSR_ME ("Merge Enable") bit
directly.

The problem is that it only *sets* ENETC_MMCSR_ME if the link is up, it
doesn't *clear* it if needed. So subsequent enetc_get_mm() calls still
see tx-enabled as true, up until a link down event, which is when
enetc_mm_link_state_update() will get called.

This is not a functional issue as far as I can assess. It has only come
up because I'd like to uphold a simple API rule in core ethtool code:
the pMAC cannot be disabled if TX is going to be enabled. Currently,
the fact that TX remains enabled for longer than expected (after the
enetc_set_mm() call that disables it) is going to violate that rule,
which is how it was caught.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 838750a03cf6..ee1ea71fe79e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -1041,10 +1041,13 @@ static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
 	else
 		priv->active_offloads &= ~ENETC_F_QBU;
 
-	/* If link is up, enable MAC Merge right away */
-	if (!!(priv->active_offloads & ENETC_F_QBU) &&
-	    !(val & ENETC_MMCSR_LINK_FAIL))
-		val |= ENETC_MMCSR_ME;
+	/* If link is up, enable/disable MAC Merge right away */
+	if (!(val & ENETC_MMCSR_LINK_FAIL)) {
+		if (!!(priv->active_offloads & ENETC_F_QBU))
+			val |= ENETC_MMCSR_ME;
+		else
+			val &= ~ENETC_MMCSR_ME;
+	}
 
 	val &= ~ENETC_MMCSR_VT_MASK;
 	val |= ENETC_MMCSR_VT(cfg->verify_time);
-- 
2.34.1

