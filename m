Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003326D076E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjC3N5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjC3N5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:57:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D7E4EFF
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6RqC3ppwfCu15H3XgduXP+AwWw03YAB/4f5V6Zq8Qx8lMJqbEpzg27Kfnpy2c7EF1MwKUWkKj+Mz4YwfMf25MC7+Lolr61pg5LD0ASkTKrbRnG1l63IeRdENgclOq6t3+dN4l6xXNsaxAw46dmAEKxwq4YWhUhPLhRbg5PT9zSDy9d+GagPb13KBULnVxpNg4eQcS4OGt4JXHbhkGhYUZS3rfXL9cW3gBRGM2A1gT6yjYZWFxx3HxPAyRfiv+yEF9WYO23PAouqFMZJTCKtvGN3Iy2NiTR/an47R509zMTnb4xtRONMj0xvME8/7bqGhC/7wl4x3/1V1YqZUe4tow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfldXWd4CkDWCBDw0FXwTC5HmUn6k/kC8gxu/ulMUn8=;
 b=m/LL2f1WEmmojZsbc0MWOJlqbbPxBvspJtlnBLBe9ftCVt5P/7E8uxJo3xc1Q4RVrbbKBs4uvSnSTSkLuwH1NJC5ZMTp1YPXy3WNnxD7JNxfqjHiCEmI/lAWaaNoJ2nndqo5vNk4ty4uu6qNfjdYiOvWKYQ+v0cPdOWcondPQgy7l8MOvqejpoK3urw4nkQ3uyjnVyiVPOA1wxWYpNZY8ulyKiIy0HcveO5n7MGXv8cl9bWubE5kFwayw7FlQF/eiWL279468JdKFFi0/ftliTyak626TFhExZ9Iy0B20nTZp9TUUBzrI+M6CT6vQPIZpyC+6S7Az7xa8MiCWww6+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfldXWd4CkDWCBDw0FXwTC5HmUn6k/kC8gxu/ulMUn8=;
 b=GrNgHMrIvzFe4/+QVuQxeYPPUJq2LIDoYdQfPyuDlznAtupuHa30AddaMCkb0lRD3qCPS6ELZZksb7kGCxlqaybuGWaE4P0W4IkR8Gw7/wuvahEbvlmnHUliQwqzBrwnnlcCyFYrQ+gecYA6vwy6dWsiFr7L4DXY5ejm3+DT6/lGpf6we7mk+/bQOLFhv8O5Daql1ipPC5LHYTFWqnGa0Mnfe+6lJospXN/KrSOrQf+nYjDNjwYFJgS+1f+zG0G9ZBQ3zO8E0IRiXlJdH2ZxhYCuh0MTdtHmV8e5ikOCGobn+Kaj9WsLVsRGTFf7zeoCBNneTFKIA7CH4y61XNgzXw==
Received: from CY5P221CA0112.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::32)
 by DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 13:57:40 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:930:1f:cafe::9b) by CY5P221CA0112.outlook.office365.com
 (2603:10b6:930:1f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Thu, 30 Mar 2023 13:57:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 13:57:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 30 Mar 2023
 06:57:28 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 30 Mar
 2023 06:57:27 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 30 Mar
 2023 06:57:25 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v3 1/4] vlan: Add MACsec offload operations for VLAN interface
