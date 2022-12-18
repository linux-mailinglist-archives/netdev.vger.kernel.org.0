Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B041E6501DB
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiLRQhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiLRQgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:36:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F93E037;
        Sun, 18 Dec 2022 08:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0202AB80B43;
        Sun, 18 Dec 2022 16:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFF1C433D2;
        Sun, 18 Dec 2022 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379984;
        bh=DamKgXosryxREHkAfv+j4U/MRQoJtVs+Akr1R/l0BzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tofn/TBYAQhOAznBm6LHVorR8z35d9SfN0hzOE84HX5aYq7qyqdlNxmUJcYmgeTRh
         sqY1jaQCvF4yoUoLvxFVkoMa1PY27lLXJ+63YMbQub0Wi8ae6iZIMxWw3fYGH2sQuQ
         EmsjeINbAPh43K6mBCkjp1wgJCTH6mG52RgTubUpgtkUTtHek4zzjzzs4isU7+bUDG
         RG8QPHn0sDn07I8CDwgyO4eZ0EWqlxj+oUubkfu3r6xoCnOQUIS89Zv3p3k7ryiNfT
         faM3MqdmjU5PcsiXClM+JAfMg9JPW/xI3YObz8ZddCdnUSdHIohWE9JOUE+v/lkUG6
         uIc1RkM0Ho04Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, pontus.fuchs@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/46] wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out
Date:   Sun, 18 Dec 2022 11:12:03 -0500
Message-Id: <20221218161244.930785-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit b6702a942a069c2a975478d719e98d83cdae1797 ]

syzkaller reported use-after-free with the stack trace like below [1]:

[   38.960489][    C3] ==================================================================
[   38.963216][    C3] BUG: KASAN: use-after-free in ar5523_cmd_tx_cb+0x220/0x240
[   38.964950][    C3] Read of size 8 at addr ffff888048e03450 by task swapper/3/0
[   38.966363][    C3]
[   38.967053][    C3] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 6.0.0-09039-ga6afa4199d3d-dirty #18
[   38.968464][    C3] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
[   38.969959][    C3] Call Trace:
[   38.970841][    C3]  <IRQ>
[   38.971663][    C3]  dump_stack_lvl+0xfc/0x174
[   38.972620][    C3]  print_report.cold+0x2c3/0x752
[   38.973626][    C3]  ? ar5523_cmd_tx_cb+0x220/0x240
[   38.974644][    C3]  kasan_report+0xb1/0x1d0
[   38.975720][    C3]  ? ar5523_cmd_tx_cb+0x220/0x240
[   38.976831][    C3]  ar5523_cmd_tx_cb+0x220/0x240
[   38.978412][    C3]  __usb_hcd_giveback_urb+0x353/0x5b0
[   38.979755][    C3]  usb_hcd_giveback_urb+0x385/0x430
[   38.981266][    C3]  dummy_timer+0x140c/0x34e0
[   38.982925][    C3]  ? notifier_call_chain+0xb5/0x1e0
[   38.984761][    C3]  ? rcu_read_lock_sched_held+0xb/0x60
[   38.986242][    C3]  ? lock_release+0x51c/0x790
[   38.987323][    C3]  ? _raw_read_unlock_irqrestore+0x37/0x70
[   38.988483][    C3]  ? __wake_up_common_lock+0xde/0x130
[   38.989621][    C3]  ? reacquire_held_locks+0x4a0/0x4a0
[   38.990777][    C3]  ? lock_acquire+0x472/0x550
[   38.991919][    C3]  ? rcu_read_lock_sched_held+0xb/0x60
[   38.993138][    C3]  ? lock_acquire+0x472/0x550
[   38.994890][    C3]  ? dummy_urb_enqueue+0x860/0x860
[   38.996266][    C3]  ? do_raw_spin_unlock+0x16f/0x230
[   38.997670][    C3]  ? dummy_urb_enqueue+0x860/0x860
[   38.999116][    C3]  call_timer_fn+0x1a0/0x6a0
[   39.000668][    C3]  ? add_timer_on+0x4a0/0x4a0
[   39.002137][    C3]  ? reacquire_held_locks+0x4a0/0x4a0
[   39.003809][    C3]  ? __next_timer_interrupt+0x226/0x2a0
[   39.005509][    C3]  __run_timers.part.0+0x69a/0xac0
[   39.007025][    C3]  ? dummy_urb_enqueue+0x860/0x860
[   39.008716][    C3]  ? call_timer_fn+0x6a0/0x6a0
[   39.010254][    C3]  ? cpuacct_percpu_seq_show+0x10/0x10
[   39.011795][    C3]  ? kvm_sched_clock_read+0x14/0x40
[   39.013277][    C3]  ? sched_clock_cpu+0x69/0x2b0
[   39.014724][    C3]  run_timer_softirq+0xb6/0x1d0
[   39.016196][    C3]  __do_softirq+0x1d2/0x9be
[   39.017616][    C3]  __irq_exit_rcu+0xeb/0x190
[   39.019004][    C3]  irq_exit_rcu+0x5/0x20
[   39.020361][    C3]  sysvec_apic_timer_interrupt+0x8f/0xb0
[   39.021965][    C3]  </IRQ>
[   39.023237][    C3]  <TASK>

In ar5523_probe(), ar5523_host_available() calls ar5523_cmd() as below
(there are other functions which finally call ar5523_cmd()):

ar5523_probe()
-> ar5523_host_available()
   -> ar5523_cmd_read()
      -> ar5523_cmd()

If ar5523_cmd() timed out, then ar5523_host_available() failed and
ar5523_probe() freed the device structure.  So, ar5523_cmd_tx_cb()
might touch the freed structure.

This patch fixes this issue by canceling in-flight tx cmd if submitted
urb timed out.

Link: https://syzkaller.appspot.com/bug?id=9e12b2d54300842b71bdd18b54971385ff0d0d3a [1]
Reported-by: syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221009183223.420015-1-syoshida@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 1baec4b412c8..efe38b2c1df7 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -241,6 +241,11 @@ static void ar5523_cmd_tx_cb(struct urb *urb)
 	}
 }
 
+static void ar5523_cancel_tx_cmd(struct ar5523 *ar)
+{
+	usb_kill_urb(ar->tx_cmd.urb_tx);
+}
+
 static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 		      int ilen, void *odata, int olen, int flags)
 {
@@ -280,6 +285,7 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 	}
 
 	if (!wait_for_completion_timeout(&cmd->done, 2 * HZ)) {
+		ar5523_cancel_tx_cmd(ar);
 		cmd->odata = NULL;
 		ar5523_err(ar, "timeout waiting for command %02x reply\n",
 			   code);
-- 
2.35.1

