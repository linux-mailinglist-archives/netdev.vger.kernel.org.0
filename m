Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8914835F7
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiACRbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiACRaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA1AC061398;
        Mon,  3 Jan 2022 09:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 818BB61169;
        Mon,  3 Jan 2022 17:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABF2C36AF0;
        Mon,  3 Jan 2022 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231027;
        bh=FMcC811dLrfa+pEL4aeEAecmD3gp+jbs0tlpxKta/6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW4JxGDann0hJ7epUdYh10cFio355ZdfSMScRpEzKXZzFFPMJdZ2CE3cOftYVm8dJ
         C5KqkQQMgSE4MRRW0kCSQVEgk2tGboLa6xN7zh6hgnu4aIoDrhwyK0tB5ApyuFWbiL
         KTabwsdwN7kriQ0I+Z0CmGNQL1tUSxqo2WBByP0drdrR0hOBxcN5CdqZBwP6dk3cGw
         04g4/6svVIqsabeS0/iLjH/ARNoo7sI0loa2+xZKU1X5v7mkfAFj9P+F4cufv7rMSM
         7X8TLaVB8ojMKcu00t6AE0mzM1BC0lzP7KZsaADyBrB/tn7zG3UmXob1f7Xhne4OWu
         x4Nujp0HsnXxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/6] atlantic: Fix buff_ring OOB in aq_ring_rx_clean
Date:   Mon,  3 Jan 2022 12:30:17 -0500
Message-Id: <20220103173018.1613394-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173018.1613394-1-sashal@kernel.org>
References: <20220103173018.1613394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 5f50153288452e10b6edd69ec9112c49442b054a ]

The function obtain the next buffer without boundary check.
We should return with I/O error code.

The bug is found by fuzzing and the crash report is attached.
It is an OOB bug although reported as use-after-free.

[    4.804724] BUG: KASAN: use-after-free in aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.805661] Read of size 4 at addr ffff888034fe93a8 by task ksoftirqd/0/9
[    4.806505]
[    4.806703] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.6.0 #34
[    4.809030] Call Trace:
[    4.809343]  dump_stack+0x76/0xa0
[    4.809755]  print_address_description.constprop.0+0x16/0x200
[    4.810455]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.811234]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.813183]  __kasan_report.cold+0x37/0x7c
[    4.813715]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.814393]  kasan_report+0xe/0x20
[    4.814837]  aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.815499]  ? hw_atl_b0_hw_ring_rx_receive+0x9a5/0xb90 [atlantic]
[    4.816290]  aq_vec_poll+0x179/0x5d0 [atlantic]
[    4.816870]  ? _GLOBAL__sub_I_65535_1_aq_pci_func_init+0x20/0x20 [atlantic]
[    4.817746]  ? __next_timer_interrupt+0xba/0xf0
[    4.818322]  net_rx_action+0x363/0xbd0
[    4.818803]  ? call_timer_fn+0x240/0x240
[    4.819302]  ? __switch_to_asm+0x40/0x70
[    4.819809]  ? napi_busy_loop+0x520/0x520
[    4.820324]  __do_softirq+0x18c/0x634
[    4.820797]  ? takeover_tasklets+0x5f0/0x5f0
[    4.821343]  run_ksoftirqd+0x15/0x20
[    4.821804]  smpboot_thread_fn+0x2f1/0x6b0
[    4.822331]  ? smpboot_unregister_percpu_thread+0x160/0x160
[    4.823041]  ? __kthread_parkme+0x80/0x100
[    4.823571]  ? smpboot_unregister_percpu_thread+0x160/0x160
[    4.824301]  kthread+0x2b5/0x3b0
[    4.824723]  ? kthread_create_on_node+0xd0/0xd0
[    4.825304]  ret_from_fork+0x35/0x40

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 03821b46a8cb4..4c22f119ac62f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -305,6 +305,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		if (!buff->is_eop) {
 			buff_ = buff;
 			do {
+				if (buff_->next >= self->size) {
+					err = -EIO;
+					goto err_exit;
+				}
 				next_ = buff_->next,
 				buff_ = &self->buff_ring[next_];
 				is_rsc_completed =
@@ -327,6 +331,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			if (buff->is_error || buff->is_cso_err) {
 				buff_ = buff;
 				do {
+					if (buff_->next >= self->size) {
+						err = -EIO;
+						goto err_exit;
+					}
 					next_ = buff_->next,
 					buff_ = &self->buff_ring[next_];
 
-- 
2.34.1

