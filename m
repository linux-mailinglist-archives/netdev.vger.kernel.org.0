Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C36583158
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243114AbiG0R7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiG0R7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2F25727B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZlbS9Asq3maVFZFeU/gkmzXmYbalDynF1MQVO3RcS0ZCUiNHEMlg51ek5wWV0b3YJUrE69Rx9RrotjXlfeL2JCYPJH1KtV3Ez36fYTTcIadSsV+2ymnOphbN3oBvgYIzp/4lgexBH/SkFOuJ7htKqqxeaZBZZaU0aboGLMh4vrXZCxlvX25qZavkjSmkPhA6DUUF233t2Rdf8L/e1mj/MRDUjhc/Dbwdsq2EEtvfMPRG166oevfmVZB1JOcPOlKzkDIXS0gU8ZYdCEyH+jp5k7xlHnzGSMIg7HakTmn3H0UO96CikeaXqYGQJSgw58BeJduadoJ0vg4Hh7tCC9Alw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yeJXMKcBMdpNzAokRg7vvsmikx3Qbya8C1mc6KG0ea8=;
 b=MvnxOAHkPXT9aacVpL8mME7B3sW4h3LivtEw47GB4FMrqIU4zoejRvdNOcEH+WLoA1ZxZiUTxD3QD2JKJhy5DkWw2Ghn0d/eTeuz5bL8lpcY5/Bw8Zmt6CmcVuM2Png5PpbMXQ3ejt8v//XunzoMMIZyyFgk4dVhNoRD7Yyqm8e/yh2nvP2KswKvEg/O6RAjSJQQ6tr8R8+p4PXxJPEanWNIrI5yF9yCDV6cpaObb25l99gtNpkMxYO25+nQqkyT0zTdJkKr8FBO4nB/kb4N6bxOPcbz7uzOMckSGOIm8LhYoAGti1SOJmwf+6+9D5bPzYgHOywLQR/hFIlLi4SGtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeJXMKcBMdpNzAokRg7vvsmikx3Qbya8C1mc6KG0ea8=;
 b=YdpAGyg+52US8I47qHHcuobzYnxAaWTibvmBy9ntiXlJl6+EqvHM9wkJFkS2vOidar1Hxtr9geRTiVZAq3oPDwXhTuLTl3bVqhAqMbaW7SfzKVnEKbhJvWE/yZI/T/6m7E0rYWI40bCfWMn6Za62RDWoLJcEu/XsGkpayW2DxwqLmARvWYHpZTnvVq+pmSvLFm7BOrLHl+q27l+9rVwUV/YM4yOgDPHHoprwbRk7C9apP9aAYUK4MW8O7NGeQzP1A1eiJKTbnXimrbYPLFHLkNqihQkFxxAOjfb9M/Ip9iDlaBd7cuduqAHIiy/alc10Y0OjgMEV7KdlcQtDJPDDJQ==
Received: from MW4PR03CA0317.namprd03.prod.outlook.com (2603:10b6:303:dd::22)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 17:04:08 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::fa) by MW4PR03CA0317.outlook.office365.com
 (2603:10b6:303:dd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:06 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:04 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/9] net: devlink: remove region snapshot ID tracking dependency on devlink->lock
