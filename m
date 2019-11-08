Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203B5F44D3
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbfKHKml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:42:41 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731756AbfKHKmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:42:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8Ag2Ij003537;
        Fri, 8 Nov 2019 02:42:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=ktw/hB3ROrbW355NANGdr0EBWMtcNysTxBNgijWME3g=;
 b=G0IXIRHzC/nvWkxQnzfI8JB+Nw+hZPgKjMt/PEfpFiNjvaEGm/b0P7uqBBj1QNjpMAwS
 KtoSnL/Tg+akV/GERRrZjmW06OB5w0tKbL0I62sOmXY6X4gjSYHxIbMu+ApbY08uCk+B
 A0xWG5pBtUv2QQGtszOLtgeo2szLB7Lm/mtDVyp/bN9R6AUF8iKxpxJ23oGPB6GdKu7F
 7jcjpWxSNg1j7qzt05CJ3w1DafseGhQcnbYWL1lBzrXlZbG5pC/GEtEeNOE0C6Qw6raH
 UpWPeVNrESwXp0muX093QqS7Vsjaoto/97aw3aQWb8IxC9hmePB18CNpWczy70E0scDd hQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w511617nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 02:42:34 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 8 Nov
 2019 02:42:33 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 8 Nov 2019 02:42:33 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 106673F703F;
        Fri,  8 Nov 2019 02:42:33 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA8AgWXF009870;
        Fri, 8 Nov 2019 02:42:32 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA8AgWhn009869;
        Fri, 8 Nov 2019 02:42:32 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>
