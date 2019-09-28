Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A0C1256
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 00:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfI1WWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 18:22:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51376 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbfI1WWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 18:22:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so9444989wme.1
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 15:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RfsDFnCvOL2Y4dMIE5ciko7IWILgqEzgM4jEzGE0lxU=;
        b=flLMU9VYTMtwvHG4IOcrHKBG7ku2jpwB47ftrZ4sFdle4KWKffi9SkVrNoDHrhG2RQ
         9uOUe/NRkmIN4JhFu5v1+zaZtNeEbRIbMQvtd39zJ347X3B385JGfFXXcPC5R7TEyfQd
         7FWodXH9cVh+EcehgCmqX1gdCx/j5pvIbSj9PpV4Uturh0bdebJG1i22sIWfeJuejvSY
         YWjkmJKHtjer8kzRPzjErWDjzQ87AKfpsDhxnCHKQ1Aw75G4nUwfzU6Gmpy2KSB21oXp
         fXCzy4DRpjFIPi/gLzlqYl+En88t7OuGebm1vh9LlXRtAiUTXGh07/hfT/wMO73GrC0w
         BhtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RfsDFnCvOL2Y4dMIE5ciko7IWILgqEzgM4jEzGE0lxU=;
        b=Ktf7oKETIHAXvoR9h1Elre1+w5Z3nJlPoN2YdZ3Jh/5b6ZHmmCsOnDpHoYgpQ1qjEK
         CO/eFCRIYXro7ZK/t5AYr63AID6j9aij9W3fyLlL7F1tY7V6St58cQUSFrcr8dP7snv0
         RnFZZIHiL1i2QkSJSnKqMiENtO7o0lnnXb9lXOHR4B4T+GJIBJEW7O34Lalvl7mKUT7Z
         snfVF1KyHq+MjnALDZvJXKuI2CFL3VncLZ+/itHxxrYOlFKq/Bh30hLMhWIuNmofYtPV
         mt5OxGHOAV/JgxbmYQEv1DSI1770CIFpSuxeDhGKvi8cByHs6NrCqOlRLjvPW+grOj8u
         jObA==
X-Gm-Message-State: APjAAAXqoRcZQLHXJSAvKRdrt/KQJ6f3XJfWEoloe4dpHYTxkvVjavPe
        XoFrnveqoJHJFCr23It/0tI=
X-Google-Smtp-Source: APXvYqxyBa/b7EeUDemuVzYkqtxlfWpp1lYSHO35SfOKQJW6mCO7bK8siy4OPS/GUbOKqTI8cwCLSg==
X-Received: by 2002:a1c:1b14:: with SMTP id b20mr11052137wmb.122.1569709361717;
        Sat, 28 Sep 2019 15:22:41 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id g4sm7952955wrw.9.2019.09.28.15.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 15:22:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] ptp_qoriq: Don't write system time into PHC at boot
Date:   Sun, 29 Sep 2019 01:22:28 +0300
Message-Id: <20190928222228.27493-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because ptp_qoriq_settime is being called prior to spin_lock_init, the
following stack trace can be seen at driver probe time:

