Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA444B2107
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390985AbfIMNb3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Sep 2019 09:31:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:37653 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391723AbfIMNb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:31:27 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-6-KpIWV1bdPc6qzhcaao16VA-1; Fri, 13 Sep 2019 14:31:23 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 13 Sep 2019 14:31:22 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 13 Sep 2019 14:31:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Topic: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Index: AQHVZuRCrtt5derbnkaX0GdcwfdxAKck5i9wgAE3h4CAABM4AIACeq2egAChsYCAAEAEAIAAEcnA
Date:   Fri, 13 Sep 2019 13:31:22 +0000
Message-ID: <be14cc8353f6403c82ad81e3e741d8f0@AcuMS.aculab.com>
References: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
 <20190911125609.GC3499@localhost.localdomain>
 <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
 <20190912225154.GF3499@localhost.localdomain>
 <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
 <20190913131954.GX3431@localhost.localdomain>
In-Reply-To: <20190913131954.GX3431@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: KpIWV1bdPc6qzhcaao16VA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 'Marcelo Ricardo Leitner'
> Sent: 13 September 2019 14:20
...
> Interestingly, we have/had the opposite problem with netlink. Like, it
> was allowing too much flexibility, such as silently ignoring unknown
> fields (which is what would happen with a new app running on an older
> kernel would trigger here) is bad because the app cannot know if it
> was actually used or not. Some gymnastics in the app could cut through
> the fat here, like probing getsockopt() return size, but then it may
> as well probe for the right sockopt to be used.

Yes, it would also work if the kernel checked that all 'unexpected'
fields were zero (up to some sanity limit of a few kB).

Then an application complied with a 'new' header would work with
an old kernel provided it didn't try so set any new fields.
(And it zeroed the entire structure.)

But you have to start off with that in mind.

Alternatively stop the insanity of setting multiple options
with one setsockopt call.
If multiple system calls are an issue implement a system call
that will set multiple options on the same socket.
(Maybe through a CMSG()-like buffer).
Then the application can set the ones it wants without having
to do the read-modify-write sequence needed for some of the
SCTP ones.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

