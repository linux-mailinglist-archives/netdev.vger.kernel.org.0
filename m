Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751484D0E27
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 03:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiCHC7T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Mar 2022 21:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbiCHC7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 21:59:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EF603914A
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 18:58:22 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-230-RAzJzQoSOG-PkwXfrfam0w-1; Tue, 08 Mar 2022 02:58:19 +0000
X-MC-Unique: RAzJzQoSOG-PkwXfrfam0w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 8 Mar 2022 02:58:18 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 8 Mar 2022 02:58:18 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tadeusz Struk' <tadeusz.struk@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
Subject: RE: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Thread-Topic: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Thread-Index: AQHYMn/TZOkDvut8fEivb26qHFvt1ay0yvXA
Date:   Tue, 8 Mar 2022 02:58:18 +0000
Message-ID: <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com>
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220308000146.534935-1-tadeusz.struk@linaro.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tadeusz Struk
> Sent: 08 March 2022 00:02
> 
> Syzbot found a kernel bug in the ipv6 stack:
> LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
> 
> The reproducer triggers it by sending an invalid message via sendmmsg() call,
> which triggers skb_over_panic, and crashes the kernel:
> 
> skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
> head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
> dev:<NULL>
> 
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:113!
> PREEMPT SMP KASAN
> CPU: 1 PID: 1818 Comm: repro Not tainted 5.17.0-rc7-dirty #9
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35
> RIP: 0010:skb_panic+0x173/0x175
> RSP: 0018:ffffc900015bf3b8 EFLAGS: 00010282
> RAX: 0000000000000090 RBX: ffff88810e848c80 RCX: 0000000000000000
> RDX: ffff88810fd84300 RSI: ffffffff814fa5ef RDI: fffff520002b7e69
> RBP: ffffc900015bf420 R08: 0000000000000090 R09: 0000000000000000
> R10: ffffffff814f55f4 R11: 203a666675626b73 R12: ffffffff855bff80
> R13: ffffffff84647fb4 R14: 0000000000010027 R15: ffffffff855bf420
> FS:  0000000000c8b3c0(0000) GS:ffff88811b100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000040 CR3: 0000000106b68000 CR4: 0000000000150ea0
> Call Trace:
>  <TASK>
>  skb_put.cold+0x23/0x23
>  __ip6_append_data.isra.0.cold+0x396/0xe3a
>  ip6_append_data+0x1e5/0x320
>  rawv6_sendmsg.cold+0x1618/0x2ba9
>  inet_sendmsg+0x9e/0xe0
>  sock_sendmsg+0xd7/0x130
>  ____sys_sendmsg+0x381/0x8a0
>  ___sys_sendmsg+0x100/0x170
>  __sys_sendmmsg+0x26c/0x3b7
>  __x64_sys_sendmmsg+0xb2/0xbd
>  do_syscall_64+0x35/0xb0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The reproducer can be found here:
> LINK: https://syzkaller.appspot.com/text?tag=ReproC&x=1648c83fb00000
> This can be fixed by increasing the alloclen in case it is smaller than
> fraglen in __ip6_append_data().
> 
> 
> Reported-by: syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  net/ipv6/ip6_output.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 4788f6b37053..622345af323e 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1629,6 +1629,13 @@ static int __ip6_append_data(struct sock *sk,
>  				err = -EINVAL;
>  				goto error;
>  			}
> +			if (unlikely(alloclen < fraglen)) {
> +				if (printk_ratelimit())
> +					pr_warn("%s: wrong alloclen: %d, fraglen: %d",
> +						__func__, alloclen, fraglen);
> +				alloclen = fraglen;
> +			}
> +

Except that is a valid case, see a few lines higher:

				alloclen = min_t(int, fraglen, MAX_HEADER);
				pagedlen = fraglen - alloclen;

You need to report the input values that cause the problem later on.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

