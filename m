Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17E6D568E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbjDDCIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjDDCHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:40 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296A53580;
        Mon,  3 Apr 2023 19:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZylccHie1l16rKWASFoQJs54YhVR07E0FY4/ZEo1K7gRu6D9GmCEun3yiaqpbqEtN3yUifYTUrZlfvnRNtO5bt+My0WdYuOR7XL39RYiz2FsXDn3x7SoRQbxyrg+BtrTPp3TIoJaGF2iCfraXbiXRyeuu64E5s5qosDbXM06mIQUA55m+F3wPasE+25OcT6VOLNnZ8XktUYU3n7xxR1D3UCtwqKW9Ypr/nn1ce9DKCtV04bZRCpxh1+SajhqaFN6fWPfJEkI+a08PtteXmPkTBustq4U8Td3ViGQ2Y38jjrSgh6NwYRby90XOm+8r6LWb3W/zAktc9La8qVS1uSrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPFm4OWnOyuxncPe3RjVHu8Y/2NhJOX+IXISsBP0JZo=;
 b=T315nGxZ2SvzzqdL7Zp7+Qn4Cc1UGCl5d2fM9fjj0CrbIxHSZAMlNJLd+H+FzNCih/My25lajhDp4+ts0EWgexcHJns7KB+mmW15K8eyVm9VstTRoZFY3LrFisqVcI/TrTWjch3yeykwJ8rtu6mIGdst0qEYbHU9RYSv6iZFbvdkI+M/nvvf9BD9EIyzM099Sca45w1DK6DbRcbYENlICyAxfa4nIYvUMds6Av4lzz0meVpLgCYixDAO9/7jZD/7uxAIqN58CaErDqJq0+tfMrJDp2trIg1KB1UumRRnasAtBb9ty5fO7enrB/a2jklnSSy4zf5oZbqwMP7p0gU5OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPFm4OWnOyuxncPe3RjVHu8Y/2NhJOX+IXISsBP0JZo=;
 b=fd2lYieVaMrUcqjC5M/jRFxjuztq0Pob0GERmmXX1Cx+X4mRCBdmKOZZbIYe3yulmb+x3HVfq4SJ4CURgy0dWXf9nCTm0OsQ942EGX9k9feohsNoLHklQH+z/P+pdOnFftdfey3WnZwbsYpQOL/31+T9ndQJbWhzkjF60drVhPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:07:10 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:07:10 +0000
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
        stable@vger.kernel.org
