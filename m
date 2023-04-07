Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A4A6DB5A8
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjDGVCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjDGVCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:02:01 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C505FFD;
        Fri,  7 Apr 2023 14:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUv35ncAne/oolPPGUZKs5c1OTMWrOCVc5Keko+rT4Cqu0d7h1j1/iv4m9f02qa/km0IWKCzHzJvt9WCDAUjAOfPKGh2QjfKntn+JMaHGPSye5P/WfwD1+sRko31ngS5oe4jLbrd5To5nv2Py2bWpq/5zaE5sKacjQOcHtVUz4IAa0P3LU/+kU/y9ss3X3CeaY7WIvdGYTNw26oREUDL4aMaCMsIhWSxo/efwdxok9MhYXMKtFt5jbL6txCrFAqZ2viDvCmgYwGONv9gvp0GUm91eRcLVB2rMzIV38bvsgMyqGfSo7jqbtM1XdyHIQVWnFRDJtgwbTuXErI4/DqZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3m1pqC9rnOkg57acYq/j+VF+lS7p+a4oP88Kw6elqo=;
 b=PkRhfuJslBjkkglc8cWSfgmVKRxtdIxSXmH8W8UWJC9bEwoBiwICNnrm3AwrVVXoupZLl24HMR3XRs5KZHdByuFmammBAXTL3xthgcLFXIUQmTX5rRZdcD7tfZlajx+x0Rimnfo+XN/gaKDZyFJ/38epiM44BPTzSIxJOAJQMAQ2gnmY54m7faG6zarkScz3OSsdzG3zXgp+D7NsZxvkwxLzatW50gRB47FLxZRks0GJqQYpNykQ+3oBVcrzDjvI8fN8AoqVmheh8Y8wiRdm7IWWEL/EvHkNX2n2R1b2YRdIQYgJIydcB0r+Bsu5amKs547ZebLw2+oIlKxuBWnroA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3m1pqC9rnOkg57acYq/j+VF+lS7p+a4oP88Kw6elqo=;
 b=VkCl5EH05BxQRqvky1w/TDWY4dln/hk4dEV4XofjmZE5UiGbGKyYiPF17VFF2YOsF/oHEMx4quraCQmfmfkdoNLb8xFjMhmLKdTRISp4hrlxLScJrYK1jqRPStFV1Iw+UvAKPfyAcoo0dWfandMaNZ32QY09SvyJZTAsSVZ52qQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by PH0PR21MB1895.namprd21.prod.outlook.com (2603:10b6:510:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 21:01:40 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 21:01:40 +0000
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
Subject: [PATCH V2,net-next, 3/3] net: mana: Add support for jumbo frame
Date:   Fri,  7 Apr 2023 13:59:56 -0700
Message-Id: <1680901196-20643-4-git-send-email-haiyangz@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e5987ddc-e2cd-4e65-f0fd-08db37ab48c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jSIWE5VExjKQ73jj3E0QPSIKlX7kmRYJUwygv3yajjHmjypRSQW8PO2Nr+XwLEp3u3yBmuJqQGpd0KWcKFZt+Pg3JV6b7tZ3SRsQ1YTVLDos80HL0uHT5zq0Odp/oevD2w50H1xv+JPYWLTKHhfUXb0VKe2dl1j2eu9bxPNCYTTe2OeVbHha+oi41ymXu+2IB+gc6Xr02FiAaJ+tyvExm90mvVSN05s5In2UoDxqJ0YwS7F/Zeqd4oDhE3mS3MU1b5MCk19g5GFTbtDfD92LSRYdUgIBzp0bo7pPKANbcEYKHPiC7AAc0wrOb4+QlYA7Q9tZneu17ja5f6zlTjzIWYop+HkC/RFaZDftYPEPxBWzjt1vIrXeO2MJAK5vESxLL4jMCYdfQlRn5wYhHLgVYnpQHuwkgC+/R1RSG2n5RR40vYuYHWavTAQQISeq4HLK9wzhV7qzGd1cXr57y6es/NpWG24KVEl70SI7sL7Kzp9uNRMaKb0I5QQzgE99QT1K/Vmq5d+EgvqJodu2gJKAmAPv7A7w9bVwvtnLOz17nxjGeBGbaWaJXgFv+xDAtZs1lfP739MPPZ3a8jrNPw9z33chjZJ9DoFUu50zzTg5XmR+X6rezlj9xWmPxb0bn7v5FMvxf3pXNXDRx3+jzHTupCjoY+sWvaF6bwkCc8TjK5E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66899021)(66946007)(6486002)(66476007)(478600001)(8676002)(4326008)(7846003)(66556008)(41300700001)(786003)(316002)(52116002)(36756003)(83380400001)(2616005)(6512007)(26005)(6506007)(6666004)(8936002)(5660300002)(2906002)(7416002)(10290500003)(30864003)(82960400001)(38350700002)(38100700002)(82950400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?05bMkiQA+kWltp/E2HbgxxibnWw+zXVq0YQHB1HEhHSZPJgnhV73aHSybKDz?=
 =?us-ascii?Q?unPL3oUzbtG88gN7XaEx0eKKwxODyilUyUhDVEmisY6XnRZaCWdJ63MLXUBs?=
 =?us-ascii?Q?CYVCsMV/0otqE4Br/pHcDH2OBtDlSGrPWfFE+yEPamd11wS70T86UsFrxWkn?=
 =?us-ascii?Q?dq85Tn0MCUTYnIZqpM6unv0pVjI4rtUJ/BZFgST6Da287VcSxROTddNxN9JI?=
 =?us-ascii?Q?HMJ4dD7w1UPeKE0dRtLsVHEGHck8YAsL/lkQ106Q+PvvR7iUiHRft/Baei3s?=
 =?us-ascii?Q?36rQfu7J6PyKixr3G8RF/OEYN8fwVcWIlGLCM4SljrFoVwFW8D8/WYHjeDoj?=
 =?us-ascii?Q?zajRlc3agGRte/G5KdtC2uMBhFhfp9dyshZbJX4zec/yZeglIlyJZ9QYq+Kg?=
 =?us-ascii?Q?XvLn2KebDrIxTj1PsI8x9lL3Q2ArfSOoPujnSecUsvFsOxDplnw6eJ3od06J?=
 =?us-ascii?Q?7jhk+ldiYe2024xgrUEZnCa5pWd7VOXN0gORZo3tXsbNBRQFL8QZN3lbRjRZ?=
 =?us-ascii?Q?dhg4QMeLACqH82h0pJAFDLfDd4An4U7dbtl09ZRF+44v0dFwH9DivNB/F/Fl?=
 =?us-ascii?Q?BmVFFj3IO4p7xVVP6U6Ob1xRAYlObcbYghBGKWQPgODVupEWNfxnaU/KYu2v?=
 =?us-ascii?Q?zAm/GOtxf3WelrU398IKFa6ZodCrQ1XfPdLqQwMOVI1xK5hbeDWGci9LFRKL?=
 =?us-ascii?Q?ubw1JxysNBOKTz9jkMOP6S6ilvOJVbFrpLOghco447N8WpW028UzmCu/oB4T?=
 =?us-ascii?Q?I9+uULOlBCHklPLjad7sQXyQwH/uc8ehR48wqfdE71TiwBtJiv5aVmZ/+Df/?=
 =?us-ascii?Q?L1dn/aiuZWUagHHxW+AJregnAemFCr+SOIDRQJBBqPKAqwyg06MmG9ext7eD?=
 =?us-ascii?Q?m7779d5Rz9MdxIl2rsyQUJW/bGGT9wryzz+qjyGiX7L8P6Inbri4kKd37Upg?=
 =?us-ascii?Q?uu0ISqJJbabBzlPKWLUiG7BGPpdOqcWfqi6nvNPZy2W1JolZ64jw5ehJWwGN?=
 =?us-ascii?Q?coRRJlqylpxzVavGkXAga4IPtocnib+x1+L0mEHgR7qwuJxv4Xjgzulhv7tQ?=
 =?us-ascii?Q?xj2VZPgNaXZ6wuc5yQKS/mPIAoY8U0g3ghjSZLxSnNq9wX6X2rf1/mGOnJ1e?=
 =?us-ascii?Q?N9zXe4Glg3JM9aynBoSVri+eToqfewwUVAu7aBTexo7N5MgPG7Q+j9Ci3sMf?=
 =?us-ascii?Q?uFv/QlvsgpEjmxCDM2lYWMKOWJINhzVXqsTxpsidZ1AVnlZvzTDrJDBk3XO+?=
 =?us-ascii?Q?rLJUnKvFpIk5VOGeSfIsB+9qf81+VJEarZgOcOn/+UEOa7IPZZx/xUzqo9aL?=
 =?us-ascii?Q?F8+yZ77O6ay4rvjcS+URBoP851YjkLYoFe5jvAVlFyRTEx863omY4CprDKzs?=
 =?us-ascii?Q?skfuYGxU8vOwXv/SseFbAJFZWEOwLJW0OZl78Mnf8eIZgKdqXWQk/UwYcaRo?=
 =?us-ascii?Q?2LzSFeO4Qeq8oKuWguR9KypwpDg3frHwNEpkTkjCrzFE/2D+uRiaCbCXvS7L?=
 =?us-ascii?Q?cfclPRJgNp79Oaue/Vzn6AEd+fA5OSZKe8rgmrmhyVtCEw/DsFr6rqPxPS6U?=
 =?us-ascii?Q?QMXhg3A1TImr2SgesIGcBScWVgUZu3jtRk9m5ie6?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5987ddc-e2cd-4e65-f0fd-08db37ab48c9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 21:01:40.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UupPuuMjazRkghye4wGemDvWEEtetMYxGD25jUtyj5NQyOZDilx536FZiuKxYzCZo9HZXR5ACEp4Oh1bkezO0A==
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

During probe, get the hardware-allowed max MTU by querying the device
configuration. Users can select MTU up to the device limit.
When XDP is in use, limit MTU settings so the buffer size is within
one page.
Also, to prevent changing MTU fails, and leaves the NIC in a bad state,
pre-allocate all buffers before starting the change. So in low memory
condition, it will return error, without affecting the NIC.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
V2:
Refectored to multiple patches for readability. Suggested by Yunsheng Lin.
Added pre-allocation of buffers to avoid changing MTU fails in a bad state.
 Suggested by Leon Romanovsky, Francois Romieu.
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 217 ++++++++++++++++--
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/mana.h                       |  14 ++
 4 files changed, 233 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 3caea631229c..23b1521c0df9 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -133,12 +133,6 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 	return act;
 }
 
