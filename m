Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941D769378A
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBLN0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjBLN0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4622E39A
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:25:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJUZj33sqoxru/v/r75uhcnphMA4CYyGCiYM/SzaMVOlgpga0g+qnDs5IuyrUKpDY2iRhg6FdL1mg1H7Z4floTY+BNzOouQdAlTo3EpPpxUjQdnElp5aZ0iqoqAHfzx4ghOmFIZ45h2VdbzQNhcnlgyu62Clxupuy9DkvzEFuEHnSCQtS3OMWWI2IbpSgiCPhjcWXyKkKIWG4SzsggCYD/9etjcCCsDX9Y6Pe/3FOWIUBRQ044J5ucmb6duQQfoF26e2hNQujKvIiH391fIpYA68MF69Qj/yaKL9HmWLYjkc3sv0XipEpxGwPfwOFXwodbHaxt5dnBGMWaw6J+BxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sx0X+EUXHei5MbZT515BMAdYJPC/PjqWzsxwsSBCF2E=;
 b=Ex8SKumM5o7oSOkWpcDy7Akm7AZKyH8Jz8+bFgjKUl8AZAwGEp2u//dNjuQ6KJ2G6aZ2dbUsRL04vl7mQ6PtDUWv66xrCuVegPT+e9IlPxhFvOGjdX4HLe3HGK26GMp4NCRFschU83Unetrh3GOJ+W+uuhU6kUHE+hKE/cvWciT0VbutvPlRjKz4UhSw2xMcJajGqC+mm7Q3ZViRPTWFsrU8Wq+G5VInAVquxRd78BxklKrOE7PYVk0EgTcKGLXByh7VDU5IvYew6LL8nvh3gOn28aXD6ycL3RMkOu74lyJ6MZdHiNA2UXyqCHaDscRn6qBiMRkyfNPrh8y/kp8ZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sx0X+EUXHei5MbZT515BMAdYJPC/PjqWzsxwsSBCF2E=;
 b=ecfxQyp8qCL8lCPPrrB1XXcgKrLIJEDSAQb72pSnjvFj3okofHZjiGpJomVb4h5d6i4g3Zyjf/i5Kjr1pJY3ruNh2bSzj59KLP8rQflBXPbvRU6uDJgkg5HrAJ2kAzl9iSLgH3gH6LQU5BYEqaeoyGVomejbQbBasUaruZHhUT7FKAbo+qUA2Pf0FWeqwCpmJQKaAeaFPJ8MzRJ1OMLvsW8S213isVL62feMwWmW0ENRsPXT4oPnDbulN0DDYc9ENsQgTD9MW6RDxGWv5XgXs7Pl05i23TNIYpsMM6c1R5EqMjXrFQjRc/SNdwzysaR8MhoAzpi1XDibeXJvstglcg==
Received: from DM6PR18CA0009.namprd18.prod.outlook.com (2603:10b6:5:15b::22)
 by SA3PR12MB8048.namprd12.prod.outlook.com (2603:10b6:806:31e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 13:25:58 +0000
Received: from DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::4e) by DM6PR18CA0009.outlook.office365.com
 (2603:10b6:5:15b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:25:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT111.mail.protection.outlook.com (10.13.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23 via Frontend Transport; Sun, 12 Feb 2023 13:25:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:52 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:52 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:49 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>
Subject: [PATCH  net-next v4 4/9] net/sched: introduce flow_offload action cookie
Date:   Sun, 12 Feb 2023 15:25:15 +0200
Message-ID: <20230212132520.12571-5-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT111:EE_|SA3PR12MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c9dacb6-b257-4a8c-bea7-08db0cfcad09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmiDVuHnjzYVa6+LUaVSx5eUNXCh7R8WbCWmsC4OamyrmbrTnfTbOVwO+nNS8hrKP0MHjaane3DrErpV2wVruQwWZu+f+NFv9x0faIZX/JB2FVpNCfQcLjm3Yiyl+PsmGNnBeC79i/Lca6tSthM0t52G3Ks52XMmFbDgap+UbsHCUPQTeBifqFfZxW116xpLtCIxBoBwJq7MVE4FSWDmaKxqL4sF/82CqH06onP/rFQ3kvdptF9Sdj2z6u04xE6VVK8n0657SYBQcQxtr3c9Nhb4+F5tz/OblfUEhljWNQERUxvbjyG/tQMF93TpVCzFpsvW9//yMuZqtHbXY24y2uK9RrzgbBjJ/5N2ZzGiPjJa88NZVog3+xvywE1xKtVzW3HdPsJ0to3ZdFqSc4EfOV7jQkSB2EaWgs0K/39tek+YL1r7Im+w68Q9aNwBk4895TPRlvqeNqKvKDdlH4eMb35qWmUM01WzXyCz0BgVEMaaCQSE8B+G01Kuc7a/7qFOPzTPBtcUOxEDyqeCf7899hWjU1oeOzfwjcvS/z4Q1tnp9sBbVmzi6mKwTFTTxlsLEUdbwuovyz+1jaJix9O0j5yy++g6dZ8yjpWARCIrPpY9XjaQa9z3A67Te6HqbR5OPIM0seF1tLTWMQW6/jHe99j7BtXVm1Un7w0XKmsEPoyi1qIGjV0qvpJMJwwrrrbsFVU6/OT3lXqveSEdwIevwQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(41300700001)(70206006)(54906003)(8676002)(6916009)(70586007)(316002)(5660300002)(8936002)(4326008)(2906002)(478600001)(6666004)(40460700003)(1076003)(186003)(26005)(2616005)(47076005)(36756003)(426003)(36860700001)(40480700001)(336012)(83380400001)(82740400003)(7636003)(82310400005)(86362001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:25:57.6039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9dacb6-b257-4a8c-bea7-08db0cfcad09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8048
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hardware action is uniquely identified by the <id, hw_index>
tuple. However, the id is set by the flow_act_setup callback and tc core
cannot enforce this, and it is possible that a future change could break
this. In addition, <id, hw_index> are not unique across network namespaces.

Uniquely identify the action by setting an action cookie by the tc core.
Use the unique action cookie to query the action's hardware stats.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/flow_offload.h | 2 ++
 net/sched/act_api.c        | 1 +
 net/sched/cls_api.c        | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 0400a0ac8a29..d177bf5f0e1a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
+	unsigned long			act_cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -610,6 +611,7 @@ struct flow_offload_action {
 	enum offload_act_command  command;
 	enum flow_action_id id;
 	u32 index;
+	unsigned long cookie;
 	struct flow_stats stats;
 	struct flow_action action;
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f4fa6d7340f8..917827199102 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -192,6 +192,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	fl_action->extack = extack;
 	fl_action->command = cmd;
 	fl_action->index = act->tcfa_index;
+	fl_action->cookie = (unsigned long)act;
 
 	if (act->ops->offload_act_setup) {
 		spin_lock_bh(&act->tcfa_lock);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5b4a95e8a1ee..bfabc9c95fa9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3577,6 +3577,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].act_cookie = (unsigned long)act;
 		}
 
 		j += index;
-- 
1.8.3.1

