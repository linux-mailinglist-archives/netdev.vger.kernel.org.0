Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FB49572D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378321AbiAUADg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:03:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:55926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378311AbiAUADc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642723412; x=1674259412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hOoHMW063qzPurSmS7Rj/rXH4ocE6G9Zt0x0jX7sm3I=;
  b=jYc1fzLIF8Ba14RgmofY2bMgx4LrbSLlJiotpATYrY7WOdD1X3zNbJ5y
   JdHpDtqVSPg6IhFvqQ1WjzZEuRMW916yVJFzyXwKtYl50lYSRN6fw/SeX
   tbmMvm1tV3ga/TEyprTkJmXAjtO2p6DCmC/taEibw+BKI0V9mFadOQB3+
   ld8wrogpsPgCI+g7bnPa0+VxA4GUM8/xXsxHBd3Wyndbmj6rNHj5JnsSt
   8lbwvjj7iYlPz/YLiwI7WiBBxjU8B2SKdbGDc+wXuIEiDbMTSRZjx5KoC
   OQ7gUV1PAqP7vGdQt9sZufFQHF3S1FUSLkC0Vhs3LwAeUq0nQptK2E4Et
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="232879180"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="232879180"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:03:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="478015671"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 20 Jan 2022 16:03:31 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 3/5] i40e: Fix queues reservation for XDP
Date:   Thu, 20 Jan 2022 16:03:03 -0800
Message-Id: <20220121000305.1423587-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
References: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

When XDP was configured on a system with large number of CPUs
and X722 NIC there was a call trace with NULL pointer dereference.

i40e 0000:87:00.0: failed to get tracking for 256 queues for VSI 0 err -12
i40e 0000:87:00.0: setup of MAIN VSI failed

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:i40e_xdp+0xea/0x1b0 [i40e]
Call Trace:
? i40e_reconfig_rss_queues+0x130/0x130 [i40e]
dev_xdp_install+0x61/0xe0
dev_xdp_attach+0x18a/0x4c0
dev_change_xdp_fd+0x1e6/0x220
do_setlink+0x616/0x1030
? ahci_port_stop+0x80/0x80
? ata_qc_issue+0x107/0x1e0
? lock_timer_base+0x61/0x80
? __mod_timer+0x202/0x380
rtnl_setlink+0xe5/0x170
? bpf_lsm_binder_transaction+0x10/0x10
? security_capable+0x36/0x50
rtnetlink_rcv_msg+0x121/0x350
? rtnl_calcit.isra.0+0x100/0x100
netlink_rcv_skb+0x50/0xf0
netlink_unicast+0x1d3/0x2a0
netlink_sendmsg+0x22a/0x440
sock_sendmsg+0x5e/0x60
__sys_sendto+0xf0/0x160
? __sys_getsockname+0x7e/0xc0
? _copy_from_user+0x3c/0x80
? __sys_setsockopt+0xc8/0x1a0
__x64_sys_sendto+0x20/0x30
do_syscall_64+0x33/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f83fa7a39e0

This was caused by PF queue pile fragmentation due to
flow director VSI queue being placed right after main VSI.
Because of this main VSI was not able to resize its
queue allocation for XDP resulting in no queues allocated
for main VSI when XDP was turned on.

Fix this by always allocating last queue in PF queue pile
for a flow director VSI.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Fixes: 74608d17fe29 ("i40e: add support for XDP_TX action")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9456641cd24a..9b65cb50282c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -210,6 +210,20 @@ static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 		return -EINVAL;
 	}
 
+	/* Allocate last queue in the pile for FDIR VSI queue
+	 * so it doesn't fragment the qp_pile
+	 */
+	if (pile == pf->qp_pile && pf->vsi[id]->type == I40E_VSI_FDIR) {
+		if (pile->list[pile->num_entries - 1] & I40E_PILE_VALID_BIT) {
+			dev_err(&pf->pdev->dev,
+				"Cannot allocate queue %d for I40E_VSI_FDIR\n",
+				pile->num_entries - 1);
+			return -ENOMEM;
+		}
+		pile->list[pile->num_entries - 1] = id | I40E_PILE_VALID_BIT;
+		return pile->num_entries - 1;
+	}
+
 	i = 0;
 	while (i < pile->num_entries) {
 		/* skip already allocated entries */
-- 
2.31.1

