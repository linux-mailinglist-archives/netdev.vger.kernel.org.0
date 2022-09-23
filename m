Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09A25E7FDD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiIWQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiIWQdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:39 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3889413F297;
        Fri, 23 Sep 2022 09:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcyYJau8TwwOP5ohWx0OM2yeTJJlAYCNW+BY5LyD9w2bDe3oNqlcencPv/LXES9TX2MUHsVoZWpzaPVJlt8wzw4C/i1WD0+FxSYaB6nnbvAuuODrFpZ3lSLcSw5axNAqhXZGBx73quzqg4cIyNXrr8qVJGMFizxgm+GulEJniRGAx7qGggjxTqgWe+oYGejqQZ3y1jzhr6ywHKyrOLxWq4fwb//lkrbpwcOIbg3ywrOGuFLuzu5JgYJvSPKeAjEp0Jwpq7ZbUOQWnC79fZa9raZNVcQPimgq9HnpD4XrhCJZHGc1JPtNcD/M09jB8uGbegFqFRdaVFumlNPmJKUxUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PwgRF5vQ31hB0Ud0Xog6REIZGvB26mJcMWzOfBDPXrQ=;
 b=btLH9y/kl99fqA3CjxWoUSI/IYrkHcnE7Mb8jIdqniOqVDQx7G1GD613Gy++loaL+GUynhvwt0tpX8l7KbO1yLExMG/7m/bCl8MO4GJC39Cs6u0OcchgCLiKz0JZStdbahXl3QVqhTdjBIZpVcQc5JIFCorNOXmxUVemINwxfbyhXovMQr9g1vTurC1gL1k9h+1WZbvLKPea6Qdjn2T8ZYrgqwH8ChK+NeMO5OHZrJUYB7w64Ov/Fhf8suS2jNnh0LJAbT93ptOSY/Tx92EMYyQfBPRcVt5fTiHBe8ymotD9vkj63SnzciMjjk5mZ5Q0KXc4yF0GezTwRIh8WBRNfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwgRF5vQ31hB0Ud0Xog6REIZGvB26mJcMWzOfBDPXrQ=;
 b=STB7vyHE96SUjiTXGHzsNiNRK40qUX2wRY0lwD2C17AIf+Rc09HyEfXOThvSKw1ddQqhBDmDGgAjH5yUZa0HZRsaUp029RWR3HSle4+ZYVhFgjrcWfT9mpZNIORqDKUgr4W2x1NgD498lxLATVAcxUZ7LF3GNbntSz6EqZXknvk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 04/12] net: stmmac: deny tc-taprio changes to per-tc max SDU
