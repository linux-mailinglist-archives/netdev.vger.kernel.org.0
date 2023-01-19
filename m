Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADFC674326
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjASTwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjASTwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:52:03 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AF09CBA9;
        Thu, 19 Jan 2023 11:51:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtlNfbban7CV+Oank0GhTYRjbykDoK42Of0K8EEcG/xIH2/FbhTAnfI9qTAWa+gEJ6px8Bv3/41pvZIcBvWEUY4AT/AM0coY6HNdExWTxJEBo0wq4XllL/vFnDhxXATrsbI/+by5vQKE4javAKK0zUk8Yrn3kK980TfyNEAXOpMHkECokb3STfwnF/AZhPDYMic50GuBzBoELcwF1wLNczBHOKJA/IK24jz4beEGfqXqd62nbgPJn/3+H9sybrT/RViYJZ7BjsDemLbflaSLA0hrs9UKQ8UCNtha2xFpmMTaeII3WQzUYhVOxpy8WNAdCMe28yIV5/zdhaeC4gIAMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paj5fTHzzwb+0m3T3j0sZC3s5JYBPwV7zFv6hU3/mh8=;
 b=lqt/xT7sHww/7RhP04+nqafKAvI+tGks4P6PXX9jrffPvj1sm5hOL6RNCfiZClRltMFkXkULOApOYMQHHr7PqLNVIMrqExP1VJkX5mJLwCJAm1nIJL+zxQy4RRNookHfL1i/iiDkmGItHMQDjAAYdpMmuNjzdLD6M7eLMhuJTzqWjrLjvy5WhIQ+9i8dtDcum4p3QfusZOaMWGKpWU+V8ElniKeIjDlp9/BimhuC+g6e2SxpLY4T5kKioDdve8VCn8mURxacEOq4y1cuZVJ1RlDNjF3lnuZwK3xRiWC/krQFBRdAOgyrmv70D5kwJnUkJB190JuSUR6dFe7+U2R8Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paj5fTHzzwb+0m3T3j0sZC3s5JYBPwV7zFv6hU3/mh8=;
 b=TidB3gU5CzMvEyckyOJ6hgw8z8PBr5nw3TGI0S69YkcNQlyn/fpx62+HY7LPlHt0jilbuPcYdy9MqmCQFIiKk426N6UbOJPJC/GtaY9XxuFQXYE5UJqKNyG/F0aVXHkU55NgMct1VjVxgQXY9MX0xb053MXzNV3k+8reyT7Fi6H03dRb1xpW6zx/8l77Pbk87+U5rQMUd8tV8SxbmzEQfsZzsadeB7IHhPsq1If1kH6W0HvSYSUqmnXrifpAEZ2Fe4XK14ViH1aUCEFFa07oGRvX3b3Rkwdi4ZinhjIgkGEnqcm/xw4mUz6bkEOFTMHKbLSPJSlh/b1c1pyZeuSYEQ==
Received: from BN7PR02CA0008.namprd02.prod.outlook.com (2603:10b6:408:20::21)
 by DS7PR12MB6005.namprd12.prod.outlook.com (2603:10b6:8:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 19:51:56 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::5) by BN7PR02CA0008.outlook.office365.com
 (2603:10b6:408:20::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 19:51:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 19:51:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:41 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:41 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:38 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
Date:   Thu, 19 Jan 2023 20:51:02 +0100
Message-ID: <20230119195104.3371966-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT019:EE_|DS7PR12MB6005:EE_
X-MS-Office365-Filtering-Correlation-Id: e71ebd7a-0d0d-445b-afa8-08dafa569eaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z90m4L37GtRBdq1hDNuOkxH8tT4mJRfkxCO9Mfs1y0T7rp/AKdbVDUKI23RcYffzxNcXSc31wLHBnueKzF7DVFAGXBTJBEE0IZJ6iNciuEC4CGt3u90tgP0XmjvgEtY/zejuNE1Co6Yhc4mMlNPgygR7gpjoSlW4w4YKVjEHcp2moKhxpc2iGEr2hNpgkSGbexhHL3QsBhB3iMtuTo6FBIZFoHilpnNay7IY68anfijWIfiVUKlWC6WqvZU3mE+TfyImut+uK3duQP//0mf2ETBdAUvfSi+qvi66vi+FYmNPm4tUVWkslbklGGq0BgNjDdB0AQTcoGpBUUgwgA7dCdWG+wDSCU1IFB1RsouwjEKZ3Lffy5Zlrsrqu2G7HkslrU3mtKoivXXeLxixpJvNGVQcb9K/V1tKCOteRZzj4nbVv52lU/pqf0iX6VSZ5AK6HX9a3YwYjdiwFsV+KsJaNrcqUDtIqZqdf2vgow5nA21qxOSC/ojS3+AjgzHegROuH++8KsUV/Mq+P3qviD9rVww3R9f9phXaVDcUwozJBLcRhcvLtbYJsYLpUoFANTWZhWw+jkExzkA3nlYGXDsGVzVMQf6JucN22fDG+mV95XY7kO8gnZ4E0ss/dNbpVd3+qS6pH41CAoVxqOtepljMCa5pMGoSAzAnhcQgDumkOuy3MwZYnDn6v/ooBFgOFAc03iViT6zph5iUaCmg/zAxi9B3eMCwn3bxcXdA/Ir57Ig=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(7636003)(36860700001)(70206006)(40480700001)(316002)(5660300002)(86362001)(110136005)(82740400003)(2906002)(8936002)(7416002)(70586007)(6666004)(8676002)(26005)(41300700001)(1076003)(40460700003)(2616005)(186003)(83380400001)(336012)(82310400005)(36756003)(47076005)(7696005)(107886003)(426003)(54906003)(478600001)(4326008)(356005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:51:56.0276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e71ebd7a-0d0d-445b-afa8-08dafa569eaa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6005
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tcf_ct_flow_table_add_action_meta() function assumes that only
established connections can be offloaded and always sets ctinfo to either
IP_CT_ESTABLISHED or IP_CT_ESTABLISHED_REPLY strictly based on direction
without checking actual connection state. To enable UDP NEW connection
offload set the ctinfo and metadata cookie based on ct->status value.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_ct.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0ca2bb8ed026..52e392de05a4 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -182,8 +182,11 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
-	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-					     IP_CT_ESTABLISHED_REPLY;
+	if (dir == IP_CT_DIR_ORIGINAL)
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
+	else
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
-- 
2.38.1

