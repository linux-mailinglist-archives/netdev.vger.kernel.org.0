Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5491B6341F1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiKVQzh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Nov 2022 11:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiKVQzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:55:33 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85D7742FA
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:55:31 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-283-2HMUIcawP0Ss9ayqiu8Yyg-1; Tue, 22 Nov 2022 16:55:29 +0000
X-MC-Unique: 2HMUIcawP0Ss9ayqiu8Yyg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 22 Nov
 2022 16:55:27 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Tue, 22 Nov 2022 16:55:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: RE: Optimising csum_fold()
Thread-Topic: Optimising csum_fold()
Thread-Index: Adj+b8b0ybT82IBbSHeFnZ0Bnl9aNQAHytGAAADzUoA=
Date:   Tue, 22 Nov 2022 16:55:27 +0000
Message-ID: <f2ad1680da754f0eab1083d651c8f71c@AcuMS.aculab.com>
References: <e77165c267df486f914f8013fede1d32@AcuMS.aculab.com>
 <20221122162451.GB15368@1wt.eu>
In-Reply-To: <20221122162451.GB15368@1wt.eu>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
> Sent: 22 November 2022 16:25
> 
> On Tue, Nov 22, 2022 at 01:08:23PM +0000, David Laight wrote:
> > There are currently 20 copies of csum_fold(), some in C some in assembler.
> > The default C version (in asm-generic/checksum.h) is pretty horrid.
> > Some of the asm versions (including x86 and x86-64) aren't much better.
> >
> > There are 3 pretty good C versions:
> >   1:	(~sum - rol32(sum, 16)) >> 16
> >   2:  ~(sum + rol32(sum, 16)) >> 16
> >   3:  (u16)~((sum + rol32(sum, 16)) >> 16)
> > All three are (usually) 4 arithmetic instructions.
> >
> > The first two have the advantage that the high bits are zero.
> > Relevant when the value is being checked rather than set.
> >
> > The first one can generate better instruction scheduling (the rotate
> > and invert can be executed in the same clock).
> >
> > The 3rd one saves an instruction on arm, but may need masking.
> > (I've not compiled an arm kernel to see how often that happens.)
> >
> > The only architectures where (I think) the current asm code is better
> > than the C above are sparc and sparc64.
> > Sparc doesn't have a rotate instruction, but does have a carry flag.
> > This makes the current asm version one instruction shorter.
> >
> > For architectures like mips and risc-v which have neither rotate
> > instructions nor carry flags the C is as good as the current asm.
> > The rotate is 3 instructions - the same as the extra cmp+add.
> >
> > Changing everything to use [1] would improve quite a few architectures
> > while only adding 1 clock to some paths in arm/arm64 and sparc.
> >
> > Unfortunately it is all currently a mess.
> > Most architectures don't include asm-generic/checksum.h at all.
> >
> > Thoughts?
> 
> Then why not just have one version per arch, the most efficient one,
> and use it everywhere ? The simple fact that we're discussing the
> tradeoffs means that if we don't want to compromise performance here
> (which I assume to be the case), then it needs to be per-arch and
> that's all. At least that's the way I understand it.

At the moment there are a lot of arch-specific ones that are
definitely sub-optimal.

I started doing some patches, my x86-64 kernel in about 4k
smaller with [1].
I was going to post the patches to asm-generic an x86.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

