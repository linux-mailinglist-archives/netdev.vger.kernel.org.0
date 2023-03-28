Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C836F6CB593
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjC1ExQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjC1ExO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:53:14 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020027.outbound.protection.outlook.com [52.101.61.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4FF270F;
        Mon, 27 Mar 2023 21:53:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOUqCaJylJEWODm+hJdAy7Dw6RNtJX/ST/YVMDxgqquWOM9uPqXKUyzv+4RIjRVSlafRa4lZgZEMyh3TGlJwk2dIGU0pg3UuJY5ZHpIZVOLFrHA03OD+OMGDn3gUtT+q5RX7HXfMYFtMULT3LeaUjcy+sSPcwYer68DlZ0LuT+6ld0pBha7AePYSx6/h4dYxO6aZrxY8jYWdS2YNslXbSOs5M4SnJklK9dxlNr/5k5G/0fZnHfoFMZxH42WLwc35tVOi+Xh4scdlPENYs8WlOfZrplwS657RiNTKHzgowMWUnYchvQKZgznnMnSUBgQ5sKvgu+lapklcxYYwqAtvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1Tzxuc4aIWXApIxi/7jlVJrOCy5V7jrasIaKfenavk=;
 b=JIw0J7HHjKYEAV30MruAgMyOwU7LaXgPGZSGtkua8f54D32tGEltTBDs9QpVlq0ZdPDbI6k9OvnlfIMieyV8bmc7i2OM+4YnzhQM8iEjMP4dQnYAAFzJuzvyl9M76R44ijsas4JbrSSZGnF7x6hVytJ/SQmZM4bX7WXOJXll6ZaBLbzjB40BeAAvprvZYsZcaNjgxUa2iHN5C2UUNaQyzMe3jHN0F2vv0knrEpzrHs/9J91B3xsdu4OZgG8lssu5o4rKLzz4ME3L9D/YlrGeZs+xtYoezhvXXuv+vieihqTGNJVSAVMMaHQZNQ6RU0M6jOe8OszphhXHi/L0El9O4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1Tzxuc4aIWXApIxi/7jlVJrOCy5V7jrasIaKfenavk=;
 b=WJIwVyS1m1m70PAhZbPnjvKiA5Cof8S/Cra7e6n710GBTimRsovxxXIMxXYHs6uun+pQJJUxuQkGUsV2RcMN+3QsRPrxdx+edH/dTyEZF7vwZX2tluEIFO4161COzoBxZMXdVdmoG29mp5GHZvIHso+iolluJUoExwOGbxuPhuw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:53:06 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:53:06 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/6] PCI: hv: fix a race condition bug in hv_pci_query_relations()
