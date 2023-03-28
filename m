Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F446CB5A7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjC1Ex6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbjC1Exk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:53:40 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DA52709;
        Mon, 27 Mar 2023 21:53:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjDe7V4S1KT3fU9ZcgJghU0Cl3RcJJgX/sHRN/gFXjOykk/YYWI4fxQ0153rKWju0RO+4bKpjtoQDKdNvOW3ezhIgUCJx7TQa4xgfzeTPbs3L8D3wiNbwhiVf+H29ro3F+/4czAiZhiLaz7UYUfikNbhdED0fdcJnazkkx0UGfA5cF0yVUpnPrBMygLs8SbW2DTjRSGfOmeicEajHQ9kdDQ32kap5pceA6b0W8iyi12DdrBxcAE3dXr0rWXlPuXjG8fXNWTYsHQwmE202cboBvoS5wHF2esIYXiDmpw3umlSkWYlzyLQ/ixE8RnoFud8koTMrdrQGRXiLJ9sp9pjvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIdejf2Qm7gwgjEEPWxewX41SsfdLZbzID/iX5ohE4w=;
 b=B2vuF0G2Eh/rSc4Nj9aFBH12sQLYOl/UJ3z21KpG7EepSMoYWwihKCYSRmfgNwtPpe3z6ndamBGChbdQv/vMJ74KFx4WCbbRVDU5zj8ma1I4IS9n2PgPVaLKCoXOZHkBc/4Ca++vBvFg/X4BrWg3qzwx+Hr7R7KZorJcVvt2MAGzIMCcYk5LF+Lfyn4pxk1BFLnV2L8/e5T+AUkEK1aOKNr7sMxc4vVh0GK1CUtB3oCnEWCVh+xFrjvhgCnBTuw0+HZHkQUVhx+CaCfA+F8v4nvHTEdeZo9OjhcGpaqIq2wQEUrID3BD5T1qi8yQZlsUSw4roDai0mV/cL3VFqM7nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIdejf2Qm7gwgjEEPWxewX41SsfdLZbzID/iX5ohE4w=;
 b=RCwJJ0f7arhF5MKhj5c0NnmWJXxqdfOemKQGK+ujRX7kqbGE+bBckQc9sgjaRJ+QXAGtLnOTAJabbblPgz7H1VQhidc8kM926n3MdPpJIm8URmrQdXPSGJ/24a0lIEituZGwmiomfG5C/2l4x5Wd/ikz/dPm2MNnk1AZtxFoXTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:53:15 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:53:15 +0000
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
Subject: [PATCH 5/6] PCI: hv: Add a per-bus mutex state_lock
Date:   Mon, 27 Mar 2023 21:51:21 -0700
Message-Id: <20230328045122.25850-6-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 53069f02-9084-43d5-eede-08db2f48570d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G9cea6A7CAyau3DXpBEA2Q3twjNYTcV+yKN1PwlvEGP4O/jImp2rKSMW38sdZTtAp9Q7UXaQT3BA98Y296FfJ0gKBcJn4lezFrOcc+s3qxMuApkVzJTtKVCd5GNmDfiH+hb3Q/fZacLLTJAY66PZA9y8i6riNsy9ulqRgvc8rRX1cYLNCqvQ30RM+RpvwsG28zHSkbg/e5ff9x4/vgUJ14/MdEZAqubo1zJNibQzmJkucO8+cH53NytcV58rU8snsa6Pg/Hj7SCXtBcleO5znEZXAtQUxntJkK7mWlSa7HNTZUY0lXuIBaz3YfW2aF+xonoXumx4JpYJzIQV2/hScEF+p7BpxGYu7w3DgMNikZfU7GGlclif/71KutdzSH8MHvH9GEYuBZN7m8eIfn3CteEv+vTfS4RusEsIk5IEepSeSC2Xuft0V2ZyoIYy80oE+Z8hXXh2Fa0kXRjOwNR6I0FBezz+NA1tqnfZgcAyNwUR+LL7wCg9AcqtuYi/HzTMUWhmu031iFPMXDcWMh/eL2DGzpckThkB1XkKRik86z94ICVXse3kNtiJHKXdf8GBEN5O60qwhdiRNEJnO/FwLCEnS+F1ZfktlJ2d7Dw6QCmTnPq9QW+DP6HE32vMLAtyQB19FMsvsicUG8bUZrYV8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(52116002)(7416002)(6486002)(30864003)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(6666004)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UNDYynaym+7HRVyg4nRH4FtFXrS/1F5ijno4QYnE+banZ8nrUIoz2P8a4Hjo?=
 =?us-ascii?Q?QIzPpFxI+DWBhVoyfWJQJlvLoewdwjpwI18HooTW3fWMaBr5qSksF56lbGSu?=
 =?us-ascii?Q?mDNnwrxvts7dRDt4mLBKhpm2t4Zfh1eCetYf7HbzWtrNG1X4AKMjjZqlh9Y7?=
 =?us-ascii?Q?bDcD6oswzSYpufcv8cJ/6z18RIzKQ23pIY4TbA+Zaqs04dS/2rxSAvYDrg2A?=
 =?us-ascii?Q?U8jv9LQOzZBPnoGkTssqNIe6SFq89427YAYuHPQMVEpkOXDX+r3yhYy4EHZO?=
 =?us-ascii?Q?He2FWbMLrBwhNJVLVLPSWqQE6fK6PBYptiWEVeHzlfPU0W8tl9bDwvNtL83L?=
 =?us-ascii?Q?qLLazAIDO2cUEMaFISVWfUKCFGXYTLA5nJshVUNzcXZc8zQpxhBZCmKwIkxI?=
 =?us-ascii?Q?w4p80rMUtYBLHY4xnUqyaVu6dvMmOpEohVefC9cJH6SPo/gk5oGFJ/hbmc2s?=
 =?us-ascii?Q?OwbWy8L2/XBIRaulIAJ00RF68tcuhbogI4mKau0RnT5ERqhE9gsgPTXtpA26?=
 =?us-ascii?Q?tYMDj0AoH0mdO58I3ffu0F6s6rAE5PEBdkz1rGf1Vn62GroH8AZ3hXanT4HA?=
 =?us-ascii?Q?0fcC7WzGQ7L63psxKFc1+U0y6RCJeFQbLaOB/UTw5V/IFZsmLqwasKGLW1Oj?=
 =?us-ascii?Q?An6BsGwh3X74S0zUvjY0aJZwJaghQqF0Z3spNBPT4jgFuGSVT/kJV0j5IpvA?=
 =?us-ascii?Q?KzYvKUablCB3W/uZVTlepBU+J+/dMDT8ZXDFCBWCnM/mLexABceYP9PLkVZo?=
 =?us-ascii?Q?6DVtKIBfotdXbm/KNsZN4PVmtL6t7Z1pUX/WJgSdGlSOmn5DDwXLjUyPxQ9q?=
 =?us-ascii?Q?tDeoNEyKkOU+0uN5nQVKcLEJllczQWGmuHHS9tRxUDfHUH5pWUVUIL2SDM5i?=
 =?us-ascii?Q?BUJ3L3IXf4uJP1wgm0pmBfulIZlvvUcyyEeafW/wYpQFxwDxsa2w8Sg6RlY6?=
 =?us-ascii?Q?0aPbmAg58fx+ajERMM0INtXWt1fwH12pO3GGlMXlAGpO3jLPh7RUnxP1NJTv?=
 =?us-ascii?Q?y/m+kycZQ2+sxgjwj555VD6yel2RXjViyHtoK2fUPbCHlbSAUUHk2CQapFYI?=
 =?us-ascii?Q?AnRU7gKb2T6HG74yZnFWGk+j8QFvIKJw1hhUDwrnwWKlHxwffRkGZ7hsqgWV?=
 =?us-ascii?Q?qPA/0WAgUV00PgzLhYoVXj6B2W1P9PksnGR+4RWSnfcJ8ZYdluKyoc838P9d?=
 =?us-ascii?Q?zIiEljTaG4jVbzWUSU2paKH0Z2CQBbKi/BStDfp8cOIO/40H08EuvSO3aIGG?=
 =?us-ascii?Q?vtAtAcxuAnd9yhjKjuwAuEcEO4amR2xX6VDjLbRaCmPmf+PEnGLq7eeBqJ4O?=
 =?us-ascii?Q?xW4ytSj6l3N/s2m+cBD9Pf0HggfrP8slRLlO6yBzbCAG8jYMIEFOO+HxNYeU?=
 =?us-ascii?Q?xENuOfPvUmsEYS5H4u02XOLdKlNpVRISORx9RVd6/DbbLkWs42mCCJ1c9KEK?=
 =?us-ascii?Q?UTC75c9lw0CfEA2JhRfRudT7mXn3GA8BZZZ+b0nd27wenkOCCSVsyJMsWvQk?=
 =?us-ascii?Q?l8NZVEUDPxX2qqFc8Fre2vBk8UIw9/IzpdnxJkijSul5ucwTbOaPCfHmkbFq?=
 =?us-ascii?Q?0SrGabr31d38yCAHYNIbo4Bs511AO0c23112JPLdzEdY04PxEdZDgjaTQksE?=
 =?us-ascii?Q?qgeDD3EDnGgnd++XYlSN29a4BQHyKHtbRZtPMfOubWGu?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53069f02-9084-43d5-eede-08db2f48570d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:53:14.9349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bIIp6fxrzNYF+mOUIwQvUt3ObqM4wEGM19nXx9q+VTOH6nNb/BoMFHH8L0lxeK33s8ep72zB9Rd16YP4HIEEbA==
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

