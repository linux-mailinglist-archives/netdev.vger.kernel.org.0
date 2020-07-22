Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE9229499
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 11:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbgGVJM7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jul 2020 05:12:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:31059 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728911AbgGVJMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 05:12:47 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-133-iHrS3EymP6-QY3_m0aDbLA-1; Wed, 22 Jul 2020 10:12:43 +0100
X-MC-Unique: iHrS3EymP6-QY3_m0aDbLA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 22 Jul 2020 10:12:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 22 Jul 2020 10:12:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>,
        Rakesh Pillai <pillair@codeaurora.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>
Subject: RE: [RFC 0/7] Add support to process rx packets in thread
Thread-Topic: [RFC 0/7] Add support to process rx packets in thread
Thread-Index: AQHWX4Pwi/SIJmxUNEW6qPlR/TNR0KkTSebw
Date:   Wed, 22 Jul 2020 09:12:42 +0000
Message-ID: <9fb3d3bd8d944a649cbe828fddca1bc1@AcuMS.aculab.com>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <20200721172514.GT1339445@lunn.ch>
In-Reply-To: <20200721172514.GT1339445@lunn.ch>
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

From: Andrew Lunn
> Sent: 21 July 2020 18:25
> 
> On Tue, Jul 21, 2020 at 10:44:19PM +0530, Rakesh Pillai wrote:
> > NAPI gets scheduled on the CPU core which got the
> > interrupt. The linux scheduler cannot move it to a
> > different core, even if the CPU on which NAPI is running
> > is heavily loaded. This can lead to degraded wifi
> > performance when running traffic at peak data rates.
> >
> > A thread on the other hand can be moved to different
> > CPU cores, if the one on which its running is heavily
> > loaded. During high incoming data traffic, this gives
> > better performance, since the thread can be moved to a
> > less loaded or sometimes even a more powerful CPU core
> > to account for the required CPU performance in order
> > to process the incoming packets.
> >
> > This patch series adds the support to use a high priority
> > thread to process the incoming packets, as opposed to
> > everything being done in NAPI context.
> 
> I don't see why this problem is limited to the ath10k driver. I expect
> it applies to all drivers using NAPI. So shouldn't you be solving this
> in the NAPI core? Allow a driver to request the NAPI core uses a
> thread?

It's not just NAPI the problem is with the softint processing.
I suspect a lot of systems would work better if it ran as
a (highish priority) kernel thread.

I've had to remove the main locks from a multi-threaded application
and replace them with atomic counters.
Consider what happens when the threads remove items from a shared
work list.
The code looks like:
	mutex_enter();
	remove_item_from_list();
	mutex_exit().
The mutex is only held for a few instructions, so while you'd expect
the cache line to be 'hot' you wouldn't get real contention.
However the following scenarios happen:
1) An ethernet interrupt happens while the mutex is held.
   This stops the other threads until all the softint processing
   has finished.
2) An ethernet interrupt (and softint) runs on a thread that is
   waiting for the mutex.
   (Or on the cpu that the thread's processor affinity ties it to.)
   In this case the 'fair' (ticket) mutex code won't let any other
   thread acquire the mutex.
   So again everything stops until the softints all complete.

The second one is also a problem when trying to wake up all
the threads (eg after adding a lot of items to the list).
The ticket locks force them to wake in order, but
sometimes the 'thundering herd' would work better.

IIRC this is actually worse for processes running under the RT
scheduler (without CONFIG_PREEMPT) because the they are almost
always scheduled on the same cpu they ran on last.
If it is busy, but cannot be pre-empted, they are not moved
to an idle cpu.
   
To confound things there is a very broken workaround for broken
hardware in the driver for the e1000 interface on (at least)
Ivy Bridge cpu that can cause the driver to spin for a very
long time (IIRC milliseconds) whenever it has to write to a
MAC register (ie on every transmit setup).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

