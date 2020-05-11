Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378981CE76F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgEKV2W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 May 2020 17:28:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:30090 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbgEKV2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:28:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-28--i5qIbC7M1CyJBNmWST7JA-1; Mon, 11 May 2020 22:28:18 +0100
X-MC-Unique: -i5qIbC7M1CyJBNmWST7JA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 11 May 2020 22:28:18 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 11 May 2020 22:28:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
Thread-Topic: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
Thread-Index: AdYm44GMpCoVm8MoQ+GQh1uj0J52IAA6cwwAAALP/JA=
Date:   Mon, 11 May 2020 21:28:18 +0000
Message-ID: <7e8f6c9831244d2bb7c39f9aa4204e90@AcuMS.aculab.com>
References: <6d52098964b54d848cbfd1957f093bd8@AcuMS.aculab.com>
 <20200511.134938.651986318503897703.davem@davemloft.net>
In-Reply-To: <20200511.134938.651986318503897703.davem@davemloft.net>
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

From: David Miller
> Sent: 11 May 2020 21:50
> To: David Laight <David.Laight@ACULAB.COM>
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when IP_HDRINCL set.
> 
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Sun, 10 May 2020 16:00:41 +0000
> 
> > The final routing for ipv4 packets may be done with the IP address
> > from the message header not that from the address buffer.
> > If the addresses are different FLOWI_FLAG_KNOWN_NH must be set so
> > that a temporary 'struct rtable' entry is created to send the message.
> > However the allocate + free (under RCU) is relatively expensive
> > and can be avoided by a quick check shows the addresses match.
> >
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> The user can change the daddr field in userspace between when you do
> this test and when the iphdr is copied into the sk_buff.
> 
> Also, you are obfuscating what you are doing in the way you have coded
> this check.  You extract 4 bytes from a magic offset (16), which is
> hard to understand.

Ok, that should at least be the structure offset.

> Just explicitly code out the fact that you are accessing the daddr
> field of an ip header.
> 
> But nonetheless you have to solve the "modified in userspace
> meanwhile" problem, as this is a bug we fix often in the kernel so we
> don't want to add new instances.

In this case the "modified in userspace meanwhile" just breaks the
application - it isn't any kind of security issue.

The problem is that you can't read the data into an skb until you
have the offset - which is got by looking up the destination address.
But you need the actual destination (from the packet data) to match
the address buffer if you don't want to create a temporary rtable entry.

I didn't find the commit that make rtable entries shared.
I though the same table was used for routes and arps  - but
it looks like they got separated at some point.

The code could put the address it read back into the skb, but that would
look even worse.

At the moment the performance is horrid when hundreds of the rtable
entries get deleted under rcu all together.
They are also added to a single locked linked list.

I'm running 500 RTP streams which each send one UDP message every 20ms.
It really needs to used the cached rtable entries.
The only sane way to send the data is through a raw socket and to get
the UDP checksum set you have to sort out the both IP addresses.
(A UPD socket would be given rx data - which needs to go elsewhere.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

