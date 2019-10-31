Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE60EB997
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfJaWRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:17:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:61771 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJaWRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:17:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 15:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="199662498"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 Oct 2019 15:17:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Lyude Paul <lyude@redhat.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 1/7] igb/igc: Don't warn on fatal read failures when the device is removed
Date:   Thu, 31 Oct 2019 15:17:13 -0700
Message-Id: <20191031221719.14028-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

Fatal read errors are worth warning about, unless of course the device
was just unplugged from the machine - something that's a rather normal
occurrence when the igb/igc adapter is located on a Thunderbolt dock. So,
let's only WARN() if there's a fatal read error while the device is
still present.

This fixes the following WARN splat that's been appearing whenever I
unplug my Caldigit TS3 Thunderbolt dock from my laptop:

  igb 0000:09:00.0 enp9s0: PCIe link lost
  ------------[ cut here ]------------
  igb: Failed to read reg 0x18!
  WARNING: CPU: 7 PID: 516 at
  drivers/net/ethernet/intel/igb/igb_main.c:756 igb_rd32+0x57/0x6a [igb]
  Modules linked in: igb dca thunderbolt fuse vfat fat elan_i2c mei_wdt
  mei_hdcp i915 wmi_bmof intel_wmi_thunderbolt iTCO_wdt
  iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp joydev
  coretemp crct10dif_pclmul crc32_pclmul i2c_algo_bit ghash_clmulni_intel
  intel_cstate drm_kms_helper intel_uncore syscopyarea sysfillrect
  sysimgblt fb_sys_fops intel_rapl_perf intel_xhci_usb_role_switch mei_me
  drm roles idma64 i2c_i801 ucsi_acpi typec_ucsi mei intel_lpss_pci
  processor_thermal_device typec intel_pch_thermal intel_soc_dts_iosf
  intel_lpss int3403_thermal thinkpad_acpi wmi int340x_thermal_zone
  ledtrig_audio int3400_thermal acpi_thermal_rel acpi_pad video
  pcc_cpufreq ip_tables serio_raw nvme nvme_core crc32c_intel uas
  usb_storage e1000e i2c_dev
  CPU: 7 PID: 516 Comm: kworker/u16:3 Not tainted 5.2.0-rc1Lyude-Test+ #14
  Hardware name: LENOVO 20L8S2N800/20L8S2N800, BIOS N22ET35W (1.12 ) 04/09/2018
  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
  RIP: 0010:igb_rd32+0x57/0x6a [igb]
  Code: 87 b8 fc ff ff 48 c7 47 08 00 00 00 00 48 c7 c6 33 42 9b c0 4c 89
  c7 e8 47 45 cd dc 89 ee 48 c7 c7 43 42 9b c0 e8 c1 94 71 dc <0f> 0b eb
  08 8b 00 ff c0 75 b0 eb c8 44 89 e0 5d 41 5c c3 0f 1f 44
  RSP: 0018:ffffba5801cf7c48 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff9e7956608840 RCX: 0000000000000007
  RDX: 0000000000000000 RSI: ffffba5801cf7b24 RDI: ffff9e795e3d6a00
  RBP: 0000000000000018 R08: 000000009dec4a01 R09: ffffffff9e61018f
  R10: 0000000000000000 R11: ffffba5801cf7ae5 R12: 00000000ffffffff
  R13: ffff9e7956608840 R14: ffff9e795a6f10b0 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff9e795e3c0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000564317bc4088 CR3: 000000010e00a006 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   igb_release_hw_control+0x1a/0x30 [igb]
   igb_remove+0xc5/0x14b [igb]
   pci_device_remove+0x3b/0x93
   device_release_driver_internal+0xd7/0x17e
   pci_stop_bus_device+0x36/0x75
   pci_stop_bus_device+0x66/0x75
   pci_stop_bus_device+0x66/0x75
   pci_stop_and_remove_bus_device+0xf/0x19
   trim_stale_devices+0xc5/0x13a
   ? __pm_runtime_resume+0x6e/0x7b
   trim_stale_devices+0x103/0x13a
   ? __pm_runtime_resume+0x6e/0x7b
   trim_stale_devices+0x103/0x13a
   acpiphp_check_bridge+0xd8/0xf5
   acpiphp_hotplug_notify+0xf7/0x14b
   ? acpiphp_check_bridge+0xf5/0xf5
   acpi_device_hotplug+0x357/0x3b5
   acpi_hotplug_work_fn+0x1a/0x23
   process_one_work+0x1a7/0x296
   worker_thread+0x1a8/0x24c
   ? process_scheduled_works+0x2c/0x2c
   kthread+0xe9/0xee
   ? kthread_destroy_worker+0x41/0x41
   ret_from_fork+0x35/0x40
  ---[ end trace 252bf10352c63d22 ]---

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 47e16692b26b ("igb/igc: warn when fatal read failure happens")
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Acked-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 drivers/net/ethernet/intel/igc/igc_main.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 105b0624081a..31b9e02875cc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -753,7 +753,8 @@ u32 igb_rd32(struct e1000_hw *hw, u32 reg)
 		struct net_device *netdev = igb->netdev;
 		hw->hw_addr = NULL;
 		netdev_err(netdev, "PCIe link lost\n");
-		WARN(1, "igb: Failed to read reg 0x%x!\n", reg);
+		WARN(pci_device_is_present(igb->pdev),
+		     "igb: Failed to read reg 0x%x!\n", reg);
 	}
 
 	return value;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 63b62d74f961..8e424dfab12e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4047,7 +4047,8 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 		hw->hw_addr = NULL;
 		netif_device_detach(netdev);
 		netdev_err(netdev, "PCIe link lost, device now detached\n");
-		WARN(1, "igc: Failed to read reg 0x%x!\n", reg);
+		WARN(pci_device_is_present(igc->pdev),
+		     "igc: Failed to read reg 0x%x!\n", reg);
 	}
 
 	return value;
-- 
2.21.0

