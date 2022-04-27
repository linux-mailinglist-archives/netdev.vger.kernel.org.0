Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3D51133E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 10:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359278AbiD0IKo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Apr 2022 04:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349302AbiD0IKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 04:10:43 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59DFF51E71
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 01:07:33 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-261-c1VjfSuEMBeiHVaCN1aObw-1; Wed, 27 Apr 2022 09:07:30 +0100
X-MC-Unique: c1VjfSuEMBeiHVaCN1aObw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Wed, 27 Apr 2022 09:07:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Wed, 27 Apr 2022 09:07:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        "Yossi Gilad" <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 6/7] tcp: increase source port perturb table to 2^16
Thread-Topic: [PATCH net 6/7] tcp: increase source port perturb table to 2^16
Thread-Index: AQHYWgPN4CV2FTUQB025UCKyP5Su7q0DZwmg
Date:   Wed, 27 Apr 2022 08:07:29 +0000
Message-ID: <7372f788762140d496c157813b0173e5@AcuMS.aculab.com>
References: <20220427065233.2075-1-w@1wt.eu> <20220427065233.2075-7-w@1wt.eu>
In-Reply-To: <20220427065233.2075-7-w@1wt.eu>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau
> Sent: 27 April 2022 07:53
> 
> Moshe Kol, Amit Klein, and Yossi Gilad reported being able to accurately
> identify a client by forcing it to emit only 40 times more connections
> than there are entries in the table_perturb[] table. The previous two
> improvements consisting in resalting the secret every 10s and adding
> randomness to each port selection only slightly improved the situation,
> and the current value of 2^8 was too small as it's not very difficult
> to make a client emit 10k connections in less than 10 seconds.
> 
> Thus we're increasing the perturb table from 2^8 to 2^16 so that the the
> same precision now requires 2.6M connections, which is more difficult in
> this time frame and harder to hide as a background activity. The impact
> is that the table now uses 256 kB instead of 1 kB, which could mostly
> affect devices making frequent outgoing connections. However such
> components usually target a small set of destinations (load balancers,
> database clients, perf assessment tools), and in practice only a few
> entries will be visited, like before.

Increasing the table size has a bigger impact on anyone trying
to get the kernel to run in a limited memory footprint.

All these large tables (often hash tables) soon add up.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

