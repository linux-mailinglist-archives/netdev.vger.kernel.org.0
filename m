Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C994830B1
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiACLpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:45:16 -0500
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:53837
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229788AbiACLpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 06:45:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fShdu0i3HZT8x+75ItDNLt3j3YUtz0aTnWV6ukizYDu3q9nadbn7jUb14AoReIzJhaGDcPOYCXFteKQxz3G5gJYSLJ3XfmoBik0mk6LLoC/sxhvA6kOcv4Y+elfq/FO2DMFA7Ugtr/HzeQVogmqtdq7RQoZiIPF/lxPZ0zolO3/bvN4EXaq4nBfVK9Bw35Kew8kn/nQEH/kXKEaC1O5WHC0cMotQq1P+XGet76nLvtZFb2frkFWsr69N2oXVIsiahDMssl49im4RxEdlpJknSlT4emULolHkRraHqWCtY0MGlttoCthChzQgg5OsdR49a0/GuXFuTlYjrzYOf2WB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zc/qofjYh38MvpBm306Y6CPgaY0ivumdYrENlOuFrbk=;
 b=MA4qGlIXuryJTtD/r4ddSwVaCjuDz433Mlsaj0htVrlEbTItxBAJIuJGpjq0Xj83nqqtwHFOrKIdV6LAsFS4BLbp+m0oUEEKADZzGtvmozngPT2lC7x+AVVMLKcOuOcque0qiRqy5mm795vqc7y/AWNSbODU5u6/xRF5PRRW+31Yo+UKBZKd6P6APFGVyUuyMCpnS+o9ODwzraqoipW526ORwRlhV3f8bWxW31L+cgE2VMhgbiF0MxeLB/lxigHOXq3r0PMZqD7CYp2pcxLUWN6HtlkmE9ckxiRmZXTqs21J1Jk2xb8hWEMwvlyANacxb4JhuZwtVUlX+yUmw+Z5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc/qofjYh38MvpBm306Y6CPgaY0ivumdYrENlOuFrbk=;
 b=rYKFlhGVeCq53rwpWcVV4NTsNWjbpmp+ROkJq8iM9hzQ/InWm2sTsF13IUxIT7tuig93h8YB1or9J80lJgPWQ/TNifQgAOjf4Xfb4xc2RVuqWmo/HXWUFRZn/QTVVQ2yoAxqn1C8cUeXyAPT+zLHd+W8egEd18KH5gtkW4V5Ym1B4clIOvtttY514LsC+uOslzris0cjnzPYTSMEGa7CYkqUsb8IqCxhOoZjnUCeGWl6Q/TtW0euKMftuGzGyhhU1OrEu8ppL5LTMqD52R1Qhe6rF7fz80vnKx3CtnQ9tVZxN10R7PBQLoi9h6QmRqnSS12+Tgz59oVtnUxDZfL0tw==
Received: from DM3PR12CA0103.namprd12.prod.outlook.com (2603:10b6:0:55::23) by
 CH2PR12MB4006.namprd12.prod.outlook.com (2603:10b6:610:25::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.13; Mon, 3 Jan 2022 11:45:09 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::c5) by DM3PR12CA0103.outlook.office365.com
 (2603:10b6:0:55::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Mon, 3 Jan 2022 11:45:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Mon, 3 Jan 2022 11:45:08 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:45:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:45:05 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 3 Jan 2022 11:45:02 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 2/3] net: openvswitch: Fill act ct extension
Date:   Mon, 3 Jan 2022 13:44:51 +0200
Message-ID: <20220103114452.406-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220103114452.406-1-paulb@nvidia.com>
References: <20220103114452.406-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60b9fefd-75db-45d1-dd5e-08d9ceae7e3f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4006:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4006933E236389DDD69AF22BC2499@CH2PR12MB4006.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:128;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0s3RqUfrQN55Rkp3CVtV821QAS38+2R32Rn28DPMms/S7EbXgT4mItjAjj9BytYXRKNz53DhCmxSPay/u5oDC0JR2zwC0QNdydvAzOPxOa8dtuMnBw2E+Yl7RZlW6Rb5v/wcKRPzaCa0CHWyjTPRmMh8ioHh6SAbJyp3n4ABGSTvJrRdzW66GksZpBsaI9ATRIIDzR/tXbCw8qkUz297Du80RC2Gz3sAjAEXiHWqPhNYIO/ljOkIMUzFd9daWe0swNfRB+J+Qmq1igle8Xx9VJHnEy6sqpAZYj3FzL9gp8UwGoLWQqy1Sm3gwLCfxIePYgqJGXHkdJ+bW5LDpzE3BmBHwKP8IrhNOGQrjFRiJEV5/LSmFPZzkPrJEHQ+lPyP4Ypc2FNZtZA8NVm4QxDI5mMWaxToqRBBuxnzWrd6y0QzhyGghUybjA+Mhpi0UjYqIin+Au+VDzVL8EcHnVRzvynHOs/BN7eZU2l6mtdmMoP/FhLeWgUx83lgTWH/sAjio3IBGQY1JZLsrf9kuQ9KqRXzWGTG1UM+D7kQj+gNwpcBnoZMmKvFIru80+7WZnO1isd36ln3Vf2OQSft5/auQ52VC4g1YmA6W5/LPNAVAyL0my+nZWHu3JqH2md8OjH/vDyQxn8bKt3LWx4yogC9j09w+WSgKMgWpzrsJbOGz42ujw3DHMsIChBxoZUd8sPQCgcLpTSbAjk+2kJ/x1e5uH3enrvyJQrNi/D/yPJMYwQIg3fDWhvVTqNZTWokCwDQ7beI6dEbKANx+u7e4ytJELXwm+OtQaZ6/dT4p5dZuJG8IhWEBTDBN9RV8yI5yxg
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(2616005)(1076003)(508600001)(107886003)(54906003)(426003)(336012)(316002)(81166007)(86362001)(356005)(47076005)(186003)(26005)(36860700001)(70586007)(36756003)(8936002)(40460700001)(921005)(8676002)(2906002)(110136005)(5660300002)(82310400004)(4326008)(6666004)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 11:45:08.5975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b9fefd-75db-45d1-dd5e-08d9ceae7e3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To give drivers the originating device information for optimized
connection tracking offload, fill in act ct extension with
ifindex from skb.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/openvswitch/conntrack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 1b5eae57bc90..13294a55073a 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -25,6 +25,8 @@
 #include <net/netfilter/nf_nat.h>
 #endif
 
+#include <net/netfilter/nf_conntrack_act_ct.h>
+
 #include "datapath.h"
 #include "conntrack.h"
 #include "flow.h"
@@ -1045,6 +1047,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			 */
 			nf_ct_set_tcp_be_liberal(ct);
 		}
+
+		nf_conn_act_ct_ext_fill(skb, ct, ctinfo);
 	}
 
 	return 0;
@@ -1245,6 +1249,8 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 					 &info->labels.mask);
 		if (err)
 			return err;
+
+		nf_conn_act_ct_ext_add(ct);
 	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
 		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
-- 
2.30.1

