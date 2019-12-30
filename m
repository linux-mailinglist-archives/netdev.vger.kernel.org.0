Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 829BC12D45C
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 21:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfL3UOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 15:14:44 -0500
Received: from mail-eopbgr680093.outbound.protection.outlook.com ([40.107.68.93]:56482
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727752AbfL3UOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 15:14:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTikffz4l/RHwZMvEzPqwmdkO252Jph/EzRFztspp12yxAig7l5I+qVZ6q56BAypM7u1XOf/1IgbnpSywWEYm8dtiaNWmcR2xno6FF3fzd/6eKYbRLDY3GWkul9CJQBQgnXdn8Wfd9ZASwYSLhqpZx333FHYMXlfdPRQV+YL0tQXyYXDXSRpoOrBIc540neXRz3TVEBPr/sXpzHQWAXDHfriHfEp9JEGM2X1qx+5vg14LoYI774U07pd0QCg+VC/3d4OFCNlzFq7ZZcEngf9vZXgYahscOy1466OCspGJyWlGCFHE9GSZGScqfrLKraO1rrEm27Qf0f6qSJjxrcJDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC1OJtV9c+6pbcT1qAqDjwkX3KsbzOKvcHWvlDdV9Lo=;
 b=l+bTp3WQuttqvP/3AK6ND9NStTEKBwWLiBCFwPnVc5xmtG2PH5sj/6bwJQ/htSkUm2xSaqaJwySIYZ9LF80/RJxgLPXbUc0S5tiHNqfb4bpFNSWVy0hH6D0DBYw7Vty5ScfXo5/+msmEXy7thou1KmvGlG9ilFC7uVcfe9rmaxADM2N2LcVQJNc3KHodlKrRQ4BjieqIUSwAukQenhI8Hcm5rnPzHjgFsvuDdXaHXLclR4zWqEWpJESolGmqkejW1cerNtMd+bXWJsnfYWk4NjiAnLpeIJ3E60FIYFFUJOXbKZUaGD2mVkZ+HBbs4L1Hkcu047GQ4sVs1k1khCgV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC1OJtV9c+6pbcT1qAqDjwkX3KsbzOKvcHWvlDdV9Lo=;
 b=IO3XBgWmrZB3VWjyrcE+MWHGlqjPJ45x4JlnNFMXkVj1yM4IinvMji57phcMLMhAjdf1icqg33rsR4R6MfFLJPW6ADewhnbgcZXt8JEexiQhvxU2hG/D2ZtDQrGNRJhmDerWH9LD7jLczVyEMDPUrR6lHMD5R2c9WIgzACmkkao=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0936.namprd21.prod.outlook.com (52.132.131.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.8; Mon, 30 Dec 2019 20:14:24 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Mon, 30 Dec 2019
 20:14:24 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus offer sequence and use async probe
Date:   Mon, 30 Dec 2019 12:13:34 -0800
Message-Id: <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34)
 To DM5PR2101MB0901.namprd21.prod.outlook.com (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Mon, 30 Dec 2019 20:14:23 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10d6b2df-24cd-4a6f-7be6-08d78d64dd02
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0936:|DM5PR2101MB0936:|DM5PR2101MB0936:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0936EFCA4E469D469818AB80AC270@DM5PR2101MB0936.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0267E514F9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(5660300002)(52116002)(6506007)(66556008)(186003)(2616005)(956004)(6666004)(16526019)(26005)(66946007)(66476007)(478600001)(2906002)(10290500003)(8936002)(36756003)(316002)(6512007)(8676002)(6486002)(4326008)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0936;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AyFyOlzU1rgYfvWYyCs+BxBzNFRxTl+3c30xXeR8XxgBDmzKpuhiAFIQDlrFQnAJMEgFamUOBLmrxK+esZopGYPzjPVcewA0h0Sz2gCLFQZE1xaI+8vFDO3FNaCp9HpcRnsqzI0jTolIe6WywhBKqQZDKM0HO/IcJOmRtunGNn2HVKxg4fQuN106rQLaT0El3zEYhvrXR8lUcmIuEdxWbAiepu/6NBEce0pk2FdN7nMagiIa2P0QW67ofcRd6UBgl7vvQGX3mGQ0nm8jnTdZcd8s+pENz5lfBaEabUtKCbqIf+nU5Eud/KGQRS4jJZvSTg5jYfwj+4BvG81nS27N3oZIj6uSScqPV+YqNeVaZLx8L70gLycQgNUKBVfk3I3WkyaQqkixEAVSR5ZSAbS8zk+LVzkTkHNPZ94Vo2MxicoLMIVPnD6L5I/4caygDE+F
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d6b2df-24cd-4a6f-7be6-08d78d64dd02
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2019 20:14:24.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnnSS/9BuyQjEo5AJJklOo2REP6TK5Rn+oFgSAUqUWyUoqC2A4KCESXXlrazOwSSrITXYP4QK8nqj+cc/aaYew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0936
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_num field in vmbus channel structure is assigned to the first
available number when the channel is offered. So netvsc driver uses it
for NIC naming based on channel offer sequence. Now re-enable the async
probing mode for faster probing.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f3f9eb8..39c412f 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *dev,
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info *device_info = NULL;
 	struct netvsc_device *nvdev;
+	char name[IFNAMSIZ];
 	int ret = -ENOMEM;
 
-	net = alloc_etherdev_mq(sizeof(struct net_device_context),
-				VRSS_CHANNEL_MAX);
+	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);
+	net = alloc_netdev_mqs(sizeof(struct net_device_context), name,
+			       NET_NAME_ENUM, ether_setup,
+			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
+
 	if (!net)
 		goto no_net;
 
@@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *dev,
 		net->max_mtu = ETH_DATA_LEN;
 
 	ret = register_netdevice(net);
+
+	if (ret == -EEXIST) {
+		pr_info("NIC name %s exists, request another name.\n",
+			net->name);
+		strlcpy(net->name, "eth%d", IFNAMSIZ);
+		ret = register_netdevice(net);
+	}
+
 	if (ret != 0) {
 		pr_err("Unable to register netdev.\n");
 		goto register_failed;
@@ -2496,7 +2508,7 @@ static int netvsc_resume(struct hv_device *dev)
 	.suspend = netvsc_suspend,
 	.resume = netvsc_resume,
 	.driver = {
-		.probe_type = PROBE_FORCE_SYNCHRONOUS,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
-- 
1.8.3.1

