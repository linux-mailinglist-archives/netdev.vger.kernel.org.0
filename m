Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4EF12A4E
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfECJRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:17:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40160 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfECJRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:17:35 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hMUJw-0002Vx-QW; Fri, 03 May 2019 09:17:32 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Possible refcount bug in ip6_expire_frag_queue()?
Date:   Fri,  3 May 2019 11:17:32 +0200
Message-Id: <20190503091732.19452-1-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 05c0b86b9696802fd0ce5676a92a63f1b455bdf3 "ipv6: frags:
rewrite ip6_expire_frag_queue()" this function got changed to
be like ip_expire() (after dropping a clone there).
This was backported to 4.4.y stable (amongst other stable trees)
in v4.4.174.

Since then we got reports that in evironments with heave ipv6 load,
the kernel crashes about every 2-3hrs with the following trace: [1].

The crash is triggered by the skb_shared(skb) check in
pskb_expand_head(). Comparing ip6_expire_frag_queue() and
ip_expire(), the ipv6 code does a skb_get() which increments that
refcount while the ipv4 code does not seem to do that.

Would it be possible that ip6_expire-frag_queue() should not
call skb_get() when using the first skb of the frag queue for
the icmp message?

Thanks,
Stefan



[1]
[296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/skbuff.c:1207!
[296583.091734] Call Trace:
[296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
[296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
[296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
[296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
[296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
[296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
[296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32/0xa0
[296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 [ixgbe]
[296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
[296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
[296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
[296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_defrag_ipv6]
[296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
[296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
[296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
[296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0
[296583.091995]  [<ffffffff8108a655>] irq_exit+0xa5/0xb0
[296583.092008]  [<ffffffff818660c0>] smp_apic_timer_interrupt+0x50/0x70
[296583.092023]  [<ffffffff8186383c>] apic_timer_interrupt+0xcc/0xe0
[296583.092037]  <EOI>
[296583.092044]  [<ffffffff816f07ae>] ? cpuidle_enter_state+0x11e/0x2d0
[296583.092060]  [<ffffffff816f0997>] cpuidle_enter+0x17/0x20
[296583.092073]  [<ffffffff810ca5c2>] call_cpuidle+0x32/0x60
[296583.092086]  [<ffffffff816f0979>] ? cpuidle_select+0x19/0x20
[296583.092099]  [<ffffffff810ca886>] cpu_startup_entry+0x296/0x360
[296583.092114]  [<ffffffff81052da7>] start_secondary+0x177/0x1b0
[296583.092878] Code: 75 1a 41 8b 87 cc 00 00 00 49 03 87 d0 00 00 00 e9 e2 fe ff ff b8 f4 ff ff ff eb bc 4c 89 ef e8 f4 99 ab ff b8 f4 ff ff ff eb ad <0f> 0b 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89
[296583.094510] RIP  [<ffffffff81740953>] pskb_expand_head+0x243/0x250
[296583.095302]  RSP <ffff88021fd03b80>
[296583.099491] ---[ end trace 4262f47656f8ba9f ]---
