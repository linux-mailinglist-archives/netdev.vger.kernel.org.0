Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776B56DB5A1
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjDGVBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjDGVBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:01:39 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40045FFD;
        Fri,  7 Apr 2023 14:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMa2OHpr5/8qyOPt3b1eMIdTDVpME0RUH2dljcu4Pf6oZzkVLY5oJ9bE8+xYJ+c7A/v19lpYgkhvpScL5vGSQaXTi46wlsJzYpcr/ahWow9Gowo6Z7h4cGYgBxhhfWLWgLKC3ksxJRvIj7I7TMwsa2lumQOrbLmnNC/URf8IKbOhF/nO/zvg0F0ZLBnecjsi4YH3pxKyV6f8Gb1zHdmuP8srDNXm2XTPwtNOMfw+wS7CIqrgx/2EgUcVEIILw54e3uplXDWa6/szpCq7rMNtITIWhwfzbUsS/JcHoekL7h1W1YrSw0/VvJy7eg3HQ90m8fUKU7XvqugeyjN0rzttsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRW0/NfEfMTjXDX7T3PoFAblacn6PSZJXI9VGY6MYIA=;
 b=fXaltohfGTizHxTVHs74mcrGsHaVDN51BTcVo2G5eQQHDgMiodh1CrBIbSgC/DTrHQuCR2rT5bT4mWl5YnNKGQZZ7Vi7FfVFEbXyL1B7lmqi7Lcc0TmVxu2wIUGnYJ9ynAwjzY3ERlNmNHdULonf7O6ZM3eb/3jPAOGaZNhqwfHvZuLMxp/GQ4SvezDP4J4ni6hHZxF2rOvVj0NmQaN/ixkLU7dwyWtFMhz8WUdrrTq1ofD7SxVAw5igVAqxLOZdMR1oWAj8s9UrJR1Zq2CY+bDMWylodtgre+ttYiUyaEVJtHemIO1Cywzx6XfNcW1UBMnYnU/VYBuwdK6tB7Es5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRW0/NfEfMTjXDX7T3PoFAblacn6PSZJXI9VGY6MYIA=;
 b=TINDXbVeb+aIYtwZFUcwnYK1LdF9sUujLGL6gzt+q1j7tTzSahMfK44S0hvJmIhZ3pwwRx96n5eTdkSajpiSb2GfsneBu4oKrqwTUfPcLiJIW7awkQWOaB/dCZYL1oeMdX6fWvUYViVtDfPvVLggf5ABx2czE0YOWacFJCEgJHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by PH0PR21MB1895.namprd21.prod.outlook.com (2603:10b6:510:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 21:01:35 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 21:01:35 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 2/3] net: mana: Enable RX path to handle various MTU sizes
