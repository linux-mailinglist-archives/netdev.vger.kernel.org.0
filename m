Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546CC6C5A9B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjCVXjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCVXjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:39:03 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07FB23C62;
        Wed, 22 Mar 2023 16:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwECd/mQ6ZxHUEfOoZoteViGMTexK55XKZ1vE7szQcw+MQ0uNUUIpM+t+Z6epmQVPXF4D9wnGUX2gPTN/iMW4X62WOAAvxfXYzQrA3k2ohRJmhJo/JdBDb6ikS0i2BI90pGX41HmVqIxJGEXWn8olcSZ6M+RfUhIQU+1LChVD0TJeOJGHMJnd/l6mTm0+5t0Ze0NMdoXLPD/xaYLveEzTQEz9KJWoXADCB1ffiyxmOy9mEBMYGbApzOPXQx4zqEcV1ssVfJPZa82vMHPqlP9/tEUhLvkDY5q2F+LajgzIEESp+7KvCex4sq16w9MdyiY3uN93UqwtkH57ULgoxCJww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQE2kybcbqrG5D6kCM7Z69pPnojlGGpYVdWU0BqhWM0=;
 b=Kd75PCnJS1oj7yZN7xDE/sHjUipXRgqu+m4thCQ8CSaAeyjnNKrEYuqaEvfkLywhBOUTgg04wGhGbr/g0qyw6NkUcZKD3zg0SvVQi/PXiZHfV4kfmIvLIDxLpbY4iSUtmCh0fG+iqG7M04CeYsbZV60RmiRzNZoCRG+nIexnOy+g5Tn+Sypntq2EjHgfxFxGC9ye5TIW6Rf5p2ItB5GspRx06qaNz70OnGOqgfdKYtZhGsa9zj7Uz+7BHGzxqMiD7oaN7y9PUgnz1RD1B5zcVjDFb+2IvneWRH++durTz+BnlQhB7wn2+5qCIHc3WHXFAwbIY5MsdNaCeXy6c8kmPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQE2kybcbqrG5D6kCM7Z69pPnojlGGpYVdWU0BqhWM0=;
 b=BiQBbXuuS/fJ/Jgwfk92w16AXjO0Ff8lZ5oNjnBQ/BZ2zVbzrDlaJZUxGez+u1KNsu3X2x6tzWLYizYEu9TL2nMVsFuLRDSgNnfI7wPCZGQpvDkUmizxBV/0pfYJqAEvj+F8E4ybuMn7hRM+6g/Zk7M6P8G53V+m65UtbR++BN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:42 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/9] net: dsa: update TX path comments to not mention skb_mac_header()