Date:   Mon, 27 Mar 2023 21:51:17 -0700
Message-Id: <20230328045122.25850-2-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230328045122.25850-1-decui@microsoft.com>
References: <20230328045122.25850-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:303:8f::18) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|IA1PR21MB3402:EE_
X-MS-Office365-Filtering-Correlation-Id: 585f1308-72af-4103-5705-08db2f48522a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7s8m2mgO3EX639PEEmyYkogPz/Rp25q9yitkm7kK2AN6l8FRx+Hrc+4aeWM9DZxvAEKIeSDWud+oFoNiuog54PgZwxEVgAMYNewcKuSbHNZ97v5rHMDZwYJY5WihL0zQsDMNDyhpWDwf/FvQyCcqPAPmXaahrtmPW3Z1DVOIzlY+OmTfu26BINQlaetAuzURq83Tgfh101Cs/ihXTHlo06hNkzH7f8WVKJAMQQ533Y3aMsJSoADTNe7NshbZmVwQzEuUrcgmt/XoJr1GtK5It94xpqp2FPkkNMqxCUkFU/KkQ1zEYIXUYldey8flJNgecjN6jlT+AzPf73rHHaJBD3lmIKdVb8vr3KAYa19tHp58mdRnoH7c0sU48d+Q91PP2zrbHgPBTjBZULYQkSkVL9nR93OfUmsgSXTTzLQiVwEGZYQsEap1utVhjhVOpcZAdJMm3r6pUtEyBlWqtcXAp7NN3xFXRU43PLC+cwLXyniuUk3KIDvoTHtsAa722LcGvYOzzlFJGsSH6m79qNWAmEE0yfe8cKZl6Vd5Jr/Cbj89Ze8KIq+rD3Z/feAGnoRglmncSLNu/1/Uf9L4U9iG/MQKk3TtzTojTyG1aF5XmtrTOiuBDh7zJ8zCgBly4qFVsYe2IGkLE+FDxxhViYIOkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(52116002)(7416002)(6486002)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(6666004)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g/fRPvJtjdfYS2Xn+TyPOY686J5X9PCNGI4uFvBf13f1YoO+uLvQ4RJzzX+T?=
 =?us-ascii?Q?xMo/qTnDRSl+0S3ylBhJulVkO58wilCR8vb5CgfB40HbAOWDh4n7QRF2oVZG?=
 =?us-ascii?Q?TbwKD5lqApeWPz0o4/aErIBOyzruvSTZX6+H/4ual95RK/5ONwJl8xcF7d4c?=
 =?us-ascii?Q?pdg2aUB+ASoRIFLebLFVvOkioo7ZpPojYNsHhsFJhRwC03AvTGCWteX5Sf6E?=
 =?us-ascii?Q?5NY87QP+I6264rH6Princ5yz2kvtqCul711ekVmaen+q+0S8okR4xkko7sB3?=
 =?us-ascii?Q?fwUbmTQPOGMDeWXqXL1EWhi5VRGiOZ6PJRpzgmWfYmNf6MwIM1hk5P+XswmL?=
 =?us-ascii?Q?dPXn98bEeIpClfHc6RILcnBTHQlltkYvA9aVYVEIJ1Pd9Re2tzMHe3zMoNt3?=
 =?us-ascii?Q?G1M34EyFW3Z9/2uQ1Z/mImnlCc4qbiss0wYNRZuN4Dxa/88UyEyIwyxvdhcQ?=
 =?us-ascii?Q?grvidMXg57PtHsH+8gIvQafT79Eyugc+OIEUbvp7QtGa7gBDI1isVZB5Jb3B?=
 =?us-ascii?Q?WsRqdLVOWJ4d2eql5Ol2v5MJHcF+Sz1A1wKC/WezINYcayzXKURR//Rhft9l?=
 =?us-ascii?Q?95t12O2NY5aWSC4m29iI+p9bEBsTHaGaeIFpeEfG7XpQmEEwQaybtYnyhFeL?=
 =?us-ascii?Q?uUlj6UGxMri3X4JQqybpCKQM7z+3bob5GncRYRW7/0mj5Vrc/q0Wx8s67jI5?=
 =?us-ascii?Q?NFkGV67lQFx41q9g1b1vRmakfLd8uDDf+80j/pHSu9RinG0TemM5Sv8xYNyZ?=
 =?us-ascii?Q?akCbr/ucxzfpEMSpIoYfgr2UJ8UTA5vsAG7iAeAZsnxNgRapwrtgr29PrWA1?=
 =?us-ascii?Q?ky+plq15DJldNytWs9An8CLtwii9ngsFU4QML7MBXeBRS7cm6zKFVtFvAUCV?=
 =?us-ascii?Q?3j/VtxOtguZKopMcntxNI2krOjWqGQB4LG0mS0M3gNnqVEMMIrLONSUHAbaT?=
 =?us-ascii?Q?wqU13oc+B+Ssgt929P8kuEB1PAcFcDeXr8xlOadSd6mm2RPkidUI39muQlJn?=
 =?us-ascii?Q?TWtZp7722TBiW8Y+RIUxiAfaVA55Q5lppqrXgAJCl/kOwzV0wdupfzNFD4nY?=
 =?us-ascii?Q?JAeyqO7zK1WqV1zhaqOs/muC3TEYKEzAURq4xlTydgTZvY4KlIObOhgh9Yle?=
 =?us-ascii?Q?23l41IdcnyC+hFG0AplGRmHs92gacqcKRZkAoDQcjD5GwsM/K6Cl184EV31y?=
 =?us-ascii?Q?GEx7zMQEU4fwp35ugsWBcWDdnK7cD4zM6w9r2YRd1QlEZYL0Nri9ZOq89F81?=
 =?us-ascii?Q?GQQdDTjOCqO12FuzOk41Svk/iJ7dbqDopbvWJDxYgpvuTFMJtfQrovM72+fJ?=
 =?us-ascii?Q?5/qef5Yf1zy6TSECKtER/dyda9augjRTK/qkz6WKMyI+hyn9UVtoiDyzS3YC?=
 =?us-ascii?Q?gjgvv/kBprjVBQq8ojfy+2/PEV8c36UjxwkhP9yh2IIAr69If4ZpvE+9NS2I?=
 =?us-ascii?Q?KrRTJp0ImoXntwcC8SVOk7AA/aOGDNi3tsEzMVZZLD4A/YZOKEaB7Ha+reim?=
 =?us-ascii?Q?RFgu/nG4ZMehUVDtjEmcBGrDpKA8fXOFs5YQ7otSILEH8MUj+jJ/5R1Y+s6+?=
 =?us-ascii?Q?hElll3YAdBQyohLiz3P7IBt1qo0AK3iSi97Xu42YwsxSTOojV4IKWQSpg2a+?=
 =?us-ascii?Q?aIZu1llrpx1Kun2hHe0Ixbm3E0GiXNS1/mw586PWZuKf?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585f1308-72af-4103-5705-08db2f48522a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:53:06.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUs+6AcBoliJdzof1wY4WBkMSoPpHm5kdQ2KrjyfnDIEHU5GpqZYHoG5td42eVOuMEyxniq+SVt0syu+K3vx6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3402
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the longstanding race between hv_pci_query_relations() and
survey_child_resources() by flushing the workqueue before we exit from
hv_pci_query_relations().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>

