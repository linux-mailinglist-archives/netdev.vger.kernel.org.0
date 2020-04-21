Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735031B2F15
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgDUS16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:27:58 -0400
Received: from pop3.seti.kr.ua ([91.202.132.4]:42737 "EHLO mail.seti.kr.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDUS15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 14:27:57 -0400
Received: from [91.202.134.21] (helo=[192.168.0.237])
        by mail.seti.kr.ua with esmtpa (Exim 4.68)
        (envelope-from <nitr0@seti.kr.ua>)
        id 1jQxcc-0001TJ-Ta
        for netdev@vger.kernel.org; Tue, 21 Apr 2020 21:27:52 +0300
Subject: Re: Memory leaks in 4.14.160+
From:   Andrew <nitr0@seti.kr.ua>
To:     netdev@vger.kernel.org
References: <f6bbdaa6-f266-3c08-a0d6-48383054704c@seti.kr.ua>
Message-ID: <2df8d7f1-2c62-7d72-aae4-4c1276b2857f@seti.kr.ua>
Date:   Tue, 21 Apr 2020 21:27:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f6bbdaa6-f266-3c08-a0d6-48383054704c@seti.kr.ua>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "server6", has
        rated this incoming email in -2.9 points.  The original message
        has been attached to this so you can view it or label similar future
        email. If you have any questions, see techdep@seti.kr.ua for details.
        Content analysis details:   (-2.9 points, 5.0 required)
        pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.7 DNS_FROM_AHBL_RHSBL    RBL: Envelope sender listed in dnsbl.ahbl.org
        -1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
        -2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
        [score: 0.0000]
        0.8 AWL                    AWL: From: address is in the auto white-list
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maybe some extra info is needed?

19.04.2020 12:24, Andrew пишет:
>
>
> Hi all.
>
> I noticed kernel memory leakage in 4.14.160 kernel (~1GB per month on 
> my setup). kmemleak reported a lot of small leaks in 2 places:
>
> unreferenced object 0xffff88806f0dbe00 (size 256):
>   comm "softirq", pid 0, jiffies 8895939313 (age 422075.624s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 02 00 00 00 00 03 00 00 ................
>     c9 ff 0a 00 00 00 00 00 20 ff 6b e7 80 88 ff ff  ........ .k.....
>   backtrace:
>     [<ffffffff816cf9e8>] kmemleak_alloc+0x28/0x50
>     [<ffffffff8119d405>] kmem_cache_alloc+0x125/0x190
>     [<ffffffffa01b3183>] __nf_conntrack_alloc+0x53/0x190 [nf_conntrack]
>     [<ffffffffa01b3786>] init_conntrack+0x4a6/0x500 [nf_conntrack]
>     [<ffffffffa01b3bf6>] nf_conntrack_in+0x416/0x470 [nf_conntrack]
>     [<ffffffffa016124c>] ipv4_conntrack_in+0x1c/0x20 [nf_conntrack_ipv4]
>     [<ffffffff816338b8>] nf_hook_slow+0x48/0xd0
>     [<ffffffff8163c49f>] ip_rcv+0x33f/0x380
>     [<ffffffff815ede07>] __netif_receive_skb_core+0x8a7/0xc20
>     [<ffffffff815f0828>] __netif_receive_skb+0x18/0x60
>     [<ffffffff815f0dd1>] process_backlog+0x91/0x150
>     [<ffffffff815f448b>] net_rx_action+0x2bb/0x780
>     [<ffffffff81a0010c>] __do_softirq+0x10c/0x2b0
>     [<ffffffff8106f754>] irq_exit+0xc4/0xd0
>     [<ffffffff8180266f>] do_IRQ+0x4f/0xe0
>     [<ffffffff8180094c>] ret_from_intr+0x0/0x1d
> unreferenced object 0xffff8880c3c1c180 (size 128):
>   comm "softirq", pid 0, jiffies 8895939313 (age 422075.624s)
>   hex dump (first 32 bytes):
>     82 00 63 3b ce fb 6a 8a 00 00 00 00 00 00 00 00 ..c;..j.........
>     00 00 00 00 20 00 00 00 00 38 c1 c3 80 88 ff ff  .... ....8......
>   backtrace:
>     [<ffffffff816cf9e8>] kmemleak_alloc+0x28/0x50
>     [<ffffffff8119fc5c>] __kmalloc_track_caller+0x13c/0x1b0
>     [<ffffffff8116b141>] __krealloc+0x51/0x90
>     [<ffffffffa01baf37>] nf_ct_ext_add+0x97/0x180 [nf_conntrack]
>     [<ffffffffa01b34be>] init_conntrack+0x1de/0x500 [nf_conntrack]
>     [<ffffffffa01b3bf6>] nf_conntrack_in+0x416/0x470 [nf_conntrack]
>     [<ffffffffa016124c>] ipv4_conntrack_in+0x1c/0x20 [nf_conntrack_ipv4]
>     [<ffffffff816338b8>] nf_hook_slow+0x48/0xd0
>     [<ffffffff8163c49f>] ip_rcv+0x33f/0x380
>     [<ffffffff815ede07>] __netif_receive_skb_core+0x8a7/0xc20
>     [<ffffffff815f0828>] __netif_receive_skb+0x18/0x60
>     [<ffffffff815f0dd1>] process_backlog+0x91/0x150
>     [<ffffffff815f448b>] net_rx_action+0x2bb/0x780
>     [<ffffffff81a0010c>] __do_softirq+0x10c/0x2b0
>     [<ffffffff8106f754>] irq_exit+0xc4/0xd0
>     [<ffffffff8180266f>] do_IRQ+0x4f/0xe0
>
> 4.14.174 have same leaks.
>
> System is used as NAT box + PPPoE terminator, conntrack helpers are 
> loaded automatically by net.netfilter.nf_conntrack_helper=1; loaded 
> helpers: nf_nat_sip nf_nat_pptp nf_nat_ftp
>
>

