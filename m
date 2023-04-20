Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BD96E882B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjDTCmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjDTCld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:41:33 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021015.outbound.protection.outlook.com [52.101.57.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E9DF2;
        Wed, 19 Apr 2023 19:41:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckBzDoXDETXXMoBKglLjULIGhFmSnzRM6lgS+Ju+okqGxKmZq7BYZKA62Y05AMmS48+ekazSmAr15/Xpucstk1cmiYgpLggM/T+OiOBcZMQ55Y5A1PNdAa4utJyDXYB73GjEsKDFWhzpYOF0lq/o5u2gl5z2vQ1ORcnV9Bg1jM5UoAJIMKuq8MBF8dvyrJ8qWlTLVlHVI4FibeRJaeQTQCUSVjkk6D9kzGsTtVt98bwxPouX5kWCWxkeG69B7VTpMXv+BJSTKRV0wrXZg6AuFyTubYwZsTUY4sSEpK2weQ7C8+ndTFbowBFNvcG8uofizTtNrhMxM4B4REHCMV6jxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPrGWX8hfKz4SMbhlNl5Ey3zRmEQqqIy5YShwVJTCAk=;
 b=hmJSGunmKVeftBZY7r+hhg3GwohbOWr04243r4iNm68kbB1k6kGBvzV+P1SwjSWjVg4USRT4rU5j1icGxaxDPXSj6KhpYlPekxMHhUqxlzIXFVruIPwMPjab/+kgjg7qaaNIkbIYKHLxwhZrOt7ZTaUoGM3kpR8c9Qr3u6Bby9pGbnEFVcagML7/vOg43eJdqhJXFqb3mtNm9EdWfQj9dDaiOiZ9LOAqhrBqSg3L9Revj3rzMFZut6WZjGwlsrB9pxlMWSmQysmaOyv1ecs/CYyTnJ9cNolL8lspmMHmqIFMy7gl84ejOu+hkTubZhwLjVnF9uodA7o4bpRp1HiDdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPrGWX8hfKz4SMbhlNl5Ey3zRmEQqqIy5YShwVJTCAk=;
 b=KwnGayZHSxkd9VsCxW6HcVcJbKH3pNNW+2+nzPrfhTjnQ1FmAO8PzTmQl3+eitYEKUF/3781wNZ0c11san+3fnd6SF7SXk6BNR6eSH0hiSoq3aqbdz/BQuQyHm79QhAwGu4BRPgKP7VAEWkkbvp1zAC7P9zVZYz0UPE2nQnHopg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:22 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        josete@microsoft.com, stable@vger.kernel.org
Subject: [PATCH v3 5/6] PCI: hv: Add a per-bus mutex state_lock
Date:   Wed, 19 Apr 2023 19:40:36 -0700
Message-Id: <20230420024037.5921-6-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420024037.5921-1-decui@microsoft.com>
References: <20230420024037.5921-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::28) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|SJ1PR21MB3411:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f688bc2-30d8-4e33-8055-08db4148ba71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzqDAnwa4IeEpcur8vOHPH+2bGepNYekO0wDF1YBAnKtJTnva4PDY6ciPnUHb0hKYFi17tWJEuQQGXj4kzNpyeIGILgwcB2C4kT9oaAuvozZ/f2ZDw1ELav5E/Rgw4mafpb4GK/aGTvxItMdptZZnr2p1kJOfDXnYDZP3h55+CbBDMEiC7jwxFuIkAKHNnmJR9z8QqJazXMhet7+YNkPRxxSVf1rnWEm/RegmvwKbX3VZwAt6wyr7e1ZIrcfZe+2aSI00n+j+croq2GNmCwLoK4IcOeIXmVR4rrY5wnNZSdmjyzmA/t11Zius5Vjv8YrKLRQW4/slxyOHLPqnglKjV4NvsJGi6FrtRro90VRPzbtti+004y1ccPNv95lzn8u/D/U3Dk/cqtkLO9hlo9wcMPVZxyNC2X7RNZm8ePSv47BADvG8ikJtibOGu/SqbqM/nuy36H1mZ/ez3stHN6sN6qF2zFCFLRb94BJSjnXVAYMQWiI0Fq9XLmE6eXmvltd8N8fWtV3iFM92AasyfyUNgQW2hYYAVtOWZWAlMZsR2wgsiELP0w5XdU/mCYoV06wX0W9welwH8SRY6DcL3c1UQJtRhhZ++VWAoNsv+ynYhQd79dGnJoboFgZGvYNPxYmLWa4uVuY/mu7hsvonZylZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iRT1vzRRNGUvZPfmkl8JlQxzEwEYitgStTFzHXAQhWxG9nq0gw7LHIsg6uLQ?=
 =?us-ascii?Q?0bj0PYUmKd8t8RHnFlZ4RnlUU2NHzkoJRO92U7mmb02vIT9yIqdn6zOjO3ei?=
 =?us-ascii?Q?ZANH3QVM3AkkudN/u6PqYUqpNAEKH2D5Wd6zWGoE7C6kSlLxFuKgYPW3OeOs?=
 =?us-ascii?Q?Vp3pDAzQQ0EkpeyI6bZLk1OqGURVlANVtqHrTe5fCRLL6Q0gvobqJOarUHa+?=
 =?us-ascii?Q?YzKZP18oP0PG6XGpFMzgfFyrBniGImSEs/4crDI9zgf2QQsyrmr4Td0mJJZI?=
 =?us-ascii?Q?SyCFLlhEUIeXSxThhBXwnbP/QtzwZk5zknxXxNqnRbtZ8Ypau4SI0yx1BtPA?=
 =?us-ascii?Q?6+7RZ/p86MRwIoY4iqLQO7V0f+IfhSxvocYxf5tqP8+NAW22D2SlQw7aOcgm?=
 =?us-ascii?Q?tIzHyFxbMrLr8pqcWYd7kX5kNb1qIgpaw/pH68U5djYo6iGK7gINPMWF3kBs?=
 =?us-ascii?Q?scq3iJsfIvXGyv5rX3ANFD2u90XiDQKV9jB2UoOGlcPL9G1oFOCGU0ExzrBB?=
 =?us-ascii?Q?DL31ug1HcaMAo3tIWRs32nO/X7WMn18gHOdsLWIfgEtz79dxo8jq05LeYPAS?=
 =?us-ascii?Q?oZ4n74IQhK+Kxkm+31R6AYzNKtzwS+nKE81U9/pZneSRI7yQEu3MZQZ2wwEj?=
 =?us-ascii?Q?OkL1aGtG4KvKDjYReVIXatF/+HyqUa3Z0hvNogANHq6Sy6Cfj0e0qDHewS4B?=
 =?us-ascii?Q?H5wfm4xhmgO0z4Sx5Z0aHMALh2sbCzOQHC3J7oQzcRbrDy5Nqm0/Tdq4/8qP?=
 =?us-ascii?Q?qeZJLeGlG7RHMPXHrWqTDuNdMAT6gsazsGnjDCVltA/xpXPEn6K0Oo1hc26b?=
 =?us-ascii?Q?adazp6wiS+oO2bJCYzUxAM6czSoFfZo53+4f7+vQmoOZoXDFFhOl8nFrIjuw?=
 =?us-ascii?Q?slqzE7QdmyZkuKxzKfadGztXpDS7RH6bYkf1zseovoAdTBPzXM+RGjRlJgmk?=
 =?us-ascii?Q?h93l/wH4zqiCBWEiyB+nbOTiVTHZDLfKIhWal/W7brr1rP/0IU3MVKSPwmI3?=
 =?us-ascii?Q?nUKQ9KrmlF4cdfdJI/VrS/sMaZowefJY1wCBGTSrrKiEl/JOQfDfGIOlZ2DA?=
 =?us-ascii?Q?OrN8BUIHBS6RCTvbKLpoyf2eJKTsA5lp55f25zTtwUb69TrQPnY6HmQ8Ltbg?=
 =?us-ascii?Q?hb+0NepjFNXFRY4k9eSDSFDZ0mDgog/JvTM4Pz5Y4QSNh5UbzkBfcUUoQEWe?=
 =?us-ascii?Q?hvlGJNjH3zR2UtGra2rf170PkX3vsexFk3OeK+9M+bnrMKWY6/hxzOs+xQ2m?=
 =?us-ascii?Q?tb3k7dDAAW1lkEEC7DWXffebz3Xr+9EdZ4nQCZsGgs6YeWQL4kUCTfNnxQ5Z?=
 =?us-ascii?Q?SI8XEpnrTyIKAScIJDKlwDA5Uex4EtDWp6Qz59k0VIJd1DkNqoUsS+bwP34F?=
 =?us-ascii?Q?JZzAilH4j5BtQJKxNfDhGFZDA+jVdcH6M9HjpxmxPgCek/Gnys1IywUZXVeR?=
 =?us-ascii?Q?ybCxZZZ0iBGBXtzRdk79mtEokDRS5pA5txdwllWHONSYX31D/sQ9RZraCUdG?=
 =?us-ascii?Q?eX9oucyHtbD0cbJBBmBmZVnJ879Qz3JJl9R+Y6OZlfsYwMJmQqZx0Bgvx2th?=
 =?us-ascii?Q?7t4BQvxJN77xsP7jZ3B9ACCleFPt/s92cDSCENWGRmTqY8HqrRnZNbcX1RKO?=
 =?us-ascii?Q?KuSVtI70CDLbIN9wR9ELiS+lc/6Y8cNCgZqyqAZOi2ME?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f688bc2-30d8-4e33-8055-08db4148ba71
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:22.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2MKZy7yplie3QwkYdBy3LSJ1ALN5r0U6A0MYGeR/wH3bg6PZNEKO1z8yCW76TMrz4/hFai+fwmolc80iUax2nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3411
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of fast device addition/removal, it's possible that
hv_eject_device_work() can start to run before create_root_hv_pci_bus()
starts to run; as a result, the pci_get_domain_bus_and_slot() in
hv_eject_device_work() can return a 'pdev' of NULL, and
hv_eject_device_work() can remove the 'hpdev', and immediately send a
message PCI_EJECTION_COMPLETE to the host, and the host immediately
unassigns the PCI device from the guest; meanwhile,
create_root_hv_pci_bus() and the PCI device driver can be probing the
dead PCI device and reporting timeout errors.

