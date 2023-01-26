Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640ED67D13E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjAZQXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjAZQXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:23:31 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DAF6536D
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:23:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DK7MeIIuV9KNUa7sclFMuwdu4B8c3Tvvzb+gZj9NnJQQHaMPL5htDrEDtAdl/HoCXLmdCUEy+4pQjKEoRdC1KTKhMd+SO93ct5CjuPKLnJTvpxxOWVM0khsRmSQ4VyZkS9n/6Tb2wcKB3ehlrXJb2bXIMc0f//JBjEyX3UKgU48GUd4MoQSEGTtqbgymftMAvY3aI8pZef0lHUyfj3LR58OAFlZdO5wqf7m0S7/Qo2VwWTBN0LjkGNd90Eyz9aqb24mc5IOfCDGImy25xyP7bQCLEGHpFZGFlFphCZuN7NOkcjl38P21iv3zEC49hfYYXGc1Au97RFN8hUXbj+/nWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQD7FaT+PBqXhv4KW+daaBG/CJCSnqhsVJIb6lvnYfc=;
 b=hMuZQpUR53+rczLn+er+VdXP9fIxrvTXDCtXQ1S5lmYu1DscB6GTf4JsQMlJ6xlHnZ0ax5Fgv4J0Dm9tqpVvpSN+f3NQQWEVCtNgwMgZEN/A8JCbTWOjQJhKfgt+IZtrXslmqNHTBI8Eznipdl9+TiR5dx6bYvsVKCjcozpkluHxfBdDakZAcSCup+RYcA9iYIqGBrHc4nDeLk12qIdDO2rAJwxXgBWTK9EcPS4L8mj29762E9ApY17Sv755hP478tLHm2HjL2RzuVdmFalE9bLFMjV1J9qfbQKBnzsfRjr6ob0+/KlZSwC16BJhlQvgF06pdyKP7dCW7MVyegNBAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQD7FaT+PBqXhv4KW+daaBG/CJCSnqhsVJIb6lvnYfc=;
 b=op1v2eXQ2pLwwRJ7lDw/0I80FIitNCYKkhX2UO8O4cviSToOZjQXr/NuvLytfAKIw35CNNy3DybuJvN3i8FakNE+gN+8eY6tNuo0VsMm7s49HW+b2BI1OcxNsTOg8E1PS+TWhvN3f/qaEv1j8lHwBGq+YJaxS+m5r4FF/hQ+N5UrFJNT85WPVhzsLgYQmpi3J5mue0fAeGK0wWVXMLSgal+t26ANwYzv8dwtBzvafsXFGCliFxqwQiP/tfLonm+Mo16NXrTSc0xAE05IunLs/y0jUG3PE6jeBncMs6QvfSa7VwtL//O0w2Ozryi7jAiv0NGaxM/TTwfCQBgce9MJfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:22:38 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:38 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 08/25] nvme-tcp: Add DDP data-path