Date:   Fri,  7 Apr 2023 13:59:55 -0700
Message-Id: <1680901196-20643-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:303:8c::22) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|PH0PR21MB1895:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e53d0f9-fed0-4af2-af88-08db37ab45b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m5PGXGU5Ag2LNxin/siNyAAlHFYoiIVZNtVS4VeqlsoA2R4+JDyXkPOOky4N3jcgX7kHJobotcDgIyYkIqrXm/lxwKBZtVQlwZU+8mCLXgM5VmwCG3kq2etUK6IZ0n8a4SY6G2toTIO75bLxml0cb/5zGmRLr6DezDTLOBnd7md02ZBN8fhE4KdMcBIp6gYC6yTpgQnki5vIxnRzbQFgcvTps2Ahygw1WwMrHuq14g9LKwbsDnxmlWDDWXpz2cnPgd1mKLkneQJl1tckqbwTP6B3hA9maAFDr+56EmXUVH756gNHG3tAlSseXlHbyjD7jnSoupQIyqW2L284jJ315qNtY49DZrbW/xESN4GfLldJu1H6CG5czgSSL0Osuaqvy60YW97ja8SmpKzouCle+PHhMajT6JvAtRajC+dHahk0wB+1TYw7feimP1c/GThRziWuQvd+z91Lm9jRXqObxku1FVehHQkhfrdyadA82sa+bBvoCbzz9L+c6B5iXEK53Mxtl4ihb86Aty9JCZ7B10BdNy8M12G2uufHkQplsXkfbDXYq6pZS5Facl0fsDOXcsIepajIw7hQvAfYFX826eJLs1nI6aDMYMymdy+jTIUX/NyRcDkObKADbabK7MVv7N4z1Kg2cjMDndAlx1ngv23NBmYNZG1gdqcgY8Had+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(6486002)(66476007)(478600001)(8676002)(4326008)(7846003)(66556008)(41300700001)(786003)(316002)(52116002)(36756003)(83380400001)(2616005)(6512007)(26005)(6506007)(6666004)(8936002)(5660300002)(2906002)(7416002)(10290500003)(82960400001)(38350700002)(38100700002)(82950400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P4C8REF8g71D2yrhya3MeLVNr5avCjbbRtPGrAsSXgX4I4fiCCndOoKWIOUO?=
 =?us-ascii?Q?6wOGQ7YfLEqmkzkbl4gxlZOciQf/yx1My7ukJUSU9mXzjR8EW/SPOm1dHANL?=
 =?us-ascii?Q?eieRnZp/TuJyfZXiLAnR2StO8LViN/DiviB/jWpojHCtgXwrFMWHhrecnsof?=
 =?us-ascii?Q?rZelM46ehZpl6HA3shjf+IHmopBDjag/OJrgxU0qNcjaPGZB+NJXRC+tVfkG?=
 =?us-ascii?Q?UdZHmlWOzWLHLpIHlXTayG7feDD52ppxy1UvhqR7TqzO+leJKDrTO1vbp/FN?=
 =?us-ascii?Q?KbVgFCwNPx23m4cXWdURL9WAp8tPbtkZW3V8wdodGnjLmPloka5JAeoW7Zr/?=
 =?us-ascii?Q?YpLjOa+FbthE4XByXra2P7ogwKzBwg4o+j1MtnfMklUWIzj/DXMZTD9LdRy9?=
 =?us-ascii?Q?N0p6MzDMfqC33lhhovqhengA16EoJIpdbnXHwd+22f5T4csEfX/bXJdJaWI5?=
 =?us-ascii?Q?+WKJA/etvfWI3cWFm8tdOIit7ypryVvPZe2XGmUm5x7t6To4JFNCeqQSj8L7?=
 =?us-ascii?Q?77+mP2N1s9nJUnPkhE3H/8envM+u3fD/lZi6PIqHlW+kJ6IlmhnaWjcNUMlQ?=
 =?us-ascii?Q?PzR+5qVKPgiDWSNyg2RHz8A4v5UXXQNWWO8E5EK7Ntt2MnWVKNaSlDybETVr?=
 =?us-ascii?Q?Ez/bDWi/MYi4oHazUOEl8EyT6JrejFzw4t29TPefc9DXwgpxAx8jKz+pzqyw?=
 =?us-ascii?Q?VN95vvzUG2pWq6E8G0QZTEc7X2v5fGQA+WXEu4fXWCWuaOhVzzCr+85uIVD8?=
 =?us-ascii?Q?tW87RRLcvJzxqaDhHzjx15Qg12XyKi4DrOTcNip50Vw9IrXBIYskccIELKcn?=
 =?us-ascii?Q?NtgR07OIDGNJjoNzZ1NRZtyEPdcETIduX0wQ/mar476ib+6LnpeCZl7Wg61+?=
 =?us-ascii?Q?SLo4dQbVoi6jz8ynR4NWNsokhQH8VVDoevg9VuEbep2tt8KD1vFe7SPlFWtq?=
 =?us-ascii?Q?CV99KABbXXULQR98VkgPKDRJhpHhxCsVrOyIWSB9ECAGX8Z10sJa8W5XrtNE?=
 =?us-ascii?Q?h93mQb3fEfHhWuKl/D2cVe7X3tW9y5wvx61ird9uHVcGEYNAPvY+wPFAFMk3?=
 =?us-ascii?Q?2kIkdEIBzRhd4US4KRsdja1Tf3VyA6WwKKCecS799PHburLB0/tPypusKu1q?=
 =?us-ascii?Q?Mj4rVrv2+TR5RA/LiSEd4MDzPQyiYtapPs5pZ8ySdAnN87ZhZu5uyNiFA6/2?=
 =?us-ascii?Q?s2xOZ9HXL4WtK0Fypg0R3Qx+JTEv627iMZSKq6z7Er94llyE9DoXaDOKnJc2?=
 =?us-ascii?Q?qFWaCHgJV407SkEgAPwyh1HTbsWaMIRcpKmY0wsKOSXBfVXq/0o6OV+Lptba?=
 =?us-ascii?Q?/hdIHCo4H4+OW7JI2nkcHBTtCYg4VdP3HvxXR+54GYydcoOw9gXZ5oFp+Ba5?=
 =?us-ascii?Q?XgfHRz6fQLjNgR5Ho5Sc7v692YBBGq6VugfixacUUWAgC9FTA3pYw55QrKnz?=
 =?us-ascii?Q?olP4SmiRilyWiCTjW4Zz6YWcN9o1Rwkmr7gZ4ZyrKhh4Xu1LnI9iAskBKsv6?=
 =?us-ascii?Q?6DLxpZw879VvQIja1jS5+VIYvS9cITq09bu/72lKGLTqzNiIJG+poN1jdN8O?=
 =?us-ascii?Q?RgEBxhNFCCBH/5DbT2c/j/TpKsW5dbGSP3XDElk0?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e53d0f9-fed0-4af2-af88-08db37ab45b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 21:01:35.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pTeacK9RCZ3UDZbnulqba2F0SJAa+cg3mgXePzuT27ar6MjQ5k+sK3tcnSW4kCBNbapTsZWFYDKNKrhprk2zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1895
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update RX data path to allocate and use RX queue DMA buffers with
proper size based on potentially various MTU sizes.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
V2:
Refectored to multiple patches for readability. Suggested by Yunsheng Lin.

---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 188 +++++++++++-------
 include/net/mana/mana.h                       |  13 +-
 2 files changed, 124 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 112c642dc89b..e5d5dea763f2 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1185,10 +1185,10 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
 	WARN_ON_ONCE(recv_buf_oob->wqe_inf.wqe_size_in_bu != 1);
 }
 
