Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302196D0771
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjC3N5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjC3N5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:57:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B622A245
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:57:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZC3f9vd5ipcmokwNAg6oEcGTW/bGL6qW5PxUoD7T8IYpyJ1wpcu4VuFjiJNzpmlNHdzzZt7cRuWRPhzX+kNxdRopnZnv78CsDl6WNo8rPEXIlZ7hO+s5SMvna4Q25AjRYcBhXB6anT9YJUI69/4lmzb5QZQx5w3H7t3FEDzZmiMZ4lc89160P2BCoxMSso6RuQK5hGQuIfZa5O55mT5Jrgn1EXx6djQXdMjs+RQBaFBfJ8RzKTABWcqDNl+BnxM8k2y/xLoLre0pKeUym2GDVPmQHrj76ElM/fo1ZA9jj7OXVGLICQzksN5rzchlC/kq+1AKX5T6VPIwO/HiHSvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+c5205Kl3p4r4usYT/Bl6lsXRQMr6ktIsFmFZrZ5oU=;
 b=nK+cYko/fw4XLv3v7kX8sLwxH+uwZBLu2bL3kTE+yrD+GvHQfM0MOBRywkakhaD9YIXEQeBitf5930wZXF0dp/DRtVtEX/NqsWgRzDvNDU4PuGFxqvoQFKmSdx+h7Aqob8fHlmbTV+rAoj0M2BBC7FpbYOTj1JYXnZSxqdcjG9yLGT1/EcjewRgmWZH+rMCJf+AMx068RMqRKSXWvULHqfjobqaKbufL2wE8AAySRGT8WmwJuqUVsyAyvYt9whCJKVB3Hkxiz9OJyttJu78X9ym1BqLPe1fl7r5P/lFZpkENucg9E3avY6zJSgilIqUoSEd1YZE7xHWdfQaT+8pyIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+c5205Kl3p4r4usYT/Bl6lsXRQMr6ktIsFmFZrZ5oU=;
 b=KMZerIVR3LkS1oxpa2MObskyBlIVCDekiAwNm4ztcvuG61XVJWwInr7tQhSvjOG+9hyuapTYeLnNqJXVXTNUHmGU+pBUEoA26hyAq5mk+NccVyl7jteJ5Mg7mnPU1OV/Ll860OyW7Ci6mFkFNwadsV1nGiTk+VOTcqvik+QcnZv0vjUsEIZmJAiy9Z4OAHHFrR0fYT3QPP5SuKYf12poldkctuXANmXlBXP5ZmLoxw9HV2GwSdLOJxIz1nmmPTdzn6+KiqoqtmDdcQzIJMfPUjBmYFVl/8a9MGeY9MbB0Y5zWfM292ZT4rI8UJ9t3HXexkKsnmtw/9rQsfSyGCYeUw==
Received: from CY5PR22CA0013.namprd22.prod.outlook.com (2603:10b6:930:16::23)
 by BN9PR12MB5241.namprd12.prod.outlook.com (2603:10b6:408:11e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 13:57:44 +0000
Received: from CY4PEPF0000C96F.namprd02.prod.outlook.com
 (2603:10b6:930:16:cafe::47) by CY5PR22CA0013.outlook.office365.com
 (2603:10b6:930:16::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 13:57:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C96F.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 13:57:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 30 Mar 2023
 06:57:33 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 30 Mar
 2023 06:57:33 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 30 Mar
 2023 06:57:31 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v3 3/4] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Thu, 30 Mar 2023 16:57:14 +0300
Message-ID: <20230330135715.23652-4-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230330135715.23652-1-ehakim@nvidia.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96F:EE_|BN9PR12MB5241:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ba0d09-cd1d-4e7e-b522-08db3126bc5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UT/hWgOkVeRz9ea4yAXGAdQmc9J0zlSnElHs97x42BqRZz/+f8e4V6KeAk6DAzQ5O/TRb1DaiEXaBqVcYvFMTWChFBbq5x6bztK0rQR60P6BTflM48C5w/KbvISIOfvHX70Yk6c367YvBMvGsBhtqhYFmt8umtBOJREE+8DI7B7Cmi3VTXHAe6xTmDbDVkbdCjPKQ1NtbAveAx2jbCJwn//pQ4mlSRlYKQk4TM2D1RQs5QuSy/hy72FR8zgHGEk427gAiALw6vr/ftaH+QdAhcwrO+OH7UldUIiw2pG+YqDlYFnOxPZwjwjjUhdiMgWgoEU97q01AY7TUthPSd2VjYiZ2Jym7N9hSuLipH9TSoJhaT+LCPXFbSqC78wJzvxa9oikIN4HYClI5F3W5D+jijiv09j0ZxhcvnxDbt5IvNmfd2N9CJ1sm2TEDAfYeTYnHTTCdBMB4rsUGACgPrIT5fRVaEUDJzSLufcZZp+2OY19J6Uz3DherfuU8poF7t+rm5vYOz45HHXz4RRQGT+bPBHrqmqCpGbmGhkUcf8Uovsg+kNJmjzeDmZAXbYIrxCruNVHXvOktaav0lEm0V1eNqAe3l3uvwDPEkzgDoCcAJ7sZAHBvO62L5dvUK535dXF4mCfNk/lyQmb69UTDq5kOTS3xEBMtV+XAEPO7csP5TOoJK5MAMvVZNx2M74PWeAVbFLoFgNrBMHpkxTOkbw7Rddg7gexN64bHMSuS/gqIPQmfEI9lR538Qzy3VJSECn0
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(36860700001)(40480700001)(110136005)(316002)(54906003)(4326008)(8676002)(356005)(70206006)(41300700001)(70586007)(82740400003)(186003)(26005)(47076005)(83380400001)(426003)(336012)(2616005)(1076003)(7696005)(478600001)(6666004)(107886003)(7636003)(86362001)(82310400005)(5660300002)(2906002)(8936002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:57:44.0336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ba0d09-cd1d-4e7e-b522-08db3126bc5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5241
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading MACsec when its configured over VLAN with current MACsec
TX steering rules will wrongly insert MACsec sec tag after inserting
the VLAN header leading to a ETHERNET | SECTAG | VLAN packet when
ETHERNET | VLAN | SECTAG is configured.

The above issue is due to adding the SECTAG by HW which is a later
stage compared to the VLAN header insertion stage.

Detect such a case and adjust TX steering rules to insert the
SECTAG in the correct place by using reformat_param_0 field in
the packet reformat to indicate the offset of SECTAG from end of
the MAC header to account for VLANs in granularity of 4Bytes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c   | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 5b658a5588c6..daaaaf344f77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -4,6 +4,7 @@
 #include <net/macsec.h>
 #include <linux/netdevice.h>
 #include <linux/mlx5/qp.h>
+#include <linux/if_vlan.h>
 #include "fs_core.h"
 #include "en/fs.h"
 #include "en_accel/macsec_fs.h"
@@ -510,6 +511,8 @@ static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+#define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
+
 static union mlx5e_macsec_rule *
 macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		      const struct macsec_context *macsec_ctx,
@@ -555,6 +558,10 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	reformat_params.type = MLX5_REFORMAT_TYPE_ADD_MACSEC;
 	reformat_params.size = reformat_size;
 	reformat_params.data = reformatbf;
+
+	if (is_vlan_dev(macsec_ctx->netdev))
+		reformat_params.param_0 = MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES;
+
 	flow_act.pkt_reformat = mlx5_packet_reformat_alloc(macsec_fs->mdev,
 							   &reformat_params,
 							   MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
-- 
2.21.3

