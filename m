Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380242B99DC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgKSRml convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Nov 2020 12:42:41 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:25808 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729561AbgKSRmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:42:39 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-235-PuInSl5ZO8GDYxP6JCcNgw-1; Thu, 19 Nov 2020 17:42:35 +0000
X-MC-Unique: PuInSl5ZO8GDYxP6JCcNgw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 19 Nov 2020 17:42:34 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 19 Nov 2020 17:42:34 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Segher Boessenkool' <segher@kernel.crashing.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>
Subject: RE: violating function pointer signature
Thread-Topic: violating function pointer signature
Thread-Index: AQHWvpH9jLd/DjVTQ26YGUc47fMkpqnPtbCA
Date:   Thu, 19 Nov 2020 17:42:34 +0000
Message-ID: <fac6049651cf4cef92162bec84550458@AcuMS.aculab.com>
References: <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <CAKwvOdkptuS=75WjzwOho9ZjGVHGMirEW3k3u4Ep8ya5wCNajg@mail.gmail.com>
 <20201118121730.12ee645b@gandalf.local.home>
 <20201118181226.GK2672@gate.crashing.org> <87o8jutt2h.fsf@mid.deneb.enyo.de>
 <20201118135823.3f0d24b7@gandalf.local.home>
 <20201118191127.GM2672@gate.crashing.org>
 <20201119083648.GE3121392@hirez.programming.kicks-ass.net>
 <20201119143735.GU2672@gate.crashing.org>
 <20201119095951.30269233@gandalf.local.home>
 <20201119163529.GV2672@gate.crashing.org>
In-Reply-To: <20201119163529.GV2672@gate.crashing.org>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Segher Boessenkool
> Sent: 19 November 2020 16:35
...
> I just meant "valid C language code as defined by the standards".  Many
> people want all UB to just go away, while that is *impossible* to do for
> many compilers: for example where different architectures or different
> ABIs have contradictory requirements.

Some of the UB in the C language are (probably) there because
certain (now obscure) hardware behaved that way.
For instance integer arithmetic may saturate on overflow
(or do even stranger things if the sign is a separate bit).
I'm not quite sure it was ever possible to write a C compiler
for a cpu that processed numbers in ASCII (up to 10 digits),
binary arithmetic was almost impossible.
There are also the CPU that only have 'word' addressing - so
that 'pointers to characters' take extra instructions.

ISTM that a few years ago the gcc developers started looking
at some of these 'UB' and decided they could make use of
them to make some code faster (and break other code).

One of the problems with UB is that whereas you might expect
UB arithmetic to generate an unexpected result and/or signal
it is completely open-ended and could fire an ICBM at the coder.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

