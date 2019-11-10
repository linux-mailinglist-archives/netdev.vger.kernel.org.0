Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A9BF67BD
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 07:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfKJF7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 00:59:24 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:36911 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfKJF7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 00:59:23 -0500
Received: by mail-oi1-f171.google.com with SMTP id y194so8861250oie.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 21:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wXh7XArEoebiOfZQsH7s7QTvvBqjtswXxlGefAjnpkg=;
        b=jG+8QaoyZt8S0ei5KwK7u+c27u/X8T4YD1jSGUs1qnOZLDX8qxoXjLmo+5GZrIIMHi
         WnVZlO/y13Is+kzMd5bpnVhK9UMY7OQWSGyP37bZMmOkFwNUk0eoYLA4B4SHv5Q/Dm4I
         td19VpzGvAumtxM68MxE++XZWmdM8gwEZBd8tPq6FJsZJDhz7RAblEJCQnmSJwZ7b/z2
         wtYY9ml0Yz51seBlHQlAWM/n7qN+tp15Oxl+JGJtgQ9BJqKzTjYkbe6e0WS9dJg4Y5pV
         VZZ5EwhqI/kCZM+LtLr5tSOP1+zx/HemozLFgzj3ZLR63vDqbAqV8dYLx8TVZhtyhbFb
         I1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wXh7XArEoebiOfZQsH7s7QTvvBqjtswXxlGefAjnpkg=;
        b=TzoE0xb0HHSoauQO02up4FSYPmN9ay8d6GMM7ByK/Vre348+IZBA+tu57ssshYpF+v
         lmRZl3aFGurnNugHfXm3SSBksIT28eNOLEJliEaJaGu+abd13hznbJogednPeS7gg6jd
         uH/PCLE+fj6TyeiY9YL4AV85EU8cSCcDZv6R5oJxgCO4QYhH+PSzxSfFf8c8PTW6XPoA
         shhUgs/NUwAvTJ6GSwtn0VcsURqgsDdgN6LUX5QPUxMXMTWyyPtzZXAxPvxXxMrzPmNA
         8mAnwu7dW3YQA+Lkil5Jg2ThwbtShp+ATVHyQGfifS1UaqymTlsQueegQASJDVWV8lFu
         Fv3A==
X-Gm-Message-State: APjAAAVqm8Cpn7Edfyuk/q1G6cGq92VfsszsVtUVZu1Oms1cc1aJh0td
        ST2QrW5bDyGJMoG71bJPIcHU8+9j99kprUXppCp2xrqWKwk=
X-Google-Smtp-Source: APXvYqwil/qfsuZBCNY+YqnoeSZBZmBSbIrgRYGoZPwHY7HhI7ZPZkXy4d7obe0KoQS1/7Mzl5jlIXxOY7vPvInZHk0=
X-Received: by 2002:a05:6808:14:: with SMTP id u20mr10192782oic.49.1573365561992;
 Sat, 09 Nov 2019 21:59:21 -0800 (PST)
MIME-Version: 1.0
From:   Avinash Patil <avinashapatil@gmail.com>
Date:   Sat, 9 Nov 2019 21:59:10 -0800
Message-ID: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
Subject: Possible bug in TCP retry logic/Kernel crash
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

Kernel: Linux 4.19.35 kernel built from linux-stable

I am seeing this issue on our platform and suspect this is TCP issue:

[ 3148.796319] Oops
[ 3148.799789] Path: /usr/bin/qtn_dut
[ 3148.803306] CPU: 0 PID: 1341 Comm: qtn_dut Tainted: P           O
   4.19.35 #4
[ 3148.810876]
[ 3148.810876] [ECR   ]: 0x00220100 => Invalid Read @ 0x00000008 by
insn @ 0x8b1bc7e8
[ 3148.820064] [EFA   ]: 0x00000008
[ 3148.820064] [BLINK ]: tcp_try_coalesce+0x3c/0xf0
[ 3148.820064] [ERET  ]: skb_try_coalesce+0x94/0x3a0
[ 3148.832704] [STAT32]: 0x00000206 : K         E2 E1
[ 3148.837677] BTA: 0x8b309ca3   SP: 0x8c92db44  FP: 0x00000000
[ 3148.843338] LPS: 0x8b304b94  LPE: 0x8b304b9c LPC: 0x00000000
[ 3148.849023] r00: 0x8c8743c0  r01: 0x8c92a0e0 r02: 0x8c92dbaa
[ 3148.849023] r03: 0x00000000  r04: 0x40000214 r05: 0x8b221ab8
[ 3148.849023] r06: 0x8bab8f3d  r07: 0x00000000 r08: 0x00000000
[ 3148.849023] r09: 0x00000000  r10: 0x1f4f9e47 r11: 0x00000000
[ 3148.849023] r12: 0x00000000  r13: 0x8afcecfc r14: 0x000d2bb8
[ 3148.849023] r15: 0x5682fbc0  r16: 0xffffffff r17: 0x00000000
[ 3148.849023] r18: 0x00000001  r19: 0x5682faa4 r20: 0x5682fa84
[ 3148.849023] r21: 0x5682fa64  r22: 0x5682fb30 r23: 0x00000020
[ 3148.849023] r24: 0x000d2bb8  r25: 0x5682fbc0
[ 3148.849023]
[ 3148.849023]
[ 3148.901689]
[ 3148.901689] Stack Trace:
[ 3148.905781] Firmware build version: AAA
[ 3148.905781] Firmware configuration: BBB
[ 3148.905781] Hardware ID           : CCC
[ 3148.920879]   skb_try_coalesce+0x94/0x3a0
[ 3148.925026]   tcp_try_coalesce+0x3c/0xf0
[ 3148.929079]   tcp_queue_rcv+0x44/0x164
[ 3148.932953]   tcp_data_queue+0x32a/0x75c
[ 3148.936946]   tcp_rcv_established+0x37e/0x7d4
[ 3148.941438]   tcp_v4_do_rcv+0xda/0x120
[ 3148.945320]   tcp_v4_rcv+0x8f2/0xa04
[ 3148.949034]   ip_local_deliver+0x72/0x208
[ 3148.953179]   process_backlog+0xbe/0x1b0
[ 3148.957169]   net_rx_action+0xfe/0x27c
[ 3148.961057]   __do_softirq+0xf0/0x228
[ 3148.964863]   __local_bh_enable_ip+0xae/0xb4
[ 3148.969277]   ip_finish_output2.constprop.6+0x116/0x368
[ 3148.974641]   __tcp_transmit_skb+0x56e/0xb3c
[ 3148.979039]   tcp_write_xmit+0x34a/0x126c
[ 3148.983174]   __tcp_push_pending_frames+0x28/0x94
[ 3148.987992]   tcp_sendmsg_locked+0xa7a/0xc14
[ 3148.992386]   tcp_sendmsg+0x1e/0x34
[ 3148.995935]   __sys_sendto+0xc8/0xf4
[ 3148.999642]   EV_Trap+0x11c/0x120
[ 3149.003057]

