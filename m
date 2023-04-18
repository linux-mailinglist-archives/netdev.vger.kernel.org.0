Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705356E5C0D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDRIby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjDRIbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:31:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AFE7A87
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:31:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4l28wxMrPwCK4xvgdBH6qqHcy9TSmyUldBlzFHsh8MR8ium/6w085lSffSNDpaKRByrUDZGht6u+Wws2/U2s8qMAIab+kfSQlt083pd/qIt4R+EB7S145dtL4VGnjIeFQU1E0g6M6Aw1Erx3NOgY7YgJuXKuvvXxnIJOjdlexo5o+rjq74OFgjymr1bNdRJXpEhx32bJDN/VaE+wo+kJNwpsNA1JWKLv9CgrZgE5iiWBAzsOaYtqp9lgaeQZ01iOkvmwqVhg8wVN59IbzMQK9pdng4xWHVhzT7wkFNSGhYQgnYQRoYJY7qB6D3NDISBUJnzC4548CpJ1kTiwG9qXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=RvG2lW60aTPj4eNK+WAJd3GcrolDXEPVThOzbIr3bixzswac4FsV3utGGK2yHoK+RVSza1HhIT28Zij+/uapYmqDpo7UmRdlFZs93VUDTGZamZQqPmyM2LyjlH/KqAhDrrLKeFK71RVN9XY86YD58l4BDE/6Fn1c3BW0JS99vPnfFOtcrdXr2ox/UWNB2rVdmd56lFVJtDRq7WObIyb5giR+eR6LUIO/W8CvrMf7rROBu3vyfYByQ1ZoTyZCmnWWIzNV/yo8swPDAoQD3iaEGtv1oxTcWEqkAOYWC/RiTGjqVMTW4PXmF9FIxJ7CzgUf/Ce3KA93YKMOkOju9ezSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvhyYkuW8uOEfIuGQ+pph9oPmKdQS3QKUy0+aZmSHXM=;
 b=iDUYGCEdAq10Zv0FGj2YzGGKiJ1f+UgCXymdA9j2ayTkY7ebIoY+++ccEAqZ/2g3ZZ6i9uHI5R3uE1ViIvSlciJFHxV6Rp3UBqUZneGfTV5aUFfkdtQPVxVH+9TML3VZwbbURkqSKyhgjrQhOqp6KgIf8qsOSit/ExGv7GVk1mBvHU2RtiZDTgsKt1PF0NpJKYOMXLOJaCF5gG2MaaIXD0HrQLE98WxHdbKylqN9vO4bioore95gZ8RbuWLx3gL20ViMsYTHwamUUoF8hKjy2/0l65tnuHo6IiG6wQRvdtnIncFgjUAuPcpF7MBr5G7I/w1fsxHlnV6aJ+GsPiGD6g==
Received: from BN9PR03CA0292.namprd03.prod.outlook.com (2603:10b6:408:f5::27)
 by SJ1PR12MB6364.namprd12.prod.outlook.com (2603:10b6:a03:452::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 08:31:26 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::9) by BN9PR03CA0292.outlook.office365.com
 (2603:10b6:408:f5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 08:31:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 08:31:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Apr 2023
 01:31:11 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 18 Apr
 2023 01:31:11 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 18 Apr
 2023 01:31:08 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 1/5] vlan: Add MACsec offload operations for VLAN interface
Date:   Tue, 18 Apr 2023 11:30:58 +0300
Message-ID: <20230418083102.14326-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230418083102.14326-1-ehakim@nvidia.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|SJ1PR12MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ebb7682-b22a-4a54-93ef-08db3fe74c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfDV2/60KsWl5IEdbmw0vaw5VMNTAFPeuKH/T789SXRvpe+nbOSGdtrPlmEhyMBNV5pVxJvOteDAqxO3JjDJBbul8d13AaL3HkDfI6SvhKP2D57MDCWPh29bZuDu37jcQX//DDgzDT9dVKHIyLokYovHuP4eGRNYEUsWHzxV6WROdXgkPblUgiM7wGfKqlY+ZOiREuqHRfNUPvqibaQM6CN77yHEupJwnlZjzJTt/nR5UT2Kg0toX4eXDRzWuE15Own/h+44a88GR7X3u00I+EYlD83gRLH05rzH/WIl4u/CK4QLt3iVYuRnn6gA1QmG6CCyhTXRntFayEbUjeQgFp2J+UmhFtOY4OmTdhRXXDCGAswTRkukNK9TFtFfkuZSDqnVO1dbluOkZb1ZYioI+5IrY4Sc1CySs1TTZch2xhvoqHg9/M46yDJp+tDuH1dLiGQOODoyuMoQvUa17MA137XNSeVjNgxb3N4dictJZ1+HOtIVzQ0sA/NSz+cOAEolvRgg9z1Kg1cAp+jvXaP55Nh/hO+5cTnqXojOY3zcP6CtjIYGGARVp8Gw+C283EiF9NHHnAN9uRnQuGvdOJDoDfleZNBH2YjlRqQvxo+pKXTJQtIg3MmmgY4Y3ATZO64hBahUwiU/exLJfXBF+bVhmBdBoZ7nftuw87vwsWGtPkl9gw118kq+bKYQo0VXyrBoVSkK+wLy12o9c6FMu7WwV8V/0VcEF/x+l5FGI6QTNdej1uI7NFgUU/BF/eHJ8nKjeCjSnurF1H8VG35UAndH+w/MS42ioNmoFozIyzkEhkE=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(7696005)(40460700003)(2906002)(70586007)(4326008)(36756003)(70206006)(86362001)(8936002)(41300700001)(82310400005)(6666004)(478600001)(316002)(356005)(7636003)(8676002)(82740400003)(34020700004)(40480700001)(54906003)(110136005)(26005)(1076003)(336012)(426003)(36860700001)(2616005)(107886003)(47076005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 08:31:24.9863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ebb7682-b22a-4a54-93ef-08db3fe74c39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6364
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

