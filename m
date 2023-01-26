Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC87467D13A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjAZQXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjAZQXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:23:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696E52DE7E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:22:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe3Hm0c+90d3R0ihccSdVB8VrzInLI0wOv8NcNqC4E+NgpDXCnseXx0f92pDPSmrx638ImMfyTpA/KbXhQVCUjz1ct/UjxrJJaTVZVAjzzcDXlrJVMsDWcrz6GKWvfytigH5Pk36GLz+24xiJW3TKXUcK7mRRixvsLRIl6cm8+9MBugM/HKJNvZYaThqH3Wq8zLU4ARtFXOX+EyMshBThHqxx9VXVzugC6tF2GLIpbgIJpmCMeEBDeVtHUIjDewTcP0VeyGTmkGBtRGyUgyrxmxysbjfWE4LHbmFEX5Rf+aqY8qray2UkC25srcS66jeN7I6/TAzpPR3/DEiX8eW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3X1xxnLcvqublCNEtqddms2kV7RobqmXHXqnP41Cp6E=;
 b=oTvboPeKjZuxXZRL/JreIy0ko7QdpkD6W1ldOUJeE+kmHufGA3PcSeX+MdMdutPbiEx3QjVzrzCClyWoObmyGJo/YiAkwX9VW38x8EehPZ34rwMbbupngnFefyFa5AUhCc8d2q9ZTM/F4BYsjHrxcZYy7UaUoPKgN3I5qbBdlbf1378W1exzeq/c6yWz9xo6SHlIv0YHG2TJuM7VXLCyIy1vRnEMnPFGVpzy2sujPMc246qnw5foPPnDg7WRcw0CAgLOv2EOXQEnblMU0qdTKvZNOtro6Aln07B9aBr0tg0qEjERMQkkQrS7hPlHMJ13XI7sJ64qppS1sU+Cugg02A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X1xxnLcvqublCNEtqddms2kV7RobqmXHXqnP41Cp6E=;
 b=ZPtSq07OYItpJhjeRWSDt6VyhiLuqEy3qBTdmT5SqNQ+bBV0eLOli3LGsa5mSMrhUmKWpvlQIRPD9S2MnXpOrVJY0JNhpFTs+SKPSYf6rnYWEa3fogG/S2lcqL1rMcyd/2ihvaTitoZ6DafBPQvEhk9HNrfG2tA0Slmki77UC3gYbTDtKjRFrgVKE86/yNoxTg8Bsvflab1aOYC9KP1hPK77ZjZIgGFNMFOL80k5bBvDoFMPv/9grMny1rESxcDdRQcz5+kJxBhGcnqETZboAPFpFQ+PSRen3PYNBfzNvFmlE5nIbuAFPDlY5xFpXigdE5shLZDOqu2Ae7bx0WaeKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:22:32 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:32 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 07/25] nvme-tcp: Add DDP offload control path
