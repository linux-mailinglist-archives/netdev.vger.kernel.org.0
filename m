Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4545567431F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjASTvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjASTvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:51:47 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817469CB84;
        Thu, 19 Jan 2023 11:51:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfMxwZRLPuIAl77XnVjk3U4EfeL21a8VmW9cDtpTlVbNBjNGOjLd/gTP0kTWzq0hhFOy3uYF/TUQPs4B8haaldr/kO/R+HCXo3PukAEBFqo1YyksnZrnrRRM2XG84rfpInyHMCZ3wthG6ROp8pPSYv2rfEC0Tu+ba2rSkkF8XW2BsBJV/jYpO23hvyVFK1U6eF1k21r0vWmC6UJSoJ7C9BsEYkakYInpFV+qwMRaxvGtTu3PHxGZDhebMrV1yTh8NI9iRdZESDBB1/0GeQvz2LusLHcxfn9OpyPEUsw6bwU1QHheLL8oG7/qeQR5/eyxbhfGIlK1E4u2xOGDNhFzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ciq8UUN0gvkcFTVqiQIpLh1OYypUHTPyPDDSQWDbzzE=;
 b=eb1DNZX4nYAbw8jfD0NiaZUrHWa1EO79r5tht0ZYigVG5exWlM6qCDADoFJ4Rrn8I4LvFqiV/iYYoAWKSVM6KY1dwfuHihFq054mxiofhjLsHydUE9UdQOhxEoKwE0Cl7iBFLpvPJde6UPOia3s2Dei+URXLjX7qmtjWGOvBfR+fnDrM3Vo9WJhmAHiMwUn56PXDWbCKo63lNydpTlvBtK2D0PVfRLppIatAYwO7hC2Nn6GCq/5PsQpbvhLyVGTewMhv/68ZYPTxos9eJHjCJCQnwb+9+r7W0SvniqROiaXMCHSHKEIfFDmnpad2YJIS4GpbD6qkwwyAjN0v3HGEvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ciq8UUN0gvkcFTVqiQIpLh1OYypUHTPyPDDSQWDbzzE=;
 b=deSbhCf3qj0MOff7kRJa6JL0j0fBKK3m/2rgXsXrhaOkMTZ79zJaRHSV+mKeLcAbv7gIZiFwXjho6AhBSvXTtUOq2l/7jHi9e9ahZ+vLarnbXUnzcG/5oAM/hTZ6yzi1YtTrCRDd6i/p47FqB8lblesG497xWAA45ivQeeb96P13/GpsnE4U3OacU/jGlxFArt/gNREyRlIE2pQFZeSCvp5bwPiAqjC89i1CumNAJcoJ9BbcsWC3VSLkhqQZQni/LQmK+Y9FGUgozu1s5T6X+HEASL4nJNW8j6j2u2pMdA1rOTKpuM56/IWftGWrYkKuAJyAmqgnZBGG9E2AXqByQw==
Received: from BN9PR03CA0618.namprd03.prod.outlook.com (2603:10b6:408:106::23)
 by CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 19:51:44 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::15) by BN9PR03CA0618.outlook.office365.com
 (2603:10b6:408:106::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 19:51:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 19:51:44 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:31 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:30 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:27 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
Date:   Thu, 19 Jan 2023 20:50:59 +0100
Message-ID: <20230119195104.3371966-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: cb6a561c-6f07-477e-3948-08dafa5697bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0iF1ZtZJnNWgySCdBdVs5EYl7hnPJYa0OZ2UrtnMoifz1oO5hPH/wJVtGawlr++ko8W25gS9ZngEYbhD9+hMtJkfz3pzEvC2V5rj8dxnp1gtzu6TZrVbLpA/gefnpQSypT+WyckaCpBvXOhlv+bBGfxkGe1xgWpk5UuF1NiMBLFNn1EAs6AgKak1RUAW1eZEzflbyJZOWBHCe05bHGIixin9Hygo/PlyEpCdN8cfKl+Yh1LXoka5rRnOCZoe5V+tIHHpsgP+AbKKVqbUxW3S1YMowHGMViPXpzgthQ2mCAjCPWwQ1oJOikbI45Tl+MeYxwY/RQOW4NoQhUZhjYM4xepwd4MTDH7785+fIHmNvDryKx5Q2cvOhpjTOUQaUiXhIcVvHSsFoDEU6bX5xI6N6mVQKrdpUDwvMOSFzJcZMQatOW/MdcEgqP/FMrLGXGpV2rviZcMIkIG0vkYIvnu70dhIiG6in6PoKdxMLwzSsm7mt6pdyuGNcRFj4giTWHzaxvZWjMTAaqBYCzgPw/b6J9a/YaVDEoxxpXJsk63SSDo4I+Utv4dNqmSNeVgQGauKoOAv24PMTtD/XjCUoz9HYPjgsuOwo6u5r5X8Fdp9mYLK1qbHnlWSprEwTIdbGKryZg1U2AprAgQP3RJL34KF3jms48bSzJZNOzrVT+zn3fvHx+CK8j061Vxcu6C4YrlUs2cWmnwEuHHz/v9GnHEv4ysY/BWypzxbobsU+aR/qNY=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(107886003)(26005)(186003)(7696005)(40480700001)(36860700001)(6666004)(478600001)(316002)(110136005)(54906003)(336012)(426003)(70586007)(70206006)(8676002)(4326008)(47076005)(36756003)(41300700001)(2616005)(83380400001)(8936002)(1076003)(7416002)(2906002)(5660300002)(40460700003)(82740400003)(7636003)(356005)(82310400005)(86362001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:51:44.4207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6a561c-6f07-477e-3948-08dafa5697bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently flow_offload_fixup_ct() function assumes that only replied UDP
connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value. To
enable UDP NEW connection offload in following patches extract the actual
connections state from ct->status and set the timeout according to it.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/netfilter/nf_flow_table_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..04bd0ed4d2ae 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -193,8 +193,11 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
+		enum udp_conntrack state =
+			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
 
-		timeout = tn->timeouts[UDP_CT_REPLIED];
+		timeout = tn->timeouts[state];
 		timeout -= tn->offload_timeout;
 	} else {
 		return;
-- 
2.38.1

