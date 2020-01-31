Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4855014EE1E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAaOAc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Jan 2020 09:00:32 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:40533 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728735AbgAaOAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:00:31 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-242-JHDjgXV-PJqc_fZ2W4bcWg-1; Fri, 31 Jan 2020 14:00:28 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 31 Jan 2020 14:00:27 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 31 Jan 2020 14:00:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'sjpark@amazon.com'" <sjpark@amazon.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sj38.park@gmail.com" <sj38.park@gmail.com>,
        "aams@amazon.com" <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: RE: [PATCH 0/3] Fix reconnection latency caused by FIN/ACK handling
 race
Thread-Topic: [PATCH 0/3] Fix reconnection latency caused by FIN/ACK handling
 race
Thread-Index: AQHV2DFvc3pd6ARlHUK3D8H5esqW/agEyn3w
Date:   Fri, 31 Jan 2020 14:00:27 +0000
Message-ID: <dc37fb0dad3c4a5f9fd88eea89d81908@AcuMS.aculab.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
In-Reply-To: <20200131122421.23286-1-sjpark@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: JHDjgXV-PJqc_fZ2W4bcWg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sjpark@amazon.com
> Sent: 31 January 2020 12:24
...
> The acks in lines 6 and 8 are the acks.  If the line 8 packet is
> processed before the line 6 packet, it will be just ignored as it is not
> a expected packet, and the later process of the line 6 packet will
> change the status of Process A to FIN_WAIT_2, but as it has already
> handled line 8 packet, it will not go to TIME_WAIT and thus will not
> send the line 10 packet to Process B.  Thus, Process B will left in
> CLOSE_WAIT status, as below.
> 
> 	 00 (Process A)				(Process B)
> 	 01 ESTABLISHED				ESTABLISHED
> 	 02 close()
> 	 03 FIN_WAIT_1
> 	 04 		---FIN-->
> 	 05 					CLOSE_WAIT
> 	 06 				(<--ACK---)
> 	 07	  			(<--FIN/ACK---)
> 	 08 				(fired in right order)
> 	 09 		<--FIN/ACK---
> 	 10 		<--ACK---
> 	 11 		(processed in reverse order)
> 	 12 FIN_WAIT_2

Why doesn't A treat the FIN/ACK (09) as valid (as if
the ACK had got lost) and then ignore the ACK (10) because
it refers to a closed socket?

I presume that B sends two ACKs (06 and 07) because it can
sit in an intermediate state and the first ACK stops the FIN
being resent?

I've implemented lots of protocols in my time, but not TCP.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

