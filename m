Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1876E00A9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjDLVR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjDLVRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:17:47 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FF583DB;
        Wed, 12 Apr 2023 14:17:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6+LYtIlSIq0phkKX+YZf+mZdY8cQtpJxdGGgejYWI8u5AiwSEuaFzub9TAVLy+JCyEuZQVHD+c5aqRBq8zrQ6ogOtJbdXQ1MkYRdNYTYTcZLv6GHN1hdrzJaFm/bW41YZ9H5zi0ZBQ6WsNpxhQ348VfKnVcet8yzQW7owMqE2fic7l6293+R3FOV7cQtD7xjVogcfgiCAeEngLhutxCNysBBGE6OdfDjh4bAZJ7gx+KIG6l92vbooIXEtd1W96w1kG3fN+LQ6rqPG73wmTH+eNTfgJPCT/p9GeNtqT9NPAZk2EbxaRIzngK8SY9MNIoL8BZQEW+ARCPuzOpHXhPSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8tizL1EqHy1BSHsU3npwL3eMOaaizIL6pS+gHroG5c=;
 b=bJPXcTBIgnEQgh5uuqIQCuoOZVzXm5DVZY0P4WeRfUKH4/c/LOJrAqmNzTkxVGDeBGg6wh4Ohf0Syw7VSGY/yVRszCWVULaJHKCKdZUNsFTSmtwRiBwkbZcVALGWjYoE5ODhZoG9zniiEPJhDT3fXq1cLFFZdOPod/rrF+CK/wrfIwwzOKFVl39xaBUM9Lss/L/KT0VAh8SzBKOYLykETvS7m3tSEQuDAL0L+3NjiQ8IEVk2GDBFTkEEFkk8jeCQv9CMWt66R3zsg84uK243Sq3FxwYiGZA0JnS1q/ZTfH4sPk9DeCO/LIcAuWnkyb1js7WPondeP40tRD9G+i9FJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8tizL1EqHy1BSHsU3npwL3eMOaaizIL6pS+gHroG5c=;
 b=bz+jjq8AKfIXy7/VGXPprWgmjZ3TYQjbT6fl9s2DHMdkkL0fXHoAVwUyniJ1VBVeIHeiubgODPsye/yeBhAqe8cLrqTEXV9Udf6EkQ3JIEkSv8IB0QpXGHJ7TNlBDbOO6rphNEeFEze0qr0FaeuFTLIDESvLH6jU1aPGU4GgdQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by SA0PR21MB1881.namprd21.prod.outlook.com (2603:10b6:806:e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 21:17:28 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 21:17:28 +0000
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
Subject: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle various MTU sizes
Date:   Wed, 12 Apr 2023 14:16:02 -0700
Message-Id: <1681334163-31084-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15)
 To BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|SA0PR21MB1881:EE_
