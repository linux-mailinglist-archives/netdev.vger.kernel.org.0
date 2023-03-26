Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0426C92F8
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCZH1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCZH1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:27:40 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907D265A7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 00:27:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANsQwb4f7hQwNSXS0UKG/oVPO844OKmymKC1/wFKyIIGcOvn/4JhPTsiAZ1rZkkz0psyP14QJiBLYqVA2B1J+1FrEwq2aumls4vmieiUdb1MivcbIj9wFyAVjkXhYIQGEfjg+JTZJU1eC0T0YSTO+KINxtgtBPnO9sKQj0Ty0O35BcVntUkTfBQ/Lh3TecemdEf95YjeA9eaR9GA0RolTvUfSJW14Gfpl4X7YtOt9nfm57K0ALUX10c0YZltqSmo4zz/GtOkyMXGCfKGhTtpCBTLXCM9HC9edLdbNDhO4f4TTTPwrtwBM2LHbAz31bnzDiyt7P2jr89AphZ4DYDdFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0CmVxXH7I8pcoFFiJ18JlsqvIDmqQG0oWt1gsOZb18=;
 b=NeCobc2E2B8FcaKjRzM9DTWnIaG+dF+dqOE4ecYEr/0uSgLF/II0MamjnrmfG2pGo7c/SKY4eDFA4Tr7+BwJ8q4ogVuy+dvQ5oEgVKweSQXWfa5UA5aBGJQY3mB7DDTBiotgMmDG4QShOo0WYklpSWGxcxKTWUsge/nEXu9f+/7FigbT5foaYWbS5eqjn75F8vTFhoaq99JuQr0DcHPq/hbEafL0gBJMagYJDjJYMxofgKSwMVm7GMGG0q2xY29P2EkvPlXcSuWfzbjqiCmb97d1pNWg9Zuv5mcHUoJ4lk7nNO/k33nGKnke7YPN2f40wU7Ii96PoCOZMsQVLiSimA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0CmVxXH7I8pcoFFiJ18JlsqvIDmqQG0oWt1gsOZb18=;
 b=g8fP6Mw4/jl5ilSqkOmJeJbpyrQ7q9onrPOFTk/foor4Su4ERIYgEdOyj2FP4ztwjjPG/h0jhnl6C+2Z+E55lhwRSzPmvOPEC9dBR46bpO4ugHkHVyqmhht2WjG1aVlsjsfnJ+G2FexmMFJxnvhjAkWK6fCqrVK8ef4BsxpgkSkbV4MWnD7mLqO0+GRGXZUsGu2lKAjHOAUaoY0fRBp2NErg2akGgMeCtEQ0s22UnFfcWTMzm1Wfw+wrDFbAUDq9v+rsd8et3HywTlMCW+jVaiD5E3+fwoJr2xSS59d9Mg7XZZY6CknKsLvkcOYt/QX2aWVtVtf36RBBRHdw+AvpaA==
Received: from MW4PR03CA0181.namprd03.prod.outlook.com (2603:10b6:303:b8::6)
 by MN2PR12MB4551.namprd12.prod.outlook.com (2603:10b6:208:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 07:27:37 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::76) by MW4PR03CA0181.outlook.office365.com
 (2603:10b6:303:b8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Sun, 26 Mar 2023 07:27:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Sun, 26 Mar 2023 07:27:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 26 Mar 2023
 00:27:29 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 26 Mar 2023 00:27:29 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Sun, 26 Mar
 2023 00:27:27 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 1/4] vlan: Add MACsec offload operations for VLAN interface
