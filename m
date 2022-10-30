Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7C26129B3
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 10:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJ3JrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 05:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJ3Jq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 05:46:57 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8154BC85;
        Sun, 30 Oct 2022 02:46:55 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id y14so22753982ejd.9;
        Sun, 30 Oct 2022 02:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=obRrSEC9n+8zBCgBpw96kYMaGNVQV8zuef943idHvok=;
        b=bkDrktPRUoRH2kDrZwOeBmMN721dxeuGRo+tkjK4W/ifEw/LgYJjG7NE3sDel4shl6
         KatLnpKB8El8Kw45BunEbn7dIzNmBvZg0ghKrSOarM4YWStRw8OG0EIigc4Zn7ppyTS8
         ttbvrkBRzUA318xbWSTp3IQSv8vR7ywN2p5csS0xv4rM0B6ufkTsnHCwQ9dx1Nk3Dm6Z
         sc2XI1ztKQjUR4z0wtCLTLy/9QPwM9ZEdaYD6FG9YPuHTnk9Fq9bwvNkThyBT8wazCCf
         tdv4bDmO/s8iyLSdLS+LW7h351RV22qBtPssXcLgmv/l6n6CiuK5mPEkKyM53FVE+oLX
         rE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=obRrSEC9n+8zBCgBpw96kYMaGNVQV8zuef943idHvok=;
        b=BaAATZumwqr1qzzw9F8QqKFaXS1EaCb9Lkxgpc15itpMJs681P+Fd+nxpmFgpWFcsY
         FRPvPE0lgSs+bPjopn3o40wf6BrI65aJYuRLDITCSw8QmRLfayxGf99Yi9f4I8UOybFe
         xahMeuI15M01EmmaHN6pgrbboU8kWHn4Y+fStWReBVr047dKE1kP27OosmOBEyeWnBrY
         YHNCaOCtpLc3G+NK4qZKu8BxN/JhUQoIOUOWC9gaXuuZkZLXgVux4L01iqiyKCZYVGxG
         nkqki8e8kSGr9u0fr//f2mZpxd+ODujjFDwlHIsAAmuW0glNE9PbuzDCiwCX12HmJP8I
         cGaQ==
X-Gm-Message-State: ACrzQf1k6QkDcPKO0IocRrX/ojFXgI0XbrMkPgzFFjqxX8M5nNWKBwil
        rUcbv9h5QwnoEysc+my0vsv88NyNimv2N2gKE1I=
X-Google-Smtp-Source: AMsMyM6MucakjelfEpcicY3M08dxi9pMTpxJJhZDzfGYeJI9sxHL3XQ3iKnCDdRUfdbIgyDqBrZTHIVMgb8Avs+Bjhs=
X-Received: by 2002:a17:907:2c71:b0:79e:8603:72c6 with SMTP id
 ib17-20020a1709072c7100b0079e860372c6mr7629499ejc.172.1667123214149; Sun, 30
 Oct 2022 02:46:54 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 17:46:18 +0800
Message-ID: <CAO4mrfeiurLJp7tntR88hbEPpXvX_Mf5+h0vx9AwYEPzEwdWzw@mail.gmail.com>
Subject: BUG: soft lockup in hci_cmd_timeout
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
compiler: gcc 8.0.1
console output:
https://drive.google.com/file/d/1QJBomAmEMry3gMAxuB7REvmQyarNSfxU/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

