Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64086B7B4A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjCMO6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjCMO6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:58:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D466515E4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:57:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq2qnJbNazXwVfluWjH2/QIu1tI0I9RFWJrXHoQBkmhPzIYw9DHgUWamiQIeUQEnXKGUAigTQx9jXROtvxr87132yFqPtaykF0oUElgWzEBI2nNuTVD/sgJhiO+BWcB0yUhZL1S8Xk67hOrRXeXMh6D8HCUf/zmPNl6iMVMih52PLVZhQISG/SvsaX1PeAk/t+60VKIiNNIwxRqp+WYcrSv3UE0Sly10TL+TlBQqQFB5QfRsQGWVmrBzCWnni3XBYmg1uC2/bU20Kko55a3mjauvG+d+aoIByhb5bBcRUHyveCdU3fsoJABbG4ktkoYksRy2OKqZdLBCA33PNjXVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wF8W4pgPuMSWR22hb9sXprLpuXg9ANFWlvD59qDGA14=;
 b=NyK0HtwlQ+65XMdlWNMB1Hx14M0kHku6wWDf3q2V9MWTo/N/Xl4+gAdBnpIJ4dgzP2/HtJ9/Wm8mmAbhxYDrE30sQDZGPae9J6cnGZLu7wOH7KuQCtxb+CXGNEjt8ieAxS9+LYDzvByBhYgbJFFsXAdcWPH1ZldNDhQoVkyparpD7o5Be5v78C59IbaQGUWDejoTqkYXaNC1jt9jHp816WC+muvuM+4fEiLZSMr8H+FOxaZwVxgPTRDrELEQnyVKhRAsCplUC2hXfr7hXG5NuTMvRLgocNapXZHidawWzJuAIE7h7uP0716gRGXB3MYzF5xmbDncHUg+slN6FSLKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wF8W4pgPuMSWR22hb9sXprLpuXg9ANFWlvD59qDGA14=;
 b=TCSeWC8b5ev+pdLMYqzbD5y3hEgtnfCTPECtx98CZ2qQuak9DSUN+n9xVwR4OOn+fTUZwTqAsBj60Zm8MyA9v2V++AQ8pr2zG46ccxvmACa9cMw/HbqD1QtGQzUzE+EosvRINhY54nb359LT5ZTQ79i8lSxgJzB9ih0UzxzyetgHxI/gQZUXXbZSw1XyUiBMUeoXAmk7D80blHIOVonybIuKa19Xflt3Dt5daTVdW7PmZ52GfibB03ch4iCZGVuUR+/OBQUW5HERH8JV3QwTkBpk+4+nXLbA+MNB+3+OUnuWVkzM3yJ2mJNOX6+dSFYV3JF1P+Z16LDrswG7vezLew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:56:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:56:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/11] vxlan: mdb: Add an internal flag to indicate MDB usage
