Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517B052BF0E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbiERQIz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 May 2022 12:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiERQIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:08:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9FAF1D5027
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:08:51 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-135-D0rUCKQzNS6AyNTb5khcbA-1; Wed, 18 May 2022 17:08:48 +0100
X-MC-Unique: D0rUCKQzNS6AyNTb5khcbA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 18 May 2022 17:08:47 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 18 May 2022 17:08:47 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "'mchan@broadcom.com'" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKw==
Date:   Wed, 18 May 2022 16:08:47 +0000
Message-ID: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
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

I'm trying to see why the tg3 driver is dropping a lot of
receive packets.

(This driver is making my head hurt...)

I think that the rx_packets count (sum of rx_[umb]cast_packets)
is all the packets, but a smaller number are actually processed
by the tg3_rx()
But none of the error counts get increased.

It is almost as if it has lost almost all the receive buffers.

If I read /sys/class/net/em2/statistics/rx_packets every second
delaying with:
  syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
about every 43 seconds I get a zero increment.
This really doesn't help!
I've put a count into tg3_rx() that seems to match what IP/UDP
and the application see.

The traffic flow is pretty horrid (but could be worse).
There are 8000 small UDP packets every 20ms.
These are reasonably spread through the 20ms (not back to back).
All the destination ports are different (8000 receiving sockets).
(The receiving application handles this fine (now).)
The packets come from two different systems.

Firstly RSS doesn't seem to work very well.
With the current driver I think everything hits 2 rings.
With the 3.10 RHEL driver it all ends up in one.

Anyway after a hint from Eric I enabled RPS.
This offloads the IP and UDP processing enough to stop
any of the cpu (only 40 of them) from reporting even 50% busy.

I've also increased the rx ring size to 2047.
Changing the coalescing parameters seems to have no effect.

I think there should be 2047 receive buffers.
So 4 interrupts every 20ms or 200/sec might be enough
to receive all the frames.
The actual interrupt rate (deltas on /proc/interrupts)
is actual over 80000/sec.
So it doesn't look as though the driver is ever processing
many packets/interrupt.
If the driver were getting behind I'd expect a smaller number
of interrupts.

This would be consistent with there only being (say) 8 active
receive buffers.

The device in question identifies as:

tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM95720) rev 5720000] (PCI Express) MAC address xx
tg3 0000:02:00.0 eth0: attached PHY is 5720C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
tg3 0000:02:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]
tg3 0000:02:00.0 eth0: dma_rwctrl[00000001] dma_mask[64-bit]

Any idea where to look?

Or should I just use different ethernet hardware!
(Although the interrupt coalescing parameters for igb are
also completely broken for this traffic flow.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