Date:   Wed, 27 Jul 2022 20:03:28 +0300
Message-ID: <1658941416-74393-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff9e80a3-5719-44cb-7315-08da6ff204e3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4189:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SI9fhcp13OTZYqRmXveaO99SvPMWeAWBP1+ETugRx3YwyidaFqD2qos26MU4qzO7csj/lVkywqVGrwhNqjk5nu9s9Mu2Ik3hfaW4XLrhZ98G36vBj6KDADR7DyCR3nCGAqaixirRHU4S+lUvfFa1SUUNGKJZGtKmMBfo/swenu/bhcTpLA15I42VqEHFW0m/x+u29PHX+TbgfqkqZ+xXA3bKyrf7dXUu4RH+CcANRG6352OcSE2dzLLolFDf96TSqGGUtduOYBkmxH77n23dUfChLHSTjQnotbOLbAURVdmc0YrgNeT9Dk2bcPh+IiBv+PVyrjdMGNFNIjULpD1SqKoBYSvujJXBSuVEJ6PNmAb+mYlDMdDVmbDYUz18GPLBiHmTfiuOTjuKa0ofIbpcNrk6LLeng+QxHwrvrg2cagpwwzJwFfcB4n2aZWcLKsf/4Pq61ojuBpmL8DBN3RpUrxbdJdPOmuOWCA2SE6oJGcdXUgPmJ0wf4F4MxGtFSziumqHbDjnOUeIk1EivYHmeKW356kQuO6bxJJ/0nYAf4WSZlJLsdEKq/uM6rRxO+Ymcy0FTEKp7GxRrTouThuPhS03xGMEkrPMpweXAAYtd5dJx2paOp7WIPs8MhZmnbwTjDRplHgF4Cpipt8oXUyi3wM6cEzWqF0sgM7I/vLU1RA7r7eVZKKaR4icP0YNnOK86jUurIpxR3NirlOV39kuI3/0GbiOZ0yXiqgMDcE7OarK02J2fog9yjvX1VZYC+g8jIgPazpT0UAQl/3BcQ+2BTPQQY73MxKl3uM6pcpf52pxVakYdZJy5gO0utPYf6REVrerXclrc5+WwXZlfnQKHA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(40470700004)(7696005)(478600001)(316002)(110136005)(54906003)(86362001)(40460700003)(2906002)(41300700001)(36756003)(6666004)(8936002)(5660300002)(26005)(2616005)(336012)(356005)(40480700001)(426003)(81166007)(47076005)(186003)(8676002)(4326008)(36860700001)(82740400003)(82310400005)(70206006)(83380400001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:08.0036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff9e80a3-5719-44cb-7315-08da6ff204e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

After mlx4 driver is converted to do locked reload, functions to get/put
regions snapshot ID may be called from both locked and unlocked context.

So resolve this by removing dependency on devlink->lock for region
snapshot ID tracking by using internal xa_lock() to maintain
shapshot_ids xa_array consistency.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 64 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 698b2d6e0ec7..da002791e300 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5691,21 +5691,28 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
 {
 	unsigned long count;
 	void *p;
+	int err;
 
-	devl_assert_locked(devlink);
-
+	xa_lock(&devlink->snapshot_ids);
 	p = xa_load(&devlink->snapshot_ids, id);
-	if (WARN_ON(!p))
-		return -EINVAL;
+	if (WARN_ON(!p)) {
+		err = -EINVAL;
+		goto unlock;
+	}
 
-	if (WARN_ON(!xa_is_value(p)))
-		return -EINVAL;
+	if (WARN_ON(!xa_is_value(p))) {
+		err = -EINVAL;
+		goto unlock;
+	}
 
 	count = xa_to_value(p);
 	count++;
 
-	return xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
-			       GFP_KERNEL));
+	err = xa_err(__xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
+				GFP_KERNEL));
+unlock:
+	xa_unlock(&devlink->snapshot_ids);
+	return err;
 }
 
 /**
@@ -5728,25 +5735,26 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
 	unsigned long count;
 	void *p;
 
-	devl_assert_locked(devlink);
-
+	xa_lock(&devlink->snapshot_ids);
 	p = xa_load(&devlink->snapshot_ids, id);
 	if (WARN_ON(!p))
-		return;
+		goto unlock;
 
 	if (WARN_ON(!xa_is_value(p)))
-		return;
+		goto unlock;
 
 	count = xa_to_value(p);
 
 	if (count > 1) {
 		count--;
-		xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
-			 GFP_KERNEL);
+		__xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
+			   GFP_KERNEL);
 	} else {
 		/* If this was the last user, we can erase this id */
-		xa_erase(&devlink->snapshot_ids, id);
+		__xa_erase(&devlink->snapshot_ids, id);
 	}
+unlock:
+	xa_unlock(&devlink->snapshot_ids);
 }
 
 /**
@@ -5767,13 +5775,17 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
  */
 static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
-	devl_assert_locked(devlink);
+	int err;
 
-	if (xa_load(&devlink->snapshot_ids, id))
+	xa_lock(&devlink->snapshot_ids);
+	if (xa_load(&devlink->snapshot_ids, id)) {
+		xa_unlock(&devlink->snapshot_ids);
 		return -EEXIST;
-
-	return xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
-			       GFP_KERNEL));
+	}
+	err = xa_err(__xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
+				GFP_KERNEL));
+	xa_unlock(&devlink->snapshot_ids);
+	return err;
 }
 
 /**
@@ -5794,8 +5806,6 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	devl_assert_locked(devlink);
-
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
 }
@@ -11227,13 +11237,7 @@ EXPORT_SYMBOL_GPL(devlink_region_destroy);
  */
 int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	int err;
-
-	devl_lock(devlink);
-	err = __devlink_region_snapshot_id_get(devlink, id);
-	devl_unlock(devlink);
-
-	return err;
+	return __devlink_region_snapshot_id_get(devlink, id);
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
 
@@ -11249,9 +11253,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  */
 void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id)
 {
-	devl_lock(devlink);
 	__devlink_snapshot_id_decrement(devlink, id);
-	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_put);
 
-- 
2.18.2

