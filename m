Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973916A3292
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBZP6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBZP6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:58:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3640C8A57;
        Sun, 26 Feb 2023 07:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D17BBB80C73;
        Sun, 26 Feb 2023 14:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D063C433D2;
        Sun, 26 Feb 2023 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422959;
        bh=+PKxtOU04L8JPUaSueipC1OQV8eeJ2OdEAoHbDAttHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdgeTQ/c6jIY7EMIqnEBrEmcGI8wy6ntPfR+dwnt1jSXawFlSUTUWY5mJHAaYYpvN
         kXlReJfkcfXE+7xFLmj9QKPRTiPQVixhI1hY+abBI5635GJB5jAqp35WTxulQOi8fJ
         k4WfvKGn4xr/yRolNQkBwDyIxH/9MnHHMK8L3UGh+cmJRnqFswccXQ08sakZiwgDKt
         gv24T5A78z6IsGgT0dyM4vOzontN+DZdm8yT5ZPyPClmg/mQ/akSViIQ4ZCQVcVQjc
         tSo+QJw8iPRu1GbkmN7OFTPBD8F1p1HGTy1O5/00xX17POSGuwYy8OneLt6s3LqJux
         zWzOgh4MyH2Hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 11/36] wifi: mt7601u: fix an integer underflow
Date:   Sun, 26 Feb 2023 09:48:19 -0500
Message-Id: <20230226144845.827893-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144845.827893-1-sashal@kernel.org>
References: <20230226144845.827893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisoo Jang <jisoo.jang@yonsei.ac.kr>

[ Upstream commit 803f3176c5df3b5582c27ea690f204abb60b19b9 ]

Fix an integer underflow that leads to a null pointer dereference in
'mt7601u_rx_skb_from_seg()'. The variable 'dma_len' in the URB packet
could be manipulated, which could trigger an integer underflow of
'seg_len' in 'mt7601u_rx_process_seg()'. This underflow subsequently
causes the 'bad_frame' checks in 'mt7601u_rx_skb_from_seg()' to be
bypassed, eventually leading to a dereference of the pointer 'p', which
is a null pointer.

Ensure that 'dma_len' is greater than 'min_seg_len'.

Found by a modified version of syzkaller.

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 12 Comm: ksoftirqd/0 Tainted: G        W  O      5.14.0+
#139
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
RIP: 0010:skb_add_rx_frag+0x143/0x370
Code: e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85 86 01 00 00 4c 8d 7d 08 44
89 68 08 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02
00 0f 85 cd 01 00 00 48 8b 45 08 a8 01 0f 85 3d 01 00 00
RSP: 0018:ffffc900000cfc90 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888115520dc0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8881118430c0 RDI: ffff8881118430f8
RBP: 0000000000000000 R08: 0000000000000e09 R09: 0000000000000010
R10: ffff888111843017 R11: ffffed1022308602 R12: 0000000000000000
R13: 0000000000000e09 R14: 0000000000000010 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88811a800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000004035af40 CR3: 00000001157f2000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 mt7601u_rx_tasklet+0xc73/0x1270
 ? mt7601u_submit_rx_buf.isra.0+0x510/0x510
 ? tasklet_action_common.isra.0+0x79/0x2f0
 tasklet_action_common.isra.0+0x206/0x2f0
 __do_softirq+0x1b5/0x880
 ? tasklet_unlock+0x30/0x30
 run_ksoftirqd+0x26/0x50
 smpboot_thread_fn+0x34f/0x7d0
 ? smpboot_register_percpu_thread+0x370/0x370
 kthread+0x3a1/0x480
 ? set_kthread_struct+0x120/0x120
 ret_from_fork+0x1f/0x30
Modules linked in: 88XXau(O) 88x2bu(O)
---[ end trace 57f34f93b4da0f9b ]---
RIP: 0010:skb_add_rx_frag+0x143/0x370
Code: e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85 86 01 00 00 4c 8d 7d 08 44
89 68 08 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02
00 0f 85 cd 01 00 00 48 8b 45 08 a8 01 0f 85 3d 01 00 00
RSP: 0018:ffffc900000cfc90 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888115520dc0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8881118430c0 RDI: ffff8881118430f8
RBP: 0000000000000000 R08: 0000000000000e09 R09: 0000000000000010
R10: ffff888111843017 R11: ffffed1022308602 R12: 0000000000000000
R13: 0000000000000e09 R14: 0000000000000010 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88811a800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000004035af40 CR3: 00000001157f2000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554

Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221229092906.2328282-1-jisoo.jang@yonsei.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index ed78d2cb35e3c..fd3b768ca92bd 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -123,7 +123,8 @@ static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
 	if (data_len < min_seg_len ||
 	    WARN_ON_ONCE(!dma_len) ||
 	    WARN_ON_ONCE(dma_len + MT_DMA_HDRS > data_len) ||
-	    WARN_ON_ONCE(dma_len & 0x3))
+	    WARN_ON_ONCE(dma_len & 0x3) ||
+	    WARN_ON_ONCE(dma_len < min_seg_len))
 		return 0;
 
 	return MT_DMA_HDRS + dma_len;
-- 
2.39.0

