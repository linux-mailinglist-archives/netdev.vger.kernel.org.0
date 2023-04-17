Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228846E4788
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjDQMV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjDQMV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D509EEB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiWm0Qq258oXH6m2nnt7O7OfgC8iq/inDTdbLfAMr2DBBg8IhPSRcPvPe6FZdLvLLXSVObIvHekHU4ehwvVIJeON/qY+xx8gVcxVd5lMUVoVCfjDmZNmS4rq6L3WEbJ9ge90H7K3JVNh7YUAYbeyDKRkxRSIRL7OPWkRotaJMw7TFrbhRC5ICEd4ipeBUgIxHKiTNqeFNHI3SqdTNnmfTdXgP7Lvt+6A+6CC8fKZJ+OgpFnZKB6+/FQ0IQoPQx6tdgxSR04d1cfIK3Sp9h+FwFD5AZCEs/JBjsI6wkpWOGzqcXpPOI51yCiwHnEZXHBag5ollS6SINVJ7r9tAh7M+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrfDdbSkr8cDSHryZ3qgF8g9Z2SqsYEXpGoXu3d0RhQ=;
 b=IcqRmwbnzlvODYO1/ghZq4TLr+gux577Xqbg6Wby093ndyd23E7fmoRrg58LbMNwT7I4KH60d7APTKupBkUDFrhXs16m9hS0avMnJoYSFxN5JMZV63V3D/6o8BZPEAG7cP4xGoZZS8nciAU/1SkTozBKNdtis+G+3hCbLF6Iwshar137XHKEJefDGlkmV73VC9wqlLuj2BLvxsoyOst29pfGc8Wwxbh4AMI8sIqCoPzFJz73DxFEsacX1AUiXW9ecdJfIrJ1y2Tgc3kU5nAX8Ti0kN83EHk9mZbmJLtlJdyjjLJe1zhCco1Ap/jGJef/K6/6AceX2HrJrSH/Ps6ZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrfDdbSkr8cDSHryZ3qgF8g9Z2SqsYEXpGoXu3d0RhQ=;
 b=lW3cj7AlfPvCF/aH9wsWAaDYeh1RsfuoQf9hV5pPKSdZLsRmI3zy5SfSDgTd/WFgaUBiE3xa/tWf3+piZX/SVO4+gOWG0ShbGe2/oxHuv/XxyuLAzyZRorEg6X/nOOUXz3pPI3SjTFcVTO6E6gqnAC1PTSsD7FaHsk8ou6A8iYNJ2GQTCsDSgqeThHxiGQNBKJUS+3hsMFzHw08lMp409VwmNSwvfh0vtPpFfvhES32cHR34PDGLO9b9CyqrU/5kABFW7EkbigxahROv/q3VmfW8kib4pZnD3DVDdPY1dtu59fsrdW366C0abTuwAF/UA4mBbSI3yPn5+kO12Enfjg==
Received: from DS7P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::18) by
 DM4PR12MB6232.namprd12.prod.outlook.com (2603:10b6:8:a5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Mon, 17 Apr 2023 12:20:48 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::99) by DS7P222CA0011.outlook.office365.com
 (2603:10b6:8:2e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:38 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:35 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 14/15] net/mlx5e: RX, Prepare non-linear striding RQ for XDP multi-buffer support
