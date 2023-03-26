Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E3F6C92F9
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCZH1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjCZH1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:27:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5BAA5FB
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 00:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmYiWS4QbxQxNAIw2ZPEL3JO+wJyf2AAOZLCdHEX61OAOMG8hQUrmVWu+DtoT0UgvYb1a6lDVwgLyiPqBadM2/uyVQy0uG8GVR+s+4JlL1+Q5TI4WEJD9gYIGKYnD7ngyOb3rKYinTDnFAFfRTZlKExg3TVlpiq4P4DSaCPD9U8iKtSV7HigFH7PHcCcTSbWtCjxLvXauZqP1X0N0pryE70QD1ZAfcjRkIW/Z0kM6RM8rHPj7sDKzi4cttiOWb9tILBza54I1DujWa1fQGukPJD5LxmTn1Cn7ABZOJ4nzvxZsErSmFfSrGwpo1NrO5xcPjHSfQP0DO9PZjCL+mrOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+c5205Kl3p4r4usYT/Bl6lsXRQMr6ktIsFmFZrZ5oU=;
 b=DPR1VJsTsdguMLzlXUClCLq8vtWR7J40hT4+9+RjAUW9jfYp/E5Ouk2q2XIONiThDyamuhtRzCE7QE38Z/UddXw8ygtYGjiUHUg1OJeHc3Ly/RVI+IArHJy8uiAXBicV4YeTBUoyxFBiYcvrh4rvQAhGjloSDN/6WlrZ2T+Gcw5vfNCjpSpbjq5BsrI2HgdKmD/6Jk3UUWWlHuPCjDrD4ZvaR2vjVPI9/PDA79aYADhjSpjZfYhH5WkksmPn4XSOG0o/169fkoMRP1RK0PQx3XpEMiyueeHlzNjeihpy+Z618CS/8DkTpqn5wpVEm1hwIKVUIGyRVgeTOhUc6I73Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+c5205Kl3p4r4usYT/Bl6lsXRQMr6ktIsFmFZrZ5oU=;
 b=Tp20V7681e+GeCxzNGDUznEXcuF4qCrMpPShFgfPq/ZtVTcLVJw9BnLM1ueKSd7lAwrP/BlnLhiNcWtNh96xM/8oWKg5E/jG3ycTV91tCT+cOsZuLhtHzEoYlMhFUeTQEVCL+mgWSa44OxRYIkxa6PkLXrprBUn4k9QZonHpZDwDTsBkSSJcgIa1IJyL11xx3AfYQDFTx6ymTgABur20Csyas+cDa7IJJGh8TglJU8xxB2NfmMXo/eH6XZfrUTP9LerpNf6qGkeA5pQf4VlJC0ka7K748GdcS9PkeSxhDae166ANYpZYvbEi0n1HzzJq1nFyv77Kc6wznOrTonKfGQ==
Received: from BN0PR04CA0018.namprd04.prod.outlook.com (2603:10b6:408:ee::23)
 by PH0PR12MB7487.namprd12.prod.outlook.com (2603:10b6:510:1e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sun, 26 Mar
 2023 07:27:45 +0000
Received: from BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::87) by BN0PR04CA0018.outlook.office365.com
 (2603:10b6:408:ee::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Sun, 26 Mar 2023 07:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT077.mail.protection.outlook.com (10.13.177.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Sun, 26 Mar 2023 07:27:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 26 Mar 2023
 00:27:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 26 Mar 2023 00:27:33 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Sun, 26 Mar
 2023 00:27:31 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 3/4] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Sun, 26 Mar 2023 10:26:35 +0300
Message-ID: <20230326072636.3507-4-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230326072636.3507-1-ehakim@nvidia.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT077:EE_|PH0PR12MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: bed7e468-91c5-40f0-65b7-08db2dcb97b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CWJzNC1FlL+yaPcRCoGu2vml4PuaV3OxNyqnv1q+qbn+YFMLtpt1FmaUx62S120UjLdPJaycxv8O6R9Oj7AnVEe4mdpGkthiEcb6zE9jV/VdYtH0FREpRv5vX936nhLVJfGCAsMFfdfigPVdTVjmwGnghkNVkTtVysnN6rDhbHqMVN63QCvOsS932jKu54YXb2cXWAaVVEMlktJ2+gWQWrEb8+tt1KT/m6eXtFLbNTJ1foY8ydcFX35113T/tCspGBVOcoj3pkVDZYVHDB8WYkfWgfEQi0dMjJPuYwnx3lhaXNhPoasHTCxftu9X4zHdIL9FLNFL0FfD5xoTFa54x0JjREMSbIDPbykeJ12/f2OmXY3xIFeRr9DDPdEYNQxJyd29Mtrs5Gmzao3rOE0eooiQ/2zIou2gGXt7SQpQ/GWmyqpQDpFgxbLOBuCh/8wic73EIy3McewdFOfaEApHnGNeZddu7SNaw4sVnAvoisAek9dLSKZ30blY87KtEaLGjPn0Z25IETJfFP71DPjkdigWf/XKNGLh17Gvc2zq79iRNhdK0mh0PwlQmpJSViiJYMLWYMFS8ncg6sIOkmqWA+WGV4d4zAww2CywCCB/3V/QNTO6oXZXjmyA/90Z0SSvCyTOPdzvDWN3sDJAqtM38WmT9APCJhMmILMbO73/t7jMnxJM0qDaDsRSAMS/DSm+XkWFpy13gIdPDdtbPDqDtqfzUAcfXKXwrlXrJpPMkvJ7m0EIKvwDcmN3PiHPzIKqZyTCwGHwaiWjp0Dd3MM+Spnn7riqYUW3rjEC1ZwU45A=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(40470700004)(46966006)(36840700001)(36756003)(336012)(70586007)(7636003)(41300700001)(40460700003)(26005)(8936002)(8676002)(4326008)(186003)(36860700001)(426003)(86362001)(1076003)(83380400001)(40480700001)(356005)(2616005)(478600001)(54906003)(110136005)(107886003)(5660300002)(82310400005)(2906002)(34020700004)(47076005)(316002)(70206006)(82740400003)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:27:44.7713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bed7e468-91c5-40f0-65b7-08db2dcb97b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7487
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

