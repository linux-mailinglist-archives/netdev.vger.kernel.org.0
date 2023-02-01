Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC43686BC7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjBAQbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBAQbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FE17963A;
        Wed,  1 Feb 2023 08:31:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXsxL2UFsfQsLDp4mjr/t8cArm+ov78r/ZqyMiJmOA77WPE0LBzLhLyS4RPV/s3Ya9QbGCEvSq6J20AM/H7yO5DpuIkUDJam4vyYufuAL1CpCwY4MrLRM8PeNqnGRA0bap2805Q1o8bgIjU4qmP9DTCUe5TKVrQWThM9PBjIqNpzROenILt/mkBnb3uAXa98gg8AVQdmg2JqiHtplz775odBME73Ag7BoazMf9+Ttea7Hi6Ng2dCqYjnvob1qFMz9WobRYF/XHtWd9WETQ79aYlETBzZAwGAc5Tes9DDcJX9OQmdn4KJrmufg8TUigiwFcg46U1HK2OHInVDHCHGXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMHH0At7TvL8tnKix1ZU13BrTUvWcccam1fmltu7nII=;
 b=jsLlxA/qQThUqfKwRGaZZtOGFUePzb4ymhDCNdVfm7dwVkbJIg+u8ES4j3l2kmqd3aiwqWgJuXhSvFrgog2Z/jMnHT/Qj3olygrY/bOuYpuS0mBIL+wtf1RYlqNP2hPpwGY9FaupIjz4NcBc97rvWG1JE3SR5T5vo5y8uzltxZ1wtaBJDnQMHc5qX6L/D5DH3uG8g731n3mpZzo/mR7txSmtwkEzeufZAjnNZeJa50uF4kxG2bhfUenkyScP4E0TEq5WaMAZg2iIkHaaVEhHag7U0hB39llAJKBDENcx58NL2uAYdzXg1CiWCF0j/+5Ybb7l/B2gAuamotiTwr8qMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMHH0At7TvL8tnKix1ZU13BrTUvWcccam1fmltu7nII=;
 b=QK0q6NGcBfYlgjLh/FpESyN7bMJcn786bVM+TIviiRhwM7j9Ltc/MOnLnmaJQOKBERAbQKl+NLA46rzb0g2E6x4+qvRDfICMHpejyNFWwNxXvrGeIsJFW9ZrVULr6+8jVhBWMXMQ8fJV/86neNEP2wFOfAK3xKkwzrI/Hd1vxt1rTitiQ3+Vl+40x6t4iVlPxXYPcPaUtbbdgVXXCk7M1yYUItLZ8mHoYx6REah+xgoL/6kQmfcPnLZ24nYRQolSbJQm7Q5LFMIr6aT331f4oanNRvtkf2zyHRrhUkDO3MH0qD2khM5Wam64WpXQwIrUQPA+Es/b+ASEchmwCeM0fg==
Received: from MW4PR03CA0180.namprd03.prod.outlook.com (2603:10b6:303:8d::35)
 by BN9PR12MB5050.namprd12.prod.outlook.com (2603:10b6:408:133::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:31:43 +0000
Received: from CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::34) by MW4PR03CA0180.outlook.office365.com
 (2603:10b6:303:8d::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT072.mail.protection.outlook.com (10.13.174.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Wed, 1 Feb 2023 16:31:43 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:36 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:35 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:32 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
Date:   Wed, 1 Feb 2023 17:30:58 +0100
Message-ID: <20230201163100.1001180-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT072:EE_|BN9PR12MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: a39a0223-33b2-45e3-f6a6-08db0471cde4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0D0FB6El+t+qzPbbsBXRLWX/Ai03wmFwQGJyfwVQQXC46lHLCRz24duaZBno5JLiNxeKgyu3LIoLyJQ5M4W85h5VNvioIaMytQS6W7cMAL9hG1yDqoOPB2FbvfCtHSYy2HtTFCdxywujV4HedeXdeUYKvY+gPxvl6MDs+RckjVIEiGxwZdkVVCW8TLw/8tIV14cEaMSc4lPb7sXcDR84hxgPl+O7vxzqc4ZXDKG0zxeMryvYrf1Dtqf/nfwNccEWeDhmWyV7lb3vr7e76xgVcP9zjdHpXS3+prl15gZfz9sPi3aOSE5J0Ty5KmB/+NOZH/jrKwqxeaYHO8hySFBztcL/tIhyNcxzrZAvd7a6Zp/SBD+L5GXPUasKorcwkvUCMR0XeOAnVTfBc1lwSHsBeSsHJ8IVsR1ELzV7Lydc2wg1opUOK7E/KW6qSJGSOGc3AxMMdtrRxMT8aVz7sa2nUg8FvBHttPnD2pHPZd6haXFLerfIjPIxQxaVYtYrg0vi3wiaDDpq2dfRwSjM4t6t1hkX2IVd95gwzlnE0GnKYtRqE5HvgC3syIXZwZvjR74phgFQ17JP2zY/UZyq7q9qQ8ju4Ztcds5YlOf+id/yl+PS5H8WKwYZPhdYdZv7hYKsfF3CazopMQK1As2ZveGJJKzApzrZL+9SG0r1KLKNm1MJdZQcQDc2oa3w2NW5axXZQPsBSfKzSsJisUxRGZlrZQ2sj6fw1mXehnZC0PxN9+Y=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(1076003)(316002)(54906003)(4326008)(8676002)(110136005)(8936002)(41300700001)(40480700001)(70586007)(70206006)(356005)(7636003)(82740400003)(86362001)(36860700001)(36756003)(107886003)(7696005)(186003)(26005)(5660300002)(40460700003)(2906002)(7416002)(82310400005)(336012)(478600001)(6666004)(47076005)(2616005)(426003)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:43.4269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a39a0223-33b2-45e3-f6a6-08db0471cde4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5050
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tcf_ct_flow_table_fill_actions() function assumes that only
established connections can be offloaded and always sets ctinfo to either
IP_CT_ESTABLISHED or IP_CT_ESTABLISHED_REPLY strictly based on direction
without checking actual connection state. To enable UDP NEW connection
offload set the ctinfo, metadata cookie and NF_FLOW_HW_ESTABLISHED
flow_offload flags bit based on ct->status value.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V5 -> V6:
    
    - Update to use flow_offload NF_FLOW_HW_ESTABLISHED bit instead of
    ext_data pointer.

 net/sched/act_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 5837f6258b17..4dad7bf64b14 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -249,8 +249,10 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	switch (tdir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		dir = IP_CT_DIR_ORIGINAL;
-		ctinfo = IP_CT_ESTABLISHED;
-		set_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
+		if (ctinfo == IP_CT_ESTABLISHED)
+			set_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
 		dir = IP_CT_DIR_REPLY;
-- 
2.38.1

