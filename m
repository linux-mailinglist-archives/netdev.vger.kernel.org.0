Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82420669ED1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjAMQ4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjAMQ4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:56:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FAA10EA;
        Fri, 13 Jan 2023 08:56:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIAlB4vSjC1uaJ839PbjVZPNhcnpU1FL6U49R6ii82JK5enyrFoV047p88+hAYjJ+OA8kGMA08SwTOTG5R8tWl3cHPV73FgKSKEkoRvAf1k/JvUZFdd8SzvdlJOoMIKGCKXgrCR7ieCXh5jePGHXwCi7HFAFHUOt3Q6+88ddx1XN+vcmAmJQfSofZ39WshhxJ+Yk61RWcL+okJGYnAza+nLu85IAZ8Y/SjSlLHU6QK/KhHBNaeFUPfqsiyVWn3j2WAJmLUfHknnh9mBBiTzubnNlxa4EBkfPyuQLJ7PfXFImoQiJo5HjOpxOxre3OL+Xhaxrb63N4L9zTAPEJzkcUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ciq8UUN0gvkcFTVqiQIpLh1OYypUHTPyPDDSQWDbzzE=;
 b=L3lzRQZ2qBc2y/P8BdE1vXn6bWmkuJP4j3xCWz8njFZ4G/JL2RP4WDXFZHqmdx8iWsHLkvbjGPqo+/97he2+aK0dE/8ganc9xEnx1E35S29unLwYMDlmRFnlMfkFR6yiaUrPjPRT4Sl+M4/+zy91QJY2PC1D59t1CYSYL1whJ/VPkBN4qUmZTI1mCBuGefrrmV3ralc3O8Om/AbBZ8yVkH4ftgPVkLdflNVEi+cyhSXu5+zGlwF9EQXfSxvaYgIZdvsgZvGb6LTHj9nFjqh9UcazmBPCtAwfMAKpO4pMm1BWJWPXmXD5GIEeWZKGN5wod3M49PCN6fooBlpuSCYHMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ciq8UUN0gvkcFTVqiQIpLh1OYypUHTPyPDDSQWDbzzE=;
 b=Xi3KTNQVldT3qRVtRDbrUXSiONxs44CDwqfYDiEMUU39taoZrHcpp3G4AmpZmyiMIiKVSUke3w5EjBDcq9d0wBByBMx7iaAwRk1+8dsn34L1P3h3BEiw3n4OCcbiZnVuo6ZC+d/Bcl9JzjzLpmC2sxTaf3/f4FTE9+tvlMduEN3siQkU7jjLOFTaPSTanSPiDeU5VgescDOMuDX/gki8TvPCk4U7961DXGr/2BwnD7JEyNFqv7kiGN6Bs0npDCLSfi3NHl3hlbzJziw1IQlcfGCVoIaSv15+Q4Munf/a+8mD3nVRdlCgwTro0FpfkeihgUiNxJPdKUETYgWGd60mHQ==
Received: from DS7PR03CA0277.namprd03.prod.outlook.com (2603:10b6:5:3ad::12)
 by DM4PR12MB6010.namprd12.prod.outlook.com (2603:10b6:8:6a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Fri, 13 Jan 2023 16:56:40 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::2e) by DS7PR03CA0277.outlook.office365.com
 (2603:10b6:5:3ad::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:31 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:31 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:27 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
Date:   Fri, 13 Jan 2023 17:55:43 +0100
Message-ID: <20230113165548.2692720-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|DM4PR12MB6010:EE_
X-MS-Office365-Filtering-Correlation-Id: e499d453-7477-4246-6dc1-08daf5872448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMC8qE3QujdB6eAnzlA0qOJGTc5WolTn/MyIowNjurSXFTtkvIDyUQzQdZqwPbiGs2WKLZ9anGRdVDB8vZu0/fx+P7UpdXdZOhRebryZEm0zNMMTuUw3OJvmhTG0lIFS7uOtfzJCUz9na9nXd2sfQVC51kiZCZpnJ9TgszsLUf3m0jCqh5n2AZauyMZr8S4o64XMZAK+CF4P+PbH89Qd+I3rlnX2FWhbMx55heS2s2QpLD3bqXf/C5vjEsgH7ybvahw+eCwbyiaXQrTzcpEmVk+zgFmddkz0hCH5Kkl/LzkOcXOr7PfqDOyXYFwsGC8Dxjs7P+n9QWavb3E7RFyy+rCagH5ZIK0TeMt2hoJm2hmrzBl2dJc3M9EUBJnfFkjHfRiH+Pir3vSgR+yvbu6NP75sgMlbB/yejaPRPQQ+tfnwqEfPVfWddxxHa/LAS0IjdzD7jc6suXgIxoqE+h9Acyof2VqhrBUybpM+Xh4sjgVk1zjiv4gTj9+dPY75qsw+JB56AO4AzSVSZpx/Q6045vF/EZl3qly2LtQbq9Unmb7MfFTAkvtJns5hmDhwHXXVmVP2h0U873efT+V3eKwS3tlj/4pTEvbOY76jBkB96r6WzGHJFvSpBqsxpRPnfrVRHv2RYWbfHl2YC9s08bJFPSfWq1BTcQTXOEtz/fhuv7vtSt0LQXODCJv+G8TJWb3iu4Kx0NGmiD6eUUaOzDYtQ4pKS33I5iYznZJdVEv2Qw4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(2906002)(82310400005)(83380400001)(47076005)(336012)(36860700001)(426003)(1076003)(7416002)(40480700001)(5660300002)(186003)(8936002)(107886003)(6666004)(36756003)(26005)(7696005)(2616005)(70586007)(7636003)(41300700001)(70206006)(110136005)(478600001)(86362001)(8676002)(54906003)(356005)(316002)(40460700003)(4326008)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:40.3056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e499d453-7477-4246-6dc1-08daf5872448
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6010
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

