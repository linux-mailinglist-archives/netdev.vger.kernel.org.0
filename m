Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2B25F3AF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgIGHO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:14:26 -0400
Received: from mail-bn8nam11on2139.outbound.protection.outlook.com ([40.107.236.139]:8459
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbgIGHOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 03:14:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZD+JzZNEfTpXDuYJFBjr470YiD3gOhmgE8i3VRG8kCqkY1Lq654QaGQXJWhGGakiogVOrWbIBRTkeWe4cQl9GhjsLq2BC1AjQGwjmalwDWplYBmXxVfI0PBJPxnOe3oqvHdlLdtl+1+lSmhQR0J7UHGxTfDXF70br+yZXx9J8XVCFVPJWSzlR7mWFPvCQxfAjRXqq1zzLhrG5C8Y5AGiiEe98wl11xZ320HzFve/wFRpHPNYMt41wDWsgJ/+opqLu+oad5V4FaVL8McHc7X13dNMVEsI7GXdGicUDSbmHQVtPnH7wxyU5acNwHcmJ3/FnVlEAKuMJorNkPh3sytLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSZLNfBgZWe76/H3T6c6mXm5E+7nHYNbGMk0Lk+uxRg=;
 b=AsuGjH4UzNryJFs9SkXAz1B4ZzM0nQ/6QlW9wALyoRYBF5KLgZMBTh1pqD7WGWN+EtkeQ1X3WL3aCcXmmloh5B3Wt+pfCYX9SgEcyvkapWlIaP06sTyKY2otrCsuIvtOcMXjL3PekL8t2TBoIjb/EYKQ5eJUZ9705r+7l3yrL0jsjyIh3lEvKcj3+NzDnyklerPzmgwmrFhKubRhRipnT8ncJAS8RE0HJIKbZQ1XzuXCYc3xAb5yjYJ7a1u7yq3bOmCS25Yeinhi0/SSLS1IarXjeNNThbo7WYbJt7oFfUt0rp2wbYQrbA5qgI9TZj6nVeJLhJxxIWF8nWe3/pd/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSZLNfBgZWe76/H3T6c6mXm5E+7nHYNbGMk0Lk+uxRg=;
 b=g5b8XWmULVhdps75SBCSyrZfq2fnd3X0GTWEyNYwJ4p7FGdsITbkvuhNiqgzubY7bdeN/I/GB/9lJkKylsCNe2bXfO6gCrcZokMyASSm8ez8wBv0hf00RdFHPKNAwNPglKLPktgmFezC/d2lp5Ct4anB3bmMwf3fYfixNP+zqUw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
Received: from BN6PR21MB0162.namprd21.prod.outlook.com (2603:10b6:404:94::8)
 by BN8PR21MB1169.namprd21.prod.outlook.com (2603:10b6:408:74::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.0; Mon, 7 Sep
 2020 07:14:03 +0000
Received: from BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::c189:fa0c:eb39:9b39]) by BN6PR21MB0162.namprd21.prod.outlook.com
 ([fe80::c189:fa0c:eb39:9b39%7]) with mapi id 15.20.3391.003; Mon, 7 Sep 2020
 07:14:03 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kuba@kernel.org, wei.liu@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        davem@davemloft.net, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com
