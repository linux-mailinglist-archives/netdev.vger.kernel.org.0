Return-Path: <netdev+bounces-2669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2403C702ED0
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A0FE1C20BA9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35284D2E8;
	Mon, 15 May 2023 13:53:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB02C8F0;
	Mon, 15 May 2023 13:53:01 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ED0268D;
	Mon, 15 May 2023 06:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684158773; x=1715694773;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Rs72Vzw8BQHCwDsmHBD36EAtM35B8o20rZOCfmA62LM=;
  b=PXMzd/Lfj/g+kjzGa8w18qjfhmej/ADNtVNrELxc9AEcPnKJCiOAA3FU
   1A6BQORfGuiDrj696zstHRfQD6sTXv85P8c2hk8KlsVUv2v7JoZtCrBSx
   I3e/5hZ+NbrdFqh5sIxnsBHdItjzKxm/llpGgnewZWX/uXoh2wUp5P6SX
   VDx74FPVncBoDb4X7SZsUNPEEj3yMbgRGvLxz0pyeex89f8MLwsCdyQHh
   FY13q5JVqQOIaIb/aNg/CbY44LCUeO58XagGcxwlfSEeJc9+1HfwvHLAH
   dsSWNLcsB2RB54LOE7r/eQVCYYWRBbokMxOMfNoFyvkA1mL7JY7kEQUei
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="348700074"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="348700074"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:52:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="695020874"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="695020874"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 15 May 2023 06:52:51 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	simon.horman@corigine.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH iwl-net v2] ice: recycle/free all of the fragments from multi-buffer frame
Date: Mon, 15 May 2023 15:52:47 +0200
Message-Id: <20230515135247.142105-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
---
v2: set cached_ntc directly to first_desc [Simon]

 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4fcf2d07eb85..730ee2741b7f 100644
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
2.34.1


