Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8656B14CC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 23:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCHWJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 17:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHWJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 17:09:44 -0500
Received: from evilolive.daedalian.us (evilolive.daedalian.us [96.126.118.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D529384F49;
        Wed,  8 Mar 2023 14:09:42 -0800 (PST)
Received: by evilolive.daedalian.us (Postfix, from userid 111)
        id 3BE3212398; Wed,  8 Mar 2023 14:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=daedalian.us;
        s=default; t=1678313382;
        bh=hpgitxCOU5nj6oddWyD9T9T7VS/UVfODqkkiFx8yIO0=;
        h=From:To:Cc:Subject:Date:From;
        b=gF9EWG/3/4T9bpmzMocSso0l1vx1Wl/P2LSRoaDoPFQERnah2pH5/ENcVA1Dd80S8
         Ls60etDgCIVpoxT6iV9qsdkaGikyzuz5ijw+IIa0ECSa0nwD+M1ZU5gjMdP+CHFNsx
         W9Gq6oiOeLfq2OLwng2PiNkRvZcnuRS9LskB4SnytbtP+OTti0Xj5R+VKZdPGmb47m
         0L9/kHBtTarsPoamHYeKKOvHOUudDnsf7S7lJPQNSVXQX3aSAhqF81cTX8jHsy0RDb
         CULD1GN1DDNORW2rtmq6LB7xfTsleR0hu7TdtRVsGXOqqqb54pVzwQ8OQiHzcpZ3JM
         SltIdrtkLzpkQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from localhost.localdomain (static-47-181-121-78.lsan.ca.frontiernet.net [47.181.121.78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by evilolive.daedalian.us (Postfix) with ESMTPSA id 7E6D2120F9;
        Wed,  8 Mar 2023 14:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=daedalian.us;
        s=default; t=1678313378;
        bh=hpgitxCOU5nj6oddWyD9T9T7VS/UVfODqkkiFx8yIO0=;
        h=From:To:Cc:Subject:Date:From;
        b=f5X8LIxAuP+f5W+e1JvPwCTHGoaQZY55me80o2nH3pWXPhWLudnNmvKsfHTBD5nHa
         iXT/jjRkGfb0hHEIQorLOGUlWiJir44xxkWhGVi/kEIo9pAsPIK7PJ5k8/XaWMjIxo
         kvbMYp1NIfvuxzrWVDUyVO8o9XJ8ESGX1ZRkRuA5dxxxShkUTq5I53MhDO5uhTbjx8
         ZUCyNpbMb/izCB6lJNjI9jP8hoQHHx9vWtzkI7e/+S7/ah2XHCr65ZL9C5DzsyrVBV
         KO8C8O+bL6aM7Qwpvj3CzocheXy7Himmn5gHmaNbg+3Fc7XG+sUjZKzQkVNR9A5lPc
         yuhbsGTemoo4Q==
From:   John Hickey <jjh@daedalian.us>
To:     anthony.l.nguyen@intel.com
Cc:     John Hickey <jjh@daedalian.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Shujin Li <lishujin@kuaishou.com>,
        Jason Xing <xingwanli@kuaishou.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net v3] ixgbe: Panic during XDP_TX with > 64 CPUs
Date:   Wed,  8 Mar 2023 14:07:57 -0800
Message-Id: <20230308220756.587317-1-jjh@daedalian.us>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
(4fe815850bdc), support was added to allow XDP programs to run on systems
with more than 64 CPUs by locking the XDP TX rings and indexing them
using cpu % 64 (IXGBE_MAX_XDP_QS).

Upon trying this out patch via the Intel 5.18.6 out of tree driver
on a system with more than 64 cores, the kernel paniced with an
array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
cpu instead of cpu % IXGBE_MAX_XDP_QS.  An example splat:

 ==========================================================================
 UBSAN: array-index-out-of-bounds in
 /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
 index 65 is out of range for type 'ixgbe_ring *[64]'
 ==========================================================================
 BUG: kernel NULL pointer dereference, address: 0000000000000058
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP NOPTI
 CPU: 65 PID: 408 Comm: ksoftirqd/65
 Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
 Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/2020
 RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
 Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 b9
 00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f b7
 47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
 RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
 RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
 RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
 RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
 R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
 R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
 FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
 knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  ixgbe_poll+0x103e/0x1280 [ixgbe]
  ? sched_clock_cpu+0x12/0xe0
  __napi_poll+0x30/0x160
  net_rx_action+0x11c/0x270
  __do_softirq+0xda/0x2ee
  run_ksoftirqd+0x2f/0x50
  smpboot_thread_fn+0xb7/0x150
  ? sort_range+0x30/0x30
  kthread+0x127/0x150
  ? set_kthread_struct+0x50/0x50
  ret_from_fork+0x1f/0x30
  </TASK>

I think this is how it happens:

Upon loading the first XDP program on a system with more than 64 CPUs,
ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
immediately after this, the rings are reconfigured by ixgbe_setup_tc.
ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
stopped my system from panicing.

I suspect to make the original patch work, I would need to load an XDP
program and then replace it in order to get ixgbe_xdp_locking_key back
above 0 since ixgbe_setup_tc is only called when transitioning between
XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
incremented every time ixgbe_xdp_setup is called.

Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
becomes another path to decrement ixgbe_xdp_locking_key to 0 on systems
with greater than 64 CPUs.

For this patch, I have changed static_branch_inc to static_branch_enable
in ixgbe_setup_xdp.  We weren't counting references.  The
ixgbe_xdp_locking_key only protects code in the XDP_TX path, which is
not run when an XDP program is loaded.  The other condition for setting
it on is the number of CPUs, which I assume is static.

Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
Signed-off-by: John Hickey <jjh@daedalian.us>
---
v1 -> v2:
	Added Fixes and net tag.  No code changes.
v2 -> v3:
	Added splat.  Slight clarification as to why ixgbe_xdp_locking_key
	is not turned off.  Based on feedback from Maciej Fijalkowski.
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index f8156fe4b1dc..0ee943db3dc9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 	adapter->q_vector[v_idx] = NULL;
 	__netif_napi_del(&q_vector->napi);
 
-	if (static_key_enabled(&ixgbe_xdp_locking_key))
-		static_branch_dec(&ixgbe_xdp_locking_key);
-
 	/*
 	 * after a call to __netif_napi_del() napi may still be used and
 	 * ixgbe_get_stats64() might access the rings on this vector,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..cd2fb72c67be 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
 		return -ENOMEM;
 	else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
-		static_branch_inc(&ixgbe_xdp_locking_key);
+		static_branch_enable(&ixgbe_xdp_locking_key);
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
 	need_reset = (!!prog != !!old_prog);
-- 
2.37.2

