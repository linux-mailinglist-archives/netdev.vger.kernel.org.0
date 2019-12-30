Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2A12D45A
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 21:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfL3UOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 15:14:35 -0500
Received: from mail-eopbgr680093.outbound.protection.outlook.com ([40.107.68.93]:56482
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfL3UOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 15:14:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+YKAGtfj5P/fKDv39udaZG1uHhHCaMaq8X0pphUfxaKYcu8qDdPSmrwG74s5oyf58Midh7T/E0tFePpAs019mf0lLUcssbI5C3KWmXf0iUyRbKU6wrDAD5XQbrt5tc4MYPLJnJzAhQ/HmxKJu1K6m12c8CraPtfL5iFTJih8kNK9w9GIV+FuD2CtX/dQvewQZm7m7A/0yEsGk3qzv5AcvjhmzmRXtd14+0fapHJJBxctMLnveCWegp+wxyiowohKmq8DAS2piQrc7cCA35y6uwJm2GUgIYez5BXJ/EiqJ2QArg/6dP0voFREjZ7txPIYxex5Lx4eTLRMaJkud575w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xcV1VUH/R2r1nO5EGIlEovl+3pTTd7nojlHr+vd+VA=;
 b=UVN+FxaB0YG13CkFnRjPIKdo2ka8jx3J58deGduNND6W9EXmsV0Ag/+uAztUaRnt2rv4Jz+I6ceRwU7irj6gc9cVzMH3hc1p9Ql3u009masjwKk8oBe4PyWS7seuwgTZZtl0D8JgfBkH5juDR134NzTj76alRRGkxFc+s9O75qXMH1ec/D/rxN6tuiWySiS54enngfVuUyRTgQmpUTsp6zlUsMW4U3DacYtPd+p1KQ1jPUAcVGXKluVahaU9Q7ldYBhhsWYYWoES0ddsI9iTnrIQyDM/MgLHNT62QEyRPUFbVxCbxo2YFuLlC6pKbLTXe52z5wHcmnlrEZGNWjxZMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xcV1VUH/R2r1nO5EGIlEovl+3pTTd7nojlHr+vd+VA=;
 b=RVwMQBwNw1FViZ1PNIDlwbcx5ZOs6veciW+ysfNFELbA8hgAHNKoYurwxgWWJ4JnCs1idBDeoihdFecTUjWl8EB1J4eB5CiTotdsQCnuc7T9DEDV/IIMsKRdCJUqjVlpC7NZwwV4g28I3ZVcVkhhYW3QEEx62Nm2/sRG5FhBpQA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0936.namprd21.prod.outlook.com (52.132.131.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.8; Mon, 30 Dec 2019 20:14:19 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Mon, 30 Dec 2019
 20:14:19 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num variable based on channel offer sequence
Date:   Mon, 30 Dec 2019 12:13:32 -0800
Message-Id: <1577736814-21112-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34)
 To DM5PR2101MB0901.namprd21.prod.outlook.com (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Mon, 30 Dec 2019 20:14:18 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fd4264d6-6864-41f3-b7d5-08d78d64da0c
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0936:|DM5PR2101MB0936:|DM5PR2101MB0936:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB09361C37407FEE039C7DE83AAC270@DM5PR2101MB0936.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-Forefront-PRVS: 0267E514F9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(5660300002)(52116002)(6506007)(66556008)(186003)(2616005)(956004)(6666004)(16526019)(26005)(66946007)(66476007)(478600001)(2906002)(10290500003)(8936002)(36756003)(316002)(6512007)(8676002)(6486002)(4326008)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0936;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ve95T7ylK+hMPlLtW4YFvNjQzOfE7mY2mssXSl6oC0HHqs3w2hwRJpoFzC4e3B7hJEVuD3rzxaUDy+ntRUIyLjOuDHopSeRGtbxEYtvkFxuZZdx2KeSZPWKmajJG6rCzSSEwqbUl6cE7LQUha5dLgXzPpRaRmo2vA2EKPqTWur2t70IvwjI+Tu9FURGzd1Xv1tEZUTZrD1Zpo/9Bh4pP/K7OcgqdUm6Q2ZE4jzDcJQ24UFpFnqbh4cUpBcXsQm8BLUZWtZnheTb9JowpgE3aaPQXh/wuaqEo1emXYm3D5yGAJtlN2IkH3FxvPnwkmBogF/mP+TZwORhfFH2mIjC0kiwGSwkfyC5kven8RMc4kb6V+9I7eUUSDN2a0PMfwX86F9mRbfWVAtPBE0J2LN5Ag8fx/S84EgJ4VPufDVrsnwsYzK5pygvOHApvDfHPnkIO
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4264d6-6864-41f3-b7d5-08d78d64da0c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2019 20:14:19.2346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwdV2oENwypMpsfNA01CjZ86K1oCTfflJXxed+/Mn/t34MGmMm403J+g1ypumCU0B3o/eZTbD7vVMyyMmQebwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0936
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This number is set to the first available number, starting from zero,
when a vmbus device’s primary channel is offered.
It will be used for stable naming when Async probing is used.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Changes
V2:
	Use nest loops in hv_set_devnum, instead of goto.

 drivers/hv/channel_mgmt.c | 38 ++++++++++++++++++++++++++++++++++++--
 include/linux/hyperv.h    |  6 ++++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 8eb1675..00fa2db 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -315,6 +315,8 @@ static struct vmbus_channel *alloc_channel(void)
 	if (!channel)
 		return NULL;
 
+	channel->dev_num = HV_DEV_NUM_INVALID;
+
 	spin_lock_init(&channel->lock);
 	init_completion(&channel->rescind_event);
 
@@ -541,6 +543,36 @@ static void vmbus_add_channel_work(struct work_struct *work)
 }
 
 /*
+ * Get the first available device number of its type, then
+ * record it in the channel structure.
+ */
+static void hv_set_devnum(struct vmbus_channel *newchannel)
+{
+	struct vmbus_channel *channel;
+	int i = -1;
+	bool found;
+
+	BUG_ON(!mutex_is_locked(&vmbus_connection.channel_mutex));
+
+	do {
+		i++;
+		found = false;
+
+		list_for_each_entry(channel, &vmbus_connection.chn_list,
+				    listentry) {
+			if (i == channel->dev_num &&
+			    guid_equal(&channel->offermsg.offer.if_type,
+				       &newchannel->offermsg.offer.if_type)) {
+				found = true;
+				break;
+			}
+		}
+	} while (found);
+
+	newchannel->dev_num = i;
+}
+
+/*
  * vmbus_process_offer - Process the offer by creating a channel/device
  * associated with this offer
  */
@@ -573,10 +605,12 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
 		}
 	}
 
-	if (fnew)
+	if (fnew) {
+		hv_set_devnum(newchannel);
+
 		list_add_tail(&newchannel->listentry,
 			      &vmbus_connection.chn_list);
-	else {
+	} else {
 		/*
 		 * Check to see if this is a valid sub-channel.
 		 */
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 26f3aee..4f110c5 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -718,6 +718,8 @@ struct vmbus_device {
 	bool perf_device;
 };
 
+#define HV_DEV_NUM_INVALID (-1)
+
 struct vmbus_channel {
 	struct list_head listentry;
 
@@ -849,6 +851,10 @@ struct vmbus_channel {
 	 */
 	struct vmbus_channel *primary_channel;
 	/*
+	 * Used for device naming based on channel offer sequence.
+	 */
+	int dev_num;
+	/*
 	 * Support per-channel state for use by vmbus drivers.
 	 */
 	void *per_channel_state;
-- 
1.8.3.1