Cc:     Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net v2] hv_netvsc: Fix hibernation for mlx5 VF driver
Date:   Mon,  7 Sep 2020 00:13:39 -0700
Message-Id: <20200907071339.35677-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:a:5db7:3438:9419:2cde]
X-ClientProxiedBy: MWHPR22CA0003.namprd22.prod.outlook.com
 (2603:10b6:300:ef::13) To BN6PR21MB0162.namprd21.prod.outlook.com
 (2603:10b6:404:94::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:a:5db7:3438:9419:2cde) by MWHPR22CA0003.namprd22.prod.outlook.com (2603:10b6:300:ef::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 7 Sep 2020 07:14:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a8a8f454-93eb-449c-236e-08d852fd995e
X-MS-TrafficTypeDiagnostic: BN8PR21MB1169:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB1169EFC63F0BF10A595114ACBF280@BN8PR21MB1169.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMeHfl5ifPG3ET5VXpMVNSVfPi/5aL1mRh1c9TGiU/BI+FvFe47WYZepBU+wM9wIzKwMT/f1FTz/GL/UlJU2ic1rhRwWR7X6RY2mdBjTeaiy4xjQ59KqfFtGbAr+8f23CGp1bhHX+t64zQhu4F9rsODZO0JS1dBIQfmy9n5fTL04EzP4rDQDUAPpZvsC8tm6zVxNFpawOUxhy3qSJtCylQsGxUACHMF1YPlo9ypiEYKvRWs4QfDJntdgK+YRpZFHwBV3ImjNuZle+je8tY8fUYMOcNS11JON3H1LUFDv02dAeFL2SDT/24SwTDUF8ihq3RBXetT5/VTQUc/h+rlzXZNViFiJ4wmS2EWR2Ex5hfXWZNJi68c8hRmqkW1D0XnzM4sojkvpnoyyp7e/Ra8psYBGuUcRgDwPHjPeH8SUAuA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0162.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(316002)(6486002)(2906002)(82950400001)(82960400001)(66476007)(66946007)(66556008)(8936002)(6666004)(86362001)(83380400001)(6636002)(7696005)(52116002)(107886003)(2616005)(36756003)(1076003)(4326008)(3450700001)(8676002)(478600001)(16526019)(186003)(10290500003)(5660300002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2lwB4Y4Ie6EoNyelrZ+UY1QXiXrl9uHtutwZyg5VK/Tcv/dAjQPviaBwu+Qxh+zzijEeth33LmSireX4r3yq273Bgho6EgIVm4rC/1nToRK4f0kdb5GujnqntWOYrzXyrDcqgtPEza3UFYTKzCcgSbxm1cT00aCPM2LIJwny4qVXzofRvwrxFgWxYMhaIGDUPq4pOncaDPAHFCzFNRHPpt/+RRYEIZhGZB9W59XwtOdsO3BCBJsq6D0wjgYUm3fjDyxvyRYmwT1L5/JRL+fof+QEhIGte2ckm6xGyc0Hw4bMbKZYOmQQlY1wFnJs9Qbfgte/JxoTbSsc3+4S3ydNyE6z5OOSz25YzDX7HAocJC08GQiSYNF6sh0mil9MzEhXU9zEpwhyknUE1qjIVzsBpdRhPmECQ734CCVnz7WLV/6/yten+4tn6k8ksUB7qk91ig46i65/BqASfMHWvtz4NUCG2wG8r3LPE0MV4KyRNSmBlqAJWTK5IDjVYdHZMypahfasF4Om+ITcl01snqVJm69QoV0vIX3c0GQ8LOv+2YnMSSdFx63eGXiSUfARFQ0ZbvO4U5TXZw7tkhyclRm51+04Y8ZqifwJwqvWq2qGppzqNeclZ/ZxOiKOzUgnvNltEUJOBrHHCPsB0ulL3V4/aLRVuMXQPsQ3FcrVKGFVO6t4nN+AlDwWoZnNh8TD/BSUDZqGF8n93FNyvGSizdyfYg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a8f454-93eb-449c-236e-08d852fd995e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR21MB0162.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 07:14:03.0240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btpWaN19hcYUapChm3JaHfh/kYEJMspMb0PIQw2nM06C5cjfgkF+Swk7bEvmCHJXLpcmY+Zg941weZWwXd1QtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5_suspend()/resume() keep the network interface, so during hibernation
netvsc_unregister_vf() and netvsc_register_vf() are not called, and hence
netvsc_resume() should call netvsc_vf_changed() to switch the data path
back to the VF after hibernation. Note: after we close and re-open the
vmbus channel of the netvsc NIC in netvsc_suspend() and netvsc_resume(),
the data path is implicitly switched to the netvsc NIC. Similarly,
netvsc_suspend() should not call netvsc_unregister_vf(), otherwise the VF
can no longer be used after hibernation.

For mlx4, since the VF network interafce is explicitly destroyed and
re-created during hibernation (see mlx4_suspend()/resume()), hv_netvsc
already explicitly switches the data path from and to the VF automatically
via netvsc_register_vf() and netvsc_unregister_vf(), so mlx4 doesn't need
this fix. Note: mlx4 can still work with the fix because in
netvsc_suspend()/resume() ndev_ctx->vf_netdev is NULL for mlx4.

Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2 (Thanks Jakub Kicinski <kuba@kernel.org>):
    Added coments in the changelog and the code about the implicit
data path switching to the netvsc when we close/re-open the vmbus
channels.
    Used reverse xmas order ordering in netvsc_remove().

 drivers/net/hyperv/netvsc_drv.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 64b0a74c1523..81c5c70b616a 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2587,8 +2587,8 @@ static int netvsc_remove(struct hv_device *dev)
 static int netvsc_suspend(struct hv_device *dev)
 {
 	struct net_device_context *ndev_ctx;
-	struct net_device *vf_netdev, *net;
 	struct netvsc_device *nvdev;
+	struct net_device *net;
 	int ret;
 
 	net = hv_get_drvdata(dev);
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
@@ -2635,6 +2632,15 @@ static int netvsc_resume(struct hv_device *dev)
 	netvsc_devinfo_put(device_info);
 	net_device_ctx->saved_netvsc_dev_info = NULL;
 
+	/* A NIC driver (e.g. mlx5) may keep the VF network interface across
+	 * hibernation, but here the data path is implicitly switched to the
+	 * netvsc NIC since the vmbus channel is closed and re-opened, so
+	 * netvsc_vf_changed() must be used to switch the data path to the VF.
+	 */
+	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
+	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
+		ret = -EINVAL;
+
 	rtnl_unlock();
 
 	return ret;
-- 
2.19.1

