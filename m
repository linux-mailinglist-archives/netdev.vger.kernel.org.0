Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F20254B6CF
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344814AbiFNQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiFNQvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:51:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5018326D5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655225474; x=1686761474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7vqZz2Q6BNRzrro+SSxwDG9G/kWyTybGVqdCv7VKdcw=;
  b=KMwIXPMVntgXNCqPyy8FKcVOrQSVSImrZ1tk3+RPYZK/nTRRNJbS8pKv
   TvUPPHNPk1mQBRYoN9B0qGq0FRP2QhQdxd8qw/QSPJAhlvwMT6x8o3wEN
   QGTF2/yo5Dg1eo+Augjr1o7+JU3B1kFo6qDBbjW6MsSge0dq0JOfF42Sd
   sPxZOfyPiDbRVPoaq2soyhMwfZk/9nMqn85+avlhGqyq2yfN+njiUwXgU
   wrQB+jJiBv9vT5dSUT0H2Hb+zFAfOJW/EvP6TkOIqWj/+EiCkF2aw3b3j
   V8dukomKN/dbzRQWr4wYoVxKmQ04oizKNlFIhyrhme4NTvISeH7cOg/4j
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="279713501"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="279713501"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 09:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="582775196"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 09:51:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 4/4] ice: Fix memory corruption in VF driver
Date:   Tue, 14 Jun 2022 09:48:06 -0700
Message-Id: <20220614164806.1184030-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
References: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Disable VF's RX/TX queues, when it's disabled. VF can have queues enabled,
when it requests a reset. If PF driver assumes that VF is disabled,
while VF still has queues configured, VF may unmap DMA resources.
In such scenario device still can map packets to memory, which ends up
silently corrupting it.
Previously, VF driver could experience memory corruption, which lead to
crash:
[ 5119.170157] BUG: unable to handle kernel paging request at 00001b9780003237
[ 5119.170166] PGD 0 P4D 0
[ 5119.170173] Oops: 0002 [#1] PREEMPT_RT SMP PTI
[ 5119.170181] CPU: 30 PID: 427592 Comm: kworker/u96:2 Kdump: loaded Tainted: G        W I      --------- -  - 4.18.0-372.9.1.rt7.166.el8.x86_64 #1
[ 5119.170189] Hardware name: Dell Inc. PowerEdge R740/014X06, BIOS 2.3.10 08/15/2019
[ 5119.170193] Workqueue: iavf iavf_adminq_task [iavf]
[ 5119.170219] RIP: 0010:__page_frag_cache_drain+0x5/0x30
[ 5119.170238] Code: 0f 0f b6 77 51 85 f6 74 07 31 d2 e9 05 df ff ff e9 90 fe ff ff 48 8b 05 49 db 33 01 eb b4 0f 1f 80 00 00 00 00 0f 1f 44 00 00 <f0> 29 77 34 74 01 c3 48 8b 07 f6 c4 80 74 0f 0f b6 77 51 85 f6 74
[ 5119.170244] RSP: 0018:ffffa43b0bdcfd78 EFLAGS: 00010282
[ 5119.170250] RAX: ffffffff896b3e40 RBX: ffff8fb282524000 RCX: 0000000000000002
[ 5119.170254] RDX: 0000000049000000 RSI: 0000000000000000 RDI: 00001b9780003203
[ 5119.170259] RBP: ffff8fb248217b00 R08: 0000000000000022 R09: 0000000000000009
[ 5119.170262] R10: 2b849d6300000000 R11: 0000000000000020 R12: 0000000000000000
[ 5119.170265] R13: 0000000000001000 R14: 0000000000000009 R15: 0000000000000000
[ 5119.170269] FS:  0000000000000000(0000) GS:ffff8fb1201c0000(0000) knlGS:0000000000000000
[ 5119.170274] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5119.170279] CR2: 00001b9780003237 CR3: 00000008f3e1a003 CR4: 00000000007726e0
[ 5119.170283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5119.170286] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5119.170290] PKRU: 55555554
[ 5119.170292] Call Trace:
[ 5119.170298]  iavf_clean_rx_ring+0xad/0x110 [iavf]
[ 5119.170324]  iavf_free_rx_resources+0xe/0x50 [iavf]
[ 5119.170342]  iavf_free_all_rx_resources.part.51+0x30/0x40 [iavf]
[ 5119.170358]  iavf_virtchnl_completion+0xd8a/0x15b0 [iavf]
[ 5119.170377]  ? iavf_clean_arq_element+0x210/0x280 [iavf]
[ 5119.170397]  iavf_adminq_task+0x126/0x2e0 [iavf]
[ 5119.170416]  process_one_work+0x18f/0x420
[ 5119.170429]  worker_thread+0x30/0x370
[ 5119.170437]  ? process_one_work+0x420/0x420
[ 5119.170445]  kthread+0x151/0x170
[ 5119.170452]  ? set_kthread_struct+0x40/0x40
[ 5119.170460]  ret_from_fork+0x35/0x40
[ 5119.170477] Modules linked in: iavf sctp ip6_udp_tunnel udp_tunnel mlx4_en mlx4_core nfp tls vhost_net vhost vhost_iotlb tap tun xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache sunrpc intel_rapl_msr iTCO_wdt iTCO_vendor_support dell_smbios wmi_bmof dell_wmi_descriptor dcdbas kvm_intel kvm irqbypass intel_rapl_common isst_if_common skx_edac irdma nfit libnvdimm x86_pkg_temp_thermal i40e intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ib_uverbs rapl ipmi_ssif intel_cstate intel_uncore mei_me pcspkr acpi_ipmi ib_core mei lpc_ich i2c_i801 ipmi_si ipmi_devintf wmi ipmi_msghandler acpi_power_meter xfs libcrc32c sd_mod t10_pi sg mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ice ahci drm libahci crc32c_intel libata tg3 megaraid_sas
[ 5119.170613]  i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod fuse [last unloaded: iavf]
[ 5119.170627] CR2: 00001b9780003237

Fixes: ec4f5a436bdf ("ice: Check if VF is disabled for Opcode and other operations")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Co-developed-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index cd8e6b50968c..7adf9ddf129e 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -504,6 +504,11 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 	}
 
 	if (ice_is_vf_disabled(vf)) {
+		vsi = ice_get_vf_vsi(vf);
+		if (WARN_ON(!vsi))
+			return -EINVAL;
+		ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
+		ice_vsi_stop_all_rx_rings(vsi);
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
 			vf->vf_id);
 		return 0;
-- 
2.35.1

