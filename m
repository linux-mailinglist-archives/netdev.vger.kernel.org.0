Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE329D983
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389811AbgJ1Wzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389802AbgJ1Wz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:55:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80473C0613CF;
        Wed, 28 Oct 2020 15:55:29 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y17so1180382ilg.4;
        Wed, 28 Oct 2020 15:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9O9GLT8bithqF+zGWxNcNiILYZ6oOC9lp7vXw06QLU=;
        b=mSK9caYijDX6pt5ckSYxGXTzlXVe8YDObn1TbhjLqPGfhL1v0NtfeZ/8VG0pZeoxvl
         RqnUh6HGW3r+9vs1UONs5MG5EMWELL40e40YOhTzOimeNOn7euGpu/QS+/3AKgFxlax8
         cxa2zvXjLuCWuVPrX9HcxYYUI4FSiaoHrPWzkMJtZhZ3EsQN+7h8HHwy17andmwy77AC
         xIeY079yb3lzvCVBmaYCsguSbEKP9T1NdOUR3ZPLIaLsrTAgfjueVRaIPV+zLzyPdPmV
         F1fOFbiMOTFOMGtgIE3p9PqGtQZFKdgxFFgYBA2V93syDrNyysd382gDjnKByzbo00vv
         dj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9O9GLT8bithqF+zGWxNcNiILYZ6oOC9lp7vXw06QLU=;
        b=M0ln2HCCQO93hZ2spiYrOEjT9pUD2dkrbUNtt4ZjobNgvhbPtiqP/4C8d2lNWL/Qp6
         tTsezME2fCpysyxrVGwg/tjK7/rqMn4GSmjRXF4Ul7Y4WVN1sLseUMyMoyQ8CJbay8gQ
         jhtOCB2dGZ++WuvJCG+Spc/QKo2cwK6zACZtQUh2VukZ1VhZSS9ql5IbRmKN5toG+LBJ
         tN0bsvkyz8ARxHI/kTQmtfRmAPWvw8BikrDx1nP2GqDoya7QM/d2f4WeyH6LX52D4i/2
         vANFg31WjlznpBo1flS5DOBYIUMh7XassCr+Puw6MHTTeQ4Cns4nG2WkRyq7LNCVjhJl
         qvlw==
X-Gm-Message-State: AOAM5330+ZgttmikKFye496FJcf3gI7xlFV5J41EB+b5eSFYAVyVymxe
        FNi3anmAzGgQXifWbKosFJoeR6awcX1efzFO
X-Google-Smtp-Source: ABdhPJw/CWQFexndJh/ruyi8qMUIlWYWZvGwO0VqJ08zwftcP73jwDJ740zITrcKHDZdGe974rEa1w==
X-Received: by 2002:a63:5fd0:: with SMTP id t199mr5651485pgb.140.1603895054553;
        Wed, 28 Oct 2020 07:24:14 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id h184sm5394105pfe.161.2020.10.28.07.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:24:14 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH] mwifiex: pcie: skip cancel_work_sync() on reset failure path
Date:   Wed, 28 Oct 2020 23:23:46 +0900
Message-Id: <20201028142346.18355-1-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
I'm not sure which commit is suitable for the fixes tag. So, I didn't
add it.

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
2.29.1

