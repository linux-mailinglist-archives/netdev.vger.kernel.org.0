Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACB717A70F
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCEOBs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Mar 2020 09:01:48 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:33499 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbgCEOBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:01:47 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-164-KJo5V8FzM7mDZwf714M0Bg-1; Thu, 05 Mar 2020 14:01:44 +0000
X-MC-Unique: KJo5V8FzM7mDZwf714M0Bg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 5 Mar 2020 14:01:43 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 5 Mar 2020 14:01:43 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jere Leppanen' <jere.leppanen@nokia.com>,
        Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Subject: RE: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
Thread-Topic: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
Thread-Index: AQHV8kg53juXUxi3m0qbVfk5LNaAmag6CEpg
Date:   Thu, 5 Mar 2020 14:01:43 +0000
Message-ID: <8831b4dc929148f28cca658a4d7a11d9@AcuMS.aculab.com>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
 <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com>
 <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
 <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
In-Reply-To: <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
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

From: Jere Leppanen
> Sent: 04 March 2020 17:13
> On Wed, 4 Mar 2020, Xin Long wrote:
> 
> > On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> > <jere.leppanen@nokia.com> wrote:
> >>
> >> On Mon, 2 Mar 2020, Xin Long wrote:
> >>
> >>> As it says in rfc6458#section-9.2:
> >>>
> >>>   The application uses the sctp_peeloff() call to branch off an
> >>>   association into a separate socket.  (Note that the semantics are
> >>>   somewhat changed from the traditional one-to-one style accept()
> >>>   call.)  Note also that the new socket is a one-to-one style socket.
> >>>   Thus, it will be confined to operations allowed for a one-to-one
> >>>   style socket.
> >>>
> >>> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> >>> on which some operations are not allowed, like shutdown, as Jere
> >>> reported.
> >>>
> >>> This patch is to change it to return a one-to-one type socket instead.
> >>
> >> Thanks for looking into this. I like the patch, and it fixes my simple
> >> test case.
> >>
> >> But with this patch, peeled-off sockets are created by copying from a
> >> one-to-many socket to a one-to-one socket. Are you sure that that's
> >> not going to cause any problems? Is it possible that there was a
> >> reason why peeloff wasn't implemented this way in the first place?
> > I'm not sure, it's been there since very beginning, and I couldn't find
> > any changelog about it.
> >
> > I guess it was trying to differentiate peeled-off socket from TCP style
> > sockets.
> 
> Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe
> there is legitimate need for that differentiation in some cases, but I
> think inventing a special socket style is not the best way to handle it.
> 
> But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET
> instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET
> to SOCK_STREAM, but why would we need to avoid that?

Because you don't want all the acks and retransmissions??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

