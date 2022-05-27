Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD125368CD
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 00:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351786AbiE0W3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 18:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbiE0W3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 18:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3E66223E;
        Fri, 27 May 2022 15:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C7E6155B;
        Fri, 27 May 2022 22:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DA6C385A9;
        Fri, 27 May 2022 22:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653690546;
        bh=4qsLsvkF6H4ESASFTsGnucXhNyE5JDDpqP62KUKOxe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WK7ginnKSWF6l5CA7eNoFZQSFTyqip2dYeQn+z1VApkHsW1mZsWrQNFYmjwjpvhxY
         2uSZsEALzISLymmAnEeikqIMDzcIBs+vbodOV2LWow7KbWlu6DPDd6iPgv+qKE4Np6
         vXZQqulLC3TA2AC/9sxctqSuXyRcvIVMn0kwp5NlS+/Ur49ha70JEe4vH8e645UI65
         dsIOarFKhdSI2JC3E2KfRkq9yW1Bi5S2eIFx8KWi/LlIM0tuP08mYRVzZo33PCrxMS
         3RfvR3uSHn2k2hsQLKKGgXe8gAyQPZSPJwHzwbrnTnYPgM3/S1sk+I0LkM4q+ZKmMV
         ZBH1d7J4e51kw==
Date:   Fri, 27 May 2022 15:29:05 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: fix invalid structure access
Message-ID: <20220527222905.chagmk4wfresegfg@sx1>
References: <20220527110132.102192-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220527110132.102192-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27 May 13:01, Alexander Lobakin wrote:
>After pulling latest bpf-next, I started catching the following:
>
>[  577.465121] general protection fault, probably for non-canonical address 0x47454cd000065c49: 0000 [#1] SMP PTI
>[  577.465173] CPU: 0 PID: 339 Comm: kworker/0:2 Tainted: G          I       5.18.0-rc7-bpf-next+ #91
>[  577.465211] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0014.082620210524 08/26/2021
>[  577.465249] Workqueue: events work_for_cpu_fn
>[  577.465276] RIP: 0010:next_phys_dev_lag+0x1f/0x100 [mlx5_core]
>[  577.465458] Code: 00 00 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 0f 1f 44 00 00 55 41 57 41 56 53 48 8b 9f f8 02 00 00 48 8b 83 38 03 00 00 31 ed <f6> 40 34 80 0f 84 b3 00 00 00 8b 40 4c 0f c8 a8 10 0f 84 a6 00 00
>[  577.465524] RSP: 0018:ffffbd020750bd58 EFLAGS: 00010246
>[  577.465548] RAX: 47454cd000065c15 RBX: ffff9c7d97bb0310 RCX: 0000000000000003
>[  577.465577] RDX: 0000000000000000 RSI: ffff9c80e7f6a1c0 RDI: ffff9c7daaea3800
>[  577.465606] RBP: 0000000000000000 R08: ffff9c80a396b400 R09: ffff9c80a396b400
>[  577.465634] R10: ffffffff910608e8 R11: ffffffffc0d41a00 R12: ffffbd020750bd80
>[  577.465662] R13: ffff9c7d802a4b40 R14: ffffffffc0d41a00 R15: ffff9c80e7f6a1c0
>[  577.465690] FS:  0000000000000000(0000) GS:ffff9c8890a00000(0000) knlGS:0000000000000000
>[  577.465722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  577.465748] CR2: 00007fb1baf70fb8 CR3: 0000000b7a010001 CR4: 00000000007706f0
>[  577.465778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>[  577.465806] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>[  577.465834] PKRU: 55555554
>[  577.465849] Call Trace:
>[  577.465865]  <TASK>
>[  577.465881]  ? mlx5_get_next_phys_dev_lag+0x80/0x80 [mlx5_core]
>[  577.466039]  bus_find_device+0x88/0xc0
>[  577.466062]  mlx5_get_next_phys_dev_lag+0x29/0x80 [mlx5_core]
>[  577.466193]  mlx5_lag_add_mdev+0x45/0x340 [mlx5_core]
>[  577.466316]  mlx5_load+0xf3/0x3c0 [mlx5_core]
>[  577.466436]  mlx5_init_one+0x1b9/0x600 [mlx5_core]
>[  577.466557]  probe_one+0xa0/0x1c0 [mlx5_core]
>[  577.466676]  local_pci_probe+0x44/0xc0
>[  577.466701]  work_for_cpu_fn+0x1a/0x40
>[  577.466723]  process_one_work+0x1cc/0x380
>[  577.466745]  worker_thread+0x2eb/0x400
>[  577.466766]  ? worker_clr_flags+0x80/0x80
>[  577.466786]  kthread+0xcc/0x100
>[  577.466804]  ? kthread_blkcg+0x40/0x40
>[  577.466823]  ret_from_fork+0x22/0x30
>[  577.466847]  </TASK>
>[  577.466860] Modules linked in: mlx5_core(+) psample mlxfw tls pci_hyperv_intf qrtr rfkill sunrpc vfat fat intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp irdma coretemp kvm_intel ib_uverbs iTCO_wdt kvm intel_pmc_bxt irqbypass ib_core iTCO_vendor_support rapl intel_cstate ipmi_ssif ice i40e intel_uncore i2c_i801 mei_me joydev pcspkr ioatdma mei lpc_ich intel_pch_thermal i2c_smbus dca acpi_ipmi ipmi_si acpi_pad acpi_power_meter zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ast drm_vram_helper drm_ttm_helper ttm wmi pkcs8_key_parser fuse ipmi_devintf ipmi_msghandler
>[  577.468965] ---[ end trace 0000000000000000 ]---
>
>More precisely, sometimes it was nullptr deref at address 0x00000034
>and sometimes general protection fault.
>Bisect has lead to commit bc4c2f2e0179 ("net/mlx5: Lag, filter non
>compatible devices"). However, turned out that those added cap
>checks only revealed the already present problem:
>mlx5_get_next_dev() doesn't perform any checks if a device belongs
>to the mlx5 auxbus, starting dereferencing it as a structure
>embedded into &mlx5_adev right from the start. Simple debug print
>says the following:
>
>[  145.960793] irdma.gen_1 i40e.iwarp.0: next auxdev
>[  145.960800] irdma.gen_1 i40e.iwarp.0: no caps
>[  145.960804] irdma.gen_1 i40e.iwarp.1: next auxdev
>[  145.960807] irdma.gen_1 i40e.iwarp.1: no caps
>[  145.960810] irdma ice.roce.0: next auxdev
>[  145.960813] irdma ice.roce.0: no caps
>[  145.960816] irdma ice.roce.1: next auxdev
>[  145.960819] irdma ice.roce.1: no caps
>[  145.960822] irdma ice.roce.2: next auxdev
>[  145.960824] irdma ice.roce.2: no caps
>[  146.224222] irdma.gen_1 i40e.iwarp.0: next auxdev
>[  146.224228] irdma.gen_1 i40e.iwarp.0: no caps
>[  146.224231] irdma.gen_1 i40e.iwarp.1: next auxdev
>[  146.224233] irdma.gen_1 i40e.iwarp.1: no caps
>[  146.224236] irdma ice.roce.0: next auxdev
>[  146.224239] irdma ice.roce.0: no caps
>[  146.224243] irdma ice.roce.1: next auxdev
>[  146.224245] irdma ice.roce.1: no caps
>[  146.224247] irdma ice.roce.2: next auxdev
>[  146.224250] irdma ice.roce.2: no caps
>[  146.224252] auxiliary mlx5_core.eth.0: next auxdev
>[  146.735499] irdma.gen_1 i40e.iwarp.0: next auxdev
>[  146.735506] irdma.gen_1 i40e.iwarp.0: no caps
>[  146.735511] irdma.gen_1 i40e.iwarp.1: next auxdev
>[  146.735514] irdma.gen_1 i40e.iwarp.1: no caps
>[  146.735517] irdma ice.roce.0: next auxdev
>[  146.735520] irdma ice.roce.0: no caps
>[  146.735523] irdma ice.roce.1: next auxdev
>[  146.735525] irdma ice.roce.1: no caps
>[  146.735528] irdma ice.roce.2: next auxdev
>[  146.735530] irdma ice.roce.2: no caps
>[  146.735533] auxiliary mlx5_core.eth.0: next auxdev
>[  146.735537] auxiliary mlx5_core.rdma.0: next auxdev
>[  146.735540] auxiliary mlx5_core.eth.1: next auxdev
>[  146.735543] auxiliary mlx5_core.rdma.1: next auxdev
>
>It was only a good luck previously that this wasn't triggering any
>other faults. It is also not common I guess to have several auxbus
>drivers on one machine :)
>Anyways, fix this by filtering the devices passed from
>bus_find_device(). In case with mlx5, they all have "mlx5_core"
>prefix defined by %MLX5_ADEV_NAME, so use it here. The results:
>
>[  833.042660] auxiliary mlx5_core.eth.0: next auxdev
>[  833.042666] auxiliary mlx5_core.rdma.0: next auxdev
>[  833.042670] auxiliary mlx5_core.eth.1: next auxdev
>[  833.042673] auxiliary mlx5_core.rdma.1: next auxdev
>[  833.558869] auxiliary mlx5_core.eth.0: next auxdev
>[  833.558876] auxiliary mlx5_core.rdma.0: next auxdev
>[  833.558880] auxiliary mlx5_core.eth.1: next auxdev
>[  833.558882] auxiliary mlx5_core.rdma.1: next auxdev
>[  833.558886] auxiliary mlx5_core.eth.2: next auxdev
>
>Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
>Fixes: bc4c2f2e0179 ("net/mlx5: Lag, filter non compatible devices")
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/dev.c | 20 +++++++++++++++----
> 1 file changed, 16 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
>index 11f7c03ae81b..b9d13184ed7c 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
>@@ -573,16 +573,28 @@ static int _next_phys_dev(struct mlx5_core_dev *mdev,
>
> static int next_phys_dev(struct device *dev, const void *data)
> {
>-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
>-	struct mlx5_core_dev *mdev = madev->mdev;
>+	const struct mlx5_adev *madev;
>+	struct mlx5_core_dev *mdev;
>+
>+	if (!strstarts(dev_name(dev), MLX5_ADEV_NAME))
>+		return 0;
>+
>+	madev = container_of(dev, struct mlx5_adev, adev.dev);
>+	mdev = madev->mdev;

We have a similar patch that is being reviewed internally.
I don't like comparing strings to match devices. Also this could cause mlx5
unwanted aux devices to be matched, e.g mlx5e, mlx5_ib, mlx5v, etc .., since
they all share the same prefix ? yes, no ? 

We also have another patch/approach that is comparing drivers:

	if (dev->driver != curr->device->driver)
		return NULL;

But also this is under discussion.

I think the whole design of this function is wrong, it's being used to match
devices of type mlx5_core_dev which are pci devices, but it is using aux class
to lookup! It works since we always have some aux devices hanging on top of
mlx5_core pci devs and since all of them share the same wrapper structure
"mlx5_adev" we find the corresponding mdev "mlx5_core_dev" sort of correctly.

>
> 	return _next_phys_dev(mdev, data);
> }
>
> static int next_phys_dev_lag(struct device *dev, const void *data)
> {
>-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
>-	struct mlx5_core_dev *mdev = madev->mdev;
>+	const struct mlx5_adev *madev;
>+	struct mlx5_core_dev *mdev;
>+
>+	if (!strstarts(dev_name(dev), MLX5_ADEV_NAME))
>+		return 0;
>+
>+	madev = container_of(dev, struct mlx5_adev, adev.dev);
>+	mdev = madev->mdev;
>
> 	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
> 	    !MLX5_CAP_GEN(mdev, lag_master) ||
>-- 
>2.36.1
>
