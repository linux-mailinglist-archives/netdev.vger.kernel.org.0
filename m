Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49186D422C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjDCKfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjDCKfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:05 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7592D51;
        Mon,  3 Apr 2023 03:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJFTDs9tau6BpIMWJjzxpvEAnc5WsfDUzmOC3dhXnSB1aX72xxKyMdRgoKz5NF5ALYWjzBvrqTWeipKkxbc5hNdQ45xnXtmZI6OpVmV5iGazsm6AL68AVLJ3xtJ6xj8L83bw9iyx4oCENNJiO9UdWAON504GuR/hJBvMC9GKgI00fyMiPIV55Zr+1jDdfkYEzjFBdeH1i3Sfu17LafIWNCWuJOp5McO5Tq9F6scKEQu0/GR7+8iIrWKwB0EfGucdOApwW4Zn+Ff/BRLi0tyMcewE+GvvNPbPUeJo7otxT1YG/4mmLAy3kw+viyR5RjHI/SlwJWhoHbfzjullGA6eCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORaf51nFqoVISRd7cxFxH7jxD3Jlon0OGjdhoeIF108=;
 b=QAEi/I9li/11fs1/pSuF7FqCyHpr4iPk1y5ltKSnWFYP5BS87uoZMvT1qOJ0N9PLbqIkNekLc6ZINtL5ZIGiVgzyJQkJhkgbXnOhDZn5YhE55MPj//K/1HaK05NYTNG1Y6LTAMnfvf9Wj4764VEWiV1tcJxoERVdGySXzg33eZxW3IMonz0Zk34y7Sspw+G7LkG8+3y17mU9Tjl/Sr889TRcV70L4wXEqUCMboq9aTLaBHSjYukPXOl8iXv+6dyAORurtukraEG27rwD8xBrj4BhCqpbBc+2IxDRRBpw/p5k2YVwmDEMHkckFFa/bgW/k/EXNBJHggcQ60XXnjZsBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORaf51nFqoVISRd7cxFxH7jxD3Jlon0OGjdhoeIF108=;
 b=YbWzmJaSDNo8zZU75RU74q6JK7xQ0vmCFW9QT2V9hGhrPTugbnRZzhMtNcQRtidBz4Q08RaLzD7wK2sFz/CWtID7u5HDeAg2QdnRhve/Phsu3FV1sPH/MIUqfW+qFJe/65daUvVgVkqsINb/GCgDwxitW3t9wuWOXkIDVt4r+v4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 4/9] net/sched: mqprio: add an extack message to mqprio_parse_opt()
