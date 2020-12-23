Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD7B2E1661
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgLWCS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728351AbgLWCSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 075692256F;
        Wed, 23 Dec 2020 02:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689875;
        bh=OWBgphiJE7k6fEgvWfLk664pXq4Nx/tvmfgM2j6gQj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYIA3l2MV7xoB3NaQ1UI8ahK+qc0r5LAI19+mua55V+raWeAmxUQoADxRmkzvZUre
         dcWFG+71mqvf5rsBUODgC2dpi3MvZpfAkBuPaP6SD63IOsc84DD/YXOs8V/inRqG+l
         DC7JsisL28ZWKfgopdzPk7BWfVGUeC3MXTfDXaqbxX4lujHc98KYWNshLetbYAeYXf
         mIpSCBHaLPKaKcQ0C7zzyHTutnOJbZRRj/23YZWA1N2Llrd+z11Xq03r0v2Mp22HQQ
         IkjSQZRqGHTf55Fh+5iqDe2lnbVtv+qqUBiaecB81IqmSINt8GcBVjY++0bePdfJJx
         Aj2Gurp+ZymYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tsuchiya Yuto <kitakar@gmail.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 067/217] mwifiex: pcie: skip cancel_work_sync() on reset failure path
Date:   Tue, 22 Dec 2020 21:13:56 -0500
Message-Id: <20201223021626.2790791-67-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit 4add4d988f95f47493500a7a19c623827061589b ]

If a reset is performed, but even the reset fails for some reasons (e.g.,
on Surface devices, the fw reset requires another quirks),
cancel_work_sync() hangs in mwifiex_cleanup_pcie().

    # firmware went into a bad state
    [...]
    [ 1608.281690] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
    [ 1608.282724] mwifiex_pcie 0000:03:00.0: rx_pending=0, tx_pending=1,	cmd_pending=0
    [ 1608.292400] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    [ 1608.292405] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
    # reset performed after firmware went into a bad state
    [ 1609.394320] mwifiex_pcie 0000:03:00.0: WLAN FW already running! Skip FW dnld
    [ 1609.394335] mwifiex_pcie 0000:03:00.0: WLAN FW is active
    # but even the reset failed
    [ 1619.499049] mwifiex_pcie 0000:03:00.0: mwifiex_cmd_timeout_func: Timeout cmd id = 0xfa, act = 0xe000
    [ 1619.499094] mwifiex_pcie 0000:03:00.0: num_data_h2c_failure = 0
    [ 1619.499103] mwifiex_pcie 0000:03:00.0: num_cmd_h2c_failure = 0
    [ 1619.499110] mwifiex_pcie 0000:03:00.0: is_cmd_timedout = 1
    [ 1619.499117] mwifiex_pcie 0000:03:00.0: num_tx_timeout = 0
    [ 1619.499124] mwifiex_pcie 0000:03:00.0: last_cmd_index = 0
    [ 1619.499133] mwifiex_pcie 0000:03:00.0: last_cmd_id: fa 00 07 01 07 01 07 01 07 01
    [ 1619.499140] mwifiex_pcie 0000:03:00.0: last_cmd_act: 00 e0 00 00 00 00 00 00 00 00
    [ 1619.499147] mwifiex_pcie 0000:03:00.0: last_cmd_resp_index = 3
    [ 1619.499155] mwifiex_pcie 0000:03:00.0: last_cmd_resp_id: 07 81 07 81 07 81 07 81 07 81
    [ 1619.499162] mwifiex_pcie 0000:03:00.0: last_event_index = 2
    [ 1619.499169] mwifiex_pcie 0000:03:00.0: last_event: 58 00 58 00 58 00 58 00 58 00
    [ 1619.499177] mwifiex_pcie 0000:03:00.0: data_sent=0 cmd_sent=1
    [ 1619.499185] mwifiex_pcie 0000:03:00.0: ps_mode=0 ps_state=0
    [ 1619.499215] mwifiex_pcie 0000:03:00.0: info: _mwifiex_fw_dpc: unregister device
    # mwifiex_pcie_work hang happening
    [ 1823.233923] INFO: task kworker/3:1:44 blocked for more than 122 seconds.
    [ 1823.233932]       Tainted: G        WC OE     5.10.0-rc1-1-mainline #1
    [ 1823.233935] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [ 1823.233940] task:kworker/3:1     state:D stack:    0 pid:   44 ppid:     2 flags:0x00004000
    [ 1823.233960] Workqueue: events mwifiex_pcie_work [mwifiex_pcie]
    [ 1823.233965] Call Trace:
    [ 1823.233981]  __schedule+0x292/0x820
    [ 1823.233990]  schedule+0x45/0xe0
    [ 1823.233995]  schedule_timeout+0x11c/0x160
    [ 1823.234003]  wait_for_completion+0x9e/0x100
    [ 1823.234012]  __flush_work.isra.0+0x156/0x210
    [ 1823.234018]  ? flush_workqueue_prep_pwqs+0x130/0x130
    [ 1823.234026]  __cancel_work_timer+0x11e/0x1a0
    [ 1823.234035]  mwifiex_cleanup_pcie+0x28/0xd0 [mwifiex_pcie]
    [ 1823.234049]  mwifiex_free_adapter+0x24/0xe0 [mwifiex]
    [ 1823.234060]  _mwifiex_fw_dpc+0x294/0x560 [mwifiex]
    [ 1823.234074]  mwifiex_reinit_sw+0x15d/0x300 [mwifiex]
    [ 1823.234080]  mwifiex_pcie_reset_done+0x50/0x80 [mwifiex_pcie]
    [ 1823.234087]  pci_try_reset_function+0x5c/0x90
    [ 1823.234094]  process_one_work+0x1d6/0x3a0
    [ 1823.234100]  worker_thread+0x4d/0x3d0
    [ 1823.234107]  ? rescuer_thread+0x410/0x410
    [ 1823.234112]  kthread+0x142/0x160
    [ 1823.234117]  ? __kthread_bind_mask+0x60/0x60
    [ 1823.234124]  ret_from_fork+0x22/0x30
    [...]

