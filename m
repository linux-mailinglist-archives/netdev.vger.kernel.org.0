Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956763B0FEE
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhFVWPf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Jun 2021 18:15:35 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:48519 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhFVWPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:15:34 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-231-IXZpIp62M8ys0FTGHGmJgA-1; Tue, 22 Jun 2021 23:13:14 +0100
X-MC-Unique: IXZpIp62M8ys0FTGHGmJgA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Jun
 2021 23:13:14 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Tue, 22 Jun 2021 23:13:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Subject: RE: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
Thread-Topic: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
Thread-Index: AQHXZ5Gk1m/0BhrSYEC4nBP7A0Tb5KsglL6Q
Date:   Tue, 22 Jun 2021 22:13:14 +0000
Message-ID: <cfaa01992d064520b3a9138983e8ec41@AcuMS.aculab.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
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

From: Xin Long
> Sent: 22 June 2021 19:05
> 
> Overview(From RFC8899):
> 
>   In contrast to PMTUD, Packetization Layer Path MTU Discovery
>   (PLPMTUD) [RFC4821] introduces a method that does not rely upon
>   reception and validation of PTB messages.  It is therefore more
>   robust than Classical PMTUD.  This has become the recommended
>   approach for implementing discovery of the PMTU [BCP145].
> 
>   It uses a general strategy in which the PL sends probe packets to
>   search for the largest size of unfragmented datagram that can be sent
>   over a network path.  Probe packets are sent to explore using a
>   larger packet size.  If a probe packet is successfully delivered (as
>   determined by the PL), then the PLPMTU is raised to the size of the
>   successful probe.  If a black hole is detected (e.g., where packets
>   of size PLPMTU are consistently not received), the method reduces the
>   PLPMTU.

This seems to take a long time (probably well over a minute)
to determine the mtu.

What is used for the actual mtu while this is in progress?

Does packet loss and packet retransmission cause the mtu
to be reduced as well?

I can imagine that there is an expectation (from the application)
that the mtu is that of an ethernet link - perhaps less a PPPoE
header.
Starting with an mtu of 1200 will break this assumption and may
have odd side effects.
For TCP/UDP the ICMP segmentation required error is immediate
and gets used for the retransmissions.
This code seems to be looking at separate timeouts - so a lot of
packets could get discarded and application timers expire before
if determines the correct mtu.

Maybe I missed something about this only being done on inactive
paths?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

