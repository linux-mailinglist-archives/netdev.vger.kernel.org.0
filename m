Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E6C6899E5
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjBCNiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBCNiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:38:12 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA73E1167B;
        Fri,  3 Feb 2023 05:38:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFSu07Pwyn87ev+NG9HJauHkbkO3qCGaP2JjVtqbKtajxcqNfilM7cqbmpcAG5b0h8qvaOrdW9Gza0/A/Y+quXg2wGuDh3sSlHTpjZk5aRRrYXX3xYHGO/FbvAc3ef7VUjWQkPbY3s005EoapTk+QcuY7vxHLfITcEkrwf2YPo8xNPpqJNyvW5SyKc1DE0G2u9CcXjRW1B/m/Ghujfa9h92SaZj3yLQ+BAh+PwWUrY0ZN9Ts8lQg8cPmK9bUjRPwoV96rc+Bu3zeFc0miuFLOuXRHpJqgXJ06yViarLifHZiLkZ0NWthIkQZAIGPGyVAMGT23jNFzMlW4ebg0sOWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cva6VJDvB1x+ZVPx+3mcK2Hh0vn7JnluBXHff9CISc=;
 b=VdMR7Gqk6g8E+ICxoufJp0i9mJnQS4yury2r6NPqetRdoBKEOpBDD83PmmrnS3bzqrac46GTYJdrxGMFEIYYxRZV0qTKfJBpVu6QDk2la9fPM+T7KF7oPyTK4ycokIRyAjBRgBBUUaBJiliQZocXYR1oAd548Nrp60s9yTnwLB87gz3vjK6w/YVx6OhMbqY79/Ldh1WU7f4u7WIPMLmE//ER3xjhNdOcrlN7ExdVCft3o2iNfUfXrygTdmNipEHTvwKpvSIwwTyUbPOCr4892Y/pvYeyV094NJTttmOUBNoiM9vMKOg7R/+VdRDWawGa4eLngYRBv4t+2b/TM9DH3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cva6VJDvB1x+ZVPx+3mcK2Hh0vn7JnluBXHff9CISc=;
 b=fGBlukxrXwVyC9CBRag23wM2SYQtXeo3VMjEDSnsNUMZ6364twWZEfX7B3xAR9kYrvbMp2T0ZkYIEBoyMN2qkFZA/X6ZS7cLaGMilK01y95Xk/Uv7dIa7+WHa0t2rf52Ze4Pf2f69NxJg2m6CMCHltZhEZUSpHWxhK0UIwq2cdIys9dJhHahC41WacNN/rS0uBzVtrhNQpnDyVx5YIe9drp+9gAOAspyKqGd1sbsLhbr0P3dmb1t/uZbJU6qyhitbTTcbC6xcIMui9C0qeT050UpGeZz7lTtJToM3Vr6Kpzb0MTnoer6CC3I81tX56SRcbpNZTr8xtABYd/VRE1AGA==
Received: from CY5PR15CA0064.namprd15.prod.outlook.com (2603:10b6:930:18::17)
 by BN9PR12MB5292.namprd12.prod.outlook.com (2603:10b6:408:105::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 13:38:06 +0000
Received: from CY4PEPF0000C977.namprd02.prod.outlook.com
 (2603:10b6:930:18:cafe::3) by CY5PR15CA0064.outlook.office365.com
 (2603:10b6:930:18::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31 via Frontend
 Transport; Fri, 3 Feb 2023 13:38:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C977.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.18 via Frontend Transport; Fri, 3 Feb 2023 13:38:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 3 Feb 2023
 05:37:52 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 3 Feb 2023 05:37:50 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        "Parav Pandit" <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next] virtio-net: Maintain reverse cleanup order
Date:   Fri, 3 Feb 2023 15:37:38 +0200
Message-ID: <20230203133738.33527-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C977:EE_|BN9PR12MB5292:EE_
X-MS-Office365-Filtering-Correlation-Id: da46d0c5-6512-4e7f-6dca-08db05ebe178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BfJ+pkTmTGwkhyT1lfBu0s2fxzAYo5f5PLyVr6r6N/7iA8krlHFNvZ+mwaMzzfmrYoFrvu7UBuBS6BKmW45TvsmnY8g+c6oTlGRezJVvHr/CmmHrVnqwBa0+oB53WSM/HrfTHWujfIHdxzK+UaeIi1lPcRtWLyBUHI5ncp/8dmeKx9NOkMTpJZtXnzDVga41D7lrY8ZL7g0F4F72Iw2qawRPKtF9uDKUTlq+7E5TqJ8q+Zhq2Fd+WlIWAikQcseactH+pRhiQoUeBRw5TW63qdGOHtUS4rkSu7YdkDDBBHFN9cqq6LI8tnjxB+OqZLiK5GD8SL7uVNInCSBwXi+WV7f8KOv2p0plMiBUv4SBn29r9rj8UzjysPMCQtVm29Fh1wNPxCerAM7IxDJ0v845LpLlNAbzOrw2qX640qUrUPEzZ4ac8qUXQ2yeVFWmHUS812PNQAFv6Nmba22oVbJqGanVV2Z7goEb0EKmDIa2xj6eEVVhKJiJDRQZv7mc2qE/7pBDVwxnVid9K5kYzJMu8eahxhW3GZvtq25FelIyKM/UAlvslSZ38XuQ79uitIG2WalsXqTXpzscm9NqqE/UUSPr12rs/9WcQnxNPC4spFD0hHuxCKcDCTWWo5Epkj4fe79nZsku3eL2Y9UTZls/+CqNLC+gDjVmz2+xqf4Mal7fa0+4CK7+1/oXLXNFnxk/LneUboVePdx5uDDQya7zQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(36840700001)(40470700004)(46966006)(2616005)(36756003)(16526019)(86362001)(186003)(2906002)(26005)(107886003)(6666004)(8676002)(478600001)(36860700001)(5660300002)(1076003)(82310400005)(4744005)(7416002)(336012)(40480700001)(356005)(110136005)(54906003)(83380400001)(426003)(316002)(8936002)(70586007)(70206006)(47076005)(4326008)(40460700003)(41300700001)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:38:06.0032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da46d0c5-6512-4e7f-6dca-08db05ebe178
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C977.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5292
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To easily audit the code, better to keep the device stop()
sequence to be mirror of the device open() sequence.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b7d0b54c3bb0..1f8168e0f64d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2279,9 +2279,9 @@ static int virtnet_close(struct net_device *dev)
 	cancel_delayed_work_sync(&vi->refill);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
+		virtnet_napi_tx_disable(&vi->sq[i].napi);
 		napi_disable(&vi->rq[i].napi);
 		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
-		virtnet_napi_tx_disable(&vi->sq[i].napi);
 	}
 
 	return 0;
-- 
2.26.2