-static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
-				      struct xdp_buff *xdp)
+static struct sk_buff *mana_build_skb(struct mana_rxq *rxq, void *buf_va,
+				      uint pkt_len, struct xdp_buff *xdp)
 {
-	struct sk_buff *skb = napi_build_skb(buf_va, PAGE_SIZE);
+	struct sk_buff *skb = napi_build_skb(buf_va, rxq->alloc_size);
 
 	if (!skb)
 		return NULL;
@@ -1196,11 +1196,12 @@ static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
 	if (xdp->data_hard_start) {
 		skb_reserve(skb, xdp->data - xdp->data_hard_start);
 		skb_put(skb, xdp->data_end - xdp->data);
-	} else {
-		skb_reserve(skb, XDP_PACKET_HEADROOM);
-		skb_put(skb, pkt_len);
+		return skb;
 	}
 
+	skb_reserve(skb, rxq->headroom);
+	skb_put(skb, pkt_len);
+
 	return skb;
 }
 
@@ -1233,7 +1234,7 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	if (act != XDP_PASS && act != XDP_TX)
 		goto drop_xdp;
 
-	skb = mana_build_skb(buf_va, pkt_len, &xdp);
+	skb = mana_build_skb(rxq, buf_va, pkt_len, &xdp);
 
 	if (!skb)
 		goto drop;
@@ -1282,14 +1283,72 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	u64_stats_update_end(&rx_stats->syncp);
 
 drop:
-	WARN_ON_ONCE(rxq->xdp_save_page);
-	rxq->xdp_save_page = virt_to_page(buf_va);
+	WARN_ON_ONCE(rxq->xdp_save_va);
+	/* Save for reuse */
+	rxq->xdp_save_va = buf_va;
 
 	++ndev->stats.rx_dropped;
 
 	return;
 }
 
