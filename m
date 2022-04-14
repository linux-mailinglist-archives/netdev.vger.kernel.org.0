Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26C50190D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239857AbiDNQuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiDNQuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:50:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B94CEE1C
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649953094; x=1681489094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pvL0QG/BjNxa73jcx8MA4Gn48j/d4XIl0FJo0ambHYA=;
  b=M34lci05fDJSGaWwSpWHP0jWhvdwx7bDfBKCmO0GIyZ3ASsY9oc6niF6
   PonQT7M84Z/hiJNqfVErJqViknlmA5sLkZM7ckNRUI2mgUIuwmOo+izSW
   JhOb0WXzOdnX6/2GACSRfp+sU4eAKiBDMRbEwIQd5pOA4F7TqCX8nU8r7
   Af6jIvSg/jyROBZ5M5wVSLQx+sn5uF3Zwxgzl/wAEh4mRu9SSG5nz+h0q
   /NHcDl7PdXE7AXpU6Qvk62DJRa80OpKLXa6ao+1gLHR78XhKi+zEEdVxi
   +N7Q9fai+a6NcT8NGcH0VTc6RrJ0iq4GHmFE3qzcdIoN7o7Gd5wi2saTU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="242901619"
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="242901619"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 09:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,260,1643702400"; 
   d="scan'208";a="526970485"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2022 09:18:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 3/4] ice: fix crash in switchdev mode
Date:   Thu, 14 Apr 2022 09:15:21 -0700
Message-Id: <20220414161522.2320694-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
References: <20220414161522.2320694-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Below steps end up with crash:
- modprobe ice
- devlink dev eswitch set $PF1_PCI mode switchdev
- echo 64 > /sys/class/net/$PF1/device/sriov_numvfs
- rmmod ice

Calling ice_eswitch_port_start_xmit while the process of removing
VFs is in progress ends up with NULL pointer dereference.
That's because PR netdev is not released but some resources
are already freed. Fix it by checking if ICE_VF_DIS bit is set.

Call trace:
[ 1379.595146] BUG: kernel NULL pointer dereference, address: 0000000000000040
[ 1379.595284] #PF: supervisor read access in kernel mode
[ 1379.595410] #PF: error_code(0x0000) - not-present page
[ 1379.595535] PGD 0 P4D 0
[ 1379.595657] Oops: 0000 [#1] PREEMPT SMP PTI
[ 1379.595783] CPU: 4 PID: 974 Comm: NetworkManager Kdump: loaded Tainted: G           OE     5.17.0-rc8_mrq_dev-queue+ #12
[ 1379.595926] Hardware name: Intel Corporation S1200SP/S1200SP, BIOS S1200SP.86B.03.01.0042.013020190050 01/30/2019
[ 1379.596063] RIP: 0010:ice_eswitch_port_start_xmit+0x46/0xd0 [ice]
[ 1379.596292] Code: c7 c8 09 00 00 e8 9a c9 fc ff 84 c0 0f 85 82 00 00 00 4c 89 e7 e8 ca 70 fe ff 48 8b 7d 58 48 89 c3 48 85 ff 75 5e 48 8b 53 20 <8b> 42 40 85 c0 74 78 8d 48 01 f0 0f b1 4a 40 75 f2 0f b6 95 84 00
[ 1379.596456] RSP: 0018:ffffaba0c0d7bad0 EFLAGS: 00010246
[ 1379.596584] RAX: ffff969c14c71680 RBX: ffff969c14c71680 RCX: 000100107a0f0000
[ 1379.596715] RDX: 0000000000000000 RSI: ffff969b9d631000 RDI: 0000000000000000
[ 1379.596846] RBP: ffff969c07b46500 R08: ffff969becfca8ac R09: 0000000000000001
[ 1379.596977] R10: 0000000000000004 R11: ffffaba0c0d7bbec R12: ffff969b9d631000
[ 1379.597106] R13: ffffffffc08357a0 R14: ffff969c07b46500 R15: ffff969b9d631000
[ 1379.597237] FS:  00007f72c0e25c80(0000) GS:ffff969f13500000(0000) knlGS:0000000000000000
[ 1379.597414] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1379.597562] CR2: 0000000000000040 CR3: 000000012b316006 CR4: 00000000003706e0
[ 1379.597713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1379.597863] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1379.598015] Call Trace:
[ 1379.598153]  <TASK>
[ 1379.598294]  dev_hard_start_xmit+0xd9/0x220
[ 1379.598444]  sch_direct_xmit+0x8a/0x340
[ 1379.598592]  __dev_queue_xmit+0xa3c/0xd30
[ 1379.598739]  ? packet_parse_headers+0xb4/0xf0
[ 1379.598890]  packet_sendmsg+0xa15/0x1620
[ 1379.599038]  ? __check_object_size+0x46/0x140
[ 1379.599186]  sock_sendmsg+0x5e/0x60
[ 1379.599330]  ____sys_sendmsg+0x22c/0x270
[ 1379.599474]  ? import_iovec+0x17/0x20
[ 1379.599622]  ? sendmsg_copy_msghdr+0x59/0x90
[ 1379.599771]  ___sys_sendmsg+0x81/0xc0
[ 1379.599917]  ? __pollwait+0xd0/0xd0
[ 1379.600061]  ? preempt_count_add+0x68/0xa0
[ 1379.600210]  ? _raw_write_lock_irq+0x1a/0x40
[ 1379.600369]  ? ep_done_scan+0xc9/0x110
[ 1379.600494]  ? _raw_spin_unlock_irqrestore+0x25/0x40
[ 1379.600622]  ? preempt_count_add+0x68/0xa0
[ 1379.600747]  ? _raw_spin_lock_irq+0x1a/0x40
[ 1379.600899]  ? __fget_light+0x8f/0x110
[ 1379.601024]  __sys_sendmsg+0x49/0x80
[ 1379.601148]  ? release_ds_buffers+0x50/0xe0
[ 1379.601274]  do_syscall_64+0x3b/0x90
[ 1379.601399]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1379.601525] RIP: 0033:0x7f72c1e2e35d

Fixes: f5396b8a663f ("ice: switchdev slow path")
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reported-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 9a84d746a6c4..6a463b242c7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -361,7 +361,8 @@ ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	np = netdev_priv(netdev);
 	vsi = np->vsi;
 
-	if (ice_is_reset_in_progress(vsi->back->state))
+	if (ice_is_reset_in_progress(vsi->back->state) ||
+	    test_bit(ICE_VF_DIS, vsi->back->state))
 		return NETDEV_TX_BUSY;
 
 	repr = ice_netdev_to_repr(netdev);
-- 
2.31.1

