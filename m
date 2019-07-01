Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BDA5C245
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfGARs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:48:59 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:50436 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbfGARs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:48:58 -0400
Received: by mail-pf1-f202.google.com with SMTP id h27so9199247pfq.17
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=eNVCwKVxs95j2PiFbTzmkX89w3uI0SuuI0z4w5mdaXI=;
        b=YmSU4tZUU0Jat0Izc2gqKOWbmRn5KG97NsHLQ1Ekwl0LukbBsphCcClYZvlusf+HTv
         T3vwADGqKDKfTQ98iltL9bJ7JWtj9ADJ/SIDn7pxpk9Xq2bvHbqzKBxFgbj8v6N7e7XH
         4Tx8NOjjvoOEDRJxy2NyYZH6+LbHUXiSs2sLLH5JJgRc3aOjmHo3q4un/uiAykxjmSob
         Z1Vkosz7EPt1nZXOZ9Siw/lvwZ8sAhat2vNPMVOgEWJjoul7MSr0HjyIoNWlLpc9bxyK
         pHbCk4ErOolh7P335WzqELl4YulrSm7ksEMRXFrZ4JkXVOlJFm6d5E2ZxwPDWE7cUnlz
         4iVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=eNVCwKVxs95j2PiFbTzmkX89w3uI0SuuI0z4w5mdaXI=;
        b=DsADykSE48brkZe3QjaEURwWLYeYcs2jwzPK7WLpRNiFfaDUVo8g7rMuulDV3ybd83
         qvak+M7Ru7EFmGQBr2HmozkWJmrzoOQlfquf/6tiNYZSLpvJAdyr0e/RTnEcOwboziWM
         8sgKGhVynSellxtek3CBU1r98Tduk37Usii0duVDdoa+Fe2I13feuPPAxOtG2nPRmzHS
         nOP10k2dLUGzEvTx5H3Z5twRzocNuWbLG7d+tAIYYs/mkylcsqyCglz4s0gMnl1dxJaO
         4SZgbbroKKGe6T059AdrRJbLmQpS2ASbbCfzz9gfxalw29cZ0feqrblpcHenMPcLN1eU
         am+Q==
X-Gm-Message-State: APjAAAXn3wcw4B0jAx3E3TuO765jT/ohL9mqJ7srk1VcVRB3f+6I577G
        GdBLhi7Mwkcz0AlmOiBi/GT84YPAQ1DE+g==
X-Google-Smtp-Source: APXvYqwIDKhBP0PYODAb9xY0yleRZGlFtcAikkHS9V5sYqsC2BV6teNPINp5wKbGQDa2QlYg3IhlGBjxp5yh4g==
X-Received: by 2002:a63:b04a:: with SMTP id z10mr25293507pgo.18.1562003337746;
 Mon, 01 Jul 2019 10:48:57 -0700 (PDT)
Date:   Mon,  1 Jul 2019 10:48:51 -0700
Message-Id: <20190701174851.70293-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next] bonding/main: fix NULL dereference in bond_select_active_slave()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Sperbeck <jsperbeck@google.com>,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bonding master can be up while best_slave is NULL.

[12105.636318] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000000
[12105.638204] mlx4_en: eth1: Linkstate event 1 -> 1
[12105.648984] IP: bond_select_active_slave+0x125/0x250
[12105.653977] PGD 0 P4D 0
[12105.656572] Oops: 0000 [#1] SMP PTI
[12105.660487] gsmi: Log Shutdown Reason 0x03
[12105.664620] Modules linked in: kvm_intel loop act_mirred uhaul vfat fat =
stg_standard_ftl stg_megablocks stg_idt stg_hdi stg elephant_dev_num stg_id=
t_eeprom w1_therm wire i2c_mux_pca954x i2c_mux mlx4_i2c i2c_usb cdc_acm ehc=
i_pci ehci_hcd i2c_iimc mlx4_en mlx4_ib ib_uverbs ib_core mlx4_core [last u=
nloaded: kvm_intel]
[12105.685686] mlx4_core 0000:03:00.0: dispatching link up event for port 2
[12105.685700] mlx4_en: eth2: Linkstate event 2 -> 1
[12105.685700] mlx4_en: eth2: Link Up (linkstate)
[12105.724452] Workqueue: bond0 bond_mii_monitor
[12105.728854] RIP: 0010:bond_select_active_slave+0x125/0x250
[12105.734355] RSP: 0018:ffffaf146a81fd88 EFLAGS: 00010246
[12105.739637] RAX: 0000000000000003 RBX: ffff8c62b03c6900 RCX: 00000000000=
00000
[12105.746838] RDX: 0000000000000000 RSI: ffffaf146a81fd08 RDI: ffff8c62b03=
c6000
[12105.754054] RBP: ffffaf146a81fdb8 R08: 0000000000000001 R09: ffff8c517d3=
87600
[12105.761299] R10: 00000000001075d9 R11: ffffffffaceba92f R12: 00000000000=
00000
[12105.768553] R13: ffff8c8240ae4800 R14: 0000000000000000 R15: 00000000000=
00000
[12105.775748] FS:  0000000000000000(0000) GS:ffff8c62bfa40000(0000) knlGS:=
0000000000000000
[12105.783892] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12105.789716] CR2: 0000000000000000 CR3: 0000000d0520e001 CR4: 00000000001=
626f0
[12105.796976] Call Trace:
[12105.799446]  [<ffffffffac31d387>] bond_mii_monitor+0x497/0x6f0
[12105.805317]  [<ffffffffabd42643>] process_one_work+0x143/0x370
[12105.811225]  [<ffffffffabd42c7a>] worker_thread+0x4a/0x360
[12105.816761]  [<ffffffffabd48bc5>] kthread+0x105/0x140
[12105.821865]  [<ffffffffabd42c30>] ? rescuer_thread+0x380/0x380
[12105.827757]  [<ffffffffabd48ac0>] ? kthread_associate_blkcg+0xc0/0xc0
[12105.834266]  [<ffffffffac600241>] ret_from_fork+0x51/0x60

Fixes: e2a7420df2e0 ("bonding/main: convert to using slave printk macros")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: John Sperbeck <jsperbeck@google.com>
Cc: Jarod Wilson <jarod@redhat.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index a30595955a37a485b9e045a31969313f8336b668..84168455aded96dfd85b310841d=
ee2a0d917b580 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -937,7 +937,7 @@ void bond_select_active_slave(struct bonding *bond)
 			return;
=20
 		if (netif_carrier_ok(bond->dev))
-			slave_info(bond->dev, best_slave->dev, "active interface up!\n");
+			netdev_info(bond->dev, "active interface up!\n");
 		else
 			netdev_info(bond->dev, "now running without any active interface!\n");
 	}
--=20
2.22.0.410.gd8fdbe21b5-goog

