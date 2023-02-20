Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D969CACF
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjBTMYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjBTMYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:19 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A251B561;
        Mon, 20 Feb 2023 04:24:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMRU6TFud0bgpjf06c0sk8P+8EhzTTFuXBXLT2q3CUjubO33Vsn7zlUgdD5+FJ2130HPiWEJ8tK7Cqq0TlufVido1IhRanwOgvk1B7gRhw9GteIE7xycZOGOjN/he7EOAezNxJLR8SwL1e8HKfQPUT6txo2HadbuVASvd1MdCw6LHL/peFTpbsDVvy1gdhdTF3xwwI2a2yHO53bL7WyYgPwMKyc3w2HTGtCDj3V15eEvjd3qfrX3CWbwkU+0Nuu2TGJ8INW7paauHCARW0OKcm4ec/Mj9gDHP135rsXtD0pEKBkPMOK6V6CJHknsd/o4MTVYoReddv7Y7iItHDaKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31NXDItaO3nwoXsGNg/z8WeaQTyKw4MZ3sYySyK7YJY=;
 b=DdOsbi09zm59Ya+pWtQ8FZDdizvyjoBIDJPRFNij8a0JAlgVIB2UKrQFCM0GYvMEysYaqJiCTcVoa3RXmu6JdF1PdpHg8636wvjK8nk8rFVVau7N/LJ6ir/xA+UfUXtss45mfxGfXFnqs2renVo+eWgySMRGbPgrSKbUcZ0pk5bCWyxo7Thv5ZAiyoyfj2D5+4kLWUZsXMpWGGEgqM9TpqEGfiE/Y42um/7DsOsL62i41wZ5SmooVR+yFrc21MCdoITOVBrNAPXVkV7QAv302Yku/BTdgzyTOY81PmejoJ5PLR2kCBDVrxCmDR7IIavD17FLG8U0oV9x87flCTuHSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31NXDItaO3nwoXsGNg/z8WeaQTyKw4MZ3sYySyK7YJY=;
 b=P0fLopy759sySraP5cGzUPshINjIi9ysjPEkdzQhgqckQE+M6nHq/g2OD9zYX9zViBWA/q0s3FgFFoJK//L7MV22/ahJG3Fe3JoCx1ZHxalZRKPjZx0DJ9+QEBE+CB6CAOrTf9mHUaL/o6tiYxD7QMQSmKpzmFr16FCdmtTVORw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:08 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 05/13] net/sched: mqprio: add an extack message to mqprio_parse_opt()
