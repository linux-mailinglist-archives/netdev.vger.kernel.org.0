Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6667D159
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjAZQZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAZQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:25:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618FA8A49
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:24:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7Ry47qle9vc1qzVNxQVtAFK359xNGL7tylbGPdR9/T5eimlt1T9mV+LCi1Qo9VinCV1POOgfIkYK/oiHTETad6L2GoCeuNw/t7QLu+LUj9BMccLZpbnSmCqHzQWxEBzkTOXdN/ui4Z3z5BybxP3AfvHga/zdvZt18wvp3dCaMTtkEt2NNodFJoVbX6Q/5313O2kP+A1gdatXm7KiVOpRdidymwyOxCulKoj7h/w3m4PMefYf4hRHVHiRaMOAF3ysoxDsQ9VZM4VO4BoIAv6x6GvfOC5joI4IA+mTwqNhvVSokW39vrfJpk3wsWIF9aHgllAHtJi9yNgeuwXiLvHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gRLJgeFDUSKor7fmCJqnnoaF5ABl6q8Jz8GaLkPhcQ=;
 b=Kj2jcISlux+uGGzp69USUSkwH521G8t1tzQzepwCWFXfdmGNIDYRHFBqKkX99zNzdN2iXj2RWYYzGgV/i2jYLx/KTefKRVnTdmitiGDNJBKOlZSMKhLcQIQb2ofsDLwXJ+w2P7lvzJfMb5K2ZP74sCmb3lj611V+NDyqEcSpegBW1iUYsmh5brXnaygRfcEv/afvMAZ3q/ydajxRe/KI3pIPY+gXfnBbxB8AnnQtev441jjsYG6/MiX+pbWSsJuEKdZxlxEmwgeRfJdQCPnKzPaT7SP71jvrHv4orisgyOFO6KPgnnMi91EXzZ7nIQCKr4B7Tz06Z1MqTBfOZAGtLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gRLJgeFDUSKor7fmCJqnnoaF5ABl6q8Jz8GaLkPhcQ=;
 b=pBY/mtO5+P5Tbts51TIj2oOC/fZ8GePzlHBXmrhf5mll4dx+9OCa3kb7ILHUjrol44P5GGhx34jnZ3+9prdfPARHsvUDqIaKbGuix4PhpEULMBJXEGo6mTSIOp/E/7pkWG3oNEhYdE7E5dHMR+sM33kjLE3bq9eGquxCmlLXt4pNizm0t2eJmZGGDsHLUTddzCRNUl8nXsmtv/0iHKwyfzTKxIM1c6AD/auav+nJS2MNyeoBNx1Tlzh+tClo3Cs1XSr6zfgL5uqjIuvmZdHW/Oe9pQdLG4cW217T8RbKZPCF8AWqO9NWoJ6dvzvQpl4zmOoC/GlKyewzTO6ByHZhsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:24:02 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:24:02 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 22/25] net/mlx5e: NVMEoTCP, ddp setup and resync
