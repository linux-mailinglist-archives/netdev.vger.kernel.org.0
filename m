Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290345236DE
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiEKPPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245614AbiEKPOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:14:52 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD99209B57
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:14:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9vMfvchyGPOCRH4EQyR0EBGljqBYCX9QjsLMGPkk5tdBdjb1BVG52NB76S5MMZTdzYYvB+cjxdEtC1gnpivFPO4X2vhFybjb2vTXFrJScroySq+5QoT6lEqn3sMyZfW6balMiPWNcpfif2B7es9VANPQomenArPdpe9m6arra4AVB6z0tumFm80kq+f37OeQtKYx7oaFkwz85PTYnQ7OXX1uRjvqyIX8d+quA3sZoYt1+kCn8DoHaosF8C736zAODUBpdawPV+3bqpBaTf8r4sc2eGBi5Ul2o/AdOhXwKmknp79GSol3hbJqi13+rRmhTsM6IP205Eg0Yr7IKLuZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CyhmlzF49aeRJvjLO1c8pnet5aWtCM6PigH31D7qJ4=;
 b=FxyWJQWWuPKrkBUUZr2vL1Ifu/h00O2eMPKQyfyfC6LC+Xf34tLYPEc6qhsXMMDmhL6kEwF/lBEqYc/fnMzvAnL0Qb9mhAQNfUZMfCkDf/gVf0LGGqB9ldJqJsM+N78it3G+wBksV7lVPzfQbb9j+LlZiTgmkfqqSH7bHVN4Hv3HYcLDsCyosUYebG2LKcw9p334LsNGM1b+5477c3u0HJaDJUd1QnK8RKl23tH7TO0WuYg4niXV3uoA6EDDvW8Ry8TnWG7f7YUzTFewixnN4WMQ1jZ/pTwEfCXrl3AXhhxhYrVsSrnsSyGtfipfbGOfH69GnXfDVN+DQJh5L0rySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CyhmlzF49aeRJvjLO1c8pnet5aWtCM6PigH31D7qJ4=;
 b=W4XOTC6qaRwgYw+k9S3ulStGCIhrRa2fThrqVcK/VPJ0bvLxGpWQxCrN7ta5ynUSkb88y3z2L517UGfe427d4E6fkK2GXAlrZFiQSZr+yle9CenU0VDKKUx1QplKx5wJwD2Enb4WBz3XAiu+KVjqpI/iP+jmLdODHmmHuzAYTdk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2300.eurprd04.prod.outlook.com (2603:10a6:3:29::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 15:14:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 15:14:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/5] net: dsa: tag_brcm: eliminate conditional based on offset from brcm_tag_xmit_ll
