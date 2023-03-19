Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266546C0592
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 22:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCSVa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 17:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjCSVah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 17:30:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2136.outbound.protection.outlook.com [40.107.92.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3681E9D5;
        Sun, 19 Mar 2023 14:30:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xr0aosI1rCAeRb9nhOTFj0nXy5XTigg3emDk3gDl8s/2hxUkCsYT4d3CS3dwOv1k8Li4VKl6ADBP4+k7u9IcWbWLOmA2cu1yXVQ5dKxhheStuJmRuXcY88atc7o7jFVikQwsi+qfbWZdgVqQtBxDj7YtUHZmOVYk/EZiXj8oesVuMCmt4e2kRrX0Nq5h3Bjtt4ln+vEnKGyW8uGqmrqebj38yVfSLzdZpzU7703rF6F4sktj+R5bxsGtsYkMwYi5wGsB0pGkbSZ7efRwJANVVSUkep2yokdKc8VD8Xj4/C1bE9eocNku6H2GLwMCTZyv2rbXVaja5yc95xRNoFYBSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KVEKpjQh3CJCPY3woYsmOTYuh0laHBon7sfhSfTzT8=;
 b=oXE5WKamGFSRnVi62WmJHmaGUpmneWQdJyFxbUvABNgY4UVYbnFfFUb/NDJcbmpJ37kLNmCK9uOSvfKxZrxwbImLiDXrNoQS/TNS/lsazEJp6/GgT/t2BjcIyvEmT9Ef66lnExOCipPVzSAbcnkTP+lDm9bmxVIjvayc1G8fhTjY7YblL1YivF8Sfy62zS6svuYrho4HclaqHK0KVyJ6kN7JWXXL0eD2pFSJlaFSaE48FmAdXMCm+mcAk6F9m1qDE3Oor5Jbq2Fd0wKSyvqSpw1HbSst96HmVSrA1Z2XehTj71d3in8l5IZJjItenF0xQunxNi3V3L0hMKQRLTFjAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KVEKpjQh3CJCPY3woYsmOTYuh0laHBon7sfhSfTzT8=;
 b=WqZjtF9aKXbtjgHBwyNaYwXgfpHT2zjnvzw+5GMQLvmuAt/83fifS4QFKB6g5z40AZSd2/4mtBB2kgDfc7dEGT+09slYfsgxrktZ4GoGtZgSALhWOlX6hZQNRQQfislNjktwM6behYIZ9Su9gWRmhbC2Tuky8ylM+9TBDwHgqL4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by CY5PR21MB3661.namprd21.prod.outlook.com (2603:10b6:930:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.0; Sun, 19 Mar
 2023 21:28:24 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6254.002; Sun, 19 Mar 2023
 21:28:24 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mana: Add support for jumbo frame
Date:   Sun, 19 Mar 2023 14:27:44 -0700
Message-Id: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:303:86::15) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|CY5PR21MB3661:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c98e3e0-581d-4bc2-5029-08db28c0de58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6E0Tgg87mt/Q54xiaHdKy5MzoF8iqw+SOUMq8worhVmTG88w1o/0syL9ZemJoZZQVLZyHNvUjmpTaiJpImBf37WWUDv4DOcVS5IK+r7vLcKHDMLVhPhmImyraMTZ5+/M3xKKkdS8zePXM1acRqAaeewSpYI4R/gh/liMGW4gKgATR1Wcb1cwEGQhq4isFvsYRNrmErYRjMKI2J2mFHZZc+L+/7kRDrh5bZvN4FIJOg9OIvqZK6YQI1UlwXjd35J79rTU1sYyXmM0t0SGL8si3JpGwkmEih6b3DQZI+uMuOzIBhxrUJhZ3FfTqShuhNpSoBwyIVDYD0m0bOwEzIbFu9xKkjyEtpuUY0pHcA7wXS8UnQqtUUuBI/+yXks4+XjRn/93L4spcDex0W3ruRWXtsC3Zl0Tvvg/tG+2l2brBsnRP77DSkKIK/DEVj9HDagE+40k/OTmwdpi/BF8WkXhtQVfoKqGzNUYEW+4VQ8f04fMileXVeZLFVhiZfiD6hIkvLFfcWRkig4ScB2lmbDZLGy3txPFFO09DgSw8FtMA8ZqZuLpDbcv3UgwsqTwK8fWzUTN9tS8MKMJFJPrIvKjDMCd+LZXCl+fZXs1AklBTAeZBF8uSaWCKddGhY/Q4kBdx08SeEm/xSgmCBM6skDMW1BqD4hZGPrbOWpHgk7pWki3YHyeWfM5NQXjPD6+pl2MFCHBsZLXqhQrGicalzN1LdRyB/GDf2+5jB5epU9oiFBTN/rYi+fLvoSYJvyMnGYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(83380400001)(2616005)(52116002)(38350700002)(38100700002)(6486002)(7846003)(5660300002)(41300700001)(36756003)(82960400001)(82950400001)(186003)(6666004)(6506007)(26005)(6512007)(478600001)(8676002)(10290500003)(66946007)(2906002)(316002)(30864003)(8936002)(7416002)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k3qbT90LnFQYkEDRKjKnCLpmLAK6yZ0osRC/3zE6hn2fi7jMok+WIME2Sre0?=
 =?us-ascii?Q?0LAScLjCwb66h13fWP6sHnvfLn33uyzYnVU8h8VHi8SZhhKg2rqD+Zp2QZ2d?=
 =?us-ascii?Q?qvfL1twuvzexPalL5HM/5mevCCBChdOnt6zOocsDBY8JH+082Z78A+021DG0?=
 =?us-ascii?Q?/XcNErmKuKoePp1la5IQlS+4DdoFjRH7TbPZf/0ex8I+pD1BwvPjl+gAktTS?=
 =?us-ascii?Q?mOgkO9Bt0dpOwV2OXVdonHNb8aS1Vv1Hs6bDI44XF1Mjdad84YgcD9GFBfk0?=
 =?us-ascii?Q?jMEU555vFoeSp89bMuRZcNp0YFSDNRpV0Id5mVa/uEIz4xFVoeyA86sVTYCu?=
 =?us-ascii?Q?AAb5ZwiTWm6zxsoMknzHLsyaG2Y9rrnWcbum0g3ZcJ7FcHLEaRhdLnbrlGXm?=
 =?us-ascii?Q?Yk0TXukd78E7FBLc/Fd+B3DTh+C0/47/wGrxO2SZoeqHOT6Q7EX0+EKNRAYv?=
 =?us-ascii?Q?iI+kZVXQ2NdxSmwd1cBUnHaXNNrVZA5HAHgs45+xIswul70pJRZYgqNf3kON?=
 =?us-ascii?Q?o5PAEtYIhNji2peON21acBm1tfNbNWbvIbnr4GK7OxGT1kt1ubWuIgj04/1r?=
 =?us-ascii?Q?0qA585kCPpfJ3MwOjg5u8GrSl1y4J1ri0KphhLXie3X68m1X1beLkUJ1zjC1?=
 =?us-ascii?Q?xbOjicGY3rhGuF6sYpofxgOdZNydB3BlhWjtcE8AOPsyeGWw8PFxXo4R/fEA?=
 =?us-ascii?Q?lTfqcPN1lI7sl7echimPVFMaioI4PvZ4ScIuqgQS3UCCi7zEph7TfTlX7SJo?=
 =?us-ascii?Q?0Z3oj5bforDKQTdLrdcs/HerDtQU9Y+v1nkLofaqt67atXG41cDNS8MD6CLs?=
 =?us-ascii?Q?vJOfVtyhjupvn+LQ//ahG2PEm3K9F1+O011sADgIdmxc5dnooxngKEadKeqP?=
 =?us-ascii?Q?drQgEt/4xcKc0WDsBbSuFOjBnPBLupXfN5jobSoLZEJvwb6MsygXNNa2yNrT?=
 =?us-ascii?Q?Dg8LmBLB6JKCuhWKrPa5EoNatGWJXvIQN+WO1DkNwbZDv4rd0PNMrLcvUQ13?=
 =?us-ascii?Q?9a6H7GPkEXju/9llUwgWrY0auq/mGef4BrLYXL405xTjZiRLHypnQYpwq9nR?=
 =?us-ascii?Q?+8AAFT+wWbZKUyV/KffO1uSZcqF2/HHY+hkQfG3Z4/foH36piijCTOJCiNjw?=
 =?us-ascii?Q?1LW2NhLYxwjwl9T79XPXgHnqPbr89Vn4Wohkn1y1HmaiYwWPrF3fIf6ZsLfW?=
 =?us-ascii?Q?adyKSvf8TIodQj9g98z9yR0SZscO+u+yLhe24Yad9OSTj2u0moDAfxcVDBkW?=
 =?us-ascii?Q?yv65H6p6GCQzQhXydQ0lH96P3l3LGc6aQ6uhoGtNesT4Bc/2wU1fzZW8IaHl?=
 =?us-ascii?Q?piCKdd6dPdzwKHWCbi8cdzhubjQdXakO2F3YpkM038Og1BURoGU+PIfmb/Bw?=
 =?us-ascii?Q?/j+3Lds3Ccv1XNA1jm3sBc0ZsrNJ4kI5UbS/lIt8wwiBXXdfQWNFZxAOZOKJ?=
 =?us-ascii?Q?N+WfFU91nkcavdhXXmjW0YqZ4PDwIwHGA2syuEZsvIClZq7St8+544mi6/ZH?=
 =?us-ascii?Q?NkbkcTr8cXn+mo44JX/r8ZGbx4o5JdEs/d1i1WHRx3wxcbEQEvaYbtS/xk8K?=
 =?us-ascii?Q?KTHm6FKyrvxiMCg1cXh/85LYd0UcSzO/qbthJVC5gpRVZeUCbduHF0Gw5Qlq?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c98e3e0-581d-4bc2-5029-08db28c0de58
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 21:28:23.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pa7HcbfIRUHeVtd4Z/BQ1H7kHIANtLUy3ymAgbOkx3bUklFDpvCKZGpevcog4AxE56nfW3B/uw1da/qDx6E/6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3661
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During probe, get the hardware allowed max MTU by querying the device
configuration. Users can select MTU up to the device limit. Also,
when XDP is in use, we currently limit the buffer size to one page.

Updated RX data path to allocate and use RX queue DMA buffers with
proper size based on the MTU setting.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  22 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 229 ++++++++++++------
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/mana.h                       |  18 +-
 4 files changed, 183 insertions(+), 90 deletions(-)

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
index 492474b4d8aa..07738b7e85f2 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -427,6 +427,34 @@ static u16 mana_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return txq;
 }
 
