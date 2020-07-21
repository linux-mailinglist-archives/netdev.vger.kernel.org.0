Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218D0227AB9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgGUIcu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jul 2020 04:32:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60884 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbgGUIcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 04:32:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-128-woYkEPDyM0aJ7Kkq3MEOcA-1; Tue, 21 Jul 2020 09:32:46 +0100
X-MC-Unique: woYkEPDyM0aJ7Kkq3MEOcA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 21 Jul 2020 09:32:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 Jul 2020 09:32:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: RE: Misaligned IPv6 addresses is SCTP socket options.
Thread-Topic: Misaligned IPv6 addresses is SCTP socket options.
Thread-Index: AdZeq3CoQr6UZTOvRHy9xmmfSyelxAAVoqqAAAzMZSA=
Date:   Tue, 21 Jul 2020 08:32:45 +0000
Message-ID: <5bf6c1d336284bf7bf0a3a32d5b64910@AcuMS.aculab.com>
References: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
 <20200721025517.GA3399@localhost.localdomain>
In-Reply-To: <20200721025517.GA3399@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 21 July 2020 03:55
> 
> On Mon, Jul 20, 2020 at 03:50:16PM +0000, David Laight wrote:
> > Several of the structures in linux/uapi/linux/sctp.h are
> > marked __attribute__((packed, aligned(4))).
> 
> I don't think we can change that by now. It's bad, yes, but it's
> exposed and, well, for a long time (since 2005).
> 
> >
> > I believe this was done so that the UAPI structure was the
> > same on both 32 and 64bit systems.
> > The 'natural' alignment is that of 'u64' - so would differ
> > between 32 and 64 bit x86 cpus.
> >
> > There are two horrible issues here:
> >
> > 1) I believe the natural alignment of u64 is actually 8
> >    bytes on some 32bit architectures.
> 
> Not sure which?

Try arm for starters.

> >    So the change would have broken binary compatibility
> >    for 32bit applications compiled before the alignment
> >    was added.
> 
> If nobody complained in 15 years, that's probably not a problem. ;-)
> 
> >
> > 2) Inside the kernel the address of the structure member
> >    is 'blindly' passed through as if it were an aligned
> >    pointer.
> >    For instance I'm pretty sure is can get passed to
> >    inet_addr_is_any() (in net/core/utils.).
> >    Here it gets passed to memcmp().
> >    gcc will inline the memcmp() and almost certainly use 64bit
> >    accesses.
> >    These will fault on architectures (like sparc64).
> 
> For 2) here we should fix it by copying the data into a different
> buffer, or something like that.

At least on some architectures.
I did wonder if the buffer could be read to 8n+4 aligned memory,
but there are aligned 64bit items elsewhere.

> That is happening on structs sctp_setpeerprim sctp_prim
> sctp_paddrparams sctp_paddrinfo, right?
> As they all use the pattern of having a sockaddr_storage after a s32.

Not no mention sctp_assoc_stats....
Which is broken for 32bit binaries on x86 and sparc 64bit kernels.
I think there is (there should be) a kernel type on 64bit
systems that is 8 bytes with the alignment it would have
on the corresponding 32bit architecture.
If nothing else using alignof() on a structure containing
a member of that type will give the 4 or 8 required to fix
the code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

