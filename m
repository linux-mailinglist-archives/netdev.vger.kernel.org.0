Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF406DBCDB
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 22:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDHUGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 16:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDHUGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 16:06:05 -0400
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 08 Apr 2023 13:06:03 PDT
Received: from resqmta-a1p-077437.sys.comcast.net (resqmta-a1p-077437.sys.comcast.net [IPv6:2001:558:fd01:2bb4::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAACF900C
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 13:06:03 -0700 (PDT)
Received: from resomta-a1p-077052.sys.comcast.net ([96.103.145.234])
        by resqmta-a1p-077437.sys.comcast.net with ESMTP
        id lED9pQrJpwZTllEmZp7D1o; Sat, 08 Apr 2023 20:03:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1680984211;
        bh=5X6C2L2NSzEiFu4R5siwZ5S34WAhfl2l65r4VtgzW0U=;
        h=Received:Received:From:To:Subject:Date:MIME-Version:Message-ID:
         Content-Type:Xfinity-Spam-Result;
        b=I9wTjudx7sXMe0NtABFQDx48sXpOsba5S6EUjGxYYmv+sMn9Q4A2MivLeS94+nLzs
         XFLJUOtdOKMp51DkScrsoO9BVkbSHG53XlcQ35TjSr9mMXAbLGaZyz4Tjupxh6CNza
         LBbC8LzjXG+SedseRrec4GN2C50MMoGC3QW15xYg4py+TEEPf3J1Ni/yMXSqZlTa9t
         9vg3wdCGl3zptgqB7rHzExEyEd27X8Z/87p8w0iRi+kWNOVmHqo844C4XEmenqVmbt
         Mf1wWRqCBFVNWXsM626q3Lu4wCcFh3Ap5i3qKkeBzrxAMrLkmXe1rRH7A0QrPJlSqn
         M83OcvMUnwBwQ==
Received: from localhost ([IPv6:2601:18c:9082:afd:219:d1ff:fe75:dc2f])
        by resomta-a1p-077052.sys.comcast.net with ESMTPSA
        id lEmYp9m2Aq4HDlEmYpEyOV; Sat, 08 Apr 2023 20:03:31 +0000
X-Xfinity-VMeta: sc=0.00;st=legit
From:   Matt Whitlock <kernel@mattwhitlock.name>
To:     <netdev@vger.kernel.org>
Subject: Memory leak in =?iso-8859-1?Q?=5F=5Fip6=5Frt=5Fupdate=5Fpmtu_(net/ipv6/route.c)?=
Date:   Sat, 08 Apr 2023 16:03:29 -0400
MIME-Version: 1.0
Message-ID: <241aa97b-4e6a-4b57-a80b-8f711c135b91@mattwhitlock.name>
User-Agent: Trojita/v0.7-503-g0dbe2890; Qt/5.15.8; xcb; Linux; Gentoo Linux
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found while running 6.1.23-gentoo with kmemleak while trying to diagnose a=20=

probably unrelated memory leak:

unreferenced object 0xffff888042fc7b00 (size 256):
  comm "softirq", pid 0, jiffies 4328682724 (age 5739.246s)
  hex dump (first 32 bytes):
    00 80 4d 01 81 88 ff ff 00 49 e3 94 ff ff ff ff  ..M......I......
    60 ef 70 b5 81 88 ff ff a4 9c 0b 02 01 00 00 00  `.p.............
  backtrace:
    [<000000000b4f8d52>] dst_alloc+0x3c/0x140
    [<0000000075b21562>] ip6_rt_cache_alloc.constprop.0+0x7b/0x190
    [<00000000236d18fe>] __ip6_rt_update_pmtu+0x119/0x250
    [<00000000e4b766f3>] inet6_csk_update_pmtu+0x42/0x80
    [<00000000b86e1f12>] tcp_v6_mtu_reduced+0x35/0x80
    [<00000000a854cc14>] tcp_v6_err+0x41f/0x480
    [<00000000eff3ef2f>] icmpv6_notify+0xbb/0x180
    [<00000000e4924371>] icmpv6_rcv+0x34a/0x3d0
    [<000000007163d548>] ip6_protocol_deliver_rcu+0x75/0x3b0
    [<00000000fdb6a323>] ip6_input_finish+0x35/0x60
    [<00000000ebde6920>] ip6_sublist_rcv_finish+0x2d/0x40
    [<00000000105dd24d>] ip6_sublist_rcv+0x191/0x210
    [<00000000e87845f8>] ipv6_list_rcv+0xed/0x100
    [<00000000206d66ad>] __netif_receive_skb_list_core+0x16c/0x1c0
    [<0000000000117935>] netif_receive_skb_list_internal+0x173/0x270
    [<00000000ea0594e7>] napi_complete_done+0x69/0x170
unreferenced object 0xffff8881b570ef60 (size 96):
  comm "softirq", pid 0, jiffies 4328682724 (age 5739.246s)
  hex dump (first 32 bytes):
    00 00 00 00 c8 05 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000adeef916>] kmalloc_trace+0x11/0x20
    [<000000002752b81a>] dst_cow_metrics_generic+0x22/0x100
    [<00000000b9c32bc3>] rt6_do_update_pmtu+0x34/0xb0
    [<00000000c53e4e49>] __ip6_rt_update_pmtu+0x12c/0x250
    [<00000000e4b766f3>] inet6_csk_update_pmtu+0x42/0x80
    [<00000000b86e1f12>] tcp_v6_mtu_reduced+0x35/0x80
    [<00000000a854cc14>] tcp_v6_err+0x41f/0x480
    [<00000000eff3ef2f>] icmpv6_notify+0xbb/0x180
    [<00000000e4924371>] icmpv6_rcv+0x34a/0x3d0
    [<000000007163d548>] ip6_protocol_deliver_rcu+0x75/0x3b0
    [<00000000fdb6a323>] ip6_input_finish+0x35/0x60
    [<00000000ebde6920>] ip6_sublist_rcv_finish+0x2d/0x40
    [<00000000105dd24d>] ip6_sublist_rcv+0x191/0x210
    [<00000000e87845f8>] ipv6_list_rcv+0xed/0x100
    [<00000000206d66ad>] __netif_receive_skb_list_core+0x16c/0x1c0
    [<0000000000117935>] netif_receive_skb_list_internal+0x173/0x270

Note: The bottom object is referenced by the top object. (Look in the hex=20
dump to see the address 0xffff8881b570ef60 in little-endian byte order at=20
offset 16.)

To my unfamiliar eyes this would appear to be the most suspect bit of code=20=

(in __ip6_rt_update_pmtu at net/ipv6/route.c:2907):

=09nrt6 =3D ip6_rt_cache_alloc(&res, daddr, saddr);
=09if (nrt6) {
=09=09rt6_do_update_pmtu(nrt6, mtu);
=09=09if (rt6_insert_exception(nrt6, &res))
=09=09=09dst_release_immediate(&nrt6->dst);
=09}

If rt6_insert_exception returns an error, we release the struct dst_entry=20
(nrt6->dst), but what about the struct rt6_info (*nrt6) that we just=20
allocated?
