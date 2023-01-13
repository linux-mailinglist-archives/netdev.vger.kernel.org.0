Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF844669EDB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjAMQ52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjAMQ5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:57:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281456F94D;
        Fri, 13 Jan 2023 08:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiV/O8U3FQTkN+QFx4x1iKYtwr4a47YZV9PzmABg1xpJIOrcQEzV4i+y+Tx9dLqeOxtkFdWc6lGnIh02JPzwvzqv3E0zcMtlhixp6ljXy6yY0uBV6JvpGJaeGkPswgDCQtdO7qy3jkvYmU5NuyVZFjErwAMt/cyBaC+8iCiP/MH4pVripo24/JLq02ZnsXoSNU6X/1vJj2wyv2ZndXw8jEHKZzwQpzXrZwk8vO0nSW5+nrO4HzkXGLO3LC3f4f1x3KJL8TJ3vu2M5XxdrgGXQlc4fv4j0I7pd/6nz9T3lD8T7ebiMHQFGa/7zW5E5s8LCJh+9barrC9D1OmBxhA7HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5RYK0xo9itxoG503Cnp98JnmWqNNzPa/9Mi27YLsp0=;
 b=nEFex+Fv61I5y8NiSmVHIanG3eRUEDfUqMumQ4+aEo6caWVXjGhhLqj//dgdA+tUdfrjaQuhjn1V132Re4Ds7SS8VKA/32W+y4zLJ65Ty8sV9ECzZ5mKRneHiIUc0WTzCao2JNr3Chit6OhFMTrj5CfXa8onkRyXiMHFUXUomfgRge02K2SpAfaeRc0NRjZlz/5STIiEPl4UBxqFWdgtEbmagxeC/4j36NFJ5SBPAiaLd+yUF3dYfuaxQUpVFuaPjXqSxxqQZXjLF9d1LGDH3LAQXX+uUNdNYfz47g0wpCcol5PDO9OpAiMugYL/n25oj8If2trXsEusmJPaacnCng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5RYK0xo9itxoG503Cnp98JnmWqNNzPa/9Mi27YLsp0=;
 b=h508THYfCf29GWtmVRqv9WFoS7RUvFAuBSWyIwMZLbD7yN/I2hP7JEiZK/boTYw43rZBF1WDzMYMhB3kw9tWvSRQ7i4ghGO073Auwg9f0EsM1hHFY0DlkJw4zAPBrA8UHeTCLE6mJbVMXxYCzuaUekyd8+RDxF0Q7efWVoqG0N04UuWDnVjndXVCNytSIEJna9A6bqswCNirr7W8aSLadXxsXYNdPiGI7nczYb3CNRK7ovzaZW6U1EyA5oB0C4/Ga27lP5KULNKXlTidHjwMi5tr1koMjDFJBZZ8UqqHSbdgOjcfApWnLGYT7NaNqs0Yr3WQqu+L6oN+7UgCucyU9A==
Received: from DS7PR06CA0028.namprd06.prod.outlook.com (2603:10b6:8:54::33) by
 MW4PR12MB6900.namprd12.prod.outlook.com (2603:10b6:303:207::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 16:56:54 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::69) by DS7PR06CA0028.outlook.office365.com
 (2603:10b6:8:54::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:43 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:42 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:39 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
Date:   Fri, 13 Jan 2023 17:55:46 +0100
Message-ID: <20230113165548.2692720-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|MW4PR12MB6900:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e4fb40-883f-493c-221e-08daf5872c29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Omc2wp0vkkUwttGirre0NDSn0zjvfygVTu818uXavt8QqYcRfLVdUbMKKYQpydhzIaMtHKnc8F4XhfjGr1JfiNFKGvDBzQwkn8hgE/iiqqrZq+IqiuHj2lPUoqTdW5j/oPdjtWY1+UsbHWR0z669Qkl6aplsRjRuCWwk8zDy8o8gqLM7CpNcj9v9/OAWiq96pUUDKDf13GXn0W0IzxBDsNmVdOUQ6hqWLmImfLRuk9S5Hw289yF1X+yldtfozg81k2KNPnm+KF/odB2N5G/MBCyDQIPsnCOPArML30k+ueTMjwcYK1sphCcgDk9K0qjm+Qth6SV0HyHFeyBh2jQbUPZjzREauSKFdQ2qE1/279T2U0MickDEkvcajGZcJTL3+Z48YbNM/5fwv1rHUTUcIzSKx5VqlXo5UiXgTZL5ig8dW3PXrWV1bXR885nJbc/C/XDohPE1ZUlOGz4kXgr1S6f29qEFZRP0QtAg4NATZwsDX6suyfLghAIpwvFUptmMyoTgw8+llTkmWC1bLtVmFOMDknNrHQnspFGKkeunzkCgLW2v6Ks0MoFi06Z6Syhz4s/JLOMM0+f0rPdtA5hJGwDIQr1nwpBu/T84dWWLb+AtT//dcOXAoE8Sd4Pnf3/S40uPk+ZBkFQYhP3blE6/yeoo8O26ywgn+J08TMXVyP6mvArAO13H3LSJzwiyO5zhqWf6+16B8TdcKe7XltydInZfkU+gZ/vHm918C0WAmnQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(46966006)(36840700001)(40470700004)(26005)(7416002)(5660300002)(36756003)(2906002)(40460700003)(110136005)(336012)(82310400005)(1076003)(2616005)(83380400001)(426003)(47076005)(36860700001)(7696005)(86362001)(186003)(40480700001)(356005)(82740400003)(54906003)(7636003)(316002)(6666004)(8936002)(70206006)(70586007)(107886003)(478600001)(8676002)(4326008)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:53.5067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e4fb40-883f-493c-221e-08daf5872c29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6900
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
index 515577f913a3..bfddb462d2bc 100644
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

