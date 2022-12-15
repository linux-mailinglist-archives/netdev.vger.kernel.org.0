Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AD664DCBF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiLOONR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLOONO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:13:14 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2089.outbound.protection.outlook.com [40.107.247.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEDE25C57;
        Thu, 15 Dec 2022 06:13:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjwAU/vyq/kuMuDVdmkzSJGEdCRo+p4q/ydWX3JUKgr/YnzVouVKaizCEB1zoWiFmCVxWvzxWB8AspUzlIn8smQhXSIURP3yRtblQJjsunPEg4F84QwrPFN/VLy9VdwwZdxwFvyS6lyq0IuS4vi3iGQELg0d9S7+nRwk9Sz5a0oSIk6freMxQJdcVLuiaSPCussd11out+LS8bUKu6z96hVE2YVR5iROu8B9HYOt08WealdmV+85CQgF9gN+efzOQGH5KSIgwBSeGzGSw5+1+k53M7RtUVAmWv8Yyf3RulQENF7ULzvK+SYL6dU/Go+Ilm3YaEnpL0+O8h53uadiPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOI0W3EvQ+kkTLXYDUvWBJA8B+/so2jZ91ia1vCx3+A=;
 b=UyS3POVZ72n3/x1l3helWDbLNrIF9KnRaPiydr/1bMGQV8B2ad2DRaw1c2JqBdDFGiYEwUF7YY7u2nDZZj9UIHj9i75/Ny6ryK9KLfjA1q2H1XaGROyFxd2lM+WL4n5Vwpv8KzJhKC2ZVwr/MLhw/M8mSaTeYmtruULLNjKJ1jMJYOfFYSqanTEIPWxmh5I3IT8lgO1AeLfdVyPYAuwVXRA/Ac0J2t5s/0v4Q/uB7iObyV41r7PGhXec3yZOJDhk+lYHrXmH6/ybyX+CtA53AII/N5d0IqY3zEZxrROk3gO9xZ3ZLkTp5r6wG4OlBBWVOOYnPE8dyR56vQOmjswRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOI0W3EvQ+kkTLXYDUvWBJA8B+/so2jZ91ia1vCx3+A=;
 b=iPdJjQWf3Z2R5ohnuN5X30v4kal74aq95cKDeY0jIdsJ8+fG+2oWsu2RPm9TM57GjfsTayxHc2Mt8rOZW73NaxVKna003KCg0DhbFjTqAWgbtljIOOpu1unLTHoAxJmWx2qRT8hg8q3fiWPcNDPiSFVmO0XH2eZVbSxKKXU87xw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB9PR04MB8186.eurprd04.prod.outlook.com (2603:10a6:10:25f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 15 Dec
 2022 14:13:09 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%7]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 14:13:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     iommu@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] iommu/arm-smmu: don't unregister on shutdown
