Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2852325E51D
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 04:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgIECy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 22:54:27 -0400
Received: from mail-bn8nam12on2107.outbound.protection.outlook.com ([40.107.237.107]:19388
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbgIECyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 22:54:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao70oJTHMP6pEW14EDq6oZw3UQYkKi9VRDTuvJge8ZD+XPVMyUwmIm9k5JCikPqJEdBgOw2n1TM+fgRowQfFZ2TA+29Go+GBIQjtapdsliv8loACnfxCdQg3W16/pdJa5fDfLU+784MZE+UFITwXl0whxzC0KfMwBjJ6T3F39yN6frAR5AcNsv5/xso4+Ri/NTWdc/sT9R+qwzAOWxc73lyGfyqv4YAP3Fw+srsx53B320T4iHRxhNRlhExBaavwxEgBv3lrkDVYGwxLqfVzTG0D6j3E1hrEd+l/eBWsu9o9KQIXX+fnSnom+Ae3a2JVdnPVOG0BztETKT7s8ON7JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG1d/YMDVaNVC0/bqLlylkHjIgbwd6MF7eSISbeIL/s=;
 b=db/P9jzqtttM2yCikJpeB8CADsS0vn5hu5h+TNplgGJvQNBMFjw2ZRkc4n1OxmKSmThWDVoTaCBhrsZVRzc1a2kjyn6eJRgQqNRm1zoObFtnlaFeJLi8U6Jwlu/w1ndeacdqxGTea2UOwlZL5zMRWzAtcdr6w1h0Z/KVYpSIvXlXQ79Yn8YTElJREWZ+JV6yf3JgXjJ/nwKlPLpzwgOZ+yF2RZDsOU8w0Scl1+NtOgRvnMnSEhJRE98dGxOU73wVe9tQkGcIPBdL6yJCQkvglDq7sY1BcgeLIGN/twfdG5rtEsTYtorKk4PTr0MLMGqSbyxKxvqGBdtYBEnb+qDVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG1d/YMDVaNVC0/bqLlylkHjIgbwd6MF7eSISbeIL/s=;
 b=TJ4AVNUktic07yLuocD4iqV249hSgPetnybfOkpm7p2XX1t9ktQBvXqxNvqaOtI+kB2OzmxvG38ERuKPC0/AVTj+XKWLMAWD9P6gBWZAIgTMpU6BlNhFLWRA3/Mz1tO7KIfPkBS+3dc4JL4izFbBZGBU6yowFEW9Choq3qLs3qY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
Received: from BN6PR21MB0162.namprd21.prod.outlook.com (2603:10b6:404:94::8)
 by BN8PR21MB1155.namprd21.prod.outlook.com (2603:10b6:408:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.1; Sat, 5 Sep
 2020 02:54:22 +0000
Received: from BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::85e9:34fc:95a2:1260]) by BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::85e9:34fc:95a2:1260%14]) with mapi id 15.20.3370.014; Sat, 5 Sep 2020
 02:54:16 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     wei.liu@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, davem@davemloft.net,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com
