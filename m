Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA03911512C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 14:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfLFNjm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Dec 2019 08:39:42 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48882 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbfLFNjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 08:39:39 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-16-t457RrF7MGGa9WB2Ppc0Xw-1; Fri, 06 Dec 2019 13:39:35 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 6 Dec 2019 13:39:35 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 6 Dec 2019 13:39:35 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Topic: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Index: AdWsNynavvs+VRwOQ6mSStk+IzVA6A==
Date:   Fri, 6 Dec 2019 13:39:35 +0000
Message-ID: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: t457RrF7MGGa9WB2Ppc0Xw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some tests I've done seem to show that recvmsg() is much slower that recvfrom()
even though most of what they do is the same.
One thought is that the difference is all the extra copy_from_user() needed by
recvmsg. CONFIG_HARDENED_USERCOPY can add a significant cost.

I've built rebuilt my 5.4-rc7 kernel with all the copy_to/from_user() in net/socket.c
replaced with the '_' prefixed versions (that don't call check_object()).
And also changed rw_copy_check_uvector() in fs/read_write.c.

Schedviz then showed the time spent by the application thread that calls
recvmsg() (about) 225 times being reduced from 0.9ms to 0.75ms.

I've now instrumented the actual recv calls. It show some differences,
but now enough to explain the 20% difference above.
(This is all made more difficult because my Ivy Bridge i7-3770 refuses
to run at a fixed frequency.)

Anyway using PERF_COUNT_HW_CPU_CYCLES I've got the following
histograms for the number of cycles in each recv call.
There are about the same number (2.8M) in each column over
an elapsed time of 20 seconds.
There are 450 active UDP sockets, each receives 1 message every 20ms.
Every 10ms a RT thread that is pinned to a cpu reads all the pending messages.
This is a 4 core hyperthreading (8 cpu) system.
During these tests 5 other threads are also busy.
There are no sends (on those sockets).

         |       recvfrom      |       recvmsg
 cycles  |   unhard  |    hard |   unhard  |    hard
-----------------------------------------------------
   1472:         29          1          0          0
   1600:       8980       4887          3          0
   1728:     112540     159518       5393       2895
   1856:     174555     270148     119054     111230
   1984:     126007     168383     152310     195288
   2112:      80249      87045     118941     168801
   2240:      61570      54790      81847     110561
   2368:      95088      61796      57496      71732
   2496:     193633     155870      54020      54801
   2624:     274997     284921     102465      74626
   2752:     276661     295715     160492     119498
   2880:     248751     264174     206327     186028
   3008:     207532     213067     230704     229232
   3136:     167976     164804     226493     238555
   3264:     133708     124857     202639     220574
   3392:     107859      95696     172949     189475
   3520:      88599      75943     141056     153524
   3648:      74290      61586     115873     120994
   3776:      62253      50891      96061      95040
   3904:      52213      42482      81113      76577
   4032:      42920      34632      69077      63131
   4160:      35472      28327      60074      53631
   4288:      28787      22603      51345      46620
   4416:      24072      18496      44006      40325
   4544:      20107      14886      37185      34516
   4672:      16759      12206      31408      29031
   4800:      14195       9991      26843      24396
   4928:      12356       8167      22775      20165
   5056:      10387       6931      19404      16591
   5184:       9284       5916      16817      13743
   5312:       7994       5116      14737      11452
   5440:       7152       4495      12592       9607
   5568:       6300       3969      11117       8592
   5696:       5445       3421       9988       7237
   5824:       4683       2829       8839       6368
   5952:       3959       2643       7652       5652
   6080:       3454       2377       6442       4814
   6208:       3041       2219       5735       4170
   6336:       2840       2060       5059       3615
   6464:       2428       1975       4433       3201
   6592:       2109       1794       4078       2823
   6720:       1871       1382       3549       2558
   6848:       1706       1262       3110       2328
   6976:       1567       1001       2733       1991
   7104:       1436        873       2436       1819
   7232:       1417        860       2102       1652
   7360:       1414        741       1823       1429
   7488:       1372        814       1663       1239
   7616:       1201        896       1430       1152
   7744:       1275       1008       1364       1049
   7872:       1382       1120       1367        925
   8000:       1316       1282       1253        815
   8128:       1264       1266       1313        792
  8256+:      19252      19450      34703      30228
----------------------------------------------------
  Total:    2847707    2863582    2853688    2877088

This does show a few interesting things:
1) The 'hardened' kernel is slower, especially for recvmsg.
2) The difference for recvfrom isn't enough for the 20% reduction I saw.
3) There are two peaks at the top a 'not insubstantial' number are a lot
   faster than the main peak.
4) There is second peak way down at 8000 cycles.
   This is repeatable.

Any idea what is actually going on??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