Date:   Fri, 23 Sep 2022 19:33:02 +0300
Message-Id: <20220923163310.3192733-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c577e0-05de-4fbb-c24d-08da9d815ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOVOQPy2NVRdD7m+PwKJiXA3t9RrBgAZwV8HmRjTIQU0wa6MtoFbT4UUwZF4BooFtmmUZZedjJllGyn0rhQEnBjGAMXqezVjYyJnxFmhIoEXWYAvihevqHsdye8bEbsjSrhPb3+rZZkLsYlO7vld7nAWwIVz3viieBfir41MAGUTjgUCaoHi3/abB4oWBBBTtOEVskgywfgWh6Vs51sxq2pHJn8tWd//KZnyZSPSJBa/oKEUrr5HDVpaSMSmBrXJ97CFpkRhaoIVvCBQiEFXOL3J/9VRFm08SPvV5JvNZrx3TqYIcqHBPmPFrG0kLgKWdI9Gz/2eUC8G7h1Mh/Attkxxj6YfN16Tmu+UiDpRQ1VojHUMoRCYXGZh2cKIM8No6Mfg4rJUocbslw0yefDI73EmpotKyPKOG88rxElhL4IEH3e8gOA1jYEWcLep1Xl8PZQGe8jpdIU79lFzYGKfu9NBF1pqlF5ZLByZS598s/sd/LoCpYMlmR6Jx8xTbXX/AoNNNuPzSkssENE9Ov4d6VTeblkMxQu0ogNmHJoW5phVFF01fFsRzDBzOlqidm7GdZwnWC9eeTZwlR50tgChMgW12Wa1JyPS+YWVclaA3nJ3+JLHlnI/+P09DDvlmX4JoJqjoGMqceoIsqMlPJXceqrJD0xFWM0oeT1MQ9peYdFSqYlHiTo1DfNYeUVNdF64sqQWXDuifBAB5Ws9ZtXpJ4nbSZ9N8xN1rnStA3ARu326FxZ7efNn3A49RTgZ7Ul6KvZZ2syRGt99Et28DxJDwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zRbpt6asnOwz6iftdEW/NbAnX94ZwOb82y4lBGxCqUpXYX+QoAf6KFrnfTnV?=
 =?us-ascii?Q?Id8+O+UiSUvB1SdUBDDVr0EAf3MsqF00iZ1Cd5du9dWwFzkWdPHB94glaBnH?=
 =?us-ascii?Q?IjIyL4+KUBvDriaibRzxPHZGPKhzdrCRPaf1Njv024BvMLfJV3GYDaHIh/5w?=
 =?us-ascii?Q?XTwKQBjRAxXXWdi9msLSJN8ZAN489Js1yJxKaBkC0aP1jCW+YoQpykknf4Vf?=
 =?us-ascii?Q?lwtN30WgHkxLpqjjpdlSx2A95vfpXf4fi2AKKLwSyDE3s3OMN38ESIec9UAU?=
 =?us-ascii?Q?NZSKqOa6YGfmzx3VBlWeF15mWlg+vWZtKIx+F7YtoYu6muRVgu3+2UWj0pNF?=
 =?us-ascii?Q?/RvHeQdzK3RRjduAp9k41L+G2FmvuePp1shqqNzLS6h0SCeqXfiyzM4JHBH8?=
 =?us-ascii?Q?i3xSxvn7dh6l2oMQQnmo5nlMUJusfw0bE0H4uHWpZPYy5NLW/HRSKvinbyyS?=
 =?us-ascii?Q?0JQrfmLxE+BEhZ+YGUHRzL7fcv0C5245TyyrAFhWWoFiPxCI/lz0w0edm51+?=
 =?us-ascii?Q?dMHUBCmJCt0lZZN0bN64xDxh6bcrTTapelibAwNb9GKpaLujDUaHc4BGPII6?=
 =?us-ascii?Q?2aqRkJmn/Oh4NxnjMYbvon73Ygsq9tN4b5luve3PFIj8bKSRAYNSDa/g5q6t?=
 =?us-ascii?Q?KO5Fw3KeEDY7gI8SGvg68pUMjeVxBG2/OwNG+f+Z0mNNMOaVodYO4qitRvPI?=
 =?us-ascii?Q?SX8Nw3GKoIw0gasa64zwrkDPXNFJpnUqBJJuVqnfGdPgg5kWgY3VXzcd10Dn?=
 =?us-ascii?Q?LtnaZjRLst/d3e6grTliEFV+18upaqPB3/iZRdLUbwLbCpnhMjymrh6Qs8bz?=
 =?us-ascii?Q?TMYGs6ozfNWRCGudpzrDtY09B3ej+aaY4PCcKslEVwK+5rsVpt0NyFAWBbTw?=
 =?us-ascii?Q?mIR9sq6ithCdDKhQN0CRMROEKePQPPh8vvsPDYhtg2k3r9ys7ZffSL0nJu4y?=
 =?us-ascii?Q?duj3fcpXZXQ2SMeml0dRl9CdkBNyFcuRqKxtzZWYFqbx/zTAeFOGW9uBrcE5?=
 =?us-ascii?Q?uiu8EAWjMXJ2bLCU/Rx5mfkCmVgdkkDURqYsQyhDi+nDF7EeCEmLbQmX2SBR?=
 =?us-ascii?Q?TWEjmEBeo3C3kxDJtQAzT6J37rbgwU76vQd3ehCSRlEx35Hif3/OHSgBMpJV?=
 =?us-ascii?Q?2/uYJSYGG2RLDZ2n0kDrXTXa+NuDQzWg0Zgl8TMkiXLvC+kWJ49oM7C8Y6m3?=
 =?us-ascii?Q?TYbxmudR9X5nFapkfTWltFEAbIRb6xRHd7eQb+WzHAz02BS3ZXQ7LHkT8ArG?=
 =?us-ascii?Q?TEYpmBK/HHrkO9E6gwPBpNY9RFalY6eROKUyoY1RxTKlZ+EpO38fyvaKss1V?=
 =?us-ascii?Q?GpY3No9KnICkOLXLZ3WuKpKDXprobaq83nZ+st1CrlzZmP+vkLe5nfp6fizE?=
 =?us-ascii?Q?gEvCY1E8UROzmt/i16f0kD+2xqogDd/5sxD5vf9K1C7o5kKbZeJChDFwv1Xh?=
 =?us-ascii?Q?5kWoqL5iVTU5xaAemwyRskfNuWOK2W2Wlyf05IpZhW87YHwcmCXsH71aqY1V?=
 =?us-ascii?Q?Y4I7XpZSNc3bZVwU/IIo2yZk1LJtH5InXCFrS/tiRfMA7cYawcFOL+YXKaTI?=
 =?us-ascii?Q?0XnS6yl9m4oMYwF5c3bnat/pHtjc3Tu9DitE+ZAmwxJe4wc+W77W4NIAy9wn?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c577e0-05de-4fbb-c24d-08da9d815ba6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:34.2999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33HhG0Hzjn+zW5rCLG4BBTgRaMjeGh2aG24GA/uCITygPPOkpI9qEO8Z/gn+vVpcg3i8UktxRPirxmS7kALrVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 773e415cc2de..8e9c7d54fb4c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -922,13 +922,17 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	struct plat_stmmacenet_data *plat = priv->plat;
 	struct timespec64 time, current_time, qopt_time;
 	ktime_t current_time_ns;
+	int i, tc, ret = 0;
 	bool fpe = false;
-	int i, ret = 0;
 	u64 ctr;
 
 	if (!priv->dma_cap.estsel)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	switch (wid) {
 	case 0x1:
 		wid = 16;
-- 
2.34.1

