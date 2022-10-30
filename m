Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355BA6129FE
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJ3KU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJ3KUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:20:25 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237605F53;
        Sun, 30 Oct 2022 03:20:24 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 21so13753080edv.3;
        Sun, 30 Oct 2022 03:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xfb46/+QKkcmunS1vuH+zT7k2qnIrEgqnKkAush5oaU=;
        b=nPKexX7KU7NjyihhimWsW4y4rmbdwvH+YtB7W01ANJ+otgklXnymSV8Za7Ur40GwR0
         EslZGctyZJhTm3F+3NwQyFy16kPCzjvSd1mpOLMC++EgonvCOyVToRSQblC59DAqAoLQ
         0O1BifyoHkMY5V8CcyWCgdBhIY3FnLesIv5Y3fjaJtKmHuJaTze9zFYmFlNMHU0cmdoA
         FJOWkBdJpeial1KJEb/eMRcQjwjjhxA8LjjJGXVdippu3pagoiHkbyj8EU06IZ4enFYF
         W4w6j2sd0Ma0Ab7czXiQNKj8eFy/fDi2hUrK4RkU5D58kCGFaGWVmGsVL3QdiGr2Hs0l
         ob8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xfb46/+QKkcmunS1vuH+zT7k2qnIrEgqnKkAush5oaU=;
        b=Q5leejYoKl0SGnsDo9ej+q1Vsdia+jDU1PzZciBQ8AknUZkVwkMSysrJihKD1ockxv
         egKAHRaVCl77ECA+Ostghkv7oiwkA0dGY1WPPkCakbF0pV5Y/TviMjcwlnVCxvuwTUKH
         vu46jPqUQTALM6kLIBHoGqJvNKyn6qVNez2/NXs7ItYOIzCK9rFyzrEMNXmhvtjFyb+E
         zsdKffUp53/0YtLkwLhEPC1i8oJXvhJSWoili1Mi1pxlreQIjVX8TngA56M7M728s5C9
         rH0M8fZQ/txAMU3tP39B9IFC7C5LoQIwQpGd7fQbKB3kgfjRGNOcFHL+ln1DqmeddJvh
         VlLQ==
X-Gm-Message-State: ACrzQf34tb1WtbE/gcRYwfWcdKEKLO4CErHwu5sDPYu0xWOjv8LW7S/0
        S8yyQvT5cLX0qBEPShpY5cgUEFBjWQq05zGVO5E9JKaIRlHp8A==
X-Google-Smtp-Source: AMsMyM5JkZh+JzrQqHUkt3CbD7lkpJSBTcCafMqNrRU+j8kNlr40JL0hny3Q2pSrHbaIcfwU1YIsgbbJ5Wma7aYd710=
X-Received: by 2002:aa7:c14b:0:b0:461:c47d:48cf with SMTP id
 r11-20020aa7c14b000000b00461c47d48cfmr7887053edp.83.1667125222563; Sun, 30
 Oct 2022 03:20:22 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 18:19:46 +0800
Message-ID: <CAO4mrfemkAbFkLUg83swrMxvphXW8w5GFYofwQz9Xk0rb2ga-g@mail.gmail.com>
Subject: stack segment fault in l2cap_chan_put
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
https://drive.google.com/file/d/1G71Ww97u1liwpZv8zvSqphYPTtn9HnOO/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

stack segment: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 12694 Comm: kworker/1:11 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: events l2cap_chan_timeout
RIP: 0010:l2cap_chan_put+0x21/0x160
Code: 5d 41 5c e9 91 0d 04 fd 90 41 54 55 48 89 fd 53 e8 84 0d 04 fd
66 90 e8 7d 0d 04 fd e8 78 0d 04 fd 4c 8d 65 18 bb ff ff ff ff <f0> 0f
c1 5d 18 bf 01 00 00 00 89 de e8 5e 0e 04 fd 83 fb 01 74 55
RSP: 0018:ffffc90000d73dc0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: ffff888111e39b80
RDX: 0000000000000000 RSI: ffff888111e39b80 RDI: 0000000000000002
RBP: dead4ead00000000 R08: ffffffff843965e8 R09: 0000000000000000
R10: 0000000000000007 R11: 0000000000000001 R12: dead4ead00000018
R13: ffff88810d814000 R14: ffff88810d8144b8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e423000 CR3: 0000000111e00000 CR4: 00000000003506e0
Call Trace:
 l2cap_sock_kill.part.11+0x24/0x110
 l2cap_sock_close_cb+0x4e/0x60
 l2cap_chan_timeout+0xdc/0x160
 process_one_work+0x3fa/0x9f0
 worker_thread+0x42/0x5c0
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
Modules linked in:
---[ end trace 9e8a9c7204ba3d85 ]---
RIP: 0010:l2cap_chan_put+0x21/0x160
Code: 5d 41 5c e9 91 0d 04 fd 90 41 54 55 48 89 fd 53 e8 84 0d 04 fd
66 90 e8 7d 0d 04 fd e8 78 0d 04 fd 4c 8d 65 18 bb ff ff ff ff <f0> 0f
c1 5d 18 bf 01 00 00 00 89 de e8 5e 0e 04 fd 83 fb 01 74 55
RSP: 0018:ffffc90000d73dc0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: ffff888111e39b80
RDX: 0000000000000000 RSI: ffff888111e39b80 RDI: 0000000000000002
RBP: dead4ead00000000 R08: ffffffff843965e8 R09: 0000000000000000
R10: 0000000000000007 R11: 0000000000000001 R12: dead4ead00000018
R13: ffff88810d814000 R14: ffff88810d8144b8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e423000 CR3: 0000000012e7a000 CR4: 00000000003506e0
----------------
Code disassembly (best guess):
   0: 5d                    pop    %rbp
   1: 41 5c                pop    %r12
   3: e9 91 0d 04 fd        jmpq   0xfd040d99
   8: 90                    nop
   9: 41 54                push   %r12
   b: 55                    push   %rbp
   c: 48 89 fd              mov    %rdi,%rbp
   f: 53                    push   %rbx
  10: e8 84 0d 04 fd        callq  0xfd040d99
  15: 66 90                xchg   %ax,%ax
  17: e8 7d 0d 04 fd        callq  0xfd040d99
  1c: e8 78 0d 04 fd        callq  0xfd040d99
  21: 4c 8d 65 18          lea    0x18(%rbp),%r12
  25: bb ff ff ff ff        mov    $0xffffffff,%ebx
* 2a: f0 0f c1 5d 18        lock xadd %ebx,0x18(%rbp) <-- trapping instruction
  2f: bf 01 00 00 00        mov    $0x1,%edi
  34: 89 de                mov    %ebx,%esi
  36: e8 5e 0e 04 fd        callq  0xfd040e99
  3b: 83 fb 01              cmp    $0x1,%ebx
  3e: 74 55                je     0x95

Best,
Wei
