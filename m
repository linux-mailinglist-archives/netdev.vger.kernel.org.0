Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B555236DF
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245621AbiEKPO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245613AbiEKPOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:14:51 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C0510115D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cratwX9Me8B2qbExV1Y2juAwy0X2mG3vfhPt7BHlZ0O5ChMS+iyQQDFD0rjtsKmLkVmThSqzbcZ6VuvVNHiVXHLMy9pcszvMLQZ/FSRVoTMmLXzKnnabsF/wQfB3X0BjTCrcQ9pSD2KNVtkRMLXgNUhEneUvWIrEVM3kYLsAPmseD3XgI6uH7zZGkb8M8ETtg8a2k1DzVd1xyCvAPS9u3vUTdOf1i86Nh8ZRR8GjWqf3/k5i1Ot2D7oo69JFMNO+9DtP7yFdsJeEgLZxiKfA5gbKgsljMc08SsjDe9wHZXCAGXj5V46cJpkbyPCA9IC7vm/gakWFeROhWvBsCsYWcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcM7gA+52dG2r3KgWlgXWIH7EQsnP1zwQczE23m8qA4=;
 b=kb4C73uBOUFZVQT87koF3VF7dPeTtGv4nq7Qs+c4LqUpuLmgj514cc8CfnKpUCaqYd2f8XCbW+9J64Y+8PraBqFS0f/NmqwpNafpowYBf+UNXVl0Hwfr1kYirWxeq+2D6uNms33fhsdWX1n+dbD7zvDvi4n/rAICYQbbVOEtd3J5txkqkuCJboA4qR3e0tCPIuDoASMxEJTK+FHOdytuvPqRtmgH/GZlqIDYzDsUiNv5g5lEEBeblDVq8pWfAlvV6G5YSGSC0p/gAIRM8FhTfFi0moY6Ytgz/w9t6TrMuljSo8OFUyW5TbI/M4dCuCjTlk84/jhO5jKyGHFzGmKwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcM7gA+52dG2r3KgWlgXWIH7EQsnP1zwQczE23m8qA4=;
 b=dUkHKJb97AJURI9FqiWtW0Pz476jVh5I0COaXDyNHUYtqdF2Zn2x5JGTu/r7LLsu3t37Fgaa6JTERLLRchL/J2w+vzIJV2tl2BYsTQaZE3VIp/+Ky5vAP+LuycgWtxQ6LCzMto0ItvSEEb2nuGH0h7a4ETFUYBMgUa5o4FF6u+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2300.eurprd04.prod.outlook.com (2603:10a6:3:29::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 15:14:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 15:14:46 +0000
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
Subject: [PATCH net-next 3/5] net: dsa: tag_brcm: __skb_put_padto() can never fail
Date:   Wed, 11 May 2022 18:14:29 +0300
Message-Id: <20220511151431.780120-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 37e44fd6-e3ea-4c35-e16b-08da3360fc25
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2300:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB2300F9586E365F611508B694E0C89@HE1PR0401MB2300.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t9i5RwEr1ihXGCmpnx5/NUKbDefQalasg8G81b7zC4t22kyJVqzwjakMki1hbypWxtx+bz3Lgi7PDljASq+m5fxwr7h7A8Kcx0wCsE36WkZbIN50SY3qBhbkdOXT7ojyBKizkB9UfAdyR+DZyN3aIxq2Ejbx7Dd9mRn3IIrWxFwCEMjfrCyESv3NVzuwl62qQoRTc8lVMyXWHH3XzP2byRsC1k/V6fx+ankCCSQ7Un6zdWdijWGbEhbbQT3lJxXMxvDv3DvItYanDkRUwPGRMHEkDvGwLutujDmPdCKqT4py9zho45PtEbzJ1gkZF7AoqnVuMOkbDtd6s/RY8kFa9A56Y1hjUZY6wC45PfEYFuv4tsOf0B2nsjISMO910md4RZFxHAgeLPSfjLZlsa30HVTMgmcoOETRLD3cTxO/FMRbnEmjcBYUj+uFRjUULqxFHgJRM2uk5ET+iYmaNcXCXb9SIrccue08vyEbrjShNswVTL9j5VvnasadBUDKxMQmqgkSHdMjzgkDl2xhIqowaccZvbHKeCkdGCC6UQ5tCA84ppjE9uNldO1Hrk1D1lI9h43f1DJnbIuQFn9xcnlDDr6I+xecZlfvv/khUYxUGNHxiGKo9vlyFyhFcOW5NepooiTStFTO+SADB/VpAGbHxBamO98+s5CKW3bJz5awDWJ+oW8/IQBWhsyuzp9byLGlv3j5IduAXRmMUWRRjo4b8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6916009)(26005)(6512007)(316002)(38350700002)(2906002)(54906003)(83380400001)(508600001)(8936002)(8676002)(5660300002)(7416002)(38100700002)(186003)(6486002)(86362001)(2616005)(66556008)(36756003)(1076003)(6506007)(66946007)(6666004)(66476007)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pWW/iqkeCTzA+X75i4eMZWga0WieENABM2rkcElHjF4cIo42z1vSRaFJ5F8Z?=
 =?us-ascii?Q?MFjptGp72dRnchnySG2r+K0uYhomvCFaIUxniehgYVpl07YijKnGxkXvhj0T?=
 =?us-ascii?Q?pjcydtI1ARa0cCWe69ECJ/VAwXNl4JIPqe+WDU2P1ZTK6uGuXvxuJ1o2zshQ?=
 =?us-ascii?Q?LAlqCTOV/42+GRNk4ZxHklrt2f1UJ9tD49UrVdc8wQslWRH5dM1AlQyyz/Rw?=
 =?us-ascii?Q?KYZhSpcmWO4fwoOapLHAqYquBx5hutCm7zMwxH1p/J0SExSIvL4fKSuhvNjA?=
 =?us-ascii?Q?5hCBgSQbobmUYyRInMzRhbKk0gQ6EM4VVrlnl2XIwuhMbKhQjyj6WiVpeYQh?=
 =?us-ascii?Q?C8S+lAdL2o/iN6gQBQLgq8tI5a9yObV6PmilYz+YDIC+5eRqIkjpji72prYt?=
 =?us-ascii?Q?lT8bjcfSprCH1f5iM7Me+/84cgML8/Q5T0f7T6e9GJstsf+2SHpfDjK/k791?=
 =?us-ascii?Q?rxhXlsvVlWUy6dCWqo+eIku17kpeAaXJTxkrjtsB0COY3AaT9ZQ144v4K4C6?=
 =?us-ascii?Q?WFeBRwiaKsBqNTK1narnBo5gpEp7a45uc/Z1DJM+dQL0Powhvzt28qpG7eN5?=
 =?us-ascii?Q?22Vo1FlpxKKSK1u8Ix98tI50udz/hrggro8WmTiTsj1GN6RsdhQdiAJL7doV?=
 =?us-ascii?Q?zpZxMqi7Zrxp20js+04ClcC0dkgPBKG/j/vwTlD84le26ef/X7OXiGTsfIVA?=
 =?us-ascii?Q?Un3ll/DWFHRA/15mq07eR5xoY21X8iNhtAPwENHT6RJ/C0PYJQbnzk5+3Ihx?=
 =?us-ascii?Q?QRtHYvt8JMqR1J7CRZFSeN9NN1jyaeAG/xWCrSBLGjMCXRzPZcMPTC6d9TOs?=
 =?us-ascii?Q?6NF0simubxeDtrPosd8oFl1nWGbGuj5jxWzb/ds4EFEcRWfCu+U9/wSu9F2P?=
 =?us-ascii?Q?lqlTlBcng33EAO9r2Lul+0afIQ3MgvPCGYzd7FxFzMWDlkgT8ZNzg35ghd4m?=
 =?us-ascii?Q?tZK+ORG0XsFuvFPOkkBG6em4moO72eYk74LxV+SKiaWimlP8c/3P/AN7kNxh?=
 =?us-ascii?Q?FXbFNlK/av4+HzTs3q7uxqHY9ocR2xQESBeXxYXnCx+WOAwxXXjdnSEnZwc8?=
 =?us-ascii?Q?HEeUdZG9S8+rJQA0SzQ9BMaY5li4O7nLx0WPVfybt0Jf1+++HUZlq1l6nEyj?=
 =?us-ascii?Q?z0sszWpXhCppPq8uguskVxCE5I0DsCtAwMdCvMJzwwNsZpEYExeCa3AhPpGy?=
 =?us-ascii?Q?3IEnggmMqInnbk9YN8+GK1YLTaePtC2/ycwZdHsJ5WbrD54F061pk4R8PV7B?=
 =?us-ascii?Q?wN1yL5+4vcUy1+hxUN6vCn56kb5joELOXHHg2xKFFUy64fA0Z3mr9F+w15z5?=
 =?us-ascii?Q?TdPp+f48TpattIdIh57XWNjUqwbR6+DPgxVfpK2OB+LFlI/WMlcnM21a29QR?=
 =?us-ascii?Q?gpNKzazbY8PmAyb3goRjNqE8LMDHbv4yUlz5w/hSifMN5N5BcaTUrQQy8fxd?=
 =?us-ascii?Q?bMwitdE7aOdB+OWo3SA/pV00k7PTi0MeGX4CHfkDticlAvjxZc9ZB3DTPdQU?=
 =?us-ascii?Q?qKpeyCh1rozqNQm8lFI6iN5KriLF3uNaSbHyY1x4bQAgwh+k2WmnRZx9cnms?=
 =?us-ascii?Q?ge3x4rCkH7Ft8xt64cCGWDGsKYiWyT/GizqNXB11+c08+A2IgIO0EaG2o2+Z?=
 =?us-ascii?Q?b0ddYBzY9X7vBQOoJMDuDejYVF1n2/030ILjxV+KZbertxqOnSXzFyYv1tD2?=
 =?us-ascii?Q?PYBr8dYeQeTIJwFk8/jaklr9Dhmb/gr8KAEkAmwTWwlgrh4SvLd1I7kIcNIr?=
 =?us-ascii?Q?/x7J6A0YkxQsUM9M+9CZ13YMM3WY3Q0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e44fd6-e3ea-4c35-e16b-08da3360fc25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:14:46.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WB1aCr/vvwJUYiTQ0hpOyZkOzAFeS9j2V2gISrHYQ5oft/8xTvZ4VIDJvP2SqBU7LEM9xd9b9rkwQwDlgKpJeA==
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

