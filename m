Return-Path: <netdev+bounces-5266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD377107BA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B3721C20BEB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0B1848A;
	Thu, 25 May 2023 08:39:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0A81FCC
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:39:46 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78DC83
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:39:32 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-233-lkoNdhwVO3-FQaAUUOP7kw-1; Thu, 25 May 2023 09:33:15 +0100
X-MC-Unique: lkoNdhwVO3-FQaAUUOP7kw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 25 May
 2023 09:32:49 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 25 May 2023 09:32:49 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	"Kurt Kanzenbach" <kurt.kanzenbach@linutronix.de>, Paolo Abeni
	<pabeni@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Thread-Topic: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Thread-Index: AQHZjjDY8wyeNtiJikCklGrvIHrrc69qpn+Q
Date: Thu, 25 May 2023 08:32:49 +0000
Message-ID: <269e5fec0f0f4020a50ea23e535db63e@AcuMS.aculab.com>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
 <20230524111259.1323415-2-bigeasy@linutronix.de>
In-Reply-To: <20230524111259.1323415-2-bigeasy@linutronix.de>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Sebastian Andrzej Siewior
> Sent: 24 May 2023 12:13
>=20
> I've been looking into threaded NAPI. One awkward thing to do is
> to figure out the thread names, pids in order to adjust the thread
> priorities and SMP affinity.
> On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
> the threaded interrupt which means a dedicate CPU affinity for the
> thread and a higher task priority to be favoured over other tasks on the
> CPU. Otherwise the NAPI thread can be preempted by other threads leading
> to delays in packet delivery.

Dropped packets....

> Having to run ps/ grep is awkward to get the PID right. It is not easy
> to match the interrupt since there is no obvious relation between the
> IRQ and the NAPI thread.
> NAPI threads are enabled often to mitigate the problems caused by a
> "pending" ksoftirqd (which has been mitigated recently by doing softiqrs
> regardless of ksoftirqd status). There is still the part that the NAPI
> thread does not use softnet_data::poll_list.

I had to enable both threaded NAPI and RFS (splitting IP processing
to multiple threads) in order to avoid dropping ethernet packets.

To make it all work the NAPI threads processing the receive ring
had to be running under the RT scheduler.
None of the other NAPI threads need to be RT - and, indeed, it
is likely to be detrimental to run them under the RT scheduler.
(You pretty much need to limit the total number of RT threads
to the number of cpu cores so that the scheduler effectively
assigns a cpu to each RT thread.)
Trying to find the correct thread pids was definitely non-trivial.
Especially if you are trying to set it all up for an unknown system.
(As soon as you run ps | grep you are open to arbitrary process names.)

One of the problems with using softints for network receive is
that they suddenly drop from 'higher priority than any RT thread'
to 'a normal priority thread that might have its priority reduced'.
The latter is pretty useless for emptying network receive rings.

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