Date:   Mon,  3 Apr 2023 13:34:35 +0300
Message-Id: <20230403103440.2895683-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9292:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c3043e-7ef5-43f2-9d53-08db342f1593
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +z1/5MlVXRUyqNhbKe+RJcrJti/9sGdbUWJAN6yvs8BibePxZoHhxfbTOj8hny+OeHLGtQu0sLcP9AMiGR0eTSXAZRsg4tGqrarwW5+e8/Rsn1OLYAI87KgF4IIY37O9Lr+ZLDEbueoxx8djh/bhfRwsql9Vo9oNFWF7LV4tu2j41u1a6Z/a1ewAsRX92Nlzx8F+2oGNw/H24bKZS4yaJM/TMdC1Q//2TtBUcku3UnFFPv+C3rXQ8HWFvbl6GKX0UPvtcuyca9i0/KC90Dui/brDf8Kiac2Uvo9Wlrn4UtAdK+uD8DXqBsfHZQpfhydfhw38gyJsRIOVpLi1iAG1bOYQygMBPI8wdWwCgwlbVf+JtBPS9qjRah52ZPqaTz2PUt2omq3p7kdzcx9Gxk/kPRBCEeJsd5PuABHIvIkEFBqkrecueMQeUzpB1auxO7plSCps11Agn87wSJnLWTw+SG81d8MtSL28lH1YL7RYb0wF91DPEKj+qq4kf8ybfAhvGlCfuc+2dTN21S3+PS9dvee4hx4rMgakyXU26QXOxPAlmjFLMhu/1AP50ptLbSnLiGGoYkNhiheDLjZM/3T/07afBGiNzUIWKQRu/vIyigc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(15650500001)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(966005)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MgXxGoMi8ysKlXVzZhPCyet86orWGScvxfeAb1mVVy6q62G6OwIUrhSC1/sS?=
 =?us-ascii?Q?ACbxZxMoiXmGTHLI/qWLkZEwUjPOhp2gQRHBYq6xYjBc++q34/xETTPZBHoL?=
 =?us-ascii?Q?fo43l32ZpGO0lWT4yLFzlepFoOCxmoEubcYTU4a/V39v+lXeRaBIuWxYdp+i?=
 =?us-ascii?Q?eRTg0cLvCPrQzeziZMNRNFa/zG1c/Jeec44b+PybbAjfbEXq5D1rAPamdJcV?=
 =?us-ascii?Q?ML4Y2U2YhFRt1FD8K7RVmfiJs22UItCr+ElkJMXfFoKkf5PMOoj3u26+89jd?=
 =?us-ascii?Q?D3sDy9GeTdztKcDJeZxYhVWsyiRFYfhp5HbkkSkp3W1CFQd2Izhm8vHcS4Y1?=
 =?us-ascii?Q?tR2OGDjR7UJFP9VGsmI1fq5LZwxWRzqdY6/VtUI+Nbg6e+r122NkaFse5xTZ?=
 =?us-ascii?Q?xrXzivA891+xzxWuF5EokdQqghzs1ajHfyNtfWowTc/ZrJqPFkhbJjHq5HYw?=
 =?us-ascii?Q?ZYNFNPzJj9ZVKoXSJtVIEjB5OtI3cLqi1v9I2eY+FzJ1lP0N9REboZsM54Hf?=
 =?us-ascii?Q?9wW3KU0YHCdTL1HrSOnK76TFiA1oiIfGfVyxJjVKc2q6rUVwYqOYuZbcPRPu?=
 =?us-ascii?Q?2KuDYSU8C4DWQyJBOEuq6QkO5yD3obWXOyqObZjua9cHMBFVcJwsK8aEwz/o?=
 =?us-ascii?Q?bpCYXuc8g/dXzA0lq8HoaEgvN2FeV/HlovVNX1EZJVp4L3eTxL3DqPXYo5QU?=
 =?us-ascii?Q?pdW6bjxtEHDV7m3sNa9InbPAWGC3TCkcd7yo2sxXaTKx9vLapX/1Bqi05GyZ?=
 =?us-ascii?Q?Z3DkX3bN8Pu22dTqjvUVVUl+aQY1dvIS3EFeYrt3t141j1x4opllMgtub+pp?=
 =?us-ascii?Q?c8U3ClOCPk9ftBXI6TLA/M2aWb+INLLiNhOZmpR9ffIwodEmkYUi23IerjOL?=
 =?us-ascii?Q?H413X/UTjmh+U18hYr2EUfwvQDch6ndzPJaDUmn/grPh3HCfFZdB1LTZDsGf?=
 =?us-ascii?Q?POsEptNZqPWWtBolXi24/3Oz0JYP9RCq3pWu39miaI039+zGCAbv7ZJyqGYm?=
 =?us-ascii?Q?CEz2BdeRjHDWK5tWoECqtivrzj2HdpH0H2n2UUz4jX39NDopRsrGCFQYqDdM?=
 =?us-ascii?Q?1HAXXeXYoCmLkEwBtXdxvxmdG7d/ZNWmU3Vu3B0BtfXaUwCp2M4+Bi+p42Bg?=
 =?us-ascii?Q?5/Cdg3jtokA7tGPYCItuU7KKadB8VU9sKLqcR6QrgS+JTULfww58nwJdD0yp?=
 =?us-ascii?Q?JIOh5P3sZuzkdm7ghg30byaWaWwy6wbn4tI9hxp0r0oZjAylHZLlyBIISa+x?=
 =?us-ascii?Q?gUkGBRhljOeJAdcVGu9ZkvTY2Qidmyrp1eTahvuW8AwxjZlJlXip4D6Rqzo5?=
 =?us-ascii?Q?TvOd/a0NqEXfJ+utDcv05quibundjSOtGauKuIMarhbFX8oeNQhmbtS6OnK6?=
 =?us-ascii?Q?DCcMRV/8UPYKnJSCjnSAIiROT0SBSojQ2uUwsqShjW4z+niKIoampGDPYfS0?=
 =?us-ascii?Q?MBNvOia3wQWW7f4K+ntap376Daw0WqF61gMezTzVkf5BTFCAcw0Cl9b9f2r/?=
 =?us-ascii?Q?BXd0yHdeFeIjGW2P1VWxiT1J+JdVfx6Zk7qy2mLLkrZsHczFlDt7K17HTN+F?=
 =?us-ascii?Q?H8dH9tHs5+EhUSUX+hcoXz1xbnElE8afbTRGabRp2Ld4BdFQULKR9ko0MnxC?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c3043e-7ef5-43f2-9d53-08db342f1593
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:03.5143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FjQiy/sXGScOiMERLxL6KpAbA22CJ+psrSAYlLyj3YtqVCowkLOzRlDbSsx9h371wCsef6UZfuiNU+ka/5D9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ferenc reports that a combination of poor iproute2 defaults and obscure
cases where the kernel returns -EINVAL make it difficult to understand
what is wrong with this command:

$ ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name veth1
$ tc qdisc add dev veth0 root mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
RTNETLINK answers: Invalid argument

Hopefully with this patch, the cause is clearer:

Error: Device does not support hardware offload.

The kernel was (and still is) rejecting this because iproute2 defaults
to "hw 1" if this command line option is not specified.

Link: https://lore.kernel.org/netdev/ede5e9a2f27bf83bfb86d3e8c4ca7b34093b99e2.camel@inf.elte.hu/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v4: none
v2->v3: change link from patchwork to lore
v1->v2: slightly reword last paragraph of commit message

 net/sched/sch_mqprio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 5a9261c38b95..9ee5a9a9b9e9 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -133,8 +133,11 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	/* If ndo_setup_tc is not present then hardware doesn't support offload
 	 * and we should return an error.
 	 */
-	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
+	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support hardware offload");
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.34.1