---
 drivers/pci/controller/pci-hyperv.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

With the below debug code:

Changes to /drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1727,6 +1727,8 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct devlink *devlink;
 	int err;

+	printk("%s: line %d: sleep 20s: \n", __func__, __LINE__); ssleep(20);
+	printk("%s: line %d: sleep 20s: done\n", __func__, __LINE__);
 	devlink = mlx5_devlink_alloc(&pdev->dev);
 	if (!devlink) {
 		dev_err(&pdev->dev, "devlink alloc failed\n");
Changes to drivers/pci/controller/pci-hyperv.c
@@ -2749,6 +2749,7 @@ static void hv_eject_device_work(struct work_struct *work)
 	 */
 	wslot = wslot_to_devfn(hpdev->desc.win_slot.slot);
 	pdev = pci_get_domain_bus_and_slot(hbus->bridge->domain_nr, 0, wslot);
+	printk("%s: 1: line %d: pdev=%px\n", __func__, __LINE__, pdev);
 	if (pdev) {
 		pci_lock_rescan_remove();
 		pci_stop_and_remove_bus_device(pdev);
@@ -2756,9 +2757,12 @@ static void hv_eject_device_work(struct work_struct *work)
 		pci_unlock_rescan_remove();
 	}

+	printk("%s: 2: line %d: pdev=%px: sleeping 10s\n", __func__, __LINE__, pdev); ssleep(10);
+	printk("%s: 3: line %d: pdev=%px: sleeping 10s: done: removing hpdev\n", __func__, __LINE__, pdev);
 	spin_lock_irqsave(&hbus->device_list_lock, flags);
 	list_del(&hpdev->list_entry);
 	spin_unlock_irqrestore(&hbus->device_list_lock, flags);
+	printk("%s: 4: line %d: pdev=%px: hpdev is removed!!!\n", __func__, __LINE__, pdev);

 	if (hpdev->pci_slot)
 		pci_destroy_slot(hpdev->pci_slot);
@@ -2770,6 +2774,7 @@ static void hv_eject_device_work(struct work_struct *work)
 	vmbus_sendpacket(hbus->hdev->channel, ejct_pkt,
 			 sizeof(*ejct_pkt), 0,
 			 VM_PKT_DATA_INBAND, 0);
+	printk("%s: 5: line %d: pdev=%px: sent PCI_EJECTION_COMPLETE\n", __func__, __LINE__, pdev);

 	/* For the get_pcichild() in hv_pci_eject_device() */
 	put_pcichild(hpdev);
@@ -3686,7 +3691,10 @@ static int hv_pci_probe(struct hv_device *hdev,

 	hbus->state = hv_pcibus_probed;

+	printk("%s: line %d: create_root_hv_pci_bus=%d: sleeping 10s\n", __func__, __LINE__, ret); ssleep(10);
+	printk("%s: line %d: create_root_hv_pci_bus=%d: sleeping 10s: done\n", __func__, __LINE__, ret);
 	ret = create_root_hv_pci_bus(hbus);
+	printk("%s: line %d: create_root_hv_pci_bus=%d\n", __func__, __LINE__, ret);
 	if (ret)
 		goto free_windows;

I'm able to repro the below timeout errors (remove the PCI VF NIC within 10 seconds after it's assigned)

[   31.445306] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI VMBus probing: Using version 0x10004
[   31.452133] hv_pci_probe: line 3694: create_root_hv_pci_bus=0: sleeping 10s
[   34.345256] hv_eject_device_work: 1: line 2752: pdev=0000000000000000
[   34.350175] hv_eject_device_work: 2: line 2760: pdev=0000000000000000: sleeping 10s
[   41.650330] hv_pci_probe: line 3695: create_root_hv_pci_bus=0: sleeping 10s: done
[   41.668443] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI host bridge to bus 468b:00
[   41.674201] pci_bus 468b:00: root bus resource [mem 0xfe0000000-0xfe00fffff window]
[   41.680284] pci_bus 468b:00: No busn resource found for root bus, will use [bus 00-ff]
[   41.688901] pci 468b:00:02.0: [15b3:1016] type 00 class 0x020000
[   41.695554] pci 468b:00:02.0: reg 0x10: [mem 0xfe0000000-0xfe00fffff 64bit pref]
[   41.704304] pci 468b:00:02.0: enabling Extended Tags
...
[   41.745847] hv_pci_probe: line 3697: create_root_hv_pci_bus=0
[   41.938950] mlx5_core 468b:00:02.0: no default pinctrl state
[   41.941462] probe_one: line 1730: sleep 20s:
[   44.466334] hv_eject_device_work: 3: line 2761: pdev=0000000000000000: sleeping 10s: done: removing hpdev
[   44.472691] hv_eject_device_work: 4: line 2765: pdev=0000000000000000: hpdev is removed!!!
[   44.478007] hv_eject_device_work: 5: line 2777: pdev=0000000000000000: sent PCI_EJECTION_COMPLETE
[   44.480213] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF slot 1 removed
[   63.154376] probe_one: line 1731: sleep 20s: done
[   63.161610] mlx5_core 468b:00:02.0: firmware version: 65535.65535.65535
[   83.174538] mlx5_core 468b:00:02.0: wait_fw_init:199:(pid 17): Waiting for FW initialization, timeout abort in 100s (0xffffffff)
[  103.190543] mlx5_core 468b:00:02.0: wait_fw_init:199:(pid 17): Waiting for FW initialization, timeout abort in 79s (0xffffffff)
[  123.202507] mlx5_core 468b:00:02.0: wait_fw_init:199:(pid 17): Waiting for FW initialization, timeout abort in 59s (0xffffffff)
[  143.214547] mlx5_core 468b:00:02.0: wait_fw_init:199:(pid 17): Waiting for FW initialization, timeout abort in 39s (0xffffffff)
[  163.222594] mlx5_core 468b:00:02.0: wait_fw_init:199:(pid 17): Waiting for FW initialization, timeout abort in 19s (0xffffffff)
[  183.178629] mlx5_core 468b:00:02.0: mlx5_function_setup:1130:(pid 17): Firmware over 120000 MS in pre-initializing state, aborting
[  183.186289] mlx5_core 468b:00:02.0: probe_one:1764:(pid 17): mlx5_init_one failed with error code -16
[  183.192623] mlx5_core: probe of 468b:00:02.0 failed with error -16
[  183.202701] pci_bus 468b:00: busn_res: [bus 00] is released

With the fix, I'm no longer seeing the timeout errors:

[   31.144066] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI VMBus probing: Using version 0x10004
[   31.149207] hv_pci_probe: line 3708: create_root_hv_pci_bus=0: sleeping 10s
[   41.378274] hv_pci_probe: line 3709: create_root_hv_pci_bus=0: sleeping 10s: done
[   41.397577] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI host bridge to bus 468b:00
[   41.402799] pci_bus 468b:00: root bus resource [mem 0xfe0000000-0xfe00fffff window]
...
[   41.415586] pci 468b:00:02.0: [15b3:1016] type 00 class 0x020000
[   41.423132] pci 468b:00:02.0: reg 0x10: [mem 0xfe0000000-0xfe00fffff 64bit pref]
...
[   41.471366] hv_pci_probe: line 3711: create_root_hv_pci_bus=0
[   41.484371] hv_eject_device_work: 1: line 2761: pdev=ffff90f4c4858000
[   41.491644] hv_eject_device_work: 2: line 2769: pdev=ffff90f4c4858000: sleeping 10s
[   51.618268] hv_eject_device_work: 3: line 2770: pdev=ffff90f4c4858000: sleeping 10s: done: removing hpdev
[   51.625094] hv_eject_device_work: 4: line 2774: pdev=ffff90f4c4858000: hpdev is removed!!!
[   51.630234] hv_eject_device_work: 5: line 2786: pdev=ffff90f4c4858000: sent PCI_EJECTION_COMPLETE
[   51.632148] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF slot 1 removed
[   51.647014] pci_bus 468b:00: busn_res: [bus 00] is released

Now the mlx5_core driver is loaded; I try fast device addition/removal again
and I'm still not seeing the timeout errors:

[  495.622678] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI VMBus probing: Using version 0x10004
[  495.627791] hv_pci_probe: line 3708: create_root_hv_pci_bus=0: sleeping 10s
[  505.762550] hv_pci_probe: line 3709: create_root_hv_pci_bus=0: sleeping 10s: done
[  505.779496] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI host bridge to bus 468b:00
[  505.784872] pci_bus 468b:00: root bus resource [mem 0xfe0000000-0xfe00fffff window]
...
[  505.798323] pci 468b:00:02.0: [15b3:1016] type 00 class 0x020000
...
[  505.868908] probe_one: line 1730: sleep 20s:
[  525.986578] probe_one: line 1731: sleep 20s: done
[  525.990717] mlx5_core 468b:00:02.0: enabling device (0000 -> 0002)
[  525.998339] mlx5_core 468b:00:02.0: firmware version: 14.25.8102
...
[  526.381211] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF registering: eth1
[  526.385432] mlx5_core 468b:00:02.0 eth1: joined to eth0
[  526.389076] mlx5_core 468b:00:02.0 eth1: Disabling LRO, not supported in legacy RQ
[  526.397276] mlx5_core 468b:00:02.0 eth1: Disabling LRO, not supported in legacy RQ
[  526.400330] mlx5_core 468b:00:02.0: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0 basic)
...
[  526.430803] hv_pci_probe: line 3711: create_root_hv_pci_bus=0
[  526.443633] hv_eject_device_work: 1: line 2761: pdev=ffff90f4e369b000
[  526.454819] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF unregistering: enP18059s1
[  526.457828] mlx5_core 468b:00:02.0 enP18059s1 (unregistering): Disabling LRO, not supported in legacy RQ
[  527.680118] mlx5_core 468b:00:02.0: devm_attr_group_remove: removing group 00000000074d6d6b
[  527.692794] hv_eject_device_work: 2: line 2769: pdev=ffff90f4e369b000: sleeping 10s
[  537.762575] hv_eject_device_work: 3: line 2770: pdev=ffff90f4e369b000: sleeping 10s: done: removing hpdev
[  537.768831] hv_eject_device_work: 4: line 2774: pdev=ffff90f4e369b000: hpdev is removed!!!
[  537.774313] hv_eject_device_work: 5: line 2786: pdev=ffff90f4e369b000: sent PCI_EJECTION_COMPLETE
[  537.777737] hv_netvsc 818fe754-b912-4445-af51-1f584812e3c9 eth0: VF slot 1 removed
[  537.794038] pci_bus 468b:00: busn_res: [bus 00] is released

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 48feab095a14..2c0b86b20408 100644
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
 		goto out;
 
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