Date:   Thu, 26 Jan 2023 18:21:18 +0200
Message-Id: <20230126162136.13003-8-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0163.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ec4890-2ba6-4c09-03e9-08daffb986a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /eS6b07jmhtOzTCeRhbLwFe2kFu9MzM4E0UwUi+8b144BCmkL5KhkhBC4bM4DtU5/ghYTgIteB5skZhDitmbWB/nXWuDsexKvQO+wt48HW+YSI2WjE1dMrqjW28tShuceBtry3g8iAP7A+DTr3RVtPuI3Z4/v1jMq50v0+QseLuSyHrnsNfyRAOAPcNFLJmbBa3BgZA7JPxZvQyOhXMBNL6q2huZxcCIr8HARdgbxf5RwLFhSu1rkwI+r0UO12gtwR65aszcA0rM5PNffBQa4Ihl96/rZlAWhtcTy2hsRj5l3jGY15GBxZaISLbt+qlPBCPBumz6VMb28t0swBd2izR+BaIWRX8L1cqaEUK+SLjugonzsYZ+CGKt1Ul9sxlD+20WYJMSyc9nsDlvwzca3CcLYqqNG2Dal91ICCZ3Qd4kHHmJqu4S0K7yYphr0yWQQ9e8Z74ENDIUeToqMLeygF7GV7AFWd84wgjFSnwxLSchsaTk+wbmQkvNyxSwDh09qud+q0QAzlgvLgBg/oWveopyANo0fVqbEedwzW72U0c9f9YZxvqxKSVUinYdCnJ1X2q6r8yjOHbssr3JQ3zp46FszPnKP7aYJo6nTCIBRwkQ+yzTkEBhlNqhrTMlOFvdAd2p0a+zvOkl+fbyEprb0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZ+jCYWJNwMx555/9NQdn36Tz5gq9nosbxKryAvI7JmYN/jMk39bok9q0Hro?=
 =?us-ascii?Q?MPJvrFgDtNLo6rrZUV4B+qkpEa2IQcZWumDf+Pbt5fX7MQ8Mh2n5bcN/gf7R?=
 =?us-ascii?Q?uohh4POcFtmbRnljDlkKbfu/mbONdckEpyafRbehJOvZgy8ZY/NzLxSKupQk?=
 =?us-ascii?Q?HHhdZcnUkNtOieDvGNfExnepBksh8uVqt+3lxhvHTslJJfnp4ARC/CrFI9c1?=
 =?us-ascii?Q?TLVEyTg1BIqpG10PF7H0+RNyCTiKf7IP9GVg8MLZWCH/sB6xFwC4ZSOcJ8MW?=
 =?us-ascii?Q?o0VrpmoWa4ZmXSDZ9V8QvWU5csNjtnXpyl3kXwRtqwfUw7khZ9F/4s0SGmDW?=
 =?us-ascii?Q?YDz340l+EljtCPmrBaeQViPMtIxDa7q3BswJ4H7tCherMq+JOMb84GZGI2qB?=
 =?us-ascii?Q?5Txmn3bMV0FgvLhZhPy37BiIfJWkA7POjIlCfMiOMDudHH8DipRMtJEEScbV?=
 =?us-ascii?Q?0+M/CVXRFlSGPF6ZHxm+a3FfVd+rhc7K7lAROV/Tdduas6imxmjRUDYRKH4k?=
 =?us-ascii?Q?DY+m1RRiQMC6OIc5snlAq9lMQiuXcbcSAnuSbRasCHJ8tqy+lsn0mnPpKv42?=
 =?us-ascii?Q?sgA+aDn/EFvI5ZLmGIEvmrxVcwS2Jet1Je22UmaSJS360oMKOJYjw7OG58QI?=
 =?us-ascii?Q?48aAIqV7gPFAqSNiareorTlK+vCp0RHDYRaIhH7ewaxH8rlzG9wgzcfPxvWS?=
 =?us-ascii?Q?aiw4wIAzYX4yOIWdeY6rvt0aHFPjuVGH9UbNJUXz+Xu7/D5vnEKAGW3zIVWI?=
 =?us-ascii?Q?4hp/cMwiDF6p7TG4jlGjjhHrV8OR+1FE41WxLlqnDKVWRzwNiEhga4YuF8AJ?=
 =?us-ascii?Q?52amsiqvbU4KxIljZJ7qal4V1fx3GxIIb+A0HC9iRG1io7+9lm5uHK3uEdin?=
 =?us-ascii?Q?r7haB9a8ALlY+2mc9Pf3Aj6jh8JQYfc+Qkdkt3dzMVNVIAG5ogeOb3Xq7kpp?=
 =?us-ascii?Q?1I5bWF+jSM7ezYEE77s05o0tt7pUtxjPTMheviRxWg9jcak8svw/nBa3o9m0?=
 =?us-ascii?Q?PPB2rltDAJWXU+2UNE0eNJTer+OqEzJZARS6XjZDoe3L3RRsQpae1udZGKug?=
 =?us-ascii?Q?rVvogsbe6uPzWrIs+nYdmVPgrLnwA1nL02HDBIVZK2h7vsPR0J4EDg//9g6j?=
 =?us-ascii?Q?tGBpAF1t5gadck7Z2jCeusADwhrYshGs7rMSZ442HDpc+9V9AqjiOeOofmac?=
 =?us-ascii?Q?w/C0CN2RdQ1gpzOswieoLQEIo9SuJ80QNrENMSE7ctCxf21izEK89+pJVbUI?=
 =?us-ascii?Q?bpg+SqsSX+Wl22z6JY9jF8H6nkiXqdt5jHQQHNbIvDzOkLE733lIUSyVkm5N?=
 =?us-ascii?Q?t0cOoAYh8R/IHfZhbnpO/6oC6VUBC07cvMxq9WjwtxEjS2S7XBFtvOYvFD6U?=
 =?us-ascii?Q?D2diZTq4wqlcHIM4H8z+U3vhbtQGQFB0k5adDeFei2amZz7qhR/L4jdxG6NH?=
 =?us-ascii?Q?7UBbrarZJO1q8i9BoyF0Z8CKXsLa8quAbyjEfdoxqJ+3WUQGsQcLVGSAoIbN?=
 =?us-ascii?Q?bH7TbYJ8qJmPYZp6HNK08qTddbrWiQqefiXVHRGn2Y6YSLsbuxq5LODbALWF?=
 =?us-ascii?Q?oM1TyFz4hHnN0Fykamtat6KJaEtmuEFyO1Q49pXj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ec4890-2ba6-4c09-03e9-08daffb986a7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:32.2420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OldU9v+CDRsy/aGtO/5zPIP0fwJuxODGhXG5n9TvSnNUk4rQJ8SUjEDFb7nQ3yVdZAnd8Bi/bHZzNpgtU4HMyQ==
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

