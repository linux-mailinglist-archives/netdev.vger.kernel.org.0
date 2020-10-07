Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8A2286212
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgJGPZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:32 -0400
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:47836
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbgJGPZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrHoxExGlYKCGCABvEloMSIGD+crGHRogLJ8ZrQa8aI+hokm8XHgnIFGtdDzCx/ZBMiS2sKg39gkTUIKWZIfhx8hITle80DlKqOAQD+orrJOC9QY2ZdSDl3Y9U1+nhqC2aGO2ZjmJt7VSG/QlxQCQ50s0DniZKC7CoCb5+pw1KxwYSRqp72QxbZx8MO2PAEIcuoSlAyC8CH17oxdsvAcmxMPLAlfp0SY1DWQQJieCACj9BT2Aw1TquoAQWpSixjlZAYRTqRTUG5BBc4gyGtdzHxgiyYiNiXfiGTH5urjC5laOO36YhjPK3g4hmMQaW6LYupxyID7ivEpWvStMEJdQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BfoaA16C0Lc2TtNvTumV450qqjh+Xn/r7XyNXBu0+U=;
 b=f9Ve/+W5vG+SGIPdvHVzaEZPXqdbPT8aiTDitcFgCfHOb49cbIUjjuGsJBELxYyZ/4IohPSyqUlICIveBo2TvJzRqhmfHPcpW+WG/p97/crb0FsvgJDrJCngZhiCnaCXl9vlm9mIW2PZFU9wFiYmkGuwg8b5Relz6JSUChf+WPUMm2ZfpCuNvXDw9p5mkXRswA4k9trXqLSiDSwOrITjSzgQAmJoIjoaM4Xkku46MfBOosLOk+v8PUkaOPvdryKwKUfdijgEHyptgE3goR/ksczmhFP8bdC7ZIB5UuhD5xmWMlGSDFKbO1N9zHQ0lVtrcxB6ynhiMgGdOVj5NrJolg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BfoaA16C0Lc2TtNvTumV450qqjh+Xn/r7XyNXBu0+U=;
 b=c0RF7LD9Ck2QI+cebi3S+h8SyeBr+Jid7Crj3iyayLnSudqiRCB3z/36Ukswo6zF/XkKrO8jxxgqSADgJx2PDWuHlIUqTPyzTb4K0y9atGpnNqbHBcedkI5sktf4iWa+WT1hiponAxcWBlljLPTHzdEdb5TgePnRjOol9lTdBqI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:18 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:18 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 5/7] igb: use igb_rx_buffer_flip
Date:   Wed,  7 Oct 2020 17:25:04 +0200
Message-Id: <20201007152506.66217-6-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201007152506.66217-1-sven.auhagen@voleatech.de>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR05CA0077.eurprd05.prod.outlook.com
 (2603:10a6:208:136::17) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 047cc7b8-7985-4249-909e-08d86ad532cc
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB60826B9DD3D5D949AC777A1DEF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sdUCViwXqyMijymLcuSOC43e6aCc5q3HuRTjxOQ+rM3dd/SYZztx4pPe9tIvoQk0RiWG6znhU+HK8FydGAEE+YqOV7VlisEibpjCmE1RXzPC2cgt6AYw5am0VqTmHOM26y5LLowXPTpWFwV+WBCH15oJPeNiwj0sE5jYg8VJi1pXYzk5AxPI1h+CoroPCgbfOgr2CyNIBzRVpF9KAvtqnVnZoukwiJsdX+vXmQKNTX0zNivxb1SvSyB6FBhSX04fR+1zAVLTJNLOKiIlL7LNP97Vc4lQETQXgx6B4iSXBPHh7XbYCUaPfWg9kBUZ1/IcVxq1AfPagcpnfS9DzFHzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dyAGvPW7rK5UTfJrJEKZxC1YhREzcZaomVlqTZpvQeEkdd3T3QYSHwvpD6qBDqcBE14R6dii+XY+2zL9LKzpyWuCOJcLNNQ2PtSc9XsP0gEMCngpS+fOHfXdozl0O01s6CnWQ+VUhn8Gk+maWS7g/0qMbrljSBApZK93WW8oqHB4PrfzJ7cbghn+tvokgAh+WacbB6Yna5CAZHbEkZS3o1WQlVeFWBTsK8CXukKMwpuV0WmYlkdL04Bh+i+qSiBzpkpsHt7GSnxcNu4HYVop1Vipow2dPTLy0oO1eeEgZsgE+5MeE8n4/YGKueOf304GNff+PTb221sa84foh90njUqfcQ/C7PrJ8JWivseH29xN15zgnYKwZ0+xct4nik95EY+oG8NFkoeORl3Yfp6FUdQA+N8upwLeiZAIlvYHzLqvaQn4z3Nqu3bGEnjrzDizAnPQwP1I+YLhhayEbgzWnVCiMX8mdIJq/1vfzgLyBjynNmQk46g3vQh4dtkYGNIvoX+DT0xOOjW67RIWHvDMbT/VNXOTktMDhhGzS6jY7ACCdtSpo7Jr98jdkc/CVdoQn7fhp4m5bzIaQ26AG2nI6IFly1prIDpdk1g7DLxL4/kI4DgrlsALAlissa4MPGJYqWI6xRQd6IE9eDpLs1z7kg==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 047cc7b8-7985-4249-909e-08d86ad532cc
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:18.7493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQBz/v0DX0EuRrZDNnppdmpTLeSJo5LGz30+MUGbl2yx9UBVDsIqZ68hJDHoYzeyIaGJyxBIYF0bDBvA2r+quvBbatGhuUkrltJo4Tj3rU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Also use the new helper function igb_rx_buffer_flip in
igb_build_skb/igb_add_rx_frag.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 87 +++++++++--------------
 1 file changed, 35 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 36ff8725fdaf..f34faf24190a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8255,6 +8255,34 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
 	return true;
 }
 
