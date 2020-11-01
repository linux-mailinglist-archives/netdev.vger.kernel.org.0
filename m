Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B626F2A20F6
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgKATRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:02 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgKATRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKxr7xBgqQPPfr/36jysCb25SuuN+LVL+ZvxV/bvUWv1Mw8oMGPx4GZVGT9bOk45w8UZgsDYTSvhyzQhrLniC/IxdA402snElFvYBpbPEKmfhShISR4KCTS5YtpECgVMeaAx0+mrUA0s7h8p6H++3XYsy4A7iw+kuTjrZ0yOqqlYnPMazNymefgiSmi00bOwskeGHvfFlbdavvUFCZ8u08JXfm1V4E577/vIKTopu2IPQKjNDUHgJN3AT7ErR9Xi7i47sSp1AU9eFfb1AiYP/jChTTZRTSrkWEiNFaBQhkYlJVlThZ9cvmH1S3cnzG8VgDRuwkWPF9N7/AkiVdtAoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjNQaADGJrr1uYGRBhmlfORK5hnjATsScbFl25g7g8w=;
 b=i97zooMM7TzXuogIZwTb+n5jay2LeZzGYfY0Vff3mvpSoRaNiLSRi06RPFv5Q3hEmKt+inSiuBntsesMDNIKTcftl1HYFtx9A/biYs9a/P2KRdApi2ttLd2XVPsuJHfj7kKwJIzwKOzG6jK5IA5AhJN7V3rI/v/Xy/MXdfzazmyNhvd7ASS7GMTzbCmDSAFEAr+GIMbZAU2vM/7+cKVOuf2/CibGYlsZm6LZ3bO7ptfB0S/7NuIi/NNLSlGsp5uUp2+1Ybok08h/Xwg4bVZc4QmkuMmfO8694owgtv1aIxw0MSrpFdOy1so7gqbKtL12nqAk1Hni14ds4lAawkxb1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjNQaADGJrr1uYGRBhmlfORK5hnjATsScbFl25g7g8w=;
 b=ppjzoXdv7rcVI3RV29M2QZGXpxD3Rbk5vkNFVMEkuJr8EcYZekrv178GBJc1X0F5bXIyNiW4NzOLrYpwtOTy6geazMEGEuoGZxbmHusW5FvJitqKLt21pvJTyBUdqUOjMW2QpOSNpkYBE8a+TCuDtFcCy4MDOS6MN5IOZhBQHxw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 02/12] net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
Date:   Sun,  1 Nov 2020 21:16:10 +0200
Message-Id: <20201101191620.589272-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201101191620.589272-1-vladimir.oltean@nxp.com>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d8ac7f0-45bd-4c59-7cde-08d87e9ab12d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28612E08D5A61871C176B33BE0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lu9WOcafHEDPD03yEXrNudu0Eynah//N4qFw7QzOADzu1pqhE5AmKG2e46qEQxVt78JeW9Z04g+UrtcuKKv8veFnif28plHDFhcCcGQjXU3OMjms4nHOJqe+wlGZGJNXS2zIgooHQNMuVOoU3uWs81CrbO6YFLeAQAz1OfYMam7ZfwHin9xkYvB7vGg0uL5NYj5I1rsZtH69Kw8pEmhFWHRN+hlVhMReteCSj0+OU6LQk9KfZkDlQbGOSts7eLcqfEBW0DOVeGaHBEtKLZaukCS2KVeSeAZqf+vUoDgYYb5Io4ph6w1zmf0Z5rOGwa/kTx6Ki5tZTWHcIE5KaQD+4Tf0w+KQ5ruFi+fFBM5W2xRs06VkLwFXhSQQw/bATrLD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sUR8CtWnC58W5UdNP1NanLClHvC2tJmh9SwQkuPdbn5KNnLQiRE9on50FCoHPlWY2cEjuTEF1V1tVuTZ0ozaZMvLe7vJPQz3rgifLcaQrfg/xf5H+tIw2mhpdMLEDuExFLBuGPqCABeNsBUFww1Rqsaa/FL8VkJEuV61Py9T7ldPTZZHkRWO3ysiKr5JR2wPO8Z/taZSvbFJp+v3EwZ2OvNSsdxkF+u0OSg4C9vCCzem6NGfgpoaf68jDzY0MNb0GO+FCCYJmQGx6O7sov3+dzNEsjdJePRf7N7vVZoD/MXz7w3quKlt3zSeqPu88H7JmIIXi8nLoky73+BLBmeIqT81jNdbdtPw+Fqz5fmRHQ03gyoRjr5rqvBf66ClEBm0Qnx939uEnFmniaUNIhK0NcvrlFqcY/3LZeuL22QG9B1eRZlpWQOfXA/7U5qoMFIqLFZBts53RHPHrSfu1tcJ2xv0Y0Bi6wjvkgQfsD0gPPhU7wA++XHZu5M133z/zjPx15RRkpB22py0ISE52IbCpuhlJemrqjXlbGQoE3BqeACRXrWs1IHLHvXyS4pkZjQtD2B09dX++9fSNJq8xlPkrUEAQdx5S4eT2rLr2ukq2vqVXBN4jb/Ef8Ffy5v1ujTcDJ90O7jhnIvXpIFt+8Pkxw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8ac7f0-45bd-4c59-7cde-08d87e9ab12d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:53.7345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQVTuTvqUrVv+7HOJXb/baAkaeT/VZmD+SKUuqQpW3JO7ILnJTTEkH7gdakA70Iuyff4IDbnFJkqaAUHiCM30g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_ksz.c | 73 ++++++-----------------------------------------
 1 file changed, 9 insertions(+), 64 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0a5aa982c60d..4820dbcedfa2 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -14,46 +14,6 @@
 #define KSZ_EGRESS_TAG_LEN		1
 #define KSZ_INGRESS_TAG_LEN		1
 
-static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
-				       struct net_device *dev, int len)
-{
-	struct sk_buff *nskb;
-	int padlen;
-
-	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
-
-	if (skb_tailroom(skb) >= padlen + len) {
-		/* Let dsa_slave_xmit() free skb */
-		if (__skb_put_padto(skb, skb->len + padlen, false))
-			return NULL;
-
-		nskb = skb;
-	} else {
-		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
-				 padlen + len, GFP_ATOMIC);
-		if (!nskb)
-			return NULL;
-		skb_reserve(nskb, NET_IP_ALIGN);
-
-		skb_reset_mac_header(nskb);
-		skb_set_network_header(nskb,
-				       skb_network_header(skb) - skb->head);
-		skb_set_transport_header(nskb,
-					 skb_transport_header(skb) - skb->head);
-		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-
-		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
-		 * skb
-		 */
-		if (skb_put_padto(nskb, nskb->len + padlen))
-			return NULL;
-
-		consume_skb(skb);
-	}
-
-	return nskb;
-}
-
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 				      struct net_device *dev,
 				      unsigned int port, unsigned int len)
@@ -90,23 +50,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *tag;
 	u8 *addr;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = 1 << dp->index;
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -156,18 +111,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	__be16 *tag;
 	u8 *addr;
 	u16 val;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ9477_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	val = BIT(dp->index);
 
@@ -176,7 +126,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -213,24 +163,19 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *addr;
 	u8 *tag;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = BIT(dp->index);
 
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
-- 
2.25.1

