Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDE5537F6A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiE3Nxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiE3NxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:53:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07D28A063;
        Mon, 30 May 2022 06:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2521BB80D84;
        Mon, 30 May 2022 13:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97809C3411C;
        Mon, 30 May 2022 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917848;
        bh=q4P0TgG5luIpHJz6sITHcKcCqK92PH1Nr8Ym2LquE5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRHvNohK5o/9i6WEWDApz7pdd8OXDreAPbtyqXrjQBi3AUMlcCkiXZ010ins09rOC
         BmlMep37EOcvoogJd5E/HOHkYjmY9Tje0LQG1RDDfOePLcD3g3DDH4761b0Zo+5+Wr
         FH9ArgvKctQakiKHaQaoh1gfkem1ilb916jGVqlXDJFnBNODVG81/0Uw7XF+GuscYf
         qURmdDKZe8rq1LHCC5DAYG6YApRujHDtq/QF96axnXi9/lR7MILsl95CntwNAEvm0F
         O/6T1xvXmNbcSS3UFXVM6kryDlhyFCfurD6kGjKKJBillMTWPIRzndZSx2PtUb00sf
         8jpDdByTm9oZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 115/135] rtw89: cfo: check mac_id to avoid out-of-bounds
Date:   Mon, 30 May 2022 09:31:13 -0400
Message-Id: <20220530133133.1931716-115-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 97df85871a5b187609d30fca6d85b912d9e02f29 ]

Somehow, hardware reports incorrect mac_id and pollute memory. Check index
before we access the array.

  UBSAN: array-index-out-of-bounds in rtw89/phy.c:2517:23
  index 188 is out of range for type 's32 [64]'
  CPU: 1 PID: 51550 Comm: irq/35-rtw89_pc Tainted: G           OE
  Call Trace:
   <IRQ>
   show_stack+0x52/0x58
   dump_stack_lvl+0x4c/0x63
   dump_stack+0x10/0x12
   ubsan_epilogue+0x9/0x45
   __ubsan_handle_out_of_bounds.cold+0x44/0x49
   ? __alloc_skb+0x92/0x1d0
   rtw89_phy_cfo_parse+0x44/0x7f [rtw89_core]
   rtw89_core_rx+0x261/0x871 [rtw89_core]
   ? __alloc_skb+0xee/0x1d0
   rtw89_pci_napi_poll+0x3fa/0x4ea [rtw89_pci]
   __napi_poll+0x33/0x1a0
   net_rx_action+0x126/0x260
   ? __queue_work+0x217/0x4c0
   __do_softirq+0xd9/0x315
   ? disable_irq_nosync+0x10/0x10
   do_softirq.part.0+0x6d/0x90
   </IRQ>
   <TASK>
   __local_bh_enable_ip+0x62/0x70
   rtw89_pci_interrupt_threadfn+0x182/0x1a6 [rtw89_pci]
   irq_thread_fn+0x28/0x60
   irq_thread+0xc8/0x190
   ? irq_thread_fn+0x60/0x60
   kthread+0x16b/0x190
   ? irq_thread_check_affinity+0xe0/0xe0
   ? set_kthread_struct+0x50/0x50
   ret_from_fork+0x22/0x30
   </TASK>

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220516005215.5878-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 147009888de0..777ad4e8f45f 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -1872,6 +1872,11 @@ void rtw89_phy_cfo_parse(struct rtw89_dev *rtwdev, s16 cfo_val,
 	struct rtw89_cfo_tracking_info *cfo = &rtwdev->cfo_tracking;
 	u8 macid = phy_ppdu->mac_id;
 
+	if (macid >= CFO_TRACK_MAX_USER) {
+		rtw89_warn(rtwdev, "mac_id %d is out of range\n", macid);
+		return;
+	}
+
 	cfo->cfo_tail[macid] += cfo_val;
 	cfo->cfo_cnt[macid]++;
 	cfo->packet_count++;
-- 
2.35.1

