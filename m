Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D8031DEEC
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhBQSNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:13:31 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:40138 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234813AbhBQSNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 13:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613585531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=swCSQpXU0cBUK+8HD0R9gjV+haeLjLXOEm2K+cTEeXc=;
        b=ZZ2c6ADfceZPcG7066XHjkwkmgdTuJsNdxPL2FOFH+GaBGeIY81pNgHDKx/6rIy1JSJS7x
        7QQUCnTTfYBbnc4XjheOFxdyrr6JfHaVPuSXGM9A+pZSS0eeTIFhhgJxib8NKTPH96EPoC
        nrgJQpuLVhl7ePtTOc9+98h8+DarhDY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bdf45ff6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 17 Feb 2021 18:12:11 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id n195so14653772ybg.9;
        Wed, 17 Feb 2021 10:12:11 -0800 (PST)
X-Gm-Message-State: AOAM531Og2xFp44gnNeCQsXYpviU/HF8KUJT6mzA7oRM4PJV1M+Zx5ci
        ZOb1s67RgGgDR/cO5w/8abSDE1OZFpvo0Yhn+1s=
X-Google-Smtp-Source: ABdhPJwks4POCamgjwBjWKdr5p4yZ9c1y9yTD+R52YjcJwoD8n52/q6FNsk52DTr9Wlm2NPOXv3GWU/mlZlNwmjXMWg=
X-Received: by 2002:a25:7693:: with SMTP id r141mr848044ybc.49.1613585530840;
 Wed, 17 Feb 2021 10:12:10 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 17 Feb 2021 19:12:00 +0100
X-Gmail-Original-Message-ID: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
Message-ID: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
Subject: possible stack corruption in icmp_send (__stack_chk_fail)
To:     Netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Netdev & Willem,

I've received a report of stack corruption -- via the stack protector
check -- in icmp_send. I was sent a vmcore, and was able to extract
the OOPS from there. However, I've been unable to produce the bug and
I don't see where it'd be in the code. That might point to a more
sinister problem, or I'm simply just not seeing it. Apparently the
reporter reproduces it every 40 or so minutes, and has seen it happen
since at least ~5.10. Willem - I'm emailing you because it seems like
you were making a lot of changes to the icmp code around then, and
perhaps you have an intuition. For example, some of the error handling
code takes a pointer to a stack buffer (_objh and such), and maybe
that's problematic? I'm not quite sure. The vmcore, along with the
various kernel binaries I hunted down are here:
https://data.zx2c4.com/icmp_send-crash-e03b4a42-706a-43bf-bc40-1f15966b3216.tar.xz
. The extracted dmesg follows below, in case you or anyone has a
pointer. I've been staring at this for a while and don't see it.

Jason

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
in: __icmp_send+0x5bd/0x5c0
CPU: 0 PID: 959 Comm: kworker/0:2 Kdump: loaded Not tainted
5.11.0-051100-lowlatency #202102142330
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: wg-crypt-wg0 wg_packet_decrypt_worker [wireguard]
Call Trace:
 <IRQ>
 show_stack+0x52/0x58
 dump_stack+0x70/0x8b
 panic+0x108/0x2ea
 ? ip_push_pending_frames+0x42/0x90
 ? __icmp_send+0x5bd/0x5c0
 __stack_chk_fail+0x14/0x20
 __icmp_send+0x5bd/0x5c0
 icmp_ndo_send+0x148/0x160
 wg_xmit+0x359/0x450 [wireguard]
 ? harmonize_features+0x19/0x80
 xmit_one.constprop.0+0x9f/0x190
 dev_hard_start_xmit+0x43/0x90
 sch_direct_xmit+0x11d/0x340
 __qdisc_run+0x66/0xc0
 __dev_xmit_skb+0xd5/0x340
 __dev_queue_xmit+0x32b/0x4d0
 ? nf_conntrack_double_lock.constprop.0+0x97/0x140 [nf_conntrack]
 dev_queue_xmit+0x10/0x20
 neigh_connected_output+0xcb/0xf0
 ip_finish_output2+0x17f/0x470
 __ip_finish_output+0x9b/0x140
 ? ipv4_confirm+0x4a/0x80 [nf_conntrack]
 ip_finish_output+0x2d/0xb0
 ip_output+0x78/0x110
 ? __ip_finish_output+0x140/0x140
 ip_forward_finish+0x58/0x90
 ip_forward+0x40a/0x4d0
 ? ip4_key_hashfn+0xb0/0xb0
 ip_sublist_rcv_finish+0x3d/0x50
 ip_list_rcv_finish.constprop.0+0x163/0x190
 ip_sublist_rcv+0x37/0xb0
 ? ip_rcv_finish_core.constprop.0+0x310/0x310
 ip_list_rcv+0xf5/0x120
 __netif_receive_skb_list_core+0x228/0x250
 __netif_receive_skb_list+0x102/0x170
 ? dev_gro_receive+0x1b5/0x370
 netif_receive_skb_list_internal+0xca/0x190
 napi_complete_done+0x7a/0x1a0
 wg_packet_rx_poll+0x384/0x400 [wireguard]
 napi_poll+0x92/0x200
 net_rx_action+0xb8/0x1c0
 __do_softirq+0xce/0x2b3
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 do_softirq_own_stack+0x3d/0x50
 do_softirq+0x66/0x80
 __local_bh_enable_ip+0x62/0x70
 _raw_spin_unlock_bh+0x1e/0x20
 wg_packet_decrypt_worker+0xf6/0x190 [wireguard]
 process_one_work+0x217/0x3e0
 worker_thread+0x4d/0x350
 ? rescuer_thread+0x390/0x390
 kthread+0x145/0x170
 ? __kthread_bind_mask+0x70/0x70
 ret_from_fork+0x22/0x30
Kernel Offset: 0x2000000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