Subject: [PATCH net 1/1] qede: fix NULL pointer deref in __qede_remove()
Date:   Fri, 8 Nov 2019 02:42:30 -0800
Message-ID: <20191108104230.9833-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_03:2019-11-07,2019-11-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While rebooting the system with SR-IOV vfs enabled leads
to below crash due to recurrence of __qede_remove() on the VF
devices (first from .shutdown() flow of the VF itself and
another from PF's .shutdown() flow executing pci_disable_sriov())

This patch adds a safeguard in __qede_remove() flow to fix this,
so that driver doesn't attempt to remove "already removed" devices.

[  194.360134] BUG: unable to handle kernel NULL pointer dereference at 00000000000008dc
[  194.360227] IP: [<ffffffffc03553c4>] __qede_remove+0x24/0x130 [qede]
[  194.360304] PGD 0
[  194.360325] Oops: 0000 [#1] SMP
[  194.360360] Modules linked in: tcp_lp fuse tun bridge stp llc devlink bonding ip_set nfnetlink ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp scsi_tgt ib_ipoib ib_umad rpcrdma sunrpc rdma_ucm ib_uverbs ib_iser rdma_cm iw_cm ib_cm libiscsi scsi_transport_iscsi dell_smbios iTCO_wdt iTCO_vendor_support dell_wmi_descriptor dcdbas vfat fat pcc_cpufreq skx_edac intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd qedr ib_core pcspkr ses enclosure joydev ipmi_ssif sg i2c_i801 lpc_ich mei_me mei wmi ipmi_si ipmi_devintf ipmi_msghandler tpm_crb acpi_pad acpi_power_meter xfs libcrc32c sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_common crc32c_intel mgag200
[  194.361044]  qede i2c_algo_bit drm_kms_helper qed syscopyarea sysfillrect nvme sysimgblt fb_sys_fops ttm nvme_core mpt3sas crc8 ptp drm pps_core ahci raid_class scsi_transport_sas libahci libata drm_panel_orientation_quirks nfit libnvdimm dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ip_tables]
[  194.361297] CPU: 51 PID: 7996 Comm: reboot Kdump: loaded Not tainted 3.10.0-1062.el7.x86_64 #1
[  194.361359] Hardware name: Dell Inc. PowerEdge MX840c/0740HW, BIOS 2.4.6 10/15/2019
[  194.361412] task: ffff9cea9b360000 ti: ffff9ceabebdc000 task.ti: ffff9ceabebdc000
[  194.361463] RIP: 0010:[<ffffffffc03553c4>]  [<ffffffffc03553c4>] __qede_remove+0x24/0x130 [qede]
[  194.361534] RSP: 0018:ffff9ceabebdfac0  EFLAGS: 00010282
[  194.361570] RAX: 0000000000000000 RBX: ffff9cd013846098 RCX: 0000000000000000
[  194.361621] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9cd013846098
[  194.361668] RBP: ffff9ceabebdfae8 R08: 0000000000000000 R09: 0000000000000000
[  194.361715] R10: 00000000bfe14201 R11: ffff9ceabfe141e0 R12: 0000000000000000
[  194.361762] R13: ffff9cd013846098 R14: 0000000000000000 R15: ffff9ceab5e48000
[  194.361810] FS:  00007f799c02d880(0000) GS:ffff9ceacb0c0000(0000) knlGS:0000000000000000
[  194.361865] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  194.361903] CR2: 00000000000008dc CR3: 0000001bdac76000 CR4: 00000000007607e0
[  194.361953] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  194.362002] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  194.362051] PKRU: 55555554
[  194.362073] Call Trace:
[  194.362109]  [<ffffffffc0355500>] qede_remove+0x10/0x20 [qede]
[  194.362180]  [<ffffffffb97d0f3e>] pci_device_remove+0x3e/0xc0
[  194.362240]  [<ffffffffb98b3c52>] __device_release_driver+0x82/0xf0
[  194.362285]  [<ffffffffb98b3ce3>] device_release_driver+0x23/0x30
[  194.362343]  [<ffffffffb97c86d4>] pci_stop_bus_device+0x84/0xa0
[  194.362388]  [<ffffffffb97c87e2>] pci_stop_and_remove_bus_device+0x12/0x20
[  194.362450]  [<ffffffffb97f153f>] pci_iov_remove_virtfn+0xaf/0x160
[  194.362496]  [<ffffffffb97f1aec>] sriov_disable+0x3c/0xf0
[  194.362534]  [<ffffffffb97f1bc3>] pci_disable_sriov+0x23/0x30
[  194.362599]  [<ffffffffc02f83c3>] qed_sriov_disable+0x5e3/0x650 [qed]
[  194.362658]  [<ffffffffb9622df6>] ? kfree+0x106/0x140
[  194.362709]  [<ffffffffc02cc0c0>] ? qed_free_stream_mem+0x70/0x90 [qed]
[  194.362754]  [<ffffffffb9622df6>] ? kfree+0x106/0x140
[  194.362803]  [<ffffffffc02cd659>] qed_slowpath_stop+0x1a9/0x1d0 [qed]
[  194.362854]  [<ffffffffc035544e>] __qede_remove+0xae/0x130 [qede]
[  194.362904]  [<ffffffffc03554e0>] qede_shutdown+0x10/0x20 [qede]
[  194.362956]  [<ffffffffb97cf90a>] pci_device_shutdown+0x3a/0x60
[  194.363010]  [<ffffffffb98b180b>] device_shutdown+0xfb/0x1f0
[  194.363066]  [<ffffffffb94b66c6>] kernel_restart_prepare+0x36/0x40
[  194.363107]  [<ffffffffb94b66e2>] kernel_restart+0x12/0x60
[  194.363146]  [<ffffffffb94b6959>] SYSC_reboot+0x229/0x260
[  194.363196]  [<ffffffffb95f200d>] ? handle_mm_fault+0x39d/0x9b0
[  194.363253]  [<ffffffffb942b621>] ? __switch_to+0x151/0x580
[  194.363304]  [<ffffffffb9b7ec28>] ? __schedule+0x448/0x9c0
[  194.363343]  [<ffffffffb94b69fe>] SyS_reboot+0xe/0x10
[  194.363387]  [<ffffffffb9b8bede>] system_call_fastpath+0x25/0x2a
[  194.363430] Code: f9 e9 37 ff ff ff 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 4c 8d af 98 00 00 00 41 54 4c 89 ef 41 89 f4 53 e8 4c e4 55 f9 <80> b8 dc 08 00 00 01 48 89 c3 4c 8d b8 c0 08 00 00 4c 8b b0 c0
[  194.363712] RIP  [<ffffffffc03553c4>] __qede_remove+0x24/0x130 [qede]
[  194.363764]  RSP <ffff9ceabebdfac0>
[  194.363791] CR2: 00000000000008dc

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 8d1c208f778f..7e1cf2ead873 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1208,8 +1208,16 @@ enum qede_remove_mode {
 static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct qede_dev *edev = netdev_priv(ndev);
-	struct qed_dev *cdev = edev->cdev;
+	struct qede_dev *edev;
+	struct qed_dev *cdev;
+
+	if (!ndev) {
+		dev_info(&pdev->dev, "Device has already been removed\n");
+		return;
+	}
+
+	edev = netdev_priv(ndev);
+	cdev = edev->cdev;
 
 	DP_INFO(edev, "Starting qede_remove\n");
 
-- 
2.18.1