+static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
+			     dma_addr_t *da, bool is_napi)
+{
+	struct page *page;
+	void *va;
+
+	/* Reuse XDP dropped page if available */
+	if (rxq->xdp_save_va) {
+		va = rxq->xdp_save_va;
+		rxq->xdp_save_va = NULL;
+	} else if (rxq->alloc_size > PAGE_SIZE) {
+		if (is_napi)
+			va = napi_alloc_frag(rxq->alloc_size);
+		else
+			va = netdev_alloc_frag(rxq->alloc_size);
+
+		if (!va)
+			return NULL;
+	} else {
+		page = dev_alloc_page();
+		if (!page)
+			return NULL;
+
+		va = page_to_virt(page);
+	}
+
+	*da = dma_map_single(dev, va + rxq->headroom, rxq->datasize,
+			     DMA_FROM_DEVICE);
+
+	if (dma_mapping_error(dev, *da)) {
+		put_page(virt_to_head_page(va));
+		return NULL;
+	}
+
+	return va;
+}
+
+/* Allocate frag for rx buffer, and save the old buf */
+static void mana_refill_rxoob(struct device *dev, struct mana_rxq *rxq,
+			      struct mana_recv_buf_oob *rxoob, void **old_buf)
+{
+	dma_addr_t da;
+	void *va;
+
+	va = mana_get_rxfrag(rxq, dev, &da, true);
+
+	if (!va)
+		return;
+
+	dma_unmap_single(dev, rxoob->sgl[0].address, rxq->datasize,
+			 DMA_FROM_DEVICE);
+	*old_buf = rxoob->buf_va;
+
+	rxoob->buf_va = va;
+	rxoob->sgl[0].address = da;
+}
+
 static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 				struct gdma_comp *cqe)
 {
@@ -1299,10 +1358,8 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct mana_recv_buf_oob *rxbuf_oob;
 	struct mana_port_context *apc;
 	struct device *dev = gc->dev;
-	void *new_buf, *old_buf;
-	struct page *new_page;
+	void *old_buf = NULL;
 	u32 curr, pktlen;
-	dma_addr_t da;
 
 	apc = netdev_priv(ndev);
 
@@ -1345,40 +1402,11 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	rxbuf_oob = &rxq->rx_oobs[curr];
 	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
-	/* Reuse XDP dropped page if available */
-	if (rxq->xdp_save_page) {
-		new_page = rxq->xdp_save_page;
-		rxq->xdp_save_page = NULL;
-	} else {
-		new_page = alloc_page(GFP_ATOMIC);
-	}
-
-	if (new_page) {
-		da = dma_map_page(dev, new_page, XDP_PACKET_HEADROOM, rxq->datasize,
-				  DMA_FROM_DEVICE);
-
-		if (dma_mapping_error(dev, da)) {
-			__free_page(new_page);
-			new_page = NULL;
-		}
-	}
-
-	new_buf = new_page ? page_to_virt(new_page) : NULL;
-
-	if (new_buf) {
-		dma_unmap_page(dev, rxbuf_oob->buf_dma_addr, rxq->datasize,
-			       DMA_FROM_DEVICE);
-
-		old_buf = rxbuf_oob->buf_va;
-
-		/* refresh the rxbuf_oob with the new page */
-		rxbuf_oob->buf_va = new_buf;
-		rxbuf_oob->buf_dma_addr = da;
-		rxbuf_oob->sgl[0].address = rxbuf_oob->buf_dma_addr;
-	} else {
-		old_buf = NULL; /* drop the packet if no memory */
-	}
+	mana_refill_rxoob(dev, rxq, rxbuf_oob, &old_buf);
 
+	/* Unsuccessful refill will have old_buf == NULL.
+	 * In this case, mana_rx_skb() will drop the packet.
+	 */
 	mana_rx_skb(old_buf, oob, rxq);
 
 drop:
@@ -1659,8 +1687,8 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
-	if (rxq->xdp_save_page)
-		__free_page(rxq->xdp_save_page);
+	if (rxq->xdp_save_va)
+		put_page(virt_to_head_page(rxq->xdp_save_va));
 
 	for (i = 0; i < rxq->num_rx_buf; i++) {
 		rx_oob = &rxq->rx_oobs[i];
@@ -1668,10 +1696,10 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 		if (!rx_oob->buf_va)
 			continue;
 
-		dma_unmap_page(dev, rx_oob->buf_dma_addr, rxq->datasize,
-			       DMA_FROM_DEVICE);
+		dma_unmap_single(dev, rx_oob->sgl[0].address,
+				 rx_oob->sgl[0].size, DMA_FROM_DEVICE);
 
-		free_page((unsigned long)rx_oob->buf_va);
+		put_page(virt_to_head_page(rx_oob->buf_va));
 		rx_oob->buf_va = NULL;
 	}
 
@@ -1681,6 +1709,26 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	kfree(rxq);
 }
 
+static int mana_fill_rx_oob(struct mana_recv_buf_oob *rx_oob, u32 mem_key,
+			    struct mana_rxq *rxq, struct device *dev)
+{
+	dma_addr_t da;
+	void *va;
+
+	va = mana_get_rxfrag(rxq, dev, &da, false);
+
+	if (!va)
+		return -ENOMEM;
+
+	rx_oob->buf_va = va;
+
+	rx_oob->sgl[0].address = da;
+	rx_oob->sgl[0].size = rxq->datasize;
+	rx_oob->sgl[0].mem_key = mem_key;
+
+	return 0;
+}
+
 #define MANA_WQE_HEADER_SIZE 16
 #define MANA_WQE_SGE_SIZE 16
 
