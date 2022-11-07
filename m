Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E54361F242
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiKGL5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiKGL5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:57:50 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2102.outbound.protection.outlook.com [40.107.102.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C71A81B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 03:57:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRTRBMuj9iSZTdxtL879AxYxCwvzYdzLqEZC44lKGbW9pprnX0SwFlakV1wSCV2ynFmXwFN007xFABiT1irQ3Y+SYeOxFLMdH8WE6N5F4VYfjMVhq28nnyOTpPC61DqQrZfVZx6w9J+WEJJRycxAJ6W/gTz0d3fHVF0v6OFR+2JYgehYmwF9OYTOQH24qEFteF1SoJT5ON7fcaKOnqOCXMWfFmMG6ZhrCgoAtLAUfjAw7BBnkgL4JkN3fMXrOwFP03mhOkK2s7kRDHBF+rbCeOBCGTc8ALJDyILXohhJ3d4fJ8GDVZdR/2apSBZAfjsPLJkgQqBwa6vYKpVxb2/G1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8swZbsm+fpMIJfx6MoXRVkeQTBrjl98/RXLS7L0Tu0=;
 b=GqZ26nmbEBZ02tvaMBM8IEv4RVxg0Zz9Ls5J09DMywOIBRh0OtrbAucpfF7KMcQ5Tt4iPhH3nExLNVeXvYFcieks/iYEmkine7YyaxCLM7U9pFwW9UgwFiheBQv0BYguB8gvL3hnWxA1hzLWwIy8VXAV3upbY2VDPSwVDuseFQ8AqG36+umYI+KQ6llpxANmessjeCLMPbYtnkeI15oIlGVg6s8nyrrAwsKyPHn1iwlti92CJYbe5IcTkYm82/+ri09IPuTtp2+BXrU+r8OxeCk7d7QQziY6xMnC1qkaL1IOvUEApBJ/n+/HrqZJ+sbnesD0as/9jeOUzz9ORjCE2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8swZbsm+fpMIJfx6MoXRVkeQTBrjl98/RXLS7L0Tu0=;
 b=FfiRPrSmvu4avTMhqMiynclYex3WicbNXmaqgHgLm78oJJGeK+GMq44gP+g1FIXzHBugkvYL4dFphLTVi7bBIA64YIGnmqwKiCJVd7F2grOupqyVukBTCezVGQzXC1kewDcH/HX+rgC/iQQFGsgSu2E2LXAZppu21s56RiEPqVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3971.namprd13.prod.outlook.com (2603:10b6:5:28f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 11:57:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 11:57:46 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Walter Heymans <walter.heymans@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] Documentation: nfp: update documentation
Date:   Mon,  7 Nov 2022 06:57:26 -0500
Message-Id: <20221107115726.22658-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0198.namprd13.prod.outlook.com
 (2603:10b6:208:2be::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3971:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df65d10-c6bd-4d95-ec7e-08dac0b748da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kD51P1kLYoU0RzFxZJsqzC/k5QsFdStAkhrfwmY2KcrpUgIeki+5nJMnzs1BgQrRkS4UIKeqLrpJX6x6cYQKKw55leExzv8AXcdkSM6pHVKQN/TVNzhkt2IdRnkbz5sIchB/evl3nGz7M+mib88l0bFgvrDvAW9jXrGKyjZ+3iBTM6x6zQOsn85Ar/FZxd7uVksF/b+aehPJZZPUWIk5mAdYSZvT/pAxjfBAEI1RZ2jqwNA4zDQqGzyaV/kNSKjry+/RcN5j70W7aTWfej91OiauaO/5rVa0Oh5Zfqy5B08VMUNgE9QdNJWdHyyGpw2itN4oNUyuWw5nEduZ7rw0B1ysfJY01lXgL4jh1fRmJR3Lf++hwnovRu9dfMIf17NjMJ0KnDbTdnmcfH1ynH8WjRnALq0LkltjNQj3WDNKB8WY2cAxtpqocObK9/XkWzEb9KlT3BtP6DnfluDrdKlQp6VZiZkTJEwuKxX4pvR3JviiRR3Tsjyrb71iqeuiCOWrNDiUQifQcsOcLYvYSBbGPSY9YeGpNHamdjdbVx+N5Af1NDRKQmyVEHvdfLJvDQvzvxDNzJa2cP4ehoLGNPNmJ9QjDZgeDP/Fwhc4bQV65xHr+06C9SZe63gC8TVp4Vt6YcMw5y9QeoWK7UZo1BHLpOGZC5Bp2MeSGgttE+nV1t9XhR1ety+2AgJqsRrCEZwx1z4C2gNhY1D24oNYjnTQeiiylIOUW6egDgJoqMHc19NMRqop6bZix+KaGabPzi3MBXFGPUSr0v4O1VsbDFsT0Out6yCa+KFeLijIOZbm8YCbJByIRQvEtwqxNZ1DZ3p+cGqldrn9vgQSDxt8zK4KTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39830400003)(346002)(366004)(396003)(451199015)(6506007)(66574015)(6666004)(107886003)(1076003)(2616005)(186003)(52116002)(26005)(6512007)(38350700002)(38100700002)(83380400001)(5660300002)(2906002)(15650500001)(44832011)(110136005)(54906003)(6486002)(316002)(41300700001)(8936002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnI5QzB6eThIcmw4YkZ2R24xaHFQWHlyTFN6WU1RNGQ1UmtUZU5LREhlQkJ3?=
 =?utf-8?B?b0lFbU1EemRYQkNuRExRRlJxa1ZhVWlNejhKRlk3VW1VSThmMG43dXpUaXhK?=
 =?utf-8?B?Q0k5LzRTUWo1T2krWEdOWEhUM3JNdGZUQ0VEL3NVUFRKSTJudGdkU3pRUncy?=
 =?utf-8?B?cjgyNUw0M29yUTFxVjA5WUVCV0svQzhQVThLVW05cTIxa0hEZi9YbkNCdmU4?=
 =?utf-8?B?TnF0N0lMR0xjNTBFOVBQallaamFvK0VkcCtEeGhFYXRlTmhsTzh4ZnNnaXBJ?=
 =?utf-8?B?M294cVQ0QXFlSlMrVzlSRFZUNzFuODZEUVdDWVdnL3p6WWFiUy9qczJrcWtt?=
 =?utf-8?B?TG9JK1JrTXZNZGp6VUthQXFHdnZqZkpLUDR1Z015QWFCN0Jpa1FDYXkzUzRz?=
 =?utf-8?B?Y2l2QUNqQkZMRCtoclpucVFrZm9lSlpqdVFzT2g2Y3JOTjQ1bFNxOStlbThY?=
 =?utf-8?B?Vmt3Tkl4Q1hzOS95aXY3bUVMU21kMjVDeEk0MjZLQm5HNDJuK2ZlRnRXa29M?=
 =?utf-8?B?ajVpTUp5eWg1aWFEaTlzMkVmL0lDK2U5bTBJU1pPcFBHamgzaWdjenNpNmc3?=
 =?utf-8?B?OHNyTUVtR1ZBYWZaRGhCU0FRb2E5aEZySnhmcHNJZnBSejB5OHdDOWhIdmEr?=
 =?utf-8?B?Y1ROYUc2eWsya2JqTEd4N2dwbFp4TlFhMy9lNEkrRDBtVzNKK3F5blNoV1pL?=
 =?utf-8?B?RTB1WEQ5eDB2cjQxN3NMd25SdWtVQm1lQlg2dE9lcU91SWJDc0JmMzJaRVFm?=
 =?utf-8?B?ZUI3RitPNndVcHNFTWNGb0ZZN2hWVVQvangzSlM4Qmp3enlCOVNGa1JJTWNq?=
 =?utf-8?B?V3o3cUN3V0ZQdDRBQ1ZvOGl0OVhjSmdEMGNPdllnRkFEeHlNZm1zV1VFK3Vy?=
 =?utf-8?B?RG1lTThKUDBTWkFPWXBSaHhKYU45alVNSVhyNStFcmlkOEV5dEhNcHhIQ054?=
 =?utf-8?B?eWhCVHFoVExJckZTYmpGdjlRNGVHQmFmZTJpbU9pQnJrQUV2MDZQV1hGdmgw?=
 =?utf-8?B?VmprRXM2TjN1cTcrVzBvRkk4OFZSOUcxUWVlNW84b1NnVFRaNkQwYXFSMWlY?=
 =?utf-8?B?RzZNRGRVS3BJWHQ4bFpjYmZ4MmFGRWJNODdPcXRmRHQ3UFRNeWRPRGxZTlgw?=
 =?utf-8?B?YXdkaHNMMkZnQWVjOEpua2tSZWQ5eFlWdFhlbW45eXhTcmFoYmVISWFUUnJx?=
 =?utf-8?B?dDRoU3JYOGFqRDBpN2M5VW9nQS93c2dJcWFHMEMxWHI5NG9sM25namo3b1dS?=
 =?utf-8?B?SDFFRjF3ZjZMZVJ5dzVSV05aS3FtMnVyT3pLNWU4V1ZHUWlYKzY1SURLK0hK?=
 =?utf-8?B?U01GMkp1cnNrVE9wVDVYa2ZyRm9tZm1sWS9tMGhpbnVRMnJHSFFSUmk1bmZ4?=
 =?utf-8?B?UXpuemk4ZFpQVDZyQ2FoR1Y3ZmlyZmMyMloxVFpuM1R1TVpWMWVXcTQ2N0FS?=
 =?utf-8?B?akFZaUwvWlBHUm0reXlSNEJOWks2VFVTZTNMUHZySmJqdlVjb3hKc29yYTY2?=
 =?utf-8?B?ZFNONG83R2pFS1BCWkpkYjVMK2UxVlZzVEFXYXYvUUhCTkJHQi9pRWpkbFhS?=
 =?utf-8?B?VGhtd0I0T2tFMU8zeG9RYVZmMDlTaDlUeExLc05KMVdXMkErSGF1RUJ6allt?=
 =?utf-8?B?MHgwTVlxYXBxN2FNOTVnSnVuUkxZTFF5RkFQQXFQNFZER1VwdkVRSlFhcEQ2?=
 =?utf-8?B?dkltVXBMZC9xZktZemNYcU1lQUwvdDlHYkxMOGJlT0JQeExhaHBVUE1ETjk3?=
 =?utf-8?B?TDlKUXljdnhUWHVXVHp3RUZKVUNJT2JFZ0V2RHJOTkpEdmRjS0oyUnpUS0to?=
 =?utf-8?B?K2Q5RVRjalZTNm9aNFoyc3BIRllmeWtFNU9qNkpSOFRiOCtmNXMwU3YvanZ5?=
 =?utf-8?B?d1NUMmsrTTdMNzgwcGREcXJIMVpjMzU3dlRxK09rdE5aTmtzRy9lZFRtL0JJ?=
 =?utf-8?B?cVcyalpZV2pZdXBSOVlLd0p6VkNNeUw3eTY4LzllQURxVTJJcC90eWIzYkRz?=
 =?utf-8?B?bUtCTEQ2RndrWjdKdU1TeFlCbU4rRWprTWo0Vkc4ZTVUTERGTXlRVHJaZFRn?=
 =?utf-8?B?dGR3bVQ3OWgvVE9vMHVFbDNuMDVkUHFGSVo5UE9xWUtLSFVWWEJja0g5T0Zx?=
 =?utf-8?B?TWczMEtTbGlhdHZIa3p0ZW80bE5LaUdpcHdCYVlsa3NxOTRkM05ZN0syK1cx?=
 =?utf-8?B?bEE9PQ==?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df65d10-c6bd-4d95-ec7e-08dac0b748da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 11:57:46.1451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uT4I8AXNLyTFbV/kfmBtCu4cm1s6ew5MRsRvOd0dOFDnQRBrYQab4KSDpPVYlp9WiqXG+BRbdNE+xlIEZoofB1o8qU5ABAhzNCDo/k35Mbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3971
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Walter Heymans <walter.heymans@corigine.com>

The NFP documentation is updated to include information about Corigine,
and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
with new information about where to find firmware.

Two new sections are added to expand the coverage of the documentation.
The new sections include:
- Devlink Info
- Configure Device

Signed-off-by: Walter Heymans <walter.heymans@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../device_drivers/ethernet/netronome/nfp.rst | 164 +++++++++++++++---
 1 file changed, 144 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
index ada611fb427c..d50e28dfa95d 100644
--- a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
+++ b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
@@ -1,50 +1,56 @@
 .. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 
-=============================================
-Netronome Flow Processor (NFP) Kernel Drivers
-=============================================
+===========================================
+Network Flow Processor (NFP) Kernel Drivers
+===========================================
 
-Copyright (c) 2019, Netronome Systems, Inc.
+:Copyright: |copy| 2019, Netronome Systems, Inc.
+:Copyright: |copy| 2022, Corigine, Inc.
 
 Contents
 ========
 
 - `Overview`_
 - `Acquiring Firmware`_
+- `Devlink Info`_
+- `Configure Device`_
+- `Statistics`_
 
 Overview
 ========
 
-This driver supports Netronome's line of Flow Processor devices,
-including the NFP4000, NFP5000, and NFP6000 models, which are also
-incorporated in the company's family of Agilio SmartNICs. The SR-IOV
-physical and virtual functions for these devices are supported by
-the driver.
+This driver supports Netronome and Corigine's line of Network Flow Processor
+devices, including the NFP3800, NFP4000, NFP5000, and NFP6000 models, which
+are also incorporated in the companies' family of Agilio SmartNICs. The SR-IOV
+physical and virtual functions for these devices are supported by the driver.
 
 Acquiring Firmware
 ==================
 
-The NFP4000 and NFP6000 devices require application specific firmware
-to function.  Application firmware can be located either on the host file system
+The NFP3800, NFP4000 and NFP6000 devices require application specific firmware
+to function. Application firmware can be located either on the host file system
 or in the device flash (if supported by management firmware).
 
 Firmware files on the host filesystem contain card type (`AMDA-*` string), media
-config etc.  They should be placed in `/lib/firmware/netronome` directory to
+config etc. They should be placed in `/lib/firmware/netronome` directory to
 load firmware from the host file system.
 
 Firmware for basic NIC operation is available in the upstream
 `linux-firmware.git` repository.
 
+A more comprehensive list of firmware can be downloaded from the
+`Corigine Support site <https://www.corigine.com/DPUDownload.html>`_.
+
 Firmware in NVRAM
 -----------------
 
 Recent versions of management firmware supports loading application
-firmware from flash when the host driver gets probed.  The firmware loading
+firmware from flash when the host driver gets probed. The firmware loading
 policy configuration may be used to configure this feature appropriately.
 
 Devlink or ethtool can be used to update the application firmware on the device
 flash by providing the appropriate `nic_AMDA*.nffw` file to the respective
-command.  Users need to take care to write the correct firmware image for the
+command. Users need to take care to write the correct firmware image for the
 card and media configuration to flash.
 
 Available storage space in flash depends on the card being used.
@@ -79,9 +85,9 @@ You may need to use hard instead of symbolic links on distributions
 which use old `mkinitrd` command instead of `dracut` (e.g. Ubuntu).
 
 After changing firmware files you may need to regenerate the initramfs
-image.  Initramfs contains drivers and firmware files your system may
-need to boot.  Refer to the documentation of your distribution to find
-out how to update initramfs.  Good indication of stale initramfs
+image. Initramfs contains drivers and firmware files your system may
+need to boot. Refer to the documentation of your distribution to find
+out how to update initramfs. Good indication of stale initramfs
 is system loading wrong driver or firmware on boot, but when driver is
 later reloaded manually everything works correctly.
 
@@ -89,9 +95,9 @@ Selecting firmware per device
 -----------------------------
 
 Most commonly all cards on the system use the same type of firmware.
-If you want to load specific firmware image for a specific card, you
-can use either the PCI bus address or serial number.  Driver will print
-which files it's looking for when it recognizes a NFP device::
+If you want to load a specific firmware image for a specific card, you
+can use either the PCI bus address or serial number. The driver will
+print which files it's looking for when it recognizes a NFP device::
 
     nfp: Looking for firmware file in order of priority:
     nfp:  netronome/serial-00-12-34-aa-bb-cc-10-ff.nffw: not found
@@ -106,6 +112,15 @@ Note that `serial-*` and `pci-*` files are **not** automatically included
 in initramfs, you will have to refer to documentation of appropriate tools
 to find out how to include them.
 
+Running firmware version
+------------------------
+
+The version of the loaded firmware for a particular <netdev> interface,
+(e.g. enp4s0), or an interface's port <netdev port> (e.g. enp4s0np0) can
+be displayed with the ethtool command::
+
+  $ ethtool -i <netdev>
+
 Firmware loading policy
 -----------------------
 
@@ -132,6 +147,115 @@ abi_drv_load_ifc
     Defines a list of PF devices allowed to load FW on the device.
     This variable is not currently user configurable.
 
+Devlink Info
+============
+
+The devlink info command displays the running and stored firmware versions
+on the device, serial number and board information.
+
+Devlink info command example (replace PCI address)::
+
+  $ devlink dev info pci/0000:03:00.0
+    pci/0000:03:00.0:
+      driver nfp
+      serial_number CSAAMDA2001-1003000111
+      versions:
+          fixed:
+            board.id AMDA2001-1003
+            board.rev 01
+            board.manufacture CSA
+            board.model mozart
+          running:
+            fw.mgmt 22.10.0-rc3
+            fw.cpld 0x1000003
+            fw.app nic-22.09.0
+            chip.init AMDA-2001-1003  1003000111
+          stored:
+            fw.bundle_id bspbundle_1003000111
+            fw.mgmt 22.10.0-rc3
+            fw.cpld 0x0
+            chip.init AMDA-2001-1003  1003000111
+
+Configure Device
+================
+
+This section explains how to use Agilio SmartNICs running basic NIC firmware.
+
+Configure interface link-speed
+------------------------------
+The following steps explains how to change between 10G mode and 25G mode on
+Agilio CX 2x25GbE cards. The changing of port speed must be done in order,
+port 0 (p0) must be set to 10G before port 1 (p1) may be set to 10G.
+
+Down the respective interface(s)::
+
+  $ ip link set dev <netdev port 0> down
+  $ ip link set dev <netdev port 1> down
+
+Set interface link-speed to 10G::
+
+  $ ethtool -s <netdev port 0> speed 10000
+  $ ethtool -s <netdev port 1> speed 10000
+
+Set interface link-speed to 25G::
+
+  $ ethtool -s <netdev port 0> speed 25000
+  $ ethtool -s <netdev port 1> speed 25000
+
+Reload driver for changes to take effect::
+
+  $ rmmod nfp; modprobe nfp
+
+Configure interface Maximum Transmission Unit (MTU)
+---------------------------------------------------
+
+The MTU of interfaces can temporarily be set using the iproute2, ip link or
+ifconfig tools. Note that this change will not persist. Setting this via
+Network Manager, or another appropriate OS configuration tool, is
+recommended as changes to the MTU using Network Manager can be made to
+persist.
+
+Set interface MTU to 9000 bytes::
+
+  $ ip link set dev <netdev port> mtu 9000
+
+It is the responsibility of the user or the orchestration layer to set
+appropriate MTU values when handling jumbo frames or utilizing tunnels. For
+example, if packets sent from a VM are to be encapsulated on the card and
+egress a physical port, then the MTU of the VF should be set to lower than
+that of the physical port to account for the extra bytes added by the
+additional header. If a setup is expected to see fallback traffic between
+the SmartNIC and the kernel then the user should also ensure that the PF MTU
+is appropriately set to avoid unexpected drops on this path.
+
+Configure Forward Error Correction (FEC) modes
+----------------------------------------------
+
+Agilio SmartNICs support FEC mode configuration, e.g. Auto, Firecode Base-R,
+ReedSolomon and Off modes. Each physical port's FEC mode can be set
+independently using ethtool. The supported FEC modes for an interface can
+be viewed using::
+
+  $ ethtool <netdev>
+
+The currently configured FEC mode can be viewed using::
+
+  $ ethtool --show-fec <netdev>
+
+To force the FEC mode for a particular port, auto-negotiation must be disabled
+(see the `Auto-negotiation`_ section). An example of how to set the FEC mode
+to Reed-Solomon is::
+
+  $ ethtool --set-fec <netdev> encoding rs
+
+Auto-negotiation
+----------------
+
+To change auto-negotiation settings, the link must first be put down. After the
+link is down, auto-negotiation can be enabled or disabled using::
+
+  ethtool -s <netdev> autoneg <on|off>
+
 Statistics
 ==========
 
-- 
2.30.2