+static int mana_change_mtu(struct net_device *ndev, int new_mtu)
+{
+	unsigned int old_mtu = ndev->mtu;
+	int err, err2;
+
+	err = mana_detach(ndev, false);
+	if (err) {
+		netdev_err(ndev, "mana_detach failed: %d\n", err);
+		return err;
+	}
+
+	ndev->mtu = new_mtu;
+
+	err = mana_attach(ndev);
+	if (!err)
+		return 0;
+
+	netdev_err(ndev, "mana_attach failed: %d\n", err);
+
+	/* Try to roll it back to the old configuration. */
+	ndev->mtu = old_mtu;
+	err2 = mana_attach(ndev);
+	if (err2)
+		netdev_err(ndev, "mana re-attach failed: %d\n", err2);
+
+	return err;
+}
+
 static const struct net_device_ops mana_devops = {
 	.ndo_open		= mana_open,
 	.ndo_stop		= mana_close,
@@ -436,6 +464,7 @@ static const struct net_device_ops mana_devops = {
 	.ndo_get_stats64	= mana_get_stats64,
 	.ndo_bpf		= mana_bpf,
 	.ndo_xdp_xmit		= mana_xdp_xmit,
+	.ndo_change_mtu		= mana_change_mtu,
 };
 
 static void mana_cleanup_port_context(struct mana_port_context *apc)
@@ -625,6 +654,9 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
 
 	mana_gd_init_req_hdr(&req.hdr, MANA_QUERY_DEV_CONFIG,
 			     sizeof(req), sizeof(resp));
+
+	req.hdr.resp.msg_version = GDMA_MESSAGE_V2;
+
 	req.proto_major_ver = proto_major_ver;
 	req.proto_minor_ver = proto_minor_ver;
 	req.proto_micro_ver = proto_micro_ver;
@@ -647,6 +679,11 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
 
 	*max_num_vports = resp.max_num_vports;
 
+	if (resp.hdr.response.msg_version == GDMA_MESSAGE_V2)
+		gc->adapter_mtu = resp.adapter_mtu;
+	else
+		gc->adapter_mtu = ETH_FRAME_LEN;
+
 	return 0;
 }
 
