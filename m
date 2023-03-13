Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFDC6B7F61
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCMRYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjCMRXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:23:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E064544AC
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:22:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8dcC1/U7j/Wrs/L2z5oBTc1FQK+b8FwDUJy2f3IqftXCOLax9LZE66cp7sLevpNCJOvVlENHnmCAA29hRMfp4F7zvYZJIkmB/Ph2GeU+D0ucdw+oAhzYQQQ6p+9WLvp5/nTk9T4zWIyV8N8PGTbWmJYepzaECVZLTEXKsBg7lsVx+mNa6Y/i9aBCOovySjebJQihXR/3I3seSq9E6KRg2rujJOsxhMQ1JJqnDS2qomTIu4ZSnAHPVAtgbNwXUpDTS8I8VW3mmJ6XPWPh7SY/V4ctmoMQdqIBLHQLkgVkv8Dh71bXf0M6W5ZpYOhjRM4xgzAufy+039ASvqsK2C8vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2AbBktE0bbUdvy08BqH/+239OsWOckfU+QebGrpONQ=;
 b=Doq9kFQzKANmpL/jcK6mnqN4WUjJKBj487RoRLm49byJb7Wo/XJgO8r5klB6VZccMK2+5/pwwt2Yd9TF8ifrVmppEfW8vXtDJ97S8heR7r1nFkLN9WDigLDlDLvJ7pqHK6g2xgzcBIb4WjlsR4Tyswdfx61QQGH1tWFKCOnjecs6TQc21SvSLCx6AayrGLELTHfISQxcHyAn/N7IwKKTN/7ntZWDmQHVa9fX+l9gpmnNfHhS6Hc5OquOCDaWeI/olaY7Ou4wMFp7hrF6e1iNMt8oVXJ1fORshwKZXwTX/tefnQ1YWqnN2zSPbd5KT0y8gSsAG/2qfejwse2orpajQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2AbBktE0bbUdvy08BqH/+239OsWOckfU+QebGrpONQ=;
 b=oPxIidxIUx1BFXpTXUitjLVDf1XKUgy/MgQt/FxgU9vQbmc2ttlDbaM80pYsI1JAVP8lNQsF/lo+/E646HsCAVB7bdmNq2+yZbDL+yRlo2kd2RqvLlJupUhLL6myyzFzuX1z3xld0S+pXYB1rJXXn0seYG+UP0vQG3YDlAFYJtNhTsFR9bHNUJ7UfKm6O9WKB18Z9PuqVm+ZrWk+10WK8v4d85Ul9ThHWn3/sBdPN2NdyUJ1QotjrWw4sntVnFcVIEIed3XvfWyHABTQCJlWkUwb1JxKF00CnHrNv1WasHEdCYcuin+kCq5nztqtP2gy7sAd3tGoQbbbRLip9VkVnQ==