Date:   Sun, 26 Mar 2023 10:26:33 +0300
Message-ID: <20230326072636.3507-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230326072636.3507-1-ehakim@nvidia.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|MN2PR12MB4551:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b019158-6ed1-4e5b-5f89-08db2dcb92e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64HYdPi+sAxM58dKyPuIOiPMmdumx7fgcoZOO8yr5WOai67jebR0hkhDyokj/8KPBhFAlfNx5tyFQ5ba8NeglRrMxmPNPQvWnWtrZRy3k015Jhfdnh+eZZcS4QH7N+pbVQf9pYGH79tqinobd5Li8dGiXwd0teOTowibiDD9P/WIrfPSdXuKfhmU+nbOJtDHL4apNkOW/lbJUVKvEFmS5jlM0SHhJv/Qpzua25WkF08nbFfAg2gm414/ofvnC7f5bwg/Tw+MS29wrN4Patlbqn1qEL3HSlUDBcvXRno6iDve1KKxgcdOjD5hbhbZIzrS40YYhBdA8VFC6ZDLzj1B1xtXxEzbHJ64V8whwrIVnGYJHJdy48+8MMJrA3tOqYhy0TrgwW01IiF1IODdYQ88C7PzmOMiCwrwXOskEm14ahWqApIrCWnVMt2vZJjJ9AbkHS6KB+2O6r/k23VqEGjXMJLdxdZr/HLaJAf3oS8Ij5HOpLgyUj7wju5c2gSS7vss6QDIWzJR5YVLl+IySlmp63N70HOLoBoYyYfk4klMf2rJdANeUBldKurkMXX9wXAMVbpIFIfFHsyA8ItEsX9SbrInOR0STEjW2OtDfxh6jNr+7mLacnoLEUt0i/zBl25Iwy6dV7J6tirkGhCgN9fwpyiQ1rPGjH5DP6ORjNfgZDgORCG0SXP8tB9Ypy6fuxk0SsXaOoLp+NpltkKWPlKS84rCetQruZKSqAfZEDQzAum+/VkejAisa6zUZsxjoEFGRQlw4noGSZ6mm0CIGaTbdLOeUoAwntHqg2J3cJUgCWY=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(426003)(47076005)(83380400001)(86362001)(82310400005)(2906002)(26005)(1076003)(316002)(110136005)(107886003)(6666004)(7696005)(478600001)(54906003)(70586007)(36860700001)(40480700001)(356005)(186003)(40460700003)(2616005)(336012)(4326008)(8676002)(34020700004)(5660300002)(70206006)(36756003)(41300700001)(8936002)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 07:27:36.8589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b019158-6ed1-4e5b-5f89-08db2dcb92e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4551
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
 net/8021q/vlan_dev.c | 54 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..7cf1f15340d7 100644
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
@@ -660,6 +664,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
 	features |= NETIF_F_LLTX;
 
+	if (real_dev->features & NETIF_F_HW_MACSEC)
+		features |= NETIF_F_HW_MACSEC;
+
 	return features;
 }
 
@@ -803,6 +810,49 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MACSEC)
+#define VLAN_MACSEC_MDO(mdo) \
+static int vlan_macsec_ ## mdo(struct macsec_context *ctx) \
+{ \
+	const struct macsec_ops *ops; \
+	ops =  vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops; \
+	return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP; \
+}
+
+#define VLAN_MACSEC_DECLARE_MDO(mdo) vlan_macsec_ ## mdo
+
+VLAN_MACSEC_MDO(add_txsa);
+VLAN_MACSEC_MDO(upd_txsa);
+VLAN_MACSEC_MDO(del_txsa);
+
+VLAN_MACSEC_MDO(add_rxsa);
+VLAN_MACSEC_MDO(upd_rxsa);
+VLAN_MACSEC_MDO(del_rxsa);
+
+VLAN_MACSEC_MDO(add_rxsc);
+VLAN_MACSEC_MDO(upd_rxsc);
+VLAN_MACSEC_MDO(del_rxsc);
+
+VLAN_MACSEC_MDO(add_secy);
+VLAN_MACSEC_MDO(upd_secy);
+VLAN_MACSEC_MDO(del_secy);
+
+static const struct macsec_ops macsec_offload_ops = {
+	.mdo_add_txsa = VLAN_MACSEC_DECLARE_MDO(add_txsa),
+	.mdo_upd_txsa = VLAN_MACSEC_DECLARE_MDO(upd_txsa),
+	.mdo_del_txsa = VLAN_MACSEC_DECLARE_MDO(del_txsa),
+	.mdo_add_rxsc = VLAN_MACSEC_DECLARE_MDO(add_rxsc),
+	.mdo_upd_rxsc = VLAN_MACSEC_DECLARE_MDO(upd_rxsc),
+	.mdo_del_rxsc = VLAN_MACSEC_DECLARE_MDO(del_rxsc),
+	.mdo_add_rxsa = VLAN_MACSEC_DECLARE_MDO(add_rxsa),
+	.mdo_upd_rxsa = VLAN_MACSEC_DECLARE_MDO(upd_rxsa),
+	.mdo_del_rxsa = VLAN_MACSEC_DECLARE_MDO(del_rxsa),
+	.mdo_add_secy = VLAN_MACSEC_DECLARE_MDO(add_secy),
+	.mdo_upd_secy = VLAN_MACSEC_DECLARE_MDO(upd_secy),
+	.mdo_del_secy = VLAN_MACSEC_DECLARE_MDO(del_secy),
+};
+#endif
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -868,7 +918,9 @@ void vlan_setup(struct net_device *dev)
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= vlan_dev_free;
 	dev->ethtool_ops	= &vlan_ethtool_ops;
-
+#if IS_ENABLED(CONFIG_MACSEC)
+	dev->macsec_ops		= &macsec_offload_ops;
+#endif
 	dev->min_mtu		= 0;
 	dev->max_mtu		= ETH_MAX_MTU;
 
-- 
2.21.3

