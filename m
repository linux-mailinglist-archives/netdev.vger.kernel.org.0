Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8121EC3D8
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgFBUlo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Jun 2020 16:41:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:60513 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgFBUlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:41:44 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-82-jLs4S1xMMpC_5-DMx-FG-A-1; Tue, 02 Jun 2020 21:41:39 +0100
X-MC-Unique: jLs4S1xMMpC_5-DMx-FG-A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 2 Jun 2020 21:41:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 2 Jun 2020 21:41:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Michael S. Tsirkin'" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Jason Wang <jasowang@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Thread-Topic: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Thread-Index: AQHWOR0GBiAzsIPf10apeP3ZClgqcqjFyCZA
Date:   Tue, 2 Jun 2020 20:41:38 +0000
Message-ID: <950896ceff2d44e8aaf6f9f5fab210e4@AcuMS.aculab.com>
References: <20200602084257.134555-1-mst@redhat.com>
 <fc204429-7a6e-8214-a66f-bf2676018aae@redhat.com>
 <20200602163306.GM23230@ZenIV.linux.org.uk>
 <CAHk-=wjgg0bpD0qjYF=twJNXmRXYPjXqO1EFLL-mS8qUphe0AQ@mail.gmail.com>
 <20200602162931-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200602162931-mutt-send-email-mst@kernel.org>
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

From: Michael S. Tsirkin
> Sent: 02 June 2020 21:33
> On Tue, Jun 02, 2020 at 10:18:09AM -0700, Linus Torvalds wrote:
> > On Tue, Jun 2, 2020 at 9:33 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > >
> > > > It's not clear whether we need a new API, I think __uaccess_being() has the
> > > > assumption that the address has been validated by access_ok().
> > >
> > > __uaccess_begin() is a stopgap, not a public API.
> >
> > Correct. It's just an x86 implementation detail.
> >
> > > The problem is real, but "let's add a public API that would do user_access_begin()
> > > with access_ok() already done" is no-go.
> >
> > Yeah, it's completely pointless.
> >
> > The solution to this is easy: remove the incorrect and useless early
> > "access_ok()". Boom, done.
> 
> Hmm are you sure we can drop it? access_ok is done in the context
> of the process. Access itself in the context of a kernel thread
> that borrows the same mm. IIUC if the process can be 32 bit
> while the kernel is 64 bit, access_ok in the context of the
> kernel thread will not DTRT.

In which case you need a 'user_access_begin' that takes the mm
as an additional parameter.

I found an 'interesting' acccess_ok() call in the code that copies
iov[] into kernel (eg for readv()).

a) It is a long way from any copies.
b) It can be conditionally ignored - and is so for one call.
   The oddball is code that reads from a different process.
   I didn't spot an equivalent check, but it all worked by
   mapping in the required page - so I'm not sure what happens.

Are there really just 2 limits for access_ok().
One for 64bit programs and one for 32bit?
With the limit being just below the 'dso' page??
So checking the current processes limit is never going
to restrict access.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

