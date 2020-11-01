Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F652A20FE
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgKATRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:20 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:31354
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727179AbgKATRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHgtYtFrEF7R+GzVapw8ywV+HnAEnocOOJgWVObPeI41wJX7dwzeNB2/CAmB4y/pTR9zdpZcZ6+zXcLvaXrDlVaIm/dUstcd9LnuAubahmCsjVQd1wVMs7SGcydKZF8C6SIY7t9OdxnKQv+I0agsH7Cb29AEAJWiraMqdrBemrxHF68r6J5TaDF1OQtmIwrnQeilvSFtNgcN8AL/XrAhx+momWa9SGS4Sfc+pAaXIZoJf5/1Y+MM2Rp0pKhCAHM/6twFodPm9SE0/HjMJNHxMcVFx67wGOXWx7MmYNT9BfF6qkjja1T6F3x+96hOz7FiuYiqzzjnyZbc+QNTcfigWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdX+8sQW9Uy0GBCZojAxdGwCrv9hS+ImDf0XljF4k5M=;
 b=Q7QnAzXGRoCKQOoxvUWTvrgf4UrqFmdGMyn6TmoQ6EZF1ghawu+Cx0MnTw0zsatuz8i+8t0YwkIzue/1XFG5Vydq0Xw0ADNlMkUioD9TlYta7PcCb8hb5PDoms6IanINl58EHp7sMUwPdl2C9FZ+p2/rMDjBxzdIOR2Wah8cmWkUEduECY+YmvDm9FsCdE/im6aya3ifLI+zucJxlXFtwEOve7UtgXh2fq/1/ksatR0CJ+9QcJpjSS6m0vljsJ9WqxBtvbuU2Sqseukps0Gvqugwe/qHZAiuyPDFy+rPC4Swb7fZ2AaTf1O+ZKUXByD5sF/pkMdbwnKf4Vel+crqBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdX+8sQW9Uy0GBCZojAxdGwCrv9hS+ImDf0XljF4k5M=;
 b=YylGV2P5IRQLDYDaq3xok3246uSBtXyfh+xJJf+x7dESiYrtc31Kr4pPRdyIXdoRcGeUzSGp0+o5opTnTLUgIT5GCGVna+Mj+yhBIWhvzl3RV1oPhIcHTN3MfjpmdMJQUUTNWkFC04BevV2OrHnc/8U63/IzKGFnyxvbMQc2ido=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 10/12] net: dsa: tag_dsa: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:18 +0200
Message-Id: <20201101191620.589272-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b6385dbf-0093-491f-1346-08d87e9ab417
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861643B88C9BF06A1E4523DE0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2D8NQhBuk3eqNF6/GNJCGSxsZEMBrJaqk9s4WHFseUtGE0dKlr05pjVhvZ7ER/gj8PJyH9RLNCfCDFj1boMwVKudYxBzWze9GllrdoVjKzvSIlqRLqYT3EFxh9u72p6d+YvuJ995ooeoMc/oG4T9UyM82zgnSuf6/+4pvr+k/h6gmpkdy7FnzWEOaBc6fsEmOI1uK5IhQRnKPgvGiow7ORVR/tBH62yGJSwx+26FZ0Lo+TN5KQsQQcGudwEGlnsMK6IsW7ApUcEHAzV8BHjtPKTYCh898e5vFY8vGdP2aycZFT7/6fUyvazvkVMR62jXJfZgHEipyWAkm5m7A32NsdQnFqnq9b87p0f19PlBMevt6QWKo8EYcqkazXSB3Qih
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PkT4DCv3ieFUk1zjkbl+RqkkHHvnl1vLHjfT7xjt940HWl1eDIpz4ne9gRnnzQ6gDDU8UoYB+s9r9Jn+SIrIFR44adC1Lw6IoPWCe4OfdjM1AB7QsI38tGhwYzlT6r/hZgrv0yhzs7BNmNmv/gLvGqHdVOh6UemPWmOfct9BflOTRgIb9SeuysmUGipB8gDhWg6JLF9VsYVfOIk7HkJ1S8axn+6vBZnAvwZhBhhsHROramQGdOBdZYTY84doyKq4egF5HX5kwZ0XNKrNmPM/bO4tcOJCD4fBEuJCyyNuJC6spP9QqTvKKyB8gAsRMCCtuXQxuDyjuYdzNTHakjTWz7dDmsd2fYNDVQO3coTJgdHV4X7mkQPSRUvqNX40dTUAxFIFGjDNJy4VLTF076t2XI9pqlHWjnYOi1uI9X2gB63Qi0lz2PUsg/4r9b3ffO7AWcl289swc1vEGSQdyXMJYQuAWp26na7j899lvjng5t1Yp/AzuwjLLsMHm137WswxRNZ2rfWQzgDO1+5T8BQ7WL9vlPNndULpLBsxxkces8nCRE4FYVg8yNKIZp5v9R8M3D7FkXWImyCdWtSoCa8Lv/hMYBKcnwBkWevH1MGcRBT60cmDhaaJbeGhR8Uw6BVBeD8CSSOFXOBdShfyZQqHtA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6385dbf-0093-491f-1346-08d87e9ab417
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:58.6428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0EzNNgPHCjHZTFaU453bLJcLDamZtHEAp/Giw7s+0CSz80JhaAMiQDu+ciwkDkUJhslu8iWZKvBJV+0qFlIyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Similar to the EtherType DSA tagger, the old Marvell tagger can
transform an 802.1Q header if present into a DSA tag, so there is no
headroom required in that case. But we are ensuring that it exists,
regardless (practically speaking, the headroom must be 4 bytes larger
than it needs to be).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_dsa.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 0b756fae68a5..63d690a0fca6 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -23,9 +23,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * the ethertype field for untagged packets.
 	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		if (skb_cow_head(skb, 0) < 0)
-			return NULL;
-
 		/*
 		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
 		 */
@@ -41,8 +38,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		if (skb_cow_head(skb, DSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, DSA_HLEN);
 
 		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
-- 
2.25.1

