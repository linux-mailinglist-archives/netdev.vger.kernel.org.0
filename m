Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C93B11BFC3
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLKW0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:26:44 -0500
Received: from mail-bn8nam11on2092.outbound.protection.outlook.com ([40.107.236.92]:22112
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbfLKW0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 17:26:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYUgx8+tj2dw2OMDX3jYHY0GMkugw/X/jV2N1BjsSnIaEZ4HYClVBx/qJiyd+imwOqDIlO+yByAQnMSBg1O7Z0zDFKZqeDXS4glikNjo4PcEzf3Dd2eY1u4lHnKgXNmh0EhXYhuH/2QVrCnCq8u1dR46yRJlAW8Dy7pbQtE+DVncL4/nFsywGQpb+Z0DTmtNWHDWuckBYFh8oKpIQfvXGSBbd9IXjYuqgBZHRD7IHLE1Zz7nHoJ8agOfwfAbLltrmHMG3LGG0gs37OXKvpD0cCwEDQ228hSNxjEtm//E11aDZ5mrDzihJDW4yhosEcfamnITqwOvPpDvCDZo0Uhhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM2amkkYojjLcRzL9usR7m+QR9CHtChNKLPqy3C4kLs=;
 b=lG7+8KfJ3d2R/9pwsuerqeguEm8lkHdhD1M2Y4uPwWHkS9VcWhfnSr8SYPVCJP3j9IzG9oChgwBQDW/Kzet2rOhtLittgn7MQOMkVGkWQY4EzZoTLpsyYBU1NzA3C17kf3rXYZZprYk5XTKHZ2Qyldl7oNq8me3AQ+b6W/x6ERa+2m1iAx/hX8r5C7Lj31AV7Pw9mY/MP99iBni11Al1vfEM748wlqwMreew0xi0eflOHk8L4VZE4RWhSkJVCUixUuVP/1wO6BpOH09SVO0Cn2Eaon7FRoUBkpPVdQrQuplVmHDVUNVUVpHDCUs5Bdjf7miyqJshASLeCCbpDiEBNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM2amkkYojjLcRzL9usR7m+QR9CHtChNKLPqy3C4kLs=;
 b=S4xuxJNJv6TdYNxVrRAXkXVQjXBJVQtgRltKfKppK5DgA3GYapox7Cq8XRFUNFB3u/Jfm5TYXiBU9jCf/M8+kI+77e9ALSTaz5OUy2DW8MCZZhH/9/3NuNQroY2xgFO5Oe1QcfPJE0EIS/fdMBA56ImYqQ9WPFSgCvxMsuO/u6I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1128.namprd21.prod.outlook.com (52.132.133.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.2; Wed, 11 Dec 2019 22:26:39 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::38a4:3ae9:3c5d:9b3a]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::38a4:3ae9:3c5d:9b3a%8]) with mapi id 15.20.2538.000; Wed, 11 Dec 2019
 22:26:39 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2,net] hv_netvsc: Fix tx_table init in rndis_set_subchannel()
Date:   Wed, 11 Dec 2019 14:26:27 -0800
Message-Id: <1576103187-2681-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0096.namprd17.prod.outlook.com
 (2603:10b6:300:c2::34) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR17CA0096.namprd17.prod.outlook.com (2603:10b6:300:c2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 11 Dec 2019 22:26:38 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8ecffa3-134d-49ce-4a7d-08d77e8930fe
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1128:|DM5PR2101MB1128:|DM5PR2101MB1128:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB112846D670B0545E0A11E47FAC5A0@DM5PR2101MB1128.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 024847EE92
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(136003)(396003)(376002)(189003)(199004)(66476007)(66946007)(66556008)(10290500003)(2616005)(956004)(6666004)(478600001)(2906002)(316002)(36756003)(4326008)(8936002)(26005)(5660300002)(186003)(6486002)(6506007)(81166006)(81156014)(8676002)(6512007)(52116002)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1128;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sso8D02MJ+n0YkoVP+ugju+KKbR+uXfSnOqxTWZ4LKqjbQbrzeB4skOOeLyaAot45Sb/iw/IjyA5sQdRE90TLN0qGmgyCVqWlLWNPgBIgO+mEmcOeOJxX4zMZPzQH5BrbD63DxQ92vzTpSdsbpqcwcgzRjSPJl3QHA2WaWwXP57VZ5B8g2SIr7obiOeSLCgsbYGHZykhmghMJPJz+qv1rgCL3clz3ys/LLTUWJq0E/Vntsh5brmqk5UO1mctBo+nuyMDGwyDbVpyrjfL8DO/rDjSchEeyBF3X3F4YecCxkPH+uDX7F7D/dUzDveIKFA3bPWKp3FIP5wDYCihJPMSS8J6YnO/FWeBg1g4zCSsVq1j2jt8DrpjYbOXyKiSOihMqMrXJnV/HOX1jVotiEWIdlzh4XbbGgCHQQ7WBkiYSBVHo5iMBbfq+kSEZ8FDtexD
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ecffa3-134d-49ce-4a7d-08d77e8930fe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2019 22:26:39.5654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcdgJg5bXS+nxX+SoYo1YhL3AGQbcAMJ4H1H0ioCU/WkccWDK+MZjVSnHas0TnFb2+Ks7CnnwmEhMh/kZJPQow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1128
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