Date:   Mon, 13 Mar 2023 16:53:46 +0200
Message-Id: <20230313145349.3557231-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0203.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: eb6dc7c1-8fc1-4537-4344-08db23d31086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3ttdgtbERuRD3YljrMMALdcWc1pItwLkrhq6U5pY9zpwDgJm07w5mbl/gqmQU6Gy3r23lL9jCTKnZTbb8ASx1HayRNCVtKbrIjoS6m/cJjBf/9fir2wtxZWKu4HyT7T4I9H0VPOdiv24oE8d7HqvV6gDhrYYeE1MNzE1HxSgoBG2lCce+FxerZbetwgpMTAr5BHepE0wkzNBsyde3osOTIx+NW4zoaMXut8qdejuhzG9GH90aMihdIivpz/o+J90VIInFDyNOSQ2FIymEmG3xYChZlzxVrfyiTn6RzI6HBg/+NOaW6ZDDhUez50UVZlF1poOR0XMqNEX13ovxc0dkGEJ1i232Ys0xGYIGVBdx7E49yeokqjk66fz2+PcPSrYlJ3SLjPuCur286RyZm4fZUyO/uaUA52uCwQGzgYXgJC1BDfRVpgAXkNSEt7y5Yw3J3xmfbChbget0JZC5hKgraQwqPcDM+9z18fGmiYC8SD7fsZZF2DvcQnMoPzaZRt8hwFP2pSBm6FHlvNnkUMDXN09RT9SSPXH17nNsXqLg6W0M7gCRLp+qjjLaZXygzYE0WSWBnFKJqeE6XU3xkn2L0+wHaQtBjv4n59nuuWqcBoHWbdCo8l1PIBMFkxrASFpPmY1RT0G45pS5yr2+cgiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(26005)(6506007)(6666004)(107886003)(6512007)(1076003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gPtvdzW+7c4GCbGWBI67H1Y+w2PVpYDRLoT1M71CbTumKngVLIUcty7mFvbq?=
 =?us-ascii?Q?lTBLFH1V/p3JoFwg8L5UdTcXk+/uosoBkSJ81xq9Tt78nZQy9AnirFUJsktv?=
 =?us-ascii?Q?E6/zpmuaWCgGRHBJpdG840qw4/xLTvp6nQp9P1mhhyaU3I1XDoSa5RYaMBLI?=
 =?us-ascii?Q?+/9LH2iGpCj313WHCQGmr+2Y28jw/j4NRrH1Fj4JrmrFmGEM4ZHO50esdUZn?=
 =?us-ascii?Q?tmYy9uIPRXkRpQEyyuEjXtQhoyiS8OU3lCzCLDJn/fSAPYRfY6O/leD7Ggfl?=
 =?us-ascii?Q?8BIEODGQCYZtpXBpMxM2UDqXQWL5iB4rDDwI17uePaOz75HaGketX++pG9/h?=
 =?us-ascii?Q?wm9j9alg+etrRBKxz0vx+15h7073d1tuZO36X/Z7wJOH3BifYBfPtNCZuPEy?=
 =?us-ascii?Q?wKy0c1MxOs/4sMfcjvqMmWV7nHIjCnpT21xdj0eGvEoSOqJS+napy9ViPM5y?=
 =?us-ascii?Q?G6mcqMnynSLE7QFpwKR/HkC8x9OBAcglAQpvxko7Ki2sFDmyYX1nVO4Svttf?=
 =?us-ascii?Q?8oGEF+EZ2XNUWf5m15zJRDmDfRb66qgRDNUlc06PwRYPlDt4VhZAhtEOkJmS?=
 =?us-ascii?Q?0Ivl6icEhM57N9jSZg8KtqXNh1Scx5U1gumeXM2NtB/mJSabHJrvIsefeHR3?=
 =?us-ascii?Q?vzSR67oPykdjpeFCDr4ew1EAkuhxR3lio6VkYiPuumURSGYUis7YBfUnfGvn?=
 =?us-ascii?Q?He0ARNt51KTLNlzthrqT1CbnrHCkNXoSwSaY05frMGQxIXTzYR+VY+Jj46GK?=
 =?us-ascii?Q?WwlizUXqgSs9fuA3hfytY2C0/x5SNdonTZnSJCZaFHwOhfbaQvSyLdeaGsI2?=
 =?us-ascii?Q?XAg89Onu6bkCPGnX7GrianH1UpoLYsMYft11/iuXpKPZpWz/xN4zJ1Ja1PVt?=
 =?us-ascii?Q?S58YUKm67o/zTUXplP7GvHcj8HZCVG6NW3WsICcdQJ1nd1p48gpkOv2mgpo2?=
 =?us-ascii?Q?AcrIQ5kgCjsc/XZodabJ/0OnkERofJuMgzL27nhZJt4/ahhiESWq6nLHjJZA?=
 =?us-ascii?Q?ylqZnGX6VmfF2yrNw2VLkDoArinR+FcGkMhQEm/8MFK51jB2DnGmuHYdBppR?=
 =?us-ascii?Q?+pue+c8Om2dKlWsafTeAw57hlOLzxq3fg3eoViXExfa7pz0f7cACILtXVg8f?=
 =?us-ascii?Q?ND+Aw1kr7u1d8Vw7ujH1pPdplQqHU6eIhD43Orq51/uyYm1WfoAShucY4LDL?=
 =?us-ascii?Q?qizG9xewi5eDCRJjBhKiX63h72jMmDYlXs5qH5YyztbfWrDO742mcB6xXx8L?=
 =?us-ascii?Q?I3CDq0V5Yp8v7cTnddLm9tO43WUZugZX3n+JybZMvXtWdrH166xORP8bIN6f?=
 =?us-ascii?Q?7l9CVjGUmIvsxSkezcqvtjPzaw6lJC6kLHlOQfQZWNhrfdvni6sDJBAykCCY?=
 =?us-ascii?Q?qcZ0boPJoTJy4rEYNi8vYACAY5UWxx5jhuA7Yjbxk5O27pHQQp4XO51rmoJ+?=
 =?us-ascii?Q?Clz7XbANSr0yKZqaSO4iaQUZS299M5bRnMfaJmZmb5lzYCFAsRgE0e0z/AeB?=
 =?us-ascii?Q?JDnGRhhLrEaY0hVT0kY1ZyHyAiQwgiH5tABfairHQ+Xtij4dRt6SDJq23QTm?=
 =?us-ascii?Q?5q3VbSyuhxn1eWCJOx+tE4to7dneLRWOA5GaY4v4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6dc7c1-8fc1-4537-4344-08db23d31086
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:56:02.6612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Spt516VR/sLLMaDdKb3imfQlq4GOsQZCG1wTcxm9bxyC2XcVp55TcTtj7CZ3KaYFzkgdvsTYSKFisLZsDGJ4JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an internal flag to indicate whether MDB entries are configured or
not. Set the flag after installing the first MDB entry and clear it
before deleting the last one.

The flag will be consulted by the data path which will only perform an
MDB lookup if the flag is set, thereby keeping the MDB overhead to a
minimum when the MDB is not used.

Another option would have been to use a static key, but it is global and
not per-device, unlike the current approach.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_mdb.c | 7 +++++++
 include/net/vxlan.h           | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index 129692b3663f..b32b1fb4a74a 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1185,6 +1185,9 @@ vxlan_mdb_entry_get(struct vxlan_dev *vxlan,
 	if (err)
 		goto err_free_entry;
 
+	if (hlist_is_singular_node(&mdb_entry->mdb_node, &vxlan->mdb_list))
+		vxlan->cfg.flags |= VXLAN_F_MDB;
+
 	return mdb_entry;
 
 err_free_entry:
@@ -1199,6 +1202,9 @@ static void vxlan_mdb_entry_put(struct vxlan_dev *vxlan,
 	if (!list_empty(&mdb_entry->remotes))
 		return;
 
+	if (hlist_is_singular_node(&mdb_entry->mdb_node, &vxlan->mdb_list))
+		vxlan->cfg.flags &= ~VXLAN_F_MDB;
+
 	rhashtable_remove_fast(&vxlan->mdb_tbl, &mdb_entry->rhnode,
 			       vxlan_mdb_rht_params);
 	hlist_del(&mdb_entry->mdb_node);
@@ -1336,6 +1342,7 @@ int vxlan_mdb_init(struct vxlan_dev *vxlan)
 void vxlan_mdb_fini(struct vxlan_dev *vxlan)
 {
 	vxlan_mdb_entries_flush(vxlan);
+	WARN_ON_ONCE(vxlan->cfg.flags & VXLAN_F_MDB);
 	rhashtable_free_and_destroy(&vxlan->mdb_tbl, vxlan_mdb_check_empty,
 				    NULL);
 }
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 110b703d8978..b7b2e9abfb37 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -327,6 +327,7 @@ struct vxlan_dev {
 #define VXLAN_F_IPV6_LINKLOCAL		0x8000
 #define VXLAN_F_TTL_INHERIT		0x10000
 #define VXLAN_F_VNIFILTER               0x20000
+#define VXLAN_F_MDB			0x40000
 
 /* Flags that are used in the receive path. These flags must match in
  * order for a socket to be shareable
-- 
2.37.3