Received: from MW4PR04CA0315.namprd04.prod.outlook.com (2603:10b6:303:82::20)
 by PH0PR12MB8031.namprd12.prod.outlook.com (2603:10b6:510:28e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 17:21:53 +0000
Received: from CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::10) by MW4PR04CA0315.outlook.office365.com
 (2603:10b6:303:82::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.25 via Frontend
 Transport; Mon, 13 Mar 2023 17:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT076.mail.protection.outlook.com (10.13.174.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24 via Frontend Transport; Mon, 13 Mar 2023 17:21:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 13 Mar 2023
 10:21:44 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 13 Mar 2023 10:21:41 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Amit Cohen <amcohen@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: [PATCH net v2] mlxsw: spectrum: Fix incorrect parsing depth after reload
Date:   Mon, 13 Mar 2023 18:21:24 +0100
Message-ID: <9c35e1b3e6c1d8f319a2449d14e2b86373f3b3ba.1678727526.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT076:EE_|PH0PR12MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: fd61d19f-fcd1-4bab-c063-08db23e77043
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vO7/krFjeqd/qzSmSeJtCFOkWqHq/rqFECD+jMcUjvpyl8AjFS0U9jUX+7pwP/jn+ySyEkKC4Lri02Py5rfZtpxttf2yp6ba7r+zf6F8OKYLg69tohALEUuMF5aY2T2an+fGmVvLSuiLC3rvYOmpPtFDTFMMJRXkm50QEuFfPBc4Gr4C2udbaHDjcJflpOulnF58ViAABjAyR1gPOF0r4/DvPlpofi9P/tzOcrjoLDoLUV0rzC2JDf1HRitXOiNei9n/pX+PQ7sbtVYWmB6i/jgiiRMNKVB6+n47Uvp+Y0tTbtVbullayrw0oNz6r5RDX1ulMseOSWJlXqoEIsr3uO4NIqY7K6qlS3varddc6rJX9uWvyZ3zyP8s2yePhCsnWvkONCQh+tAnNQr2HnHbo9OqdjvQclov9WY450Xlf2LbtTzCFrjs4wOrCcF3ouiSyEWDmrvCV9wuf+IT3cuL3hFHqVFWVjSeDQRUDhlSbM6bBUcZ3oQskGBPK/I/GQ7CvO6AhzTfAT3FIwlaZXFm4tubsgI4b5iKQaa9w01HQqjMsGDWrpEpRvy9YqtmuFXq48mu7R/0z9Kz6wXBR41dPOP0nuvgI7RVTJ1XMCBkwZfBtHKafWNbIfEWxaJLUPLnPfrccXpWoCDfdeTi2UVwh2c6ZqW/qXLPXUMLwxnhxkVQloesheIcOkfgho02UM4LoUgDCLYilVbjOywqzzkiukaISeBhu7tTT3jtmMtzAfX9Bhf6FVfZLckK6mn74EiD
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(110136005)(54906003)(41300700001)(478600001)(8676002)(4326008)(8936002)(70586007)(70206006)(36756003)(82310400005)(356005)(86362001)(40480700001)(82740400003)(36860700001)(7636003)(26005)(7696005)(6666004)(107886003)(186003)(16526019)(5660300002)(2906002)(66574015)(316002)(83380400001)(336012)(47076005)(426003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 17:21:53.0025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd61d19f-fcd1-4bab-c063-08db23e77043
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8031
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Spectrum ASICs have a configurable limit on how deep into the packet
they parse. By default, the limit is 96 bytes.

There are several cases where this parsing depth is not enough and there
is a need to increase it. For example, timestamping of PTP packets and a
FIB multipath hash policy that requires hashing on inner fields. The
driver therefore maintains a reference count that reflects the number of
consumers that require an increased parsing depth.

During reload_down() the parsing depth reference count does not
necessarily drop to zero, but the parsing depth itself is restored to
the default during reload_up() when the firmware is reset. It is
therefore possible to end up in situations where the driver thinks that
the parsing depth was increased (reference count is non-zero), when it
is not.

Fix by making sure that all the consumers that increase the parsing
depth reference count also decrease it during reload_down().
Specifically, make sure that when the routing code is de-initialized it
drops the reference count if it was increased because of a FIB multipath
hash policy that requires hashing on inner fields.

Add a warning if the reference count is not zero after the driver was
de-initialized and explicitly reset it to zero during initialization for
good measures.

Fixes: 2d91f0803b84 ("mlxsw: spectrum: Add infrastructure for parsing configuration")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    * Change routing code to drop the reference during de-init.

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a8f94b7544ee..02a327744a61 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2937,6 +2937,7 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 
 static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 {
+	refcount_set(&mlxsw_sp->parsing.parsing_depth_ref, 0);
 	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_DEFAULT_PARSING_DEPTH;
 	mlxsw_sp->parsing.vxlan_udp_dport = MLXSW_SP_DEFAULT_VXLAN_UDP_DPORT;
 	mutex_init(&mlxsw_sp->parsing.lock);
@@ -2945,6 +2946,7 @@ static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 static void mlxsw_sp_parsing_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	mutex_destroy(&mlxsw_sp->parsing.lock);
+	WARN_ON_ONCE(refcount_read(&mlxsw_sp->parsing.parsing_depth_ref));
 }
 
 struct mlxsw_sp_ipv6_addr_node {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 09e32778b012..4a73e2fe95ef 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10381,11 +10381,23 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 					      old_inc_parsing_depth);
 	return err;
 }
+
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	bool old_inc_parsing_depth = mlxsw_sp->router->inc_parsing_depth;
+
+	mlxsw_sp_mp_hash_parsing_depth_adjust(mlxsw_sp, old_inc_parsing_depth,
+					      false);
+}
 #else
 static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 {
 	return 0;
 }
+
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+}
 #endif
 
 static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
@@ -10615,6 +10627,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_register_inetaddr_notifier:
 	mlxsw_core_flush_owq();
 err_dscp_init:
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
@@ -10655,6 +10668,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mlxsw_core_flush_owq();
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_lb_rif_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
-- 
2.39.0