Date:   Wed, 11 May 2022 18:14:30 +0300
Message-Id: <20220511151431.780120-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511151431.780120-1-vladimir.oltean@nxp.com>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48b64323-a288-4ade-9a2d-08da3360fce4
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2300:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB23004C3DE8ED6FF0E1734336E0C89@HE1PR0401MB2300.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5UhQL5DkpUOme+sHn/QP49WtMfA1c7JTB7RhoDkgiZ03+fJqT2eA/LmnjQ8mMcjA4QHUgrZYiC0YuTRuNXMDD2I1EdneOSq1RjRf7V0BVQrfPDhEWALKO0dFIfjWHGx7dOfUw3z+61sGHoQGNQ2LE5N1jFpyHt1NdwDX+ixoDKAHb1KmhtBsqOT58v/91R0kldz5PypWgcRNczdC1PqVrwWBd0XvJRqTzMjmQ6KZRt3atQJkgc3AmPQuT8Zn/RKXOV1ObYj6JCDtzskdNYcPRspP3IxXfszQzgSeWu2Y5zED4OhH2esreJHPBXQlTTykz9DyXqQyP17+DarAXaEYOGFxP18dZLjO/XXGNWRrSNueggkjlWMdlzPh7TFzJiAhbAUVj10vlwnbeMWsuhhIu/G4QQ7kMzAQWCAJsvyadhUwyefQfyqm5uOjsHdm00mdaaFhj9ReaaIslU1AKKXRQodBQelAHdtuWPkhc6Zbj0a5sgBOCgqlt4r59cQUZZ6ytBTRI+FZ8XaRo4bGOeYMQXhkuFmRLKZTNc14/zzkgjevh0xIFkimehq1WTfUMs6zQJD5x8wJeakQ6xwvgeXF0LyRT22GooRUvgiKIZlmE1kJlXG8bSYfhbPB0YT//j0F9aBHHxnY2QJ1ksygz+HQ88r0P64L6y6tjudauCzKJLGlO1tIqwCXaJtZt507O6/4NMEw8UrfOITYI1aq/bd8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6916009)(26005)(6512007)(316002)(38350700002)(2906002)(54906003)(83380400001)(508600001)(8936002)(8676002)(5660300002)(7416002)(38100700002)(186003)(6486002)(86362001)(2616005)(66556008)(36756003)(1076003)(6506007)(66946007)(6666004)(66476007)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c72sxfuu/8xxPdhE0rw0mZHlKuRrQbRIIsDA16XuLo3LwRD3RtxFWsar+LNK?=
 =?us-ascii?Q?8uyo4n9ewu2+yqhIlroQQYkADmfbRoSQDGB7M+tVfW8naa/98pa7EmB5J3fv?=
 =?us-ascii?Q?i5ixIaSupZzqaqnZjgtWVqiu0ziXBqAVtQrdQSFaffPXKfid0Ypyy2PUSES2?=
 =?us-ascii?Q?C656glZ9hE67Rh69q6lplclrIEyW5nNLm1p96F+cws0u2bomFKSq6lBmkFEI?=
 =?us-ascii?Q?JaYni35j5GJ7GewT3Fbzc3FJ56tF7CkUJT/sFiFvThLO5n6ZcOa6iGgQGTaB?=
 =?us-ascii?Q?UvmZM9Doc23z59c4SVc1hI600996T/GgLTpOlNPJGgwj2mvHEi23TGP6EadY?=
 =?us-ascii?Q?zKwmZ4gt34gd0TIc74m1TWA3PxpeJRNVZW02S/IXwi8kH82z+fTISaYzZkrI?=
 =?us-ascii?Q?oiXVYsA/osNKZEBW3Pve8oG/cOAYv77Vs3SkZV/POzfNlcmO06wAs2WJtX3F?=
 =?us-ascii?Q?nu8UFy0Xeuk1nEWmKAgrpLPPIgi8vFTZpCh4ITr5CzI54im0XnfJ1uIsuNbV?=
 =?us-ascii?Q?W+WnhOM03pYTPHUKnCjboTq6PDGrxiceMBzGbiWhOOEd2pY/YzJxAU0t6xJJ?=
 =?us-ascii?Q?KJMNg2YY4C9nQZQn2GNB0XuozZDsbMpBGmqIyJw1EPeH0AzWbcfuR3NwPxCz?=
 =?us-ascii?Q?+5P/M+Kn+aEoxEe/jqqQd8yZI2AH9N4LosKyJaMTMpZOYIL4cE97P6KTFp0J?=
 =?us-ascii?Q?eQaopxHm13mdZd8RcyNmvG7B9eE5/nfnEXEnz3rIhRY/mRTcOc4BrCBecw8k?=
 =?us-ascii?Q?OI1bsHcfo1qwKFlyj6yNshNkVppPD4wuiVr8M+i1JdUl611tf9lOIYo/u07f?=
 =?us-ascii?Q?r9v2aOrP9g3Nim7cAM+w5k6knkOqC9gh4sHChuyzZgrKI+klrsENs3PJX2pJ?=
 =?us-ascii?Q?/qkHKzEJAThdBAfZicUp9SieGmoT3cAJwmTnTR8mD2LCINlAvqZyKmHMeXmO?=
 =?us-ascii?Q?bpKEmxmwlontxdahvFamdvISnfRWuMNVoa5TzDMWZEPZD9J4Cfm5K8Fbw1TC?=
 =?us-ascii?Q?hD/RD2EKWWr+t/HLVf6sQYedtmDDiLk/oqwRGdYAHJs6k/qDtQa4MjVQbKWw?=
 =?us-ascii?Q?+CmwsnpHqbP1ziDuYkXx8dXOGCUuqh5j/NgXIhyJT9CRFU/YeMLpoN2kOf0X?=
 =?us-ascii?Q?K9VsPSC1QNTA4WK+XnclSGaBl0CAjGFYd/oK90D5zgXWvmDdBAB+fvy2vFlb?=
 =?us-ascii?Q?1DtXIcscpez+tCVeQqzp4ESwsaiPZ6WIQa6MkwYJD+gZcDGTyrCwaiB9L6qb?=
 =?us-ascii?Q?+cZ+AMDSnNI/r7FD7t0az9CHYZHbl2nmhncy5AIFI/Z1eqDg9O+cD/kc3lvh?=
 =?us-ascii?Q?d2KvxeoydA2vOAdp07wYQuRT++l5y2J6hKfgHIOvFz60XgGvWzdsl93KM0Ys?=
 =?us-ascii?Q?v3SsmL+K5uUPd30jONkw2tvfTLDaMK5mPVOL4vEQJ8n2HhjAsopMils3SgCt?=
 =?us-ascii?Q?wKk6IL4f8F+kM2OWDWCPfBUeP8dvlkNBCu8UrMaju3lqwLAGu0uc4Ql5e8I2?=
 =?us-ascii?Q?XhMGvZJuYxKZ/lubSCGWRJGCF4QQIpMBT9I99i8oRcb89vzRSqDs+8idxNFV?=
 =?us-ascii?Q?uhkXkP3BpGXrvFykQOCCE9AHtzRQN4CI6RYuI48wPZo8hX4FMXLBusaOuF+Y?=
 =?us-ascii?Q?okY2etkic+YHu0tAoRA8W6+IruEqz/UJraKO3OnbsrNz/JCIeG9icfE9p5ZU?=
 =?us-ascii?Q?ExbCnQ7GzOV6CGzYgN2ACD44jHPypOK0wJcBFPQ4Y/y2WUDWyPCD3TbS/sV6?=
 =?us-ascii?Q?S1OAUDlhlzBdSogXsMSoPkRPt8Ga8Ac=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b64323-a288-4ade-9a2d-08da3360fce4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:14:48.0625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0B+1/QzIGmT9C4st9Z9xqxnC7hDr9gfgt+uIpe6tVoBWoDrTMtkHCkkqpeAO7VlKNh/6sY327hQn2jFGECNBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2300
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the low-level, common tag insertion procedure by handling the
differences between prepended headers and Ethertype headers outside it.
With this, the prepended header no longer has the check whether to call
dsa_alloc_etype_header() in its code path.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_brcm.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index c2610d34386d..ac9cfd418948 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -78,27 +78,10 @@
 
 static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 					struct net_device *dev,
