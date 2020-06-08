Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18611F1D1A
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgFHQSo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 12:18:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21592 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730267AbgFHQSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:18:44 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-252-mqGdXTzJN4mqnAaD_WReKg-1; Mon, 08 Jun 2020 17:18:40 +0100
X-MC-Unique: mqGdXTzJN4mqnAaD_WReKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Jun 2020 17:18:39 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Jun 2020 17:18:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?iso-8859-1?Q?=27Ivan_Skytte_J=F8rgensen=27?= <isj-sctp@i1.dk>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: packed structures used in socket options
Thread-Topic: packed structures used in socket options
Thread-Index: AQHWPLpUTq2nADe9c02l9PzEMhJDA6jNLBzwgAAGoICAAC9ugP//9FcAgABAGeCAAAZCgIABR3tg
Date:   Mon, 8 Jun 2020 16:18:39 +0000
Message-ID: <cd3793726252407f8e80aa8d0025d44f@AcuMS.aculab.com>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
 <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
 <23a14b44bd5749a6b1b51150c7f3c8ba@AcuMS.aculab.com>
 <2213135.ChUyxVVRYb@isjsys>
In-Reply-To: <2213135.ChUyxVVRYb@isjsys>
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

From: Ivan Skytte Jørgensen
> Sent: 07 June 2020 22:35
...
> > > >>>> contains:
> > > >>>>
> > > >>>> struct sctp_paddrparams {
> > > >>>> 	sctp_assoc_t		spp_assoc_id;
> > > >>>> 	struct sockaddr_storage	spp_address;
> > > >>>> 	__u32			spp_hbinterval;
> > > >>>> 	__u16			spp_pathmaxrxt;
> > > >>>> 	__u32			spp_pathmtu;
> > > >>>> 	__u32			spp_sackdelay;
> > > >>>> 	__u32			spp_flags;
> > > >>>> 	__u32			spp_ipv6_flowlabel;
> > > >>>> 	__u8			spp_dscp;
> > > >>>> } __attribute__((packed, aligned(4)));
> > > >>>>
> > > >>>> This structure is only used in the IPPROTO_SCTP level socket option SCTP_PEER_ADDR_PARAMS.
> > > >>>> Why is it packed?
...
> I was involved. At that time (September 2005) the SCTP API was still evolving (first finalized in
> 2011), and one of the major users of the API was 32-bit programs running on 64-bit kernel (on powerpc
> as I recall). When we realized that the structures were different between 32bit and 64bit we had to
> break the least number of programs, and the result were those ((packed)) structs so 32-bit programs
> wouldn't be broken and we didn't need a xxx_compat translation layer in the kernel.

I was also looking at all the __u16 in that header - borked.

Ok, so the intention was to avoid padding caused by the alignment
of sockaddr_storage rather than around the '__u16 spp_flags'.

I'd have to look up what (packed, aligned(4)) actually means.
It could force the structure to be fully packed (no holes)
but always have an overall alignment of 4.

It might have been clearer to put an 'aligned(4)' attribute
on the spp_address field itself.
Or even wonder whether sockaddr_storage should actually
have 8 byte alignment.

If it has 16 byte alignment then you cannot cast an IPv4
socket buffer address (which will be at most 4 byte aligned)
to sockaddr_storage and expect the compiler not to generate
code that will crash and burn on sparc64.

ISTR that the NetBSD view was that 'sockaddr_storage' should
never actually be instantiated - it only existed as a typed
pointer.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

