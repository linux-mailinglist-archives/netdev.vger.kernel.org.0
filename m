Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B24F69A472
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjBQDkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjBQDke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:40:34 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174675A3BB;
        Thu, 16 Feb 2023 19:40:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNc70lBjObwrHClsugHqEXhkQ/1ojDy6HpgNc6y/eK21BAPB1R1OAq/dKORuF12nyCws3arUTtskKL6xbV5VipWJMsLSL20/nZzW+6yFyrxtV/xwwntBJGWexnLpMjzaoJFAuEQwJctWSokQfpRRybrmUOq3h9zWkmM9SxjXeC11Xt6aQSsdY3/EXt0kbA9OO71vuLlMcSECWfv90EInQvb5ZVLCZK7YKW7SllSwCzg0Ne7906CSSrMe5glhas5GLr1fzxG9bknW6pSPz6Ts9Ljmiaer9AmyZ+Otb90kr38KviANXJhk7I17OzngxpRtB9v71JLOJehnpSAkp7lacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNd/dIDKoKVCD3o5IohXcdjlWz7WYrM+V+H2uF4eJ0w=;
 b=ZbZs7sxZ/FJ617QaYuvUrkwr5QqdSG6zStH4vpDtoxokVsTp1o0AQoQFIxYW23OXpFucDqot1twXKHwfUwAZi4jIcICRysDcgu/QNLvFLI95WQf9/ITfxDoCPnUzYlxt9KgYuP9Dn9F7yFN8ZCOnjwbsDWE+mV9j1cmfcxHnHXJeInF/c1UCa0U0gH5XAc4F1gteVK19t4iqgWius4kZAR/PCz2hniAh1bTBvIsjUcX2mvd+eI6asJUXn8uhrkqNr/UVTi9yCr8XaDg7KnPoklD8DFyIUIhBkWx6Lz/h1aSFmcIHfix1JZvzUODbXe3xqc9V56j3TLaOQf4DgHd0bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNd/dIDKoKVCD3o5IohXcdjlWz7WYrM+V+H2uF4eJ0w=;
 b=F317JgZj0inefoIwcxDAKZMgDwkSZZxB10IwVshh5b6MJLV0I01yne9ZjAnDIeZqY1DJbsPxmIT062l3wzquyNs6sAd5PluYkrsqMPT51T/viqsAX8KKeMMI5V6+UYPfgGFiMZEsRO3x54t6vrVeo0RGfZ1AgFRosfp1rQ6VYdLmwnXRG1SfEYoz10+yyuUZicx5TTGpxPEOwk+q/gj/oTmsLgMZLsKI4j1UUB7eCRovAfkdnkFAF1KZQHNODiFmA41f6tRnoqPaFOVMiiWYF2FtF3U9GpDnGoQndmzJ2nI1xVVxdHgrdBPykR5Ke5kyABG4ztZnX8kULb5+PuNGiw==
Received: from BN9PR03CA0871.namprd03.prod.outlook.com (2603:10b6:408:13c::6)
 by SN7PR12MB7249.namprd12.prod.outlook.com (2603:10b6:806:2a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Fri, 17 Feb
 2023 03:40:13 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::4f) by BN9PR03CA0871.outlook.office365.com
 (2603:10b6:408:13c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Fri, 17 Feb 2023 03:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Fri, 17 Feb 2023 03:40:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:40:00 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:56 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v3 4/5] ip_tunnel: constify input argument of ip_tunnel_info_opts( )
Date:   Fri, 17 Feb 2023 05:39:24 +0200
Message-ID: <20230217033925.160195-5-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217033925.160195-1-gavinl@nvidia.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|SN7PR12MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: e0035b2a-c0a1-4dc7-f748-08db1098ad01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dGltD49d1u0u9joPJuK1GeKViHqC0caFuq7ThSfUgJWqSh3aFVGt0iiRht+fcGeUENlsn3+FHOPcGfxcYu3DuSzTmQSMwE8O+A95ul2jAeArqrma961Y22NYaB7b3cY5ZfXI1jDN6QGrdrQy6Y34h42cigmheCDD4bsf+T4bPxHz2AfVvyxWcUDHTHw8Vlb5e6StfOM7RXX31EfmMqqrZEtD2uIR89FxHHEkQCvQLBADq52+3XzzfvVjAywku072n8c8IDFsuocFbxU9Qdn4Y51Hv9Rn4Hw/F7HOyj5c5tLiyzpiE3p1pjPBJohaWbmS/aGOatG0HbECiMJpopbBy/auGg/b+vucg+8e7OyQq53N4snxufWVZ/6qKXZjERrr/Z+ISC/YmgJW/1iA0ntdNFsM+zX1SL0HusDFTZf5xc1/izn+lSXwLcFk6YuxGe+cmLq6jmHjS7bXZed2Wgeuzqdej+t6Ydh1y88luQl87TjOJWst1vMBHh8GIgDnpuN8sP5ZSks9UhE2F9DKjCRk3Ip1D/kmOj/g9pR20JC85zDoVDCX4PivmOZ9HdyTasqtQ1h928TKn/JPZ6xm7gozdLF5mokc9HwfsftmCGVv4dag9BL56q7hKzDLZ9Vs08Sza2rpAuMgLYTx3e32Ia9lLbdWiemiQYtaKwGIylCglPqmnRUnR/j83/6zsQuuLTy4tuQ9fbe2cOKuQerf5GYQQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(86362001)(36860700001)(356005)(82740400003)(7636003)(82310400005)(55016003)(40480700001)(36756003)(316002)(70586007)(4326008)(40460700003)(41300700001)(70206006)(8676002)(54906003)(110136005)(7696005)(8936002)(5660300002)(4744005)(336012)(83380400001)(2616005)(478600001)(426003)(47076005)(16526019)(6666004)(186003)(26005)(107886003)(1076003)(2906002)(6286002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 03:40:12.4686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0035b2a-c0a1-4dc7-f748-08db1098ad01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7249
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify input argument(i.e. struct ip_tunnel_info *info) of
ip_tunnel_info_opts( ) so that it wouldn't be needed to W/A it each time
in each driver.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
---
 include/net/ip_tunnels.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index fca357679816..32c77f149c6e 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -485,9 +485,9 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 	}
 }
 
-static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
+static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
 {
-	return info + 1;
+	return (void *)(info + 1);
 }
 
 static inline void ip_tunnel_info_opts_get(void *to,
-- 
2.31.1

