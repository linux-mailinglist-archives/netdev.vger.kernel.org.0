Return-Path: <netdev+bounces-2161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA3E70091F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09A1D281628
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774CC1DDFC;
	Fri, 12 May 2023 13:23:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68383DF69;
	Fri, 12 May 2023 13:23:38 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38C61719;
	Fri, 12 May 2023 06:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683897816; x=1715433816;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KFgxCTHyDtIPMbPgmh15zr4FZHfdbdTIln5B+NGNrp4=;
  b=A/3V4s23SoHx239tIKgAhs4aZ78VKYEiMwKSAnJJ+pocy0ds684jWAzg
   VoqoFPFqhAMKV+RlPDYHNrQBehWnXiuxlTNbOmRYdqHUomw7HcEv2A4IZ
   9AZhbQGx0uiWcgBtadHuwxBIzJvvafJgAYAgHp9V1NJHnfJHPWtu3VkP9
   BW6HIeYXS9NRLUL0FClAgBbNVhN48jtNPWu0Tx/DL4j7Esb/ZRtq/n0Dr
   2ChCZqcN1X0sR7Khn7kBFp1y4Zz1tZ8YkZ/vTewF+jXLoJ4WW5Rv8FYYa
   RbreZZLLo5lZflI4i2shD5vXhKBcPaxVb6PSgCEPa8GM6iK6HByrUI/Ov
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="378922938"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="378922938"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 06:23:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="677660424"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="677660424"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2023 06:23:34 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH iwl-net] ice: recycle/free all of the fragments from multi-buffer packet
Date: Fri, 12 May 2023 15:23:30 +0200
Message-Id: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
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
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The ice driver caches next_to_clean value at the beginning of
ice_clean_rx_irq() in order to remember the first buffer that has to be
freed/recycled after main Rx processing loop. The end is indicated by
first descriptor of packet that the Rx processing loop has ended. Note
that if mentioned loop ended in the middle of gathering a multi-buffer
packet, next_to_clean would be pointing to the descriptor in the middle
of the packet BUT freeing/recycling stage will stop at the first
descriptor. This means that next iteration of ice_clean_rx_irq() will
miss the (first_desc, next_to_clean - 1) entries.

 When running various 9K MTU workloads, such splats were observed,
mostly related to rx_buf->page being NULL as behavior described in the
paragraph above breaks ICE_RX_DESC_UNUSED() macro which is used when
refilling Rx buffers:

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

To fix this, compare next_to_clean with first_desc at the beginning of
ice_clean_rx_irq(). In the case they are not the same, set cached_ntc to
first_desc so that at the end, when freeing/recycling buffers,
descriptors from first to ntc are not missed.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4fcf2d07eb85..4d1fc047767f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1162,6 +1162,9 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	bool failure;
 	u32 first;
 
+	if (ntc != rx_ring->first_desc)
+		cached_ntc = rx_ring->first_desc;
+
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
 	xdp->frame_sz = ice_rx_frame_truesize(rx_ring, 0);
-- 
2.34.1