Date:   Thu, 26 Jan 2023 18:21:19 +0200
Message-Id: <20230126162136.13003-9-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f777708-f891-437c-dbda-08daffb98a29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nMtmRUL2Mo+ttiF7OI9Kao+JmGjsBhAgNX0Twn3DQcGlNBCzIpQWBtHur18w0+sCW1bW9hRxekMPiSQz+MIWYu8/li24udCGxKOVGs4ELJzxq0VYw0Xk73zJubzLWCVdLaOYaUvue99sNYZ/kWcPJCb99s+UCYyn+ObgCwe/O21Xs39+dBw/dGG7dow/XlAHzMBFflG0eoQ2hVelqDsBvKtSsYr2p/ERMHkq1F0TkuSOVvExXm7iTxdVLo2wrJG1IoqbHpONtMRjH/VtW0LHsCao9xeaN+fOFVQDKiML44RpLm0oBfhUKD0wXVTnmXoPkP+fWt3VVxWles2BShZkEIDy9YD6Z5mlz9jyWBIe7hFuWcRO6y6mPp7zL9+JA5a1Vv1uvfR64xZJtNBNVkQX5QILNnGDNPTJy1MkZcgsgqqE58ULL8y2ZQhxRLx/n9HskCdsGc6ITgosP/4bocueIBTjWhsOSsZq0dF0HqGpJdUmjtVVUaJWuh4tT+0G1UVayt0yV1TKx8YO8zi7KSkY48WDRKzdZgwkrNk4kLZR4CuxfqLd0hzG60lXxdpSLpAFKSWzRMXpHYjadTp5Hhi2FLRzhHnfeg5h0xWGE1QC/FUpLXwz+tfCeQp3i/bzz9hWrRJ6cSiL/jU9RJW8s5Mng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?leOIJoRZKhrO+MEizd/hfPzL7zZkZGw00SVyGoZot7SjEjUeJXMdfc3UUA/S?=
 =?us-ascii?Q?rug7iisPpLmcFsWrYIV1gZlq6lWG03EgqfNGz9V1VVBAaiBXIfxO5k7ZPhDr?=
 =?us-ascii?Q?zY2i6mzr8urjJvIOm+DHtMroT8jJ9/7NquUYSH1h4yP2MIB92ij0yL7GFsFb?=
 =?us-ascii?Q?RHyMcQD8YNxCvFA4Cffvb7DleiJ+e6opKGzSvzIhDH78jWRU+09BkFZfCwe7?=
 =?us-ascii?Q?W3hpV3qIRxQ8VDnT8og/beFCR5SZ7nXFK/ZHiGNqjND4aZFhSlZcE46ch7a7?=
 =?us-ascii?Q?b5F3Tn/9TLo8yaMXJ+/7Dl+zaoVuvWgTB1H3iFNHdcMOmMcb8PRzXTqLi8sn?=
 =?us-ascii?Q?3qEVwZEO9cSfwvzU5Dp1Ao7dizVWuYhuPmftPRtBBsKDegPY11BcxLOus0wV?=
 =?us-ascii?Q?VgV6LhV3LJvf5jE7J6DUcFwvgd7/TI7ltOV8HKtjVuVGm8tn7OqXn/2Nu+Kd?=
 =?us-ascii?Q?5hxes6cCDFR3v8eqBK89Qe5OlJBVMflNegoZsM6wWudIF15i8OAZb9FU9EgO?=
 =?us-ascii?Q?7YbpstNmTX6116kE+QdqtJ8x7LF0qgSCRVcp9nNYZrJQ5jyZhd1HL6vGlUNZ?=
 =?us-ascii?Q?u2I48wS4qCnPgfqJ10PNLmYHf9WaxaZDO/+Eh46Jwz8YEzOE97W9Cw5AuN86?=
 =?us-ascii?Q?xzDWUxrScxGPbCMLUFEkD8ciwYxUoiTvCJHNIlSIaVsO4wguw0A2aXFyIMVx?=
 =?us-ascii?Q?ofrheoPcpNmjyaGM/Vg7mI8sdalKLSt3xosnaVR/+5em7aWzxWOA5/kOPJC0?=
 =?us-ascii?Q?KeeoVYoy6Wx5FKBFv477vpTQXTlcgCR3KO4uUEDaI6RYh9yYrGeb0hWPXL2T?=
 =?us-ascii?Q?Im402htOfo2M0St1r4W7lgEiKMXveMI7hU4Wy6+st2m3UIAR7sChoHSh6/Ra?=
 =?us-ascii?Q?USgvSan0TCdIQycFsZorjCr3FeUa0i8+s1SLm2a9hh0szRV5ULhGQtoqM1Wi?=
 =?us-ascii?Q?1g5Kv+GYAHVn0rXykcHApNhkZVSph4dBiS0h3ncGhQozmzcXsqVOaS71+icl?=
 =?us-ascii?Q?fM7Hai4t5SP38MAO6O3hc0oOGG/0HUGqbT4QP0Pd3Ht48qeNrBHIkWe8QzBP?=
 =?us-ascii?Q?18aDcwwF0n4yKmxuPS9ApS73ndeKgkcZuyxYqAWBTPq+UdNXAfr6K125Pnt2?=
 =?us-ascii?Q?47LtxtsXGwvSrDiqh45GbjxwJ9Di5saB+tVpANOZkxLf0hDp8zNfBYlX/1/y?=
 =?us-ascii?Q?/M50t7SdNT26wBcBgE+ZSTBaltIigjWGBU5lr7id+OjDny5XPd6/PLvugmKP?=
 =?us-ascii?Q?YVPC6tIWqRYOA/aItvX2Bt49mEFpxD9iPFSoYxrp02Uc0FFrzF6oEJms4kYJ?=
 =?us-ascii?Q?JdqS7thcJhp5yPpqIXnDOMjlR3ro2TwzVVZvcrOGvoXHXBfpfJz0EKASpKqp?=
 =?us-ascii?Q?AnGYeRcQMVHf72iOj2QhzAAguInwIJJ9SZwJ1mc9wSme/TXZhaUgBx0WFuBX?=
 =?us-ascii?Q?+lrm+upDzQWpxQIajTacTDGPeotxml15ysXDdWl1UzYaRfmVCWnc234z3Z4T?=
 =?us-ascii?Q?miBems9r1hZ1wcaXFXOFT1DJ2NKcotYqCZ47m/xgq0JpsKBv6c+LhI4kzqsD?=
 =?us-ascii?Q?c3hoLWAAiy69gsAE+l1MIj6757+WY/1jy2ZjYytG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f777708-f891-437c-dbda-08daffb98a29
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:37.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIigKPs5rTsCKqkNnLIi15hCM59t/7IkvnaRw7uQwDRLOUZIFxn6fUP8aQzmEEIXsxAqShNYZDzcpmJ7mj5OrA==
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

From: Boris Pismenny <borisp@nvidia.com>

