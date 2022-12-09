Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58964818C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLILYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiLILYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:24:41 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30E186930C;
        Fri,  9 Dec 2022 03:24:38 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42F1923A;
        Fri,  9 Dec 2022 03:24:45 -0800 (PST)
Received: from [10.57.87.116] (unknown [10.57.87.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0D0C3F73B;
        Fri,  9 Dec 2022 03:24:36 -0800 (PST)
Message-ID: <d3517811-232c-592d-f973-2870bb5ec3ac@arm.com>
Date:   Fri, 9 Dec 2022 11:24:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] iommu/arm-smmu: don't unregister on shutdown
Content-Language: en-GB
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, iommu@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
References: <20221208165350.3895136-1-vladimir.oltean@nxp.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20221208165350.3895136-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-12-08 16:53, Vladimir Oltean wrote:
> Michael Walle says he noticed the following stack trace while performing
> a shutdown with "reboot -f". He suggests he got "lucky" and just hit the
> correct spot for the reboot while there was a packet transmission in
> flight.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
> CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 6.1.0-rc5-00088-gf3600ff8e322 #1930
> Hardware name: Kontron KBox A-230-LS (DT)
> pc : iommu_get_dma_domain+0x14/0x20
> lr : iommu_dma_map_page+0x9c/0x254
> Call trace:
>   iommu_get_dma_domain+0x14/0x20
>   dma_map_page_attrs+0x1ec/0x250
>   enetc_start_xmit+0x14c/0x10b0
>   enetc_xmit+0x60/0xdc
>   dev_hard_start_xmit+0xb8/0x210
>   sch_direct_xmit+0x11c/0x420
>   __dev_queue_xmit+0x354/0xb20
>   ip6_finish_output2+0x280/0x5b0
>   __ip6_finish_output+0x15c/0x270
>   ip6_output+0x78/0x15c
>   NF_HOOK.constprop.0+0x50/0xd0
>   mld_sendpack+0x1bc/0x320
>   mld_ifc_work+0x1d8/0x4dc
>   process_one_work+0x1e8/0x460
>   worker_thread+0x178/0x534
>   kthread+0xe0/0xe4
>   ret_from_fork+0x10/0x20
> Code: d503201f f9416800 d503233f d50323bf (f9404c00)
> ---[ end trace 0000000000000000 ]---
> Kernel panic - not syncing: Oops: Fatal exception in interrupt
> 
> This appears to be reproducible when the board has a fixed IP address,
> is ping flooded from another host, and "reboot -f" is used.
> 
> The following is one more manifestation of the issue:
> 
> $ reboot -f
> kvm: exiting hardware virtualization
> cfg80211: failed to load regulatory.db
> arm-smmu 5000000.iommu: disabling translation
> sdhci-esdhc 2140000.mmc: Removing from iommu group 11
> sdhci-esdhc 2150000.mmc: Removing from iommu group 12
> fsl-edma 22c0000.dma-controller: Removing from iommu group 17
> dwc3 3100000.usb: Removing from iommu group 9
> dwc3 3110000.usb: Removing from iommu group 10
> ahci-qoriq 3200000.sata: Removing from iommu group 2
> fsl-qdma 8380000.dma-controller: Removing from iommu group 20
> platform f080000.display: Removing from iommu group 0
> etnaviv-gpu f0c0000.gpu: Removing from iommu group 1
> etnaviv etnaviv: Removing from iommu group 1
> caam_jr 8010000.jr: Removing from iommu group 13
> caam_jr 8020000.jr: Removing from iommu group 14
> caam_jr 8030000.jr: Removing from iommu group 15
> caam_jr 8040000.jr: Removing from iommu group 16
> fsl_enetc 0000:00:00.0: Removing from iommu group 4
> arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
> arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000002, GFSYNR1 0x00000429, GFSYNR2 0x00000000
> fsl_enetc 0000:00:00.1: Removing from iommu group 5
> arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
> arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000002, GFSYNR1 0x00000429, GFSYNR2 0x00000000
> arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
> arm-smmu 5000000.iommu:         GFSR 0x80000002, GFSYNR0 0x00000000, GFSYNR1 0x00000429, GFSYNR2 0x00000000
> fsl_enetc 0000:00:00.2: Removing from iommu group 6
> fsl_enetc_mdio 0000:00:00.3: Removing from iommu group 8
> mscc_felix 0000:00:00.5: Removing from iommu group 3
> fsl_enetc 0000:00:00.6: Removing from iommu group 7
> pcieport 0001:00:00.0: Removing from iommu group 18
> arm-smmu 5000000.iommu: Blocked unknown Stream ID 0x429; boot with "arm-smmu.disable_bypass=0" to allow, but this may have security implications
> arm-smmu 5000000.iommu:         GFSR 0x00000002, GFSYNR0 0x00000000, GFSYNR1 0x00000429, GFSYNR2 0x00000000
> pcieport 0002:00:00.0: Removing from iommu group 19
> Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a8
> pc : iommu_get_dma_domain+0x14/0x20
> lr : iommu_dma_unmap_page+0x38/0xe0
> Call trace:
>   iommu_get_dma_domain+0x14/0x20
>   dma_unmap_page_attrs+0x38/0x1d0
>   enetc_unmap_tx_buff.isra.0+0x6c/0x80
>   enetc_poll+0x170/0x910
>   __napi_poll+0x40/0x1e0
>   net_rx_action+0x164/0x37c
>   __do_softirq+0x128/0x368
>   run_ksoftirqd+0x68/0x90
>   smpboot_thread_fn+0x14c/0x190
> Code: d503201f f9416800 d503233f d50323bf (f9405400)
> ---[ end trace 0000000000000000 ]---
> Kernel panic - not syncing: Oops: Fatal exception in interrupt
> ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---
> 
> The problem seems to be that iommu_group_remove_device() is allowed to
> run with no coordination whatsoever with the shutdown procedure of the
> enetc PCI device. In fact, it almost seems as if it implies that the
> pci_driver :: shutdown() method is mandatory if DMA is used with an
> IOMMU, otherwise this is inevitable. That was never the case; shutdown
> methods are optional in device drivers.
> 
> This is the call stack that leads to iommu_group_remove_device() during
> reboot:
> 
> kernel_restart
> -> device_shutdown
>     -> platform_shutdown
>        -> arm_smmu_device_shutdown
>           -> arm_smmu_device_remove
>              -> iommu_device_unregister
>                 -> bus_for_each_dev
>                    -> remove_iommu_group
>                       -> iommu_release_device
>                          -> iommu_group_remove_device
> 
> I don't know much about the arm_smmu driver, but
> arm_smmu_device_shutdown() invoking arm_smmu_device_remove() looks
> suspicious, since it causes the IOMMU device to unregister and that's
> where everything starts to unravel. It forces all other devices which
> depend on IOMMU groups to also point their ->shutdown() to ->remove(),
> which will make reboot slower overall.
> 
> This behavior was introduced when arm_smmu_device_shutdown() was made to
> run the exact same thing as arm_smmu_device_remove(). Prior to the
> blamed commit, there was no iommu_device_unregister() call in
> arm_smmu_device_shutdown().
> 
> Restore the old shutdown behavior by making remove() call shutdown(),
> but shutdown() does not call the remove() specific bits.
> 
> Fixes: b06c076ea962 ("Revert "iommu/arm-smmu: Make arm-smmu explicitly non-modular"")

I think that's semantically correct, but I'm pretty sure at that point 
it would have been benign in practice - the observable splat will be a 
much more recent fallout from me changing the iommu_device_unregister() 
behaviour in 57365a04c921 ("iommu: Move bus setup to IOMMU device 
registration"). The assumption therein is that unregister would only 
happen on probe failure, before the IOMMU instance is in use, or on 
module unload, which would not be allowed while active devices still 
hold module references. I overlooked that the SMMU drivers were doing 
what they do, sorry about that.

The change itself looks sensible. The point of this shutdown hook is 
simply not to leave active translations in place that might confuse 
future software after reboot/kexec; any housekeeping in the current 
kernel state is a waste of time anyway. Fancy doing the same for SMMUv3 
as well?

Thanks,
Robin.

> Reported-by: Michael Walle <michael@walle.cc>
> Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   drivers/iommu/arm/arm-smmu/arm-smmu.c | 22 ++++++++++++++--------
>   1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index 30dab1418e3f..b2cf0871a5c0 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -2188,19 +2188,16 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
>   	return 0;
>   }
>   
> -static int arm_smmu_device_remove(struct platform_device *pdev)
> +static void arm_smmu_device_shutdown(struct platform_device *pdev)
>   {
>   	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
>   
>   	if (!smmu)
> -		return -ENODEV;
> +		return;
>   
>   	if (!bitmap_empty(smmu->context_map, ARM_SMMU_MAX_CBS))
>   		dev_notice(&pdev->dev, "disabling translation\n");
>   
> -	iommu_device_unregister(&smmu->iommu);
> -	iommu_device_sysfs_remove(&smmu->iommu);
> -
>   	arm_smmu_rpm_get(smmu);
>   	/* Turn the thing off */
>   	arm_smmu_gr0_write(smmu, ARM_SMMU_GR0_sCR0, ARM_SMMU_sCR0_CLIENTPD);
> @@ -2212,12 +2209,21 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
>   		clk_bulk_disable(smmu->num_clks, smmu->clks);
>   
>   	clk_bulk_unprepare(smmu->num_clks, smmu->clks);
> -	return 0;
>   }
>   
> -static void arm_smmu_device_shutdown(struct platform_device *pdev)
> +static int arm_smmu_device_remove(struct platform_device *pdev)
>   {
> -	arm_smmu_device_remove(pdev);
> +	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
> +
> +	if (!smmu)
> +		return -ENODEV;
> +
> +	iommu_device_unregister(&smmu->iommu);
> +	iommu_device_sysfs_remove(&smmu->iommu);
> +
> +	arm_smmu_device_shutdown(pdev);
> +
> +	return 0;
>   }
>   
>   static int __maybe_unused arm_smmu_runtime_resume(struct device *dev)