Subject: [PATCH v2 5/6] PCI: hv: Add a per-bus mutex state_lock
Date:   Mon,  3 Apr 2023 19:05:44 -0700
Message-Id: <20230404020545.32359-6-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404020545.32359-1-decui@microsoft.com>
References: <20230404020545.32359-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::24) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH8PR21MB3959:EE_
X-MS-Office365-Filtering-Correlation-Id: 988a30ab-bb88-4622-686b-08db34b14c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lmFfaHDExSx6zk/oaST89v1JASYQJj17KBQtUt5T3b7Ch+sNYg85Ek6E/JpX7KAukN3w2vSqOr+Qcmcb5RheEJjWKY31i/OBy58Rly4dZJub4olSAOOR1Ypto5YX384HjzlzexSABx6fskb9ebmm6avtXO0LdG6oDOdIXE7FoVpwyc2+Zk5GAIPDdnIyghl/aIo/CiugGX/ys6kIIfEU2h4BpOQelJ85LC6FBJYHHjZ6gDv1nEml91CAcMIRgPxu2imdi5Q+rPEBZjxT+95JFrh9Ntl0kNpt1MCNPhTemOzSQHpLYKxtwWr1V9Bd0Ba98AogxKWhyS9biLi9IGm2i/bLe553zTwpvoHbcAE/tV9WmGFmYrni5HGVMBMbhR+eQixaog8uvXJeKqQ4HLsvW922AvfPcSFcSglE7e7GsebmaVlD/b4oG7sKgm0LzJWjqas7V5hwuXzFpeB8JH0QY0VRuwUKu8S716VEahBZ19vgu8mC1fu4YzpJN6X7Xqkb42iex48jTcOfCcP6ulxI1TJPMBw0+HqXHZz3jpZ4Fy04NxiLphvAEt+JUzY6LbakUMFCl9u/Efd371dSPNbrbp0oQR0/3Mz/JjNp8dmfVGy3b+hn4u+eVCS4BiBLajNWeei0BF5Tm1C4PN7QLJ4mEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b3mMO8l2sNpkh7XZzt3+/R2bB1AhOj7s4l0yg/KEUFS2Hl1/0O6wq8/4aTQH?=
 =?us-ascii?Q?A9UvtCc4U8dPR1lH4MiUfzlpgkZRyMi4Gg65wTECO48TITJbLiLgsirtw+3U?=
 =?us-ascii?Q?Fr6PdJsBlSuQQHj3enjZ2lYUXb+K8OyrVf0nvdfmm0Uyk+ZFMX4TuGsN9gLr?=
 =?us-ascii?Q?feMmeFuhfHOJG1iPfk1pMu0/iQ29edGfl0ngFtWze3tm3c8UPTsF8Z+lx/4J?=
 =?us-ascii?Q?8+bE6gdQJx2v3AILkwXxCwm6nhgruR4x4FPgA1mNGx5jtW8cinEFNzb6YFmq?=
 =?us-ascii?Q?EBFCxdv9tccdtuJ+v6cJ+AwAsJ8zImiJ1xwBoIH7N5UvJ2fVx/GTY5lcSSqR?=
 =?us-ascii?Q?dlpQHLsjRxDBoKQJHPzhwtB9aopgzw44AK1Gt4XjLKfNHoqLxyawBBa4Bulw?=
 =?us-ascii?Q?bdXWyMRsNM+8mIvjjWdP2ftI7LnoSGiKe6SwiBydcvUilaI1wglxK5WhIb/P?=
 =?us-ascii?Q?pY8iiZ4GMcJWuQW5/ly+3whiJenNslcttxIb7lkJAShkKg++aY7aQoePregN?=
 =?us-ascii?Q?VTM9iXjPvhE9D+qbwBvWtoQgnPrf+7HjUpWJjNvFFDEL7PtwKNyGC1i5CLT9?=
 =?us-ascii?Q?+EGzl2pTyPSjB8IGpgRlNicn6kbvvcsnOqz80EhGQcIkKyMaJTtuoWYG6ULB?=
 =?us-ascii?Q?B/Ww54O7LPB06Itp2M+FCqjw6VvwRt76GHy/L5jsk5PcKh1rPvaOmBeOgAL1?=
 =?us-ascii?Q?jHhHkXg2L2lURm2qDZpSrg7x1hYFJkow+5baknjmhHrKjLTrI17NI7M/CuK4?=
 =?us-ascii?Q?Uh/5kMEvh+BXP/DLV2rKrH9qXq4G3i7fKn6y/mbq+OwGyNxcC+AZFyVfQB7K?=
 =?us-ascii?Q?dut9BXksgQ1xTB+5UR5koGEOcPIJ2YWI2fGLPeYBUWw/YM3909FMT+D+yefe?=
 =?us-ascii?Q?Aa/Qteo22Ph4MpWFuAZRfndrF0+8YuvfUmFGlwoqa/bM+EZIZQxV1snACUXU?=
 =?us-ascii?Q?nvt/RYUQUYy7wDvTH8FcQ7sTZv7ft+YQn40EMdf43Id5BYtOPvNX4zZ/Zr/p?=
 =?us-ascii?Q?r7STZbG3lj3yUtkXJHNZTTpeOdowJH+FBCOERHVuXT+Pgdpg2cew7TnLabXZ?=
 =?us-ascii?Q?rGcd6Ooq9LzRhE62em6nlYcrOneky83VjtODNs3Q1h7cACi327JxfzSgm+92?=
 =?us-ascii?Q?Ww7Gm7YNsQS/sHbVX62CToRQoeZRn39hjpqTr8W0esUXakdI/u+JEZTJfvn+?=
 =?us-ascii?Q?WW3H9+IbcFARuoR7Lt5JtT5vZMGpTJcjWM5bOpyskm49WM4RNIi+4/C3LCnn?=
 =?us-ascii?Q?pOODKkqsZNCMEGqi9do23d73DnKLX06zpE7KSoQVmqUG/U6oWtCToVV3LKb0?=
 =?us-ascii?Q?hZBXVAu21yzbMXk61N+gS2TxlnjQrOlfpogMaml2CsVHvBNA6BtAFzIUj+06?=
 =?us-ascii?Q?/k5itpoatni/FmqREiwx8r0f86UDz+TdQgrStKNOptK/DRdaglhse02K7lsu?=
 =?us-ascii?Q?5sMrzIvCCMpwK1krflgK3XfP7aWc8MksGrvRHl2t2QqzNOIetCImztRYDrVe?=
 =?us-ascii?Q?xypBEa18g4hvcGw4XTOIycm05zCK8rcAvbv0LuQXK6tSp6S9b9Mxu0YF9XJL?=
 =?us-ascii?Q?FVORWtgiTNRIO8AgWWL29omtpM3qXrlQl3pBvBQbsuBtHk4p4pQ19h0Aw6OR?=
 =?us-ascii?Q?Ll1Mej2mMNqqhE0g4eHDw3/ONF1aF1nUv4PwvarIMFPU?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 988a30ab-bb88-4622-686b-08db34b14c43
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:07:09.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgA/eBAasg7gzrpkzc+2Nszh27l4U1m4qKtZWnZgZgdRHvkkDZDXd0UoSJ+HTJhUHWLzurqycKcrL2Tean43HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3959
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
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  Fixed the "goto out" in hv_pci_resume() [Michael Kelley]
  Added Cc:stable

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

