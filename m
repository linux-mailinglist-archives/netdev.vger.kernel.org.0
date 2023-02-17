Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB69669B193
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBQREM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBQREJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:04:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DEB68E6A;
        Fri, 17 Feb 2023 09:04:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgGbYAYGFFzIKW7VPrTG+4XUMzekNlx/y3+BaDCJPNo6NVi4oUbTOvFFCRTsk2XMf9JARVYNr3uayjxgnuBYZjs5g/3V/G7YK5C8Tt9JLT09YFxsBZpCtYkwlg0MCWZaImrvwDcNjBPKizdsLcIM8iX1bav+tnPBbrf5x3vUmKQpEWcmzSv2x2yqIQU9XVYsJjGE9ny647FAy27fOpIfOawxpV+zdRrNPzBmZvZX7rbJykwwlFr0hitVGMkfKKEFnCAZHi8aZmb/y0z3X36BbieBqHvic1CgyrptQeOfGO+kG5FR5l6nvjFvHBFF/nbOBKZ/I18c+3VUeK2RPkO2aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G44D0UO7yii02OxO0FEqi0luvf40NJoOEhWWUrZnp2Y=;
 b=UX+caR/RGHpeiXBz/RtmPt6UH+FJDKUx89HXjaT+mexmw3fH0nQAbXF4eq7yXpTzE44hXSKO/usRpTo3OCKKEFPrmnn7lT57zLkltsEARoaJHe5SlJEdWYlj8zATsX44z2NyGXgZYSDtZDh3ogSELMKApzlS1izkwm1Ai2AjahiY3h/sqnYicfyNrGwZMJT40FHEVemzqyu1l3w7sadEZobgmhEWBlNhZtLUQ0SR2uw2h+EJJ5y3c23apzQnaulHbt7MNXiexGp676a+TejlVB1E2VZ/jwfnjEDu3sJaZYudfzV/H0iZDbI7EBi+T6Gi51xOmUSLaPrrQzLwMS+Dfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G44D0UO7yii02OxO0FEqi0luvf40NJoOEhWWUrZnp2Y=;
 b=DnJq2IjGVuPRkj6iL0Jzl0s+XzjKTAoI1ILWr5tNaDfuuAxZAXe8cAScmImEOjTlr1A2zzZWdPyFM2KMmQBzAy7XOxthSVs2gJRUQYytymsax9IsiZPotIScLj5QJMsuPHlCW4qxKoKYTJ4u6kNFCFsrixe0QcSEXAFirTU508Q=
Received: from DM6PR02CA0168.namprd02.prod.outlook.com (2603:10b6:5:332::35)
 by MW4PR12MB6825.namprd12.prod.outlook.com (2603:10b6:303:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 17:04:05 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::24) by DM6PR02CA0168.outlook.office365.com
 (2603:10b6:5:332::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 17:04:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.17 via Frontend Transport; Fri, 17 Feb 2023 17:04:05 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 11:04:04 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 11:04:04 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 17 Feb 2023 11:04:02 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Date:   Fri, 17 Feb 2023 17:03:48 +0000
Message-ID: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT013:EE_|MW4PR12MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: ed13a889-c942-446b-b644-08db1108f9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9wPYOvYbEIov4qjh7gr9oqWKe/93dXkXOh5Q96Kse0DvPAoLw7T/KiCV4oyiyabvrG4b/gRSMul9eD8ihJzK2x+ztyP3zoh1/wx7ys1gythpDHpCG/sjOd+7iXJshLfw4ZkpWvGt7Vk+fqMtTLzmKnIBUcZwtP1qlDWgyRnWvuxlbu2VsZFBzTmTvdUYgMSYsc4z74AYaPCqV0fzzoW25/rreledFhaT4i7tqb2zu3Jl1gD1NWOw0HD9oMxp0tbD4gbLwDRqJVzlfeMQrhlYVUJCUe3fCOBXIxmfLLQBxBAWpQ7iR0Ghf2Jux1zvr9Hy37wn1yj1THGBnxCK+t5l7v6p8CoQlfHLtpaTI5o1l3VyVmMd+tysCKGpeIBdRNaEQfWF8dwWRCu5y0S8erykeHOYb209Fk3br+4hDOKO7PtXjJjnphRUsta/Lvq0hEFLkS4S4AtRD6iVkjxw06ejeKGQMagySPrVChovXO7n2GZnwNJmBksPVeShgk3gXsFq/XI9TBpzzGalAaFTlx9bmpT/SE79nJMh17bEfQNUGnqSI4CsTw3WDAqvjPliAkNon3s2QuKLk6N7KJcG4WL6EbTofn9Gq/VKu2WiVUNk99qSfNGlJteyAtXSA0Gzmy/4301wVcE+hMh6UMxWshKRew5+eybtOOdmBDHqT/AC0b+ut/ChVUOLH60qCEOUpSorIPUJpeGRdD9wxjkF9+N2HhbZ9POKkwAYoJwdP4FtIU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(82740400003)(2876002)(316002)(110136005)(54906003)(8676002)(7416002)(8936002)(6636002)(5660300002)(40460700003)(70206006)(70586007)(336012)(356005)(41300700001)(426003)(2616005)(4326008)(47076005)(86362001)(40480700001)(81166007)(82310400005)(83380400001)(36756003)(36860700001)(966005)(478600001)(186003)(1076003)(26005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 17:04:05.0629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed13a889-c942-446b-b644-08db1108f9cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6825
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Add an embarrasingly missed semicolon breaking kernel building
in ia64 configs.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index d2eb6712ba35..3eb355fd4282 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
 				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
 		rtc_time64_to_tm(tstamp, &build_date);
 #else
-		memset(&build_date, 0, sizeof(build_date)
+		memset(&build_date, 0, sizeof(build_date);
 #endif
 		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
 
-- 
2.17.1

