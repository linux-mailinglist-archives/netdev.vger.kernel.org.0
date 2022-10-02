Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DF75F228E
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 12:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJBKZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 06:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJBKY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 06:24:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A181AF0D
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 03:24:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mz+q4+PXBQ5wPEEXANt20Hl8DSA8XSfrzz5G3HvKmLpSH1yxUHTavPA51RppjfhKb9Wojzs7vTa5qyBW8aaUimU9NaZPhixI9eRbfMHmERkOOuvYkUp4AIAkGNFSKn+6sxbWJ2g95Zmw9oFx/kkwhmMlXYXu1R0AwI9eWKhALF4S9U2RlzojG4iohkgG9TzijIcVBRzWpFsUEHpr1NFiNZNzvTdtZ7pKyoC62SbXhgNc4m1j8XLtZzke/4h9twSMzx01I5k0IRkgewKssN6wra1zCeQiWWdIx8Qrkd7EnGZ1nB+TmPEy2wmRerKFht774t4tB/7P2p2P2NB25E1NAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+E48PMH0VOlTPzfJ0inDbNZyHLetCbC/YRvwbBonuA=;
 b=E9ZOf7UaGCNEQ1+Mkw2rX6njNcF/sNAk3CcdRJCrDMnNQsd0tiNy8H9XhEj3rCnkSg5lfcYZxGhuqrBG8x9R7pI4kXGoAdskh5bRFHxOzj5V95IjH13DTfDKdTW0RPjIWfu+nj6FeuyPC1q/WdxoDaA7zdYcG+Uz6aXZEcXkmaXn/zugGVRurCiVF6v5nDXSUzUrd2bmHwW3ftI2YHqV4R2+XuxD9jy/XXiHhQSYrkS8yHXQqfdx0SAU/fJ2ghv4aX8KDUSCjk5YH1eDTpJLOXcFHiEggLEZkBFaPYbx9ELtSyydIe2jy7gKod6x4hjkqFAMWgQxlfCNtCfDwd7eag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+E48PMH0VOlTPzfJ0inDbNZyHLetCbC/YRvwbBonuA=;
 b=jwMeoswkxT686BZUWwpmP56b1RDU6EktDAWK5OOI4r+NV3daTpq1S4WaPf9oxoOUtdMmsO308a0k2uXsl4+ol/rwZphkKbGoJRwoqD8ZbhvUv+9Rfpm6IdtKypCmNs/m+QvivqMNp6tmOVbKwXX+o8pdAjSH8xlJSzSJe1Gv1CDVMTT8sgBF8YB4K6Mr7C8/icuUECCLhWw1Bte/oG7frWpqNKdc0b/aXSj5q3x/KMb2IFgeq2Ul1Qb+LV3uYi1rAo8iNSJuEfK9wSS0LD4sbseZjhyAXXZnarGt1DaZkfkK3xv3MVDyF+NlbLD/1c+LfIKl1vCTdtkR5fcofV3r0A==
Received: from MW4PR03CA0234.namprd03.prod.outlook.com (2603:10b6:303:b9::29)
 by MW4PR12MB5627.namprd12.prod.outlook.com (2603:10b6:303:16a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sun, 2 Oct
 2022 10:24:53 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::67) by MW4PR03CA0234.outlook.office365.com
 (2603:10b6:303:b9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24 via Frontend
 Transport; Sun, 2 Oct 2022 10:24:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Sun, 2 Oct 2022 10:24:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 2 Oct 2022
 03:24:42 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 2 Oct 2022
 03:24:42 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 2 Oct 2022 03:24:39 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v3 1/2] net: Fix return value of qdisc ingress handling on success
