Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43631E452C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437669AbfJYIER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:04:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:51668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405453AbfJYIER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 04:04:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB135B930;
        Fri, 25 Oct 2019 08:04:14 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>
Subject: [PATCH] net: usb: lan78xx: Disable interrupts before calling generic_handle_irq()
Date:   Fri, 25 Oct 2019 10:04:13 +0200
Message-Id: <20191025080413.22665-1-dwagner@suse.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lan78xx_status() will run with interrupts enabled due to the change in
ed194d136769 ("usb: core: remove local_irq_save() around ->complete()
handler"). generic_handle_irq() expects to be run with IRQs disabled.

[    4.886203] 000: irq 79 handler irq_default_primary_handler+0x0/0x8 enabled interrupts
[    4.886243] 000: WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x154/0x168
[    4.896294] 000: Modules linked in:
[    4.896301] 000: CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.6 #39
[    4.896310] 000: Hardware name: Raspberry Pi 3 Model B+ (DT)
[    4.896315] 000: pstate: 60000005 (nZCv daif -PAN -UAO)
[    4.896321] 000: pc : __handle_irq_event_percpu+0x154/0x168
[    4.896331] 000: lr : __handle_irq_event_percpu+0x154/0x168
[    4.896339] 000: sp : ffff000010003cc0
[    4.896346] 000: x29: ffff000010003cc0 x28: 0000000000000060
[    4.896355] 000: x27: ffff000011021980 x26: ffff00001189c72b
[    4.896364] 000: x25: ffff000011702bc0 x24: ffff800036d6e400
[    4.896373] 000: x23: 000000000000004f x22: ffff000010003d64
[    4.896381] 000: x21: 0000000000000000 x20: 0000000000000002
[    4.896390] 000: x19: ffff8000371c8480 x18: 0000000000000060
[    4.896398] 000: x17: 0000000000000000 x16: 00000000000000eb
[    4.896406] 000: x15: ffff000011712d18 x14: 7265746e69206465
[    4.896414] 000: x13: ffff000010003ba0 x12: ffff000011712df0
[    4.896422] 000: x11: 0000000000000001 x10: ffff000011712e08
[    4.896430] 000: x9 : 0000000000000001 x8 : 000000000003c920
[    4.896437] 000: x7 : ffff0000118cc410 x6 : ffff0000118c7f00
[    4.896445] 000: x5 : 000000000003c920 x4 : 0000000000004510
[    4.896453] 000: x3 : ffff000011712dc8 x2 : 0000000000000000
[    4.896461] 000: x1 : 73a3f67df94c1500 x0 : 0000000000000000
[    4.896466] 000: Call trace:
[    4.896471] 000:  __handle_irq_event_percpu+0x154/0x168
[    4.896481] 000:  handle_irq_event_percpu+0x50/0xb0
[    4.896489] 000:  handle_irq_event+0x40/0x98
[    4.896497] 000:  handle_simple_irq+0xa4/0xf0
[    4.896505] 000:  generic_handle_irq+0x24/0x38
[    4.896513] 000:  intr_complete+0xb0/0xe0
[    4.896525] 000:  __usb_hcd_giveback_urb+0x58/0xd8
[    4.896533] 000:  usb_giveback_urb_bh+0xd0/0x170
[    4.896539] 000:  tasklet_action_common.isra.0+0x9c/0x128
[    4.896549] 000:  tasklet_hi_action+0x24/0x30
[    4.896556] 000:  __do_softirq+0x120/0x23c
[    4.896564] 000:  irq_exit+0xb8/0xd8
[    4.896571] 000:  __handle_domain_irq+0x64/0xb8
[    4.896579] 000:  bcm2836_arm_irqchip_handle_irq+0x60/0xc0
[    4.896586] 000:  el1_irq+0xb8/0x140
[    4.896592] 000:  arch_cpu_idle+0x10/0x18
[    4.896601] 000:  do_idle+0x200/0x280
[    4.896608] 000:  cpu_startup_entry+0x20/0x28
[    4.896615] 000:  rest_init+0xb4/0xc0
[    4.896623] 000:  arch_call_rest_init+0xc/0x14
[    4.896632] 000:  start_kernel+0x454/0x480

Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stefan Wahren <wahrenst@gmx.net>
Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

Hi,

This patch just fixes the warning. There are still problems left (the
unstable NFS report from me) but I suggest to look at this
separately. The initial patch to revert all the irqdomain code might
just hide the problem. At this point I don't know what's going on so I
rather go baby steps. The revert is still possible if nothing else
works.

Thanks,
Daniel

 drivers/net/usb/lan78xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 62948098191f..f24a1b0b801f 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1264,8 +1264,11 @@ static void lan78xx_status(struct lan78xx_net *dev, struct urb *urb)
 		netif_dbg(dev, link, dev->net, "PHY INTR: 0x%08x\n", intdata);
 		lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 
-		if (dev->domain_data.phyirq > 0)
+		if (dev->domain_data.phyirq > 0) {
+			local_irq_disable();
 			generic_handle_irq(dev->domain_data.phyirq);
+			local_irq_enable();
+		}
 	} else
 		netdev_warn(dev->net,
 			    "unexpected interrupt: 0x%08x\n", intdata);
-- 
2.23.0

