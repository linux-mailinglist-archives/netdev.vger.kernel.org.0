Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D01B590442
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiHKQq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbiHKQpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:45:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A17C4C9E
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660234649; x=1691770649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MbSwMctb9d+wDCppxPYl51lc4afJPTpNAABSueXGYbU=;
  b=lWsR/i6p57Y4JNb02IQw3NK0JpIyLihMi5OJ7vzi4yKT0qFWVPoUJo20
   D151xGjjl6d5X42LgPS+3w/53rRybQp38NxYbvBXyTr9r3WzaHKZUeSms
   fNWgawy9Fa7zzCzEsmNUiryG21IWH+l84HiuHSfYBmZ2dvyRCpFm0WpVn
   +NFeCHDf2YmrYjccrskDFj5K9CoIvlxeXT7xyiaPKJINgh2qmFHXgFyCb
   imFyxqsp04ZXBu/rB4HRx3d1pQJ2Cml8tbDTeMB8VsHQKaTt/YFBJj6ys
   9RaopFvnWT3pzk89Uc0ThEfp0eMMFRcE/H4byugFDOlyfTA5utjxIExuZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="274448356"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="274448356"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 09:17:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="731928502"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Aug 2022 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 2/2] ice: Fix call trace with null VSI during VF reset
Date:   Thu, 11 Aug 2022 09:17:14 -0700
Message-Id: <20220811161714.305094-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
References: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

During stress test with attaching and detaching VF from KVM and
simultaneously changing VFs spoofcheck and trust there was a
call trace in ice_reset_vf that VF's VSI is null.

[145237.352797] WARNING: CPU: 46 PID: 840629 at drivers/net/ethernet/intel/ice/ice_vf_lib.c:508 ice_reset_vf+0x3d6/0x410 [ice]
[145237.352851] Modules linked in: ice(E) vfio_pci vfio_pci_core vfio_virqfd vfio_iommu_type1 vfio iavf dm_mod xt_CHECKSUM xt_MASQUERADE
xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun
 bridge stp llc sunrpc intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTC
O_vendor_support irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel rapl ipmi_si intel_cstate ipmi_devintf joydev intel_uncore m
ei_me ipmi_msghandler i2c_i801 pcspkr mei lpc_ich ioatdma i2c_smbus acpi_pad acpi_power_meter ip_tables xfs libcrc32c i2c_algo_bit drm_sh
mem_helper drm_kms_helper sd_mod t10_pi crc64_rocksoft syscopyarea crc64 sysfillrect sg sysimgblt fb_sys_fops drm i40e ixgbe ahci libahci
 libata crc32c_intel mdio dca wmi fuse [last unloaded: ice]
[145237.352917] CPU: 46 PID: 840629 Comm: kworker/46:2 Tainted: G S      W I E     5.19.0-rc6+ #24
[145237.352921] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS SE5C610.86B.01.01.0008.021120151325 02/11/2015
[145237.352923] Workqueue: ice ice_service_task [ice]
[145237.352948] RIP: 0010:ice_reset_vf+0x3d6/0x410 [ice]
[145237.352984] Code: 30 ec f3 cc e9 28 fd ff ff 0f b7 4b 50 48 c7 c2 48 19 9c c0 4c 89 ee 48 c7 c7 30 fe 9e c0 e8 d1 21 9d cc 31 c0 e9 a
9 fe ff ff <0f> 0b b8 ea ff ff ff e9 c1 fc ff ff 0f 0b b8 fb ff ff ff e9 91 fe
[145237.352987] RSP: 0018:ffffb453e257fdb8 EFLAGS: 00010246
[145237.352990] RAX: ffff8bd0040181c0 RBX: ffff8be68db8f800 RCX: 0000000000000000
[145237.352991] RDX: 000000000000ffff RSI: 0000000000000000 RDI: ffff8be68db8f800
[145237.352993] RBP: ffff8bd0040181c0 R08: 0000000000001000 R09: ffff8bcfd520e000
[145237.352995] R10: 0000000000000000 R11: 00008417b5ab0bc0 R12: 0000000000000005
[145237.352996] R13: ffff8bcee061c0d0 R14: ffff8bd004019640 R15: 0000000000000000
[145237.352998] FS:  0000000000000000(0000) GS:ffff8be5dfb00000(0000) knlGS:0000000000000000
[145237.353000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[145237.353002] CR2: 00007fd81f651d68 CR3: 0000001a0fe10001 CR4: 00000000001726e0
[145237.353003] Call Trace:
[145237.353008]  <TASK>
[145237.353011]  ice_process_vflr_event+0x8d/0xb0 [ice]
[145237.353049]  ice_service_task+0x79f/0xef0 [ice]
[145237.353074]  process_one_work+0x1c8/0x390
[145237.353081]  ? process_one_work+0x390/0x390
[145237.353084]  worker_thread+0x30/0x360
[145237.353087]  ? process_one_work+0x390/0x390
[145237.353090]  kthread+0xe8/0x110
[145237.353094]  ? kthread_complete_and_exit+0x20/0x20
[145237.353097]  ret_from_fork+0x22/0x30
[145237.353103]  </TASK>

Remove WARN_ON() from check if VSI is null in ice_reset_vf.
Add "VF is already removed\n" in dev_dbg().

This WARN_ON() is unnecessary and causes call trace, despite that
call trace, driver still works. There is no need for this warn
because this piece of code is responsible for disabling VF's Tx/Rx
queues when VF is disabled, but when VF is already removed there
is no need to do reset or disable queues.

Fixes: efe41860008e ("ice: Fix memory corruption in VF driver")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 8fd7c3e37f5e..76f70fe1d998 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -571,8 +571,10 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 
 	if (ice_is_vf_disabled(vf)) {
 		vsi = ice_get_vf_vsi(vf);
-		if (WARN_ON(!vsi))
+		if (!vsi) {
+			dev_dbg(dev, "VF is already removed\n");
 			return -EINVAL;
+		}
 		ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
 		ice_vsi_stop_all_rx_rings(vsi);
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
-- 
2.35.1

