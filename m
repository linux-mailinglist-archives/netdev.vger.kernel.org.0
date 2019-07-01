Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639445C387
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfGATPb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jul 2019 15:15:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58517 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGATPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:15:31 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1hi1lu-0000m0-Fj; Mon, 01 Jul 2019 19:15:26 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id C848C5FF10; Mon,  1 Jul 2019 12:15:24 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C058E9FA39;
        Mon,  1 Jul 2019 12:15:24 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Eric Dumazet <edumazet@google.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Sperbeck <jsperbeck@google.com>,
        Jarod Wilson <jarod@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] bonding/main: fix NULL dereference in bond_select_active_slave()
In-reply-to: <20190701174851.70293-1-edumazet@google.com>
References: <20190701174851.70293-1-edumazet@google.com>
Comments: In-reply-to Eric Dumazet <edumazet@google.com>
   message dated "Mon, 01 Jul 2019 10:48:51 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18507.1562008524.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Mon, 01 Jul 2019 12:15:24 -0700
Message-ID: <18508.1562008524@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:

>A bonding master can be up while best_slave is NULL.
>
>[12105.636318] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>[12105.638204] mlx4_en: eth1: Linkstate event 1 -> 1
>[12105.648984] IP: bond_select_active_slave+0x125/0x250
>[12105.653977] PGD 0 P4D 0
>[12105.656572] Oops: 0000 [#1] SMP PTI
>[12105.660487] gsmi: Log Shutdown Reason 0x03
>[12105.664620] Modules linked in: kvm_intel loop act_mirred uhaul vfat fat stg_standard_ftl stg_megablocks stg_idt stg_hdi stg elephant_dev_num stg_idt_eeprom w1_therm wire i2c_mux_pca954x i2c_mux mlx4_i2c i2c_usb cdc_acm ehci_pci ehci_hcd i2c_iimc mlx4_en mlx4_ib ib_uverbs ib_core mlx4_core [last unloaded: kvm_intel]
>[12105.685686] mlx4_core 0000:03:00.0: dispatching link up event for port 2
>[12105.685700] mlx4_en: eth2: Linkstate event 2 -> 1
>[12105.685700] mlx4_en: eth2: Link Up (linkstate)
>[12105.724452] Workqueue: bond0 bond_mii_monitor
>[12105.728854] RIP: 0010:bond_select_active_slave+0x125/0x250
>[12105.734355] RSP: 0018:ffffaf146a81fd88 EFLAGS: 00010246
>[12105.739637] RAX: 0000000000000003 RBX: ffff8c62b03c6900 RCX: 0000000000000000
>[12105.746838] RDX: 0000000000000000 RSI: ffffaf146a81fd08 RDI: ffff8c62b03c6000
>[12105.754054] RBP: ffffaf146a81fdb8 R08: 0000000000000001 R09: ffff8c517d387600
>[12105.761299] R10: 00000000001075d9 R11: ffffffffaceba92f R12: 0000000000000000
>[12105.768553] R13: ffff8c8240ae4800 R14: 0000000000000000 R15: 0000000000000000
>[12105.775748] FS:  0000000000000000(0000) GS:ffff8c62bfa40000(0000) knlGS:0000000000000000
>[12105.783892] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[12105.789716] CR2: 0000000000000000 CR3: 0000000d0520e001 CR4: 00000000001626f0
>[12105.796976] Call Trace:
>[12105.799446]  [<ffffffffac31d387>] bond_mii_monitor+0x497/0x6f0
>[12105.805317]  [<ffffffffabd42643>] process_one_work+0x143/0x370
>[12105.811225]  [<ffffffffabd42c7a>] worker_thread+0x4a/0x360
>[12105.816761]  [<ffffffffabd48bc5>] kthread+0x105/0x140
>[12105.821865]  [<ffffffffabd42c30>] ? rescuer_thread+0x380/0x380
>[12105.827757]  [<ffffffffabd48ac0>] ? kthread_associate_blkcg+0xc0/0xc0
>[12105.834266]  [<ffffffffac600241>] ret_from_fork+0x51/0x60
>
>Fixes: e2a7420df2e0 ("bonding/main: convert to using slave printk macros")
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Reported-by: John Sperbeck <jsperbeck@google.com>
>Cc: Jarod Wilson <jarod@redhat.com>
>CC: Jay Vosburgh <j.vosburgh@gmail.com>
>CC: Veaceslav Falico <vfalico@gmail.com>
>CC: Andy Gospodarek <andy@greyhouse.net>
>---
> drivers/net/bonding/bond_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index a30595955a37a485b9e045a31969313f8336b668..84168455aded96dfd85b310841dee2a0d917b580 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -937,7 +937,7 @@ void bond_select_active_slave(struct bonding *bond)
> 			return;
> 
> 		if (netif_carrier_ok(bond->dev))
>-			slave_info(bond->dev, best_slave->dev, "active interface up!\n");
>+			netdev_info(bond->dev, "active interface up!\n");
> 		else
> 			netdev_info(bond->dev, "now running without any active interface!\n");
> 	}

	What is the bonding mode and options in the failure case?

	I see that the fix is fine in the sense that it returns to the
original status quo for the message.

	However, the code path seems odd; if best_slave is NULL, that
means that bond_find_best_slave() saw all slaves as down, but if
netif_carrier_ok is true, then bond_set_carrier() did not.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
