Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746566C3094
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCULnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjCULnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:43:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64998A72
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:43:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrJxNQll5B1tyt3HVHdZfHOp6gup22yveXfpwSknNw4bhZiNJSCGgWuuNGwl9NsiNPQe+pTWuLTasdHiKvlKXhkpoHzrh++1EH3VJI3601lFxcn57NKJrOIK6fe6CeioVGZfy20SzB73loaljX8+0VcfNJvXONBbJBpu3XJye7VYHcpDRWaO+qtPCwqOvh1YgpB393iyjRwJjGYyCheBtyzwvP7YyvkZ1QCTpPAok8jP2IgqQ71l+jwIXKu16W6lST0olinkdopoSFnM4kTIzWEbo+oE1pv4JGZ6MhT6vXkRL323lOLvE7znbAmmwevAnvx5ddYTH0sb0XxnomMuaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+PjbVXJhv51xt9oog0RcXoke7b0YNj/d5yVINa4fZg=;
 b=XEQxHXWRXOa0FrGypbfJsW8t1+iQ/4XPK+iEzniY2+q6egyGphMeElzG95fpDBf7VcrUN3ZzjcVEOCdaGvnGi3mRreR8VQc3qYfnvvHuwQGZYwv/a3vcU0QcRDeC/0sFpznwycaMVune113I3jhnDcqW0nU245bIx1CzYAUjwwc7JTlW+p6e7MKaVbgIUwzdM85AaoduWbm4bHYnPLdrDR9SXKtF6PC1+jeTCluHPw5dsVpWLkzkg9n0bVj9MzPBF0+EGXw2ZnSC8yYFa8Ya+E5zOgOVYM+r+3M7uGNx5y6VUgZRV+HwBQsDelP+ZyWinWS9pvWBVCvWFPdi7ZEsZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+PjbVXJhv51xt9oog0RcXoke7b0YNj/d5yVINa4fZg=;
 b=VqaWzt0hT5xMXHhlKS1jQwTYU5PJxcIo3k4IpVWvQDj4MueXITw4cG6A/TSw+oMfyPhAX4BqcYTyDsajwG1k+pjZvDXDSghyw3vgKJ0oCqu6Uohydy+AwdpjdKwjkGO7625EuVYEp2zRJsl4YMNiuAfazSFz2GrTEH9kfF5Qd67nedJFnXz5l1XoN5i4Q/Z9CVLBTTcCOlN/tl+J805kxelHUsJ3owuroP71lI43HuansnSyOVtl/iY0aMdKcheYnjfUVBxbfljPSFB17UO8bLcbq3HGqDQJ+oEgFjt6vHkGSyRGRnqe2LqLgMXbGf779E1trCsVE2LIvIUpWpkhrg==
Received: from DS7PR03CA0334.namprd03.prod.outlook.com (2603:10b6:8:55::11) by
 IA1PR12MB6283.namprd12.prod.outlook.com (2603:10b6:208:3e5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 11:43:18 +0000
Received: from DS1PEPF0000B07A.namprd05.prod.outlook.com
 (2603:10b6:8:55:cafe::2a) by DS7PR03CA0334.outlook.office365.com
 (2603:10b6:8:55::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 11:43:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000B07A.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Tue, 21 Mar 2023 11:43:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 21 Mar 2023
 04:43:05 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 21 Mar
 2023 04:43:02 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net] mlxsw: spectrum_fid: Fix incorrect local port type
Date:   Tue, 21 Mar 2023 12:42:00 +0100
Message-ID: <eace1f9d96545ab8a2775db857cb7e291a9b166b.1679398549.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B07A:EE_|IA1PR12MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: b88fb53e-6e99-4850-49b6-08db2a017691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AY59oW65vZ6j09UwyAZ7BOH3wac7QlSVaRU/gV3R5FX2ze0Rsgm/7eEy2vEFxKqiqW4+SHDGH5d7GebvgrdQpQWo2t9cHW+6wGEgRDeOB4yVRRgha93iQzHWMWGRsAfPeMJ7Ho4ui0tIMMUUCGb+ge5sDeBGojBizXR7ALOaVjsr8e6xhiLXTs2vNukcUN9lgYO6mDyrJnW76EtMBNIImvpuRo7Ga5EZRDAXSDHeWzyb1meMz0Eg2hLKcDFXVnElVti+XfD5b6c0uXjtrJsqgJ/Qqs0Zf6U+ZmoXfeTKOOVhcjTRzhQIPx8D4qhc8ztrPQ65oWUdwp/Kh6t7yB9zf7TonggWpR/QcPrcJKh5JexKLAFo+WIdEtccCmSu1jOpNbOrYblQKX4dpd/2LYzRecXhOY2sFwhfEKmRTPL1xLV8O06rnyOPxZd3JaP0OTbUR2DVujKfwO0eERkLMUE/9XL9/H/EYe/GariT3Fyw0MSg1NlHSFTAyAiG9kFuSjoS6QN1aMDoUrRj+XtEDFcHJSyR4nQ+21Xn5TXA/fNE316NvbqcaVx00ao4IwX6C1QWBwsIXsqPJ6Y3NJbGJF6ReSnfaumuyAi+91d1G/ceLdt3TzUIs1DellzsNyXbJATHx6SmJsuafDMZvb4CZOUIA85AP+5Lwi45cj09NotnZ3WmpZT4iM1vucRvQljoK1B82DXBSGAGhqJj3sFcuXl7JDf8dhWMwvC0q4zy23D+zWjuq8ao1Xve92krhc4CPDip
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(36840700001)(40470700004)(46966006)(478600001)(40480700001)(41300700001)(36860700001)(83380400001)(40460700003)(316002)(8676002)(70206006)(4326008)(70586007)(54906003)(110136005)(186003)(16526019)(26005)(2616005)(336012)(86362001)(82310400005)(82740400003)(107886003)(36756003)(2906002)(8936002)(5660300002)(7636003)(426003)(47076005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:43:17.4218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b88fb53e-6e99-4850-49b6-08db2a017691
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B07A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6283
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Local port is a 10-bit number, but it was mistakenly stored in a u8,
resulting in firmware errors when using a netdev corresponding to a
local port higher than 255.

Fix by storing the local port in u16, as is done in the rest of the
code.

Fixes: bf73904f5fba ("mlxsw: Add support for 802.1Q FID family")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 045a24cacfa5..b6ee2d658b0c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -1354,7 +1354,7 @@ static int mlxsw_sp_fid_8021q_port_vid_map(struct mlxsw_sp_fid *fid,
 					   u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
 	/* In case there are no {Port, VID} => FID mappings on the port,
@@ -1391,7 +1391,7 @@ mlxsw_sp_fid_8021q_port_vid_unmap(struct mlxsw_sp_fid *fid,
 				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
+	u16 local_port = mlxsw_sp_port->local_port;
 
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
-- 
2.39.0