Cc:     Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net] hv_netvsc: Fix hibernation for mlx5 VF driver
Date:   Fri,  4 Sep 2020 19:52:18 -0700
Message-Id: <20200905025218.45268-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:3:d8e4:275a:eb59:9dcf]
X-ClientProxiedBy: CO2PR04CA0086.namprd04.prod.outlook.com
 (2603:10b6:104:6::12) To BN6PR21MB0162.namprd21.prod.outlook.com
 (2603:10b6:404:94::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:3:d8e4:275a:eb59:9dcf) by CO2PR04CA0086.namprd04.prod.outlook.com (2603:10b6:104:6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Sat, 5 Sep 2020 02:54:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: afcee75d-3f0e-4b53-f102-08d85146fa2e
X-MS-TrafficTypeDiagnostic: BN8PR21MB1155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB1155A092AACE4F95B4FE2A16BF2A0@BN8PR21MB1155.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTJwtyfidOdekjVzNCx864iA156oZnFaNKLZcaYJSI49/90iWea5dk0hugzW2GBT7FFg03bXzY0vi1aOrxCaT4NuylyMgqKxPpv4B1ePvmkXQwuyxG2yNh9Dly29aHCu3ZO8lMOrs2FuULIinlHJEGtGK50EaymDJgREFUoHVIb2zG+cVE9L/ONEXTcRjAfsqtCT0/bRBPYIpV6RRG3058nrCLdVLGemfnsfPTexOyojCM8qqaIe+vVykJwErja/zmGDU/1d46cvxTxA+eDJ8EmTg2CDR4Y0yRW99NtVfix6/S+wj4g8IWib5Igzf5j8pUy1m75hbzIB1QP0+WBz3CKQUDIEkGy1E2XHd15aoppbXEUygUAgdk3hvL0XWLMM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0162.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(10290500003)(66476007)(7696005)(16526019)(107886003)(3450700001)(478600001)(6486002)(66946007)(5660300002)(4326008)(2906002)(1076003)(66556008)(86362001)(6636002)(82950400001)(82960400001)(2616005)(8676002)(83380400001)(8936002)(36756003)(186003)(52116002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: PaY20vFiXTZGzg0f01yJcwk9iZk0+tA6DW455zpKrM7B/asHJoOApGdZ4/KrokmgXA1sn2vdjN5BqfDjMDZTrRIw/mhiJKNwy/bjXie+011DGszcx6tanUV3UK9Guz2b2zv1feIr3jffXqGqCOnRn6ygDQN7XWNjpk3o0EEUMzmeTENo9Ef5g3crhL1O6THOwIQKhcDx4YKDucXAFwS0uO86mU06/lxrD0EE20hgP4UiXCSmvBQIRG0tCRyrJ8CpIez3REkxCpK7FaeGmBYeKUd/CebUBtv58Gu3LIbkChArNx4wNqLQgYWJAi9OMLtgbSB3UoQT4BVTneMUkUbSEtvK97xKRQga9mUv1btfYAq7VD0yD9XJ7dIqYhuxo1ZZePlfu+tsfcRODMj/0og6+A3tLz44Rz7C/UlvVks8sxZCi930r2mgHaTNRlFV4eK/lvC6Do5wva+CrkgecIE7AnECsjuemP+LuftKgLDMOtUWsJGEk/clq36VRKzndYuURsO7x35AlVsKMX9ysQHJRBGnb1DgGhS6QDkJjwSPdo5SiCSpnGRcmJ4vK/osJmK9S3pP4vVHeFfem68Gpz0kNFQIP2Lv69oDReA6/NODb+MrEweVpqhWY9sSGzoaG+tVxBFw+ACjC/qupUwfFqmTXKXcCD37ThMZ+Ybjbf5A/tvrsUAqEN9k83ZMnxm3eTg7Du7/zBvgEuXhHPp2kpxm+Q==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afcee75d-3f0e-4b53-f102-08d85146fa2e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR21MB0162.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2020 02:54:16.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WBZfZyYtdYrUTUZeyKwfeS2K1Sdc3GY84n0ZQU1mH5npb2V+xm7SnanQ0T1ozPBIgrxAQjLTUaHC/OmBe6Mcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5_suspend()/resume() keep the network interface, so during hibernation
netvsc_unregister_vf() and netvsc_register_vf() are not called, and hence
netvsc_resume() should call netvsc_vf_changed() to switch the data path
back to the VF after hibernation. Similarly, netvsc_suspend() should
not call netvsc_unregister_vf().

BTW, mlx4_suspend()/resume() are differnt in that they destroy and
re-create the network device, so netvsc_register_vf() and
netvsc_unregister_vf() are automatically called. Note: mlx4 can also work
with the changes here because in netvsc_suspend()/resume()
ndev_ctx->vf_netdev is NULL for mlx4.

Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 64b0a74c1523..f896059a9588 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2587,7 +2587,7 @@ static int netvsc_remove(struct hv_device *dev)
 static int netvsc_suspend(struct hv_device *dev)
 {
 	struct net_device_context *ndev_ctx;
-	struct net_device *vf_netdev, *net;
+	struct net_device *net;
 	struct netvsc_device *nvdev;
 	int ret;
 
@@ -2604,10 +2604,6 @@ static int netvsc_suspend(struct hv_device *dev)
 		goto out;
 	}
 
-	vf_netdev = rtnl_dereference(ndev_ctx->vf_netdev);
-	if (vf_netdev)
-		netvsc_unregister_vf(vf_netdev);
-
 	/* Save the current config info */
 	ndev_ctx->saved_netvsc_dev_info = netvsc_devinfo_get(nvdev);
 
@@ -2623,6 +2619,7 @@ static int netvsc_resume(struct hv_device *dev)
 	struct net_device *net = hv_get_drvdata(dev);
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info *device_info;
+	struct net_device *vf_netdev;
 	int ret;
 
 	rtnl_lock();
@@ -2635,6 +2632,10 @@ static int netvsc_resume(struct hv_device *dev)
 	netvsc_devinfo_put(device_info);
 	net_device_ctx->saved_netvsc_dev_info = NULL;
 
+	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
+	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
+		ret = -EINVAL;
+
 	rtnl_unlock();
 
 	return ret;
-- 
2.19.1

