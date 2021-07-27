Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637983D8202
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhG0Vol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhG0Vok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:44:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15B2C061757;
        Tue, 27 Jul 2021 14:44:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c16so122430plh.7;
        Tue, 27 Jul 2021 14:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3KPt1GPvL5XMf6x4iIuebcXLQlUcJ+y0yMw39x8Q0fQ=;
        b=g7mWBdVfo+GwkuKargaV3o0+CVAKth30tV1+fjXJIq1FAk00Mv/x3s62arsMKSunRR
         Ymz3s25Y1zRTtlGF1yM4fEiQiOB7GF6HJaB7YydQLwMLPcLe5qyVMAZhMyzFEFynuebZ
         v4pKkwwBxZij5hnNarVy8zFaXQQdc/eN5focZ59lDpFlYEIx/wyWCRmPFsLiccqmUvWY
         dO5xwuAEi1KSGlhLid4nEIGi/8fWEL7xY53NTZf5yAjWYoNO51iRMwSsjby/FxMeL2Wx
         qIfCmdTUc7RtRNwcIdEuhSRaoWhXaeoGuZd/TfQGR4/HrCqMfTbP1Nw0oNe3fmkY7ivt
         zcgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3KPt1GPvL5XMf6x4iIuebcXLQlUcJ+y0yMw39x8Q0fQ=;
        b=dpj7GmuSGhtUUETsTvnaa6/vnar8CSYE9fo+kzaw6uYXxF6Y5ggHVoY7UO6SkyKu3w
         vGGRC4sBfLdjv9hnZI0ugCVUaHaPzaJnUTq4+leU2lB6XetRJ0SAob0KcuQcrD6to0EV
         MlB2pXpyHfh9muN4GMVp25suQrBtajxBDelULHy8DQtyzg1i6lwzkw4UB8pUkQMiXBnx
         kXBaaMdeCQ7ozj7C50KZljih1pe5sbGXm9tZj/6jpSNchpZYuo31kDIm8/UyjfTOOrnU
         Wyy0DLjAN3BJhsASy4FpMZLsBb0BoqK/fPRfJe28JKpwCcm6nbESqRG5DV6fyf7Ven/e
         rfrA==
X-Gm-Message-State: AOAM533+Qas/qeIcgJRHgAYvzOPitr34i4JBqqVA20IANqn/6euWxwXM
        7g2puQwpKWWzA6ZGL1HxSD4=
X-Google-Smtp-Source: ABdhPJxO0mk/xwRIo1yOKogLvCnVLCqPH0q6qWqEkuQyJqLFtFTvYGjUZ2rRdA9lT413gBZVGLabHg==
X-Received: by 2002:a17:90b:4d8a:: with SMTP id oj10mr6217722pjb.235.1627422279483;
        Tue, 27 Jul 2021 14:44:39 -0700 (PDT)
Received: from novachrono.domain.name ([122.163.131.208])
        by smtp.gmail.com with ESMTPSA id z9sm4899543pfa.2.2021.07.27.14.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:44:39 -0700 (PDT)
From:   Rajat Asthana <rajatasthana4@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Rajat Asthana <rajatasthana4@gmail.com>
Subject: [PATCH] ath9k_htc: Add a missing spin_lock_init()
Date:   Wed, 28 Jul 2021 03:13:58 +0530
Message-Id: <20210727214358.466397-1-rajatasthana4@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reported a lockdep warning on non-initialized spinlock:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x143/0x1db lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:937 [inline]
 register_lock_class+0x1077/0x1180 kernel/locking/lockdep.c:1249
 __lock_acquire+0x102/0x5230 kernel/locking/lockdep.c:4781
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x19d/0x700 kernel/locking/lockdep.c:5477
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 ath9k_wmi_event_tasklet+0x231/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:172
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x1b0/0x944 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x21/0x50 kernel/softirq.c:913
 smpboot_thread_fn+0x3ec/0x870 kernel/smpboot.c:165
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

We missed a spin_lock_init() in ath9k_wmi_event_tasklet() when the wmi
event is WMI_TXSTATUS_EVENTID. Placing this init here instead of
ath9k_init_wmi() is fine mainly because we need this spinlock when the
event is WMI_TXSTATUS_EVENTID and hence it should be initialized when it
is needed.

Signed-off-by: Rajat Asthana <rajatasthana4@gmail.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index fe29ad4b9023..446b7ca459df 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -169,6 +169,7 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 					     &wmi->drv_priv->fatal_work);
 			break;
 		case WMI_TXSTATUS_EVENTID:
+			spin_lock_init(&priv->tx.tx_lock);
 			spin_lock_bh(&priv->tx.tx_lock);
 			if (priv->tx.flags & ATH9K_HTC_OP_TX_DRAIN) {
 				spin_unlock_bh(&priv->tx.tx_lock);
-- 
2.32.0