---
 drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

With the below debug code:

@@ -2103,6 +2103,8 @@ static void survey_child_resources(struct hv_pcibus_device *hbus)
 	}

 	spin_unlock_irqrestore(&hbus->device_list_lock, flags);
+	ssleep(15);
+	printk("%s: completing %px\n", __func__, event);
 	complete(event);
 }

@@ -3305,8 +3307,12 @@ static int hv_pci_query_relations(struct hv_device *hdev)

 	ret = vmbus_sendpacket(hdev->channel, &message, sizeof(message),
 			       0, VM_PKT_DATA_INBAND, 0);
-	if (!ret)
+	if (!ret) {
+		ssleep(10); // unassign the PCI device on the host during the 10s
 		ret = wait_for_response(hdev, &comp);
+		printk("%s: comp=%px is becoming invalid! ret=%d\n",
+			__func__, &comp, ret);
+	}

 	return ret;
 }
@@ -3635,6 +3641,8 @@ static int hv_pci_probe(struct hv_device *hdev,

 retry:
 	ret = hv_pci_query_relations(hdev);
+	printk("hv_pci_query_relations() exited\n");
+
 	if (ret)
 		goto free_irq_domain;

I'm able to repro the below hang issue:

[   74.544744] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI VMBus probing: Using version 0x10004
[   76.886944] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF slot 1 removed
[   84.788266] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: The device is gone.
[   84.792586] hv_pci_query_relations: comp=ffffa7504012fb58 is becoming invalid! ret=-19
[   84.797505] hv_pci_query_relations() exited
[   89.652268] survey_child_resources: completing ffffa7504012fb58
[  150.392242] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  150.398447] rcu:     15-...0: (2 ticks this GP) idle=867c/1/0x4000000000000000 softirq=947/947 fqs=5234
[  150.405851] rcu:     (detected by 14, t=15004 jiffies, g=2553, q=4833 ncpus=16)
[  150.410870] Sending NMI from CPU 14 to CPUs 15:
[  150.414836] NMI backtrace for cpu 15
[  150.414840] CPU: 15 PID: 10 Comm: kworker/u32:0 Tainted: G        W   E      6.3.0-rc3-decui-dirty #34
...
[  150.414849] Workqueue: hv_pci_468b pci_devices_present_work [pci_hyperv]
[  150.414866] RIP: 0010:__pv_queued_spin_lock_slowpath+0x10f/0x3c0
...
[  150.414905] Call Trace:
[  150.414907]  <TASK>
[  150.414911]  _raw_spin_lock_irqsave+0x40/0x50
[  150.414917]  complete+0x1d/0x60
[  150.414924]  pci_devices_present_work+0x5dd/0x680 [pci_hyperv]
[  150.414946]  process_one_work+0x21f/0x430
[  150.414952]  worker_thread+0x4a/0x3c0

With this patch, the hang issue goes away:

[  186.143612] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: The device is gone.
[  186.148034] hv_pci_query_relations: comp=ffffa7cfd0aa3b50 is becoming invalid! ret=-19
[  191.263611] survey_child_resources: completing ffffa7cfd0aa3b50
[  191.267732] hv_pci_query_relations() exited

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index f33370b75628..b82c7cde19e6 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device *hdev)
 	if (!ret)
 		ret = wait_for_response(hdev, &comp);
 
+	/*
+	 * In the case of fast device addition/removal, it's possible that
+	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
+	 * already got a PCI_BUS_RELATIONS* message from the host and the
+	 * channel callback already scheduled a work to hbus->wq, which can be
+	 * running survey_child_resources() -> complete(&hbus->survey_event),
+	 * even after hv_pci_query_relations() exits and the stack variable
+	 * 'comp' is no longer valid. This can cause a strange hang issue
+	 * or sometimes a page fault. Flush hbus->wq before we exit from
+	 * hv_pci_query_relations() to avoid the issues.
+	 */
+	flush_workqueue(hbus->wq);
+
 	return ret;
 }
 
-- 
2.25.1

