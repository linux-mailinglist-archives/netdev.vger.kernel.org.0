Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E0F7257D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfGXDrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfGXDrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:47:21 -0400
Received: from wens.tw (mirror2.csie.ntu.edu.tw [140.112.30.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB0172070D;
        Wed, 24 Jul 2019 03:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563940040;
        bh=bNBmOGH+i508gpZOyyYxmRc+j2aSTFWcOfPJFqhayno=;
        h=From:To:Cc:Subject:Date:From;
        b=QQ2xi8HFdFXXDjjinjrDCQhYTlL13vNQX/JZT3bVUGZoFWYslIxhRh8pGhh5p1YyV
         7WXL75P4r+bKqj8W/aA3oARTS3SBTMfCHpltgDCSNh0fXGanTG1zZvJJEZarj0Pc8k
         +/vzuMC4HvV5B0ByLK4f+/kxYHMGl9FM+6DGYafk=
Received: by wens.tw (Postfix, from userid 1000)
        id AD6C75FAD1; Wed, 24 Jul 2019 11:47:16 +0800 (CST)
From:   Chen-Yu Tsai <wens@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: Check existence of .port_mdb_add callback before calling it
Date:   Wed, 24 Jul 2019 11:47:02 +0800
Message-Id: <20190724034702.21212-1-wens@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

With the recent addition of commit 75dad2520fc3 ("net: dsa: b53: Disable
all ports on setup"), users of b53 (BCM53125 on Lamobo R1 in my case)
are forced to use the dsa subsystem to enable the switch, instead of
having it in the default transparent "forward-to-all" mode.

The b53 driver does not support mdb bitmap functions. However the dsa
layer does not check for the existence of the .port_mdb_add callback
before actually using it. This results in a NULL pointer dereference,
as shown in the kernel oops below.

The other functions seem to be properly guarded. Do the same for
.port_mdb_add in dsa_switch_mdb_add_bitmap() as well.

b53 is not the only driver that doesn't support mdb bitmap functions.
Others include bcm_sf2, dsa_loop, lantiq_gswip, mt7530, mv88e6060,
qca8k, realtek-smi, and vitesse-vsc73xx.

    8<--- cut here ---
    Unable to handle kernel NULL pointer dereference at virtual address 00000000
    pgd = (ptrval)
    [00000000] *pgd=00000000
    Internal error: Oops: 80000005 [#1] SMP ARM
    Modules linked in: rtl8xxxu rtl8192cu rtl_usb rtl8192c_common rtlwifi mac80211 cfg80211
    CPU: 1 PID: 134 Comm: kworker/1:2 Not tainted 5.3.0-rc1-00247-gd3519030752a #1
    Hardware name: Allwinner sun7i (A20) Family
    Workqueue: events switchdev_deferred_process_work
    PC is at 0x0
    LR is at dsa_switch_event+0x570/0x620
    pc : [<00000000>]    lr : [<c08533ec>]    psr: 80070013
    sp : ee871db8  ip : 00000000  fp : ee98d0a4
    r10: 0000000c  r9 : 00000008  r8 : ee89f710
    r7 : ee98d040  r6 : ee98d088  r5 : c0f04c48  r4 : ee98d04c
    r3 : 00000000  r2 : ee89f710  r1 : 00000008  r0 : ee98d040
    Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
    Control: 10c5387d  Table: 6deb406a  DAC: 00000051
    Process kworker/1:2 (pid: 134, stack limit = 0x(ptrval))
    Stack: (0xee871db8 to 0xee872000)
    1da0:                                                       ee871e14 103ace2d
    1dc0: 00000000 ffffffff 00000000 ee871e14 00000005 00000000 c08524a0 00000000
    1de0: ffffe000 c014bdfc c0f04c48 ee871e98 c0f04c48 ee9e5000 c0851120 c014bef0
    1e00: 00000000 b643aea2 ee9b4068 c08509a8 ee2bf940 ee89f710 ee871ecb 00000000
    1e20: 00000008 103ace2d 00000000 c087e248 ee29c868 103ace2d 00000001 ffffffff
    1e40: 00000000 ee871e98 00000006 00000000 c0fb2a50 c087e2d0 ffffffff c08523c4
    1e60: ffffffff c014bdfc 00000006 c0fad2d0 ee871e98 ee89f710 00000000 c014c500
    1e80: 00000000 ee89f3c0 c0f04c48 00000000 ee9e5000 c087dfb4 ee9e5000 00000000
    1ea0: ee89f710 ee871ecb 00000001 103ace2d 00000000 c0f04c48 00000000 c087e0a8
    1ec0: 00000000 efd9a3e0 0089f3c0 103ace2d ee89f700 ee89f710 ee9e5000 00000122
    1ee0: 00000100 c087e130 ee89f700 c0fad2c8 c1003ef0 c087de4c 2e928000 c0fad2ec
    1f00: c0fad2ec ee839580 ef7a62c0 ef7a9400 00000000 c087def8 c0fad2ec c01447dc
    1f20: ef315640 ef7a62c0 00000008 ee839580 ee839594 ef7a62c0 00000008 c0f03d00
    1f40: ef7a62d8 ef7a62c0 ffffe000 c0145b84 ffffe000 c0fb2420 c0bfaa8c 00000000
    1f60: ffffe000 ee84b600 ee84b5c0 00000000 ee870000 ee839580 c0145b40 ef0e5ea4
    1f80: ee84b61c c014a6f8 00000001 ee84b5c0 c014a5b0 00000000 00000000 00000000
    1fa0: 00000000 00000000 00000000 c01010e8 00000000 00000000 00000000 00000000
    1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
    [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
    [<c014bdfc>] (notifier_call_chain) from [<c014bef0>] (raw_notifier_call_chain+0x18/0x20)
    [<c014bef0>] (raw_notifier_call_chain) from [<c08509a8>] (dsa_port_mdb_add+0x48/0x74)
    [<c08509a8>] (dsa_port_mdb_add) from [<c087e248>] (__switchdev_handle_port_obj_add+0x54/0xd4)
    [<c087e248>] (__switchdev_handle_port_obj_add) from [<c087e2d0>] (switchdev_handle_port_obj_add+0x8/0x14)
    [<c087e2d0>] (switchdev_handle_port_obj_add) from [<c08523c4>] (dsa_slave_switchdev_blocking_event+0x94/0xa4)
    [<c08523c4>] (dsa_slave_switchdev_blocking_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
    [<c014bdfc>] (notifier_call_chain) from [<c014c500>] (blocking_notifier_call_chain+0x50/0x68)
    [<c014c500>] (blocking_notifier_call_chain) from [<c087dfb4>] (switchdev_port_obj_notify+0x44/0xa8)
    [<c087dfb4>] (switchdev_port_obj_notify) from [<c087e0a8>] (switchdev_port_obj_add_now+0x90/0x104)
    [<c087e0a8>] (switchdev_port_obj_add_now) from [<c087e130>] (switchdev_port_obj_add_deferred+0x14/0x5c)
    [<c087e130>] (switchdev_port_obj_add_deferred) from [<c087de4c>] (switchdev_deferred_process+0x64/0x104)
    [<c087de4c>] (switchdev_deferred_process) from [<c087def8>] (switchdev_deferred_process_work+0xc/0x14)
    [<c087def8>] (switchdev_deferred_process_work) from [<c01447dc>] (process_one_work+0x218/0x50c)
    [<c01447dc>] (process_one_work) from [<c0145b84>] (worker_thread+0x44/0x5bc)
    [<c0145b84>] (worker_thread) from [<c014a6f8>] (kthread+0x148/0x150)
    [<c014a6f8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
    Exception stack(0xee871fb0 to 0xee871ff8)
    1fa0:                                     00000000 00000000 00000000 00000000
    1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
    Code: bad PC value
    ---[ end trace 1292c61abd17b130 ]---

    [<c08533ec>] (dsa_switch_event) from [<c014bdfc>] (notifier_call_chain+0x48/0x84)
    corresponds to

	$ arm-linux-gnueabihf-addr2line -C -i -e vmlinux c08533ec

	linux/net/dsa/switch.c:156
	linux/net/dsa/switch.c:178
	linux/net/dsa/switch.c:328

Fixes: e6db98db8a95 ("net: dsa: add switch mdb bitmap functions")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---

This piece of code was moved around in release 4.16, and probably
existed for even longer in some other form. Seems kind of odd that
I'm running into it just now. Maybe there's some other issue I'm
missing, or that it's specific to b53 only? Either way I get the
feeling that I missing something and this is only papering over it.

---
 net/dsa/switch.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4ec5b7f85d51..13c7ef53e0de 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -147,14 +147,19 @@ dsa_switch_mdb_prepare_bitmap(struct dsa_switch *ds,
 	return 0;
 }
 
-static void dsa_switch_mdb_add_bitmap(struct dsa_switch *ds,
-				      const struct switchdev_obj_port_mdb *mdb,
-				      const unsigned long *bitmap)
+static int dsa_switch_mdb_add_bitmap(struct dsa_switch *ds,
+				     const struct switchdev_obj_port_mdb *mdb,
+				     const unsigned long *bitmap)
 {
 	int port;
 
+	if (!ds->ops->port_mdb_add)
+		return -EOPNOTSUPP;
+
 	for_each_set_bit(port, bitmap, ds->num_ports)
 		ds->ops->port_mdb_add(ds, port, mdb);
+
+	return 0;
 }
 
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
@@ -175,9 +180,7 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 	if (switchdev_trans_ph_prepare(trans))
 		return dsa_switch_mdb_prepare_bitmap(ds, mdb, ds->bitmap);
 
-	dsa_switch_mdb_add_bitmap(ds, mdb, ds->bitmap);
-
-	return 0;
+	return dsa_switch_mdb_add_bitmap(ds, mdb, ds->bitmap);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
-- 
2.20.1