-					unsigned int offset)
+					u8 *brcm_tag)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u16 queue = skb_get_queue_mapping(skb);
-	u8 *brcm_tag;
-
-	/* The Ethernet switch we are interfaced with needs packets to be at
-	 * least 64 bytes (including FCS) otherwise they will be discarded when
-	 * they enter the switch port logic. When Broadcom tags are enabled, we
-	 * need to make sure that packets are at least 68 bytes
-	 * (including FCS and tag) because the length verification is done after
-	 * the Broadcom tag is stripped off the ingress packet.
-	 */
-	eth_skb_pad(skb);
-
-	skb_push(skb, BRCM_TAG_LEN);
-
-	if (offset)
-		dsa_alloc_etype_header(skb, BRCM_TAG_LEN);
-
-	brcm_tag = skb->data + offset;
 
 	/* Set the ingress opcode, traffic class, tag enforcment is
 	 * deprecated
@@ -173,10 +156,21 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 static struct sk_buff *brcm_tag_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
+	/* The Ethernet switch we are interfaced with needs packets to be at
+	 * least 64 bytes (including FCS) otherwise they will be discarded when
+	 * they enter the switch port logic. When Broadcom tags are enabled, we
+	 * need to make sure that packets are at least 68 bytes
+	 * (including FCS and tag) because the length verification is done after
+	 * the Broadcom tag is stripped off the ingress packet.
+	 */
+	eth_skb_pad(skb);
+
 	/* Build the tag after the MAC Source Address */
-	return brcm_tag_xmit_ll(skb, dev, 2 * ETH_ALEN);
-}
+	skb_push(skb, BRCM_TAG_LEN);
+	dsa_alloc_etype_header(skb, BRCM_TAG_LEN);
 
+	return brcm_tag_xmit_ll(skb, dev, dsa_etype_header_pos_tx(skb));
+}
 
 static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
@@ -282,8 +276,13 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY);
 static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
 					     struct net_device *dev)
 {
+	/* See the padding comment in brcm_tag_xmit() */
+	eth_skb_pad(skb);
+
 	/* tag is prepended to the packet */
-	return brcm_tag_xmit_ll(skb, dev, 0);
+	skb_push(skb, BRCM_TAG_LEN);
+
+	return brcm_tag_xmit_ll(skb, dev, skb->data);
 }
 
 static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
-- 
2.25.1

