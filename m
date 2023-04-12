Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426336E00AE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjDLVST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjDLVSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:18:05 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D686B8;
        Wed, 12 Apr 2023 14:17:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCMN0bXLdigV3TrhgGLXDYu6dtxTLZBhHPjhV8e0X68YCv0rbkhk0WnCoIRMkE9jifE5HVKLAY9tjjX9EQ646+0FyGNR4HdkfeFn0CYFxUqS0XNaNcYKKb+9sp6j+oJIj/3LVHG5pROnw1KHDMv38XXxAdQPTnOiSCpDA2gaBFwLDaEYe7L3IFWb32slqZaI49la0W8RQGoM+uy1QOk7lI1F/vsM1gbNRhpDO3MzuKITtlpKx69ur87B76hPgMq5Lf/hVB6M4TSUJ8VP1yZWLp6dBy7lqBBpsYMaAKfQ3PoupaxfRTEMguCcrenzG7sRjimGXsWJzd+ShSw68kiEUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y25lOOt/RjK+hbGWqFQsq2bS5JCsc5PO/B1QXAj8M1o=;
 b=bLSEKPMd+TgctZCNBfxD5iChOLyqij5j9fRwlw7JahvEO+i7thJJU3OSKX1rqPm8rSJP3aMwutSM/nHU+oTnycLepUyGQo+3yJcwedEXuzXRxbyJ5+bzYRiqS+wXUtYl5VN15P+oEsRgl+X9vQfSp5EkRkmihGDMNJlJdAHUk6aSSy3BJqTGSS6AdTIHX29gs6MXCHJEaPs9Q5ZipxQ5sSLQwZUiLNfmHbRMNiNZ3QNQVr455MGAz2tk6+9c0KmB8lLvjNARvBSvNDT+deGQ4+zJvEbP+kq64ySVzKP7yaa8PC4leaicGyrexE3M8259+g23aEqG5WYgd4NlxA6XHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y25lOOt/RjK+hbGWqFQsq2bS5JCsc5PO/B1QXAj8M1o=;
 b=D2LTcCXkc5LQaDgbtfyC4eHm/BzTi4Bm9qDbqPSTYm1QOdZu18FWaQitb+fYLqurFouA0r5IxpL8n6kUzUXDzJ7oQh45BwHKhQeY8UZZHcadxExSR1UmFl682TCJHour1sBFrDgC+aQfDH4CmwMJQL0AkAMgI4jF4dLb961C25o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by SA0PR21MB1881.namprd21.prod.outlook.com (2603:10b6:806:e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 21:17:32 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 21:17:32 +0000
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
Subject: [PATCH V3,net-next, 4/4] net: mana: Add support for jumbo frame
Date:   Wed, 12 Apr 2023 14:16:03 -0700
Message-Id: <1681334163-31084-5-git-send-email-haiyangz@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e9e7d3ec-ddd7-43ab-3a50-08db3b9b546b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpCkAB4fAWPl5D2BfbSCbcT5HpF+Ju1r7AqZ3CiFpeaNrhupengbEZqMXNY2gQ7GOPTqc6zAyT8dIDBJZrHNJ3XfIVntBN5dfgFzLexiOQwcJdAlLn0XkmzR1w0mfgRqyifbK4u09A+HIlSkr/besVW8/Cue1yH4N6RvJhFF965iEinGkoGbWqaljp5/HLODDFt1Yy9TbkvaBqZhPvvlRmLGOCz6W8CqYtgfkvlc1cdWUjVGgEtkgb1GKGMTcgwc5G0/obZlMT9U9jfGtpm4+miQHtJvHNsU76LEeLJa7X+2Nt4YY47D1g7KPOfMJcPJO5MVluh5si8wKnMK/Xv8dmGVNwWZbNgqKHbdoPKKH4435rwlucarXO2Nx5EV7TJW2bXXzwm2kt6tdNZkUiVxilTW23ZxLfVmJJtg1yqGAm85jJy/jAjwTcq9mfo5w6lBsR3+fFAWwFDPNINgivbaeojOyW6LXR29M9FBLDn8bUltI8TpJMahlbuRlcIXFl55BXZnLm93SxuGVrGrTLdr+PQoA6UZeMHN8PC3sWrC7/0DWqjeO/uGbVoiCMvbPO5RjZZqAsj7QQ4wi4QW8Fg/ey8f4ZQgeyrZOXcVCkxNKPbgWXXo5VA54KV3j6F65DCwNSG8Zm2JsxcemXGwa1e4zAosfgdG+IoBruT9mjP7hOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199021)(8676002)(38350700002)(38100700002)(2616005)(83380400001)(7846003)(186003)(478600001)(52116002)(10290500003)(6486002)(6666004)(316002)(26005)(6506007)(6512007)(2906002)(30864003)(5660300002)(7416002)(36756003)(4326008)(82950400001)(66476007)(66946007)(82960400001)(41300700001)(66556008)(786003)(8936002)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ydq1k+dSyqgCqQX34jqSQZFtqDZ+/xH3cFK9XF0L+NdY+pGVifQvT+oLBaYg?=
 =?us-ascii?Q?KoM/hxbT1EG4N52YjwE2d2xckbHgF78cojwKwua4kHYUKEwb/t/h95VZgpm4?=
 =?us-ascii?Q?JTQ2mqk5vt+WPDjGa84Z8pVYt3Qv6zflyHl3vV2NxDweeEikQT29kFzAFv3K?=
 =?us-ascii?Q?JWiqFmSlbPZhK9kHUsejBOOamFLZnhG18w32iK7gxnIVL3tYeVYeHVbZZLak?=
 =?us-ascii?Q?bOYu1MvxzfNsMRNy8YypT9bker1yKFNJIUHAJfn6jJDwn0JxcOxvUFZY0i1y?=
 =?us-ascii?Q?Ecxin0QyhhMyd/8FvIEXsjQ7FHYDzECLJWyLJOecnqrgx8GI9NCznZgGPVkL?=
 =?us-ascii?Q?hWpvo1F0mtYvJlZV9Hf6gmuSJ1ClGv4IwM4P8/pkyE8kjHsB4OIMD+kCXe+2?=
 =?us-ascii?Q?Ku2tOFFaSLoVp7qt0W/PKbi599+YMbtYmcYAwMWge+wOVo1+JRz+yMx35ug5?=
 =?us-ascii?Q?Q/8Gk6zGOjAyYdadrPK1SABtLejm/Y8XyBMiBRy5PkL0U1ieFPEoRsSrPDDy?=
 =?us-ascii?Q?KMRYpXzWHQyYntXPVvVxeJrHITb8eSUh7oT7OuwwF7x4FhbsWUmBDULsxd7G?=
 =?us-ascii?Q?5V3kqHpBT9r1NEGqTDNmvmhiwcdBFAIF9deE9Hf6go/yEhzWkbPPkOUvEjg5?=
 =?us-ascii?Q?naCqalmsJ9PZOyGen4L+YriCeaPDHmk1Gx8oQCE9uHKbYPVD53TyfPnfMwmR?=
 =?us-ascii?Q?i1mqzhuKsSZ9nuuWlyaevOeNO30PAsWYucmBsiElpSEwL3tcvGxPvPTT+bvZ?=
 =?us-ascii?Q?xhX6yEvaAVYn9RirtHqa2ZpUWvCFX1Edpi8rez7RiKs5P/k3GMcHL/dXTOm4?=
 =?us-ascii?Q?r/0GdH3R4hQxHbrvqd1oY3maIMUYqBSZkF334hK8y4YwfPZRVhFgVS2Ug6uM?=
 =?us-ascii?Q?Z+V4ueRlqHpzuWkCUghh2bMXehWTmn7qdUnPGldjKNUXE6Wjg3BAfgjcql60?=
 =?us-ascii?Q?Dze9bwGlJ708R3ywiBMnw0kMH0uM0tEHJ1s4PP1WS3QDUvLwiCZ/hGzxYHag?=
 =?us-ascii?Q?VSnic1vBvCcE1Qke3H3OyKyZjzXapvyc+qh8IWYjpI3P80XKvK6pbDG8FkSo?=
 =?us-ascii?Q?wtS/hsCBwaJkpP0OybwP7/c53jzEqcfuuvSWbOPIMif6uduuE3Gpp1kf1SwM?=
 =?us-ascii?Q?GaQem50OP67kZ3grsAvy1SpKztoS8y2FMgctceoq7wj4buiScjox3cmPlnhW?=
 =?us-ascii?Q?DWLvxXHJIvNf7n1p4f8GEouzKoZ6FB87YCT5foS+PwtCUZl6ExrGwuokRsFb?=
 =?us-ascii?Q?uAu7u5ndXESE1VodojuJ7dOUAbr5q+RXk14bwW0Hqh/FwcMpFuU1QRSFdlHg?=
 =?us-ascii?Q?JqY5LZd3P8Rn1IlBQPppo9C+d4KnP91m7SwtLtJMuV+qWhP2Uu4gniWXwfFA?=
 =?us-ascii?Q?kjnWesFHjuvrI8hpJwLnTRJubpNYkMjfItJf2ES4fZJGFX5htp+TGcPGOdR5?=
 =?us-ascii?Q?zls/Nj0cdcPm/hVzL4PZsSkEk6sf9/m0tHLPOSFanSfN+0f7THFly9Md/BWK?=
 =?us-ascii?Q?CvpmuRSZOkCchOW6qdsgVCQuPCx498WyYhmRiumXEiv+Ld0KDJSY1Kca77Ue?=
 =?us-ascii?Q?8QJYxXzQbJe99/Ck48Fe1TSFDeLDTHGk4Ww9NYQq?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e7d3ec-ddd7-43ab-3a50-08db3b9b546b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:17:32.6702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRAweadqCWlhd+s9eop8qRx49pOxs4vJvw/2+bUTkmKJCyRfkBC9cCZUAMnzqWiCBfxcfHOAQMuIFp+D+fcKRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR21MB1881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During probe, get the hardware-allowed max MTU by querying the device
configuration. Users can select MTU up to the device limit.
When XDP is in use, limit MTU settings so the buffer size is within
one page. And, when MTU is set to a too large value, XDP is not allowed
to run.
Also, to prevent changing MTU fails, and leaves the NIC in a bad state,
pre-allocate all buffers before starting the change. So in low memory
condition, it will return error, without affecting the NIC.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
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
index 8e7fa6e9c3b5..cabecbfa1102 100644
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
@@ -1797,7 +1996,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct gdma_dev *gd = apc->ac->gdma_dev;
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
-	unsigned int mtu = ndev->mtu;
 	struct gdma_queue_spec spec;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
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