Date:   Thu, 26 Jan 2023 18:21:33 +0200
Message-Id: <20230126162136.13003-23-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 749ca57d-f2cb-4341-f376-08daffb9bcb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PpWR4BETXk94opKHc0Vkts7DoARl0NzRZUiGkFNbGAOIUrCDBBsnF7bT32PB2yAu2u0ezokPeOvu4NX9iFNA86nOfamA4vpXm2lHfMzROeu/jLEncdQwnCB3m74ZhCVLdPp4F4C1moZbIKJRz9vLmqsQdGX5k2q7lmqJlAHrryVLpsJ6+q0654PitHhZVNEEphUXiX6PJ9ZmpiN+DdNpuY9RjqfYFXAG41FswpNx/FGmMBQab4yQL4nFmxZxW8/M+tllwcSY3nPIvCCioEAoGcdXK1GGO0j2s7dcK5QcQCpDFRBbBQ+37MM6aJ32mg/C84H/Y6+eOXHPHymtwT+ZKQnejizVzVcAABVFFaVmO5ObbTaZQxbTvgcwNbRhu7St6ycRKIVZzmIIV+O9gpdsxAHlmO5AS1r/pAokWkhy960BVVIsXI7vSoCEvROfsk2IR0RnDDlQpNrNZ/AKbXJD5yyXxuc2DA7qTzJ0vj1G1kAXCmr9ucWfrupygPDUdnCJgZjXTs0APrisv5vzGM41olEeaunmIvtJAI0tg8IAgtcl9t8sjEy6Sf66q4lvzxHOX+h1AjmzHlfo/vXI0ihinCFxnQhvE/zXLbffHwNAy/qIqeT7am+BVwRYBIZDnuSQyv7N7R2rgfBo3PQRjAg4tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eFxK/Q6XrJRfFH5D7qYx/TgACIStLmA3X7d6ET1XCSTchJ/5Ezk8StfLLPe2?=
 =?us-ascii?Q?bOHNvN0fulq15+8GZCXFmpB8xONmpdBq8oBb4QrR0Bvneq6WVOa0Nv/X6v5a?=
 =?us-ascii?Q?heg4wN1BvO+7FxFfAtmv/pJM5JNlBvXC1UFAC1jhibPJlAhGda7OkiMKcvmi?=
 =?us-ascii?Q?jmJLlsWS4LFWwmXoSLUIdFtFFMAaz7pZ3HoUgvmFcBIGp1KIqykgGvYDVS1A?=
 =?us-ascii?Q?3HxIcNgwAhIsDHYHOR3LWxJ73+4ONkYYXbqmLmmoxdaLG+ybA0EXeVHGgjd5?=
 =?us-ascii?Q?32Tuvv8yAX7j8yD1ENbi+u0hHtf5DSRGN9yqqD9S6FK3yfSoZLUZfIN5ulYi?=
 =?us-ascii?Q?+HG5OGmGR+Mw12TUAdsZ2O3wnl2v5gi22JcnT15z5JpRp3HVU15Wf89h+0RG?=
 =?us-ascii?Q?SLFMpZ3t0JXd4xotzHLQlZktDEQjZ/13fssGSzcizvqRuMV7ewRtPixOowT0?=
 =?us-ascii?Q?HUrmVuZbfypVnw58G2SLxsZqe/sGZQ3B0aXSaA8aI7PLzdsNnj9ea5kG8Wwi?=
 =?us-ascii?Q?rSN97UanuhHfwJFbTbtjzvh6kDx5wSS8gAmdk2KqdL4KTCeaJL8aRiwVXHyO?=
 =?us-ascii?Q?0z9NRRbPm8FhDfyRn2tgATcNtZ7r6cIInHgXczKRU5nJV298oEGzESAjC1Rv?=
 =?us-ascii?Q?C8Jz6bLu2M4jNuPG9T40qWrPxH8240xqFhYtkR9zt3ZySIMJwUcEhTzhDFfb?=
 =?us-ascii?Q?CFxocFbDJngdiQutVzbVcBX0/WnYXe0Gce74/nmQhe/8kRN0D5Owy/3U9zzI?=
 =?us-ascii?Q?koQ3wma2mW6sat7ruwEHrvpvIG4rdh7tYtfJuxBfrg24Xqor3AKjFr3Uv4eI?=
 =?us-ascii?Q?240qI58pF11tuh9B6aJ+9uzz9/Tt+1iVUooWtUCqnpDq74YeVSEZnDTUh43p?=
 =?us-ascii?Q?u2PulMZDYFX9wa9MtOKZJuc6ERuHFukRctTdtHF9a7gEMgpFcTcApoVe5VCn?=
 =?us-ascii?Q?UNFMp6IPYhiTTQpm9qeVImjUQEX0m21H4hbpMt/2aOr2rNFZi949fbMMrJnL?=
 =?us-ascii?Q?1deWG/m3QA8PCE5bzqgMmBRMQB/pZotduwhI004hJVJzJVOUpBlAmDrPJMYV?=
 =?us-ascii?Q?eIk7ooDaPLpsLMhIXRQJxeGzBG0NI6B6segxLDJU/Lb0U+WlOU6KWvbd2cvU?=
 =?us-ascii?Q?LBUbB0ve6YVIbwKRdfsbKkigzQFFVD+6yzdA39ZULi2hn+/eHGkbYHcrg+i2?=
 =?us-ascii?Q?dBn/mh11oxJoGN1cUUj0HrI68h39SGo+FJQzcnyR0XbFFxFkQ4DJ0fs20wyi?=
 =?us-ascii?Q?zAvmQYNx0tk7yW+ikV/Bt+bU9UeYGX01jVG8XFhTsc9IDbKkkP0qpPpzU51Z?=
 =?us-ascii?Q?5JPGor40JVss1w/npB2TnVEmNbGoraRloiLyDVq9jijBm/FaM1BhBG2SSE+y?=
 =?us-ascii?Q?arzgmTvxlyAeN+UcJju2tEhifC6KRhOmWZ0kv9DRvEpvdbLLhZdvrOWL/Uie?=
 =?us-ascii?Q?tJuNcuyZ1EEIPQLwoMhiUmHfkiSd88r7MvDWI28WfUtd6BXkDnOGQoAqdV/d?=
 =?us-ascii?Q?9473oLvw7rlnmGU0GoPPxkg4w25CMr9/VxEhj2LhJFhR68WCTha2USzD+EvD?=
 =?us-ascii?Q?wNpllZ3Tf45bSt0IvUYCvEijNgFe1QuoC+kBkQoh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749ca57d-f2cb-4341-f376-08daffb9bcb3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:24:02.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxUboHZlNOuDcwIROgMs9ubcKQaIljKgehT21PYfoDZhrspw6VhoyHHjpTzgNb6ZlMnn1uwVJH2pKWPp5v7LSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for every NVME request to perform