Date:   Thu, 30 Mar 2023 16:57:12 +0300
Message-ID: <20230330135715.23652-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230330135715.23652-1-ehakim@nvidia.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|DS0PR12MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: a90c91f9-7d36-44df-a8b9-08db3126ba06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Js9AUulxQm6BFXGKJlG3ikmFW/6tKW89TLeCnKx7i6eWhiCXEluL7e5jgRY8onCjsZ2NnpB44/xaf0YHAt2kZ5/3IRCUdf4yE8Yc1SKJqaTbXkfze6zVeYSYHjRPN1Fm2Kg0ZDZCJEgADkWbmrqNy2j9SWSr9ikzoQSkoHuG4Agp3ZrYs++j/L9wAnC5mXjosg5OOasM7/UpEvvdwYTMe530wiRb4RAB+F39oTOcUyaOP0XRBrBSb9ZGixSVMdekm6xFWqBRf7T1e6iSFwURo8t8vhfuh09uu7I2vXKcAkMjVc0qso3E+wfsHFSvvZUTf2elj/WsRl2Aq1AWCAoCAeARjzjNM4EgzY+mv51kXfOy7+vy3ale8Mpml3mAqyyglGQomvedJq1f8lpvO6/1ByFhSvy37EhRvj8VDejMWLfhXW+I8N+sXeSauhw9Sr1h7zsrdepTw5h9SuxPYBi04BdhjBjekLXeErLy9k11+kv7tsmohjjNBrE4j2k2wKq6sc2wu/nASJ89RzVniWetrqFxePOC70bPxZhsxdQ90M4oncwEOPcofTx+A8j6ubiGryN1gdAiH3GYVE7A6iqAUvm16b+eB2ijpWMery0QRdPmf6usXKDzaCEpGvqz1r6QRbjPSzf+BnML0OFJlQl3YggLPj7MEcy2zVznRJzC8iZ63HwK+wj/TnGItP0oQUUvWLSahZeqTub5i4Go0PBRQTD1CWUxeFyblj3jTtTllO9XABlPZ22XvQfqMzyLb7H
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199021)(36840700001)(46966006)(40470700004)(47076005)(40460700003)(7636003)(4326008)(5660300002)(8936002)(356005)(86362001)(82310400005)(70206006)(82740400003)(8676002)(40480700001)(70586007)(41300700001)(36756003)(83380400001)(426003)(2616005)(336012)(26005)(36860700001)(54906003)(1076003)(6666004)(110136005)(107886003)(2906002)(478600001)(7696005)(186003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:57:40.1011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a90c91f9-7d36-44df-a8b9-08db3126ba06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MACsec offload operations for VLAN driver
to allow offloading MACsec when VLAN's real device supports
Macsec offload by forwarding the offload request to it.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 net/8021q/vlan_dev.c                          | 153 ++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6db1aff8778d..5ecef26e83c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5076,6 +5076,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
+	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..16efc1bfc345 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -26,6 +26,7 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <net/arp.h>
+#include <net/macsec.h>
 
 #include "vlan.h"
 #include "vlanproc.h"
@@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
 			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
 			   NETIF_F_ALL_FCOE;
 
+	if (real_dev->features & NETIF_F_HW_MACSEC)
+		dev->hw_features |= NETIF_F_HW_MACSEC;
+
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
@@ -803,6 +807,152 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MACSEC)
+
+static const struct macsec_ops *vlan_get_macsec_ops(const struct macsec_context *ctx)
+{
+	return vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops;
+}
+
+static int vlan_macsec_add_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_add_txsa)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_add_txsa(ctx);
+}
+
+static int vlan_macsec_upd_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_upd_txsa)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_upd_txsa(ctx);
+}
+
+static int vlan_macsec_del_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_del_txsa)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_del_txsa(ctx);
+}
+
+static int vlan_macsec_add_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_add_rxsa)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_add_rxsa(ctx);
+}
+
+static int vlan_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_upd_rxsa)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_upd_rxsa(ctx);
+}
+
+static int vlan_macsec_del_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_del_rxsa)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_del_rxsa(ctx);
+}
+
+static int vlan_macsec_add_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_add_rxsc)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_add_rxsc(ctx);
+}
+
+static int vlan_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_upd_rxsc)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_upd_rxsc(ctx);
+}
+
+static int vlan_macsec_del_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_del_rxsc)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_del_rxsc(ctx);
+}
+
+static int vlan_macsec_add_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_add_secy)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_add_secy(ctx);
+}
+
+static int vlan_macsec_upd_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_upd_secy)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_upd_secy(ctx);
+}
+
+static int vlan_macsec_del_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops || !ops->mdo_del_secy)
+		return -EOPNOTSUPP;
+
+	return ops->mdo_del_secy(ctx);
+}
+
+#undef _BUILD_VLAN_MACSEC_MDO
+
+static const struct macsec_ops macsec_offload_ops = {
+	.mdo_add_txsa = vlan_macsec_add_txsa,
+	.mdo_upd_txsa = vlan_macsec_upd_txsa,
+	.mdo_del_txsa = vlan_macsec_del_txsa,
+	.mdo_add_rxsc = vlan_macsec_add_rxsc,
+	.mdo_upd_rxsc = vlan_macsec_upd_rxsc,
+	.mdo_del_rxsc = vlan_macsec_del_rxsc,
+	.mdo_add_rxsa = vlan_macsec_add_rxsa,
+	.mdo_upd_rxsa = vlan_macsec_upd_rxsa,
+	.mdo_del_rxsa = vlan_macsec_del_rxsa,
+	.mdo_add_secy = vlan_macsec_add_secy,
+	.mdo_upd_secy = vlan_macsec_upd_secy,
+	.mdo_del_secy = vlan_macsec_del_secy,
+};
+
+#endif
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -869,6 +1019,9 @@ void vlan_setup(struct net_device *dev)
 	dev->priv_destructor	= vlan_dev_free;
 	dev->ethtool_ops	= &vlan_ethtool_ops;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	dev->macsec_ops		= &macsec_offload_ops;
+#endif
 	dev->min_mtu		= 0;
 	dev->max_mtu		= ETH_MAX_MTU;
 
-- 
2.21.3

