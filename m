Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35BA5C3AA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfGATcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:32:11 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38981 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfGATcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:32:11 -0400
Received: by mail-yw1-f68.google.com with SMTP id u134so420351ywf.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iH5txb2xwJV2SaanITy3vuz4LNuG+KCxERnI97DX39Q=;
        b=M+0g9drsqoc5txWnlFMO9FpvAEod54bFZwNeq9zGqF2UWFeZ6Dja89rk1nYIv2UUir
         x6CHAqM8fxOV8QwS0H8chkVeKE2AIovnuxUx91EMtkrEyYzTI6T3XyDdNwJWji4AHGXN
         T6ttaazfb2CqtgXSLjp1ZetJ7+rWg3SK8PIdivSn4fJWGmomIrYL68JaW4uKuWEdPymy
         xehKVIT4DlGs1Z459DTrqfjdlW6XK23Q6DtHgL5yHZRfKsIiDfBfa02uYTZ80/26m7Zz
         Fq5RvhwF0v5alkbLlAvjTtXw42VqlDpd0M2SO1kUaASHeGNL3LeDZrYqX91zLe3V6524
         s4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iH5txb2xwJV2SaanITy3vuz4LNuG+KCxERnI97DX39Q=;
        b=A3rhAwOSX0iYYw63yP5YZ6sWWa/NHfhlj/DDnki1HeLuP3IT5ZhbKZuoNvKvKHxlmw
         of26QD7/9TP9WnTN3fzzROKgBzUoVvExJhezdt4bgmvPmWf9P7zqNt7i1lXHgMEH1rRr
         lEkeLEEx+ru+xDP8urnV9SLHILBVU55mbHKSO+uY3Dt9wChgJB2bxw4NPzZ+tBjNqzLX
         tMPyI05PrnwSo09BbIGdOAgyprOtqBmLa7mwROPOmoaMgsDq6krLt5TMT4PTweeqFxxJ
         JABT/GVknhRIv5urCIQ3X3JkxkGhregUflEXSfj09Ge2iUbnVJsQRAOgrZV4BcfifXBx
         t6eA==
X-Gm-Message-State: APjAAAWoA8EyUA32XzssWo9jOso6xbHKRKRboSMRRB2k+SGwBRzPJiG8
        Ls4V2i1mXlnC/HmIRYKvWR6Fw3Qid1RT0zg5IEhx7g==
X-Google-Smtp-Source: APXvYqyhN9dxdPbVbFJPL1MoSOlDSsHFTulAYkAeyN+qyLXrWyqWQAQLPMOPjUH3VDeN2Zv9vNU9QNyNIctpsXPEWSg=
X-Received: by 2002:a81:57d0:: with SMTP id l199mr16339784ywb.179.1562009529816;
 Mon, 01 Jul 2019 12:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190701174851.70293-1-edumazet@google.com> <18508.1562008524@famine>
In-Reply-To: <18508.1562008524@famine>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 1 Jul 2019 21:31:57 +0200
Message-ID: <CANn89iKu+JfmYt0gTOY_6M19-gVL0=+krASa-85qjTDQupyYbA@mail.gmail.com>
Subject: Re: [PATCH net-next] bonding/main: fix NULL dereference in bond_select_active_slave()
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Sperbeck <jsperbeck@google.com>,
        Jarod Wilson <jarod@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 9:15 PM Jay Vosburgh <jay.vosburgh@canonical.com> wr=
