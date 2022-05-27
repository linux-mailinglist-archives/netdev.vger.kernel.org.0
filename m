Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B574B535EE2
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 13:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351150AbiE0LC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 07:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348937AbiE0LCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 07:02:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C4412AE0;
        Fri, 27 May 2022 04:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653649334; x=1685185334;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n4db8VHHL6r1idQnACORSXlcl38Almu2Snr1jSt3r64=;
  b=M3y/dV6DZc6Y2xlTji20S/Q4E0T7hT49gC/1Y2Y+I6qv61QPcbWubGM1
   E0DA+PKCx/SEu/HtWTznZTKypcH9tuItRqSJ3flqV+7izh4bxyFmVOeoK
   NEw9o7xQ3FJA7WXhFoDVnXajNba1HWjXLxhxl7zYBAjgy/p4RKa6IfE68
   DT4/gJB9LUiRqyncOP0WWlsZd9X7k2HwJEuqjdF8Etn9B7+A672rCTx4a
   Numd42xT2eBcwPPxk5ygd5s1Fqeb6gaQc/rfjOs6RLAd0/6psZVmQPFEj
   G/n7MdCKqxz+laHR8eYqhlBU1n3A2LumN/cF9ShDfHuvzCyiXVQF6lFkV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="254325958"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="254325958"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 04:02:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="677939314"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2022 04:02:12 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 24RB2Au6016118;
        Fri, 27 May 2022 12:02:10 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Mark Bloch <mbloch@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net] net/mlx5: fix invalid structure access
Date:   Fri, 27 May 2022 13:01:32 +0200
Message-Id: <20220527110132.102192-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After pulling latest bpf-next, I started catching the following:

[  577.465121] general protection fault, probably for non-canonical address 0x47454cd000065c49: 0000 [#1] SMP PTI
[  577.465173] CPU: 0 PID: 339 Comm: kworker/0:2 Tainted: G          I       5.18.0-rc7-bpf-next+ #91
[  577.465211] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0014.082620210524 08/26/2021
[  577.465249] Workqueue: events work_for_cpu_fn
[  577.465276] RIP: 0010:next_phys_dev_lag+0x1f/0x100 [mlx5_core]
[  577.465458] Code: 00 00 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 0f 1f 44 00 00 55 41 57 41 56 53 48 8b 9f f8 02 00 00 48 8b 83 38 03 00 00 31 ed <f6> 40 34 80 0f 84 b3 00 00 00 8b 40 4c 0f c8 a8 10 0f 84 a6 00 00
[  577.465524] RSP: 0018:ffffbd020750bd58 EFLAGS: 00010246
[  577.465548] RAX: 47454cd000065c15 RBX: ffff9c7d97bb0310 RCX: 0000000000000003
[  577.465577] RDX: 0000000000000000 RSI: ffff9c80e7f6a1c0 RDI: ffff9c7daaea3800
[  577.465606] RBP: 0000000000000000 R08: ffff9c80a396b400 R09: ffff9c80a396b400
[  577.465634] R10: ffffffff910608e8 R11: ffffffffc0d41a00 R12: ffffbd020750bd80
[  577.465662] R13: ffff9c7d802a4b40 R14: ffffffffc0d41a00 R15: ffff9c80e7f6a1c0
[  577.465690] FS:  0000000000000000(0000) GS:ffff9c8890a00000(0000) knlGS:0000000000000000
[  577.465722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  577.465748] CR2: 00007fb1baf70fb8 CR3: 0000000b7a010001 CR4: 00000000007706f0
[  577.465778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  577.465806] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  577.465834] PKRU: 55555554
[  577.465849] Call Trace:
[  577.465865]  <TASK>
[  577.465881]  ? mlx5_get_next_phys_dev_lag+0x80/0x80 [mlx5_core]
[  577.466039]  bus_find_device+0x88/0xc0
[  577.466062]  mlx5_get_next_phys_dev_lag+0x29/0x80 [mlx5_core]
[  577.466193]  mlx5_lag_add_mdev+0x45/0x340 [mlx5_core]
[  577.466316]  mlx5_load+0xf3/0x3c0 [mlx5_core]
[  577.466436]  mlx5_init_one+0x1b9/0x600 [mlx5_core]
[  577.466557]  probe_one+0xa0/0x1c0 [mlx5_core]
[  577.466676]  local_pci_probe+0x44/0xc0
[  577.466701]  work_for_cpu_fn+0x1a/0x40
[  577.466723]  process_one_work+0x1cc/0x380
[  577.466745]  worker_thread+0x2eb/0x400
[  577.466766]  ? worker_clr_flags+0x80/0x80
[  577.466786]  kthread+0xcc/0x100
[  577.466804]  ? kthread_blkcg+0x40/0x40
[  577.466823]  ret_from_fork+0x22/0x30
[  577.466847]  </TASK>
[  577.466860] Modules linked in: mlx5_core(+) psample mlxfw tls pci_hyperv_intf qrtr rfkill sunrpc vfat fat intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp irdma coretemp kvm_intel ib_uverbs iTCO_wdt kvm intel_pmc_bxt irqbypass ib_core iTCO_vendor_support rapl intel_cstate ipmi_ssif ice i40e intel_uncore i2c_i801 mei_me joydev pcspkr ioatdma mei lpc_ich intel_pch_thermal i2c_smbus dca acpi_ipmi ipmi_si acpi_pad acpi_power_meter zram xfs crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ast drm_vram_helper drm_ttm_helper ttm wmi pkcs8_key_parser fuse ipmi_devintf ipmi_msghandler
[  577.468965] ---[ end trace 0000000000000000 ]---

