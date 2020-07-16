Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA88222101
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGPKz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgGPKz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:55:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14921206C1;
        Thu, 16 Jul 2020 10:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594896927;
        bh=dRdXMiQCUcJiSH0FWlDV1Zin9+nV/pVzV5iDpzOreqo=;
        h=From:To:Cc:Subject:Date:From;
        b=PGXzo/KAaYPGqlUd0NFZAPiTQLgkFeRq+rrH2ovjTOK7EudaWVhA2lFteCNKajVER
         0swTfYHC1C6rfac7O/APeeRWMdRXy2ECDo+4W4fgoOjx8h+TB5OuYtwT2IsWyuZClq
         GazVkkMWw4zUnb5zjuxikWoGPSL1WSKE196gk1Uw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/cm: Protect access to remote_sidr_table
Date:   Thu, 16 Jul 2020 13:55:19 +0300
Message-Id: <20200716105519.1424266-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

cm.lock must be held while access to remote_sidr_table.
This fix the below NULL pointer dereference.

 [ 2666.146138] BUG: kernel NULL pointer dereference, address: 0000000000000000
 [ 2666.151565] #PF: supervisor write access in kernel mode
 [ 2666.152896] #PF: error_code(0x0002) - not-present page
 [ 2666.154184] PGD 0 P4D 0
 [ 2666.154911] Oops: 0002 [#1] SMP PTI
 [ 2666.155859] CPU: 2 PID: 7288 Comm: udaddy Not tainted 5.7.0_for_upstream_perf_2020_06_09_15_14_20_38 #1
 [ 2666.158123] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 [ 2666.161909] RIP: 0010:rb_erase+0x10d/0x360
 [ 2666.163549] Code: 00 00 00 48 89 c1 48 89 d0 48 8b 50 08 48 39 ca 74 48 f6 02 01 75 af 48 8b
7a 10 48 89 c1 48 83 c9 01 48 89 78 08 48 89 42 10 <48> 89 0f 48 8b 08 48 89 0a 48 83 e1 fc 48
 89 10 0f 84 b1 00 00 00
 [ 2666.169743] RSP: 0018:ffffc90000f77c30 EFLAGS: 00010086
 [ 2666.171646] RAX: ffff8883df27d458 RBX: ffff8883df27da58 RCX: ffff8883df27d459
 [ 2666.174026] RDX: ffff8883d183fa58 RSI: ffffffffa01e8d00 RDI: 0000000000000000
 [ 2666.176325] RBP: ffff8883d62ac800 R08: 0000000000000000 R09: 00000000000000ce
 [ 2666.178618] R10: 000000000000000a R11: 0000000000000000 R12: ffff8883df27da00
 [ 2666.180919] R13: ffffc90000f77c98 R14: 0000000000000130 R15: 0000000000000000
 [ 2666.183197] FS:  00007f009f877740(0000) GS:ffff8883f1a00000(0000) knlGS:0000000000000000
 [ 2666.186318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [ 2666.188293] CR2: 0000000000000000 CR3: 00000003d467e003 CR4: 0000000000160ee0
 [ 2666.190614] Call Trace:
 [ 2666.191896]  cm_send_sidr_rep_locked+0x15a/0x1a0 [ib_cm]
 [ 2666.193902]  ib_send_cm_sidr_rep+0x2b/0x50 [ib_cm]
 [ 2666.195695]  cma_send_sidr_rep+0x8b/0xe0 [rdma_cm]
 [ 2666.197559]  __rdma_accept+0x21d/0x2b0 [rdma_cm]
 [ 2666.199335]  ? ucma_get_ctx+0x2b/0xe0 [rdma_ucm]
 [ 2666.201105]  ? _copy_from_user+0x30/0x60
 [ 2666.202741]  ucma_accept+0x13e/0x1e0 [rdma_ucm]
 [ 2666.204549]  ucma_write+0xb4/0x130 [rdma_ucm]
 [ 2666.206306]  vfs_write+0xad/0x1a0
 [ 2666.207780]  ksys_write+0x9d/0xb0
 [ 2666.209316]  do_syscall_64+0x48/0x130
 [ 2666.210915]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [ 2666.212810] RIP: 0033:0x7f009ef60924
 [ 2666.214354] Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 80 00 00 00 00 8b
05 2a ef 2c 00 48 63 ff 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3
 66 90 55 53 48 89 d5 48 89 f3 48 83
 [ 2666.220512] RSP: 002b:00007fff843edf38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 [ 2666.223546] RAX: ffffffffffffffda RBX: 000055743042e1d0 RCX: 00007f009ef60924
 [ 2666.225889] RDX: 0000000000000130 RSI: 00007fff843edf40 RDI: 0000000000000003
 [ 2666.228228] RBP: 00007fff843ee0e0 R08: 0000000000000000 R09: 0000557430433090
 [ 2666.230572] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
 [ 2666.232931] R13: 00007fff843edf40 R14: 000000000000038c R15: 00000000ffffff00
 [ 2666.235272] Modules linked in: nfsv3 nfs_acl rpcsec_gss_krb5
auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache xt_MASQUERADE
mlx5_ib nf_conntrack_netlink nfnetlink iptable_nat xt_addrtype
iptable_filter bpfilter xt_conntrack br_netfilter bridge stp llc overlay
rpcrdma ib_isert iscsi_target_mod ib_iser ib_srpt target_core_mod ib_srp
ib_ipoib rdma_ucm ib_uverbs sb_edac mlx5_core kvm_intel iTCO_wdt
iTCO_vendor_support kvm ib_umad mlxfw pci_hyperv_intf act_ct
nf_flow_table irqbypass nf_nat rdma_cm crc32_pclmul rfkill nf_conntrack
crc32c_intel ghash_clmulni_intel virtio_net ib_cm i2c_i801 pcspkr
nf_defrag_ipv6 net_failover failover nf_defrag_ipv4 ptp i2c_core lpc_ich
iw_cm pps_core mfd_core ib_core sunrpc sch_fq_codel ip_tables serio_raw
 [ 2666.258905] CR2: 0000000000000000
 [ 2666.260386] ---[ end trace 92a3d3f267f6faa3 ]---
 [ 2666.262174] RIP: 0010:rb_erase+0x10d/0x360
 [ 2666.263781] Code: 00 00 00 48 89 c1 48 89 d0 48 8b 50 08 48 39 ca 74
48 f6 02 01 75 af 48 8b 7a 10 48 89 c1 48 83 c9 01 48 89 78 08 48 89 42
   10 <48> 89 0f 48 8b 08 48 89 0a 48 83 e1 fc 48 89 10 0f 84 b1 00 00
      00
 [ 2666.269994] RSP: 0018:ffffc90000f77c30 EFLAGS: 00010086
 [ 2666.272008] RAX: ffff8883df27d458 RBX: ffff8883df27da58 RCX: ffff8883df27d459
 [ 2666.274465] RDX: ffff8883d183fa58 RSI: ffffffffa01e8d00 RDI: 0000000000000000
 [ 2666.276978] RBP: ffff8883d62ac800 R08: 0000000000000000 R09: 00000000000000ce
 [ 2666.279437] R10: 000000000000000a R11: 0000000000000000 R12: ffff8883df27da00
 [ 2666.281941] R13: ffffc90000f77c98 R14: 0000000000000130 R15: 0000000000000000
 [ 2666.284397] FS:  00007f009f877740(0000) GS:ffff8883f1a00000(0000) knlGS:0000000000000000
 [ 2666.287708] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [ 2666.289817] CR2: 0000000000000000 CR3: 00000003d467e003 CR4: 0000000000160ee0
 [ 2666.292274] Kernel panic - not syncing: Fatal exception
 [ 2666.294689] Kernel Offset: disabled
 [ 2666.296253] ---[ end Kernel panic - not syncing: Fatal exception]---

Fixes: 6a8824a74bc9 ("RDMA/cm: Allow ib_send_cm_sidr_rep() to be done under lock")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 0d1377232933..dc0558b23158 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3676,10 +3676,12 @@ static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
 		return ret;
 	}
 	cm_id_priv->id.state = IB_CM_IDLE;
+	spin_lock_irq(&cm.lock);
 	if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
 		rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
 		RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
 	}
+	spin_unlock_irq(&cm.lock);
 	return 0;
 }
 
-- 
2.26.2

