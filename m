Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E835F6E9F83
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbjDTW4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjDTW4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:24 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2070.outbound.protection.outlook.com [40.107.14.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA0565B4;
        Thu, 20 Apr 2023 15:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFffYDlBdZ3W6Mqig6FnVv+xkQq6erOa8YioNZ0ZQRbD/aOxmSAWHUQWqkobow15gOynQFjYf3lsJGsOmPlbnGxesqvT/SfW+gfG5NPiM1f/V/Qu4R3P0ZRki0mJvzUbhuqTw5pzIeRb/5ig++ej9H+S+nmv+vobxmmzOAcU+/vj8uylCfBJmYyFXbl65SL/yFuUc5y1TAM2jrjDytShI0ShofpKwtfICgPs6gqTbjE5a/t2HxtzABtqTKC14F1bqYEkdwtpwRWK87oLl7Ct4lG6OwpdjWN/kcai3SuTX5elZQomLE27PI9x4i4pKp24FnGkcT9sZuvRqXIkQQaYIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTdiTvuz0snlaQP1usAosQoB9AJsPhW1MxetII5AmaE=;
 b=Q6aBkjAjYav3uDS9cxRGtZI0iNpZTo5L1BZdQK4/c0dNjKl9hzvvdVOHt5HGzCnU/iE98t/mpV1H6US7DCZEujjqQHrt96Tf784OU/ByuoexDmnYZavNOb20Y+/TXpuoEjh1zxfY0lLccMzwBs7mtUNL3nIJQrzkfLF2YXPCW+KePafdfNeKOsV6raLPsqUn06JZj1Ek7GXhMxFGHH3MO5QR4RqkpZ8tGeMvanLiCcbiyJrpXVIv4tcPizi9OhlDP0wRkP/2rCysvBfRwJkaUgsYggjnKuNMUF6QGav0qi5hYDpSclCPJhDI4xUhz6+mttC+MBTWattfCQaxvQz7lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTdiTvuz0snlaQP1usAosQoB9AJsPhW1MxetII5AmaE=;
 b=cfZPoWOKIJQ+Ze3zS0to24N5q3bhXIUILyQveFwyF/kUiruFd2F8YgLdhdnxVqnyF6Fu+7gr74JVUVqJBXRxDjsMoRxvMBrHSRnK8Vb+XODZ7YN8qMAirQIpBOdcZOS1NKnmldKX3ltoktX2BEfVTMiT4LBsHjajgYjWJoj7NhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:18 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 8/9] net: dsa: update TX path comments to not mention skb_mac_header()