More precisely, sometimes it was nullptr deref at address 0x00000034
and sometimes general protection fault.
Bisect has lead to commit bc4c2f2e0179 ("net/mlx5: Lag, filter non
compatible devices"). However, turned out that those added cap
checks only revealed the already present problem:
mlx5_get_next_dev() doesn't perform any checks if a device belongs
to the mlx5 auxbus, starting dereferencing it as a structure
embedded into &mlx5_adev right from the start. Simple debug print
says the following:

[  145.960793] irdma.gen_1 i40e.iwarp.0: next auxdev
[  145.960800] irdma.gen_1 i40e.iwarp.0: no caps
[  145.960804] irdma.gen_1 i40e.iwarp.1: next auxdev
[  145.960807] irdma.gen_1 i40e.iwarp.1: no caps
[  145.960810] irdma ice.roce.0: next auxdev
[  145.960813] irdma ice.roce.0: no caps
[  145.960816] irdma ice.roce.1: next auxdev
[  145.960819] irdma ice.roce.1: no caps
[  145.960822] irdma ice.roce.2: next auxdev
[  145.960824] irdma ice.roce.2: no caps
[  146.224222] irdma.gen_1 i40e.iwarp.0: next auxdev
[  146.224228] irdma.gen_1 i40e.iwarp.0: no caps
[  146.224231] irdma.gen_1 i40e.iwarp.1: next auxdev
[  146.224233] irdma.gen_1 i40e.iwarp.1: no caps
[  146.224236] irdma ice.roce.0: next auxdev
[  146.224239] irdma ice.roce.0: no caps
[  146.224243] irdma ice.roce.1: next auxdev
[  146.224245] irdma ice.roce.1: no caps
[  146.224247] irdma ice.roce.2: next auxdev
[  146.224250] irdma ice.roce.2: no caps
[  146.224252] auxiliary mlx5_core.eth.0: next auxdev
[  146.735499] irdma.gen_1 i40e.iwarp.0: next auxdev
[  146.735506] irdma.gen_1 i40e.iwarp.0: no caps
[  146.735511] irdma.gen_1 i40e.iwarp.1: next auxdev
[  146.735514] irdma.gen_1 i40e.iwarp.1: no caps
[  146.735517] irdma ice.roce.0: next auxdev
[  146.735520] irdma ice.roce.0: no caps
[  146.735523] irdma ice.roce.1: next auxdev
[  146.735525] irdma ice.roce.1: no caps
[  146.735528] irdma ice.roce.2: next auxdev
[  146.735530] irdma ice.roce.2: no caps
[  146.735533] auxiliary mlx5_core.eth.0: next auxdev
[  146.735537] auxiliary mlx5_core.rdma.0: next auxdev
[  146.735540] auxiliary mlx5_core.eth.1: next auxdev
[  146.735543] auxiliary mlx5_core.rdma.1: next auxdev

It was only a good luck previously that this wasn't triggering any
other faults. It is also not common I guess to have several auxbus
drivers on one machine :)
Anyways, fix this by filtering the devices passed from
bus_find_device(). In case with mlx5, they all have "mlx5_core"
prefix defined by %MLX5_ADEV_NAME, so use it here. The results:

[  833.042660] auxiliary mlx5_core.eth.0: next auxdev
[  833.042666] auxiliary mlx5_core.rdma.0: next auxdev
[  833.042670] auxiliary mlx5_core.eth.1: next auxdev
[  833.042673] auxiliary mlx5_core.rdma.1: next auxdev
[  833.558869] auxiliary mlx5_core.eth.0: next auxdev
[  833.558876] auxiliary mlx5_core.rdma.0: next auxdev
[  833.558880] auxiliary mlx5_core.eth.1: next auxdev
[  833.558882] auxiliary mlx5_core.rdma.1: next auxdev
[  833.558886] auxiliary mlx5_core.eth.2: next auxdev

Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
Fixes: bc4c2f2e0179 ("net/mlx5: Lag, filter non compatible devices")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 11f7c03ae81b..b9d13184ed7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -573,16 +573,28 @@ static int _next_phys_dev(struct mlx5_core_dev *mdev,
 
 static int next_phys_dev(struct device *dev, const void *data)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	const struct mlx5_adev *madev;
+	struct mlx5_core_dev *mdev;
+
+	if (!strstarts(dev_name(dev), MLX5_ADEV_NAME))
+		return 0;
+
+	madev = container_of(dev, struct mlx5_adev, adev.dev);
+	mdev = madev->mdev;
 
 	return _next_phys_dev(mdev, data);
 }
 
 static int next_phys_dev_lag(struct device *dev, const void *data)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	const struct mlx5_adev *madev;
+	struct mlx5_core_dev *mdev;
+
+	if (!strstarts(dev_name(dev), MLX5_ADEV_NAME))
+		return 0;
+
+	madev = container_of(dev, struct mlx5_adev, adev.dev);
+	mdev = madev->mdev;
 
 	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(mdev, lag_master) ||
-- 
2.36.1

