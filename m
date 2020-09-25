Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60C278335
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgIYIug convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Sep 2020 04:50:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:39480 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbgIYIuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 04:50:35 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-267-SlDLLyGgPCWGYT3qfkzgEw-1; Fri, 25 Sep 2020 09:50:31 +0100
X-MC-Unique: SlDLLyGgPCWGYT3qfkzgEw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 25 Sep 2020 09:50:30 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 25 Sep 2020 09:50:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kai-Heng Feng' <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] e1000e: Increase iteration on polling MDIC ready bit
Thread-Topic: [PATCH v2] e1000e: Increase iteration on polling MDIC ready bit
Thread-Index: AQHWkox4cI4WCPtPmUq6IlIoeEXohal5Cn3A
Date:   Fri, 25 Sep 2020 08:50:30 +0000
Message-ID: <2f48175dce974ea689bfd26b9fc2245a@AcuMS.aculab.com>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <20200924150958.18016-1-kai.heng.feng@canonical.com>
 <20200924155355.GC3821492@lunn.ch>
 <8A08B3A7-8368-48EC-A2DD-B5D5F3EA94C5@canonical.com>
In-Reply-To: <8A08B3A7-8368-48EC-A2DD-B5D5F3EA94C5@canonical.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng
> Sent: 24 September 2020 17:04
...
> > I also don't fully understand the fix. You are now looping up to 6400
> > times, each with a delay of 50uS. So that is around 12800 times more
> > than it actually needs to transfer the 64 bits! I've no idea how this
> > hardware works, but my guess would be, something is wrong with the
> > clock setup?
> 
> It's probably caused by Intel ME. This is not something new, you can find many polling codes in e1000e
> driver are for ME, especially after S3 resume.
> 
> Unless Intel is willing to open up ME, being patient and wait for a longer while is the best approach
> we got.

There is some really broken code in the e1000e driver that affect my
Ivy bridge platform were it is trying to avoid hardware bugs in
the ME interface.

It seems that before EVERY write to a MAC register it must check
that the ME isn't using the interface - and spin until it isn't.
This causes massive delays in the TX path because it includes
the write that tells the MAC engine about a new packet.

The code is completely broken though.
Interrupts and processes switches can happen between the
test for the ME being idle and the actual write.

AFAICT the only reliable way to get ethernet access on such
systems is to use a different ethernet interface.

Also, from what I remember, the broken workaround is missing
from some of the setup code paths.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

