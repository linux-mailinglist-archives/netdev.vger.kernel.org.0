Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD72912BFB5
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 00:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfL1Xr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 18:47:56 -0500
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:20832
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfL1Xrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 18:47:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+ZHnzsTE2bbIFsyXe6Cp4lBLZbX5J2GEsXjx00LWkhytizNllIDDqDENtVsA1ONKZPmUDnLpqG3E4FWt0VgmCVcQ5VVeoyI5NGK+drgeKJqecx0kdEwFTfor59v0pl6VP1cV3UYZnwBBvJz1aMAZFKLEfe3FG2wGXeOq+WsWrYQTd9SaxDOB68mjQUMx+XWEkz+6S0rggzE9COgfbNXDFLDvJLSK97BdZgan4dUeA/l1NVRLkwgJhHIKRVxNMUJhGKYB73j388pz/n6nF/+4Q/QPDhHsaUof/4xXizu8sak3Wnfb7Z39WoIc+eWbB1AMAzxOoeUge4HcgfUm5xOoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE+TeZ8HsTtCfcVx3oCCeYc6rM2U7eATcut/H80QDiY=;
 b=OT5eIGp/BqB976FJm7MEcC/9l+HWPuTDhk7qtSZ4P6fuKScq4r+ZQk36iF0Seg1UPBFVstHlWumPCBjNvPDVN/y9ktZimfGpOJL4vVrFJKsMwy9rPApME1HKIta+dgTDR31qsTZmrJk9ldyeyPK3jXrTPKTzju3asODTZ9WKUdpULJ2kVY+wyNSY7QD24LDxBQCPTMJV1UzazE85fitScxFrZVoEJ9Z6B+d+IOeKMWuAp1Nr8jzMekJhKseVl0nD9boyBGvsZYHITx3N8LYnAzFO0c4KMmbuZ31YzIkVLO0Ou947hMPPao8Dmpypah2xl/11B96gvuEJRyGXCGQlUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FE+TeZ8HsTtCfcVx3oCCeYc6rM2U7eATcut/H80QDiY=;
 b=aC6bsKc6ZwUho6KHAyLPMpihXpIVSszZaMAO7IfxI4Hk5up0e3ckycqY8njuK5ElcifFRCvYZ95SI4fqRdye2rYG/a626EWPe+TKyB+JGSUYcVxTNEDE9ygSsOj+DenZOjAPtBSeXNXbZhBVG45NMqRAwHLp0h5RLrSydlrTnJE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0727.namprd21.prod.outlook.com (10.167.110.39) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.1; Sat, 28 Dec 2019 23:47:18 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Sat, 28 Dec 2019
 23:47:18 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 2/3] Drivers: hv: vmbus: Add dev_num to sysfs
Date:   Sat, 28 Dec 2019 15:46:32 -0800
Message-Id: <1577576793-113222-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
References: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0022.namprd12.prod.outlook.com
 (2603:10b6:301:4a::32) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1201CA0022.namprd12.prod.outlook.com (2603:10b6:301:4a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sat, 28 Dec 2019 23:47:17 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91939a02-401a-46ff-3619-08d78bf04611
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0727:|DM5PR2101MB0727:|DM5PR2101MB0727:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB07273A9DF6D37B5198A370E9AC250@DM5PR2101MB0727.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 02652BD10A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(6666004)(478600001)(81156014)(10290500003)(6506007)(8936002)(4326008)(2616005)(36756003)(316002)(81166006)(52116002)(26005)(956004)(8676002)(2906002)(5660300002)(66556008)(186003)(66476007)(66946007)(16526019)(6512007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0727;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqRq1odeKpXEjBam5qaJz0SUNAE0g7HqhFd7x87CixNNIxZo1P5E+9UT2+5wem3PPGZVjQonDJnivwaIIgxkAU9D/1Lgv7AWx/3E84cGpcU0QiOiFge8c/xhM9K1PBO02KfRjGCVDy4wjOTsAiSa1rXJxT66lWBNHlLxzpkcMfxrWYuvTMlZNxMOisB4f+fYe23Zjjf3nNxe9kBqv9/rOlpXg03Mmhxs2yCfCbRJpyUgIVlcA4UL2xUxfjmNr2MLl3IGoJjnGej+Wak9U4RUFg7tBNaDvIwDemHn3dvt2+cWARMHzTpkAuP45R5L6tSsx+sRa+P6W35jVBtgAV5vprknPG1XxOqAw+ltFgDHBeV3foCD5m50t396xO/oi0SJPbZQxzRRLiPoairKCUZHJgtOxnhLLuFx2noz0YIpssyDIDqI4qaRDElFgrb8cCH4
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91939a02-401a-46ff-3619-08d78bf04611
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2019 23:47:18.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyiilgK/d0PieL3gyry15w+7mKPn0D8OqAMzC2oCSt85510h8y5oB/00lRNqPIwdRvghqKaa180lAhYy+YJ5jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a number based on the vmbus device offer sequence.
Useful for device naming when using Async probing.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 Documentation/ABI/stable/sysfs-bus-vmbus |  8 ++++++++
 drivers/hv/vmbus_drv.c                   | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-bus-vmbus b/Documentation/ABI/stable/sysfs-bus-vmbus
index 8e8d167..a42225d 100644
--- a/Documentation/ABI/stable/sysfs-bus-vmbus
+++ b/Documentation/ABI/stable/sysfs-bus-vmbus
@@ -49,6 +49,14 @@ Contact:	Stephen Hemminger <sthemmin@microsoft.com>
 Description:	This NUMA node to which the VMBUS device is
 		attached, or -1 if the node is unknown.
 
+What:           /sys/bus/vmbus/devices/<UUID>/dev_num
+Date:		Dec 2019
+KernelVersion:	5.5
+Contact:	Haiyang Zhang <haiyangz@microsoft.com>
+Description:	A number based on the vmbus device offer sequence.
+		Useful for device naming when using Async probing.
+Users:		Debugging tools and userspace drivers
+
 What:		/sys/bus/vmbus/devices/<UUID>/channels/<N>
 Date:		September. 2017
 KernelVersion:	4.14
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4ef5a66..fe7aefa 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -214,6 +214,18 @@ static ssize_t numa_node_show(struct device *dev,
 static DEVICE_ATTR_RO(numa_node);
 #endif
 
+static ssize_t dev_num_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	if (!hv_dev->channel)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", hv_dev->channel->dev_num);
+}
+static DEVICE_ATTR_RO(dev_num);
+
 static ssize_t server_monitor_pending_show(struct device *dev,
 					   struct device_attribute *dev_attr,
 					   char *buf)
@@ -598,6 +610,7 @@ static ssize_t driver_override_show(struct device *dev,
 #ifdef CONFIG_NUMA
 	&dev_attr_numa_node.attr,
 #endif
+	&dev_attr_dev_num.attr,
 	&dev_attr_server_monitor_pending.attr,
 	&dev_attr_client_monitor_pending.attr,
 	&dev_attr_server_monitor_latency.attr,
-- 
1.8.3.1

