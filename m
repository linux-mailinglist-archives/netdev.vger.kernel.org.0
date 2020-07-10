Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7721B382
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 12:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGJKz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 06:55:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45324 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726840AbgGJKz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 06:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594378554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=coizABqL9K80yz73oJ3We9DFGRNEdWV3wOmK762Q0Is=;
        b=JmDdfzP4ZnKJUAC4En6+hkWpy+j0W45nGUOaCoMkjOrK1cxQhjIWTffO5kCYf5/IQru25z
        Q8+q6uUY98dGhWKbSmG63Ly8LNt70+kLsOK2/Vawtdg9xXwd5Abr+THq0EXtaw7SnNKbRb
        NpiOZXYzY7PoqeZk6lJhL5kLAeVJdAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-C0k86CA9OV6ebgErhVDbeg-1; Fri, 10 Jul 2020 06:55:53 -0400
X-MC-Unique: C0k86CA9OV6ebgErhVDbeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 459CD107ACCA;
        Fri, 10 Jul 2020 10:55:52 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.192.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF0295C1D6;
        Fri, 10 Jul 2020 10:55:50 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     jtoppins@redhat.com, feliu@redhat.com
Subject: [PATCH net] bnxt_en: fix NULL dereference in case SR-IOV configuration fails
Date:   Fri, 10 Jul 2020 12:55:08 +0200
Message-Id: <44c96038dc3b3e78d2bb763ad5ea1e989694a68e.1594377971.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

we need to set 'active_vfs' back to 0, if something goes wrong during the
allocation of SR-IOV resources: otherwise, further VF configurations will
wrongly assume that bp->pf.vf[x] are valid memory locations, and commands
like the ones in the following sequence:

 # echo 2 >/sys/bus/pci/devices/${ADDR}/sriov_numvfs
 # ip link set dev ens1f0np0 up
 # ip link set dev ens1f0np0 vf 0 trust on

will cause a kernel crash similar to this:

 bnxt_en 0000:3b:00.0: not enough MMIO resources for SR-IOV
 BUG: kernel NULL pointer dereference, address: 0000000000000014
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 CPU: 43 PID: 2059 Comm: ip Tainted: G          I       5.8.0-rc2.upstream+ #871
 Hardware name: Dell Inc. PowerEdge R740/08D89F, BIOS 2.2.11 06/13/2019
 RIP: 0010:bnxt_set_vf_trust+0x5b/0x110 [bnxt_en]
 Code: 44 24 58 31 c0 e8 f5 fb ff ff 85 c0 0f 85 b6 00 00 00 48 8d 1c 5b 41 89 c6 b9 0b 00 00 00 48 c1 e3 04 49 03 9c 24 f0 0e 00 00 <8b> 43 14 89 c2 83 c8 10 83 e2 ef 45 84 ed 49 89 e5 0f 44 c2 4c 89
 RSP: 0018:ffffac6246a1f570 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000b
 RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff98b28f538900
 RBP: ffff98b28f538900 R08: 0000000000000000 R09: 0000000000000008
 R10: ffffffffb9515be0 R11: ffffac6246a1f678 R12: ffff98b28f538000
 R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffc05451e0
 FS:  00007fde0f688800(0000) GS:ffff98baffd40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000014 CR3: 000000104bb0a003 CR4: 00000000007606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  do_setlink+0x994/0xfe0
  __rtnl_newlink+0x544/0x8d0
  rtnl_newlink+0x47/0x70
  rtnetlink_rcv_msg+0x29f/0x350
  netlink_rcv_skb+0x4a/0x110
  netlink_unicast+0x21d/0x300
  netlink_sendmsg+0x329/0x450
  sock_sendmsg+0x5b/0x60
  ____sys_sendmsg+0x204/0x280
  ___sys_sendmsg+0x88/0xd0
  __sys_sendmsg+0x5e/0xa0
  do_syscall_64+0x47/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: c0c050c58d840 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Fei Liu <feliu@redhat.com>
CC: Jonathan Toppins <jtoppins@redhat.com>
CC: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 3a9a51f7063a..392e32c7122a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -396,6 +396,7 @@ static void bnxt_free_vf_resources(struct bnxt *bp)
 		}
 	}
 
+	bp->pf.active_vfs = 0;
 	kfree(bp->pf.vf);
 	bp->pf.vf = NULL;
 }
@@ -835,7 +836,6 @@ void bnxt_sriov_disable(struct bnxt *bp)
 
 	bnxt_free_vf_resources(bp);
 
-	bp->pf.active_vfs = 0;
 	/* Reclaim all resources for the PF. */
 	rtnl_lock();
 	bnxt_restore_pf_fw_resources(bp);
-- 
2.26.2

