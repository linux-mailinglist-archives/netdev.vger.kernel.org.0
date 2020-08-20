Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2166924BAF3
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgHTMUj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Aug 2020 08:20:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21815 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730083AbgHTMUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 08:20:36 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-118-q-2yRy14OXaDjkU2wgyLYg-1; Thu, 20 Aug 2020 13:20:32 +0100
X-MC-Unique: q-2yRy14OXaDjkU2wgyLYg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 20 Aug 2020 13:20:25 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 20 Aug 2020 13:20:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Sitnicki' <jakub@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: RE: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
Thread-Topic: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
Thread-Index: AQHWdtzbHJLXFHCDqUy9ea5Q2RcL9qlA6Vow
Date:   Thu, 20 Aug 2020 12:20:25 +0000
Message-ID: <ad210e824dd74c05b1072655fc5dc69c@AcuMS.aculab.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
 <87lficrm2v.fsf@cloudflare.com>
 <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com>
 <87k0xtsj91.fsf@cloudflare.com>
In-Reply-To: <87k0xtsj91.fsf@cloudflare.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki
> Sent: 20 August 2020 11:30
> Subject: Re: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
> 
> On Tue, Aug 18, 2020 at 08:19 PM CEST, Alexei Starovoitov wrote:
> > On Tue, Aug 18, 2020 at 8:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>          :                      rcu_read_lock();
> >>          :                      run_array = rcu_dereference(net-
> >bpf.run_array[NETNS_BPF_SK_LOOKUP]);
> >>     0.01 :   ffffffff817f8624:       mov    0xd68(%r12),%rsi
> >>          :                      if (run_array) {
> >>     0.00 :   ffffffff817f862c:       test   %rsi,%rsi
> >>     0.00 :   ffffffff817f862f:       je     ffffffff817f87a9 <__udp4_lib_lookup+0x2c9>
> >>          :                      struct bpf_sk_lookup_kern ctx = {
> >>     1.05 :   ffffffff817f8635:       xor    %eax,%eax
> >>     0.00 :   ffffffff817f8637:       mov    $0x6,%ecx
> >>     0.01 :   ffffffff817f863c:       movl   $0x110002,0x40(%rsp)
> >>     0.00 :   ffffffff817f8644:       lea    0x48(%rsp),%rdi
> >>    18.76 :   ffffffff817f8649:       rep stos %rax,%es:(%rdi)
> >>     1.12 :   ffffffff817f864c:       mov    0xc(%rsp),%eax
> >>     0.00 :   ffffffff817f8650:       mov    %ebp,0x48(%rsp)
> >>     0.00 :   ffffffff817f8654:       mov    %eax,0x44(%rsp)
> >>     0.00 :   ffffffff817f8658:       movzwl 0x10(%rsp),%eax
> >>     1.21 :   ffffffff817f865d:       mov    %ax,0x60(%rsp)
> >>     0.00 :   ffffffff817f8662:       movzwl 0x20(%rsp),%eax
> >>     0.00 :   ffffffff817f8667:       mov    %ax,0x62(%rsp)
> >>          :                      .sport          = sport,
> >>          :                      .dport          = dport,
> >>          :                      };
> >
> > Such heavy hit to zero init 56-byte structure is surprising.
> > There are two 4-byte holes in this struct. You can try to pack it and
> > make sure that 'rep stoq' is used instead of 'rep stos' (8 byte at a time vs 4).
> 
> Thanks for the tip. I'll give it a try.

You probably don't want to use 'rep stos' in any of its forms.
The instruction 'setup' time is horrid on most cpu variants.
For a 48 byte structure six writes of a zero register will be faster.

If gcc is generating the 'rep stos' then the compiler source code for that
pessimisation needs deleting...

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

