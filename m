Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B8B2A20F8
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgKATRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:04 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727009AbgKATRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkz0NoSV084XtkNmGTISewLIUFeHg6C1KozUx5rQBliMxtwCellZMzdIe/jRgUhPcATMZDNbFA5Ti3T/rnJmD6HnKWCH0Dp2WFseO5Gwtjv5lsNv+BvUenKA6sSx0+gon2abYHUli7EJaFftYAEOIjAYrqQVWY7JWGwYuEX7WqL7nnrkaUhOBZ46DUY1xnPnTIZaW8Q1s+6YoQEWSXJPMxe1b/epT/2IhHRTd2yenrDb7jEUKACpsHwS/JL+Zrqq9z1faJ9T+TP0mVCWN+fnv4rKbWig2oXsifOLBFoI85Qy+v526OcD0DwlUk3SWDAqIsjy8pL7oJ9kK3xuNButOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdpjpowCtzYIgkTzKwF0wGOrCcKWxHeVfMzB0k2jGGk=;
 b=Cn2FqN/ul8X+cXRMlWVMsIEypbEllnSqWtJDvwyKPuAbIiJpKiKz+CKegyxvS5kGhGxnjxAd33EOIc9TgMRGzKGVhlg67j8dpxx1CITKIQHgLsSIlH8esX4TsRpZwbc1wla3DJEHw7UaorIRg6q+uTC8nDMzUgiVLNtiDkzv1LNp4qjVpCEcHmbnW65NHFCqEiU3zu9HNOLwFSt+AJNgi1X+zdiFIwLMOXsnhTqtuy+zv0/PpJfdvw/JSJXu3f9nug0Ob/mNdUSMVqn9oP7sHC9bJ28x+7+fo7J0MlR4HU831MpKOS39yFtaKaKeMgL4pfbPUfqCsJ8rsoZ7FoIg8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdpjpowCtzYIgkTzKwF0wGOrCcKWxHeVfMzB0k2jGGk=;
 b=ehmD8EddYLbwM8b0BvsP03I8fjYhfhncIHfdLolAZquWtBnUIar/g5v+NCxB3x35EYYOl10rog0I9ebGGMcsEcsgDpel20e32GHQD8+1ViQRhNl0C+sEpMKz1iWyofZEphNP9DWo/v4y8n/+nWelZNvQcZUkdBhX5zRHxYeDuTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 03/12] net: dsa: trailer: don't allocate additional memory for padding/tagging
Date:   Sun,  1 Nov 2020 21:16:11 +0200
Message-Id: <20201101191620.589272-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: fe80f3f5-8cab-444e-3e98-08d87e9ab186
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28612E62FB78F598F797EC39E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ez3+oYwDF01DY37emPh1Nb8RqcSoDt7p/L7fuiWECREOfjpf8gzdZ9qgQOqn1OTUICSzJK80aI5G9C/QvSbVx7yZl3N9Oqx95UdCOjYvGc264Y42fvDLha4BbomqPijIqhGz+Hf3OtZacr5bfxgHz68x1gwB4LG3m1yfINAfj47d6vGLNYxbgUNFu6WjJ3LZ2sk2G3VkoVLMPDyt6J6EH18KXI3w5bW52Q44y36rCSVElnsHDDmMbXZUESxVWaNS2XETuj9/0959g+n6CyOWn5xhgYiiZdsAdtLDqKPqx4BxUMlHp6io5tL0+iKmgG1mF5XzndTv2henLVkiKEzyZuWI0G/NvwL7KrEMvHFE/9PfZPhZjxqPVXEcZGPPvFut
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: phzYSl54WTn9HDaO6v6QWYOJJ6961yqy2Wv3XOPJVvy/q4vRdTzznScHILl3Ve3QNQGXN96yWLG+vygu6gexKiUiZTjM3sD7cIQQdbPCh+p62+Hkqo2FyWCVmYFTaWTUrIT9UC9g25zae1UIJwnPfeKGFCBXP7vTJGO7FHtfpDFklr3ljlITPN+7qNZ+yxMeV5xdbgrAUrO7GO1mlba4QBjtRf7K4YXsCujbO2Wcd349C30kccd3l3hq8uleIuG4UQNwfwUUEbEU91weDw6Mcvip7UL6+RrMII1QlmokZsAMa+j4iy9T2JKekxv3XuqO6xwGvPQ4LGgKhnFnzFRlZ4sLH/FjM5SY5WaaMAJ8II+5WHwZKaRjoE2LtPd+RDbteI8BHO5kUviPPjLxCm8uRuh0odBC79uI0iRzd3hpIlO7c/nBki+55EcjvVYpIJGmjvP9VFg0/JFNfiCD+8MIL83VxZ0y1ovgKW3Omfljjyo9OKgXRjnBZU6VNnPv7/t5wucFxQ8Q6NvWH0x60K+gWU4aHEs2HUMR3xgU+HZcreqTvC2Zz3DaNZM6nCjSGnD95WGhy10Jd2/wP+aF5WKWGX/rtpzQC58XQRl8msE3DEaOEqkM+TjmSwwylhiAbzgVR13rguXwhjluLqZM8ckCiA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe80f3f5-8cab-444e-3e98-08d87e9ab186
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:54.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXGBQLTT/i0cgBQe6efDMl0zKAkL/djNrjIPCBK4jh6ac7lOFtEZX1WmKUvjchC7+cKz7Wb+960G6bdYzG8BYQ==
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

 net/dsa/tag_trailer.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 3a1cc24a4f0a..5b97ede56a0f 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -13,42 +13,15 @@
 static struct sk_buff *trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
-	int padlen;
 	u8 *trailer;
 
-	/*
-	 * We have to make sure that the trailer ends up as the very
-	 * last 4 bytes of the packet.  This means that we have to pad
-	 * the packet to the minimum ethernet frame size, if necessary,
-	 * before adding the trailer.
-	 */
-	padlen = 0;
-	if (skb->len < 60)
-		padlen = 60 - skb->len;
-
-	nskb = alloc_skb(NET_IP_ALIGN + skb->len + padlen + 4, GFP_ATOMIC);
-	if (!nskb)
-		return NULL;
-	skb_reserve(nskb, NET_IP_ALIGN);
-
-	skb_reset_mac_header(nskb);
-	skb_set_network_header(nskb, skb_network_header(skb) - skb->head);
-	skb_set_transport_header(nskb, skb_transport_header(skb) - skb->head);
-	skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-	consume_skb(skb);
-
-	if (padlen) {
-		skb_put_zero(nskb, padlen);
-	}
-
-	trailer = skb_put(nskb, 4);
+	trailer = skb_put(skb, 4);
 	trailer[0] = 0x80;
 	trailer[1] = 1 << dp->index;
 	trailer[2] = 0x10;
 	trailer[3] = 0x00;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
2.25.1