Date:   Fri, 21 Apr 2023 01:56:00 +0300
Message-Id: <20230420225601.2358327-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d84bc5a-434e-40ec-64ef-08db41f27394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FpvKihcL2MamMB15mQxJIOMt45rv4rpliKQgoSChuDA+YXvsBitL9azt3hboQbTAOeyuyRv4z2gcqspNKseTw39VIIN4W0451kNdNiLvtoZ0nPgSPkQ3FqbJQt45MihDL6cSiiahej6Egk01biqvl5l69ZsjVU/cPsyiPw9szXyYNNkQx04tgncxHsD7eIkhNCHISYKwRWSvRbgYJA9tSnyGOI/ZNCuj/8XWxy2eSCBzdWDq2XDmyEV0t0jAwXXLvCRU+d8XrMQQWO9IZXKob3wZzna4Z/ZeDZiQ/avaKDnft08xS+2PK1CfBMAhIIPavtx2NtwBlXEinsXxsbuDdLt9P5hAQtz8oeETag7QilliMGF1iit9LtSgmOJUBn44Ywnb8VWxImrF/1pBEw4ZMT6+zmqljgPsszReo4FcyDYPskAYHyaKrwGSH6EVY11GGcIlmQQIM9WtC1k3kzAkE4L4u2g3GJPS2IJ5vk1hfb3Dz4KApix7hEBtGKqNlSN0IaqztktaF88W6exx3DyXuyULALsypV3VV59D6EHXfvAfAUV0eJyF1MCUVig+2Dz0PMnKcxViO7rYqOW/z1K1fSxt59C3BWjIqLgmlMX1xiJQHqfpTX6tV5Fjm0sPW9/I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SZTZSWwyDdAkjVCi9/xU31IjVLRLChxWyzehlkAu+GKBlIL/7FnVhNxlnsjc?=
 =?us-ascii?Q?IRCKi13naCbvyeLpv5YLCn7LVnwfRuK4YtdYXTBMyw+sY+xuOzXuAeqS//rJ?=
 =?us-ascii?Q?OVyILsyGjCcmftLuFZH94Q8qWqIQ9xwH2ceXWoQ6RZ8d0UIumw/sxtVmD48M?=
 =?us-ascii?Q?dVpX1xU4kPpex5uPGz1sTvNrDZDDKESJQb/daN2+FG2TaNM3kjBehBkdPur5?=
 =?us-ascii?Q?MojuvY8U4Dvagx1mhJIxSKpAh2dOHOAVxqqLObltuqOPHQ4hDVL6fgvMgP47?=
 =?us-ascii?Q?hYpHSAJgbldRPBKdY65yE8RF4EOu2YALBHYfZtKOk+1OkTgdCTJ3WaLhNzG2?=
 =?us-ascii?Q?ZViyxbZ9bvNNvC0x40XU3isjyhduFQR6SyCD07yJJ5BuleIqtTepLIp3wGW1?=
 =?us-ascii?Q?sCynww4JbfUDerAocvwvGVtnIha84zpGTTXB3FzGuZCqM7yQ5oOT5LCxsH5a?=
 =?us-ascii?Q?Lx205kOBh8Zc+BHotJJ9L9EEuCYayJCKMpXdsiayS+GF/Q2+ZOF0S/6Cqagw?=
 =?us-ascii?Q?bdlE1luJ3F6ZNS4OpryzR3PTjQ0gnSsa2SVVVkHK2ZGgeOsd59bMRIxA2thy?=
 =?us-ascii?Q?q5xDDGowF+zh6TKBB5v5MFzGum4VW3h3XKblebb1GXfVtpSV7tmO+BsomC/t?=
 =?us-ascii?Q?vEr97nmi7ApKla0OXLqhRl0kiOkOkQGCPP61vFQAPzIAVS+IQeBoExyYwIt4?=
 =?us-ascii?Q?nxJhkRTGEbKOjDiD5KR2otHCQAtaLZlMN/2fKctAPnvIheLu4qNStRwFO1QV?=
 =?us-ascii?Q?w2jp8eIKi9oXKBOKlzRVB8kXgn8VeRV5KIR4pRKSdca6DE3UxnhiXgkR9Xis?=
 =?us-ascii?Q?P4NNHfBe1aEt0TSBVIeKgMHWn9BO3CqW5g9tnOks9+aMzvD6o7So9ge8tBI1?=
 =?us-ascii?Q?4x6oPUvOxVayo47r3m5Dwc7voRi026bCHwNfSI5ENUJmvsu+iutMa26doDjW?=
 =?us-ascii?Q?LjT57ExA+gyilKL+YbG0ETapf30iXyduLZqz6hiXfkzWPGGjDsjvbVanRH15?=
 =?us-ascii?Q?vENbLSRmdlLJJfEsHxzlcNA8Q7DLdBMej0A7U/bPx+p4rfDLmJIe7ceLsGZV?=
 =?us-ascii?Q?h6/UgoEY72Rk/VIcNJWKn0nbFf2i09dpSDybzUOnqrFWEJyF16FOrvnlenPc?=
 =?us-ascii?Q?kgm8LlRyNUZpd4SH76dLu6XqxDXnFJRDlB6ZeJp6EosLby1St2LX7LjXA1Vx?=
 =?us-ascii?Q?TySsmrXVGuWe77nRwpB2y1SzrVm1UpcbD6z/uhS6M7YgRskboguLkGbsZSH9?=
 =?us-ascii?Q?+gjGdmdbot4NVCeWRhsecSeTtreYDlZAVjV3rYjA/K/g8+KiBKWu8V5hm31J?=
 =?us-ascii?Q?oQyS+uOvXFRNiiZl1V0p9GtqL6ZOTjvYPWugaGT/8MfNS4/G+y/wgSpQfw50?=
 =?us-ascii?Q?5fOTYV9nM8/fGUjPsWzEKDfOuG7o2/1f+GEQlFBgfDtmisWrwdE+q75C3fJ+?=
 =?us-ascii?Q?Pp6n4PTkkGbwhRllw+sF8R9RDM1FQHqMQ+T4pRkZazw2j8ORc1v1Y9rrW3C5?=
 =?us-ascii?Q?DQpjzgio8Cm8aksb8IuDXM2+KF6mXG/KByrFcbJmgsoWijty/bOuNZr9BB7t?=
 =?us-ascii?Q?r6KBeDvcsIs/CE0kx96rpLB7haciyK74TDtH64fMhNlPrR8k0UxzOAD6VMMg?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d84bc5a-434e-40ec-64ef-08db41f27394
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:18.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nDD3ILeRjeJydKjQLfnLTTyf2yKXlYzIo4L+pCDjzRbvPD08JM7WEm3GQYAZ3zbuTW0oC1gmwgCHM+o08Bcrmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once commit 6d1ccff62780 ("net: reset mac header in dev_start_xmit()")
will be reverted, it will no longer be true that skb->data points at
skb_mac_header(skb) - since the skb->mac_header will not be set - so
stop saying that, and just say that it points to the MAC header.

I've reviewed vlan_insert_tag() and it does not *actually* depend on
skb_mac_header(), so reword that to avoid the confusion.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag.h       | 2 +-
 net/dsa/tag_8021q.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag.h b/net/dsa/tag.h
index 7cfbca824f1c..32d12f4a9d73 100644
--- a/net/dsa/tag.h
+++ b/net/dsa/tag.h
@@ -229,7 +229,7 @@ static inline void *dsa_etype_header_pos_rx(struct sk_buff *skb)
 	return skb->data - 2;
 }
 
-/* On TX, skb->data points to skb_mac_header(skb), which means that EtherType
+/* On TX, skb->data points to the MAC header, which means that EtherType
  * header taggers start exactly where the EtherType is (the EtherType is
  * treated as part of the DSA header).
  */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 5ee9ef00954e..cbdfc392f7e0 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -461,8 +461,8 @@ EXPORT_SYMBOL_GPL(dsa_tag_8021q_unregister);
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci)
 {
-	/* skb->data points at skb_mac_header, which
-	 * is fine for vlan_insert_tag.
+	/* skb->data points at the MAC header, which is fine
+	 * for vlan_insert_tag().
 	 */
 	return vlan_insert_tag(skb, htons(tpid), tci);
 }
-- 
2.34.1

