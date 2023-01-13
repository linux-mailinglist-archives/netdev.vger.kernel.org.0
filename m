Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2CE669ED6
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjAMQ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjAMQ4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:56:54 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C7742638;
        Fri, 13 Jan 2023 08:56:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvpxK8NKnTcqyv6S6tlf3dL0YTw3YV7+20WJ3gxis2mALmdDZVgoG90+QfcbXYONFDuqfQO6/B+5eqlZcZ6cQIyqApdM/DfnDUWZbf28pFlnOjlzNMBw2MgVSMHGID75iEfRIlnKrvsotD7FDwPIP9LTCyVD2TsHW6cWvo7wJS8PnKY7YrJV4e66SGWfaVsqp/niqaMGemIXMBklqZ5ZZGpajlRrV+aMQ6etY3Rt36Bwrn1bfep2JsKM1XgT1Yu+zvtKYZNA8hSOhM8G71od+bwFejsWoBIKwkY0P8ARUpqxGLUUD/bSlmYdX2a6TdGHRuH6AND0YcxNfJLTBQM8nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eVt+c+15jGRhcTXeDwGGa8OjjrApn0DRx+nf2W7K2E=;
 b=guNdnUW8NBzYpqP+HvyYwH9cWYgovb9g5Rrzv3sVX+8Zz9komWG6dgyySFDqZEMJsA0foywG7aru4nHmjma8gmZsBLZHnL++9qAwZ46lOwnqUXfDugqRzbEgkfEXzlIQQsFbrDJL2mme2HTBYNTpOHPxADElkk5PDT2qXoVrrTwykQbAEHt8Xg0g3MybnpZtJ9tXIp1w9/XyNHSP3c2v4JJl4mtGCaqD7aaHQpYWHAlbmkLo6ndCw90xqFtvYC2uLsKAh/xaYKX5LIjDL77IyjvMAXpoDuhZrWrzKICoLf9SrrBE8ctXQ6hc9M99z1X+zBH6JyXoCzidlNK2+cOJsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eVt+c+15jGRhcTXeDwGGa8OjjrApn0DRx+nf2W7K2E=;
 b=sGUK0pcZVCPDt/sB94v59Gux7B2ADzuZr2RadxY9B9lWPvIovZIFc0envNRHx3dFiIsrjovlZgqL14/rQAD1IZPRvCNgI3S5LZoyaCBNx/fnIFHlrv3wbHUSzqPPG5mm83KTDtJABCX2AYVB2Mc3k7LaqetUnGdXhru/0BR72nGZlVZvohG1+FRrpWd0iVqxGsp6GluUxJKjo/EU4q/XDJUT1g9vYIPfDNmZdPwnJik1pwpxPX1+Lt79BraqMPTA8pJGFXveg1qREtR913Ad7H3Ryhxshd6jME08OFhaKo4LfzKoUC2JpQDTE7JMHBdCv84F3Uwxi1J442vp5G62og==
Received: from DS7PR06CA0045.namprd06.prod.outlook.com (2603:10b6:8:54::26) by
 CY5PR12MB6432.namprd12.prod.outlook.com (2603:10b6:930:38::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.19; Fri, 13 Jan 2023 16:56:51 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::50) by DS7PR06CA0045.outlook.office365.com
 (2603:10b6:8:54::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.14 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:39 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:39 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:35 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 4/7] netfilter: flowtable: allow updating offloaded rules asynchronously
