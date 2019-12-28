Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012F612BFB2
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 00:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfL1Xr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 18:47:56 -0500
Received: from mail-dm6nam10on2120.outbound.protection.outlook.com ([40.107.93.120]:26849
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbfL1Xr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Dec 2019 18:47:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSrfLoB/RYLB7hJbdZoZ2ZVX/G2y2uet+KJaYgDl/bEaotIVOlSuhIOkLjHp6m73w4ei0T5KzBT/Nbx79YZNSfyDEyBgvcDWWR2y0km8L21+pm34YCB+YTO6PO02b4g2rGr+JbfZ630JBybXcjZnd6R2GBX24uo7Ucdxacc64nYMQynFoBxnZg7X6fCa4EVKBQPQyAobrQOz1X/JncCZicWvBgqLwZCimjN68HfQTg0h32d053W4NY8XOIz0gq7HkzJmMez1dAzE/PxgzlDB4QK+Yih4/VchBDD0AQRjbgPHpnLJm9nSysqlwAc/y9Xzf/bGaZgMC60PhOPn7yy0hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNxeZ934RWhaWtLTnsqBF7YuZDzqGpUSYuLAeeG/IAg=;
 b=TnDoaC7qtcx9TYwh0+6/AxGqZXpMDG2n2Kr0RT+pEXAv7JoBIYs1zOXEmYyIziDo6u0/u5wg6cho7p5tc8RtajkJoRlcFpN+e1WpQSwtHo62yHYxuE/JM493kmFpOC0y8rQ3eHdO/sbXmeCvRXDSwetwATO8Z2yti2XhFYDg2pdlfYA6uVJE2vg2ZpJYbun+HtV80188c/n0OhXRXDibjyUyJZLUTjR3wtTJkV+zEYVO5DEFSkjk7Xlvnm8EI+9QnKelSgbXXi8XdyKeY47a8ZqyD8jBdPfMDJWjjb9SE1cqVeziD580PT6wv4hmi75vs9pthvd6HnDh2lG5gA67Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xNxeZ934RWhaWtLTnsqBF7YuZDzqGpUSYuLAeeG/IAg=;
 b=Yba+Xz95h9nv+X+FjLDjxuF84k+WOl2EIvwBHmj5sTYlsS0vFhnVbI5/7nFe+Yje8CqHuw/+ng9nJ0WNdNEm2TymzGkklNtDzNXLNRvO/NtGL4Iu58FqbZIIha6Fjg2Lon7DfjN/w+7XmrkBSP3Adjh7rgX6zc1udI/v0IGlPbk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0727.namprd21.prod.outlook.com (10.167.110.39) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.1; Sat, 28 Dec 2019 23:47:14 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Sat, 28 Dec 2019
 23:47:14 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 1/3] Drivers: hv: vmbus: Add a dev_num variable based on channel offer sequence
Date:   Sat, 28 Dec 2019 15:46:31 -0800
Message-Id: <1577576793-113222-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
References: <1577576793-113222-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR1201CA0022.namprd12.prod.outlook.com
 (2603:10b6:301:4a::32) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1201CA0022.namprd12.prod.outlook.com (2603:10b6:301:4a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Sat, 28 Dec 2019 23:47:13 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 82af4c5e-45e4-4941-7f9d-08d78bf04374
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0727:|DM5PR2101MB0727:|DM5PR2101MB0727:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB07275A9EB22364E61AC0B195AC250@DM5PR2101MB0727.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-Forefront-PRVS: 02652BD10A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(6666004)(478600001)(81156014)(10290500003)(6506007)(8936002)(4326008)(2616005)(36756003)(316002)(81166006)(52116002)(26005)(956004)(8676002)(2906002)(5660300002)(66556008)(186003)(66476007)(66946007)(16526019)(6512007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0727;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yznTxQdfBERcB8e24RMggSO/BZN+G4cNXqFqQaqiBvg4c2mFMilSA8KYxByUImT6y+GPMPVkPiM0hOSK5Ww8Bm408L/HofTQDahBR4BZCMCGKyHKPBf1eLTIzvv4SKhOkE3zuOs1sW09j4R2onJeGauxfWiQXiCXnfgDRZesUExHCdHuJTEiJL9mN1COuhNI2IsmCcTHf7ewZ7zTJx2BipP5/Yy3OchPZ1bD9gteWg89Ss9bxp73rUjxcQbRqZwR0d0LDq5lE1Q6jKqod9ik4UUSynI4wBGWkZLNuAciopKwWqjd91KiMJBpPoSeBA76FwnZLvulPKzZ/VXBVRv+NR8JBbLmUd55fztap6MuRoykAFSoHMzkkVQL7oQClo9vouUwjuSqlWMrBECI6JtDPd6IT5chMryWqxkjMVV0iHQUlvdk2K8Q+vDe1RCcNav7
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82af4c5e-45e4-4941-7f9d-08d78bf04374
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2019 23:47:14.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jnw1P8G1TQWY4CdLFXmF9bv77rWCiy84n0cNBehIOuaygsHkYyWt7BgyamZrcheq8Iz5Ur4y2WGHJzcypmeZJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This number is set to the first available number, starting from zero,
when a vmbus device’s primary channel is offered.
It will be used for stable naming when Async probing is used.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c | 40 ++++++++++++++++++++++++++++++++++++++--
 include/linux/hyperv.h    |  6 ++++++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 8eb1675..b14c6a2 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -315,6 +315,8 @@ static struct vmbus_channel *alloc_channel(void)
 	if (!channel)
 		return NULL;
 
+	channel->dev_num = HV_DEV_NUM_INVALID;
+
 	spin_lock_init(&channel->lock);
 	init_completion(&channel->rescind_event);
 
@@ -541,6 +543,38 @@ static void vmbus_add_channel_work(struct work_struct *work)
 }
 
 /*
+ * Get the first available device number of its type, then
+ * record it in the channel structure.
+ */
+static void hv_set_devnum(struct vmbus_channel *newchannel)
+{
+	struct vmbus_channel *channel;
+	unsigned int i = 0;
+	bool found;
+
+	BUG_ON(!mutex_is_locked(&vmbus_connection.channel_mutex));
+
+next:
+	found = false;
+
+	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
+		if (i == channel->dev_num &&
+		    guid_equal(&channel->offermsg.offer.if_type,
+			       &newchannel->offermsg.offer.if_type)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (found) {
+		i++;
+		goto next;
+	}
+
+	newchannel->dev_num = i;
+}
+
+/*
  * vmbus_process_offer - Process the offer by creating a channel/device
  * associated with this offer
  */
@@ -573,10 +607,12 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
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