Date:   Thu, 23 Mar 2023 01:38:22 +0200
Message-Id: <20230322233823.1806736-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: ae95d9de-be40-40ac-0ef3-08db2b2e91e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bFeyIRg59CRu5mmV3QbGXn2r1vzuW2qE7CncrIrX83zz7b7JAEzu2SiqgJDJdjWuNy17U+CoKWuxtVRQ7roi2E+Xwh3it+jLhteEsqyPJg+2/IprGaWLT+WKH6rY8f6bealBF2sI76oV1Pv8yaoKE5UPghWrIkMi6Hm1PM48sa3O/HGDkO3xtg6LyzZ0DiYXMGskRAnTMZHyvM83LR/w2682kHzokiGyzMdkJtzONVgL2ymYfzfCQoP2C3Ed8uAG+Mx7weyUnTj6X8JSrlR9D52A90LZW3hgJLtlywonltW6JucPQZMU1WT8Cga1brkMHq577fkQaMmzHPfekYFl9EsDNGCmeHdNiqG0VN6aYtkViwwuwp7IWP6+067F0m2oyj3VlaMKU0c96Nf3LGF9kH7NARxGuGU86duXXbi1E+oHB0i4kYKN4ElRpGDmEFGP6Y6lhTDNdqok04q0PJYCMYVo/2pUIMcnKbW24GYzogFbkS/fymdmk5VYq1M0cnUHlL1LfOzBkOrQMPhpSdOXEW0TMzviTnyTa9UqhOaVjpnWBYzDt6Ql8IZZF7/RWseinbe4KXoq6aTfqXWBnnuIObFjb3FI/aovrdOh9Qhb5Gs7w7dxJEFYHXQze6wSI98DeMHvLQv/dHSTZDJbKC2oCihjy6lpwH4b1ipRjkvitlXDnhHgatGfO2WtaSqfG0lZfdd1KlmdQOKsgSoJTaLKDOKh0YBeGJkquwv0/xwfIkBFNMFT8udfugNARnfjmnm/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7XIwkc63rmRZcMdIhMoDMPYmSodKViKJCVeYzIjP23kLDSt6HpUStzAkg8Uq?=
 =?us-ascii?Q?URms3E7ncHs2pTI/sxIAF2Mdt0WOEBL7mPo3ooguUpzPSuLyQ0B9yAVWiMkN?=
 =?us-ascii?Q?hAZPh/KgasrqtZ5eusFLw3c8K4qecNCY5KT/nsdhbpsWE21vLmD4epjqH7GS?=
 =?us-ascii?Q?+MRAphSYeomFXo5TM3X5Mudv23+sm0LgUHPvsrVjsaM27jHCNTrHOSgf/nOK?=
 =?us-ascii?Q?n+l8ujRwa7k3PtLP5RKoOne8VFL1IA9TxoGmM/w1Q6mUM7zBSKAv7FQxN17G?=
 =?us-ascii?Q?CxB01UceTTj8y3l4fcFOHT6j7K/thp0a+YLT9/guKVfPHABjN4rgShhrtPDg?=
 =?us-ascii?Q?o5hO2tARffjaRDbZyJmUC7dKxr4LJo0drNSrdIz+zJmoBn1gmfQY7jWBc0xc?=
 =?us-ascii?Q?04Hjfpq3iD9Hi7nb8ltVepuIektO72ae3LHg8asaNyPgs/vCL24/MAXaKv57?=
 =?us-ascii?Q?Mv9b1sc3n7G3/muuhyJWIVT4YQtImCnnnyb7icwoMH2hf5vD9iJtyaFLm9cJ?=
 =?us-ascii?Q?uujK5pkc4hVLTVU1f72GQG6The5bJ7A36p4TgAR0eCein3VPcLlXiFp+dFt8?=
 =?us-ascii?Q?1UtZhsHVuDPn8tMXl6wq5LaAMkmpH5qVB//slA3VUDh2Myd0+SnjRZXB+9nL?=
 =?us-ascii?Q?qIp7E1PNSIbrb/CmBDK6lmF8RYEWftotbQ/GB2OxhJDrJBus3BeLPrmkr7wU?=
 =?us-ascii?Q?Do3j5hZ6/apTpOKa5fpGoYWQ1PX5RMDtggO9zWCTaMf84LK4bqOViiN69Lvk?=
 =?us-ascii?Q?he7W3QNDVfk0XKFkYP8GaD3UK+9X/KvK+ZrqVyew7QEhsGYuHLYkdBbCLH+b?=
 =?us-ascii?Q?H6ZHR9a8h1wXwsAaJI0VrQ7j1h0/drLY/XtjSkeE+x0srmuCr882AGK4M4yi?=
 =?us-ascii?Q?2NfRuJRs2TZ4hJizLsGejW0t7h4m3uzVCIPem4cvO9hg4lM+begSiX0mBZX3?=
 =?us-ascii?Q?NsOzRcZ19uV+lCs7o3xPi0USvHTcHtl6KjmXAkDapAMNfPAeRtqLI3If64l2?=
 =?us-ascii?Q?V7c+H3r5yCb//1Ql4qUzdUC4PpRPkgfR5AAobRvSzxQ50sMDMWTx2g39y119?=
 =?us-ascii?Q?lJydGq4tNXikrvu24eGjPKFRV/LZkvDsvOphmRSPxapG6GUlxzuiQFGCawdc?=
 =?us-ascii?Q?VIiCVIm0MdgRacBXvj+5XEy97gRKzDqZhi1rwgG1SH2GbVElZnwD/3dcEjUY?=
 =?us-ascii?Q?O1ehvjxMotsRAW+u9d0p6Y1DjlZNWuDvYXcoimt2OncQUqedQG6KJeLxoUS7?=
 =?us-ascii?Q?ZCdkOeWV5Ev2qAdyJKsfQqgxY6i9bazao83li6WQ7eugvN2filheFxy2nUhU?=
 =?us-ascii?Q?W9oZGifWwNI0Y70L+muTJcEf55m6Rj9mhpLF4krvxijU4HPk8EP4Ex4YTAPM?=
 =?us-ascii?Q?mI+kz14Dz7Q8KsVOPAZu5WH4LnRezfNUPi7wB2YTTt28wDXRYxn5Jt5sRVkc?=
 =?us-ascii?Q?4M45YAlujpzNW2Ozsl6eAUWZolTn0xwKWJxaYoD6wEuPZfQnNIBylNXoQipD?=
 =?us-ascii?Q?+8PL79s33zPj/mRRk9y3QVTtmnRG4BxQAmgeFc994RP6kkm4MHS6LotJ81QK?=
 =?us-ascii?Q?XAjJyNI09NU+aqxiY+JuSux1GFKwL8AEwEf/g2PmoRa9ypcPWuZpEwv/hFgS?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae95d9de-be40-40ac-0ef3-08db2b2e91e9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:42.1235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zElhepYmEOr4e4c+QR5vxytD617AZTsMbl3QjOG+lOvXW3P08aO2kbhulB1723ygDqMEWBhjkCHZLXf2JMgEyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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

