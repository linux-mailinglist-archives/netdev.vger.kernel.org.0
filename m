Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28EA6BC689
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCPHJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjCPHJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:09:20 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061.outbound.protection.outlook.com [40.107.96.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A52DABB2D;
        Thu, 16 Mar 2023 00:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SolOXgWPRALwm2kocqX3BigZZG2xTTcku/ik0AppaWta+uXgpogJOC97sCYX28a4zkyxQudLVKT/ddz2u6IYJHkrlWuuZ5TFzd5P7UaZ6UInCLTeSipxgNJB4nnjsZ/FCaWdcue/VLAn51QLmt0Rh+GNsmALLi5n8ofw0sGlfA4iOgtghSR8EtP4HScYOmseHpAbkBl++5eGqxweO9H2INP1qxqYN8DDgForE0wb1ZnV4HGoyHHisHHMtncnCMBAbctcOCUSQ+uGB3g1PJEO0BdVUZRw9MYTW0QLciUKlnHg3Rg3oV97ZsyvspC79EXmS5jMzkPVsrKRQTfcaWyrIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wh1kRVQBO7vonDW6jZkmra8sdH89oNTkM3pbMxGnO7E=;
 b=jbNsYwmqyKnu7BqosGQt9WsTM9te1JWb0VHXnImMw+unSPn9lgdr7wi5Bm9qkG7ZQbm6eYygdCEVT9+G3GpXxSk/Lf1WypukPgDyh7KQnCDa9hghX2lR07bIWfe5bChSCsGMEvKgmFMWN6gverVPlGZNCTaupmvxUULzIP5q3BT/NJfs3DcpFJWHp+wFIW8zXYwQFa6xQ0ziAswGD4e8KxOkceO67vxfuLubKhYd09+S/0QaVEttyXTU5HYWR/mO4yt08SOF6Vsp2ncCb6VVMpLgFIcLnQtdupx7P4Mt5j16zNyTBMiikatrpxTofr0ezVgfGKJ7H+HE0cwiM5rZpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh1kRVQBO7vonDW6jZkmra8sdH89oNTkM3pbMxGnO7E=;
 b=LwFWHZYpfHtU0dgoY+hyCpCyY4ytG6WjwdyBO3QADXr0e9+3NZ2ZhSUQRRROj5vE2Ov/7a+Xe7CbwGUZdlT3JVnoGkAn4rcvkThJaCgB3JrhsbH2ukV4T7pdFn4GPJRAvdEg5X6Kjo0Yecw6Z/Uvwl2til9z2BfF5c+gqvtt0iVlHb1/rdOJ2GLaJe4VFlFbYmcZP42glJ3XuX8IJ65HMHPN65q0SdzmmWAY8xI32bKBkK6EilxD3jNg+09mm/l0x5ZdS7m/bRIKJ6wund7eAyTS6RE4EXlI2G4Jl+QMVOI8zERjOhAIeAGWUNcmWf8RtfjWIjIv6iISDK+s6+HBHQ==
Received: from CY5PR15CA0192.namprd15.prod.outlook.com (2603:10b6:930:82::18)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 07:08:54 +0000
Received: from CY4PEPF0000C971.namprd02.prod.outlook.com
 (2603:10b6:930:82:cafe::54) by CY5PR15CA0192.outlook.office365.com
 (2603:10b6:930:82::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31 via Frontend
 Transport; Thu, 16 Mar 2023 07:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C971.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 16 Mar 2023 07:08:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 00:08:34 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 00:08:30 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v8 4/5] ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
Date:   Thu, 16 Mar 2023 09:07:57 +0200
Message-ID: <20230316070758.83512-5-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316070758.83512-1-gavinl@nvidia.com>
References: <20230316070758.83512-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C971:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae7f65d-9a5b-44cb-cfba-08db25ed4d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcOr8psfjy5ZAEcpBLkiprHNHUumzYAgDGtOLAmT1aKYX6tlPxelZOsZIVEFr6wwG7MDkYbwyJFQ9fptUuMeKqwC06mjugKYYuirVXELE90EahjCgBTi7Ly3DaFoyyltCIMbjR8e2LEy9vopWt0kSN0/dT6Muod5A8V3v5P/Tn2CcjaIPHqD1gMoVqICkNYjvPL+ooLu88Ei+LqIMAAFHsPJf90mRUk5jnMq6qUKmdKO90NaCWhx6YZQBVQzC8xls1NQSSOGgO2e2POxObNDDkKxPO2gzmFTP6vbfwTjDQnabOimj58yEoVd9NOyqSMyjwbx2MXCsxhoINh8U2C4C19/wMntbjIh6qshOP/uD3BGao0xX8iGNwBmpgOyrrA6iEpYz+YgwvGGy8ptVBnXgbxwf6drPePfHAL/7mBV1/l77Pz5yVZreVVH5aPZAXTQ9rVY2dP9Kb28x/k8vpwc0t/MCDKrVP51klwS1wj/PF42+cNq/jZ8SO8NLuqYBgrv1y1N7tt2KxDwVJRf7+NM5Zm0RRvudxpERr2Gbq0/Ulu+bEz36210BWDOG8s1bYeKVq0e9rtFtZmwf55j959aapyYS9XD+WhvQSaO4lDVCybz5K52qNN6C229r3F6TNeR3sf3Y3ZCGpDeWCpdaEMj9K1+/86iR9J0N0OdpLcik5lDnZCw2LsyKItRFLHBT+HP0dMXkvDU6YQ8wM+KoCc5xxaFtjoot/8jnaLx2a1PIiCJhwB5MYOmXjJ3qu0eFunp
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(426003)(47076005)(336012)(316002)(54906003)(36756003)(40460700003)(110136005)(55016003)(1076003)(86362001)(7636003)(2616005)(82740400003)(36860700001)(6286002)(16526019)(82310400005)(6666004)(356005)(186003)(26005)(5660300002)(8676002)(40480700001)(83380400001)(7696005)(478600001)(8936002)(4326008)(70586007)(41300700001)(70206006)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 07:08:53.6163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae7f65d-9a5b-44cb-cfba-08db25ed4d4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C971.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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

