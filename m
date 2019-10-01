Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB3CC40A0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfJATHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:07:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44581 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJATHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:07:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id z9so3693279wrl.11
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 12:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=duvmQrLASend+2POPpxhDdqpGtPPwbHVJC0F3HaMz9k=;
        b=sGcqh9tjpxLiU03vB9j2nQItdyjnHSoihXtWuQYfMwe/rAF1bi7mETZPifRVrnLy3l
         1D6tea6oqlNf4CwLsWP0WC/I7GKzEch64HGbwuXgnISlGJm3emHQnDfaFsrACoxnSAQD
         /Dw74qfW4IHjDE/X0AqTpYjc0mnopglLwFUb0xWlw10NHJWE5uo50IYU+VWGpxVT/6zx
         cC5Nlcmkj1gYTCar5BH+GyO3R+vygoo9xY3fw+j/WbHEdgaHzytiKShXf7/YHixbkKoK
         hz7wmXmxc1LfVv5Rahfy9Qnnqc1HM22uEGnQQZIrd2P6D9ERDJJVembmqRjTOAEKdMa+
         oguw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=duvmQrLASend+2POPpxhDdqpGtPPwbHVJC0F3HaMz9k=;
        b=rI4aMl8FXgMsTOeeYIcdCydwXy0kgfgXgz19INDCoklFfGQsyz/TPe6VLpdrn2Nfn0
         9hMv0AU22tkNBo2PwulrvIw7F39Uk8WJd0dMDw+Pkvma5alvBREsaTYtovUz8U0knojH
         xnaJF5Tc6C5hMZzPta2wf70rZrMJrh82cpZNjXtUzF6X0mlTccjKM0rH30FA3JEGS9Bu
         uOegNQpSj8RbCmSv+BOKNS6EW+zHpZ4rw2ghdZIivWoDVpgzhzl3X92eDATQMLxIpMfp
         0RR+Y6Kw28SkY9Rmbipgs5uCiWrKmy3AfKjb/JGTw0mgI9iZCzK5lrz9MBto+y4VEd85
         Z4Cw==
X-Gm-Message-State: APjAAAWGsmo3gwJwuVP6n40PCNJE/DASwXtMaNLVpK0n0t3OqFCUTgtU
        ktvDFRjYaR3u68SDdEvmgmtwEn2A
X-Google-Smtp-Source: APXvYqyOd1xSPf0Q+b99SKvPeyPSjYZlqHI9+h7ovdUWJnI1/UPW/tRPbFPdv/A2gDruIYd+pb07eg==
X-Received: by 2002:a5d:6943:: with SMTP id r3mr18666142wrw.21.1569956829543;
        Tue, 01 Oct 2019 12:07:09 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id s12sm36648477wra.82.2019.10.01.12.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:07:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net] ptp_qoriq: Initialize the registers' spinlock before calling ptp_qoriq_settime
Date:   Tue,  1 Oct 2019 22:07:01 +0300
Message-Id: <20191001190701.5754-1-olteanv@gmail.com>
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

Fixes: ff54571a747b ("ptp_qoriq: convert to use ptp_qoriq_init/free")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Followed Richard Cochran's feedback:

	Please fix the actual bug, the spin lock issue, and don't worry about
	changing the initial value.

 drivers/ptp/ptp_qoriq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index c61f00b72e15..a577218d1ab7 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -507,6 +507,8 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 		ptp_qoriq->regs.etts_regs = base + ETTS_REGS_OFFSET;
 	}
 
+	spin_lock_init(&ptp_qoriq->lock);
+
 	ktime_get_real_ts64(&now);
 	ptp_qoriq_settime(&ptp_qoriq->caps, &now);
 
@@ -514,7 +516,6 @@ int ptp_qoriq_init(struct ptp_qoriq *ptp_qoriq, void __iomem *base,
 	  (ptp_qoriq->tclk_period & TCLK_PERIOD_MASK) << TCLK_PERIOD_SHIFT |
 	  (ptp_qoriq->cksel & CKSEL_MASK) << CKSEL_SHIFT;
 
-	spin_lock_init(&ptp_qoriq->lock);
 	spin_lock_irqsave(&ptp_qoriq->lock, flags);
 
 	regs = &ptp_qoriq->regs;
-- 
2.17.1

