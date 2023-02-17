Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B235B69A469
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBQDkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQDkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:40:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8C13B3E9;
        Thu, 16 Feb 2023 19:40:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSGF5eVU0gmW50uZBYL5e8spfnHO68uW94YlCYXNl4zF6lHgg8zTmGs/r2suErSoxwYd3QyNNclNAu4eFOqpHoEPiwSdB8TV8uc8oNrYSpa9DGErP/u5+klPKNCl+mwIT2lmbblpUkuwiKG4rmEM/zTmeG0GYb9YjCvRkiVvw3Hh33gFB6VXvMgfASSxirZO/l+/FKjflbXM8XJtqLoAdYhrEgRNGQkX+oai0c5PLus66xKC4nI7wGang3s4NnxK4bqtjjekUWCZ0F6zYIINeNhfu8PWsHOITlvuZFIo5aBF7nagNzYGDLngbXfMLkUtSne+bCK+l9q6Y4Drbf+Xiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RINZz/xH9T6HMe50zjnVWntOeXzKKmq93VvSIXSHb0Q=;
 b=ZCuQPE49F/EAWgfCz5Mf8bTjmP2Gyh+NfCkj9JKHGa1goIPC5NFb4IHHOxdZPr0Bj7jajuvkAEbWfhVd0tVAkA6d8Ue1yGaTvg03rB2PmlrO0GYWGBnoxA+MPKHRRSOAOXUBIYyX7A+ieW5bBgYhj8IH8fDb7NlRMsW1xfpgorMb64PZaCNeNRQhQxcwoRA4CaWbC5LbXjiXbBywaGGdFuVALTxwWLGdZ57vFpG+9jK9TH5yV5Xuykz4zOl9sbqGTU8DDlFCnQ8l7rJpotjz2SF6qMR4RBiNnU7KdO03AyscB5cShJijXn7vuzLSPip7DVFFJzZTHTqrTuL3igdzLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RINZz/xH9T6HMe50zjnVWntOeXzKKmq93VvSIXSHb0Q=;
 b=DmfAdzV1GcCCwpXMqMdfXBFTvPF3spDGNiiaK+j0Oc+0ggWqhm6lgSYsKG/r7E6TWs12Msrnswe6HlUkrBMwtmQ6N2ABxVdOs3BlmF32QmeK5u3ZAEVW78GOH7K2WJYbM78Fcag10voladB6wHENlNPxAu6+Nmp9qrxsi5fIKHISGh2h9dWT0z2fSmWmqOIMOug5vE1C8OeJuTRZ4ol+KElkweoOPDMX0Xzs+sWkn8uxTNrEfTcJrKDYPgR27Ip1+58U7pwBcPEEv1rbzWR5lqZx86JxCiLy6K0qfmEymLk4IxEByI8KQds7+t/v9aF/K73g8sr+svb/Uzi602/jsQ==
Received: from MW4PR04CA0117.namprd04.prod.outlook.com (2603:10b6:303:83::32)
 by BY1PR12MB8447.namprd12.prod.outlook.com (2603:10b6:a03:525::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 03:39:56 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::5a) by MW4PR04CA0117.outlook.office365.com
 (2603:10b6:303:83::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Fri, 17 Feb 2023 03:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Fri, 17 Feb 2023 03:39:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:48 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:45 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v3 1/5] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Fri, 17 Feb 2023 05:39:21 +0200
Message-ID: <20230217033925.160195-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217033925.160195-1-gavinl@nvidia.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|BY1PR12MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a75b6c-ab22-4d43-92a0-08db1098a2d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FW7cEsqB1qJU6qc/jdbyQ7DuJgGq2znfU04EI5cz2rODtiJgiqwTpH96AqKST2H+LEPueIXdOX+DFYA46q5evvcYVWWeXwX4hjz6c+/DIqhSQ30Qfipp9EALGrIfhP/Eq4dd73vJSZKzLv9fjhDmrpCFTRoaO6P7bdriiR6Biw6jOkJcTFRoNxn5pzqqL5o1rM+6KjnOBIrW+6R2DXhzTvQm5Eqmz7A6p1Jl5BeYdqbNFkVxBlfMcHFAPyrkvtPuAe4x+ORYjCGDOsiAFay+r9oe/jJEiNSsyomKaNzpz6y042x4mBbnBlQs2xQccg2tEyEr48HL8SiQC4iSUN+aUHrKqD1LEklF4xaDtxsxesT4HXhnbSJ+dyuJRBOz/ZUBbvCmhrIalXT7NklcinnCDIf5D8Dux63oQbysEWKzgzIt0n/xXM27kSGrylZGL5Y6v7J5KI10aJuulKmoP5lB7G/mNqJjycCal8Aw9ZejpaUYCR/BAeGpDimXDSKkmL8UIVl5h566/vD4aPHCa75q/y5b5E9DKspdBT2HJEW44CYmw51Ngz1pboQziH0cHJiNG1jTBIaamtkNgnNfzwuEFiCUIdblcOI96XqEG5DrMpfwzJ5j2+Ukwpu06KeZKwmKK+efpM87/rLxo9sd4RMp96QMUMFm1OPVDdjN/ZzqZjRYZRUU+e6VDPnx8BTjUoIh3i5cH3bvMZ1y757UBZ6jtw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(316002)(8676002)(4326008)(8936002)(70586007)(70206006)(54906003)(110136005)(5660300002)(2906002)(41300700001)(7696005)(55016003)(478600001)(16526019)(186003)(2616005)(26005)(6286002)(107886003)(1076003)(336012)(6666004)(40460700003)(36756003)(83380400001)(40480700001)(47076005)(426003)(7636003)(36860700001)(82310400005)(356005)(82740400003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 03:39:55.5164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a75b6c-ab22-4d43-92a0-08db1098a2d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8447
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused argument (i.e. u32 vxflags) in vxlan_build_gbp_hdr( ) and
vxlan_build_gpe_hdr( ) function arguments.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..86967277ab97 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,8 +2140,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
-				struct vxlan_metadata *md)
+static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
 {
 	struct vxlanhdr_gbp *gbp;
 
@@ -2160,8 +2159,7 @@ static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
 	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
 }
 
-static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
-			       __be16 protocol)
+static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
 {
 	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
 
@@ -2224,9 +2222,9 @@ static int vxlan_build_skb(struct sk_buff *skb, struct dst_entry *dst,
 	}
 
 	if (vxflags & VXLAN_F_GBP)
-		vxlan_build_gbp_hdr(vxh, vxflags, md);
+		vxlan_build_gbp_hdr(vxh, md);
 	if (vxflags & VXLAN_F_GPE) {
-		err = vxlan_build_gpe_hdr(vxh, vxflags, skb->protocol);
+		err = vxlan_build_gpe_hdr(vxh, skb->protocol);
 		if (err < 0)
 			return err;
 		inner_protocol = skb->protocol;
-- 
2.31.1

