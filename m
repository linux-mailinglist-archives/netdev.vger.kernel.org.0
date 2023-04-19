Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F1E6E7C47
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjDSOWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjDSOV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:21:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8A2BC
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/+MvNVsFW5CwdlhOf3ZyKWAe7dOJDBSdIYazM0vVQ03QBDGh07O/QLjKjwHOad1baWLCtZ/dWxbZMmRMpmG+AlXU+ruiWuW2p+N5vIxCAmwgcleFKoX7cgrIsHETy1rSuhzX6pHmtW8PaIA4Chnnb7zNhycms6KdReLk+wosslc4WyvVsFKUpt+sn5yHQFesQhHLyUKA3ESLHWNz8eYDNSI4xuLe6SBwBINN1o5hyJ2sBr/d8KLQsAXoA9G9elPZaoPu5C+vc5VwHyo4A77YSjtD6UONTUdOaB7bDT2q9CyCG0/AVA3h0fYpqeq3msOI1CKtOpmyQfHOf+iO9GWbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=dZ1MYpedOGvWE+BngGZKSbxQqY9idfNN9CZmYOvUkU1cmJoj8ESWDatf0qPBd4ZtpkMJGE0TvNEo9zv+ZEl7HBY7Ih4xknYK2Jpe1aiJELl88b5FcuzVwKg12DX/cEMLEHyqLqC760woYWeijMTcPwJOL+WkXcOP/00s67nFeFz6WVjdblLoDtCNfnHzLx3+NQBXeBI7xu4YxYqGl8YkvZPF5SYmDGJC7SNcmrcZrvMT8mdkHkXnYqsAeImCW3kISXOpsyiL5zYonI79gx8Bhj4BlY4YfO1yZ2NlqivNRvduxYmuLvhWayc+CpG1/Bu+JBv+xEmB3DvzJRlfegYzpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=JH0rcnCZyXnVqzuVtnqMtU6dAXwCmPwMeUDhG6Axf0tqZksGpLxPGHCAG78BGEkMhc4ydC/9e2SZimITIZ/lVYJwDDHd8JbASbKsDsr2wZF/LT4+3w/vMwMrf7cEChhlDepqvoYnmbaleMRcEeC1mmB2hhYBMHCXU099Qz7+CML7/ByF+SzqFEHOzzIT6OQ4UNbOmontsvF0RQw4J69NX2Wn7ZSegkwsGCKlR4c0ezYAWvBUeBsjdp+YttQ0yWtqHMW6AO1C/F/cWe7K5EN36rZnMGuDBNoZjepLjSeTjTHADg0Ah9XNDsUzleSZpc7vFxadqzAIWUXpMiuecDeFVg==
Received: from BN9PR03CA0512.namprd03.prod.outlook.com (2603:10b6:408:131::7)
 by CH2PR12MB4859.namprd12.prod.outlook.com (2603:10b6:610:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:21:51 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::26) by BN9PR03CA0512.outlook.office365.com
 (2603:10b6:408:131::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 14:21:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 14:21:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 07:21:40 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 07:21:39 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 19 Apr
 2023 07:21:37 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 1/5] vlan: Add MACsec offload operations for VLAN interface
Date:   Wed, 19 Apr 2023 17:21:22 +0300
Message-ID: <20230419142126.9788-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230419142126.9788-1-ehakim@nvidia.com>
References: <20230419142126.9788-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|CH2PR12MB4859:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ae87cc-bd7c-4296-ddc9-08db40e16af5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: km66aPIrvGmwmygqupEx03L2vZHzSGjAF8x1viYOR5N/EBxXMxazKnt2b8TkkgvWS5rcDeNqGd9CbeT2Uzke6TjxSQzYJz8SNlaitXvOI+xk5Nvgm1Bh1zgkpq4qiq0AwiHtosJdwdBGs93kpUEDERX4OCZHGCHR1NrSzMTzQ84wYDka+pdmvvCSVnZ06c+gpeMHNQqSG9SN2jIz9fpK8p6Dgf3PvmPS8qJ4KBhayxCEtSvxa1D3erbw3e+ZsFAPfJHOSSdrXWOTO+eoYBh86rZ4yTfE3ydkPSo7SeUrljmFleS8FSsvI58qounNLxmfOymW8eSmCEdm1YPD5Dj3fahGzqoiFMbNUFpe8GU3qDUi88O4tsTvJFlZ6stKLErTT5MDbzFu5H7kDSbEO0VCKpHwEGiVWUTD1lEFD6EfRqXqldq2/CiKEPEtvMhShVdsNDvDE/PIe7w7Ru7XrO+of1b3YRhF15AJMp58FZa3uNRoCOt+n0hr4YJkWIw/Z+KarJPZ9599+wW5Ptw9DR+7B1Jgp4+JWiZy0F9Gcdp4vaeSFvluo3J0yPVC70G/ppJd302QIT1hzIq6XGzr4ylSjGteDy+4ntzHxSp2624Rnlvb5FMrrJGNq3fvHG1EeFYTWCyB/gw/4cH3vjrbT19IFO7u+i6MXILzoU4K4u1fVellZp/JaZmUDuxFdH1QtRYjRSfLpl7sehliq3GN/UQUGFJA+Jxtj7pqGac99iDvSVftvxtUw1YmL2lcwpKiRWCqns0yFTf/rIsAwCK2pB8JQtbgZOt+ifRkPC3ZV36DxoY=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(8936002)(34070700002)(8676002)(316002)(82740400003)(41300700001)(4326008)(70586007)(70206006)(40480700001)(54906003)(7636003)(110136005)(356005)(186003)(40460700003)(107886003)(2906002)(36756003)(1076003)(26005)(83380400001)(426003)(86362001)(336012)(47076005)(82310400005)(2616005)(5660300002)(36860700001)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:21:50.7343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ae87cc-bd7c-4296-ddc9-08db40e16af5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4859
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
 net/8021q/vlan_dev.c | 242 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..870e4935d6e6 100644
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
 