direct data placement. This is achieved by creating a NIC HW mapping
between the CCID (command capsule ID) to the set of buffers that compose
the request. The registration is implemented via MKEY for which we do
fast/async mapping using KLM UMR WQE.

The buffer registration takes place when the ULP calls the ddp_setup op
which is done before they send their corresponding request to the other
side (e.g nvmf target). We don't wait for the completion of the
registration before returning back to the ulp. The reason being that
the HW mapping should be in place fast enough vs the RTT it would take
for the request to be responded. If this doesn't happen, some IO may not
be ddp-offloaded, but that doesn't stop the overall offloading session.

When the offloading HW gets out of sync with the protocol session, a
hardware/software handshake takes place to resync. The ddp_resync op is the
part of the handshake where the SW confirms to the HW that a indeed they
identified correctly a PDU header at a certain TCP sequence number. This
allows the HW to resume the offload.

The 1st part of the handshake is when the HW identifies such sequence
number in an arriving packet. A special mark is made on the completion
(cqe) and then the mlx5 driver invokes the ddp resync_request callback
advertised by the ULP in the ddp context - this is in downstream patch.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 146 +++++++++++++++++-
 1 file changed, 144 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index a90be18963d6..e7c2cf83fd20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -682,19 +682,156 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 	mlx5e_nvmeotcp_put_queue(queue);
 }
 
