Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46012DC02
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfLaWOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:14:44 -0500
Received: from mail-bn7nam10on2098.outbound.protection.outlook.com ([40.107.92.98]:4448
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbfLaWOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:14:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSCDG+zqkEvicFyVdi3/fUWrI6jZ/b6vSWwTl2ylzGvFP1w1ATKIGlhNBiAVhKRuJCt/jRv315rm2vbXMEVkXP8Eh5mt4yQaPe3ctNt9RXCgSqeNseCqtjEn4ZlmjFnap9H7IuiwNUDPPrsAAC6iPy66+xWdKUgJSHOhDUvZyWe98uSGq20ROKelg4R9DRobbSk/PWDIg57b4O3juRU+RQjp3OQFNMFQTuefrMeCgiYYtC9yph+/tMTKayyfmARj+/tBMaULPjdnEQU+pwStfODzIrmFZ6MmrUq5iN6nf6MyrLsmp6RDEFaHmaV4+xbuVy5QF1OSepBE1DENDP0Opg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zEfZIFi5E1HysfK+fN7aq7LXjTJWPxt1PdRKNIFCfA=;
 b=Vkn+U0G9+ZuR1/7rRbaOlXyb+ZkoF9JvAi/i2cKeGYdNLRup7ldQcA1XWnzjCv961+6LThdJq6QjOj/7khuzCi9pqGncSb5soC3itAb6A3oasw9RSYqMDH1JWeGBHum3knXpzC3aEG1wiUnqVXUH4bhv2/yC5QseQbl3mIkovTIQ2jswstUfEf/f3lB3OE+qEhGMv5jenkkR1IVFUpHFBcGRNqSVJkUcvv7EfSj4uZMHFgt7d8Hi+wSQ+CQxiOqdnCEMy/NdYyK5U5JHeQGmTR8bVWO12qfXJZTRrbD+cV1lMz/4hDwQOaT6l08K2ahFNuSVNYWSBdB3e9cBatnIlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zEfZIFi5E1HysfK+fN7aq7LXjTJWPxt1PdRKNIFCfA=;
 b=J0C/zipMCZ9WQzM+sacsKOW6ZNTkNhjSnXqgbd4ckMgtUmFKPuhUYIQVS9utPmDNcMgLF7T6J41X16X5A+8cEDqD34U5ewHJrMFwODPIWrTmSUT8Bp0TEL2xXIUeuMMC2fHyZAGQTMTpHdv0rF65t7w4zHP8WGJkt/DzWQ4AuY4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1014.namprd21.prod.outlook.com (52.132.133.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 22:14:38 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Tue, 31 Dec 2019
 22:14:38 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 1/3] Drivers: hv: vmbus: Add a dev_num variable based on channel offer sequence
Date:   Tue, 31 Dec 2019 14:13:32 -0800
Message-Id: <1577830414-119508-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
References: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR17CA0086.namprd17.prod.outlook.com
 (2603:10b6:300:c2::24) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR17CA0086.namprd17.prod.outlook.com (2603:10b6:300:c2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Tue, 31 Dec 2019 22:14:37 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5386c0a-61b0-44f8-64ef-08d78e3ed378
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1014:|DM5PR2101MB1014:|DM5PR2101MB1014:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB10146F7E59045988B174BE6AAC260@DM5PR2101MB1014.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0268246AE7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(39860400002)(376002)(136003)(199004)(189003)(6512007)(4326008)(36756003)(6486002)(66556008)(66476007)(66946007)(10290500003)(6666004)(8676002)(16526019)(5660300002)(186003)(956004)(6506007)(8936002)(26005)(2906002)(2616005)(81156014)(478600001)(81166006)(52116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1014;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAY4FqP4abLX9aBS9Qvr2UdJJgI3JJGyCBPL3HPtcYHZiTYMa3HlyQfgAehhMrWN/Xbu/veX0tFrstiJVi54G+xTQC4BEyO9mnStM+OjKLfnlEkNquLqPvW89OBlZ51uB0L7KuygVaiGyJRUIXShdRorljqzlW1/Yirj5EIRnKXMPqDuEwrMS0rJESWXOr+elh3cBLqrHr6mqfoMXdh34Ql+uBNdkJFMRXmF4cG2RhsuExscSCjVXISiBE17vlKR6L7gKCTA6bjhNwzb7m7gWRgAAwXf/NoIcNvOha0QzIZWSUEZOGMiNslchnrwYt4amhfCAUszjPwWkyWQiNsPafp4C0bzlCodibIvDFCzuhHRb/KnE9rYYJjpgK5j/bShh+SqCUlgGiJGP1+VooVdy3VAqPZaxtOZLN9iAKJH3QZsZ6qHPiMkjSPDU7UBYjU2
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5386c0a-61b0-44f8-64ef-08d78e3ed378
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2019 22:14:38.5632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0MOAJ8ufnhexlLe7YKfZjvN4Gsm/eatcxDturTzcFkys2RkL7cBcFks3v5/yrPAFBESJAoimu6CXzeBXpVAwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This number is set to the first available number, starting from zero,
when a VMBus device’s primary channel is offered.
It will be used for stable naming when Async probing is used.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Changes
V3:
 Rename a local var, add code comments.

V2:
 Use nest loops in hv_set_devnum, instead of goto.
---
 drivers/hv/channel_mgmt.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/hyperv.h    |  6 ++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 8eb1675..68adfa1 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -315,6 +315,8 @@ static struct vmbus_channel *alloc_channel(void)
 	if (!channel)
 		return NULL;
 
+	channel->dev_num = HV_DEV_NUM_INVALID;
+
 	spin_lock_init(&channel->lock);
 	init_completion(&channel->rescind_event);
 
@@ -541,6 +543,44 @@ static void vmbus_add_channel_work(struct work_struct *work)
 }
 
 /*
+ * Get the first available device number of its type, then
+ * record it in the channel structure.
+ */
+static void hv_set_devnum(struct vmbus_channel *newchannel)
+{
+	struct vmbus_channel *channel;
+	int i = -1;
+	bool in_use;
+
+	BUG_ON(!mutex_is_locked(&vmbus_connection.channel_mutex));
+
+	/*
+	 * Iterate through each possible device number starting at zero.
+	 * If the device number is already in use for a device of this type,
+	 * try the next device number until finding one that is not in use.
+	 * This approach selects the smallest device number that is not in
+	 * use, and so reuses any numbers that are freed by devices that
+	 * have been removed.
+	 */
+	do {
+		i++;
+		in_use = false;
+
+		list_for_each_entry(channel, &vmbus_connection.chn_list,
+				    listentry) {
+			if (i == channel->dev_num &&
+			    guid_equal(&channel->offermsg.offer.if_type,
+				       &newchannel->offermsg.offer.if_type)) {
+				in_use = true;
+				break;
+			}
+		}
+	} while (in_use);
+
+	newchannel->dev_num = i;
+}
+
+/*
  * vmbus_process_offer - Process the offer by creating a channel/device
  * associated with this offer
  */
@@ -573,10 +613,12 @@ static void vmbus_process_offer(struct vmbus_channel *newchannel)
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

