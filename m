Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90965914BE
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbiHLRX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237635AbiHLRXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:23:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA2FB248F
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660324998; x=1691860998;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnnyAAL+hQShI73CgRD45ZbG+aSwmAj5DUC9dvEbflc=;
  b=NuKCgaoH5mchCE8cKxKk5ZIrc2ZBshyNzUoOcrIeIrFFWPo4JUxKtDjL
   K1/9joO8M2OQdSOJb/+j1hgCAVkR7eHXewWaOOzDtwYGQlnek7mWqsZAT
   ivfA4EtX5kDXxE/qaBFnhxFbWMQYRfRM9YxOtnu1t8sEWffkITnv1tfrw
   gzJFLwqtGPtKVulHQLnCNyvzSj3LewvxWQJRl6RMhTcAguQqPkB50Y56n
   j37anrcESSGGujJkLRuev3G9DoFZZ4zU12FFqlI4PSN8hWUnUvybTFmpE
   Kk95abLXGYgS76Q7Gtg1VjYrzeI5pMNzfdrT6aLkHSinFtJmbF4eL/Zfv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="290396034"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="290396034"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 10:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="634716854"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2022 10:23:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 2/4] iavf: Fix NULL pointer dereference in iavf_get_link_ksettings
Date:   Fri, 12 Aug 2022 10:23:07 -0700
Message-Id: <20220812172309.853230-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
References: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix possible NULL pointer dereference, due to freeing of adapter->vf_res
in iavf_init_get_resources. Previous commit introduced a regression,
where receiving IAVF_ERR_ADMIN_QUEUE_NO_WORK from iavf_get_vf_config
would free adapter->vf_res. However, netdev is still registered, so
ethtool_ops can be called. Calling iavf_get_link_ksettings with no vf_res,
will result with:
[ 9385.242676] BUG: kernel NULL pointer dereference, address: 0000000000000008
[ 9385.242683] #PF: supervisor read access in kernel mode
[ 9385.242686] #PF: error_code(0x0000) - not-present page
[ 9385.242690] PGD 0 P4D 0
[ 9385.242696] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
[ 9385.242701] CPU: 6 PID: 3217 Comm: pmdalinux Kdump: loaded Tainted: G S          E     5.18.0-04958-ga54ce3703613-dirty #1
[ 9385.242708] Hardware name: Dell Inc. PowerEdge R730/0WCJNT, BIOS 2.11.0 11/02/2019
[ 9385.242710] RIP: 0010:iavf_get_link_ksettings+0x29/0xd0 [iavf]
[ 9385.242745] Code: 00 0f 1f 44 00 00 b8 01 ef ff ff 48 c7 46 30 00 00 00 00 48 c7 46 38 00 00 00 00 c6 46 0b 00 66 89 46 08 48 8b 87 68 0e 00 00 <f6> 40 08 80 75 50 8b 87 5c 0e 00 00 83 f8 08 74 7a 76 1d 83 f8 20
[ 9385.242749] RSP: 0018:ffffc0560ec7fbd0 EFLAGS: 00010246
[ 9385.242755] RAX: 0000000000000000 RBX: ffffc0560ec7fc08 RCX: 0000000000000000
[ 9385.242759] RDX: ffffffffc0ad4550 RSI: ffffc0560ec7fc08 RDI: ffffa0fc66674000
[ 9385.242762] RBP: 00007ffd1fb2bf50 R08: b6a2d54b892363ee R09: ffffa101dc14fb00
[ 9385.242765] R10: 0000000000000000 R11: 0000000000000004 R12: ffffa0fc66674000
[ 9385.242768] R13: 0000000000000000 R14: ffffa0fc66674000 R15: 00000000ffffffa1
[ 9385.242771] FS:  00007f93711a2980(0000) GS:ffffa0fad72c0000(0000) knlGS:0000000000000000
[ 9385.242775] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9385.242778] CR2: 0000000000000008 CR3: 0000000a8e61c003 CR4: 00000000003706e0
[ 9385.242781] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9385.242784] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 9385.242787] Call Trace:
[ 9385.242791]  <TASK>
[ 9385.242793]  ethtool_get_settings+0x71/0x1a0
[ 9385.242814]  __dev_ethtool+0x426/0x2f40
[ 9385.242823]  ? slab_post_alloc_hook+0x4f/0x280
[ 9385.242836]  ? kmem_cache_alloc_trace+0x15d/0x2f0
[ 9385.242841]  ? dev_ethtool+0x59/0x170
[ 9385.242848]  dev_ethtool+0xa7/0x170
[ 9385.242856]  dev_ioctl+0xc3/0x520
[ 9385.242866]  sock_do_ioctl+0xa0/0xe0
[ 9385.242877]  sock_ioctl+0x22f/0x320
[ 9385.242885]  __x64_sys_ioctl+0x84/0xc0
[ 9385.242896]  do_syscall_64+0x3a/0x80
[ 9385.242904]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 9385.242918] RIP: 0033:0x7f93702396db
[ 9385.242923] Code: 73 01 c3 48 8b 0d ad 57 38 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 7d 57 38 00 f7 d8 64 89 01 48
[ 9385.242927] RSP: 002b:00007ffd1fb2bf18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 9385.242932] RAX: ffffffffffffffda RBX: 000055671b1d2fe0 RCX: 00007f93702396db
[ 9385.242935] RDX: 00007ffd1fb2bf20 RSI: 0000000000008946 RDI: 0000000000000007
[ 9385.242937] RBP: 00007ffd1fb2bf20 R08: 0000000000000003 R09: 0030763066307330
[ 9385.242940] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd1fb2bf80
[ 9385.242942] R13: 0000000000000007 R14: 0000556719f6de90 R15: 00007ffd1fb2c1b0
[ 9385.242948]  </TASK>
[ 9385.242949] Modules linked in: iavf(E) xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nft_compat nf_nat_tftp nft_objref nf_conntrack_tftp bridge stp llc nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables rfkill nfnetlink vfat fat irdma ib_uverbs ib_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support ice irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel rapl i40e pcspkr intel_cstate joydev mei_me intel_uncore mxm_wmi mei ipmi_ssif lpc_ich ipmi_si acpi_power_meter xfs libcrc32c mgag200 i2c_algo_bit drm_shmem_helper drm_kms_helper sd_mod t10_pi crc64_rocksoft crc64 syscopyarea sg sysfillrect sysimgblt fb_sys_fops drm ixgbe ahci libahci libata crc32c_intel mdio dca wmi dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
[ 9385.243065]  [last unloaded: iavf]

Dereference happens in if (ADV_LINK_SUPPORT(adapter)) statement

Fixes: 209f2f9c7181 ("iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 negotiation")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
This was initially sent [1] and has had the -EAGAIN removed. It was an
extra safety check, where the adjusted goto (alone) has been tested to
resolve the issue.

[1] https://lore.kernel.org/netdev/20220712182636.53a957cc@kernel.org/

 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 45d097a164ad..6aa3eff0da2c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2367,7 +2367,7 @@ static void iavf_init_get_resources(struct iavf_adapter *adapter)
 	err = iavf_get_vf_config(adapter);
 	if (err == -EALREADY) {
 		err = iavf_send_vf_config_msg(adapter);
-		goto err_alloc;
+		goto err;
 	} else if (err == -EINVAL) {
 		/* We only get -EINVAL if the device is in a very bad
 		 * state or if we've been disabled for previous bad
-- 
2.35.1