-static unsigned int mana_xdp_fraglen(unsigned int len)
-{
-	return SKB_DATA_ALIGN(len) +
-	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-}
-
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc)
 {
 	ASSERT_RTNL();
@@ -179,17 +173,18 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	struct bpf_prog *old_prog;
-	int buf_max;
+	struct gdma_context *gc;
+
+	gc = apc->ac->gdma_dev->gdma_context;
 
 	old_prog = mana_xdp_get(apc);
 
 	if (!old_prog && !prog)
 		return 0;
 
-	buf_max = XDP_PACKET_HEADROOM + mana_xdp_fraglen(ndev->mtu + ETH_HLEN);
-	if (prog && buf_max > PAGE_SIZE) {
-		netdev_err(ndev, "XDP: mtu:%u too large, buf_max:%u\n",
-			   ndev->mtu, buf_max);
+	if (prog && ndev->mtu > MANA_XDP_MTU_MAX) {
+		netdev_err(ndev, "XDP: mtu:%u too large, mtu_max:%lu\n",
+			   ndev->mtu, MANA_XDP_MTU_MAX);
 		NL_SET_ERR_MSG_MOD(extack, "XDP: mtu too large");
 
 		return -EOPNOTSUPP;
@@ -206,6 +201,11 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 	if (apc->port_is_up)
 		mana_chn_setxdp(apc, prog);
 
+	if (prog)
+		ndev->max_mtu = MANA_XDP_MTU_MAX;
+	else
+		ndev->max_mtu = gc->adapter_mtu - ETH_HLEN;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index e5d5dea763f2..cabecbfa1102 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -427,6 +427,192 @@ static u16 mana_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return txq;
 }
 
+/* Release pre-allocated RX buffers */
+static void mana_pre_dealloc_rxbufs(struct mana_port_context *mpc)
+{
+	struct device *dev;
+	int i;
+
+	dev = mpc->ac->gdma_dev->gdma_context->dev;
+
+	if (!mpc->rxbufs_pre)
+		goto out1;
+
+	if (!mpc->das_pre)
+		goto out2;
+
+	while (mpc->rxbpre_total) {
+		i = --mpc->rxbpre_total;
+		dma_unmap_single(dev, mpc->das_pre[i], mpc->rxbpre_datasize,
+				 DMA_FROM_DEVICE);
+		put_page(virt_to_head_page(mpc->rxbufs_pre[i]));
+	}
+
+	kfree(mpc->das_pre);
+	mpc->das_pre = NULL;
+
+out2:
+	kfree(mpc->rxbufs_pre);
+	mpc->rxbufs_pre = NULL;
+
+out1:
+	mpc->rxbpre_datasize = 0;
+	mpc->rxbpre_alloc_size = 0;
+	mpc->rxbpre_headroom = 0;
+}
+
+/* Get a buffer from the pre-allocated RX buffers */
+static void *mana_get_rxbuf_pre(struct mana_rxq *rxq, dma_addr_t *da)
+{
+	struct net_device *ndev = rxq->ndev;
+	struct mana_port_context *mpc;
+	void *va;
+
+	mpc = netdev_priv(ndev);
+
+	if (!mpc->rxbufs_pre || !mpc->das_pre || !mpc->rxbpre_total) {
+		netdev_err(ndev, "No RX pre-allocated bufs\n");
+		return NULL;
+	}
+
+	/* Check sizes to catch unexpected coding error */
+	if (mpc->rxbpre_datasize != rxq->datasize) {
+		netdev_err(ndev, "rxbpre_datasize mismatch: %u: %u\n",
+			   mpc->rxbpre_datasize, rxq->datasize);
+		return NULL;
+	}
+
+	if (mpc->rxbpre_alloc_size != rxq->alloc_size) {
+		netdev_err(ndev, "rxbpre_alloc_size mismatch: %u: %u\n",
+			   mpc->rxbpre_alloc_size, rxq->alloc_size);
+		return NULL;
+	}
+
+	if (mpc->rxbpre_headroom != rxq->headroom) {
+		netdev_err(ndev, "rxbpre_headroom mismatch: %u: %u\n",
+			   mpc->rxbpre_headroom, rxq->headroom);
+		return NULL;
+	}
+
+	mpc->rxbpre_total--;
+
+	*da = mpc->das_pre[mpc->rxbpre_total];
+	va = mpc->rxbufs_pre[mpc->rxbpre_total];
+	mpc->rxbufs_pre[mpc->rxbpre_total] = NULL;
+
+	/* Deallocate the array after all buffers are gone */
+	if (!mpc->rxbpre_total)
+		mana_pre_dealloc_rxbufs(mpc);
+
+	return va;
+}
+
+/* Get RX buffer's data size, alloc size, XDP headroom based on MTU */
+static void mana_get_rxbuf_cfg(int mtu, u32 *datasize, u32 *alloc_size,
+			       u32 *headroom)
+{
+	if (mtu > MANA_XDP_MTU_MAX)
+		*headroom = 0; /* no support for XDP */
+	else
+		*headroom = XDP_PACKET_HEADROOM;
+
+	*alloc_size = mtu + MANA_RXBUF_PAD + *headroom;
+
+	*datasize = ALIGN(mtu + ETH_HLEN, MANA_RX_DATA_ALIGN);
+}
+
+static int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu)
+{
+	struct device *dev;
+	struct page *page;
+	dma_addr_t da;
+	int num_rxb;
+	void *va;
+	int i;
+
+	mana_get_rxbuf_cfg(new_mtu, &mpc->rxbpre_datasize,
+			   &mpc->rxbpre_alloc_size, &mpc->rxbpre_headroom);
+
+	dev = mpc->ac->gdma_dev->gdma_context->dev;
+
+	num_rxb = mpc->num_queues * RX_BUFFERS_PER_QUEUE;
+
+	WARN(mpc->rxbufs_pre, "mana rxbufs_pre exists\n");
+	mpc->rxbufs_pre = kmalloc_array(num_rxb, sizeof(void *), GFP_KERNEL);
+	if (!mpc->rxbufs_pre)
+		goto error;
+
+	mpc->das_pre = kmalloc_array(num_rxb, sizeof(dma_addr_t), GFP_KERNEL);
+	if (!mpc->das_pre)
+		goto error;
+
+	mpc->rxbpre_total = 0;
+
+	for (i = 0; i < num_rxb; i++) {
+		if (mpc->rxbpre_alloc_size > PAGE_SIZE) {
+			va = netdev_alloc_frag(mpc->rxbpre_alloc_size);
+			if (!va)
+				goto error;
+		} else {
+			page = dev_alloc_page();
+			if (!page)
+				goto error;
+
+			va = page_to_virt(page);
+		}
+
+		da = dma_map_single(dev, va + mpc->rxbpre_headroom,
+				    mpc->rxbpre_datasize, DMA_FROM_DEVICE);
+
+		if (dma_mapping_error(dev, da)) {
+			put_page(virt_to_head_page(va));
+			goto error;
+		}
+
+		mpc->rxbufs_pre[i] = va;
+		mpc->das_pre[i] = da;
+		mpc->rxbpre_total = i + 1;
+	}
+
+	return 0;
+
+error:
+	mana_pre_dealloc_rxbufs(mpc);
+	return -ENOMEM;
+}
+
+static int mana_change_mtu(struct net_device *ndev, int new_mtu)
+{
+	struct mana_port_context *mpc = netdev_priv(ndev);
+	unsigned int old_mtu = ndev->mtu;
+	int err;
+
+	/* Pre-allocate buffers to prevent failure in mana_attach later */
+	err = mana_pre_alloc_rxbufs(mpc, new_mtu);
+	if (err) {
+		netdev_err(ndev, "Insufficient memory for new MTU\n");
+		return err;
+	}
+
+	err = mana_detach(ndev, false);
+	if (err) {
+		netdev_err(ndev, "mana_detach failed: %d\n", err);
+		goto out;
+	}
+
+	ndev->mtu = new_mtu;
+
+	err = mana_attach(ndev);
+	if (err) {
+		netdev_err(ndev, "mana_attach failed: %d\n", err);
+		ndev->mtu = old_mtu;
+	}
+
+out:
+	mana_pre_dealloc_rxbufs(mpc);
+	return err;
+}
+
 static const struct net_device_ops mana_devops = {
 	.ndo_open		= mana_open,
 	.ndo_stop		= mana_close,
@@ -436,6 +622,7 @@ static const struct net_device_ops mana_devops = {
 	.ndo_get_stats64	= mana_get_stats64,
 	.ndo_bpf		= mana_bpf,
 	.ndo_xdp_xmit		= mana_xdp_xmit,
+	.ndo_change_mtu		= mana_change_mtu,
 };
 
 static void mana_cleanup_port_context(struct mana_port_context *apc)
@@ -625,6 +812,9 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
 
 	mana_gd_init_req_hdr(&req.hdr, MANA_QUERY_DEV_CONFIG,
 			     sizeof(req), sizeof(resp));
+
+	req.hdr.resp.msg_version = GDMA_MESSAGE_V2;
+
 	req.proto_major_ver = proto_major_ver;
 	req.proto_minor_ver = proto_minor_ver;
 	req.proto_micro_ver = proto_micro_ver;
@@ -647,6 +837,11 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
 
 	*max_num_vports = resp.max_num_vports;
 
+	if (resp.hdr.response.msg_version == GDMA_MESSAGE_V2)
+		gc->adapter_mtu = resp.adapter_mtu;
+	else
+		gc->adapter_mtu = ETH_FRAME_LEN;
+
 	return 0;
 }
 
@@ -1712,10 +1907,14 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 static int mana_fill_rx_oob(struct mana_recv_buf_oob *rx_oob, u32 mem_key,
 			    struct mana_rxq *rxq, struct device *dev)
 {
+	struct mana_port_context *mpc = netdev_priv(rxq->ndev);
 	dma_addr_t da;
 	void *va;
 
-	va = mana_get_rxfrag(rxq, dev, &da, false);
+	if (mpc->rxbufs_pre)
+		va = mana_get_rxbuf_pre(rxq, &da);
+	else
+		va = mana_get_rxfrag(rxq, dev, &da, false);
 
 	if (!va)
 		return -ENOMEM;
@@ -1798,7 +1997,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
-	unsigned int mtu = ndev->mtu;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
 	u32 cq_size, rq_size;
@@ -1817,15 +2015,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->rxq_idx = rxq_idx;
 	rxq->rxobj = INVALID_MANA_HANDLE;
 
-	rxq->datasize = ALIGN(mtu + ETH_HLEN, 64);
-
-	if (mtu > MANA_XDP_MTU_MAX) {
-		rxq->alloc_size = mtu + MANA_RXBUF_PAD;
-		rxq->headroom = 0;
-	} else {
-		rxq->alloc_size = mtu + MANA_RXBUF_PAD + XDP_PACKET_HEADROOM;
-		rxq->headroom = XDP_PACKET_HEADROOM;
-	}
+	mana_get_rxbuf_cfg(ndev->mtu, &rxq->datasize, &rxq->alloc_size,
+			   &rxq->headroom);
 
 	err = mana_alloc_rx_wqe(apc, rxq, &rq_size, &cq_size);
 	if (err)
@@ -2238,8 +2429,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->netdev_ops = &mana_devops;
 	ndev->ethtool_ops = &mana_ethtool_ops;
 	ndev->mtu = ETH_DATA_LEN;
-	ndev->max_mtu = ndev->mtu;
-	ndev->min_mtu = ndev->mtu;
+	ndev->max_mtu = gc->adapter_mtu - ETH_HLEN;
+	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->needed_headroom = MANA_HEADROOM;
 	ndev->dev_port = port_idx;
 	SET_NETDEV_DEV(ndev, gc->dev);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 56189e4252da..96c120160f15 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -145,6 +145,7 @@ struct gdma_general_req {
 }; /* HW DATA */
 
 #define GDMA_MESSAGE_V1 1
+#define GDMA_MESSAGE_V2 2
 
 struct gdma_general_resp {
 	struct gdma_resp_hdr hdr;
@@ -354,6 +355,9 @@ struct gdma_context {
 	struct gdma_resource	msix_resource;
 	struct gdma_irq_context	*irq_contexts;
 
+	/* L2 MTU */
+	u16 adapter_mtu;
+
 	/* This maps a CQ index to the queue structure. */
 	unsigned int		max_num_cqs;
 	struct gdma_queue	**cq_table;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index fee99d704281..cd386aa7c7cc 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -37,6 +37,7 @@ enum TRI_STATE {
 #define COMP_ENTRY_SIZE 64
 
 #define RX_BUFFERS_PER_QUEUE 512
+#define MANA_RX_DATA_ALIGN 64
 
 #define MAX_SEND_BUFFERS_PER_QUEUE 256
 
@@ -390,6 +391,14 @@ struct mana_port_context {
 	/* This points to an array of num_queues of RQ pointers. */
 	struct mana_rxq **rxqs;
 
+	/* pre-allocated rx buffer array */
+	void **rxbufs_pre;
+	dma_addr_t *das_pre;
+	int rxbpre_total;
+	u32 rxbpre_datasize;
+	u32 rxbpre_alloc_size;
+	u32 rxbpre_headroom;
+
 	struct bpf_prog *bpf_prog;
 
 	/* Create num_queues EQs, SQs, SQ-CQs, RQs and RQ-CQs, respectively. */
@@ -489,6 +498,11 @@ struct mana_query_device_cfg_resp {
 	u16 max_num_vports;
 	u16 reserved;
 	u32 max_num_eqs;
+
+	/* response v2: */
+	u16 adapter_mtu;
+	u16 reserved2;
+	u32 reserved3;
 }; /* HW DATA */
 
 /* Query vPort Configuration */
-- 
2.25.1

