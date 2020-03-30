Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCE2198475
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgC3TaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:30:12 -0400
Received: from mail-co1nam11on2135.outbound.protection.outlook.com ([40.107.220.135]:43542
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727406AbgC3TaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:30:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoMtF6WQETF5Mrwbl4pygRiYT4WIr2pD7Noo2CabBFn+VB3OFDuYUWULdxeHInPZg2zj1h5X4NoMXt4ILcpLoXyJQaVAp8NBXZ7rzvYgJmtShI4uMReIO5/kCrl/OF6+MFYgPHjecG5BjrPhVVZQLhlGVSQ/IIrcCRNlU+ptpx+5J7wQ5XVO4xx96+kgWqOtRYFIDQqMlDcaXyc6wELd9I0+D2HwsJQOAYhVGupS1p70qEepMXuy34/iqO5GGp1T6S4tV46t9eEJvacewy2O8+iSDbIyiu0zwy9MAStgwP9qgfPeWn7iaRTKbew8JICSHGVkiP3ZY8PvMHc11/vNyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hriD5hIRfgoUmX0FQgIvB07fZBG3wOMnzE4mh+zutVc=;
 b=W0ytmkuYjgvTj7NRZsjlMepnAq/EYS/M8NnPK63N8LKUpttpt+mVFB+MhAEoWv0LwZITqgFKUpQeCPzfvBqjgXt9U32Kqx/7N66VvviIbUmJGuT8A6JT1id+5iCJfvQXdtuw1rdEbHCkusenNAdspckDKdefiMQP2r3BzkuFf+mVAvSTbVzYr2WXBCGbYmc3gSw3LGH4R2Xb9xXcn/BuJIw1ymzHl4gcaYmotZx5VcBb1/EgfMatcpzs5NvdXpnqhIBhNXnjRTCB/mPRpjSO+vAVVZfjBiQ2fOa2Psf1JaE/4dAtdVPLm7ch/fhQnp7a5ukk4dSA2Yowh/u2wLDfHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hriD5hIRfgoUmX0FQgIvB07fZBG3wOMnzE4mh+zutVc=;
 b=HC9RXGvFnlRy4C00Oi5smtCRqr/ejdDpjGvJLzxWzM4m/2h+SXkUKbAFMCcuhyD6fHtCZDJz6fBfmViddFYi4+VIIHt2MGfxX6HueILVJf0WIaavoWDWh91rvGghAsPS1x5oH3PeLuyHvr1mdjzFiQGArBgpheP9lguRUM0nU+0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (2603:10b6:4:a7::30)
 by DM5PR2101MB0904.namprd21.prod.outlook.com (2603:10b6:4:a7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.4; Mon, 30 Mar
 2020 19:30:04 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6490:7025:f39:3fa8]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6490:7025:f39:3fa8%4]) with mapi id 15.20.2900.002; Mon, 30 Mar 2020
 19:30:04 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hv_netvsc: Remove unnecessary round_up for recv_completion_cnt
Date:   Mon, 30 Mar 2020 12:29:13 -0700
Message-Id: <1585596553-22721-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:300:6c::25) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR04CA0063.namprd04.prod.outlook.com (2603:10b6:300:6c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 19:30:03 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b383bd38-5282-40d3-dc68-08d7d4e0befb
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0904:|DM5PR2101MB0904:|DM5PR2101MB0904:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0904069834C526C4AE98C13CACCB0@DM5PR2101MB0904.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0901.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(6506007)(478600001)(26005)(2906002)(82960400001)(82950400001)(81156014)(6666004)(186003)(8676002)(36756003)(8936002)(16526019)(81166006)(5660300002)(956004)(2616005)(7846003)(10290500003)(66946007)(66476007)(66556008)(6512007)(4326008)(52116002)(316002)(6486002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hggQ1z7tOwBC6NSfUmJtCvVR7iAAkyoad86pBkCOmUsNyXBOcl+ht/qNEcnt92AoMeCkPPRMUQZZaCB8tn0+dwJ4mBsZCTcmh9GI5cuB5q5xShp6JdiFykLh/R3GWUeoN3NakALHWgSP7L5+EYOKMXlZLm3w3f/+KqI8RmPgZdUEhxb1mH01sA5C4ErM3b6kcqDo5Vk+YVSSlpAJzaXZZFLmOy1ckz/29d+cfy8MMUav6xa6CU+jDSeXs7+Ut3iFmJniAeQbMOmBm+5oNXqnZuXTUvQAIuxum08cnbjkBoTMtYtVe8+jRgSQPs1qEVxdomYlBExFN0nCvy1qBYCXG0qV8AR8XRp3IKwudLQDy2hNEY9vLQAAtgtm9jJaUNNfwpIERfEVjJmx3VIY33xVZVEK+q9ECccn/TYF+57os65ataCeBiTIEEHhTTB/6NDQ
X-MS-Exchange-AntiSpam-MessageData: wEWzR74PenT1I2ZLM8jqlovvDvWVipFO0lDfzNZk6eA9wpiq6ggpL4iHY/CFIDaS3uebiefab7C1GaLBnIbU7F/w9stXEY7lEkDiMrR6P7g62dbXzG9jnQsYwk9QbAiuYOG9xVqX3ZLOsm8n+odixQ==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b383bd38-5282-40d3-dc68-08d7d4e0befb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 19:30:04.2521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pt2kuZ7XE+iL9+D37FQID849UUWmy095mckzEmGAG3orNqTF4t0KzIZ5rhfrkyunuybtFXcALtupNWGwRDRs1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0904
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vzalloc_node(), already rounds the total size to whole pages, and
sizeof(u64) is smaller than sizeof(struct recv_comp_data). So
round_up of recv_completion_cnt is not necessary, and may cause extra
memory allocation.

To save memory, remove this unnecessary round_up for recv_completion_cnt.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1b320bc..ca68aa1 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -388,10 +388,11 @@ static int netvsc_init_buf(struct hv_device *device,
 	net_device->recv_section_size = resp->sections[0].sub_alloc_size;
 	net_device->recv_section_cnt = resp->sections[0].num_sub_allocs;
 
-	/* Setup receive completion ring */
-	net_device->recv_completion_cnt
-		= round_up(net_device->recv_section_cnt + 1,
-			   PAGE_SIZE / sizeof(u64));
+	/* Setup receive completion ring.
+	 * Add 1 to the recv_section_cnt because at least one entry in a
+	 * ring buffer has to be empty.
+	 */
+	net_device->recv_completion_cnt = net_device->recv_section_cnt + 1;
 	ret = netvsc_alloc_recv_comp_ring(net_device, 0);
 	if (ret)
 		goto cleanup;
-- 
1.8.3.1