Date:   Fri, 13 Jan 2023 17:55:45 +0100
Message-ID: <20230113165548.2692720-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|CY5PR12MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ec0388-7094-4a1f-df1d-08daf5872a36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NxVzCkP+8aNLtHl6mQR8vq/CwDZK/MHI+OJNy8JYWyNM7nAJfQ1ZrZBhGrHgnmki5B5gCjMWH3MAdTivDzTpfb3GDh0dx/MlkznLqx0yGl2yWDZv6/gj2UVEK+P9dDPPUKqPvfpcMqJK98/eObA3In4wVaA9GqmLjgfmLjZu+hzF0+8CJn5bN4Ue2/HDMj4r//Zli8gdU3eJonNTGTHbXUX4mTuHEoqMYaQrFFT82lGrhTB3f5bDJ+DcWam+fKDvNAfx/567hkc29n7ko5gL550l90SVyU5XmmcSMJmbzDUREO+VTTYohON2a1ju4ovsTFcGJtnnhueYlTz5jpLtKj4pMCDLd1AL4r1G4UnWIl1rnU/3f243p6+KaTSyazt3DbonzPOj30BaCMZhnt8xzU0qvYqfxK0uYNL4ox6+WBrWfQ3KfQNBdEFYPXO1YC315HoXn7AdOfnZPyEYGtpJFoBchZv+7mTN7Cr/WbiNHGLtIt8ZRd4s170GdfLgbDhi2jox2Zy4J4IXJBPLwQaUhn8WxLUYimUrQ6iAb6NStd6e6WxPykGKdpLxhjzG23OOxWqLhAnuEKr0fjkN6EO4x2nldyvsmdkjBgRsOpd5KxfiUf9FIWckGtT+oACoAHopJfPDs/q6p5A3u9VjJT8a8eaUugwBNovjsB25zJJrfSqacQbz+1hawosspSXSREBZwEO/jnl6c/VC9oQqhoNHBEorFjyVQs55fCkKT9Xcaxc=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(2906002)(110136005)(40460700003)(5660300002)(7416002)(316002)(54906003)(36756003)(2616005)(1076003)(82310400005)(336012)(83380400001)(47076005)(426003)(36860700001)(7696005)(86362001)(26005)(40480700001)(356005)(186003)(7636003)(82740400003)(478600001)(107886003)(6666004)(8936002)(4326008)(8676002)(70586007)(41300700001)(70206006)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:50.2569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ec0388-7094-4a1f-df1d-08daf5872a36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6432
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following patches in series need to update flowtable rule several times
during its lifetime in order to synchronize hardware offload with actual ct
status. However, reusing existing 'refresh' logic in act_ct would cause
data path to potentially schedule significant amount of spurious tasks in
'add' workqueue since it is executed per-packet. Instead, introduce a new
flow 'update' flag and use it to schedule async flow refresh in flowtable
gc which will only be executed once per gc iteration.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 20 +++++++++++++++-----
 net/netfilter/nf_flow_table_offload.c |  5 +++--
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 88ab98ab41d9..e396424e2e68 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -165,6 +165,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
+	NF_FLOW_HW_UPDATE,
 };
 
 enum flow_offload_type {
@@ -300,7 +301,7 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
+bool nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 04bd0ed4d2ae..5b495e768655 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -316,21 +316,28 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static bool __flow_offload_refresh(struct nf_flowtable *flow_table,
+				   struct flow_offload *flow)
+{
+	if (likely(!nf_flowtable_hw_offload(flow_table)))
+		return true;
+
+	return nf_flow_offload_add(flow_table, flow);
+}
+
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (timeout - READ_ONCE(flow->timeout) > HZ)
+	if (timeout - READ_ONCE(flow->timeout) > HZ &&
+	    !test_bit(NF_FLOW_HW_UPDATE, &flow->flags))
 		WRITE_ONCE(flow->timeout, timeout);
 	else
 		return;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table)))
-		return;
-
-	nf_flow_offload_add(flow_table, flow);
+	__flow_offload_refresh(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
@@ -435,6 +442,9 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
+	} else if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags)) {
+		if (!__flow_offload_refresh(flow_table, flow))
+			set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
 		nf_flow_offload_stats(flow_table, flow);
 	}
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8b852f10fab4..103b2ca8d123 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1036,16 +1036,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 }
 
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
+bool nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
 	struct flow_offload_work *offload;
 
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
 	if (!offload)
-		return;
+		return false;
 
 	flow_offload_queue_work(offload);
+	return true;
 }
 
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
-- 
2.38.1