Conditions under which this happens:

There are 2 processes running on platform which communicate with TCP
sockets- P1 and P2.
1. P1 has 2 TCP sockets- one TCP client to communicate with P2 while
another TCP server to listen to client running on another machine.
2. P1 has issued command to P2 and P2 is preparing response.
3. While P2 is preparing response, P1 receives zero sized packet from
remote server and closes its server socket treating this as error.
Note: client socket is open/active. P2 prepares its response but its
buffered
4. P1 respawns server socket and issues another command to P2 and
waits for response.
5. P2 now sends 2 sets of data- one for old session and one response
for current command. I see kernel panic with backtrace as above.


There is another symptom of this issue :

# [  194.416963] Alignment trap: fault in fix-up 0000a260 at [<00000001>]
[  194.423419]
[  194.423419] Misaligned Access
[  194.427950] Path: (null)
[  194.430517] CPU: 0 PID: 0 Comm: swapper Tainted: P           O
4.19.35 #3
[  194.437816]
[  194.437816] [ECR   ]: 0x00230400 => Misaligned r/w from 0x00000001
[  194.445597] [EFA   ]: 0x00000001
[  194.445597] [BLINK ]: tcp_ack+0x5e6/0x1598
[  194.445597] [ERET  ]: tcp_ack+0x606/0x1598
[  194.457087] [STAT32]: 0x0000020e : K       A1 E2 E1
[  194.462137] BTA: 0x8b3bf3b7   SP: 0x8b4c9c04  FP: 0x00000000
[  194.467777] LPS: 0x8b3ba37c  LPE: 0x8b3ba384 LPC: 0x00000000
[  194.473454] r00: 0x8ce503c0  r01: 0x8f3b34e4 r02: 0x00000001
[  194.473454] r03: 0xa0076e71  r04: 0x00000000 r05: 0x06e0ed35
[  194.473454] r06: 0x8f3b3800  r07: 0x00000000 r08: 0x0b9362f8
[  194.473454] r09: 0x00000000  r10: 0x00032e0c r11: 0x00000000
[  194.473454] r12: 0xefec0000  r13: 0x8f3b3400 r14: 0x8f3b3c00
[  194.473454] r15: 0x8ce503c0  r16: 0x00000001 r17: 0x8f3b3800
[  194.473454] r18: 0x00000000  r19: 0x00000000 r20: 0x66c2443f
[  194.473454] r21: 0x8b4c9c80  r22: 0x00000004 r23: 0x00000001
[  194.473454] r24: 0x00000000  r25: 0x8b4cb2e0
[  194.473454]
[  194.473454]
[  194.526128]
[  194.526128] Stack Trace:
[  194.530209]
[  194.530209] Firmware build version: pyang_sh-swbuild04_main2ac-cl101263
[  194.530216]
[  194.530216] Firmware configuration: pearl_10gax_config
[  194.538389]
[  194.538389] Hardware ID           : 65535
[  194.550632]   tcp_ack+0x606/0x1598
[  194.554160]   tcp_rcv_established+0x458/0x7d4
[  194.558646]   tcp_v4_do_rcv+0xda/0x120
[  194.562521]   tcp_v4_rcv+0x8f2/0xa04
[  194.566162]   ip_local_deliver+0x72/0x208
[  194.570287]   netif_receive_skb+0x62/0x104
[  194.574510]   br_handle_frame_finish.constprop.2+0x1a6/0x270
[  194.580299]   br_handle_frame+0x170/0x2a0
[  194.584427]   __netif_receive_skb_core+0x156/0x650
[  194.589346]   netif_receive_skb+0x50/0x104
[  194.593582]   wowlan_magic_packet_check+0xc68/0x16b8 [switch_tqe]
[  194.599825]   net_rx_action+0xfe/0x27c
[  194.603695]   __do_softirq+0xf0/0x228
[  194.607477]   __handle_domain_irq+0x5c/0x98
[  194.611732]   handle_interrupt_level1+0xcc/0xd8


Do you happen to know if this is already reported/fixed?
I can run more experiments/gather more debug data/stats if required.

Thanks in advance.

-Avinash