@@ -1185,10 +1222,10 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
 	WARN_ON_ONCE(recv_buf_oob->wqe_inf.wqe_size_in_bu != 1);
 }
 
-static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
-				      struct xdp_buff *xdp)
+static struct sk_buff *mana_build_skb(struct mana_rxq *rxq, void *buf_va,
+				      uint pkt_len, struct xdp_buff *xdp)
 {
-	struct sk_buff *skb = build_skb(buf_va, PAGE_SIZE);
+	struct sk_buff *skb = napi_build_skb(buf_va, rxq->alloc_size);
 
 	if (!skb)
 		return NULL;
@@ -1196,11 +1233,12 @@ static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
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
 
@@ -1233,7 +1271,7 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	if (act != XDP_PASS && act != XDP_TX)
 		goto drop_xdp;
 
-	skb = mana_build_skb(buf_va, pkt_len, &xdp);
+	skb = mana_build_skb(rxq, buf_va, pkt_len, &xdp);
 
 	if (!skb)
 		goto drop;
@@ -1282,14 +1320,72 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
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
@@ -1299,10 +1395,8 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct mana_recv_buf_oob *rxbuf_oob;
 	struct mana_port_context *apc;
 	struct device *dev = gc->dev;
-	void *new_buf, *old_buf;
-	struct page *new_page;
+	void *old_buf = NULL;
 	u32 curr, pktlen;
-	dma_addr_t da;
 
 	apc = netdev_priv(ndev);
 
@@ -1345,40 +1439,11 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
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
@@ -1659,8 +1724,8 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
-	if (rxq->xdp_save_page)
-		__free_page(rxq->xdp_save_page);
+	if (rxq->xdp_save_va)
+		put_page(virt_to_head_page(rxq->xdp_save_va));
 
 	for (i = 0; i < rxq->num_rx_buf; i++) {
 		rx_oob = &rxq->rx_oobs[i];
@@ -1668,10 +1733,10 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
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
 
@@ -1681,6 +1746,26 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
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
 
@@ -1690,11 +1775,10 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
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
@@ -1703,25 +1787,12 @@ static int mana_alloc_rx_wqe(struct mana_port_context *apc,
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
@@ -1764,6 +1835,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
+	unsigned int mtu = ndev->mtu;
 	struct mana_cq *cq = NULL;
 	struct gdma_context *gc;
 	u32 cq_size, rq_size;
@@ -1780,9 +1852,18 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
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
@@ -2194,8 +2275,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
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
index bb11a6535d80..33cd144733fb 100644
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
 
@@ -486,6 +489,11 @@ struct mana_query_device_cfg_resp {
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