Fix the issue by adding a per-bus mutex 'state_lock' and grabbing the
mutex before powering on the PCI bus in hv_pci_enter_d0(): when
hv_eject_device_work() starts to run, it's able to find the 'pdev' and call
pci_stop_and_remove_bus_device(pdev): if the PCI device driver has
loaded, the PCI device driver's probe() function is already called in
create_root_hv_pci_bus() -> pci_bus_add_devices(), and now
hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able
to call the PCI device driver's remove() function and remove the device
reliably; if the PCI device driver hasn't loaded yet, the function call
hv_eject_device_work() -> pci_stop_and_remove_bus_device() is able to
remove the PCI device reliably and the PCI device driver's probe()
function won't be called; if the PCI device driver's probe() is already
running (e.g., systemd-udev is loading the PCI device driver), it must
be holding the per-device lock, and after the probe() finishes and releases
the lock, hv_eject_device_work() -> pci_stop_and_remove_bus_device() is
able to proceed to remove the device reliably.

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  Fixed the "goto out" in hv_pci_resume() [Michael Kelley]
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

 drivers/pci/controller/pci-hyperv.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 48feab095a144..3ae2f99dea8c2 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -489,7 +489,10 @@ struct hv_pcibus_device {
 	struct fwnode_handle *fwnode;
 	/* Protocol version negotiated with the host */
 	enum pci_protocol_version_t protocol_version;
+
+	struct mutex state_lock;
 	enum hv_pcibus_state state;
+
 	struct hv_device *hdev;
 	resource_size_t low_mmio_space;
 	resource_size_t high_mmio_space;
@@ -2512,6 +2515,8 @@ static void pci_devices_present_work(struct work_struct *work)
 	if (!dr)
 		return;
 
+	mutex_lock(&hbus->state_lock);
+
 	/* First, mark all existing children as reported missing. */
 	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_for_each_entry(hpdev, &hbus->children, list_entry) {
@@ -2593,6 +2598,8 @@ static void pci_devices_present_work(struct work_struct *work)
 		break;
 	}
 
+	mutex_unlock(&hbus->state_lock);
+
 	kfree(dr);
 }
 