Introduce the NVMe-TCP DDP data-path offload.
Using this interface, the NIC hardware will scatter TCP payload directly
to the BIO pages according to the command_id in the PDU.
To maintain the correctness of the network stack, the driver is expected
to construct SKBs that point to the BIO pages.

The data-path interface contains two routines: setup/teardown.
The setup provides the mapping from command_id to the request buffers,
while the teardown removes this mapping.

For efficiency, we introduce an asynchronous nvme completion, which is
split between NVMe-TCP and the NIC driver as follows:
NVMe-TCP performs the specific completion, while NIC driver performs the
generic mq_blk completion.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 121 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index b350250bf8fb..533177971777 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -102,6 +102,13 @@ struct nvme_tcp_request {
 	size_t			offset;
 	size_t			data_sent;
 	enum nvme_tcp_send_state state;
+
+#ifdef CONFIG_ULP_DDP
+	bool			offloaded;
+	struct ulp_ddp_io	ddp;
+	__le16			ddp_status;
+	union nvme_result	result;
+#endif
 };
 
 enum nvme_tcp_queue_flags {
@@ -307,11 +314,75 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 	return true;
 }
 
+static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
+{
+	int ret;
+
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ret = sg_alloc_table_chained(&req->ddp.sg_table,
+				     blk_rq_nr_phys_segments(rq),
+				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
+	if (ret)
+		return -ENOMEM;
+	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
+	return 0;
+}
+
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
 	.resync_request		= nvme_tcp_resync_request,
+	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
 };
 
+static void nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
+				  struct request *rq)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	netdev->netdev_ops->ulp_ddp_ops->teardown(netdev, queue->sock->sk,
+						  &req->ddp, rq);
+	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+}
+
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
+{
+	struct request *rq = ddp_ctx;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (!nvme_try_complete_req(rq, req->ddp_status, req->result))
+		nvme_complete_rq(rq);
+}
+
+static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue, u16 command_id,
+			      struct request *rq)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	int ret;
+
+	if (!(rq_data_dir(rq) == READ) ||
+	    queue->ctrl->offload_io_threshold > blk_rq_payload_bytes(rq))
+		return 0;
+
+	req->ddp.command_id = command_id;
+	ret = nvme_tcp_req_map_sg(req, rq);
+	if (ret)
+		return -ENOMEM;
+
+	ret = netdev->netdev_ops->ulp_ddp_ops->setup(netdev, queue->sock->sk,
+						     &req->ddp);
+	if (ret) {
+		sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+		return ret;
+	}
+
+	/* if successful, sg table is freed in nvme_tcp_teardown_ddp() */
+	req->offloaded = true;
+	return 0;
+}
+
 static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	struct net_device *netdev = queue->ctrl->offloading_netdev;
@@ -453,6 +524,12 @@ static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
 	return false;
 }
 
+static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue, u16 command_id,
+			      struct request *rq)
+{
+	return 0;
+}
+
 static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	return 0;
@@ -740,6 +817,26 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 	queue_work(nvme_reset_wq, &to_tcp_ctrl(ctrl)->err_work);
 }
 
+static void nvme_tcp_complete_request(struct request *rq,
+				      __le16 status,
+				      union nvme_result result,
+				      __u16 command_id)
+{
+#ifdef CONFIG_ULP_DDP
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (req->offloaded) {
+		req->ddp_status = status;
+		req->result = result;
+		nvme_tcp_teardown_ddp(req->queue, rq);
+		return;
+	}
+#endif
+
+	if (!nvme_try_complete_req(rq, status, result))
+		nvme_complete_rq(rq);
+}
+
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		struct nvme_completion *cqe)
 {
@@ -759,10 +856,9 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
 		req->status = cqe->status;
 
-	if (!nvme_try_complete_req(rq, req->status, cqe->result))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, req->status, cqe->result,
+				  cqe->command_id);
 	queue->nr_cqe++;
-
 	return 0;
 }
 
@@ -960,10 +1056,13 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
 static inline void nvme_tcp_end_request(struct request *rq, u16 status)
 {
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
 	union nvme_result res = {};
 
-	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, cpu_to_le16(status << 1), res,
+				  pdu->command_id);
 }
 
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
@@ -1263,6 +1362,15 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	else
 		flags |= MSG_EOR;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
+		ret = nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id,
+					 blk_mq_rq_from_pdu(req));
+		WARN_ONCE(ret, "ddp setup failed (queue 0x%x, cid 0x%x, ret=%d)",
+			  nvme_tcp_queue_id(queue),
+			  pdu->cmd.common.command_id,
+			  ret);
+	}
+
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
@@ -2594,6 +2702,9 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_ULP_DDP
+	req->offloaded = false;
+#endif
 	req->state = NVME_TCP_SEND_CMD_PDU;
 	req->status = cpu_to_le16(NVME_SC_SUCCESS);
 	req->offset = 0;
-- 
2.31.1

