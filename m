Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E47177CC3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgCCRGE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Mar 2020 12:06:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:25575 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728059AbgCCRGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:06:04 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-17-G4aWCeFTOteZM3bhTid1zQ-1; Tue, 03 Mar 2020 17:05:59 +0000
X-MC-Unique: G4aWCeFTOteZM3bhTid1zQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 3 Mar 2020 17:05:59 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 3 Mar 2020 17:05:59 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     Network Development <netdev@vger.kernel.org>
CC:     "'bruce.w.allan@intel.com'" <bruce.w.allan@intel.com>,
        "'jeffrey.e.pieper@intel.com'" <jeffrey.e.pieper@intel.com>,
        "'jeffrey.t.kirsher@intel.com'" <jeffrey.t.kirsher@intel.com>
Subject: [PATCH net 0/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Topic: [PATCH net 0/1] e1000e: Stop tx/rx setup spinning for upwards of
 300us.
Thread-Index: AdXxfUgFmk/Tgr0tRv2xa6d4kBDK/g==
Date:   Tue, 3 Mar 2020 17:05:59 +0000
Message-ID: <9e23756531794a5e8b3d7aa6e0a6e8b6@AcuMS.aculab.com>
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

commit bdc125f73f3c810754e858b942d54faf4ba6bffe

> Author: Bruce Allan <bruce.w.allan@intel.com>
> Date:   Tue Mar 20 03:47:52 2012 +0000
>
>     e1000e: 82579 potential system hang on stress when ME enabled
>
>     Previously, a workaround was added to address a hardware bug in the
>     PCIm2PCI arbiter where a write by the driver of the Transmit/Receive
>     Descriptor Tail register could happen concurrently with a write of any
>     MAC CSR register by the Manageability Engine (ME) which could cause the
>     Tail register to have an incorrect value.  The arbiter is supposed to
>     prevent the concurrent writes but there is a bug that can cause the Host
>     (driver) access to be acknowledged later than it should.
>     After further investigation, it was discovered that a driver write access
>     of any MAC CSR register after being idle for some time can be lost when
>     ME is accessing a MAC CSR register.  When this happens, no further target
>     access is claimed by the MAC which could hang the system.
>     The workaround to check bit 24 in the FWSM register (set only when ME is
>     accessing a MAC CSR register) and delay for a limited amount of time until
>     it is cleared is now done for all driver writes of MAC CSR registers on
>     82579 with ME enabled.  In the rare case when the driver is writing the
>     Tail register and ME is accessing any MAC CSR register for a duration
>     longer than the maximum delay, write the register and verify it has the
>     correct value before continuing, otherwise reset the device.
>
>     This patch also moves some pre-existing macros from the hardware-specific
>     header file to the more appropriate generic driver header file.
>
>     Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
>     Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

added some excessive spinning delays to the e1000e driver code.
Loosely the changed code does:
        while (readl(...) & E1000_ICH_FWSM_PCIM2PCI)
                udelay(50);
        writel(...);
when updating a lot of hardware registers including:
- The transmit ring tail index on every transmit.
- The receive ring tail index when adding rx buffers.
- The interrupt mask at the end of the netdev 'poll' callback.
Even with udelay(1) it typically takes 200us for the bit to clear.
The longest I've seen is just over 300us.

The situation for the transmit ring is even worse.
If multiple processes are sending frames concurrently (on different sockets)
then one of the processes can loop sending all the packets.
This can mean there are multple 200us spins in one process.
(netdev_xmit_more() doesn't help much - it is only set in the inner loop).

The whole thing can add 1ms (or more) to the time spent sending a message.

Rather than spin until E1000_ICH_FWSM_PCIM2PCI is clear, this patch
remembers that a ring tail pointer write is needed and writes it
at a later point, either:
- On the next update to the relevant ring.
- In the netdev 'poll' callback (typicall packet receive)
- On the next clock tick.

This removes most of the long delays, however there is still a potential delay
when interrupts are enabled at the end of the 'poll' callback.
A big problem with the existing code (and my patch) is that E1000_ICH_FWSM_PCIM2PCI
could be set between the test and the writel().
This could even happen if interrupts are disabled - which they are not.
I'm fairly sure the NETRX softint code can run in the middle of the
transmit setup.

I actually wonder if this is anything like the correct fix to the original
problem.

The commit message says:
>     After further investigation, it was discovered that a driver write access
>     of any MAC CSR register after being idle for some time can be lost when
>     ME is accessing a MAC CSR register.

If the write is 'lost' (rather than corrupted) then it would be much better
to do a readback test and rewrite if incorrect.
If writes are only 'sometimes lost' this would almost never trigger and
never take very long to recover from.

But I'm not at all sure what this means:
>     When this happens, no further target access is claimed by the MAC which
>     could hang the system.
If it just means that they found that interrupts weren't always re-enabled
causing both receive and transmit to stop.
Not what I'd call 'hang the system'.

Now a readback of the ring tail pointers isn't an issue.
But the interrupt mask is self-clearing so may get bits cleared between
the write and any readback.
The extra interrupts may not matter.
OTOH if there is an extra bit (an interrupt that can't happen) that can be
inverted each write it could be used to detect whether the write was lost.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