X-MS-Office365-Filtering-Correlation-Id: abb574b9-e36d-4c40-fb1c-08db3b9b5208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3n0OE/j6Lm3Ahnu7VNZ2hS5UMB3DKFUgIvBEg6KSBhFb9VvvqRaGK9rCsg1NNvyl46SarhixXs/RZw7vCzQ5ho4HLkNKXByaMmdhgzU/+KaDGCyDeDYrBGaW4dWgxRXuRWLWWxD3Jd+SV7NmzZ5nq+73cQe1XskTkw+0uYWLYrylV9ilC0JKCcaL4zUooN6HTOkt9G63zUR/RcHl3dXneR9+DCT0PNJsWqkvhaCzpiYmxC7Z56KpjE0NR0zg4YoKL6BrL7K64rBTKGu0CBTQ0okas1hg8XfnqT8Xk2czlOAzvFxxp3BxHPqpwMO+zmwvHl8RlfToET/Ijvakoxjyux5FYxluRavTiSOkdDVijBcgy4+majibjeI6QrFNhRbp297AcH1oZZ38MptFsOxGb0w5hI9RAEe9Ac8xOpTrTTuRCCY/Ph7CzsOt23iw/Afp6tlsrPPknZtSQUr1MXq/SKUyez+JIRAeceZcqNRBEqwbp+UHgtnL2sdPPm+Lj8o/73A0JccGoBql+Uq62cMAVWzi3DGB00Hhk3Tvb0hpixfunxJanaQjfUn5dBPzjqjb5WZzNIN1mlf3bsiXll7xxnQYEWuKIaOIDDy2b986gO8th681/3IqgUjhRzY8F/Nw7CUon5m0Dhmi1GqOiVPT79+b4jdv3lu8Hh+L66tNtj0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(8676002)(38350700002)(38100700002)(2616005)(83380400001)(7846003)(186003)(478600001)(52116002)(10290500003)(6486002)(6666004)(316002)(26005)(6506007)(6512007)(2906002)(5660300002)(7416002)(36756003)(4326008)(82950400001)(66476007)(66946007)(82960400001)(41300700001)(66556008)(786003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xw0SxVxKNDhCMT8NJmSeS+V+8jsmoganlZVV5LdrgYmnBwQTh8c21z6M4sdY?=
 =?us-ascii?Q?WuGyVwYAouNrRxMxef0DDRdi8L7a+sCBf893IdaWNHMiSItp8rMaNSgh3JRK?=
 =?us-ascii?Q?bBcvd3h8vE6pP6HRGj6LKVkDWcR7rhrjbSjT0U8FnNlYA5HoqTslFTKdGjnE?=
 =?us-ascii?Q?CuJ8LovBl3kkmYZGTrrVZ1fY2uSrqgM07ovYndbzNDq5cnSbTsFsSj6QMXXC?=
 =?us-ascii?Q?8I74LgZOzsIsUf856a77wCgyxY00CCCs6Bsf+VBzIXXIPCeUgE699pdgKOu2?=
 =?us-ascii?Q?p+04pjLKQYji5h22AzXjHFjkr0Ouky7kk+MvFL93PvS0rNx+HMwY4b7m95oY?=
 =?us-ascii?Q?K5CqeDqPbv1vwGFG4O6Yatb1/UVujz/qP9b4yv2UyFmnnglnTriMtDBw1Uxm?=
 =?us-ascii?Q?nOKd4vTygEwCNjGJNONMZ1gA+0yWseXuf1XFXwwKe1ZmXxHYpvjnTnUUQrwU?=
 =?us-ascii?Q?FoimDlCu0R2Tb4HA6bDsL7gyLeSk953mGAd1TrrLKYrNQyrfhi1dKeDA5KMI?=
 =?us-ascii?Q?yYFeNvgeiwPMRSjyu2T+3g+j/kiFPLQFIXUYJmR7lzvpyqkNKj2guypAfEKy?=
 =?us-ascii?Q?RuVmx/j6qH8jYrR6dh1hvJTkcVWoult6t0iRdB3fbzWWtYLzw1MYWYABnQjh?=
 =?us-ascii?Q?kgANiSX3jIdAN/AKbXE8008Ct/mL3Fo8j7fnne0VZS0MSztRCgE7fZcTQD6A?=
 =?us-ascii?Q?lhyH4++papfXUEynktJW/gRO+Z9jymeGWBpXjlHvf0RSGSOH4t5Urc0EFRG9?=
 =?us-ascii?Q?y5zHt23oaRF/I/q5Q9GiB/rC/6O9mjJYgDkIXsBk2iLh5k6UOODLuIIi3beP?=
 =?us-ascii?Q?Pq4oXiae3j6FmgUr3pFAlDhoOKMGDOkp1636bZe0aC58TBwW2mgGt3QYEpqN?=
 =?us-ascii?Q?vutwPgGey5xxslN8jwTq4l0Gl4+A8ECtM7sKXQgO4jy5NHLuOcJt0Qw3fVFA?=
 =?us-ascii?Q?Tz7Vv4gZpWXVwPGHe6CakpWKlL3CEuUIAhwER3fa9Yt81zurRzNw4F9ekSzB?=
 =?us-ascii?Q?XcuGJdL/RHxH8V/QKycKkBx03EeeHuN2NvjTAhG8bwHCB52kKgiSGAhSnlg7?=
 =?us-ascii?Q?nR4t0ZyNRdtmr6MI2RLdVPJdcQLb6mFvUVFN95Q2wx1EaTe9yK1hNpalCDWL?=
 =?us-ascii?Q?ibpNb818buPFeY0qDECxat3/964lfBOrUtcWJix14CDw2s9d1bKLtgKCMJS6?=
 =?us-ascii?Q?W+FHZ3vgiiEXSVIb/PR8K62M6aFSxomB7HAUqBpUJqzamEPh5Y+4dVI8X3GU?=
 =?us-ascii?Q?vAQfUkNZuYx/PKh4cLO3C58Bsh3+SYbZa+wjFWSCjlMblxB3DUHDQ5X1z+QP?=
 =?us-ascii?Q?NCQB5v48RDesDsUiiIUJRllbnGFFvlukfsyatD4oI/YTJy3vf5L8lzL8vucf?=
 =?us-ascii?Q?xEhrnyRCEMOl9hZd36pLeO5BHoo78FEb6C0LnA2KwRByWliVf40FJOY0Wakf?=
 =?us-ascii?Q?JkKBqGoTz0AVTTxU40WoJOMNBeo69mTqo+tWb5TQedfA6obUZaTdtHXq8kGi?=
 =?us-ascii?Q?hk8GRjwH2gZvFjRqrSQ6WkRQBsSL81lNyQSAZ67GGD6PfmTT0wfoBZzJG6hD?=
 =?us-ascii?Q?Fs7VPn/9ztPCh/2DwYE7j5dN/4Hd5o6g6evjPltq?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb574b9-e36d-4c40-fb1c-08db3b9b5208
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:17:28.6625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j77kurd4kyNl5ULfinzrAzHBK/oftzlXH9pW7ZCExOhB3pnYRm2x4y4+JJ9k/Hc7a4Ww64ZkposUmjFtVBS6Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update RX data path to allocate and use RX queue DMA buffers with
proper size based on potentially various MTU sizes.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
V3:
Refectored to multiple patches for readability. Suggested by Jacob Keller.

V2:
Refectored to multiple patches for readability. Suggested by Yunsheng Lin.

---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 38 ++++++++++++++-----
 include/net/mana/mana.h                       |  7 ++++
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 911954ff84ee..8e7fa6e9c3b5 100644
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
@@ -1301,6 +1302,14 @@ static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
 	if (rxq->xdp_save_va) {
 		va = rxq->xdp_save_va;
 		rxq->xdp_save_va = NULL;
+	} else if (rxq->alloc_size > PAGE_SIZE) {
+		if (is_napi)
+			va = napi_alloc_frag(rxq->alloc_size);
+		else
+			va = netdev_alloc_frag(rxq->alloc_size);
+
+		if (!va)
+			return NULL;
 	} else {
 		page = dev_alloc_page();
 		if (!page)
@@ -1309,7 +1318,7 @@ static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
 		va = page_to_virt(page);
 	}
 
-	*da = dma_map_single(dev, va + XDP_PACKET_HEADROOM, rxq->datasize,
+	*da = dma_map_single(dev, va + rxq->headroom, rxq->datasize,
 			     DMA_FROM_DEVICE);
 
 	if (dma_mapping_error(dev, *da)) {
@@ -1732,7 +1741,7 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
 	u32 buf_idx;
 	int ret;
 
-	WARN_ON(rxq->datasize == 0 || rxq->datasize > PAGE_SIZE);
+	WARN_ON(rxq->datasize == 0);
 
 	*rxq_size = 0;
 	*cq_size = 0;
@@ -1788,6 +1797,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct gdma_dev *gd = apc->ac->gdma_dev;
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
+	unsigned int mtu = ndev->mtu;
 	struct gdma_queue_spec spec;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
@@ -1807,7 +1817,15 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
-	rxq->datasize = ALIGN(ETH_FRAME_LEN, 64);
+	rxq->datasize = ALIGN(mtu + ETH_HLEN, 64);
+
+	if (mtu > MANA_XDP_MTU_MAX) {
+		rxq->alloc_size = mtu + MANA_RXBUF_PAD;
+		rxq->headroom = 0;
+	} else {
+		rxq->alloc_size = mtu + MANA_RXBUF_PAD + XDP_PACKET_HEADROOM;
+		rxq->headroom = XDP_PACKET_HEADROOM;
+	}
 
 	err = mana_alloc_rx_wqe(apc, rxq, &rq_size, &cq_size);
 	if (err)
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 037bcabf6b98..fee99d704281 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -291,6 +291,11 @@ struct mana_recv_buf_oob {
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
@@ -300,6 +305,8 @@ struct mana_rxq {
 	u32 rxq_idx;
 
 	u32 datasize;
+	u32 alloc_size;
+	u32 headroom;
 
 	mana_handle_t rxobj;
 
-- 
2.25.1

