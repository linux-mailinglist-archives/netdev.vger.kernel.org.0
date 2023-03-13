Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487426B7074
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjCMHyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCMHxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:53:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F62D55044;
        Mon, 13 Mar 2023 00:52:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6e/YXBg0Z/fY1sm2M8XFk8BJzphxvjB8nPt8Qn3fLAU8EI7prhh9FJo3Zm8SLbbw0XEBb3CDQKXFcUBRuQ4rMUjUvkOBbxpwsZHwVD374tflzWUnV+9YDpmkEXzbJofEnc+Bn3mY8nTfTUOK6/rsnz+D6fz7ZcGoAgSCM2bTB/6xIU+FM95OsNpmN+DWZ57lbKMlMpJ/gtEehdaFUUwfmfBrG3awtGoSflmT5hxwiGU4ACjIzJPlTJGqQBtfK9ED9k5lacPrF1woWtwb2i9SdAA2rtCojDheCBx7AgBx4ys09ZYEpWo7Xo+ZHD0SU0JnrDhiMEQXPKvr0919THyHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LiRfAa2itCYIWXFmGqtdDa59C96LZtJJ1JYHLmSVfM=;
 b=hNUTC0/CipNcG63cmEj16/Sra1Dd8NiqddjnPrrZSHXTCnlYGgMczV26P575TvvPTHEtK3KA038luPXcXaJFVkvWt7LG1cOaiRsganHSUSaeX4l8ptUSVTzSRSD9yIE1byRwPCMU9mTw1qONgAEx19LWgVcB/e9vxmk/ZFX4JLLAgVAR+FjJ0vQAa1JIMqT2uTfbMDnFNKDFDcnRG9smXzkMST6ak4p4m1dPB2c4PJc+3uu4isqbJZP9u7rTI3Nh2ZShFFyFlT5H0qrv02MtmsLpYAKwj1z1vRL4CISR0gSHTmNXzCQiHHFNSbdXXSYuvxh/glrGL7Kj3UAoQ/vSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LiRfAa2itCYIWXFmGqtdDa59C96LZtJJ1JYHLmSVfM=;
 b=iV6+HYTYJkpiXazyHKCGswldYl0/rfiFwbu7cnIqGqLr2EyVNi0/uIcbdv5Xe/dIoDbzOHsSj4zfl96WECrZtsGnSmSKxv9R9GGqr94QRF5sIs0Zr5I2E3y0kuWAhgKPdeISpT6M9Nf96Y9Orlg0MVntfCI65UHmIT5bcn1KaQ9dFp+B/qmLmlgKmpiG5fEH1wjuC+mi7aE3IMWiIY3ZMPvE5Xpq5+cbrqODcKlq5OEmRBLqbeZZGqKm1YPlO0LXLvfOuWtDPiAEWii9enfbzQXPCGrPvZYGXatBr0h19H2yN/W6+mpOIWpibuJwS2cRi3NCmH9RktjSfwSLttcLFg==
Received: from CY5PR19CA0105.namprd19.prod.outlook.com (2603:10b6:930:83::18)
 by IA0PR12MB8352.namprd12.prod.outlook.com (2603:10b6:208:3dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:51:56 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:83:cafe::65) by CY5PR19CA0105.outlook.office365.com
 (2603:10b6:930:83::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 07:51:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Mon, 13 Mar 2023 07:51:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 00:51:46 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 13 Mar
 2023 00:51:43 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v7 4/5] ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
Date:   Mon, 13 Mar 2023 09:51:06 +0200
Message-ID: <20230313075107.376898-5-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313075107.376898-1-gavinl@nvidia.com>
References: <20230313075107.376898-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|IA0PR12MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db7aa20-d4fe-4282-9b77-08db2397d129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ppH5rWpsuloN/GKY2jTQ2lKxY/qAXtnPIgDvEM4ReI0ipRqEoLkYVjK5uPG858AkK3i0rGDBiS7ArNpQpuqXlpSWiXde1spwD+YEARcDh3f62SPQD8Sq3knX7JusAD+Vw1Gpoq/ZHbILXZgD4U0GJe61tGrbDtA31tluoMq/+qUWF6GJ7xoEMOy7bSsgwDjqkl2aGckLlxgvxtnCbtKtXSEhOD/dZC/dsovQA/MLZT7X4nh1BWRnVRIHvhmwmUfdaHSsPaJ8uLtxnyIrblvDIyzIh+nD2pm8mbT+hcx2nDCY1BX9oZeG5xyEGk9vjYRojh8ppe8MJG/qts0OAt++h2KzcqhAN63x4IMkS37r9l1qOvdXv8eqEm8RvQmrXalej0Tkw2xbJcfJjQoruGJYFUvdD6CAzuvEuKM/uAdS+ayrqSj6KCzaGVZAW1Upze0cjffaG1XeRSGgjczhcyrjDLNYvLXbx5dwBiWbAGnIlYWThLQDtRrNQcLIj2p+6NxSOst0Mk7qAjS3p8ennHPiQp0ThIC8aKoyVnaxfxYIqC+gK1uH/tQFAm+H1fwGvetDyfAAWIqRswmOMItF+zBWdqLMNaA76XFrCXOrGC8uZ3i0ehuBYVDOVzRMV2RRbcrhQrzf6dt8cj6fDHr2Qp7B9WvpWLK407G08c9je5GXvewzut8olc+EyNIFMXPT5Ol3q+IGoVntE+6PsJPGdhnedXlM1QXVXGJDHMYV/vHkEV0idBpKCOsvmBl+KibS5XS
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(82740400003)(36860700001)(82310400005)(356005)(7696005)(2906002)(70586007)(41300700001)(70206006)(55016003)(40480700001)(8676002)(4326008)(40460700003)(478600001)(316002)(36756003)(54906003)(86362001)(110136005)(7636003)(426003)(47076005)(5660300002)(1076003)(26005)(2616005)(336012)(6286002)(186003)(16526019)(107886003)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:51:55.8006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db7aa20-d4fe-4282-9b77-08db2397d129
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8352
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ip_tunnel_info_opts( ) from static function to macro to cast return
value and preserve the const-ness of the pointer.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
---
 include/net/ip_tunnels.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index fca357679816..255b32a90850 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -67,6 +67,12 @@ struct ip_tunnel_key {
 	GENMASK((sizeof_field(struct ip_tunnel_info,		\
 			      options_len) * BITS_PER_BYTE) - 1, 0)
 
+#define ip_tunnel_info_opts(info)				\
+	_Generic(info,						\
+		 const struct ip_tunnel_info * : ((const void *)((info) + 1)),\
+		 struct ip_tunnel_info * : ((void *)((info) + 1))\
+	)
+
 struct ip_tunnel_info {
 	struct ip_tunnel_key	key;
 #ifdef CONFIG_DST_CACHE
@@ -485,11 +491,6 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 	}
 }
 
-static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
-{
-	return info + 1;
-}
-
 static inline void ip_tunnel_info_opts_get(void *to,
 					   const struct ip_tunnel_info *info)
 {
-- 
2.31.1