watchdog: BUG: soft lockup - CPU#1 stuck for 173s! [kworker/1:4:2398]
Modules linked in:
irq event stamp: 2362
hardirqs last  enabled at (2361): [<ffffffff81315cf8>] vprintk_emit+0x468/0x4a0
hardirqs last disabled at (2362): [<ffffffff84bdcc2a>]
sysvec_apic_timer_interrupt+0xa/0xc0
softirqs last  enabled at (2350): [<ffffffff83f89ee2>]
update_defense_level+0x212/0x6f0
softirqs last disabled at (2348): [<ffffffff83f89cd0>]
update_defense_level+0x0/0x6f0
CPU: 1 PID: 2398 Comm: kworker/1:4 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: events hci_cmd_timeout
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x40
Code: 7e 31 c0 81 e2 00 01 ff 00 75 10 65 48 8b 04 25 40 70 01 00 48
8b 80 50 15 00 00 c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 <65> 48
8b 0c 25 40 70 01 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8
RSP: 0018:ffffc900029a7cd8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8881245e9b80
RDX: 0000000000000000 RSI: ffff8881245e9b80 RDI: 0000000000000002
RBP: ffffc900029a7d10 R08: ffffffff81315b3c R09: 0000000000000000
R10: 0000000000000007 R11: 0000000000000200 R12: 0000000000000200
R13: ffffffff8915b208 R14: 000000000000002a R15: ffffc900029a7d40
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd86bad1de0 CR3: 000000001319a000 CR4: 00000000003506e0
Call Trace:
 vprintk_emit+0x2b2/0x4a0
 vprintk+0x7e/0x90
 _printk+0x5f/0x7b
 bt_err+0x72/0x8e
 hci_cmd_timeout+0x47/0xb0
 process_one_work+0x3fa/0x9f0
 worker_thread+0x42/0x5c0
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 1393 Comm: aoe_tx0 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:debug_object_deactivate+0xa6/0x180
Code: 4c 89 f7 e8 0c e9 61 02 48 8b 9b 40 7e 2f 89 48 85 db 74 7d 4c
3b 6b 18 74 7b 48 8b 1b ba 01 00 00 00 48 85 db 74 11 83 c2 01 <4c> 3b
6b 18 74 65 48 8b 1b 48 85 db 75 ef 39 15 8e 68 50 04 7d 06
RSP: 0018:ffffc90000003eb0 EFLAGS: 00010002
RAX: 0000000000000002 RBX: ffff88802e1fbaf0 RCX: 0000000061e44876
RDX: 0000000000000002 RSI: 0000000000010205 RDI: ffffffff893a65b0
RBP: ffffc90000003f08 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff893a65c8 R11: 0000000000000000 R12: ffffffff85037d20
R13: ffff88807dc1ada0 R14: ffffffff893a65b0 R15: 7fffffffffffffff
FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556e95194b28 CR3: 000000000c690000 CR4: 00000000003506f0
Call Trace:
 <IRQ>
 __hrtimer_run_queues+0x1ee/0x810
 hrtimer_interrupt+0x12b/0x2c0
 __sysvec_apic_timer_interrupt+0x9c/0x2c0
 sysvec_apic_timer_interrupt+0x99/0xc0
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x40
Code: 7e 31 c0 81 e2 00 01 ff 00 75 10 65 48 8b 04 25 40 70 01 00 48
8b 80 50 15 00 00 c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 <65> 48
8b 0c 25 40 70 01 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8
RSP: 0018:ffffc90005337a38 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff888104dc0000
RDX: 0000000000000000 RSI: ffff888104dc0000 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff813136ed R09: 0000000000000000
R10: 0000000000000007 R11: 0000000000000200 R12: 0000000000000200
R13: ffffffff86ada1d0 R14: 0000000000000000 R15: 0000000000000000
 console_unlock+0x483/0x880
 vprintk_emit+0x2e0/0x4a0
 dev_vprintk_emit+0x213/0x237
 dev_printk_emit+0x63/0x83
 __netdev_printk+0xcf/0x15b
 netdev_warn+0x75/0x93
 ieee802154_subif_start_xmit.cold.1+0x17/0x26
 dev_hard_start_xmit+0x139/0x5a0
 sch_direct_xmit+0xf9/0x520
 __dev_queue_xmit+0x8bf/0x1af0
 tx+0x54/0xa0
 kthread+0xd2/0x160
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 0-...!: (1 GPs behind) idle=8c9/1/0x4000000000000000
softirq=148712/148713 fqs=1
----------------
Code disassembly (best guess):
   0: 7e 31                jle    0x33
   2: c0 81 e2 00 01 ff 00 rolb   $0x0,-0xfeff1e(%rcx)
   9: 75 10                jne    0x1b
   b: 65 48 8b 04 25 40 70 mov    %gs:0x17040,%rax
  12: 01 00
  14: 48 8b 80 50 15 00 00 mov    0x1550(%rax),%rax
  1b: c3                    retq
  1c: 0f 1f 40 00          nopl   0x0(%rax)
  20: 66 2e 0f 1f 84 00 00 nopw   %cs:0x0(%rax,%rax,1)
  27: 00 00 00
* 2a: 65 48 8b 0c 25 40 70 mov    %gs:0x17040,%rcx <-- trapping instruction
  31: 01 00
  33: bf 02 00 00 00        mov    $0x2,%edi
  38: 48 89 ce              mov    %rcx,%rsi
  3b: 4c 8b 04 24          mov    (%rsp),%r8
  3f: e8                    .byte 0xe8

Best,
Wei
