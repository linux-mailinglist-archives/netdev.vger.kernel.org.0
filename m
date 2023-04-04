Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA86D5673
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjDDCHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbjDDCHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:08 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3332695;
        Mon,  3 Apr 2023 19:07:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IivObe+W11y54caRAFEVUO0vzIrSqVgkfSJj55FUUcXNSw03CBpbf5GKcjib+Zw8ZPy8u3JzHdxqHt7HLVdD+sGgorSBCM8lRwQMi3aM/14gKYzL7Lfot3TtlP6QRtbCKTJN6owkBfzrSXM4ExCUFDTyY/cvv0DEpAujcX7FHLDwpKEUyFn1C8H0QMHJozBVeTJ/f1g4ESAcLmYSIXFr2Opq90HzLuA026bcQkoBTv4RPhSdM4NbzAee27jMO7Cef2KeS1C13mRL6H0P7+AS/dhdIaELIvJp+19qjsUxmZpNR4FatrrGuM3LldPQZiWFD0A1wL9i4XNWhkYMD1o/uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQw8s0e+ITqhk/HKjdZspANCHM8y/8k8XqmHREtfe/o=;
 b=DcOV/zx1kXnMj7Rh1BTYVvymLD/ZwG8N6+u04kC3GzhpoET8FmK8cXafvgwu1l69thWCQrS2/TzOdz3IkGJgqdtnFm2Zubp6tIDpcuAwMIuDcppUBtXNVPQzOUyku8fQXtSoooKGtOR4FJknCEQ95BorGJsNIWFJtgz1twrZfgpJjEYvBADmf21Eo5PHUt7PTVjmM/24Ak6/r/PuHK2uIm3aG+gYUCIyFRwSgDylFX6jMZw0gZpNU/oQYzCCtksv2vSclb4Z47pYpvl9FfAaVcyGb+aT5ZyXMalNiCVBx6C2E+MbUVz5M9l3OyYi72WWtMgSb+ELn/DG8Lmx3JFbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQw8s0e+ITqhk/HKjdZspANCHM8y/8k8XqmHREtfe/o=;
 b=fCIUP/Kfzun0/Bd3wMal06CDDsU626RetHGC6ZDsdVGmHPeb+lgcZBmU/VChutd07tavFR6eyiRKAefATEC0OAKTkz5nv1oBrsyo8QcCwO1svLtkHLS1DRciBGFm8DukLZiu7T0dQeykbRAlaNhLb/1qZtQgxbxrk3Vvj8v4Zag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:07:03 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:07:03 +0000
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
Subject: [PATCH v2 2/6] PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
Date:   Mon,  3 Apr 2023 19:05:41 -0700
Message-Id: <20230404020545.32359-3-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 12a42dfb-5b01-4a97-47c4-08db34b14861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qdP/HG0zihdWgIFDHdPFK6dSCOQQLvs86fwQPwd9IzCC/c1llsv7O2tBsOMLaaFN/ZkK6AG4Yw9axo4AKWsOCHkGWmlwYOGBRBXrgMj47kj6Zgi00jW6bOnZIHHIbnm/oWorMzxml+LppFUKSapoWfyH1aWcKlZ/wT9oS60FWhjG1GkI5l7mrJzhbgP+Eh4Ibtpau34wIIEaUJaKMf8MaCtM/1MpcVROK9zRVC8+/GIbCrrfLmDlu/Yi/jcDILSbnw0ukblNn68b2P8vPmvc9mmOTFhwBJB+vvZii4r2Z30o/LVQpxklKEQHJk6tQW5ajn7j159R7Vj/LSF3yuD+7CUl5eFN20SWoHpitetEsxN4V5DO4KkZ/YKaKyv9KyoEZyd7jpJ0xkQ0ni+ahiQReEZa6hBzqFY3l43sEkh/637MDH7ji8yYU0+poNXK1bVAQ3Pw6RyadzqrniiZeBMgIroyhuiRKJvF4z6qo/dlvEQyl/hAnLsG6NubhxF+2pzqzp8ctmlhUOMw915OjEBve9MtdRMKED4T1FwzIeY/qMXJxJot6eS8aPWAm38vapmCNb3dS0Eq0Ze6elY8DH66YipOAQIwry6Jl9lRzs1zUAhrUW/uRldovwS2/hEmsRPcBpBBcfJYCnFWswogM6lgMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(66899021)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tOyVx/hLPywgs5I+1yYZ8W3eU8E1B0Pylq4Q57rR9DWu5IB8/iiVPQdmXQ9B?=
 =?us-ascii?Q?4PWOEScfOajdgBPwfyaVHWQzTGZYbCjwcJxZfShOaLFE9gwuVgU9N/Jw+Uqc?=
 =?us-ascii?Q?DhZXJl+4W8UJKDo7hPDPFP7gHu4Sf925dU8HXMX81A9/7rVfZSyRK3PRWcPa?=
 =?us-ascii?Q?7biJEzoJoFU+f07p+Pz/s/XrW/5+mqJvXJtAH/4ytOQK86nTOwYZctt6A1ZL?=
 =?us-ascii?Q?HM1YOQNvTOAqHc33d/eDGkWzTm9UJf0zf66g6omPHl6K1vJQnDlVgBOo0oXZ?=
 =?us-ascii?Q?IKZgwZ1EqHi1b9EOeQSi8iIXUtmXRrOLm5OTqACsJ84Vigd5mOBG6Ece/zHn?=
 =?us-ascii?Q?+xrY5aQDDfo1LLjSjdrUhm8E6vtkDwthr9oulNB4yVav4LGPtw8FRJ9B7XR1?=
 =?us-ascii?Q?lFPK2k5p1cKoOh1E4L3LU0ckvj8HYqbX0oYMJbD2/OhDjn3ZThT4AbA3YOvv?=
 =?us-ascii?Q?ZAIoAfjCf7/hfPbsNILnCOa7s/oUxjSi9bXV52RiL2JwNhSYG3Js0NQP8Rf8?=
 =?us-ascii?Q?O5djCfmK7bY6AJLcfYw1UvP/gr4Gdbb6zahKEyNKedI0u7gI5rMrJGGMYn2A?=
 =?us-ascii?Q?f6WLkvpq3IRC7ULw3ctsC26rpdy9OaVcz5Swp4HPPp3xqpnq0iMO0UGv3vaH?=
 =?us-ascii?Q?eyhjTljhlZ3AV7T/bs/yoZ2H04dHA7n7b7NduONDdRmOs5f06Fr4/vjgLfF6?=
 =?us-ascii?Q?7I1QRtpHr/wDTxReIIxpBW3bFm3DEf1rJKFFo+fmaxQVC45BhDoXDS4e9l2/?=
 =?us-ascii?Q?Z9Sfo+E2ZhhEmRV19wdG7XiIBbj/p9FeGwX4wwKPNTPv6WzgoYFhOhgCgZfA?=
 =?us-ascii?Q?SV6i858+zrmIiaKT3ql8ccNj7Gb/RP94SIcowU0MKwkWE6C4XHrzuPpmUYtQ?=
 =?us-ascii?Q?4wyn+Pi/hw5hnKCyLJAub8jJrurwzc4hP/SIDpVRrnIIMWdhB0sP7qjzvrtq?=
 =?us-ascii?Q?E/vsqoNneI+5KEQ8CoBWKeLC3JoJt8l3aUB/nvhJHJfWQ0ldKVDlxxzPpd8f?=
 =?us-ascii?Q?jgwYefUIv6cy5wla6C0Nbxf4+yTdErMChjqguN3q80iD9lg5lef72CW2nHWk?=
 =?us-ascii?Q?mmOuuqfA0LJ3HXSjhro/3Nq5aXSB8hDM0Y2nnuRaIwGo+1eLmBTknVBOgcSS?=
 =?us-ascii?Q?sOfCUPetF2NcIXPLOT9L6GaPOa3007zbZoaAlDfzEwz5truui7PXeOHIcYTN?=
 =?us-ascii?Q?pO+vvcrrFgRKoNTeCR09kFv5vAp2TEMObSaORlPJV47nYHp6nrIY9bSIGaiR?=
 =?us-ascii?Q?tlElN93AVC6LL/CYTH/3fZkivRnO0ifkmPk644BGTQrfSgsNxctYuTjU1DUi?=
 =?us-ascii?Q?M8jH+jSPb/tauXjU923N5cY8qdQMbXqyukQNmQeIc5T5z+y6Kh6wvjBqXmVB?=
 =?us-ascii?Q?Hr3RFEtrxiHq60pMslsgyyYKPIzrfHw4o4XbNznT9L3ooFHdpkx9kBLqTPu/?=
 =?us-ascii?Q?p+KeZ/c/rzhpMn1goemjk1VGro1dBQ7HsTM+7XOevzAIpBxZP4AxsA/5s7OF?=
 =?us-ascii?Q?ZD4A7ZupoMb9XYiGW0BNF94OoSbFoG/c68iUOSm/tQ7dAd6bb8eaPSsx+S9c?=
 =?us-ascii?Q?jv8XHo1eZvcZ96CEA+ds3kTUQhaMulV5CIwUEj3VizH1tQjgcImCRr6Pjr1j?=
 =?us-ascii?Q?F9EQQvLTJ001Yv2GnpGz0jV1M7h3N4Ugzm5Md9aYzsxz?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a42dfb-5b01-4a97-47c4-08db34b14861
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:07:03.3284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQpojLHSL7Nb/TCsmZL7NC2xD4NEpOl6mmGznyKEO7+MmLC7m5WYNmoH5EEwTRK37dgrwNODfPpIzxLUdusvAA==
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

