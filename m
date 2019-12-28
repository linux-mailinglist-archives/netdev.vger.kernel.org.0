Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5266412BFB6
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 00:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfL1XsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 18:48:01 -0500
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:20832
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbfL1Xr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 18:47:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Prnfla+iVBnvNEtt2a3lsPwnNDRBj4jGRJB11TQ4FPFaFTgVaNfnnlOrs26MlDJIpR1pdQGpSFJdZ8DeoRrqeoskYV80zoYbWkOZ9IPwR5SToBTWLjCsrH6fJvpmUZCqNzQCeFcjDMj6Vypynm49cIl8qU2ceAFIn4rbAOHscBObRjfUkwmi6Dxd/Sab7jIDs4YXNtbg5DICybr+8I17HAWXt4/MFKhUALsg/5K/hyIE5BQZR374nPwPbTsKEYGFsYDM8zIuFUEcnGxjcBir3Cd9ZCCBekqgMWKeGwVVohLIJWV0AbPfyLu7p8Oyx0BJDnYwS6F5PbAsplUnAo/9Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC1OJtV9c+6pbcT1qAqDjwkX3KsbzOKvcHWvlDdV9Lo=;
 b=cSGHk2D8StxR1OYLuwsgCa46PexZP7sXafNx3QKrEoMgsuGmJhM4B4sHF2J0LOAD5/qGwnM07HDRgTFmB6++yCBc5mHCznvmTUtVWxJpUVoH7vMiD4cuFJsc9+a2dH7IXdJlHnzXTnfYCelZutLfyfUJW/2JEfSdNIRmzWQwedF2+hi8btK3+zpfBtSQ9O0eyIStGxO1yTbM9lAx25Zur2NlxTZHaNnqltZcpVHpZCjqZGoRsLYrK1sRruv5eIhjGhO30H/ysBA2KVP0zDLTjLPghnVQl2InJd1048p9cQfS/kCEQeB/Piun1Mkt4g6wZjuPBd0hf+cJzWnnhtW13g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC1OJtV9c+6pbcT1qAqDjwkX3KsbzOKvcHWvlDdV9Lo=;
 b=RoLH+d5gsQLY+SUqXOUwXZt0Fo/WblU5XFsnp9Fwm1wicyfMTpoekcluhZNWZhHrYUrdL0hJq2ufRTNmEclpPhh5Gj3n2Q4nFBwcrKulLLHgFi+SBdu3EivM+0JRahsaC5JmoGJrzwCPuerGhviyzS3nq3aiTcnI7zO5rsoWEfE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0727.namprd21.prod.outlook.com (10.167.110.39) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.1; Sat, 28 Dec 2019 23:47:20 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Sat, 28 Dec 2019
 23:47:20 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 3/3] hv_netvsc: Name NICs based on vmbus offer sequence and use async probe
Date:   Sat, 28 Dec 2019 15:46:33 -0800
Message-Id: <1577576793-113222-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
References: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0022.namprd12.prod.outlook.com
 (2603:10b6:301:4a::32) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1201CA0022.namprd12.prod.outlook.com (2603:10b6:301:4a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sat, 28 Dec 2019 23:47:19 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 993b18b2-1654-44e7-abe2-08d78bf04739
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0727:|DM5PR2101MB0727:|DM5PR2101MB0727:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0727E6F9310D17AB95CAD5E8AC250@DM5PR2101MB0727.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 02652BD10A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(6666004)(478600001)(81156014)(10290500003)(6506007)(8936002)(4326008)(2616005)(36756003)(316002)(81166006)(52116002)(26005)(956004)(8676002)(2906002)(5660300002)(66556008)(186003)(66476007)(66946007)(16526019)(6512007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0727;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S7+iRUM9cDwDaeFVyX6Y/16axMFsrqw2cdUqVJPwRE/MGMF4cHMtdT+OJ4WchU2a23t/Q1odZ7WAkl5SQQG/tLLcLC7svkp+gtw3nQMuOER+gMLZ59ioUDxrb/UlO6x3Ke0duCZcvo9VZ14LgRODEn33k9k5hYH1Hs9QQsO3S+Ag7jPP36Qw5BnTJvpoXVRUa1F0hOQPle1LFkpm7YtUouvJTGUlBxDBsP4EGI19fDgxfLh9yOBud200oWY+XsiFDRq5jvs1soREsb0BPdIs/QfPPt7a3DdX5KjWX0tEOq5FxTS0CltaufJRsQisSsPMye1qBBSV/gycu0ib6V0+tg+sw+2rSGreZCZZ0/DuxCHm8fQKFCiTHKi3m0+MKfEGXEEXAPNmbQQFApvg89BEYoIWbGDbHrTIUSGJho4qRBUjZUfW4F71/BBAwVJnP5ey
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993b18b2-1654-44e7-abe2-08d78bf04739
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2019 23:47:20.0877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ic/dY7y3VufFc9Jg/5Ew0tZzRaS8HmfPQHkC8cfona7VVLEKR7IViWcqlBc1SOFpcmxNR8BafUqs0ZO5/TWFww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0727
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