This commit introduces direct data placement offload to NVME
TCP. There is a context per queue, which is established after the
handshake using the sk_add/del NDOs.

Additionally, a resynchronization routine is used to assist
hardware recovery from TCP OOO, and continue the offload.
Resynchronization operates as follows:

1. TCP OOO causes the NIC HW to stop the offload

2. NIC HW identifies a PDU header at some TCP sequence number,
and asks NVMe-TCP to confirm it.
This request is delivered from the NIC driver to NVMe-TCP by first
finding the socket for the packet that triggered the request, and
then finding the nvme_tcp_queue that is used by this routine.
Finally, the request is recorded in the nvme_tcp_queue.

3. When NVMe-TCP observes the requested TCP sequence, it will compare
it with the PDU header TCP sequence, and report the result to the
NIC driver (resync), which will update the HW, and resume offload
when all is successful.

Some HW implementation such as ConnectX-7 assume linear CCID (0...N-1
for queue of size N) where the linux nvme driver uses part of the 16
bit CCID for generation counter. To address that, we use the existing
quirk in the nvme layer when the HW driver advertises if the device is
not supports the full 16 bit CCID range.

Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments via ulp_ddp_limits.

A follow-up patch introduces the data-path changes required for this
offload.

Socket operations need a netdev reference. This reference is
dropped on NETDEV_GOING_DOWN events to allow the device to go down in
a follow-up patch.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 263 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 254 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 70e273b565de..b350250bf8fb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -16,6 +16,10 @@
 #include <net/busy_poll.h>
 #include <trace/events/sock.h>
 
+#ifdef CONFIG_ULP_DDP
+#include <net/ulp_ddp.h>
+#endif
+
 #include "nvme.h"
 #include "fabrics.h"
 
