Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8CA54E320
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiFPONt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377634AbiFPONm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 10:13:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF622BFE
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 07:13:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 759D561D9B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 14:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B021C3411A;
        Thu, 16 Jun 2022 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655388819;
        bh=AojHqnGnbKp46nSSRg/o/YHzLIrys3QjZXI5b12sR2g=;
        h=From:To:Cc:Subject:Date:From;
        b=XAsYYgE3cdX9GdfaTKvn2RWSqzmv3iuXRwEGpXtcCuS/uZjRXAiiXLLTuXBcR1gUm
         AwWB0HpRpuMTTLOlQF2n9TUMPz7z/32yOD1bsNUNoJ8vqv5Pw7d38xiXpeKw3XQfkG
         88U0MypcpzM9mf2qOwSLZAcAWdSQIO0c6NKw9xWklLRDGraWIPjoGafLLqIwnzUmV2
         FqVM5nkjIRQG0yk+8Hxe6izZ1IvJZDgDVJWmTlSkovdHA04r9a0AFHtoQ8MIKXT1iG
         3hG8+41yGHoUJ5kTtYMesD0XOHGBOEeJongNv3//LPn7D4t/I6gRTsxG9bHDHxzz0a
         Zt4aeS+t/a6Hw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, magnus.karlsson@intel.com,
        jbrouer@redhat.com, sven.auhagen@voleatech.de
Subject: [PATCH net] igb: fix a use-after-free issue in igb_clean_tx_ring
Date:   Thu, 16 Jun 2022 16:13:20 +0200
Message-Id: <e5c01d549dc37bff18e46aeabd6fb28a7bcf84be.1655388571.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following use-after-free bug in igb_clean_tx_ring routine when
the NIC is running in XDP mode. The issue can be triggered redirecting
traffic into the igb NIC and then closing the device while the traffic
is flowing.

[   73.322719] CPU: 1 PID: 487 Comm: xdp_redirect Not tainted 5.18.3-apu2 #9
[   73.330639] Hardware name: PC Engines APU2/APU2, BIOS 4.0.7 02/28/2017
[   73.337434] RIP: 0010:refcount_warn_saturate+0xa7/0xf0
[   73.362283] RSP: 0018:ffffc9000081f798 EFLAGS: 00010282
[   73.367761] RAX: 0000000000000000 RBX: ffffc90000420f80 RCX: 0000000000000000
[   73.375200] RDX: ffff88811ad22d00 RSI: ffff88811ad171e0 RDI: ffff88811ad171e0
[   73.382590] RBP: 0000000000000900 R08: ffffffff82298f28 R09: 0000000000000058
[   73.390008] R10: 0000000000000219 R11: ffffffff82280f40 R12: 0000000000000090
[   73.397356] R13: ffff888102343a40 R14: ffff88810359e0e4 R15: 0000000000000000
[   73.404806] FS:  00007ff38d31d740(0000) GS:ffff88811ad00000(0000) knlGS:0000000000000000
[   73.413129] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.419096] CR2: 000055cff35f13f8 CR3: 0000000106391000 CR4: 00000000000406e0
[   73.426565] Call Trace:
[   73.429087]  <TASK>
[   73.431314]  igb_clean_tx_ring+0x43/0x140 [igb]
[   73.436002]  igb_down+0x1d7/0x220 [igb]
[   73.439974]  __igb_close+0x3c/0x120 [igb]
[   73.444118]  igb_xdp+0x10c/0x150 [igb]
[   73.447983]  ? igb_pci_sriov_configure+0x70/0x70 [igb]
[   73.453362]  dev_xdp_install+0xda/0x110
[   73.457371]  dev_xdp_attach+0x1da/0x550
[   73.461369]  do_setlink+0xfd0/0x10f0
[   73.465166]  ? __nla_validate_parse+0x89/0xc70
[   73.469714]  rtnl_setlink+0x11a/0x1e0
[   73.473547]  rtnetlink_rcv_msg+0x145/0x3d0
[   73.477709]  ? rtnl_calcit.isra.0+0x130/0x130
[   73.482258]  netlink_rcv_skb+0x8d/0x110
[   73.486229]  netlink_unicast+0x230/0x340
[   73.490317]  netlink_sendmsg+0x215/0x470
[   73.494395]  __sys_sendto+0x179/0x190
[   73.498268]  ? move_addr_to_user+0x37/0x70
[   73.502547]  ? __sys_getsockname+0x84/0xe0
[   73.506853]  ? netlink_setsockopt+0x1c1/0x4a0
[   73.511349]  ? __sys_setsockopt+0xc8/0x1d0
[   73.515636]  __x64_sys_sendto+0x20/0x30
[   73.519603]  do_syscall_64+0x3b/0x80
[   73.523399]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   73.528712] RIP: 0033:0x7ff38d41f20c
[   73.551866] RSP: 002b:00007fff3b945a68 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[   73.559640] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff38d41f20c
[   73.567066] RDX: 0000000000000034 RSI: 00007fff3b945b30 RDI: 0000000000000003
[   73.574457] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[   73.581852] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff3b945ab0
[   73.589179] R13: 0000000000000000 R14: 0000000000000003 R15: 00007fff3b945b30
[   73.596545]  </TASK>
[   73.598842] ---[ end trace 0000000000000000 ]---

Fixes: 9cbc948b5a20c ("igb: add XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 68be2976f539..1c26bec7d6fa 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4819,8 +4819,11 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 	while (i != tx_ring->next_to_use) {
 		union e1000_adv_tx_desc *eop_desc, *tx_desc;
 
-		/* Free all the Tx ring sk_buffs */
-		dev_kfree_skb_any(tx_buffer->skb);
+		/* Free all the Tx ring sk_buffs or xdp frames */
+		if (tx_buffer->type == IGB_TYPE_SKB)
+			dev_kfree_skb_any(tx_buffer->skb);
+		else
+			xdp_return_frame(tx_buffer->xdpf);
 
 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
-- 
2.36.1