Date:   Sun, 2 Oct 2022 13:24:31 +0300
Message-ID: <1664706272-10164-2-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
References: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|MW4PR12MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: 866bc78d-3298-4a82-41f7-08daa46058a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTKwRkXavM+LqNZbKcGIHf3Ff4ZPQWWZPJmptWL+hZMN77eAGMaGqe0DfXg6NqpRBu6t4vu6ZZMYsqiwxSrw/L9+x+1huGvEJ1zA7YzQXBA8i9M7KdqkNj8ErIKmWWUABW+SI9r4tCeJ1OtVIz4Po1McQ+kWwLdRMxsTh+0ilaNkSAE9v64apssRoeAy14WItqwKcJrtC5NLdUD/rLJexg4keEM0DRg+Cxj3rPoCtBzOwWayVuobY9kgk66T8fNFjEkkE52fe858RrtrCtW5b+wyOzxPPPXgPdZNW/oiPwwmhFBP7aZ09zs+GK3mt3ch7P0mv+4s+psmDfDCQuyEKMuo/DB/IFXOGjv3pniOzSAsUG3w1jhJZ9WbhfnDnk6WDWyxpLKenViCHV8KiDilQ6QJ5Ff0j98cWUgwiwXzDiQ/4kEF1mZnZnAttp0233DIuap4LCTjGmtGxr07HK+DhC9xVQ6WaJC9vRB43MGZSanV3YToo035A0/E+GTcYgB8qJzD/C6t1Dn0TCxKLChK6uWbBu7g0XeeJVvLVT74E9q5QIa7mPpmSldzUIy4ZF0xZK5ivq599VnYSmB8X5xhJXeS4jbaQSim/hQ2xvAhER2fi4CIQE7ztPgpj5Hz594PwDLYW4dMxWZlCyweQe65htwKE1Kss+pzqr4w55/pwA5AiQmbbSl4P4oUyFG9ZWmGkqqQl71dR1m9H/4hJ6W5wo1NyCzEzTZyWYRdgpGozN/bupghcHfh0Toz0Ld/7kZTKJxjQGzaKUA6rd8HfI7NJA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(426003)(336012)(2906002)(47076005)(40460700003)(86362001)(40480700001)(82310400005)(356005)(6666004)(8676002)(26005)(4326008)(41300700001)(7636003)(82740400003)(83380400001)(36860700001)(186003)(2616005)(8936002)(36756003)(70206006)(110136005)(54906003)(478600001)(6636002)(5660300002)(70586007)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 10:24:53.6087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 866bc78d-3298-4a82-41f7-08daa46058a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5627
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently qdisc ingress handling (sch_handle_ingress()) doesn't
set a return value and it is left to the old return value of
the caller (__netif_receive_skb_core()) which is RX drop, so if
the packet is consumed, caller will stop and return this value
as if the packet was dropped.

This causes a problem in the kernel tcp stack when having a
egress tc rule forwarding to a ingress tc rule.
The tcp stack sending packets on the device having the egress rule
will see the packets as not successfully transmitted (although they
actually were), will not advance it's internal state of sent data,
and packets returning on such tcp stream will be dropped by the tcp
stack with reason ack-of-unsent-data. See reproduction in [0] below.

Fix that by setting the return value to RX success if
the packet was handled successfully.

[0] Reproduction steps:
 $ ip link add veth1 type veth peer name peer1
 $ ip link add veth2 type veth peer name peer2
 $ ifconfig peer1 5.5.5.6/24 up
 $ ip netns add ns0
 $ ip link set dev peer2 netns ns0
 $ ip netns exec ns0 ifconfig peer2 5.5.5.5/24 up
 $ ifconfig veth2 0 up
 $ ifconfig veth1 0 up

 #ingress forwarding veth1 <-> veth2
 $ tc qdisc add dev veth2 ingress
 $ tc qdisc add dev veth1 ingress
 $ tc filter add dev veth2 ingress prio 1 proto all flower \
   action mirred egress redirect dev veth1
 $ tc filter add dev veth1 ingress prio 1 proto all flower \
   action mirred egress redirect dev veth2

 #steal packet from peer1 egress to veth2 ingress, bypassing the veth pipe
 $ tc qdisc add dev peer1 clsact
 $ tc filter add dev peer1 egress prio 20 proto ip flower \
   action mirred ingress redirect dev veth1

 #run iperf and see connection not running
 $ iperf3 -s&
 $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1

 #delete egress rule, and run again, now should work
 $ tc filter del dev peer1 egress
 $ ip netns exec ns0 iperf3 -c 5.5.5.6 -i 1

Fixes: f697c3e8b35c ("[NET]: Avoid unnecessary cloning for ingress filtering")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/core/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 56c8b0921c9f..2c14f48d2457 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5136,11 +5136,13 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+		*ret = NET_RX_DROP;
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
@@ -5153,8 +5155,10 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 			*another = true;
 			break;
 		}
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_CONSUMED:
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	default:
 		break;
-- 
2.30.1