[    2.269117] the code is fine but needs lockdep annotation.
[    2.274569] turning off the locking correctness validator.
[    2.280027] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc7-01478-g01eaa67a4797 #263
[    2.288073] Hardware name: Freescale LS1021A
[    2.292337] [<c0313cb4>] (unwind_backtrace) from [<c030e11c>] (show_stack+0x10/0x14)
[    2.300045] [<c030e11c>] (show_stack) from [<c1219440>] (dump_stack+0xcc/0xf8)
[    2.307235] [<c1219440>] (dump_stack) from [<c03b9b44>] (register_lock_class+0x730/0x73c)
[    2.315372] [<c03b9b44>] (register_lock_class) from [<c03b6190>] (__lock_acquire+0x78/0x270c)
[    2.323856] [<c03b6190>] (__lock_acquire) from [<c03b90cc>] (lock_acquire+0xe0/0x22c)
[    2.331649] [<c03b90cc>] (lock_acquire) from [<c123c310>] (_raw_spin_lock_irqsave+0x54/0x68)
[    2.340048] [<c123c310>] (_raw_spin_lock_irqsave) from [<c0e73fe4>] (ptp_qoriq_settime+0x38/0x80)
[    2.348878] [<c0e73fe4>] (ptp_qoriq_settime) from [<c0e746d4>] (ptp_qoriq_init+0x1f8/0x484)
[    2.357189] [<c0e746d4>] (ptp_qoriq_init) from [<c0e74aac>] (ptp_qoriq_probe+0xd0/0x184)
[    2.365243] [<c0e74aac>] (ptp_qoriq_probe) from [<c0b0a07c>] (platform_drv_probe+0x48/0x9c)
[    2.373555] [<c0b0a07c>] (platform_drv_probe) from [<c0b07a14>] (really_probe+0x1c4/0x400)
[    2.381779] [<c0b07a14>] (really_probe) from [<c0b07e28>] (driver_probe_device+0x78/0x1b8)
[    2.390003] [<c0b07e28>] (driver_probe_device) from [<c0b081d0>] (device_driver_attach+0x58/0x60)
[    2.398832] [<c0b081d0>] (device_driver_attach) from [<c0b082d4>] (__driver_attach+0xfc/0x160)
[    2.407402] [<c0b082d4>] (__driver_attach) from [<c0b05a84>] (bus_for_each_dev+0x68/0xb4)
[    2.415539] [<c0b05a84>] (bus_for_each_dev) from [<c0b06b68>] (bus_add_driver+0x104/0x20c)
[    2.423763] [<c0b06b68>] (bus_add_driver) from [<c0b0909c>] (driver_register+0x78/0x10c)
[    2.431815] [<c0b0909c>] (driver_register) from [<c030313c>] (do_one_initcall+0x8c/0x3ac)
[    2.439954] [<c030313c>] (do_one_initcall) from [<c1f013f4>] (kernel_init_freeable+0x468/0x548)
[    2.448610] [<c1f013f4>] (kernel_init_freeable) from [<c12344d8>] (kernel_init+0x8/0x10c)
[    2.456745] [<c12344d8>] (kernel_init) from [<c03010b4>] (ret_from_fork+0x14/0x20)
[    2.464273] Exception stack(0xea89ffb0 to 0xea89fff8)
[    2.469297] ffa0:                                     00000000 00000000 00000000 00000000
[    2.477432] ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.485566] ffe0: 00000000 00000000 00000000 00000000 00000013 00000000

This behavior has been introduced during the rework commit ff54571a747b
("ptp_qoriq: convert to use ptp_qoriq_init/free"), so technically it is
a fix for that.

But I couldn't find a justification to just move the spin_lock_init a
few lines above, because I don't see why the ptp_qoriq_settime call
should be done at all at probe time. Writing a CLOCK_REALTIME value into
a timer that is supposed to track CLOCK_TAI means there will be a 37
second offset that's going to render it useless for any practical
purpose. Even furthermore, there may be concurrency with RTC drivers at
probe time which is not handled (or there may be no RTC on the platform
at all), so in practice even if the code is there, the ptp_qoriq clock
may still tick in Jan 1st, 1970 until a better clock source becomes
available.

So just remove the ptp_qoriq_settime call and let the clock tick in 1970
until user space does something about it. Most other PTP drivers do the
same, except chelsio cxgb4 and maybe a few others.

So while this is in fact changing the behavior that the ptp_qoriq
(formerly gianfar_ptp) has had since day one, it is only fixing a recent
rework commit.

Fixes: ff54571a747b ("ptp_qoriq: convert to use ptp_qoriq_init/free")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/ptp/ptp_qoriq.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index c61f00b72e15..5dbcca2332d5 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -450,7 +450,6 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 {
 	struct device_node *node = ptp_qoriq->dev->of_node;
 	struct ptp_qoriq_registers *regs;
-	struct timespec64 now;
 	unsigned long flags;
 	u32 tmr_ctrl;
 
@@ -507,9 +506,6 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 		ptp_qoriq->regs.etts_regs = base + ETTS_REGS_OFFSET;
 	}
 
-	ktime_get_real_ts64(&now);
-	ptp_qoriq_settime(&ptp_qoriq->caps, &now);
-
 	tmr_ctrl =
 	  (ptp_qoriq->tclk_period & TCLK_PERIOD_MASK) << TCLK_PERIOD_SHIFT |
 	  (ptp_qoriq->cksel & CKSEL_MASK) << CKSEL_SHIFT;
-- 
2.17.1

