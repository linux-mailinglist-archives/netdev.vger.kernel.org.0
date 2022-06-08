Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891DB542DA3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbiFHKaV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jun 2022 06:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiFHK3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:29:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43222290B36
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 03:18:26 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-272-XX68EoR1PGKPNiM1bBGKiQ-1; Wed, 08 Jun 2022 11:18:23 +0100
X-MC-Unique: XX68EoR1PGKPNiM1bBGKiQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 8 Jun 2022 11:18:22 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 8 Jun 2022 11:18:22 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH net-next 1/9] vlan: adopt u64_stats_t
Thread-Topic: [PATCH net-next 1/9] vlan: adopt u64_stats_t
Thread-Index: AQHYes4gtiuM5BJQbEG+qrM/apt4lK1FSwAw
Date:   Wed, 8 Jun 2022 10:18:22 +0000
Message-ID: <cea2c2c39d0e4f27b2e75cdbc8fce09d@AcuMS.aculab.com>
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
 <20220607233614.1133902-2-eric.dumazet@gmail.com>
In-Reply-To: <20220607233614.1133902-2-eric.dumazet@gmail.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet
> Sent: 08 June 2022 00:36
> 
> As explained in commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
> we should use u64_stats_t and related accessors to avoid load/store tearing.
> 
> Add READ_ONCE() when reading rx_errors & tx_dropped.

Isn't this all getting entirely stupid?

AFAICT nearly every 'memory' access in the kernel is going
to get wrapped in READ/WRITE_ONCE() to avoid something
that really never actually happens?

It might be better to just mark everything 'volatile'.
Although perhaps that ought to be a compiler option.

OTOH I've seen gcc generate extra instructions for 'volatile'
accesses - to the point where I used 'barrier()' to optimise
code.
I think the volatile casts in READ_ONCE() can generate worse
code than volatile variables.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

