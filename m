Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519333F9AAB
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245257AbhH0OMi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Aug 2021 10:12:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:36940 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236500AbhH0OMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 10:12:37 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-72-vzzB4TQBP02qr8fh2JfgRg-1; Fri, 27 Aug 2021 15:11:46 +0100
X-MC-Unique: vzzB4TQBP02qr8fh2JfgRg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 15:11:44 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 27 Aug 2021 15:11:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: IP routing sending local packet to gateway.
Thread-Topic: IP routing sending local packet to gateway.
Thread-Index: AdebRgbMhfPTX4NbSQqr56kVCuK30g==
Date:   Fri, 27 Aug 2021 14:11:44 +0000
Message-ID: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
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

I've an odd IP routing issue.
A packet that should be sent on the local subnet (to an ARPed address)
is being send to the default gateway instead.

What seems to happen is:
A TCP connection is opened between A and B.
The only traffic to B is application level keepalives on the connection.
This state is completely stable.

A then makes another connection to B.
B sends the SYN-ACK packet to the default gateway G.
G ARP's B and sends an ICMP host redirect packet to B.

G doesn't seem to forward the packet to A.
B also ignores the icmp redirect.

Now B is sending all traffic with A's IP address to G's MAC address.
So all the connections retry and then timeout.

In this state arping will work while (icmp) ping fails!
Although one of the ping requests does 'fix' it.
Possibly when A actually ARPs B - but I'm not sure.

A is ubuntu 20.0 (5.4.0-81) under vmware - but probably not relevant.
G is likely to be Linux with IP forwarding enabled.

B is an x86-64 kernel I've built from the 5.10.36 LTS sources.
Userspace buildroot/busybox (I need to add ftrace).

Running netstat -rn on B gives the expected 2 routes.
arp -an always seems to show a MAC address for A's IP.

Before I start digging through the code has anyone any ideas?
I don't remember seeing anything going through the mailing lists.

My 'gut feel' is that it has something to do with the arp table
entry timing out (10 minutes??).
The existing TCP connection has a reference to the ARP entry and
is probably using it even though it might be stale.
But the SYN-ACK transmit is trying to locate the entry so may
well have a different error action.

I've not seen any arp packets while the application keepalives
are going on - but those messages are every 5 seconds.
It might be that the arp request on the 10 minute timer
isn't actually being sent (or responded to) and the 'arp failed'
state is getting set so that the later request decides the
'local route' is broken and so uses the 'default route' instead.

B does have two interfaces setup as a 'bond' but only one IP
address on the single virtual interface.
That shouldn't be relevant since it looks like IP routing
rather than anything lower down.

I've not tried any other kernel versions.
I do need to start using the latest 5.10 one soon.
(Build is set to use kernels from kernel.org rather than git.)

Any ideas/suggestions?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