+static bool
+mlx5e_nvmeotcp_validate_small_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, hole_size, hole_len, chunk_size = 0;
+
+	for (i = 1; i < sg_len; i++)
+		chunk_size += sg_dma_len(&sg[i]);
+
+	if (chunk_size >= mtu)
+		return true;
+
+	hole_size = mtu - chunk_size - 1;
+	hole_len = DIV_ROUND_UP(hole_size, PAGE_SIZE);
+
+	if (sg_len + hole_len > MAX_SKB_FRAGS)
+		return false;
+
+	return true;
+}
+
+static bool
+mlx5e_nvmeotcp_validate_big_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, j, last_elem, window_idx, window_size = MAX_SKB_FRAGS - 1;
+	int chunk_size = 0;
+
+	last_elem = sg_len - window_size;
+	window_idx = window_size;
+
+	for (j = 1; j < window_size; j++)
+		chunk_size += sg_dma_len(&sg[j]);
+
+	for (i = 1; i <= last_elem; i++, window_idx++) {
+		chunk_size += sg_dma_len(&sg[window_idx]);
+		if (chunk_size < mtu - 1)
+			return false;
+
+		chunk_size -= sg_dma_len(&sg[i]);
+	}
+
+	return true;
+}
+
+/* This function makes sure that the middle/suffix of a PDU SGL meets the
+ * restriction of MAX_SKB_FRAGS. There are two cases here:
+ * 1. sg_len < MAX_SKB_FRAGS - the extreme case here is a packet that consists
+ * of one byte from the first SG element + the rest of the SGL and the remaining
+ * space of the packet will be scattered to the WQE and will be pointed by
+ * SKB frags.
+ * 2. sg_len => MAX_SKB_FRAGS - the extreme case here is a packet that consists
+ * of one byte from middle SG element + 15 continuous SG elements + one byte
+ * from a sequential SG element or the rest of the packet.
+ */
+static bool
+mlx5e_nvmeotcp_validate_sgl_suffix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int ret;
+
+	if (sg_len < MAX_SKB_FRAGS)
+		ret = mlx5e_nvmeotcp_validate_small_sgl_suffix(sg, sg_len, mtu);
+	else
+		ret = mlx5e_nvmeotcp_validate_big_sgl_suffix(sg, sg_len, mtu);
+
+	return ret;
+}
+
+static bool
+mlx5e_nvmeotcp_validate_sgl_prefix(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int i, hole_size, hole_len, tmp_len, chunk_size = 0;
+
+	tmp_len = min_t(int, sg_len, MAX_SKB_FRAGS);
+
+	for (i = 0; i < tmp_len; i++)
+		chunk_size += sg_dma_len(&sg[i]);
+
+	if (chunk_size >= mtu)
+		return true;
+
+	hole_size = mtu - chunk_size;
+	hole_len = DIV_ROUND_UP(hole_size, PAGE_SIZE);
+
+	if (tmp_len + hole_len > MAX_SKB_FRAGS)
+		return false;
+
+	return true;
+}
+
+/* This function is responsible to ensure that a PDU could be offloaded.
+ * PDU is offloaded by building a non-linear SKB such that each SGL element is
+ * placed in frag, thus this function should ensure that all packets that
+ * represent part of the PDU won't exaggerate from MAX_SKB_FRAGS SGL.
+ * In addition NVMEoTCP offload has one PDU offload for packet restriction.
+ * Packet could start with a new PDU and then we should check that the prefix
+ * of the PDU meets the requirement or a packet can start in the middle of SG
+ * element and then we should check that the suffix of PDU meets the requirement.
+ */
+static bool
+mlx5e_nvmeotcp_validate_sgl(struct scatterlist *sg, int sg_len, int mtu)
+{
+	int max_hole_frags;
+
+	max_hole_frags = DIV_ROUND_UP(mtu, PAGE_SIZE);
+	if (sg_len + max_hole_frags <= MAX_SKB_FRAGS)
+		return true;
+
+	if (!mlx5e_nvmeotcp_validate_sgl_prefix(sg, sg_len, mtu) ||
+	    !mlx5e_nvmeotcp_validate_sgl_suffix(sg, sg_len, mtu))
+		return false;
+
+	return true;
+}
+
 static int
 mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct ulp_ddp_io *ddp)
 {
+	struct scatterlist *sg = ddp->sg_table.sgl;
+	struct mlx5e_nvmeotcp_queue_entry *nvqt;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5_core_dev *mdev;
+	int i, size = 0, count = 0;
 
 	queue = container_of(ulp_ddp_get_ctx(sk),
 			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	mdev = queue->priv->mdev;
+	count = dma_map_sg(mdev->device, ddp->sg_table.sgl, ddp->nents,
+			   DMA_FROM_DEVICE);
+
+	if (count <= 0)
+		return -EINVAL;
 
-	/* Placeholder - map_sg and initializing the count */
+	if (WARN_ON(count > mlx5e_get_max_sgl(mdev)))
+		return -ENOSPC;
+
+	if (!mlx5e_nvmeotcp_validate_sgl(sg, count, READ_ONCE(netdev->mtu)))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < count; i++)
+		size += sg_dma_len(&sg[i]);
+
+	nvqt = &queue->ccid_table[ddp->command_id];
+	nvqt->size = size;
+	nvqt->ddp = ddp;
+	nvqt->sgl = sg;
+	nvqt->ccid_gen++;
+	nvqt->sgl_length = count;
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count);
 
-	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
 	return 0;
 }
 
@@ -717,6 +854,11 @@ static void
 mlx5e_nvmeotcp_ddp_resync(struct net_device *netdev,
 			  struct sock *sk, u32 seq)
 {
+	struct mlx5e_nvmeotcp_queue *queue =
+		container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	queue->after_resync_cqe = 1;
+	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
 }
 
 struct mlx5e_nvmeotcp_queue *
-- 
2.31.1

