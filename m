Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9999510BE8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351605AbiDZWXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346426AbiDZWXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:23:39 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA761EAFB
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:20:29 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y14so12123pfe.10
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JVRFURdG76Dl9sspocpqmwwFtBArwWcQWqjE+72v8EI=;
        b=d1V64UADOytbZfDzDvJ3VfAxmezyXbcsGjfZlN6KFb9k94Y8qkdpcxCILHBfHoIv9Z
         2p2c4EuBMpr1yUDRGvvafKoyb2R1/Xd1I2D+0IbIL92O+pMDCjQ+1HkUZusQ8tws7BOb
         31dCkpLYVicv+Ok4o8bMN5GU/tu4pwAvuS3Cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JVRFURdG76Dl9sspocpqmwwFtBArwWcQWqjE+72v8EI=;
        b=en4q/nIUMoeQSnYwuvnO1NK+KuRdlOo99qR4q0hB8ouayUqMfNzsoLlZLlcAzX7kOA
         8KkjNdgDdRrqQCh7x07ssyuJfoc3EcDoghUWh3yAvJiObDm/cQGebf5kKAgkQP5RZ4nA
         trWwyIKLZH+lfGQqIBOnORM7mlI0VncpUAqEZiYyNuZtfYSHUCv1RkCzFzrlu8qyui47
         ymfWsvtixjvoIwI8BDVyACTbDz7Lm42QmfSYJgKl3BMl8lcYwvRVfFPU7rRT0HsdXDlb
         Ie18WHIcMOIi5a44XrOpCnPTK3rrgn6F4UxJ2p7Nbbw91N8v8SPeThLcM6wjZpMxpzTp
         PUZQ==
X-Gm-Message-State: AOAM532FDAbFHAVbPUELp3BdIXE410KJ2xETuuUNYJFqD3sJH+q3POic
        l83Y6fYyyvCAY7hMJeCTX2hzrg==
X-Google-Smtp-Source: ABdhPJzHnDPpa/XWh62VMiNx0ZNq8fNu0fcxeXXhNFJA5lFTWuZ6hQZaUyNDQQ3ibJy4N+tQ1Y+u/g==
X-Received: by 2002:aa7:8096:0:b0:50c:e24a:3bf8 with SMTP id v22-20020aa78096000000b0050ce24a3bf8mr26662983pff.29.1651011628708;
        Tue, 26 Apr 2022 15:20:28 -0700 (PDT)
Received: from kuabhs-cdev.c.googlers.com.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u2-20020a62d442000000b0050d404f837fsm8029107pfl.156.2022.04.26.15.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 15:20:27 -0700 (PDT)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@kernel.org
Cc:     quic_wgong@quicinc.com, kuabhs@chromium.org,
        briannorris@chromium.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2] ath10k: skip ath10k_halt during suspend for driver state RESTARTING
Date:   Tue, 26 Apr 2022 22:19:55 +0000
Message-Id: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Double free crash is observed when FW recovery(caused by wmi
timeout/crash) is followed by immediate suspend event. The FW recovery
is triggered by ath10k_core_restart() which calls driver clean up via
ath10k_halt(). When the suspend event occurs between the FW recovery,
the restart worker thread is put into frozen state until suspend completes.
The suspend event triggers ath10k_stop() which again triggers ath10k_halt()
The double invocation of ath10k_halt() causes ath10k_htt_rx_free() to be
called twice(Note: ath10k_htt_rx_alloc was not called by restart worker
thread because of its frozen state), causing the crash.

To fix this, during the suspend flow, skip call to ath10k_halt() in
ath10k_stop() when the current driver state is ATH10K_STATE_RESTARTING.
Also, for driver state ATH10K_STATE_RESTARTING, call
ath10k_wait_for_suspend() in ath10k_stop(). This is because call to
ath10k_wait_for_suspend() is skipped later in
[ath10k_halt() > ath10k_core_stop()] for the driver state
ATH10K_STATE_RESTARTING.

The frozen restart worker thread will be cancelled during resume when the
device comes out of suspend.

Below is the crash stack for reference:

[  428.469167] ------------[ cut here ]------------
[  428.469180] kernel BUG at mm/slub.c:4150!
[  428.469193] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  428.469219] Workqueue: events_unbound async_run_entry_fn
[  428.469230] RIP: 0010:kfree+0x319/0x31b
[  428.469241] RSP: 0018:ffffa1fac015fc30 EFLAGS: 00010246
[  428.469247] RAX: ffffedb10419d108 RBX: ffff8c05262b0000
[  428.469252] RDX: ffff8c04a8c07000 RSI: 0000000000000000
[  428.469256] RBP: ffffa1fac015fc78 R08: 0000000000000000
[  428.469276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  428.469285] Call Trace:
[  428.469295]  ? dma_free_attrs+0x5f/0x7d
[  428.469320]  ath10k_core_stop+0x5b/0x6f
[  428.469336]  ath10k_halt+0x126/0x177
[  428.469352]  ath10k_stop+0x41/0x7e
[  428.469387]  drv_stop+0x88/0x10e
[  428.469410]  __ieee80211_suspend+0x297/0x411
[  428.469441]  rdev_suspend+0x6e/0xd0
[  428.469462]  wiphy_suspend+0xb1/0x105
[  428.469483]  ? name_show+0x2d/0x2d
[  428.469490]  dpm_run_callback+0x8c/0x126
[  428.469511]  ? name_show+0x2d/0x2d
[  428.469517]  __device_suspend+0x2e7/0x41b
[  428.469523]  async_suspend+0x1f/0x93
[  428.469529]  async_run_entry_fn+0x3d/0xd1
[  428.469535]  process_one_work+0x1b1/0x329
[  428.469541]  worker_thread+0x213/0x372
[  428.469547]  kthread+0x150/0x15f
[  428.469552]  ? pr_cont_work+0x58/0x58
[  428.469558]  ? kthread_blkcg+0x31/0x31

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Co-developed-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

Changes in v2:
- Fixed typo, replaced ath11k by ath10k in the comments.
- Adjusted the position of my S-O-B tag.
- Added the Tested-on tag.

 drivers/net/wireless/ath/ath10k/mac.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d804e19a742a..e9c1f11fef0a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5345,8 +5345,22 @@ static void ath10k_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->conf_mutex);
 	if (ar->state != ATH10K_STATE_OFF) {
-		if (!ar->hw_rfkill_on)
-			ath10k_halt(ar);
+		if (!ar->hw_rfkill_on) {
+			/* If the current driver state is RESTARTING but not yet
+			 * fully RESTARTED because of incoming suspend event,
+			 * then ath10k_halt is already called via
+			 * ath10k_core_restart and should not be called here.
+			 */
+			if (ar->state != ATH10K_STATE_RESTARTING)
+				ath10k_halt(ar);
+			else
+				/* Suspending here, because when in RESTARTING
+				 * state, ath10k_core_stop skips
+				 * ath10k_wait_for_suspend.
+				 */
+				ath10k_wait_for_suspend(ar,
+							WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
+		}
 		ar->state = ATH10K_STATE_OFF;
 	}
 	mutex_unlock(&ar->conf_mutex);
-- 
2.36.0.464.gb9c8b46e94-goog