When the host tries to remove a PCI device, the host first sends a
PCI_EJECT message to the guest, and the guest is supposed to gracefully
remove the PCI device and send a PCI_EJECTION_COMPLETE message to the host;
the host then sends a VMBus message CHANNELMSG_RESCIND_CHANNELOFFER to
the guest (when the guest receives this message, the device is already
unassigned from the guest) and the guest can do some final cleanup work;
if the guest fails to respond to the PCI_EJECT message within one minute,
the host sends the VMBus message CHANNELMSG_RESCIND_CHANNELOFFER and
removes the PCI device forcibly.

In the case of fast device addition/removal, it's possible that the PCI
device driver is still configuring MSI-X interrupts when the guest receives
the PCI_EJECT message; the channel callback calls hv_pci_eject_device(),
which sets hpdev->state to hv_pcichild_ejecting, and schedules a work
hv_eject_device_work(); if the PCI device driver is calling
pci_alloc_irq_vectors() -> ... -> hv_compose_msi_msg(), we can break the
while loop in hv_compose_msi_msg() due to the updated hpdev->state, and
leave data->chip_data with its default value of NULL; later, when the PCI
device driver calls request_irq() -> ... -> hv_irq_unmask(), the guest
crashes in hv_arch_irq_unmask() due to data->chip_data being NULL.

Fix the issue by not testing hpdev->state in the while loop: when the
guest receives PCI_EJECT, the device is still assigned to the guest, and
the guest has one minute to finish the device removal gracefully. We don't
really need to (and we should not) test hpdev->state in the loop.

Fixes: de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  No change to the patch body.
  Added Cc:stable

 drivers/pci/controller/pci-hyperv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index b82c7cde19e66..1b11cf7391933 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -643,6 +643,11 @@ static void hv_arch_irq_unmask(struct irq_data *data)
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
 	int_desc = data->chip_data;
+	if (!int_desc) {
+		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
+			 __func__, data->irq);
+		return;
+	}
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -1911,12 +1916,6 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		hv_pci_onchannelcallback(hbus);
 		spin_unlock_irqrestore(&channel->sched_lock, flags);
 
-		if (hpdev->state == hv_pcichild_ejecting) {
-			dev_err_once(&hbus->hdev->device,
-				     "the device is being ejected\n");
-			goto enable_tasklet;
-		}
-
 		udelay(100);
 	}
 
-- 
2.25.1