Date:   Mon, 17 Apr 2023 15:19:02 +0300
Message-ID: <20230417121903.46218-15-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT006:EE_|DM4PR12MB6232:EE_
X-MS-Office365-Filtering-Correlation-Id: 94f6bde5-0a36-49e3-f420-08db3f3e2d24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwGFNhUMebs1UaXMB1Z28pyTfkWjxuycp1Q3NUcYc88ia72HcQqoxQrZbTURpmSgrD1tPiT0yCRlNaFiQHG2EsLIfMN5JBcNwJn1Z8/fREBXZ3dd5YGBPA/z+KSH9sRr2yxLbohRWvuaS4Zg4f+0AIK0GrybjTnT7uHYqBcYdOCudGUXiZcGnKeTLsFh7hNgZoOaE4W4Nf+pSj9TjtjZnX8rvpM1EBRS7An3I0FGRxbL2gAMTjtCqPA3GFLYth5KyRwchtSxO8jlEeiiGehfdU6HjtMGArUBJEmMFl0zOP45F6Kah93uMV+jn81eYZbQjdWLodPuAA4vgfUt5ZQZxgtqUCiHi4tMPmk1gZTqp5Ckj7AKi5gY/8wy9EFXISj5dglzi6BBKpwJ4sBCwtZVE1tOG0NaFggKCQ8N0SEIxAbanvGsqoAIH5TC5nKRjERwYIVzWUVwt+a2ficCKAUNObCsoPBMONOTCHxg67JittkXEKQLpiieHP6kPUogFPTm+9TAamDAv4vyxSnLHnVBNNnckVeHXs1wNp1zVNeEePYl8gZICEnQHfl6ZeJj3OyL39yvFeanBuR+Q/wFKsV4zLDYiTfuxU9/bvwo+miTPIlgvfmDr3B7AeBJ4w3+dnB+pKh7x+ienVUFvvCn/ZyW/9n3b7RZOvUCgVl+wCgXa+TeigoBx0nfo+bkZYLmnw3nqnLJNpKmiY13zgo8Hd8DdhgHXBmXKDl3P02ItykcJpDC6PdUTiT6x4KOBoMLrp2ccoscT9nt7q9jFgJpIsdmvrgi+JQh7I9bL0rCI/aob8Q=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(336012)(7696005)(6666004)(86362001)(478600001)(110136005)(34020700004)(36860700001)(2616005)(47076005)(426003)(36756003)(83380400001)(26005)(40480700001)(107886003)(186003)(1076003)(40460700003)(82740400003)(82310400005)(7636003)(356005)(70206006)(70586007)(316002)(2906002)(4326008)(8936002)(8676002)(5660300002)(7416002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:47.9413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f6bde5-0a36-49e3-f420-08db3f3e2d24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6232
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for supporting XDP multi-buffer in striding RQ, use
xdp_buff struct to describe the packet. Make its skb_shared_info collide
the one of the allocated SKB, then add the fragments using the xdp_buff
API.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 51 +++++++++++++++++--
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a2c4b3df5757..2e99bef49dd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1977,10 +1977,17 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	struct mlx5e_frag_page *frag_page = &wi->alloc_units.frag_pages[page_idx];
 	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	struct mlx5e_frag_page *head_page = frag_page;
-	u32 frag_offset    = head_offset + headlen;
-	u32 byte_cnt       = cqe_bcnt - headlen;
+	u32 frag_offset    = head_offset;
+	u32 byte_cnt       = cqe_bcnt;
+	struct skb_shared_info *sinfo;
+	struct mlx5e_xdp_buff mxbuf;
+	unsigned int truesize = 0;
 	struct sk_buff *skb;
+	u32 linear_frame_sz;
+	u16 linear_data_len;
 	dma_addr_t addr;
+	u16 linear_hr;
+	void *va;
 
 	skb = napi_alloc_skb(rq->cq.napi,
 			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
@@ -1989,16 +1996,52 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 		return NULL;
 	}
 
+	va = skb->head;
 	net_prefetchw(skb->data);
 
-	/* Non-linear mode, hence non-XSK, which always uses PAGE_SIZE. */
+	frag_offset += headlen;
+	byte_cnt -= headlen;
+	linear_hr = skb_headroom(skb);
+	linear_data_len = headlen;
+	linear_frame_sz = MLX5_SKB_FRAG_SZ(skb_end_offset(skb));
 	if (unlikely(frag_offset >= PAGE_SIZE)) {
 		frag_page++;
 		frag_offset -= PAGE_SIZE;
 	}
 
 	skb_mark_for_recycle(skb);
-	mlx5e_fill_skb_data(skb, rq, frag_page, byte_cnt, frag_offset);
+	mlx5e_fill_mxbuf(rq, cqe, va, linear_hr, linear_frame_sz, linear_data_len, &mxbuf);
+	net_prefetch(mxbuf.xdp.data);
+
+	sinfo = xdp_get_shared_info_from_buff(&mxbuf.xdp);
+
+	while (byte_cnt) {
+		/* Non-linear mode, hence non-XSK, which always uses PAGE_SIZE. */
+		u32 pg_consumed_bytes = min_t(u32, PAGE_SIZE - frag_offset, byte_cnt);
+
+		if (test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state))
+			truesize += pg_consumed_bytes;
+		else
+			truesize += ALIGN(pg_consumed_bytes, BIT(rq->mpwqe.log_stride_sz));
+
+		mlx5e_add_skb_shared_info_frag(rq, sinfo, &mxbuf.xdp, frag_page, frag_offset,
+					       pg_consumed_bytes);
+		byte_cnt -= pg_consumed_bytes;
+		frag_offset = 0;
+		frag_page++;
+	}
+	if (xdp_buff_has_frags(&mxbuf.xdp)) {
+		struct mlx5e_frag_page *pagep;
+
+		xdp_update_skb_shared_info(skb, sinfo->nr_frags,
+					   sinfo->xdp_frags_size, truesize,
+					   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
+
+		pagep = frag_page - sinfo->nr_frags;
+		do
+			pagep->frags++;
+		while (++pagep < frag_page);
+	}
 	/* copy header */
 	addr = page_pool_get_dma_addr(head_page->page);
 	mlx5e_copy_skb_header(rq, skb, head_page->page, addr,
-- 
2.34.1