@@ -1690,11 +1738,10 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
 	struct mana_recv_buf_oob *rx_oob;
 	struct device *dev = gc->dev;
-	struct page *page;
-	dma_addr_t da;
 	u32 buf_idx;
+	int ret;
 
-	WARN_ON(rxq->datasize == 0 || rxq->datasize > PAGE_SIZE);
+	WARN_ON(rxq->datasize == 0);
 
 	*rxq_size = 0;
 	*cq_size = 0;
@@ -1703,25 +1750,12 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 		rx_oob = &rxq->rx_oobs[buf_idx];
 		memset(rx_oob, 0, sizeof(*rx_oob));
 
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-
-		da = dma_map_page(dev, page, XDP_PACKET_HEADROOM, rxq->datasize,
-				  DMA_FROM_DEVICE);
-
-		if (dma_mapping_error(dev, da)) {
-			__free_page(page);
-			return -ENOMEM;
-		}
-
-		rx_oob->buf_va = page_to_virt(page);
-		rx_oob->buf_dma_addr = da;
-
 		rx_oob->num_sge = 1;
-		rx_oob->sgl[0].address = rx_oob->buf_dma_addr;
-		rx_oob->sgl[0].size = rxq->datasize;
-		rx_oob->sgl[0].mem_key = apc->ac->gdma_dev->gpa_mkey;
+
+		ret = mana_fill_rx_oob(rx_oob, apc->ac->gdma_dev->gpa_mkey, rxq,
+				       dev);
+		if (ret)
+			return ret;
 
 		rx_oob->wqe_req.sgl = rx_oob->sgl;
 		rx_oob->wqe_req.num_sge = rx_oob->num_sge;
@@ -1764,6 +1798,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
+	unsigned int mtu = ndev->mtu;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
 	u32 cq_size, rq_size;
@@ -1780,9 +1815,18 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->ndev = ndev;
 	rxq->num_rx_buf = RX_BUFFERS_PER_QUEUE;
 	rxq->rxq_idx = rxq_idx;
-	rxq->datasize = ALIGN(MAX_FRAME_SIZE, 64);
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
+	rxq->datasize = ALIGN(mtu + ETH_HLEN, 64);
+
+	if (mtu > MANA_XDP_MTU_MAX) {
+		rxq->alloc_size = mtu + MANA_RXBUF_PAD;
+		rxq->headroom = 0;
+	} else {
+		rxq->alloc_size = mtu + MANA_RXBUF_PAD + XDP_PACKET_HEADROOM;
+		rxq->headroom = XDP_PACKET_HEADROOM;
+	}
+
 	err = mana_alloc_rx_wqe(apc, rxq, &rq_size, &cq_size);
 	if (err)
 		goto out;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index bb11a6535d80..fee99d704281 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -36,9 +36,6 @@ enum TRI_STATE {
 
 #define COMP_ENTRY_SIZE 64
 
-#define ADAPTER_MTU_SIZE 1500
-#define MAX_FRAME_SIZE (ADAPTER_MTU_SIZE + 14)
-
 #define RX_BUFFERS_PER_QUEUE 512
 
 #define MAX_SEND_BUFFERS_PER_QUEUE 256
@@ -282,7 +279,6 @@ struct mana_recv_buf_oob {
 	struct gdma_wqe_request wqe_req;
 
 	void *buf_va;
-	dma_addr_t buf_dma_addr;
 
 	/* SGL of the buffer going to be sent has part of the work request. */
 	u32 num_sge;
@@ -295,6 +291,11 @@ struct mana_recv_buf_oob {
 	struct gdma_posted_wqe_info wqe_inf;
 };
 
+#define MANA_RXBUF_PAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) \
+			+ ETH_HLEN)
+
+#define MANA_XDP_MTU_MAX (PAGE_SIZE - MANA_RXBUF_PAD - XDP_PACKET_HEADROOM)
+
 struct mana_rxq {
 	struct gdma_queue *gdma_rq;
 	/* Cache the gdma receive queue id */
@@ -304,6 +305,8 @@ struct mana_rxq {
 	u32 rxq_idx;
 
 	u32 datasize;
+	u32 alloc_size;
+	u32 headroom;
 
 	mana_handle_t rxobj;
 
@@ -322,7 +325,7 @@ struct mana_rxq {
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
-	struct page *xdp_save_page;
+	void *xdp_save_va; /* for reusing */
 	bool xdp_flush;
 	int xdp_rc; /* XDP redirect return code */
 
-- 
2.25.1

