Return-Path: <netdev+bounces-7072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B93C2719A70
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E70D1C20B5E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E1923417;
	Thu,  1 Jun 2023 11:01:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E680723402
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:01:32 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B77199
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 04:01:27 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-144-KQsI8QU2NXmzXqmxFLGEwA-1; Thu, 01 Jun 2023 12:01:24 +0100
X-MC-Unique: KQsI8QU2NXmzXqmxFLGEwA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 1 Jun
 2023 12:01:21 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 1 Jun 2023 12:01:21 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'David Howells' <dhowells@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>, "Jens
 Axboe" <axboe@kernel.dk>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chuck Lever
	<chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, John Fastabend
	<john.fastabend@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Linus
 Torvalds" <torvalds@linux-foundation.org>
Subject: RE: Bug in short splice to socket?
Thread-Topic: Bug in short splice to socket?
Thread-Index: AQHZk0XbNwrvw6NqbEOlRWOj/YHtG691x/2w
Date: Thu, 1 Jun 2023 11:01:21 +0000
Message-ID: <3009021da34b4d70a839c1f0a40ffc58@AcuMS.aculab.com>
References: <20230526180844.73745d78@kernel.org>
 <20230524153311.3625329-1-dhowells@redhat.com>
 <20230524153311.3625329-10-dhowells@redhat.com>
 <499791.1685485603@warthog.procyon.org.uk>
In-Reply-To: <499791.1685485603@warthog.procyon.org.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Howells
> Sent: 30 May 2023 23:27
>=20
> Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> > Will the TLS selftests under tools/.../net/tls.c exercise this?
>=20
> Interesting.  Now that you've pointed me at it, I've tried running it.  M=
ostly
> it passes, but I'm having some problems with the multi_chunk_sendfile tes=
ts
> that time out.  I think that splice_direct_to_actor() has a bug.  The pro=
blem
> is this bit of code:
>=20
> =09=09/*
> =09=09 * If more data is pending, set SPLICE_F_MORE
> =09=09 * If this is the last data and SPLICE_F_MORE was not set
> =09=09 * initially, clears it.
> =09=09 */
> =09=09if (read_len < len)
> =09=09=09sd->flags |=3D SPLICE_F_MORE;
> =09=09else if (!more)
> =09=09=09sd->flags &=3D ~SPLICE_F_MORE;
>=20
> When used with sendfile(), it sets SPLICE_F_MORE (which causes MSG_MORE t=
o be
> passed to the network protocol) if we haven't yet read everything that th=
e
> user requested and clears it if we fulfilled what the user requested.
>=20
> This has the weird effect that MSG_MORE gets kind of inverted.  It's neve=
r
> seen by the actor if we can read the entire request into the pipe - excep=
t if
> we hit the EOF first.  If we hit the EOF before we fulfil the entire requ=
est,
> we get a short read and SPLICE_F_MORE and thus MSG_MORE *is* set.  The
> upstream TLS code ignores it - but I'm changing this with my patches as
> sendmsg() then uses it to mark the EOR.

Isn't MSG_MORE supposed to be just a hint that more data will follow.
So you'd expect a final send with MSG_MORE to get sent, but possibly
after a short timeout.

Using it as a record marker seems wrong.

I'm not sure how to clear 'Oh bugger I set MSG_MORE but have no data'
to avoid the timeout.
A zero length semdmsg() won't DTRT with protocols like SCTP.
(Does splice even do anything sensible with SCTP?)

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


