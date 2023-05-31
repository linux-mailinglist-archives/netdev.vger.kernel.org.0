Return-Path: <netdev+bounces-6852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9727186B7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BDD1281567
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D717174F8;
	Wed, 31 May 2023 15:50:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF09174EC;
	Wed, 31 May 2023 15:50:12 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1A012B;
	Wed, 31 May 2023 08:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685548210; x=1717084210;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lAStyqkpKxMpRWFEmN6/fxXN8UiaPp9Vk4Abc22viy4=;
  b=bryzKOWtkE1XHRTCWo/ELKL+TocP7XtTcWqk+VHqOOdCwORJXHYIcahW
   5FjocMg2ZEfDMoG0FX9t7o1vCktvzbkVUQUZZNzf8rlICO23qZkJDeLh+
   oms0aOTL2q8uWHRO3IJhmTbGR6FcS+G5iWg06FcINMB3ZWxO3DGDRUvAS
   5jfzFKFwgX/+cUsDaWLJeXpi+QKBUjPTvXjVl/yaiv+BveVyvhpIvClA4
   lOhlb812E2P/vddp7Xsgk+ZyPPlYGqelDGID6hjCJMVykeKcKsMePy+wi
   kohZdtn3z3LQc76bLY0tp4a4sZJPlaxYD/+hQgI3ZcQUcmQ1vLqbH60qe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="418770874"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="418770874"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:49:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="819370635"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="819370635"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2023 08:49:10 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	Simon Horman <simon.horman@corigine.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net] ice: recycle/free all of the fragments from multi-buffer frame
Date: Wed, 31 May 2023 08:44:57 -0700
Message-Id: <20230531154457.3216621-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

The ice driver caches next_to_clean value at the beginning of
ice_clean_rx_irq() in order to remember the first buffer that has to be
freed/recycled after main Rx processing loop. The end boundary is
indicated by first descriptor of frame that Rx processing loop has ended
its duties. Note that if mentioned loop ended in the middle of gathering
multi-buffer frame, next_to_clean would be pointing to the descriptor in
the middle of the frame BUT freeing/recycling stage will stop at the
first descriptor. This means that next iteration of ice_clean_rx_irq()
will miss the (first_desc, next_to_clean - 1) entries.

 When running various 9K MTU workloads, such splats were observed:

[  540.780716] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  540.787787] #PF: supervisor read access in kernel mode
[  540.793002] #PF: error_code(0x0000) - not-present page
[  540.798218] PGD 0 P4D 0
[  540.800801] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  540.805231] CPU: 18 PID: 3984 Comm: xskxceiver Tainted: G        W          6.3.0-rc7+ #96
[  540.813619] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[  540.824209] RIP: 0010:ice_clean_rx_irq+0x2b6/0xf00 [ice]
[  540.829678] Code: 74 24 10 e9 aa 00 00 00 8b 55 78 41 31 57 10 41 09 c4 4d 85 ff 0f 84 83 00 00 00 49 8b 57 08 41 8b 4f 1c 65 8b 35 1a fa 4b 3f <48> 8b 02 48 c1 e8 3a 39 c6 0f 85 a2 00 00 00 f6 42 08 02 0f 85 98
[  540.848717] RSP: 0018:ffffc9000f42fc50 EFLAGS: 00010282
[  540.854029] RAX: 0000000000000004 RBX: 0000000000000002 RCX: 000000000000fffe
[  540.861272] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000000ffffffff
[  540.868519] RBP: ffff88984a05ac00 R08: 0000000000000000 R09: dead000000000100
[  540.875760] R10: ffff88983fffcd00 R11: 000000000010f2b8 R12: 0000000000000004
[  540.883008] R13: 0000000000000003 R14: 0000000000000800 R15: ffff889847a10040
[  540.890253] FS:  00007f6ddf7fe640(0000) GS:ffff88afdf800000(0000) knlGS:0000000000000000
[  540.898465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  540.904299] CR2: 0000000000000000 CR3: 000000010d3da001 CR4: 00000000007706e0
[  540.911542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  540.918789] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  540.926032] PKRU: 55555554
[  540.928790] Call Trace:
[  540.931276]  <TASK>
[  540.933418]  ice_napi_poll+0x4ca/0x6d0 [ice]
[  540.937804]  ? __pfx_ice_napi_poll+0x10/0x10 [ice]
[  540.942716]  napi_busy_loop+0xd7/0x320
[  540.946537]  xsk_recvmsg+0x143/0x170
[  540.950178]  sock_recvmsg+0x99/0xa0
[  540.953729]  __sys_recvfrom+0xa8/0x120
[  540.957543]  ? do_futex+0xbd/0x1d0
[  540.961008]  ? __x64_sys_futex+0x73/0x1d0
[  540.965083]  __x64_sys_recvfrom+0x20/0x30
[  540.969155]  do_syscall_64+0x38/0x90
[  540.972796]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  540.977934] RIP: 0033:0x7f6de5f27934

To fix this, set cached_ntc to first_desc so that at the end, when
freeing/recycling buffers, descriptors from first to ntc are not missed.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 059bd911c51d..52d0a126eb61 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1152,11 +1152,11 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	unsigned int offset = rx_ring->rx_offset;
 	struct xdp_buff *xdp = &rx_ring->xdp;
+	u32 cached_ntc = rx_ring->first_desc;
 	struct ice_tx_ring *xdp_ring = NULL;
 	struct bpf_prog *xdp_prog = NULL;
 	u32 ntc = rx_ring->next_to_clean;
 	u32 cnt = rx_ring->count;
-	u32 cached_ntc = ntc;
 	u32 xdp_xmit = 0;
 	u32 cached_ntu;
 	bool failure;
-- 
2.38.1