This is a deadlock caused by calling cancel_work_sync() in
mwifiex_cleanup_pcie():

- Device resets are done via mwifiex_pcie_card_reset()
- which schedules card->work to call mwifiex_pcie_card_reset_work()
- which calls pci_try_reset_function().
- This leads to mwifiex_pcie_reset_done() be called on the same workqueue,
  which in turn calls
- mwifiex_reinit_sw() and that calls
- _mwifiex_fw_dpc().

The problem is now that _mwifiex_fw_dpc() calls mwifiex_free_adapter()
in case firmware initialization fails. That ends up calling
mwifiex_cleanup_pcie().

Note that all those calls are still running on the workqueue. So when
mwifiex_cleanup_pcie() now calls cancel_work_sync(), it's really waiting
on itself to complete, causing a deadlock.

This commit fixes the deadlock by skipping cancel_work_sync() on a reset
failure path.

After this commit, when reset fails, the following output is
expected to be shown:

    kernel: mwifiex_pcie 0000:03:00.0: info: _mwifiex_fw_dpc: unregister device
    kernel: mwifiex: Failed to bring up adapter: -5
    kernel: mwifiex_pcie 0000:03:00.0: reinit failed: -5

To reproduce this issue, for example, try putting the root port of wifi
into D3 (replace "00:1d.3" with your setup).

    # put into D3 (root port)
    sudo setpci -v -s 00:1d.3 CAP_PM+4.b=0b

Cc: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201028142346.18355-1-kitakar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 18 +++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/pcie.h |  2 ++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6a10ff0377a24..33cf952cc01d3 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -526,6 +526,8 @@ static void mwifiex_pcie_reset_prepare(struct pci_dev *pdev)
 	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
 	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
+
+	card->pci_reset_ongoing = true;
 }
 
 /*
@@ -554,6 +556,8 @@ static void mwifiex_pcie_reset_done(struct pci_dev *pdev)
 		dev_err(&pdev->dev, "reinit failed: %d\n", ret);
 	else
 		mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
+
+	card->pci_reset_ongoing = false;
 }
 
 static const struct pci_error_handlers mwifiex_pcie_err_handler = {
@@ -3142,7 +3146,19 @@ static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 	int ret;
 	u32 fw_status;
 
-	cancel_work_sync(&card->work);
+	/* Perform the cancel_work_sync() only when we're not resetting
+	 * the card. It's because that function never returns if we're
+	 * in reset path. If we're here when resetting the card, it means
+	 * that we failed to reset the card (reset failure path).
+	 */
+	if (!card->pci_reset_ongoing) {
+		mwifiex_dbg(adapter, MSG, "performing cancel_work_sync()...\n");
+		cancel_work_sync(&card->work);
+		mwifiex_dbg(adapter, MSG, "cancel_work_sync() done\n");
+	} else {
+		mwifiex_dbg(adapter, MSG,
+			    "skipped cancel_work_sync() because we're in card reset failure path\n");
+	}
 
 	ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
 	if (fw_status == FIRMWARE_READY_PCIE) {
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 843d57eda8201..5ed613d657094 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -242,6 +242,8 @@ struct pcie_service_card {
 	struct mwifiex_msix_context share_irq_ctx;
 	struct work_struct work;
 	unsigned long work_flags;
+
+	bool pci_reset_ongoing;
 };
 
 static inline int
-- 
2.27.0