Date:   Mon, 20 Feb 2023 14:23:35 +0200
Message-Id: <20230220122343.1156614-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da9ab75-2b4d-4d38-e7fd-08db133d5d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: do0shaaIuSRe5w56Xh9qa8qV3z4ATv4k/PKjfEMJ3Ud8AI52Gj7YhyhBHeq6cl+acQrDniqH4iHG6Cu3GLuvi9Luai1jC7daUOgDsoHpv9qnA+YMf0bWv7UgEHSA+DIW3nar3kfZKTH+mOk7XufcEJSk8BejXh7h2TLpAlz7DeOCbEmbrqGTFaU0F0EGa/YQ7ZFrp/wiI5LrSONIN9d3+DyDf6aBBRHoqq3rRCtYQEyfYppNdDVYZAqe1CByAb1mjHHU5YeggEIC7C285/oLyuOvWu7+mouqkhq3zybLMi397Bxgad0FSfjuLaG+//kHDRTD/GJJYZ/Rpsb7yM+H3MvLGnPVqCfcmyXwmytWyzRqNcGNjEpvX8UaaygiFQ7Kwf8qnh1oGQ9INjfnmusaGmy3g5AZ7b8FRUWHsgdfhywjpKfHC9tURebzvDkuHONmc36QhxPNogEHFMz2CsipBxXA2PySMJsuXLYO+f9yCIu0EttqxeOu1THG9G1HhrCW/y2ximWfF+WDIfHf7Y8yzhjFOAv/YfwPaww2Maj+NG+sXxA/wBbJkRw90VDXrQUqPmKVMMvbRzvzY+Ntq6BeMVuzQx/xI28I4Jf1HpFs5YMiLpwpkM0SGvVuye4uQNakXVtXH0kM8DA1NgnQsispyDOxt3HkRjVrIHQYehQLgJUksc5xk2rjk0pWXYdW2QWF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(966005)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(15650500001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UyNUkaKSACsoGC4oL0V5uNwT1jzNqaqpLlcGi9hMiPXMNqTYis0IvnIQ2vTh?=
 =?us-ascii?Q?h8KFlGNMLXh1WN6Xs/cAivf+H0Hf6+5QLRd5nDiNDJvf0PouZlHksf+OQl7R?=
 =?us-ascii?Q?fhihJUFtKKvLTssy2PzacuOIJGfvAHFTTb14f1QwYI76mE2pZFvHp9Q9VUwP?=
 =?us-ascii?Q?nNL2YROwqnvKFMkc3brLU8txSFAEOG7+zAvBs1+YWCzhKVm1KIdaqxZR5cAp?=
 =?us-ascii?Q?BfyVD2YtiEU3UnHwX6fxXDgg7mzNsDTcIQm8eSs4xVhNSSoe1PSHCx9bMZBx?=
 =?us-ascii?Q?ggo1rgLl2SPM/ggtTdgq10AUHAhFM19vFIVahcoV46wWxbbES4TDhrc8Kf28?=
 =?us-ascii?Q?HAbM8Ru2xPpJLIhJ1M3iZZr3fT5rwFIlrrFWQo8u+IQoiiJMp4Idn7IS1L1W?=
 =?us-ascii?Q?vcg3wM9fN62V2AIlWD4HYD7rPGui0eCpXlQYXfAeJx0dCYbTuMhwTHnuQ6W1?=
 =?us-ascii?Q?yLAlogQfkhEN4/o4pKCiy12eJiproRbKf18BR0gsZAJ4x/tqd8OmgoMvUdwq?=
 =?us-ascii?Q?11RHLZpemHO8j2oFabLd42H23fcbf8C9xPYyg5n3ICCUaIYgmmBAeP33GLsj?=
 =?us-ascii?Q?rK/ye9Rl5a6s3v5DDUY65ZDNqW2cOpTuxkLac68WepfBkhuVsvX6KLCUVDak?=
 =?us-ascii?Q?jFxilrhwPrbvoSQjmlYrxyIU3cYSkCbdiGXvGCRlQ6NgM714HP7RbwTxq+vq?=
 =?us-ascii?Q?3hWwEmPjHM1H5HXb9Sd3jqS3rnIAMrlL/SABg+2wth4fWQ2vdzR0dM3ufQP8?=
 =?us-ascii?Q?lxPIi0B9rby/I12UDALyf6oFCy3GQPZlZWsIiX3H+YnwLPuvBW9pFeWpcT85?=
 =?us-ascii?Q?OKx+mTkplzIE314eLAHpA0kI8GoVH5mGpfv2QiWIE7OErn/EFJ2xqti9FlVx?=
 =?us-ascii?Q?Egm4d8oZtxFmiC6EYPBWv8Rif9awgC23B/a+R8fuxv4KLXGLmmVRCdP152R6?=
 =?us-ascii?Q?12s//76w2xqT2Xy5lUzRhLLtUvFlE2hNUMZxRidI0prCjfkskUb8JJOLcUUD?=
 =?us-ascii?Q?qLbfV2aMOB6spKeuxq4vf9pMEfhPBHekpP0V1ribC7JMuQ1/V7CGnwdPD1QY?=
 =?us-ascii?Q?VM1jRpkGsc3V5paGu741eBoqYhy8FlxoFUKyosGQl5nRqQGAolbYLmN6Jnw6?=
 =?us-ascii?Q?ULQpu2GEljOWjSxx5MOVFzPvkeX61nc8sBOB7/lRt8zskMYD16QB2Xol9Ztb?=
 =?us-ascii?Q?diDkNMbE4nCo//Oc+XvCEvJY2P7vCWXqUkeDszsRzwmoEdPyyMJWenYG1ORo?=
 =?us-ascii?Q?bk9uRu53bSp5G/BHTXcMYfEn9GQA+j7ZK53yEw0pdJGq5/V4SoUGI36uSQl9?=
 =?us-ascii?Q?+EoVNVhDpY+DwnuMipKxR5DC7py7aRMBRChd0i9hL/U0Qc1wFgERGLsMeG2y?=
 =?us-ascii?Q?XF8lUhdpyr4l9cncaYdv+CojhUiGbgBNk22YCzTOhqr0qUuItnIlufLe5kIn?=
 =?us-ascii?Q?RM3Lh36mh3f5ksjM67CEA9+CwyvAry0s8sfp6qcHxaMhkdfC+IlbI4D+m3B4?=
 =?us-ascii?Q?40x++Venyy/Fi8FBndDVq5ql97l1Db920sbuznC9e2RqUL4VuL3T0aZBJe7Y?=
 =?us-ascii?Q?Lm+PXbzYmymOPArYM0UG2g1Si44DwhVaJUjHgW/Tr9gSpa6y3Aa2c61YY/HQ?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da9ab75-2b4d-4d38-e7fd-08db133d5d04
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:07.9779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzFSeRmAZmZjIgFo33uylsdC8dJ689bdJIgfwo3PYE0750qJYoZcNzpYoJ1n+XXT6+pYuapMHE4J42sAWAkyIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
---
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

