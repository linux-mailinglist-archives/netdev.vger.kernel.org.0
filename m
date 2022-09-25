Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84355E919D
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIYIOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 04:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIYIOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 04:14:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54571DF14
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 01:14:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjQKRFnrV5DJZ7ajvahCYJxNz6IC7a2GDCiisxY+zn6mx3yXCkpeUmZcMiJsVhNuQ9PbdEKKEPazE7IVscs86He6pOJfbqfYDoRWN0F0TbaaFmr1bUnsDF1MZCI+MFNXCjmYVdkdElO76n4nJTbAaUJFZ7XOowX5VqPM7R1tT6foA2AV5fvS/IEsPx2kyAka2twQ8l3iVyKjYZMkheHD5+vfy/4rL7VAJ13WeOHxwNZ0v6C20LM4fNVDx+Q+3Jy1QKon04ttom/8PIbgbSquKZXsra7d7mkrKoKtCMVhYZEV5Woml/aJoZE/jDxiQkHuNfb7I7cQoUDn6H4ZxoX2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssugjoLig5Gu/YK/UvNnKGJoC0A1ZbXTlBoVzX2ubfI=;
 b=moEKcYXTnLk/lodcIdGdXZJMzssIik/e60V3wEhmB/q05Im/tTVbyA815Qm7+mmdAdv160jUQTo0AY8SxolGl2nr4nJEbeHzWHFIJuIIFphkFeBfzPCIfopISnkA6LoL9XA2fDMX22eZ2TJPVQICOCLqa3BNNdKuHa78UCVAHHwhxVQRENmYmPprVD0sLZixOE3X00Ma89ixNbS6nF7hFXu+ymO4rz6SeXpqjF/67eoDrrOivXoI4iJvJP9EcKAkCHm+BtyhDIRf9csYH5LxWPtfu0tNucG7WU4GQ7/Kqwuh04an/MkmcDdfBhqPPb0UVkgigF60cWqjIDm6GFH9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssugjoLig5Gu/YK/UvNnKGJoC0A1ZbXTlBoVzX2ubfI=;
 b=QML6/WPAs8OEcTlrEthnZjrpbc+mAytePG8B2nhw2F5B2S5nxPUcRuWyNkluJ/rWAdLPE+wLygwkedreF7Eb1mkIbn1gA6tCKWOYP9X5OL/NtXR8Q/tL+eo8gWL2FGw7i2bVmK5o9jSVWxoFGDUTt0lONrIY4gyPuw+ELLwgjXDp46H5es29MSMWoN+M220jrO7yVHZPTYfDHLv7HtqfMVWRBfwbpv/ZNYEg4jxv8kNryaK5vHAGU/Gc2OaH5fHuX1KhJ7Qr0c489Kj5FyiEWvZZfLARtJ9ASrmGzk/o1EdgBhYvUtG+Cr0Xyw1HhaEbBAjQFYZ52rGDPpj49cZkbg==
Received: from BN9PR03CA0137.namprd03.prod.outlook.com (2603:10b6:408:fe::22)
 by DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sun, 25 Sep
 2022 08:14:39 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::c) by BN9PR03CA0137.outlook.office365.com
 (2603:10b6:408:fe::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24 via Frontend
 Transport; Sun, 25 Sep 2022 08:14:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Sun, 25 Sep 2022 08:14:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 25 Sep
 2022 01:14:30 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 25 Sep
 2022 01:14:30 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 25 Sep 2022 01:14:27 -0700
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
Subject: [PATCH net v2 1/2] net: Fix return value of qdisc ingress handling on success
Date:   Sun, 25 Sep 2022 11:14:21 +0300
Message-ID: <1664093662-32069-2-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT017:EE_|DM6PR12MB4403:EE_
X-MS-Office365-Filtering-Correlation-Id: b15edac2-1839-4d4a-efd4-08da9ecdfe15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUhTfSBCes3bkhzSqj6NbeAfj9M1kgjKwRyWV860ILMefhuONV+OAxCFhPqX3b3/P0fwmbru6qLOx4l5PnHNF4KKux+nUalE3pPJSzKxsSgh+aCILj+eUe0043w3LYTxJxHMMjePjLL+vwMGQZuJMCC0QdqREqeAwCh+UtpP6HkBXFk2Iaf75Kl7n//Sg/celf49gjMaq4A4/Fs5lbLgTRMWIugzX3g9E6C7kCkfLJxLTM3lEv6GDHYFIRV7kvApzE6j8m9olyLlHAgzkeHJZydjACggToSLajJmuRTwUoYdE0zh8HedlPnAryvAgPz21y4dTY6m5uF0tG0N93zTwLOMwwiK59yjtzmZs2PUxAqbz/FPtx7lhfBu2mkcFZIUd6IegfmZf5mximY/CnMUVQmveNi+N17CV9rrclGiB8juzJB1G+SVeEfrAuO0NpKsf0qK8TLLC9tHHnJfxk9qFS6KTxjcY+dWRknQsTGyTZAJmp16gqyQxs4tpTZUJ5onMZOwQPPcQ1chS27nEoU8HPcJxGpOnyFwl9eDhWEjmDWInCn3etyQU2QyfqBNaVuBPUgcqTi+sY2ln8RiSv67Hx5yClll7P4k2MS+GB/mSDj61FLUJKtPLXjTRvFkMtJNWfT8e1rW7KQzCHYdKYAOOBgOpmn3vSvXVAmQfqzO6nT34o6g0uJRxJanjuDVc+ykewSmfkrceRSn9bzAyIJKJUTGIDAnUzT7bV9PEYL9Ad+KGu3aaEmSC8AbRod/ci3SngagEv8SNqQ0eJW2Z3KN3w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(356005)(7636003)(6666004)(36860700001)(41300700001)(26005)(47076005)(82740400003)(186003)(2616005)(83380400001)(336012)(426003)(4326008)(8676002)(54906003)(110136005)(478600001)(6636002)(316002)(70586007)(70206006)(8936002)(5660300002)(86362001)(40460700003)(82310400005)(36756003)(2906002)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 08:14:39.2493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b15edac2-1839-4d4a-efd4-08da9ecdfe15
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4403
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 56c8b0921c9f..c58ab657b164 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5141,6 +5141,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		consume_skb(skb);
+		*ret = NET_RX_SUCCESS;
 		return NULL;
 	case TC_ACT_REDIRECT:
 		/* skb_mac_header check was done by cls/act_bpf, so
@@ -5153,8 +5154,10 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
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