Date:   Thu, 15 Dec 2022 16:12:50 +0200
Message-Id: <20221215141251.3688780-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0019.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DB9PR04MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: a1dfb612-563e-4ac8-9f27-08dadea67e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5naXBHAqItxxxXTVyzHmgtP+ve4X+j1gBYY0Lg5uUnK3ZIgfj8eaZd5JICuGuUFaXDfBnmDxeWRsh5A6N3r3OvH8TVEzKCV3+aiQwPSuOBtYO7XBuRCo2Jms1ily0O9he3ZQBUZxXjzi9/v30eXYrIIFiiqmkXCsMasbv0243ozgc5lVEzflG5aqw71tJ397KyVL1+SsfKzaAlgmZrgOMfPQGE8tRHGkTi01Sn+ytMzaIVPLUbLc6Q0Y2egcqMNX99VAHWnDQFcmS1xqo0P8RUJhLVYuSLQqnkoScczMJE26AM0DGFaesQXnToHmIemTLa2wMG8bWJeDY/3ScFNKhjZDNVgvXgFaM26hLsTwIrXrhBS+ZT7nfK/EVYW+31wzK/YBN+238UXBwvxh1+Kzj5d6ZbSoUF7XTbHydeDsfDAv3+x541el3gdP94VshFXXSRGH0mgSZcHADJxp5kGJswiiSbqqKoXYvKtk0/BdcrH3HiT1tD0Wize8OdITQX8MjZSUeYhjzEA56/vsfmvQhy3FZv3rbJWMp4Ie6oFnt8axbz2nJWqlVflmKmyfQw0mT2wupFtZ1i5QAlAY6AFScy5WSHT3h3vSm3CNmauHWYEz8oSaTt2cKSOU6eGPCpqoSH2ZXqEdQTJWJ1u+on+OOF4NT3FsUpUMQ2dz452/6zXs+g2rxf/jnVwz9mvAKXmTc3RmCb5Nh0ye04d2WTWhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(186003)(1076003)(316002)(6916009)(54906003)(478600001)(6486002)(86362001)(36756003)(26005)(6506007)(6512007)(38100700002)(38350700002)(2616005)(52116002)(6666004)(41300700001)(44832011)(2906002)(5660300002)(8676002)(8936002)(4326008)(83380400001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZbQvG5Tvlnovw7mSFGMVwehrMiyRNZvSEISR/6WD4GU2pXK/YIv4dlAVWTO?=
 =?us-ascii?Q?N9iNdiW+RJH4PnIYWf2NEM6/92hpDqzWIuomY2zADgGe8FtsSeBESLnOmnpJ?=
 =?us-ascii?Q?ZvuVRX4j4CBNCSl01quxsSQAbshP1YQmCwtaiTAuJnzezKg47uCZCwgojiZW?=
 =?us-ascii?Q?z1LrPh+KCRs6x0ySmHVM/6XgfKZ/D1OSEVLwoJV2Vu2sGXYE0VhUhML6Wd9V?=
 =?us-ascii?Q?IVQYwLFE+wqcdeG61vL0LbmV+oyJZlonSLwYZtFIrIroxjxKLezhP8bWlivV?=
 =?us-ascii?Q?2B+gk9nqOil2yDZXy7srgu/0FHR/GQH+pmZ6VEozA2/qmkD5yQR7mLsVonJU?=
 =?us-ascii?Q?NqmQLGDV33shBq6nLx/Ny2kbzNSjceTagoin1z7ME40DefvZ6jMZYOcepwYJ?=
 =?us-ascii?Q?fHdc7kCWjTykVid9Ch9XIZoRRXsstmX6s7t1Jr/nCFqwNU/s987FGYswfzn4?=
 =?us-ascii?Q?B/rAnwrTOepexi8mialld8MWmuQS3lRHq5ww5KZck2glqjAE1UXrg222sr0O?=
 =?us-ascii?Q?keAeYVUife0RNr/S2ZT+6EKuEezT7jT8ohgaFuyU63s/9Z8N5W9J4848a73V?=
 =?us-ascii?Q?r9ie6lsSv+3tHhHju5BC9ldSzSLN4dQXwWAZIyHgoVRIcHBdtIfr2kfSsA3T?=
 =?us-ascii?Q?6zP7j+l7crAlszepcLqjH3egzvxsgRlfazVc95GOsxF0MfhT4g9H2Zunu4Ip?=
 =?us-ascii?Q?bgqxohe+T2kwQcd2ngUIeORNlvFMxryoQdsWjMFQ/iwD9VL+Pacg1BPk06GK?=
 =?us-ascii?Q?xt70SWuBqHDj/bRTG4XCqAcKRNapWXpMIpneEjt5YSaFjdt7C2eCgDqsnewG?=
 =?us-ascii?Q?+jJ9I4wLd1G8XxcHIxW+jLo7g6vczIuWa/57oPs4KzcR1RJ/z6L1f4DxGvOX?=
 =?us-ascii?Q?AK2B3lw3W/ObLS86ak3Way2detf5NRY5y21l1G+5Mty5ox4sjjyu8oqfKvzv?=
 =?us-ascii?Q?JaRu0tiUSR6pN5MhgqT4DjGcZ86ZzSjQBILdXLUG2aAB8HBvnkro2hlTlN6Y?=
 =?us-ascii?Q?U9zDKQcOfN+PIzoiKznnq+AE+cZxIbCj3lcL4FijdrZO4O79WrlM0wWHgxJC?=
 =?us-ascii?Q?vC0q483owK3LPxYg6SAtbuZc9zMaK7K+0OcjirhuUuSMVVeTqjk3bvk8JZDL?=
 =?us-ascii?Q?EGWjJhdZhkXvljNnV3crtMjJixRJW53fQtS9IST8s3jGfBx1x2hnE+ln9wmp?=
 =?us-ascii?Q?fZUt/rF32NTVFltF7Hf/wbd8wODZyW7lcpx6oCGIs4RfSg3wfpV3jVAAcELA?=
 =?us-ascii?Q?t/I5i1K3yCZZQbFvA8bfMyfdkmBwo9AfMgVKz8f3oM5XV1lsWNNlKi3RXLYL?=
 =?us-ascii?Q?vEFm0q2qNdiXYO363e+6+b9SPIg4j/4H0uQVQmO4Z4tG77AFhXvEIt2Mz+eV?=
 =?us-ascii?Q?AJU8FgSpnDdwX9FRB1DGdzCA6/+3VYW3yX2hhiJUy3ptc//uWllaA57wDLnA?=
 =?us-ascii?Q?iHk/weARY0dIKYMm8QKWyud9QyB4XRFxOIHiFlehN8kYfgRQ37Nro1QZGYxU?=
 =?us-ascii?Q?Ns80pAKnpUHfRqm/Kyq10T6K3xIxCkn5zbTUpnglXWmdFqHuHn+5rzvmT2FA?=
 =?us-ascii?Q?MQsTWcvcAJ7MK/BD+bDNNsvIhJlunsgJHRSeMDSHerPfnJ2aojrGOvhox7Us?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1dfb612-563e-4ac8-9f27-08dadea67e1d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:13:09.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7g7LOQnzsi0Yt6FvqyGdPEBMFzUFPwV1D2o64/4i6bqzSzxCaad8v0LQhyWDNkWw5o4UGol5qqOQTLTwv1TFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8186
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Walle says he noticed the following stack trace while performing
a shutdown with "reboot -f". He suggests he got "lucky" and just hit the
correct spot for the reboot while there was a packet transmission in
flight.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 6.1.0-rc5-00088-gf3600ff8e322 #1930
Hardware name: Kontron KBox A-230-LS (DT)
pc : iommu_get_dma_domain+0x14/0x20
lr : iommu_dma_map_page+0x9c/0x254
Call trace:
 iommu_get_dma_domain+0x14/0x20
 dma_map_page_attrs+0x1ec/0x250
 enetc_start_xmit+0x14c/0x10b0
 enetc_xmit+0x60/0xdc
 dev_hard_start_xmit+0xb8/0x210
 sch_direct_xmit+0x11c/0x420
 __dev_queue_xmit+0x354/0xb20
 ip6_finish_output2+0x280/0x5b0
 __ip6_finish_output+0x15c/0x270
 ip6_output+0x78/0x15c
 NF_HOOK.constprop.0+0x50/0xd0
 mld_sendpack+0x1bc/0x320
 mld_ifc_work+0x1d8/0x4dc
 process_one_work+0x1e8/0x460
 worker_thread+0x178/0x534
 kthread+0xe0/0xe4
 ret_from_fork+0x10/0x20
Code: d503201f f9416800 d503233f d50323bf (f9404c00)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops: Fatal exception in interrupt

This appears to be reproducible when the board has a fixed IP address,
is ping flooded from another host, and "reboot -f" is used.

The following is one more manifestation of the issue:

$ reboot -f
kvm: exiting hardware virtualization
cfg80211: failed to load regulatory.db
arm-smmu 5000000.iommu: disabling translation
sdhci-esdhc 2140000.mmc: Removing from iommu group 11
sdhci-esdhc 2150000.mmc: Removing from iommu group 12
fsl-edma 22c0000.dma-controller: Removing from iommu group 17
dwc3 3100000.usb: Removing from iommu group 9
dwc3 3110000.usb: Removing from iommu group 10
ahci-qoriq 3200000.sata: Removing from iommu group 2
fsl-qdma 8380000.dma-controller: Removing from iommu group 20
platform f080000.display: Removing from iommu group 0
etnaviv-gpu f0c0000.gpu: Removing from iommu group 1
etnaviv etnaviv: Removing from iommu group 1
caam_jr 8010000.jr: Removing from iommu group 13
caam_jr 8020000.jr: Removing from iommu group 14
caam_jr 8030000.jr: Removing from iommu group 15
caam_jr 8040000.jr: Removing from iommu group 16
fsl_enetc 0000:00:00.0: Removing from iommu group 4
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000002, GFSYNR1 0x00000429, GFSYNR2 0x00000000
fsl_enetc 0000:00:00.1: Removing from iommu group 5
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000002, GFSYNR1 0x00000429, GFSYNR2 0x00000000
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000000, GFSYNR1 0x00000429, GFSYNR2 0x00000000
fsl_enetc 0000:00:00.2: Removing from iommu group 6
fsl_enetc_mdio 0000:00:00.3: Removing from iommu group 8
mscc_felix 0000:00:00.5: Removing from iommu group 3
fsl_enetc 0000:00:00.6: Removing from iommu group 7
pcieport 0001:00:00.0: Removing from iommu group 18
arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
arm-smmu 5000000.iommu:         GFSR 0x00000002, GFSYNR0 0x00000000, GFSYNR1 0x00000429, GFSYNR2 0x00000000
pcieport 0002:00:00.0: Removing from iommu group 19
Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a8
pc : iommu_get_dma_domain+0x14/0x20
lr : iommu_dma_unmap_page+0x38/0xe0
Call trace:
 iommu_get_dma_domain+0x14/0x20
 dma_unmap_page_attrs+0x38/0x1d0
 enetc_unmap_tx_buff.isra.0+0x6c/0x80
 enetc_poll+0x170/0x910
 __napi_poll+0x40/0x1e0
 net_rx_action+0x164/0x37c
 __do_softirq+0x128/0x368
 run_ksoftirqd+0x68/0x90
 smpboot_thread_fn+0x14c/0x190
Code: d503201f f9416800 d503233f d50323bf (f9405400)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops: Fatal exception in interrupt
---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

The problem seems to be that iommu_group_remove_device() is allowed to
run with no coordination whatsoever with the shutdown procedure of the
enetc PCI device. In fact, it almost seems as if it implies that the
pci_driver :: shutdown() method is mandatory if DMA is used with an
IOMMU, otherwise this is inevitable. That was never the case; shutdown
methods are optional in device drivers.

This is the call stack that leads to iommu_group_remove_device() during
reboot:

kernel_restart
-> device_shutdown
   -> platform_shutdown
      -> arm_smmu_device_shutdown
         -> arm_smmu_device_remove
            -> iommu_device_unregister
               -> bus_for_each_dev
                  -> remove_iommu_group
                     -> iommu_release_device
                        -> iommu_group_remove_device

I don't know much about the arm_smmu driver, but
arm_smmu_device_shutdown() invoking arm_smmu_device_remove() looks
suspicious, since it causes the IOMMU device to unregister and that's
where everything starts to unravel. It forces all other devices which
depend on IOMMU groups to also point their ->shutdown() to ->remove(),
which will make reboot slower overall.

There are 2 moments relevant to this behavior. First was commit
b06c076ea962 ("Revert "iommu/arm-smmu: Make arm-smmu explicitly
non-modular"") when arm_smmu_device_shutdown() was made to run the exact
same thing as arm_smmu_device_remove(). Prior to that, there was no
iommu_device_unregister() call in arm_smmu_device_shutdown(). However,
that was benign until commit 57365a04c921 ("iommu: Move bus setup to
IOMMU device registration"), which made iommu_device_unregister() call
remove_iommu_group().

Restore the old shutdown behavior by making remove() call shutdown(),
but shutdown() does not call the remove() specific bits.

Fixes: 57365a04c921 ("iommu: Move bus setup to IOMMU device registration")
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: change Fixes: tag, slightly reword commit message

 drivers/iommu/arm/arm-smmu/arm-smmu.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 30dab1418e3f..b2cf0871a5c0 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -2188,19 +2188,16 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int arm_smmu_device_remove(struct platform_device *pdev)
+static void arm_smmu_device_shutdown(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
 	if (!smmu)
-		return -ENODEV;
+		return;
 
 	if (!bitmap_empty(smmu->context_map, ARM_SMMU_MAX_CBS))
 		dev_notice(&pdev->dev, "disabling translation\n");
 
-	iommu_device_unregister(&smmu->iommu);
-	iommu_device_sysfs_remove(&smmu->iommu);
-
 	arm_smmu_rpm_get(smmu);
 	/* Turn the thing off */
 	arm_smmu_gr0_write(smmu, ARM_SMMU_GR0_sCR0, ARM_SMMU_sCR0_CLIENTPD);
@@ -2212,12 +2209,21 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
 		clk_bulk_disable(smmu->num_clks, smmu->clks);
 
 	clk_bulk_unprepare(smmu->num_clks, smmu->clks);
-	return 0;
 }
 
-static void arm_smmu_device_shutdown(struct platform_device *pdev)
+static int arm_smmu_device_remove(struct platform_device *pdev)
 {
-	arm_smmu_device_remove(pdev);
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+
+	if (!smmu)
+		return -ENODEV;
+
+	iommu_device_unregister(&smmu->iommu);
+	iommu_device_sysfs_remove(&smmu->iommu);
+
+	arm_smmu_device_shutdown(pdev);
+
+	return 0;
 }
 
 static int __maybe_unused arm_smmu_runtime_resume(struct device *dev)
-- 
2.34.1

