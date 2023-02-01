Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0FB686BC5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjBAQbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjBAQbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:45 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5234D7921C;
        Wed,  1 Feb 2023 08:31:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHBw+wPh5gZgNsuCjX/8PFzH9e9TdfB0GzyS3HUqRPu64sZMeP57x4id2JOms4icBXbtAgy6bKEPJC58Neh4hwvfx9QmlaLz0u1p7T/hTN509ujkFHmnJ+qIISsa7AQ5BkQpv1LHqpUusH46v0eqNz3/XDWffzYFDZfTRywAcEdzy9rBVrL07dPpWrBYp+IJZMbG4WHvxldrHcZ0yV1kCd6yOyKu5HYtu0lrB8zX/6vvbjDEcsF9bk9kSG6y7ekJbC5KBK9cxKcFJAoBP42lyQdoe9/JxXexDcgWjuOJdCPihxHyXMo/HWGoGnbNHdPzRdc3r8IVXCZgbAZDi6nXXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzQTIwY1V1d3OR26yee/gQ4zp73ZHR9EKI7KwtaVvM4=;
 b=i8OoDOWsdlSy+3Yrw15QsYzwIFwHXSjGN6SgbuT4dTg9p0jSvZJVFRxvfp41zcjYbxHz3kf0LfGzsvcFbzlYKHZ+XlADzIP6fx+AC1EBa2xJk9LCMGpGqSmQzGn1zVL1HcyvAy5sfHpcbi+TA9Q4Ju/tXKUco06hvK2/EjsKkuJEBWip+s8JlBvBc9k9tZTPZw11iKarKzw850xJkvRVAn4yzcAj8l/KYB+L7T/tpXCwqogKsoE7AAuvmqy26SQl9cT5ALN1aqB9k6uo7pS7cY1FTx853wDdv30zGzQxLtrh37hT+HGB7L5Iw4pTaLRbYh3Km5ASSNdkeOddBzHgNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzQTIwY1V1d3OR26yee/gQ4zp73ZHR9EKI7KwtaVvM4=;
 b=P85CNIBfgl0sRbD5zxN7zhNKNzHgK84S6WtQf5gvhSFf0sw4eKFIRWyFwagpc4BBlDt+81WE1gzz4vgAD2nMuKnylw8An23HmN6p+IoGeV4sjc5wrxwUsvbUNDYSMKwAMsMBXOnGTYxKGKZ1O8+E5a9m5I2UYPk1brkqbuhDWqDH+X9YlArDmxN5WPh+VqXTvUOIc9MfPL6YQ/8J3Hf9FZ6funvCE81LAzKncBStE1m444fjlnaDYRVBdMshoV1NUIzbaJpNfTxQ8wbGVldQ9o+hr7ta+OMIss9jmUiSoIABT+BNEsPkPIJBiRbI9cOI6QVDHb5o7coPdY+fb1Sstw==
Received: from MW4PR03CA0152.namprd03.prod.outlook.com (2603:10b6:303:8d::7)
 by BL1PR12MB5077.namprd12.prod.outlook.com (2603:10b6:208:310::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 16:31:38 +0000
Received: from CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::9a) by MW4PR03CA0152.outlook.office365.com
 (2603:10b6:303:8d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT072.mail.protection.outlook.com (10.13.174.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Wed, 1 Feb 2023 16:31:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:25 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:25 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:22 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
Date:   Wed, 1 Feb 2023 17:30:55 +0100
Message-ID: <20230201163100.1001180-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT072:EE_|BL1PR12MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d197593-0dad-4cfb-c7c6-08db0471cabc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1NRV4WqCvPO7B3jqjrOY3IfsJiZGzXyEaPADF826UXjuFdEemQp9+el+48J6pSX1dOq3jdq4v2GQ9zHEEwJD0ZBCf9oH9wfz4WYtWLoEqrDwy4EnFYjWChIJh+TW5xoJw9xmAfmlzl6NNlc7dX2Ca8ndwqNHWvzcPdoZM7kYrGx9B+IfhwAvOShi/zIBcZRtkqETo/lGFDYf+rDlEDL6muIONN2TC9JZS66XR+0MPMhudMOoFq3/mJDjcV0eCDXtQOvhNRtrzkBawMGxZqNYHvmeBhdEMjGcE9VVOSNh/uqPx9szXw28likhgyhQKpYQN2oADCuR4CuBRq9sdQsMAJbtJh2CJPVruNTyrVnkwIn4p/An/CyBa0SxiCyXT8WIO8c/RTtL66ZbXJd8ZRmo4d3qV11xGPyT6K4K1NjFNvwYw4uFL6Nlx+uxizDl4KxjK3d1QP668MJlp/IDrz5XXaJuX0wyfEnS69xY1+k8vr7OA9vCDSCiOfZMDMH8nStAn8VMqXUVDIMlCxPJlJo6WkjCYbH6PgXglYtNV1XxFZkhQT7pQ2YVpur1rL19CYdQAlqFDlRCNb1usXjqvlpKtnS/5uW5TLc1GMTcvhItgWryE+4Op2D5JYNRMcJxkmkkX2kSEVmsQjLfjhgVrgbL4V1Z+9R/Thxj++uOoYPKZ8n6hY30BApV5BlCI/4YgNRwVLdCGYb0lA9C3S47/ONz9o9RxRblFKZMb50GR3LBzs=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199018)(40470700004)(46966006)(36840700001)(70586007)(70206006)(4326008)(41300700001)(8936002)(47076005)(8676002)(7416002)(36860700001)(316002)(426003)(83380400001)(110136005)(5660300002)(336012)(54906003)(40460700003)(82740400003)(7636003)(36756003)(2906002)(2616005)(82310400005)(186003)(40480700001)(478600001)(356005)(7696005)(26005)(6666004)(86362001)(107886003)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:38.1304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d197593-0dad-4cfb-c7c6-08db0471cabc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5077
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

Notes:
    Changes V5 -> V6:
    
    - Revert the patch to V2 version. Pablo is going to fix the issue of
    netfilter's flow table not updating ct->status flags.
    
    Changes V3 -> V4:
    
    - Rework the patch to decouple netfilter and act_ct timeout fixup
    algorithms.

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