@@ -104,6 +108,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_ALLOCATED	= 0,
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
+	NVME_TCP_Q_OFF_DDP	= 3,
 };
 
 enum nvme_tcp_recv_state {
@@ -131,6 +136,16 @@ struct nvme_tcp_queue {
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
 
+	/*
+	 * resync_req is a speculative PDU header tcp seq number (with
+	 * an additional flag at 32 lower bits) that the HW send to
+	 * the SW, for the SW to verify.
+	 * - The 32 high bits store the seq number
+	 * - The 32 low bits are used as a flag to know if a request
+	 *   is pending (ULP_DDP_RESYNC_PENDING).
+	 */
+	atomic64_t		resync_req;
+
 	/* send state */
 	struct nvme_tcp_request *request;
 
@@ -170,6 +185,9 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct net_device	*offloading_netdev;
+	u32			offload_io_threshold;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -261,6 +279,198 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+#ifdef CONFIG_ULP_DDP
+
+static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
+{
+	return test_bit(ULP_DDP_C_NVME_TCP_BIT, netdev->ulp_ddp_caps.active);
+}
+
+static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
+				      struct ulp_ddp_limits *limits)
+{
+	int ret;
+
+	if (!netdev || !is_netdev_ulp_offload_active(netdev) ||
+	    !netdev->netdev_ops->ulp_ddp_ops->limits)
+		return false;
+
+	limits->type = ULP_DDP_NVME;
+	ret = netdev->netdev_ops->ulp_ddp_ops->limits(netdev, limits);
+	if (ret == -EOPNOTSUPP) {
+		return false;
+	} else if (ret) {
+		WARN_ONCE(ret, "ddp limits failed (ret=%d)", ret);
+		return false;
+	}
+
+	return true;
+}
+
+static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
+	.resync_request		= nvme_tcp_resync_request,
+};
+
+static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct ulp_ddp_config config = {.type = ULP_DDP_NVME};
+	int ret;
+
+	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
+	config.nvmeotcp.cpda = 0;
+	config.nvmeotcp.dgst =
+		queue->hdr_digest ? NVME_TCP_HDR_DIGEST_ENABLE : 0;
+	config.nvmeotcp.dgst |=
+		queue->data_digest ? NVME_TCP_DATA_DIGEST_ENABLE : 0;
+	config.nvmeotcp.queue_size = queue->ctrl->ctrl.sqsize + 1;
+	config.nvmeotcp.queue_id = nvme_tcp_queue_id(queue);
+	config.nvmeotcp.io_cpu = queue->io_cpu;
+
+	/* Socket ops keep a netdev reference. It is put in
+	 * nvme_tcp_unoffload_socket().  This ref is dropped on
+	 * NETDEV_GOING_DOWN events to allow the device to go down
+	 */
+	dev_hold(netdev);
+	ret = netdev->netdev_ops->ulp_ddp_ops->sk_add(netdev,
+						      queue->sock->sk,
+						      &config);
+	if (ret) {
+		dev_put(netdev);
+		return ret;
+	}
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
+	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	return 0;
+}
+
+static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+
+	if (!netdev) {
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
+		return;
+	}
+
+	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+
+	netdev->netdev_ops->ulp_ddp_ops->sk_del(netdev, queue->sock->sk);
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
+	dev_put(netdev); /* held by offload_socket */
+}
+
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
+				    struct net_device *netdev)
+{
+	struct ulp_ddp_limits limits = {.type = ULP_DDP_NVME };
+
+	if (!nvme_tcp_ddp_query_limits(netdev, &limits)) {
+		queue->ctrl->offloading_netdev = NULL;
+		return;
+	}
+
+	queue->ctrl->offloading_netdev = netdev;
+	dev_dbg_ratelimited(queue->ctrl->ctrl.device,
+			    "netdev %s offload limits: max_ddp_sgl_len %d\n",
+			    netdev->name, limits.max_ddp_sgl_len);
+	queue->ctrl->ctrl.max_segments = limits.max_ddp_sgl_len;
+	queue->ctrl->ctrl.max_hw_sectors =
+		limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
+	queue->ctrl->offload_io_threshold = limits.io_threshold;
+
+	/* offloading HW doesn't support full ccid range, apply the quirk */
+	queue->ctrl->ctrl.quirks |=
+		limits.nvmeotcp.full_ccid_range ? 0 : NVME_QUIRK_SKIP_CID_GEN;
+}
+
+/* In presence of packet drops or network packet reordering, the device may lose
+ * synchronization between the TCP stream and the L5P framing, and require a
+ * resync with the kernel's TCP stack.
+ *
+ * - NIC HW identifies a PDU header at some TCP sequence number,
+ *   and asks NVMe-TCP to confirm it.
+ * - When NVMe-TCP observes the requested TCP sequence, it will compare
+ *   it with the PDU header TCP sequence, and report the result to the
+ *   NIC driver
+ */
+static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+				     struct sk_buff *skb, unsigned int offset)
+{
+	u64 pdu_seq = TCP_SKB_CB(skb)->seq + offset - queue->pdu_offset;
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	u64 pdu_val = (pdu_seq << 32) | ULP_DDP_RESYNC_PENDING;
+	u64 resync_val;
+	u32 resync_seq;
+
+	resync_val = atomic64_read(&queue->resync_req);
+	/* Lower 32 bit flags. Check validity of the request */
+	if ((resync_val & ULP_DDP_RESYNC_PENDING) == 0)
+		return;
+
+	/*
+	 * Obtain and check requested sequence number: is this PDU header
+	 * before the request?
+	 */
+	resync_seq = resync_val >> 32;
+	if (before(pdu_seq, resync_seq))
+		return;
+
+	/*
+	 * The atomic operation guarantees that we don't miss any NIC driver
+	 * resync requests submitted after the above checks.
+	 */
+	if (atomic64_cmpxchg(&queue->resync_req, pdu_val,
+			     pdu_val & ~ULP_DDP_RESYNC_PENDING) !=
+			     atomic64_read(&queue->resync_req))
+		netdev->netdev_ops->ulp_ddp_ops->resync(netdev,
+							queue->sock->sk,
+							pdu_seq);
+}
+
+static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
+{
+	struct nvme_tcp_queue *queue = sk->sk_user_data;
+
+	/*
+	 * "seq" (TCP seq number) is what the HW assumes is the
+	 * beginning of a PDU.  The nvme-tcp layer needs to store the
+	 * number along with the "flags" (ULP_DDP_RESYNC_PENDING) to
+	 * indicate that a request is pending.
+	 */
+	atomic64_set(&queue->resync_req, (((uint64_t)seq << 32) | flags));
+
+	return true;
+}
+
+#else
+
+static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
+{
+	return false;
+}
+
+static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
+{
+	return 0;
+}
+
+static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{}
+
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
+				    struct net_device *netdev)
+{}
+
+static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+				     struct sk_buff *skb, unsigned int offset)
+{}
+
+#endif
+
 static void nvme_tcp_init_iter(struct nvme_tcp_request *req,
 		unsigned int dir)
 {
@@ -703,6 +913,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1660,6 +1873,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1679,21 +1894,51 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	struct net_device *netdev;
 	int ret;
 
-	if (idx)
+	if (idx) {
 		ret = nvmf_connect_io_queue(nctrl, idx);
-	else
+		if (ret)
+			goto err;
+
+		netdev = ctrl->queues[idx].ctrl->offloading_netdev;
+		if (netdev && is_netdev_ulp_offload_active(netdev)) {
+			ret = nvme_tcp_offload_socket(&ctrl->queues[idx]);
+			if (ret) {
+				dev_err(nctrl->device,
+					"failed to setup offload on queue %d ret=%d\n",
+					idx, ret);
+			}
+		}
+	} else {
 		ret = nvmf_connect_admin_queue(nctrl);
+		if (ret)
+			goto err;
 
-	if (!ret) {
-		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
-	} else {
-		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
-			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
-		dev_err(nctrl->device,
-			"failed to connect queue: %d ret=%d\n", idx, ret);
+		netdev = get_netdev_for_sock(ctrl->queues[idx].sock->sk);
+		if (!netdev) {
+			dev_info_ratelimited(ctrl->ctrl.device, "netdev not found\n");
+			ctrl->offloading_netdev = NULL;
+			goto done;
+		}
+		if (is_netdev_ulp_offload_active(netdev))
+			nvme_tcp_offload_limits(&ctrl->queues[idx], netdev);
+		/*
+		 * release the device as no offload context is
+		 * established yet.
+		 */
+		dev_put(netdev);
 	}
+
+done:
+	set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
+	return 0;
+err:
+	if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
+		__nvme_tcp_stop_queue(&ctrl->queues[idx]);
+	dev_err(nctrl->device,
+		"failed to connect queue: %d ret=%d\n", idx, ret);
 	return ret;
 }
 
-- 
2.31.1

