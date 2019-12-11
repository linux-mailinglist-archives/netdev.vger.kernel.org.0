Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714F611BF8D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLKWAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:00:02 -0500
Received: from mail-eopbgr680096.outbound.protection.outlook.com ([40.107.68.96]:42730
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfLKWAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 17:00:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOhc4mpMw2qhlVaDFsjJhVRc9rhKgqq6aqye8BncSzO84MiAYo9CNPhmdvLeHSrq1D1ZC2Mn/vis0KMJOGY0JUP5lszTLulDM/C7w5jLzlvjJER97AZIaqsCbqz3QgUpI5s1JlCL6+9x76bpE/R+XyEVEBLeW6QZTjgDNFin2YZJjvyuXplaWkpyFNxKuyiA3RlzWfMiKo2ognBhusbfkDRBte+xPdpovG83Bzggryoy3IvStBYjXaHlB0urSZ2eGHkRNRrg+nHNYD9/62bym+vlaftQRe0bOe+x+289eYPN+Q8Wpk5fqdVpw6I54MJHh0Fvrn8MMFzfHez+QRZStA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM2amkkYojjLcRzL9usR7m+QR9CHtChNKLPqy3C4kLs=;
 b=aogYViKzTMKEfKpTkoWVmVNbHBsOEQlup235ggTh7ttPYgd93cRcAyV7MDFtWDPyWW8phhLwYjdzxbBbx0WG8W2XcdGIVBa9xqUUeSV4TjPwX5+toYFjOK4o30sIEbng+kmnGzKzCj/9QdjCMkq6YreDqww+RiknPiwok/YmBUXpVmPeIMODIbKFOCMA8cPS4IyrDEMO3Nh0JzI4C/xCzuSc1/P03qmAPUGpyU6QCoRDuTZSn99CqJvSAOpFh8OFQLcB7a5YvmmXyMu0PVezuUY9V/QfUTi4GtRsZJfzYUnvUdTpS/Vr1/wL1ZKb5o2zzm1qW5RXUiTdTWu43aV44A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM2amkkYojjLcRzL9usR7m+QR9CHtChNKLPqy3C4kLs=;
 b=E6vAcLEdJdZp9oLxRA7sCL28GsEf3wXB5jEizoInRvVNttZuIETuvSjPzPNiAHT0Bfv9IaylpPYQqjGlz1K9W1E4dIYkNG98SAU18G9I6l14It5K177KW1GY6vobHrPAQtJGwfR+O5EcEGlVVyx4LVrzxcFbvpdHADPgAhJsXq8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0869.namprd21.prod.outlook.com (10.167.110.162) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.2; Wed, 11 Dec 2019 21:59:56 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::38a4:3ae9:3c5d:9b3a]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::38a4:3ae9:3c5d:9b3a%8]) with mapi id 15.20.2538.000; Wed, 11 Dec 2019
 21:59:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix tx_table init in rndis_set_subchannel()
Date:   Wed, 11 Dec 2019 13:59:03 -0800
Message-Id: <1576101543-130334-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:300:16::23) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR13CA0013.namprd13.prod.outlook.com (2603:10b6:300:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.6 via Frontend Transport; Wed, 11 Dec 2019 21:59:54 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 86b44b87-3048-4c88-b722-08d77e8574ea
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0869:|DM5PR2101MB0869:|DM5PR2101MB0869:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0869293A92DC0C360F72DD14AC5A0@DM5PR2101MB0869.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 024847EE92
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(36756003)(8676002)(6486002)(10290500003)(4326008)(81156014)(81166006)(956004)(8936002)(478600001)(2616005)(186003)(16526019)(316002)(52116002)(6506007)(5660300002)(2906002)(6512007)(66946007)(66476007)(26005)(6666004)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0869;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /rCidJ4bvnc5rOWmkeQVXIW6rlbUBhvFSUU/m11Rkwz47ybLf++XtxQ5GnJow+28X+i4U8EQOXbkld0is8RGIshspqqNHR7pOlRCwORHIHIb03+aioG7+Euqf9hL1q94yHAi75EP5tMwYthJxNwpUy30DPBCStnwnVP22/9EHV1EuafYQi6j8C6FNEFet3ZfJu0Oxprzsz2+fDF62UF/6YC2xwPD+zhK+Oe4U9wE2akCXin/ZDN8Ie3wjPQ3HO7NeYxF2Ajrir2wOlTLxXeCp69El4cjWaHhbpcAXpHaFPkgwQBCs158BLuY4MP1zQlt++fpg3GWNs8w0JebvWZlJWf84Qzvq9cJC41lXZv2Tg1NbrfT8y/Ry1koc7uQxJlwFdpkqkh9h/hFzSssZDC3Kwhfk0zrEgvvUyEn8jM1qJCs1HDdZl7CYCaI3YuMJWpX
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b44b87-3048-4c88-b722-08d77e8574ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2019 21:59:55.7501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lt0HqoesmLNkd2VI7wMOJybLIARRb7D+XTsfdSTCr3cU6JIYNvvu6JQRgzeF489GHfB3LIu5stWNv3LfVVxSEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Host can provide send indirection table messages anytime after RSS is
enabled by calling rndis_filter_set_rss_param(). So the host provided
table values may be overwritten by the initialization in
rndis_set_subchannel().

To prevent this problem, move the tx_table initialization before calling
rndis_filter_set_rss_param().

Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after subchannels open")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 206b4e7..05bc5ec8 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1171,6 +1171,9 @@ int rndis_set_subchannel(struct net_device *ndev,
 	wait_event(nvdev->subchan_open,
 		   atomic_read(&nvdev->open_chn) == nvdev->num_chn);
 
+	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
+		ndev_ctx->tx_table[i] = i % nvdev->num_chn;
+
 	/* ignore failures from setting rss parameters, still have channels */
 	if (dev_info)
 		rndis_filter_set_rss_param(rdev, dev_info->rss_key);
@@ -1180,9 +1183,6 @@ int rndis_set_subchannel(struct net_device *ndev,
 	netif_set_real_num_tx_queues(ndev, nvdev->num_chn);
 	netif_set_real_num_rx_queues(ndev, nvdev->num_chn);
 
-	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
-		ndev_ctx->tx_table[i] = i % nvdev->num_chn;
-
 	return 0;
 }
 
-- 
1.8.3.1