+static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
+					  unsigned int size)
+{
+	unsigned int truesize;
+
+#if (PAGE_SIZE < 8192)
+	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
+#else
+	truesize = ring_uses_build_skb(rx_ring) ?
+		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
+		SKB_DATA_ALIGN(size);
+#endif
+	return truesize;
+}
+
+static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
+			       struct igb_rx_buffer *rx_buffer,
+			       unsigned int size)
+{
+	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
+#if (PAGE_SIZE < 8192)
+	rx_buffer->page_offset ^= truesize;
+#else
+	rx_buffer->page_offset += truesize;
+#endif
+}
+
 /**
  *  igb_add_rx_frag - Add contents of Rx buffer to sk_buff
  *  @rx_ring: rx descriptor ring to transact packets on
@@ -8269,20 +8297,12 @@ static void igb_add_rx_frag(struct igb_ring *rx_ring,
 			    struct sk_buff *skb,
 			    unsigned int size)
 {
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
-				SKB_DATA_ALIGN(IGB_SKB_PAD + size) :
-				SKB_DATA_ALIGN(size);
-#endif
+	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
+
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
 			rx_buffer->page_offset, size, truesize);
-#if (PAGE_SIZE < 8192)
-	rx_buffer->page_offset ^= truesize;
-#else
-	rx_buffer->page_offset += truesize;
-#endif
+
+	igb_rx_buffer_flip(rx_ring, rx_buffer, size);
 }
 
 static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
@@ -8345,14 +8365,9 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 				     struct xdp_buff *xdp,
 				     union e1000_adv_rx_desc *rx_desc)
 {
+	unsigned int size = xdp->data_end - xdp->data_hard_start;
+	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
 	unsigned int metasize = xdp->data - xdp->data_meta;
-#if (PAGE_SIZE < 8192)
-	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
-#else
-	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-				SKB_DATA_ALIGN(xdp->data_end -
-					       xdp->data_hard_start);
-#endif
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
@@ -8377,11 +8392,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 	}
 
 	/* update buffer offset */
-#if (PAGE_SIZE < 8192)
-	rx_buffer->page_offset ^= truesize;
-#else
-	rx_buffer->page_offset += truesize;
-#endif
+	igb_rx_buffer_flip(rx_ring, rx_buffer, size);
 
 	return skb;
 }
@@ -8431,34 +8442,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 	return ERR_PTR(-result);
 }
 
-static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
-					  unsigned int size)
-{
-	unsigned int truesize;
-
-#if (PAGE_SIZE < 8192)
-	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
-#else
-	truesize = ring_uses_build_skb(rx_ring) ?
-		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
-		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
-		SKB_DATA_ALIGN(size);
-#endif
-	return truesize;
-}
-
-static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
-			       struct igb_rx_buffer *rx_buffer,
-			       unsigned int size)
-{
-	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
-#if (PAGE_SIZE < 8192)
-	rx_buffer->page_offset ^= truesize;
-#else
-	rx_buffer->page_offset += truesize;
-#endif
-}
-
 static inline void igb_rx_checksum(struct igb_ring *ring,
 				   union e1000_adv_rx_desc *rx_desc,
 				   struct sk_buff *skb)
-- 
2.20.1

