Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603B66641EA
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbjAJNcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbjAJNbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:33 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E62F38AF9;
        Tue, 10 Jan 2023 05:31:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQjMVclVQMqnkxZ2ul3H/c+JmGw5NlpRBFt4+N5v4OG8Gn7yM7bl1XVXuafj1RaAT4sC8nZ1OaSncUNZu4cZfBgEOBJp04HXTfUUNaCKRSFjHUSsuBd+Jyh4061k85vOxYLJhV5AdlxA41dK7o5ycIXx8tXJWG2FEkj0SRaMTRvkcQpRNld0zp4rlCBFN/7+UGNZPDM6DjSsJNk70iiqzaoNjk3ep//vCXLGQgs4Ry+pmQL/guMYh6NeoDfNBNaq/CktW4oyPOCDRcfvTsNUfvSwCORPaP3kAQABJ20EsD0NEYpYotwPOyhKiGyiy9P3jRe3jBOS9cih1rxGMj9l+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eVt+c+15jGRhcTXeDwGGa8OjjrApn0DRx+nf2W7K2E=;
 b=f+TnZ6u1nfyV/bLKX/DJ1LDtvzrNlJtQ9e/yKzOU+VRMKiYoLWIyPze7dwkJUP/hrnWgnl+jfdXear376sDE9T6cP0HJB2xOz5/gw8gHqZ4IBqcjX5/Zc42Ap+UO3lEmYyMtLnpGYaQC0dHqDrZi714Al5QHEiEGcWsxCs1V+W7smI+0duaTri6F5uQLHSz7XzC33ptBQL1+R7yqw2IKqpjXBVnUVxHO20uIekX/3xmO4TTA01iYIsaIturLH4bNcL07Jczo5JPT/fKNPJbodTaR/tYc8t9FhDaqIAbQL9sfTBtCvvOudyvDz0PB/B8FEeRa/jtrhfPFK0x3kg6LQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eVt+c+15jGRhcTXeDwGGa8OjjrApn0DRx+nf2W7K2E=;
 b=fcC05QHIi+LERQ5gixLBwa3n+Kd50rXHej5bEpcgfkvXNsVcTPbboBZjAII7955To2OFCaEQ2FmWOlHij5/qqILo1AgJilFwJv+EBtZURw1jBHxTNehkRpumYdZfCo8QgZlkdDcTXp/4jCsKYwmRoOt82rgQNgaVJyUwOBiosFpqBap9jx/Zfk5GnEpvnmKLWN1FvYn6XmpBbaojD3lbnZMqQhgMuvUFJjmuglgeXXnf7DKrqRZOCRFT8W46Y5evPVaWW+xdbjnDiF8zbgypU47+MQx1kmw1I/JdExjMqy18qg9W+chPRhhjbB5+1oj8+oAlIXQWYm09ynOtlWjlag==
Received: from DM6PR12CA0025.namprd12.prod.outlook.com (2603:10b6:5:1c0::38)
 by BL3PR12MB6643.namprd12.prod.outlook.com (2603:10b6:208:38f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:30 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::ff) by DM6PR12CA0025.outlook.office365.com
 (2603:10b6:5:1c0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Tue, 10 Jan 2023 13:31:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:13 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:13 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:31:10 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 4/7] netfilter: flowtable: allow updating offloaded rules asynchronously
Date:   Tue, 10 Jan 2023 14:30:20 +0100
Message-ID: <20230110133023.2366381-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|BL3PR12MB6643:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e8c0008-6a70-48a2-4db5-08daf30efb19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60Uh8tSsHgS0eNuFrah2xn7W1eZ9LZNTz1fSNgAHBqP5M4OAGg12Nwlm7s6suTLJRG8OWZjQUdQ6xy4RflnfvbRKX7pwOm64o+HntKRGcPLiWQ0hWELYBVKssN6BJ0xhUFY95Y5G1uhx9wficZeHGg0uFUIj2uvs1HvgAipZp9hsVh8NRcExVqUoLnhgDj1ob8hPrSipiuA8tSghQwSL1lqkIQwqMdOCBVcPnLfeDxPsU6/D6Qq4+zsAqxHUvCMkDvIHQH0KcJHDCtBhk7QyKauxGU0yWokVBaGAOvWoilm7s9pSJ1vVGhzHEmaipSB4TX/ijSGRPqDaDidrFR2uF0kuT/9+x1AlIACLtpA4C2TZFgodNIilifinG0tdbDNZxyuCdESFC95zApNcv3qMTbstzk1mRQs9be6br2uw29KzEqhIOhw/H5B2WYESD+5AGz3LZJ/h+fvfn4hKEGSAudFdfEFS7gEWQw22W7KtRvhiTCaGilsIRlCwC/ZvMqsKDo1QDysgY+WiYd2XWtevtc0kKHe+Lcq+d+BSZ94Re4FWFb1laVYK/lEwQh6/LygaPvvw9QTtFCHN1D6NhT4QFvjp+qifIoxjM7uJpC4lkq0ZDbaJeP7td0uH5UBOgqBoN7hrEoKyw62xkegROF/PBGDGL00W7oAma3LdEWYFByQaasXr5brXkIJk2EVGyvDttcIfwoYx0/CH2GSWoLif5G1JDFR624L4sW/NvBWU+Ow=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(426003)(36860700001)(36756003)(7416002)(5660300002)(6666004)(2906002)(107886003)(86362001)(40460700003)(40480700001)(82740400003)(336012)(356005)(7636003)(82310400005)(41300700001)(83380400001)(2616005)(186003)(70206006)(70586007)(26005)(47076005)(4326008)(8676002)(1076003)(8936002)(54906003)(7696005)(110136005)(316002)(478600001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:29.2615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8c0008-6a70-48a2-4db5-08daf30efb19
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6643
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

