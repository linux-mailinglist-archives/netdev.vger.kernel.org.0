Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4733D5843A0
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiG1Py3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiG1Py1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828726BD44
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rsm2ZE3Ui8fY/UzhXHTZUdQn4tTVB7kONd1hj/ql4/6T8o68XGraHTgJfhauET8d76HyKE5WIDvYD01GBa8bvLEW+czixj/Gt+oi6z4hfeWgX7Q/lRFusFHOqUrjQ5znhS2WJakS9JQ5twaMsmTLxB0uSH6yuvaUK9gRPDUzwRRLUhpRqySrEkU2C8Sr1vxDS4Np2sM69n3LLMJHHueeUnXWHi5lYNP4EeFDwHIef0MSAyJIA7o0BCQmpVz6ogb+oTIqtRJX5Qa8Abi3tiI/EKdRi8Qgk6WbgLnlDLzof+LuMbFYDbr2pIAH461av50PdCKB3LcC59hLPbst6TQsSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Yo9z+sDwfXNadmkr8cfPA7+7a1diRD8S3rqm+RrixY=;
 b=M4dTbqK8kSI1X7WS/Ba0Dtoth2F3CNR8cu1cTB0UsKACr87DXEnZ1jOy6oJhSqL8J8wkSQCkojutMG9iwU/PfGlmW1KDID7p2i1zdwdODIBx7iU0FVA0YHd3pLSLd5e2M/Y2RGaJCJx2pqoYQEXoK2GLeywwbmV1Q0/VU8WxYBHh8w7rPa2jf/jk3RaHNguhNXmv4HtFguzS1HPYyjdagGFzozZ7GjpO9x/ybt5luZibOsg/wC6SDw1RLLWDpUmvlbHJeZS2+9Q3G8WzNlCNWRmDvDvcW2bgdzlDjZjsCk24SL7tFxridEJQCty7uSGJVG2HcAwdKiW0wi3m0DN6JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Yo9z+sDwfXNadmkr8cfPA7+7a1diRD8S3rqm+RrixY=;
 b=CBV2O4DA36KLykppFgwFmAsJiDXLlveKkioy9AcOIsyiqvbZUwwRLopWJGWtDVHITDl54ZrwffGCsCgZuuI+40PkH1pjKQndFIhUit0a3ysWksb4QqgOR37GhvPdpDALMld1aFk+0uESqlpyzUDp1Y4rF3SpaUyWkM8Z2UTdmQt+8za1ct/Ui/8TAZMQCwNOunq7+xUcjNFKgcO9sUtiT71l9SjEXwGABAW844XAPYJEbFENYCuaJi0b8otSJnVA66d3c0DFqxOudkga1g/nIOH5QpxzvBC0s81k/UwNRP9s8H1FSu0A4KJnTJP2vbj8/nj0DkzqoIX+BDtHtJmezA==
Received: from DM6PR08CA0003.namprd08.prod.outlook.com (2603:10b6:5:80::16) by
 SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.6; Thu, 28 Jul 2022 15:54:24 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::81) by DM6PR08CA0003.outlook.office365.com
 (2603:10b6:5:80::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:23 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:21 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next v2 1/9] net: devlink: remove region snapshot ID tracking dependency on devlink->lock
Date:   Thu, 28 Jul 2022 18:53:42 +0300
Message-ID: <1659023630-32006-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 167c0023-0e06-4a62-1a32-08da70b171aa
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IN2ZXLXhIbWdzchb7yXzQz3tiUwJTtWbQb64DrmYV+61XXdwckRJ9eTROpVBt00ufJLcP954Mczh7bdKknPuL0fjb2J4G/gV5PHmUBoJgdamt8sLFbuDz0TuP5VspvQIoM61dAOxVv15TrLg3FIawzfZzPanYzEz6v0QgUwgTsGWn9lKUgQV/SkqQ8i6JG5uHVA/nSVuoICth0oxYuRmS60eDPv/CjtL9+e43k5HKFX9Lhjsm9WS7+Sy+2EfIlvvP0drpmXnWfXkA+ZTrIEdp2OgrekudHvTdTAWhKgmu0VvbJqKADspy6a/DgmHNw2+McsGw6iqAbH/BfegSpXGeRHXPh5P3WwU0nGRyIL4ijgTX54Rm4RLxE5lSjtQPOHh3MRTxS4Aj3qkVAGwGNqNO5e7cZgUlZLUBJWd4Q3oLmozrKiTq97Q7ASVb1Ncvvvfjrt+aPomWRKx2f+mEQ0C0GzsrwtNRqujlYUXtbLXkeJz95yD/wUIvO4KZ2HJ7A1ko/Trvgp4UHD+1GkxnAxrAMoz88JJfi8fOIH/kZZI3uoSGhkMHP9NPyiwusCdOwdQAMB5s2Mh8bB9BnvllFboyLQizJnWYunX7z3oSILgZwjH5lArFkFrpXoARgkpsTDlVYzrNV9pmKGZ5fh4dlph0twnvIPGW+siB6OHKLb7Lux74Z0dDQdoF0EJmn3q2YG2JDHyV+e6F5MsPYhQfFUYzH6NTDCFUneENIdW8L/KpegUg777f1QDm3J9XOplPhaSoTzQsUp5TSxYfqVAHzlVrIKAw2il1yuUsCcRqedT1XzyRK+Xlu2JBHFCjLZsVVMMyx/R+84u315kE7IuJaP14Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(36840700001)(40470700004)(46966006)(83380400001)(426003)(81166007)(8936002)(2906002)(5660300002)(82740400003)(47076005)(336012)(356005)(36860700001)(186003)(41300700001)(7696005)(478600001)(26005)(54906003)(36756003)(316002)(6666004)(2616005)(110136005)(4326008)(86362001)(70206006)(70586007)(8676002)(40460700003)(82310400005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:24.3748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 167c0023-0e06-4a62-1a32-08da70b171aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
v1->v2:
- changed GFP_KERNEL to GFP_ATOMIC in __xa_store() calls
---
 net/core/devlink.c | 64 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ca4c9939d569..64d150516e45 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5690,21 +5690,28 @@ static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
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
+				GFP_ATOMIC));
+unlock:
+	xa_unlock(&devlink->snapshot_ids);
+	return err;
 }
 
 /**
@@ -5727,25 +5734,26 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
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
+			   GFP_ATOMIC);
 	} else {
 		/* If this was the last user, we can erase this id */
-		xa_erase(&devlink->snapshot_ids, id);
+		__xa_erase(&devlink->snapshot_ids, id);
 	}
+unlock:
+	xa_unlock(&devlink->snapshot_ids);
 }
 
 /**
@@ -5766,13 +5774,17 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
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
+				GFP_ATOMIC));
+	xa_unlock(&devlink->snapshot_ids);
+	return err;
 }
 
 /**
@@ -5793,8 +5805,6 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  */
 static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
-	devl_assert_locked(devlink);
-
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
 }
@@ -11226,13 +11236,7 @@ EXPORT_SYMBOL_GPL(devlink_region_destroy);
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
 
@@ -11248,9 +11252,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
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