+	if (real_dev->vlan_features & NETIF_F_HW_MACSEC)
+		dev->hw_features |= NETIF_F_HW_MACSEC;
+
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
@@ -803,6 +807,241 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MACSEC)
+
+static const struct macsec_ops *vlan_get_macsec_ops(const struct macsec_context *ctx)
+{
+	return vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops;
+}
+
+static int vlan_macsec_offload(int (* const func)(struct macsec_context *),
+			       struct macsec_context *ctx)
+{
+	if (unlikely(!func))
+		return 0;
+
+	return (*func)(ctx);
+}
+
+static int vlan_macsec_dev_open(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_dev_open, ctx);
+}
+
+static int vlan_macsec_dev_stop(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_dev_stop, ctx);
+}
+
+static int vlan_macsec_add_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_secy, ctx);
+}
+
+static int vlan_macsec_upd_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_secy, ctx);
+}
+
+static int vlan_macsec_del_secy(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_secy, ctx);
+}
+
+static int vlan_macsec_add_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_rxsc, ctx);
+}
+
+static int vlan_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_rxsc, ctx);
+}
+
+static int vlan_macsec_del_rxsc(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_rxsc, ctx);
+}
+
+static int vlan_macsec_add_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_rxsa, ctx);
+}
+
+static int vlan_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_rxsa, ctx);
+}
+
+static int vlan_macsec_del_rxsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_rxsa, ctx);
+}
+
+static int vlan_macsec_add_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_add_txsa, ctx);
+}
+
+static int vlan_macsec_upd_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_upd_txsa, ctx);
+}
+
+static int vlan_macsec_del_txsa(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_del_txsa, ctx);
+}
+
+static int vlan_macsec_get_dev_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_dev_stats, ctx);
+}
+
+static int vlan_macsec_get_tx_sc_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_tx_sc_stats, ctx);
+}
+
+static int vlan_macsec_get_tx_sa_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_tx_sa_stats, ctx);
+}
+
+static int vlan_macsec_get_rx_sc_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_rx_sc_stats, ctx);
+}
+
+static int vlan_macsec_get_rx_sa_stats(struct macsec_context *ctx)
+{
+	const struct macsec_ops *ops = vlan_get_macsec_ops(ctx);
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	return vlan_macsec_offload(ops->mdo_get_rx_sa_stats, ctx);
+}
+
+static const struct macsec_ops macsec_offload_ops = {
+	/* Device wide */
+	.mdo_dev_open = vlan_macsec_dev_open,
+	.mdo_dev_stop = vlan_macsec_dev_stop,
+	/* SecY */
+	.mdo_add_secy = vlan_macsec_add_secy,
+	.mdo_upd_secy = vlan_macsec_upd_secy,
+	.mdo_del_secy = vlan_macsec_del_secy,
+	/* Security channels */
+	.mdo_add_rxsc = vlan_macsec_add_rxsc,
+	.mdo_upd_rxsc = vlan_macsec_upd_rxsc,
+	.mdo_del_rxsc = vlan_macsec_del_rxsc,
+	/* Security associations */
+	.mdo_add_rxsa = vlan_macsec_add_rxsa,
+	.mdo_upd_rxsa = vlan_macsec_upd_rxsa,
+	.mdo_del_rxsa = vlan_macsec_del_rxsa,
+	.mdo_add_txsa = vlan_macsec_add_txsa,
+	.mdo_upd_txsa = vlan_macsec_upd_txsa,
+	.mdo_del_txsa = vlan_macsec_del_txsa,
+	/* Statistics */
+	.mdo_get_dev_stats = vlan_macsec_get_dev_stats,
+	.mdo_get_tx_sc_stats = vlan_macsec_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = vlan_macsec_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = vlan_macsec_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = vlan_macsec_get_rx_sa_stats,
+};
+
+#endif
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -869,6 +1108,9 @@ void vlan_setup(struct net_device *dev)
 	dev->priv_destructor	= vlan_dev_free;
 	dev->ethtool_ops	= &vlan_ethtool_ops;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	dev->macsec_ops		= &macsec_offload_ops;
+#endif
 	dev->min_mtu		= 0;
 	dev->max_mtu		= ETH_MAX_MTU;
 
-- 
2.21.3

