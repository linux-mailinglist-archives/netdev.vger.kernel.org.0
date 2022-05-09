Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DB6520305
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbiEIQ7N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 May 2022 12:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiEIQ7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:59:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 380112B24F6
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:55:17 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-20-dLmZaJ8FN6yJy0IVnD9rLQ-1; Mon, 09 May 2022 17:55:14 +0100
X-MC-Unique: dLmZaJ8FN6yJy0IVnD9rLQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 9 May 2022 17:55:13 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 9 May 2022 17:55:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     netdev <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        'Eric Dumazet' <edumazet@google.com>
Subject: High packet rate udp receive
Thread-Topic: High packet rate udp receive
Thread-Index: AdhjwryEcPV95/8RR7qM1N+cs9RjHQ==
Date:   Mon, 9 May 2022 16:55:13 +0000
Message-ID: <06dc7df0afd344fc9aa656896e761d37@AcuMS.aculab.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm testing some high channel count RTP (UDP audio).
When I get much over 250000 receive packets/second the
network receive softint processing seems to overload
one cpu and then packets are silently discarded somewhere.

I (probably) can see all the packets in /sys/class/net/em2/statistics/rx_packets
but the counts from 'netstat -s' are a lot lower.

The packets are destined for a lot of UDP sockets - each gets 50/sec.
These can't be 'connected' because the source address is allowed to change.
For testing the source IP is pretty fixed.
But I've not tried to look for the actual bottleneck.

Are we stuck with one cpu doing all the ethernet, IP and UDP
receive processing?
(and the end of transmit reaping).
Or is there a way to get another cpu to do some of the work?

Since this is UDP things like gro can't help.
We do have to handle very large numbers of packets.

Would a multi-queue ethernet adapter help?
This system has a BCM5720 (tg3 driver) which I don't think is multi-Q.

OTOH I've also had issues with a similar packet rate on an intel
nic that would be multi-q because the interrupt mitigation logic
is completely broken for high packet rates.
Only increasing the ring size to 4096 stopped it dropping packets.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

