Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1778A6474B4
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLHQyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiLHQyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:54:05 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2073.outbound.protection.outlook.com [40.107.104.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA99750A7;
        Thu,  8 Dec 2022 08:54:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpXRM8GePMFcEvDjQID/Ge2JqjBMoK8GMdJrdUSPKi3BWVgFFTIBy/qsfZhLjmEROj0bW+Le0kYJzkHX2QYzXuNlv5P3WjcLd7FuUDBqJrX/KhSVgH+IBwVAPG3wgmnVHyYH0dn3Y5J7F7Gr6BTuO95eWn5NPB/S4attYmNEpRvTJ4AlwmYGqZW8HlaPGjsnkoXnK4nBgReD2XUngxL4aPaMcZ5MDEa1QvlXzfZHoLqMlbBhd3nLcNMR9i7mlfb/Cf8dQn1E12K6f84IstCHmIIaPPl5kPfOkiVNUyCtGFNE5Dtin2YpDa5VDw+Jw7WJ6Wb8W0mSQtWfeRMb0vvKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTKu0tCuGzGitF/yJVJ5uXt3kBRSWUqDJ2HUdrLi6bA=;
 b=ggGXD4SEES9fNuEfK4CFo5MSQhdzKqG2Mrosme6dpqaHqWKLt+7llHGw9d4hBoyicUmd8F1JkL0bqyhzk76Ni4hAqOycQXZ0UPnZp6w0phzC8SSXiaQzKfKpA/dfEmqdHxPz7zRENJsUxfBZyu0Oy6XItJk5sdlsxJZRucjlvXY8JMrHOXolBG6ks4yFBHlLVWd6HPAxTFt0SBcgEZiM/jxuUnp7o9zDlXhQa8szFz149P+4g5OV5aPcaYdq6jX9qy8bIuhdpumjae+MNvCP69Zf1iAT+0uGDDvMmp+upqezJxL0KTUKIbZeQqc6e29c4XOOE9ZHdBK821T/fbES+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTKu0tCuGzGitF/yJVJ5uXt3kBRSWUqDJ2HUdrLi6bA=;
 b=LPXlglCnIC/yDd5LHRAcUl+KPo9Z1KH1zhdxWVApsz1umo7JfYbV9cMY82V3mHqjAgD8EgJV2RUmpH7MQjFOR7zmHicMjZMfEDeBk3C3jhFq5qcdLE+zH3/CUAOEDFfGAfPfWflA4A8cz/bHzaPf/CYpoXvnjoflD1io7wRalPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7446.eurprd04.prod.outlook.com (2603:10a6:10:1aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 8 Dec
 2022 16:54:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 16:54:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     iommu@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH] iommu/arm-smmu: don't unregister on shutdown
Date:   Thu,  8 Dec 2022 18:53:50 +0200
Message-Id: <20221208165350.3895136-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0040.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7446:EE_
X-MS-Office365-Filtering-Correlation-Id: 884825d3-0b54-4211-69f3-08dad93cce7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WGg0P8jf5zP1hmG9DoAySsXZlGIkL7/jrdLX+qr+UVtbTZ+91V8QaU66UWWIGtmJOrDfzBTcU5AxhmJIhAYnIdJmziBkv9TuGY9x77/9aHAm/HV4tGqNuyDLy2fdjrsaeynZZch6DgF36y8GQt1c8zm3ykXvJDBaoAaqhJ45ChsCO0t/y9nQgIj+OpHe3N8kMDTP8UBO9OlTFh3jao41V/dP1kjid+Ij5/YmpP+FEvLutzSPXUyRz6ZkFYtEXOGSwG9vWj3IAWGq7q7W+QWXR5f0jabA9oSYXRlAQdnwIzBLdfiBhVOak3zhzPJyfCm8FFoOjWE9gQCpBkUaF0N+3wMsBnsU70GjOr1gfhPchQj+6i3x4b1Si2uIRqVV3bKznDFyW0z7qyYlHCMMr0O/VAgMcwYgvGgrMZaIqF9SLoGXjUzndWarXF1BVFj9Q+0N0iotYzgPxY36SkurTpKQ+kTof1so4Rze5fPlfRyk0HsZtIWC7Qxb70+gnG9XV4/WH4vzDuHJlFzzZbw4fDPcjV16NMVcHj06CP6rw5tUhLcCQZArsQpMUn9k95dIXSe3SjcsfcnNpCmVr0zMk9wXKjt/oxy4f5UQDd+ZzTKQ7iIV8WP4fsmi7UxCDLOoclPGYDBMteo/zVLSQKePbI/HjsBWt7EF30ifzMWH/c92LuG/m96D7DGimtBtBC2PJqO6WxVd+SbQhp1qW0ySQ7pWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199015)(36756003)(38350700002)(86362001)(5660300002)(2906002)(4326008)(8676002)(44832011)(83380400001)(8936002)(66556008)(478600001)(6486002)(66946007)(316002)(2616005)(1076003)(6916009)(54906003)(186003)(38100700002)(41300700001)(6506007)(66476007)(6512007)(26005)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lzRuNV8f1xErQYcWE+5+anDdo6OmVzSLgVaXiYXOvchXCGlrXW683bEaJZ+R?=
 =?us-ascii?Q?SzzXmQPI8CHOc/OugL+Qmev/1LXx1WijuPQQY/edDjQa+UJP0dUHVxiyTG+G?=
 =?us-ascii?Q?EiXYElIedURgSspM5FZLBbBz84GfFgjkSf3E3ulNEqepSmsw/URRyazI2FGh?=
 =?us-ascii?Q?jE6til2oPWKw8/Gxv+E26YVigPj6awG15QGPIGh6+WGla3+9LO6gCf5yP7Pd?=
 =?us-ascii?Q?x5BgDVX+JH7W/BO6ctqo2dP9TgNmMKLV+2aatinsQqsXxkox0oJRPRGL1W7Y?=
 =?us-ascii?Q?gog/hzEjGu/Ae31kI4Net6vcczQJ8o1fxDpEvFub9i3dsLH0UhuaEQVlLQhZ?=
 =?us-ascii?Q?D4GmVgOm5h2McXh4uA0qixsUTWq0fUuIY1CdbwNHFjFUuJiug60s/gXXvGln?=
 =?us-ascii?Q?PVDbzqyAQOvQ4W6AXCCKcNToxXvT/slKUow4PJcWXurAjWZzhLjcsWG8hUqd?=
 =?us-ascii?Q?wIYlKPkEfsZ4PFjpD629vaBBZUqOlX/Aowq511zPgLQ7hUv89A/G5CJL9pMS?=
 =?us-ascii?Q?QXBEDnwkuyjvroA/RWwGZ8xVZQ3q05RtcK6h+a18f1b0KLae+UxpyBuZV+wa?=
 =?us-ascii?Q?MyjLTla815gYWt31uMR4Q7vWKANHYNiDf74Vxg47lNreaFsi6c/Nw9ayB5+3?=
 =?us-ascii?Q?uZ2ehjo3KVH/D3pQ4FMSXX35GKJ/xnyg8e7WmDIbODCKftna0xvxtDd3YGyQ?=
 =?us-ascii?Q?XYEnU4Ch8BXFszPbYAPEA+sNaiv+MQHIjslrZTugMO6MgZNIais1Fqrg1r6k?=
 =?us-ascii?Q?Hlw2foPD6GUrjxY69dNlIU2+HWckBluiYA1bSahWbOSWdytCf8yT49F5Dlgx?=
 =?us-ascii?Q?CVmmzqJaO/Vtlfldm/URZHTKpdR9MuLBYyUsuzJitmVX1Jlq8/o88XpLQEDr?=
 =?us-ascii?Q?VarWthtrShtoBdsqtnnuk0wgbMe14IFaYyrn5aOrTgDo7P3j5nH9sZ8WAv7o?=
 =?us-ascii?Q?USX1ixCX1JgT1MFa2oT+G122/hqVTY75FSJMzWXkyvEv4DzXZX0ABtJReqiV?=
 =?us-ascii?Q?3Nyy4OqF8tVITP5shmhJ7tF3gsCf9gHRrBTiwhXcs4aVKCaVlWx+2kcegWCZ?=
 =?us-ascii?Q?lQb0BdbXD9M+W2bdCuqYJcNuupK3PjOxOTyWnt0L9+gK7tYz9kB2VaUza96n?=
 =?us-ascii?Q?ayVvzcUky3yHqzMRwBsVYCOee0y26YazVU/mkuhDAwXKmFgYy9g97wd1ehVx?=
 =?us-ascii?Q?gVWgMcefk8Ve6RAa/BEl6390Ay8erB2p2eVXzTen6lWIIohgYgWTcmBlzR4D?=
 =?us-ascii?Q?HhKKyR3L7YsaTGSk3JS6SK4lXGADQu59fEyfh6goOZGeITNv8Xmfx0Ye6bdP?=
 =?us-ascii?Q?mlJMTOjxjvNuMtvATn3F062cnRkVVWIinMwW/V3T+b87xQErw3dADNrRCxZF?=
 =?us-ascii?Q?rL3R6BMJEGuLelK4fdkMTl1nSr44AxsBWckNiV1qAjC5xQkpLDZJCM5v7Jzu?=
 =?us-ascii?Q?qCfg+in/LZIr1txrm/vMYMV6R/zSjrXD+Ge5Xzl8v8l6hCgg5n+NdbdBOu2O?=
 =?us-ascii?Q?C/9RiQWBOyVjJwejiIr8bo2BIk6DiNXUJVh5M5j7NuwrJw8r/GT8qlVo+cv/?=
 =?us-ascii?Q?Ctg4S+oKhR/g7KuDO41RdE6j6EzpP3W7WZoa1rl7OCcAFDy1WvRu2ToYlU1X?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884825d3-0b54-4211-69f3-08dad93cce7a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:54:01.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTaV3JQZ7KannHeGKGIdRYDJ+fHG130iqeWfXTvRP+t9Gn1YYJMtA9x4TS4qkuEXcxG/n6MU27PuIxiiCtD5Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

This behavior was introduced when arm_smmu_device_shutdown() was made to
run the exact same thing as arm_smmu_device_remove(). Prior to the
blamed commit, there was no iommu_device_unregister() call in
arm_smmu_device_shutdown().

Restore the old shutdown behavior by making remove() call shutdown(),
but shutdown() does not call the remove() specific bits.

Fixes: b06c076ea962 ("Revert "iommu/arm-smmu: Make arm-smmu explicitly non-modular"")
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

