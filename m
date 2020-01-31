Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D818814E914
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 08:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgAaHRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 02:17:17 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:50542 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbgAaHRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 02:17:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1580455033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=262ZcO9nGFIaHjYtWQmk/Eq3eRhsSEhvvzLlMTVZhgY=;
        b=FjZFhdVlICftOoiLbHemtSAy0XBE3r+42d6JOwo//ijPAlEUJX+SV0rnYBhkW9n5ZqvcEP
        vBrlbfVrkXMYAC7c7Essy9zyIhRaTigK7RfYYWqF3PI9JO3Z2rgy8fadByAxLZ940L8WDj
        P5Um687AdLKfLRALbkt72RYd4I9HAaI=
From:   Sven Eckelmann <sven@narfation.org>
To:     syzbot <syzbot+24458cef7d37351dd0c3@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com,
        Arvid Brodin <arvid.brodin@alten.se>
Subject: Re: KMSAN: uninit-value in batadv_interface_tx (2)
Date:   Fri, 31 Jan 2020 08:17:05 +0100
Message-ID: <2402337.3Z8xRsGYif@bentobox>
In-Reply-To: <00000000000038fa02059d614893@google.com>
References: <00000000000038fa02059d614893@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2318064.iM8dZQ9v1p"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2318064.iM8dZQ9v1p
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, 30 January 2020 21:27:12 CET syzbot wrote:
[...]
> dashboard link: https://syzkaller.appspot.com/bug?extid=24458cef7d37351dd0c3
[...]
> Reported-by: syzbot+24458cef7d37351dd0c3@syzkaller.appspotmail.com
[...]
> =====================================================
> BUG: KMSAN: uninit-value in batadv_interface_tx+0x10cf/0x2450 net/batman-adv/soft-interface.c:264

This line is just comparing the eth_hdr(skb)->h_dest with the STP address 
(static const buffer). 

Is there some situation when hsr would not initialize offset for eth_hdr() 
correctly or where h_dest is not initialized from a correctly initialized 
value? At least the comparisons with eth_hdr(skb)->h_source didn't cause this 
error.

Regarding my assupmtion: it seems like the hsr_xmit is only initializing the 
h_source in master mode. And there even more conditions (see
hsr_addr_subst_dest) for initializing the h_dest in master mode.

Btw. the code in hsr which "stored this" was

	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
		return;


[...]
>  batadv_interface_tx+0x10cf/0x2450 net/batman-adv/soft-interface.c:264
>  __netdev_start_xmit include/linux/netdevice.h:4447 [inline]
>  netdev_start_xmit include/linux/netdevice.h:4461 [inline]
>  xmit_one net/core/dev.c:3420 [inline]
>  dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3436
>  __dev_queue_xmit+0x37de/0x4220 net/core/dev.c:4013
>  dev_queue_xmit+0x4b/0x60 net/core/dev.c:4046
>  hsr_xmit net/hsr/hsr_forward.c:228 [inline]
>  hsr_forward_do net/hsr/hsr_forward.c:285 [inline]
>  hsr_forward_skb+0x2614/0x30d0 net/hsr/hsr_forward.c:361
>  hsr_handle_frame+0x385/0x4b0 net/hsr/hsr_slave.c:43
>  __netif_receive_skb_core+0x21de/0x5840 net/core/dev.c:5051
>  __netif_receive_skb_one_core net/core/dev.c:5148 [inline]
>  __netif_receive_skb net/core/dev.c:5264 [inline]
>  process_backlog+0x936/0x1410 net/core/dev.c:6095
>  napi_poll net/core/dev.c:6532 [inline]
>  net_rx_action+0x786/0x1ab0 net/core/dev.c:6600
>  __do_softirq+0x311/0x83d kernel/softirq.c:293
>  run_ksoftirqd+0x25/0x40 kernel/softirq.c:607
>  smpboot_thread_fn+0x493/0x980 kernel/smpboot.c:165
>  kthread+0x4b5/0x4f0 kernel/kthread.c:256
>  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353
> 
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
>  kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
>  kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
>  kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
>  __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
>  pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1637
>  __skb_pad+0x47f/0x900 net/core/skbuff.c:1805
>  __skb_put_padto include/linux/skbuff.h:3193 [inline]
>  skb_put_padto include/linux/skbuff.h:3212 [inline]
>  send_hsr_supervision_frame+0x122d/0x1500 net/hsr/hsr_device.c:310
>  hsr_announce+0x1e2/0x370 net/hsr/hsr_device.c:341
>  call_timer_fn+0x218/0x510 kernel/time/timer.c:1404
>  expire_timers kernel/time/timer.c:1449 [inline]
>  __run_timers+0xcff/0x1210 kernel/time/timer.c:1773
>  run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
>  __do_softirq+0x311/0x83d kernel/softirq.c:293


Kind regards,
	Sven
--nextPart2318064.iM8dZQ9v1p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl4z1HEACgkQXYcKB8Em
e0ZO0Q/9HNGZvABsLfWxI93iMpHwWUH4pakoQ7Grba5VxXvEhQiGRUwYuY8DHAHO
V2uHFRAaldEZebz7Q3YMOD/Ysj6IyGROaUSFHKhC4vs9VlEKH/ojanzpE4SPS50L
lXfQ83UiDH+Tz83Ur5pk2CPJ/CQ3B8g8My1+uqrLgs4s216tLWYdfHvp7KEtfp1y
jNYCL/f9BxV9D93Djxv0qVtWEfYPQYipVq9iPgsIG8FRUbCbXiY841eogk/idFNe
0uoOPzMBwfV7ODnAszvi7J0Rg0fa5yunULu4v3yh/SGizu6GIsICa0w9kt5wVWKJ
hzNtAtw2L+RClZnrukDs8NY19QoFBtFNBXi0E6/Y/loEoa9FIGdRx2hcOplrCmhC
siEMhxfWwYlMl+kRas/YTt4jMBilT1Fp89b2prn2YcW8I64QSwyCacTwhZIhvkGy
FCudRlfjBEPbd9uti/37/NXXcv3Nq3ecbdBcALeIaNL+R9CYuemXOfJVkRpgcCs/
otUv3ZKFMeVkML4g+dn4DMcL+UnUlo3ehjKuObJXOdfTnZ4eBQkbIaZA34PQ+zRg
vNxDwM/e2qg6VjvQ2LzoIqPQ5FEb7lPNPBsXQN2kPFJGHwnSocohyJK0aa7FGIB/
RhIMVpyKiR8Zg/r5wUwGhrtGX+lrLp9xRWzWBZ5eyAmdPpOxS70=
=e1ZJ
-----END PGP SIGNATURE-----

--nextPart2318064.iM8dZQ9v1p--



