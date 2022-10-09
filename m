Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA8B5F8D2A
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 20:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJIScq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 14:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiJIScp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 14:32:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE77F1A82A
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 11:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665340363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXznQXP5vOjUrkjEnwUIqWLfyHqVdoVCHj9DHnCkya0=;
        b=enCmSqulOxEOW7lftucj52uyXU37oI05q5ul+rsaHMB4RVv8sAyMr36FpW1Cr7MW+0IAK2
        VXhwUn1sdHbA0pMpqqyK14TTxdR3K6eMZKG0mS2t8WAAmKZYSjgF92BSyVqXACxxQfIj6i
        45mDCP0gegBK+H3g2CM/CAwXLIDcUYU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-410-xoe08MVvOjuu44iMQ1mmpw-1; Sun, 09 Oct 2022 14:32:41 -0400
X-MC-Unique: xoe08MVvOjuu44iMQ1mmpw-1
Received: by mail-pj1-f70.google.com with SMTP id z24-20020a17090abd9800b0020d43dcc8c3so281296pjr.9
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 11:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hXznQXP5vOjUrkjEnwUIqWLfyHqVdoVCHj9DHnCkya0=;
        b=ilvXq7ephTwzQ7rWdaSELnC59xDZlhbSnWubRL7GVJfXO4YIKaa8X2CdivkMgbgeNx
         8j1CzFQapHwI46gY0rhj9RFOhPV8VpAKLxGVeGzdxvO/wW83yjaIiI3oEVZQgf16HVrq
         JxdN7XErjC+2HyfKWvB7W73wWUj0GSvRTYQtJaZfFmGQ/oJlg4OPk0AT/xBFD/dkvvE6
         M0HNZGWpVoAnTTyYVzns/MVlJn1KEPWKLLm3fba2KZQ8Dc/QKlk3dNr6o6EMwTKYk3Vg
         EGmwuT17QMY+hhiL23At5p2GAaL28j1HXDLOrr1K3le4M6gzI6EIdIruu5Vw2HU8B9oK
         +OHw==
X-Gm-Message-State: ACrzQf1EK7cHSCx0rKsdSqROauR+IkvEmWAXdUEVnnJBkmPuZMBcY3Jy
        VyXBEiEEnz10xJaAoVlQ40T67+9iMk6zcbweXlhRvA5hnXijJQIv4kG5/wEiiSqPHqNihUzKfpX
        hZUAkJVDpCIgzfhjD
X-Received: by 2002:a65:4048:0:b0:441:85ee:7a6a with SMTP id h8-20020a654048000000b0044185ee7a6amr13857254pgp.39.1665340360433;
        Sun, 09 Oct 2022 11:32:40 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM70wJCNapq9lGySt9W9fJBMz00VpBEVfQbGlYMERayDIgx4flpSUdIlH3hrxxbZY56iH/BSLQ==
X-Received: by 2002:a65:4048:0:b0:441:85ee:7a6a with SMTP id h8-20020a654048000000b0044185ee7a6amr13857233pgp.39.1665340360087;
        Sun, 09 Oct 2022 11:32:40 -0700 (PDT)
Received: from xps13.. ([240d:1a:c0d:9f00:4f2f:926a:23dd:8588])
        by smtp.gmail.com with ESMTPSA id l76-20020a633e4f000000b00460a5c6304dsm2393839pga.67.2022.10.09.11.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Oct 2022 11:32:39 -0700 (PDT)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     pontus.fuchs@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com
Subject: [PATCH] ar5523: Fix use-after-free on ar5523_cmd() timed out
Date:   Mon, 10 Oct 2022 03:32:23 +0900
Message-Id: <20221009183223.420015-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 6f937d2cc126..ce3d613fa36c 100644
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
2.37.3