@@ -2741,6 +2748,8 @@ static void hv_eject_device_work(struct work_struct *work)
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
 	hbus = hpdev->hbus;
 
+	mutex_lock(&hbus->state_lock);
+
 	/*
 	 * Ejection can come before or after the PCI bus has been set up, so
 	 * attempt to find it and tear down the bus state, if it exists.  This
@@ -2777,6 +2786,8 @@ static void hv_eject_device_work(struct work_struct *work)
 	put_pcichild(hpdev);
 	put_pcichild(hpdev);
 	/* hpdev has been freed. Do not use it any more. */
+
+	mutex_unlock(&hbus->state_lock);
 }
 
 /**
@@ -3562,6 +3573,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 		return -ENOMEM;
 
 	hbus->bridge = bridge;
+	mutex_init(&hbus->state_lock);
 	hbus->state = hv_pcibus_init;
 	hbus->wslot_res_allocated = -1;
 
@@ -3670,9 +3682,11 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_irq_domain;
 
+	mutex_lock(&hbus->state_lock);
+
 	ret = hv_pci_enter_d0(hdev);
 	if (ret)
-		goto free_irq_domain;
+		goto release_state_lock;
 
 	ret = hv_pci_allocate_bridge_windows(hbus);
 	if (ret)
@@ -3690,12 +3704,15 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_windows;
 
+	mutex_unlock(&hbus->state_lock);
 	return 0;
 
 free_windows:
 	hv_pci_free_bridge_windows(hbus);
 exit_d0:
 	(void) hv_pci_bus_exit(hdev, true);
+release_state_lock:
+	mutex_unlock(&hbus->state_lock);
 free_irq_domain:
 	irq_domain_remove(hbus->irq_domain);
 free_fwnode:
@@ -3945,20 +3962,26 @@ static int hv_pci_resume(struct hv_device *hdev)
 	if (ret)
 		goto out;
 
+	mutex_lock(&hbus->state_lock);
+
 	ret = hv_pci_enter_d0(hdev);
 	if (ret)
-		goto out;
+		goto release_state_lock;
 
 	ret = hv_send_resources_allocated(hdev);
 	if (ret)
-		goto out;
+		goto release_state_lock;
 
 	prepopulate_bars(hbus);
 
 	hv_pci_restore_msi_state(hbus);
 
 	hbus->state = hv_pcibus_installed;
+	mutex_unlock(&hbus->state_lock);
 	return 0;
+
+release_state_lock:
+	mutex_unlock(&hbus->state_lock);
 out:
 	vmbus_close(hdev->channel);
 	return ret;
-- 
2.25.1