ote:
>
> Eric Dumazet <edumazet@google.com> wrote:
>
> >A bonding master can be up while best_slave is NULL.
> >
> >[12105.636318] BUG: unable to handle kernel NULL pointer dereference at =
0000000000000000
> >[12105.638204] mlx4_en: eth1: Linkstate event 1 -> 1
> >[12105.648984] IP: bond_select_active_slave+0x125/0x250
> >[12105.653977] PGD 0 P4D 0
> >[12105.656572] Oops: 0000 [#1] SMP PTI
> >[12105.660487] gsmi: Log Shutdown Reason 0x03
> >[12105.664620] Modules linked in: kvm_intel loop act_mirred uhaul vfat f=
at stg_standard_ftl stg_megablocks stg_idt stg_hdi stg elephant_dev_num stg=
_idt_eeprom w1_therm wire i2c_mux_pca954x i2c_mux mlx4_i2c i2c_usb cdc_acm =
ehci_pci ehci_hcd i2c_iimc mlx4_en mlx4_ib ib_uverbs ib_core mlx4_core [las=
t unloaded: kvm_intel]
> >[12105.685686] mlx4_core 0000:03:00.0: dispatching link up event for por=
t 2
> >[12105.685700] mlx4_en: eth2: Linkstate event 2 -> 1
> >[12105.685700] mlx4_en: eth2: Link Up (linkstate)
> >[12105.724452] Workqueue: bond0 bond_mii_monitor
> >[12105.728854] RIP: 0010:bond_select_active_slave+0x125/0x250
> >[12105.734355] RSP: 0018:ffffaf146a81fd88 EFLAGS: 00010246
> >[12105.739637] RAX: 0000000000000003 RBX: ffff8c62b03c6900 RCX: 00000000=
00000000
> >[12105.746838] RDX: 0000000000000000 RSI: ffffaf146a81fd08 RDI: ffff8c62=
b03c6000
> >[12105.754054] RBP: ffffaf146a81fdb8 R08: 0000000000000001 R09: ffff8c51=
7d387600
> >[12105.761299] R10: 00000000001075d9 R11: ffffffffaceba92f R12: 00000000=
00000000
> >[12105.768553] R13: ffff8c8240ae4800 R14: 0000000000000000 R15: 00000000=
00000000
> >[12105.775748] FS:  0000000000000000(0000) GS:ffff8c62bfa40000(0000) knl=
GS:0000000000000000
> >[12105.783892] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[12105.789716] CR2: 0000000000000000 CR3: 0000000d0520e001 CR4: 00000000=
001626f0
> >[12105.796976] Call Trace:
> >[12105.799446]  [<ffffffffac31d387>] bond_mii_monitor+0x497/0x6f0
> >[12105.805317]  [<ffffffffabd42643>] process_one_work+0x143/0x370
> >[12105.811225]  [<ffffffffabd42c7a>] worker_thread+0x4a/0x360
> >[12105.816761]  [<ffffffffabd48bc5>] kthread+0x105/0x140
> >[12105.821865]  [<ffffffffabd42c30>] ? rescuer_thread+0x380/0x380
> >[12105.827757]  [<ffffffffabd48ac0>] ? kthread_associate_blkcg+0xc0/0xc0
> >[12105.834266]  [<ffffffffac600241>] ret_from_fork+0x51/0x60
> >
> >Fixes: e2a7420df2e0 ("bonding/main: convert to using slave printk macros=
")
> >Signed-off-by: Eric Dumazet <edumazet@google.com>
> >Reported-by: John Sperbeck <jsperbeck@google.com>
> >Cc: Jarod Wilson <jarod@redhat.com>
> >CC: Jay Vosburgh <j.vosburgh@gmail.com>
> >CC: Veaceslav Falico <vfalico@gmail.com>
> >CC: Andy Gospodarek <andy@greyhouse.net>
> >---
> > drivers/net/bonding/bond_main.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_=
main.c
> >index a30595955a37a485b9e045a31969313f8336b668..84168455aded96dfd85b3108=
41dee2a0d917b580 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -937,7 +937,7 @@ void bond_select_active_slave(struct bonding *bond)
> >                       return;
> >
> >               if (netif_carrier_ok(bond->dev))
> >-                      slave_info(bond->dev, best_slave->dev, "active in=
terface up!\n");
> >+                      netdev_info(bond->dev, "active interface up!\n");
> >               else
> >                       netdev_info(bond->dev, "now running without any a=
ctive interface!\n");
> >       }
>
>         What is the bonding mode and options in the failure case?

I am not sure.

Basically I only have crash dumps at this point (no idea how to repro the b=
ug)

I guess that is :

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: encap3+4 (4)
Use Carrier: 1
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
MAC address: 00:1a:11:c0:65:40
Active Members: eth1 eth2


>
>         I see that the fix is fine in the sense that it returns to the
> original status quo for the message.
>
>         However, the code path seems odd; if best_slave is NULL, that
> means that bond_find_best_slave() saw all slaves as down, but if
> netif_carrier_ok is true, then bond_set_carrier() did not.