One of the purposes of the central dsa_realloc_skb() is to ensure that
the skb has a geometry which does not need to be adjusted by tagging
protocol drivers for most cases. This includes making sure that the skb
is not cloned (otherwise pskb_expand_head() is called).

So there is no reason why __skb_put_padto() is going to return an error,
otherwise it would have returned the error in dsa_realloc_skb().

Use the simple eth_skb_pad() which passes "true" to "free_on_error"
(which does not matter) and save a conditional in the TX data path.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_brcm.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 6cc4c4859a41..c2610d34386d 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -90,11 +90,8 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	 * need to make sure that packets are at least 68 bytes
 	 * (including FCS and tag) because the length verification is done after
 	 * the Broadcom tag is stripped off the ingress packet.
-	 *
-	 * Let dsa_slave_xmit() free the SKB
 	 */
-	if (__skb_put_padto(skb, ETH_ZLEN, false))
-		return NULL;
+	eth_skb_pad(skb);
 
 	skb_push(skb, BRCM_TAG_LEN);
 
@@ -220,11 +217,8 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 	 * need to make sure that packets are at least 70 bytes
 	 * (including FCS and tag) because the length verification is done after
 	 * the Broadcom tag is stripped off the ingress packet.
-	 *
-	 * Let dsa_slave_xmit() free the SKB
 	 */
-	if (__skb_put_padto(skb, ETH_ZLEN, false))
-		return NULL;
+	eth_skb_pad(skb);
 
 	skb_push(skb, BRCM_LEG_TAG_LEN);
 
-- 
2.25.1

