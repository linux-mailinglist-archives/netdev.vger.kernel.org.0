Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770C067EDB9
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjA0Sjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbjA0Sji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:38 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C613A1DB81;
        Fri, 27 Jan 2023 10:39:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CV2CHA5Nn16nYCYCc1tMeDVy3x8ey7+84CWN4w6yX3osTUhHAYnFFvsZK6J6/+cG2W3xv9rioFCUC9oM8lXG3e1Jl0KzpRSwtuk2chOQh2vY4MbfrvO5BI00HLWAiWpLblNOGNyd6Zkm9YbsKziamAaZ9WucRvKOvOvtGmzVLXuFyNExqFlGZfoXd316cnvTzkGGiHLtnH6hS52iip1JecL09nYlKRRTvyvD6XuZmfGpL7tRzNIEC6qhDU/f3COZjWz5aUD7v+LkBkVNo4gC+2N9DNTseI4+kN70Fxo8IDhmfui+MOq8KHVZfATTyf28oGr+iRuLsMr5X4/ggrKVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fc5chHB3Hj+JbD878mPb0uD62fVD37gKGI4Eclruct0=;
 b=gHIrEGJp6rI6RF4VLx09WCajFbpmYNy+xLMzfrz7eUImvuj6AUmqzM/27twLtZ3so1iGSJCcJwTOERXdGL1QvJhq1bZ43Fr+th04jW9V1jdYThRx6gOf67D3mAPlGGLNBrN50gawgvajyK4X1yhor+JnDsV00EOwJpO+p3atTCmtJCdcsqsBfi9ECOPBp4UYNEASPp1oX2sdSlAQOEpNeWz0o+Vx/WZf8Yj6ERB2SFnIYEjtv8cSNEmpD/16WLx4EuhF7jjrWy81252KWsFHjXxTLSXvAQ9Q2+Oy1/F9TVenduVThoXmfEp8CJBnWw1feH80KQYZBX+dOr1ywMFhTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fc5chHB3Hj+JbD878mPb0uD62fVD37gKGI4Eclruct0=;
 b=Ad3Xvj86aBC+rycPiTYSHY9GMhgc7toKpNWdtt2wvcwZIHSykyGIuyYq3eqSFNiMfuvl8SFa5cftUDzgh/1/FW24Fqfpxr+z64N1Q+x2YzzmrN9ZUarF6Np6SH4vVqDpd+ImdFN78Ji8vZD+a715OrfLjeaqoWJvzRhh/ASJZWltTWRm1nkEsDFpdhTZ8TbCGIYTtWDqfMMHg1KGoNutxUzR46DA3g8IOW2XqLdCwnL3GqSFOBSbhEeE9sKur/aivUdlYax9QnT2X9SlYNh7JF/Lxc0aayV+cdPXnYJ2JhVYVtBKHsmEU606HqwBNcj2bU/NXJB3ZfkjPwdeR0yRlQ==
Received: from CY5PR10CA0017.namprd10.prod.outlook.com (2603:10b6:930:1c::20)
 by DM4PR12MB6157.namprd12.prod.outlook.com (2603:10b6:8:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:39:26 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:1c:cafe::ab) by CY5PR10CA0017.outlook.office365.com
 (2603:10b6:930:1c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Fri, 27 Jan 2023 18:39:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:18 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:17 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:39:14 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
Date:   Fri, 27 Jan 2023 19:38:43 +0100
Message-ID: <20230127183845.597861-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|DM4PR12MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb8dcf1-70af-4df1-ccb8-08db0095d106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYxc+j1d5E6YMj+ibnefY4wTNdHnrowHybJZbLB0h398CfKTs4r4Dpu5i2fozpVDocYpyCPTt6DVacpQuWUYTKWP9Ff+NMIYDx2S61U0aQtqGNBGS1gKP8HhCmveoxwRgF2jjP2ph75C0HjZERBhOPEd64zRX2lj/7qCAC8biOASTKbuLxHBAR4qti8t7yZvnau+M0EjuExOi2y0fjEfS+p1fNUlcG4CNWsmVXFgtLtQahg3MkzHUQ4R5rqhnBbIH0rO1lvS0ZW4BkSy5X82mYWz3ON4pRBjuR7xT6V62ncRr2JBUL1/QjrfXvcff84pdS9qcGSnf6RvxRSPJyYFvaS2ZtO1lsk2VVuN86ZEjn108ynr60XqejesULQybPBomUw6EnNox1yY7h7/KbamUSEAtcNTLiXvyMT8mtVWAaG1RqhbsOWmgW+1lDHuKKOKaIjwQ9MMgPQjk/wHNn4KL2EiUdkKjCSUM+nDbVFPLpr6YWoRnSg6WXreIw4ZU1rkxDwURtobtxxlsuE9VmGro57A6emkamEUHkSfHC5sHmPssdh8XYyk6dPug7D6Ne8C6n/mkYqX6geKGa6bfd0J2zEgeN1ONu5AbIIgpaF/GHCwaIs9Sf3OoLo84q6Y5z8KDHJRlSI0gqInb3WICLJJ1mINjYjC+xZvikYOYHRF6L6wcujPzIfAIwXwpll7s4gcXPbrSm3e6huuOJdB6zCLzq9O5C/9xFRzEMx7P1sVZys=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(7696005)(186003)(26005)(478600001)(47076005)(2616005)(336012)(82310400005)(426003)(83380400001)(107886003)(6666004)(316002)(54906003)(41300700001)(7636003)(8676002)(356005)(1076003)(70206006)(82740400003)(110136005)(7416002)(8936002)(4744005)(40460700003)(4326008)(86362001)(5660300002)(70586007)(36756003)(40480700001)(36860700001)(2906002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:25.9024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb8dcf1-70af-4df1-ccb8-08db0095d106
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6157
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
 net/sched/act_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 48b88c96de86..2b81a7898662 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -249,7 +249,8 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	switch (tdir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		dir = IP_CT_DIR_ORIGINAL;
-		ctinfo = IP_CT_ESTABLISHED;
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
 		WRITE_ONCE(flow->ext_data, (void *)ctinfo);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-- 
2.38.1

