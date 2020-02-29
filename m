Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A311A174931
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgB2UaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 15:30:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53816 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgB2UaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 15:30:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id f15so7157587wml.3
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 12:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=8q+K72TqZR65w66dq8YMSxJT3l85wbNTaC/2l3mGYZ4=;
        b=qeGCOnnLDcydIHvNhLF3N/QaUPT1SxdGk0jx4+MWlw6UfzK772h6BEZ1f7rFEF05Fb
         rsod7DCiRUIbOQKQnxBf5hB1GH8Dn4gv/X9SUqrqWmzVee29Dft2hkeniJkD47pamb2V
         FXSqhDexuDj5T/C3aUsWyXRI8KfwdHn+PVUwUOHmLZ65VSN2dXcb1WTOqIVhiJQWaiV+
         wvKNv+SVt4DfmZxUjjglBAHFocqGnU0T8KROmXhzDIe/wlPXySftTwQN/a/pVATpeVHs
         dgNuhpbNEfpBWXAZcbavn682l4pUVdzKQLmKCoVwrO+KDYnl8bkt/6v9wVtXiiyGJHZ8
         dYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=8q+K72TqZR65w66dq8YMSxJT3l85wbNTaC/2l3mGYZ4=;
        b=NS27UZeOsTGhmKcW2urDSfClBjM7PGDoMiEoqpIbH7FzmED2tYeGS307mytJYwV3va
         7p4CIiC0rsap7J0Lh/Zz7GlQwmFc4vk5ZLwKtg34nqKBlOnxEoQ8QmHwPlkmFkTB2yee
         PG+Zu2KQmusW364ca0PkPU59+RhKi8LLVuIYf1HM24XFfz/l2jmSxn8R0jxgdqLLLZtv
         8nb8u5UggeCwP/v8lF0+8cZj1yNtpR92MxFJKnpPeEwlSO1Ad+ivKcLitxsFGp9dnL+O
         /T2UHEStUNzWe447u6liQvDIS4qEYL+3xQhGhYyws8UUfeBd0iDTzQnOl01xNdB+co2m
         oTBQ==
X-Gm-Message-State: APjAAAW1hj6baJeXlvHDlZIdcExaQ0IzfQc63GtY8ONSU7TpmlS788Vo
        ero3pEKYqDNPqB3gC9xUF9w=
X-Google-Smtp-Source: APXvYqzz3x0BoxM3BKC6kdGC1FEzXrqkgFTQAsljSqGHzlU13xamUYg4Nq8LXg/XxevGnVwfUACoIg==
X-Received: by 2002:a1c:960c:: with SMTP id y12mr10922979wmd.9.1583008221067;
        Sat, 29 Feb 2020 12:30:21 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id o26sm7502028wmc.33.2020.02.29.12.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 12:30:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: sja1105: Don't destroy not-yet-created xmit_worker
Date:   Sat, 29 Feb 2020 22:30:07 +0200
Message-Id: <20200229203007.16703-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following NULL pointer dereference on PHY connect error path
teardown:

[    2.291010] sja1105 spi0.1: Probed switch chip: SJA1105T
[    2.310044] sja1105 spi0.1: Enabled switch tagging
[    2.314970] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
[    2.322463] 8<--- cut here ---
[    2.325497] Unable to handle kernel NULL pointer dereference at virtual address 00000018
[    2.333555] pgd = (ptrval)
[    2.336241] [00000018] *pgd=00000000
[    2.339797] Internal error: Oops: 5 [#1] SMP ARM
[    2.344384] Modules linked in:
[    2.347420] CPU: 1 PID: 64 Comm: kworker/1:1 Not tainted 5.5.0-rc5 #1
[    2.353820] Hardware name: Freescale LS1021A
[    2.358070] Workqueue: events deferred_probe_work_func
[    2.363182] PC is at kthread_destroy_worker+0x4/0x74
[    2.368117] LR is at sja1105_teardown+0x70/0xb4
[    2.372617] pc : [<c036cdd4>]    lr : [<c0b89238>]    psr: 60000013
[    2.378845] sp : eeac3d30  ip : eeab1900  fp : eef45480
[    2.384036] r10: eef4549c  r9 : 00000001  r8 : 00000000
[    2.389227] r7 : eef527c0  r6 : 00000034  r5 : ed8ddd0c  r4 : ed8ddc40
[    2.395714] r3 : 00000000  r2 : 00000000  r1 : eef4549c  r0 : 00000000
[    2.402204] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[    2.409297] Control: 10c5387d  Table: 8020406a  DAC: 00000051
[    2.415008] Process kworker/1:1 (pid: 64, stack limit = 0x(ptrval))
[    2.421237] Stack: (0xeeac3d30 to 0xeeac4000)
[    2.612635] [<c036cdd4>] (kthread_destroy_worker) from [<c0b89238>] (sja1105_teardown+0x70/0xb4)
[    2.621379] [<c0b89238>] (sja1105_teardown) from [<c10717fc>] (dsa_switch_teardown.part.1+0x48/0x74)
[    2.630467] [<c10717fc>] (dsa_switch_teardown.part.1) from [<c1072438>] (dsa_register_switch+0x8b0/0xbf4)
[    2.639984] [<c1072438>] (dsa_register_switch) from [<c0b89c30>] (sja1105_probe+0x2ac/0x464)
[    2.648378] [<c0b89c30>] (sja1105_probe) from [<c0b11a5c>] (spi_drv_probe+0x7c/0xa0)
[    2.656081] [<c0b11a5c>] (spi_drv_probe) from [<c0a26ab8>] (really_probe+0x208/0x480)
[    2.663871] [<c0a26ab8>] (really_probe) from [<c0a26f0c>] (driver_probe_device+0x78/0x1c4)
[    2.672093] [<c0a26f0c>] (driver_probe_device) from [<c0a24c48>] (bus_for_each_drv+0x80/0xc4)
[    2.680574] [<c0a24c48>] (bus_for_each_drv) from [<c0a26810>] (__device_attach+0xd0/0x168)
[    2.688794] [<c0a26810>] (__device_attach) from [<c0a259d8>] (bus_probe_device+0x84/0x8c)
[    2.696927] [<c0a259d8>] (bus_probe_device) from [<c0a25f24>] (deferred_probe_work_func+0x84/0xc4)
[    2.705842] [<c0a25f24>] (deferred_probe_work_func) from [<c03667b0>] (process_one_work+0x22c/0x560)
[    2.714926] [<c03667b0>] (process_one_work) from [<c0366d8c>] (worker_thread+0x2a8/0x5d4)
[    2.723059] [<c0366d8c>] (worker_thread) from [<c036cf94>] (kthread+0x150/0x154)
[    2.730416] [<c036cf94>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)

Checking for NULL pointer is correct because the per-port xmit kernel
threads are created in sja1105_probe immediately after calling
dsa_register_switch.

Fixes: a68578c20a96 ("net: dsa: Make deferred_xmit private to sja1105")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index acf58c34c8be..64aaf1b74259 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1971,7 +1971,8 @@ static void sja1105_teardown(struct dsa_switch *ds)
 		if (!dsa_is_user_port(ds, port))
 			continue;
 
-		kthread_destroy_worker(sp->xmit_worker);
+		if (sp->xmit_worker)
+			kthread_destroy_worker(sp->xmit_worker);
 	}
 
 	sja1105_tas_teardown(ds);
-- 
2.17.1

