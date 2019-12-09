Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48518116FD6
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLIPFQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Dec 2019 10:05:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39178 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfLIPFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:05:16 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-250-xcW0IChpMEyv3Vdq0rFWyg-1; Mon, 09 Dec 2019 15:05:13 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 9 Dec 2019 15:05:12 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 9 Dec 2019 15:05:12 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'network dev' <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Topic: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Index: AdWsNynavvs+VRwOQ6mSStk+IzVA6ACaJgVw
Date:   Mon, 9 Dec 2019 15:05:12 +0000
Message-ID: <0a3ac42bb3044373bb15a9a3da1c2af9@AcuMS.aculab.com>
References: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
In-Reply-To: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: xcW0IChpMEyv3Vdq0rFWyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight
> Sent: 06 December 2019 13:40
> Some tests I've done seem to show that recvmsg() is much slower that recvfrom()
> even though most of what they do is the same.
> One thought is that the difference is all the extra copy_from_user() needed by
> recvmsg. CONFIG_HARDENED_USERCOPY can add a significant cost.
> 
> I've built rebuilt my 5.4-rc7 kernel with all the copy_to/from_user() in net/socket.c
> replaced with the '_' prefixed versions (that don't call check_object()).
> And also changed rw_copy_check_uvector() in fs/read_write.c.
...
> Anyway using PERF_COUNT_HW_CPU_CYCLES I've got the following
> histograms for the number of cycles in each recv call.
> There are about the same number (2.8M) in each column over
> an elapsed time of 20 seconds.
> There are 450 active UDP sockets, each receives 1 message every 20ms.
> Every 10ms a RT thread that is pinned to a cpu reads all the pending messages.
> This is a 4 core hyperthreading (8 cpu) system.
> During these tests 5 other threads are also busy.
> There are no sends (on those sockets).

I've repeated the measurements with HT disabled.
The initial peak in the previous data will be running against an idle cpu.
The second peak when the other cpu is doing work.

I've also expanded the vertical scale.
(My histogram code uses 64 buckets.)

         |       recvfrom      |       recvmsg
 cycles  |   unhard  |    hard |   unhard  |    hard
-----------------------------------------------------
   1504:          1          0          0          0
   1568:        255          3          0          0
   1632:      15266        473         83          0
   1696:     178767      18853       7110          1
   1760:     423080     154636     123239        416
   1824:     441977     410044     401895      23493
   1888:     366640     508236     423648     186572
   1952:     267423     431819     383269     347182
   2016:     183694     305336     288347     384365
   2080:     126643     191582     196172     358854
   2144:      89987     116667     133757     275872
   2208:      65903      73875      92185     197145
   2272:      54161      52637      68537     138436
   2336:      46558      43771      55740      98829
   2400:      42672      40982      50058      76901
   2464:      42855      42297      48429      66309
   2528:      51673      44994      51165      61234
   2592:     113385     107986     117982     125652
   2656:      59586      57875      65416      72992
   2720:      49211      47269      57081      67369
   2784:      34911      31505      41435      51525
   2848:      29386      24238      34025      43631
   2912:      23522      17538      27094      35947
   2976:      20768      14279      23747      30293
   3040:      16973      12210      19851      26209
   3104:      13962      10500      16625      22017
   3168:      11669       9287      13922      18978
   3232:       9519       8003      11773      16307
   3296:       8119       6926       9993      14346
   3360:       6818       5906       8532      12032
   3424:       5867       5002       7241      10499
   3488:       5319       4492       6107       9087
   3552:       4835       3796       5625       7858
   3616:       4544       3530       5270       6840
   3680:       4113       3263       4845       6140
   3744:       3691       2883       4315       5430
   3808:       3325       2467       3798       4651
   3872:       2901       2191       3412       4101
   3936:       2499       1784       3127       3593
   4000:       2273       1594       2636       3163
   4064:       1868       1372       2231       2819
  4128+:      50073      45330      51853      53752

This shows that the hardened usercopy has a significant cost in recvmsg.
All the places I changed contain explicit length checks.

I'm going to see how much of the additional cost of recvmsg is down to
the iov reading code.
A lot of code will be passing exactly one buffer, and the code to process
it is massive.

More odd is the peak at 2592 cycles in all 4 traces.
I'm having difficulty thinking of an 'artefact' that wouldn't add an offset.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

