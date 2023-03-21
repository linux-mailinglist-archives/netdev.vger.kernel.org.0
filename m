Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9826C3947
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCUSie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUSic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:38:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3EE1C332
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679423911; x=1710959911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uzWXw3hQ7itz03M0HrqCs7TohTrdhVXQJrTIw0imS7M=;
  b=LeH88C9ml3GBJou/GjShbqT2Sa2wvtXD6pMf0zMpTLS35+W91dQcMCFq
   qbdK3VjE+2QzBmob1Ul1zj7zcqCtPHWNL1ca0CxUGGPgEuO2Jrw/9X9dN
   ZUoInEyCvkybAJ7MmMPtvlagrzjDLrXzANKjA+k7Ga2jgsDi4Kak2IaD5
   JMuXMV3Dyco4WCuvEfxlONmWZpPRE4547jqUYEPFBkQ413VS1yMIQxjpl
   az7L5y14ZbvXuoyfLqZfdXO9WDGFkvwB7oWnilA0x337htjL0wihY8qxF
   1j46QLacwyzF9g7d6N4JndXzetehNF+Ar66MDoDo6SVaCMqL0f1JkxlZn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="339067624"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="339067624"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 11:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="684001759"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="684001759"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2023 11:38:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Piotr Raczynski <piotr.raczynski@intel.com>,
        anthony.l.nguyen@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net 1/3] ice: fix rx buffers handling for flow director packets
Date:   Tue, 21 Mar 2023 11:36:39 -0700
Message-Id: <20230321183641.2849726-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
References: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Raczynski <piotr.raczynski@intel.com>

Adding flow director filters stopped working correctly after
commit 2fba7dc5157b ("ice: Add support for XDP multi-buffer
on Rx side"). As a result, only first flow director filter
can be added, adding next filter leads to NULL pointer
dereference attached below.

Rx buffer handling and reallocation logic has been optimized,
however flow director specific traffic was not accounted for.
As a result driver handled those packets incorrectly since new
logic was based on ice_rx_ring::first_desc which was not set
in this case.

Fix this by setting struct ice_rx_ring::first_desc to next_to_clean
for flow director received packets.

[  438.544867] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  438.551840] #PF: supervisor read access in kernel mode
[  438.556978] #PF: error_code(0x0000) - not-present page
[  438.562115] PGD 7c953b2067 P4D 0
[  438.565436] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  438.569794] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.2.0-net-bug #1
[  438.577531] Hardware name: Intel Corporation M50CYP2SBSTD/M50CYP2SBSTD, BIOS SE5C620.86B.01.01.0005.2202160810 02/16/2022
[  438.588470] RIP: 0010:ice_clean_rx_irq+0x2b9/0xf20 [ice]
[  438.593860] Code: 45 89 f7 e9 ac 00 00 00 8b 4d 78 41 31 4e 10 41 09 d5 4d 85 f6 0f 84 82 00 00 00 49 8b 4e 08 41 8b 76
1c 65 8b 3d 47 36 4a 3f <48> 8b 11 48 c1 ea 36 39 d7 0f 85 a6 00 00 00 f6 41 08 02 0f 85 9c
[  438.612605] RSP: 0018:ff8c732640003ec8 EFLAGS: 00010082
[  438.617831] RAX: 0000000000000800 RBX: 00000000000007ff RCX: 0000000000000000
[  438.624957] RDX: 0000000000000800 RSI: 0000000000000000 RDI: 0000000000000000
[  438.632089] RBP: ff4ed275a2158200 R08: 00000000ffffffff R09: 0000000000000020
[  438.639222] R10: 0000000000000000 R11: 0000000000000020 R12: 0000000000001000
[  438.646356] R13: 0000000000000000 R14: ff4ed275d0daffe0 R15: 0000000000000000
[  438.653485] FS:  0000000000000000(0000) GS:ff4ed2738fa00000(0000) knlGS:0000000000000000
[  438.661563] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  438.667310] CR2: 0000000000000000 CR3: 0000007c9f0d6006 CR4: 0000000000771ef0
[  438.674444] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  438.681573] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  438.688697] PKRU: 55555554
[  438.691404] Call Trace:
[  438.693857]  <IRQ>
[  438.695877]  ? profile_tick+0x17/0x80
[  438.699542]  ice_msix_clean_ctrl_vsi+0x24/0x50 [ice]
[  438.702571] ice 0000:b1:00.0: VF 1: ctrl_vsi irq timeout
[  438.704542]  __handle_irq_event_percpu+0x43/0x1a0
[  438.704549]  handle_irq_event+0x34/0x70
[  438.704554]  handle_edge_irq+0x9f/0x240
[  438.709901] iavf 0000:b1:01.1: Failed to add Flow Director filter with status: 6
[  438.714571]  __common_interrupt+0x63/0x100
[  438.714580]  common_interrupt+0xb4/0xd0
[  438.718424] iavf 0000:b1:01.1: Rule ID: 127 dst_ip: 0.0.0.0 src_ip 0.0.0.0 UDP: dst_port 4 src_port 0
[  438.722255]  </IRQ>
[  438.722257]  <TASK>
[  438.722257]  asm_common_interrupt+0x22/0x40
[  438.722262] RIP: 0010:cpuidle_enter_state+0xc8/0x430
[  438.722267] Code: 6e e9 25 ff e8 f9 ef ff ff 8b 53 04 49 89 c5 0f 1f 44 00 00 31 ff e8 d7 f1 24 ff 45
84 ff 0f 85 57 02 00 00 fb 0f 1f 44 00 00 <45> 85 f6 0f 88 85 01 00 00 49 63 d6 48 8d 04 52 48 8d 04 82 49 8d
[  438.722269] RSP: 0018:ffffffff86003e50 EFLAGS: 00000246
[  438.784108] RAX: ff4ed2738fa00000 RBX: ffbe72a64fc01020 RCX: 0000000000000000
[  438.791234] RDX: 0000000000000000 RSI: ffffffff858d84de RDI: ffffffff85893641
[  438.798365] RBP: 0000000000000002 R08: 0000000000000002 R09: 000000003158af9d
[  438.805490] R10: 0000000000000008 R11: 0000000000000354 R12: ffffffff862365a0
[  438.812622] R13: 000000661b472a87 R14: 0000000000000002 R15: 0000000000000000
[  438.819757]  cpuidle_enter+0x29/0x40
[  438.823333]  do_idle+0x1b6/0x230
[  438.826566]  cpu_startup_entry+0x19/0x20
[  438.830492]  rest_init+0xcb/0xd0
[  438.833717]  arch_call_rest_init+0xa/0x30
[  438.837731]  start_kernel+0x776/0xb70
[  438.841396]  secondary_startup_64_no_verify+0xe5/0xeb
[  438.846449]  </TASK>

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dfd22862e926..b61dd9f01540 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1210,6 +1210,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
 			if (++ntc == cnt)
 				ntc = 0;
+			rx_ring->first_desc = ntc;
 			continue;
 		}
 
-- 
2.38.1

