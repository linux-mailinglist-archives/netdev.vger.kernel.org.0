Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407C04835D4
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiACRac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbiACR3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:29:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7152C061799;
        Mon,  3 Jan 2022 09:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 540356119A;
        Mon,  3 Jan 2022 17:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77F9C36AED;
        Mon,  3 Jan 2022 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230961;
        bh=rQWPm9cXJfuksOaoRvd/2G82SysMisSSSu3E4i638IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjPyxw8HW7laJ6MyysQpRXDVOJfel/ZQoA7coWD7gyzL3OW0Jf4pcv53r2bnjArCQ
         elMcHxpDjf+2VmHYwGfkm9/w3DRA29DMxnb+eJLW+gsmHC4MM2/PwVwKeXzfhN5yvq
         CLf4CQYFUudTNZt3wiRE80leKGdTefYqTp0VoNK3rxENS3BV6e+ExMnDXwD74EQzFK
         jxiNx7o7EHhwG1uL6zz/+S24kdZFNqtxzYiAOOgQ2EU5ldj96MG0STifh8UL4RSsFG
         SEb2OX5ZPye087XD+no03H9aBxNjHQs5jWHJguBWB1LOP5kUkLbv1vbiuxPWdho2Jd
         krXBDLcBM2Q9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/16] atlantic: Fix buff_ring OOB in aq_ring_rx_clean
Date:   Mon,  3 Jan 2022 12:28:41 -0500
Message-Id: <20220103172849.1612731-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
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
index 24122ccda614c..72f8751784c31 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -365,6 +365,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
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
@@ -388,6 +392,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			    (buff->is_lro && buff->is_cso_err)) {
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

