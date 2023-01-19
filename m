Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A1567432A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjASTwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjASTwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:52:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A325F9DCA3;
        Thu, 19 Jan 2023 11:52:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AD2cFSom8jiF1XLBYtxwqyAYknw/xq8ssvsWR2eD/FeKJJwYyTMOO5s1/DyQTJnIHfB68ub7vJOnScLdGZy+Ry972E8POKDoE8sLqL+jfyjPsDy7aUhhmAHGdVMl84vVRq0xHWMxYZsqUOw8NZKV6ZApphCKzDiSH9A9YoXgLzvrAS4TF52idULa9chf6fVwO7AKFpku2uQzezHsAnC+aV4ncytfRK4/p78vVjGY1v/n8LF3jNuYB9WtBrR4bt1Cn62GQV6FK3QiNZKfwYdQ00LwYbinKqs3MbPizrpdavchZ1HXqoy6DBS53soQyWgS5YZJi7NwBukFeYL93Zi+cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=ilmVo4QzqWfvAkuEUr758AGgJnIZPdF3FfkFyrC993SYmStv48LFdS69xW8k4q6ISdrkw48Mez9FvsGoImmHc3RnC2qXK3+BG9PzTi6v+YmY8hd3Ol2XsEc6GcGziNLo3ksrYct6g5fAal7ukcOWn7PNzHpO7ba7zjKzE5fZSJY0RS6xe7GO838Ba84p+yDW8SV5ZMjnWR2CDwjGqz9ROOwPtZneQedX8dMDU2UwWdqXuXAR2cbsE91PDQqE5JJUY/8Gckgbzb3s9pXX2fHYFPrVdNr5luuLguzDmAIK+cyOxeoD4IbJjGa03D+ni238w9y7oXrJw7UByR3OvyeoBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=WC9vUY1EWguxWjrZPpVa0VrlmxEPAjuuoGcwNkYigvkOG7dV9xxV2fftkAxzysGLYFebZ1+QovmLGpCES4ZOTMkWEAJAW/MQpzxDgFDHoNzHYicmbirsjyz4MOHRq5/qNIWE32/rt8xmCjM24TV+V5/tYTU+CHo9DQJ75y84jKq29w05KqYHxXk11lhZk4e0H0SCkvACvR43KDCtmSD/YiSIdu6uNv0Gt0vKB93XUAyoIm7Oqh6WUUncthncPzWoczoE2EZEvG8GGVSFq4OZdM+WScdTVGPDvigY7Cj9k9gh5dYsM3AixzMyLom7p1C8bzWQ7+U1qCz5EVhe5jH3GA==
Received: from BN0PR04CA0084.namprd04.prod.outlook.com (2603:10b6:408:ea::29)
 by PH7PR12MB7305.namprd12.prod.outlook.com (2603:10b6:510:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 19:52:07 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::9d) by BN0PR04CA0084.outlook.office365.com
 (2603:10b6:408:ea::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 19:52:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 19:52:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:49 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:48 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:45 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
Date:   Thu, 19 Jan 2023 20:51:04 +0100
Message-ID: <20230119195104.3371966-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT013:EE_|PH7PR12MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: 65938be8-7ee6-43e9-9c17-08dafa56a4a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6/OwtQf3fFzy8oJAcbvzhkiw1eLe7J/nwaYA0XBtm+aIh1Xwes3tcxOk7TamOs1pyLTW7V20tDQM6II4jHoNLRCXHM/C1YQzx/dqakVi30Xc3YdGxwpPZKy//1B6UQ5AYvvaWtjkwMN3isyiYardyf9CSxXN+kMZj3xr4GwaT4xf5ueYn+IJB2ctz4zpExJ0SWRBqPMhu/7xAK8yzoiNdX3RNTardb4Ofzpj4tzOxO7tv+fVxxWVblVd0/DppRba80xPs4ZUL5iqfsjCsGBw9fW6cB0e4v+gtj5G/Z374eMiKi4IACJlWtnqMygHYqxHs05ooukNa1NYZNfYs1nU67R1s+z4Nz2PGLHnR6DHA+ha4tyBtV1uvjD3rurUJv5G68wHRjW0XvdDEsw2CIHGx5kfHMqyNHbSUO3hGkFI/C9yXpZWFxrCDO3W3DeXKOVIWut1VpldonlE7RsiQHdZA3Q+uDS+JNPlYD+o0H3A/aTJ0Xdc5lEEFMf9PyzRx6cmDORQbiEWroNFDcXDxQc7YMVYbqVr2eH0OLZwRc2eg3bezS3vYDGfI5omVQwMgWvBtvQ24S9uzaJ5mM4Q6MhdtZre8KQyeiFuDSacHS6q9vmpffWbwcIo17xw8ku0QU54f5doum7YkcqtBPDCo+ABsb8HnCr1rZ7R1VlzWhyFFNokZD+4ZdPUe2bbLkmzMPVpVBuGfYl4YTpnFUEWKp7W2/tRAmV9TeXdI+l1Hc6zoM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(7696005)(70206006)(107886003)(41300700001)(426003)(47076005)(8936002)(36860700001)(2906002)(36756003)(8676002)(4326008)(70586007)(7416002)(186003)(316002)(26005)(6666004)(478600001)(1076003)(40460700003)(5660300002)(82310400005)(356005)(336012)(54906003)(7636003)(83380400001)(82740400003)(110136005)(2616005)(86362001)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:52:06.0501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65938be8-7ee6-43e9-9c17-08dafa56a4a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7305
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both synchronous early drop algorithm and asynchronous gc worker completely
ignore connections with IPS_OFFLOAD_BIT status bit set. With new
functionality that enabled UDP NEW connection offload in action CT
malicious user can flood the conntrack table with offloaded UDP connections
by just sending a single packet per 5tuple because such connections can no
longer be deleted by early drop algorithm.

To mitigate the issue allow both early drop and gc to consider offloaded
UDP connections for deletion.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/netfilter/nf_conntrack_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 496c4920505b..52b824a60176 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1374,9 +1374,6 @@ static unsigned int early_drop_list(struct net *net,
 	hlist_nulls_for_each_entry_rcu(h, n, head, hnnode) {
 		tmp = nf_ct_tuplehash_to_ctrack(h);
 
-		if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
-			continue;
-
 		if (nf_ct_is_expired(tmp)) {
 			nf_ct_gc_expired(tmp);
 			continue;
@@ -1446,11 +1443,14 @@ static bool gc_worker_skip_ct(const struct nf_conn *ct)
 static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	u8 protonum = nf_ct_protonum(ct);
 
+	if (test_bit(IPS_OFFLOAD_BIT, &ct->status) && protonum != IPPROTO_UDP)
+		return false;
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
 		return true;
 
-	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(protonum);
 	if (l4proto->can_early_drop && l4proto->can_early_drop(ct))
 		return true;
 
@@ -1507,7 +1507,8 @@ static void gc_worker(struct work_struct *work)
 
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
 				nf_ct_offload_timeout(tmp);
-				continue;
+				if (!nf_conntrack_max95)
+					continue;
 			}
 
 			if (expired_count > GC_SCAN_EXPIRED_MAX) {
-- 
2.38.1

