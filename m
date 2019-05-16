Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CB22026A
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfEPJUl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 May 2019 05:20:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:43595 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726336AbfEPJUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 05:20:41 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-213-AVS39ZqYMG-GN_QLUh8Hbw-1; Thu, 16 May 2019 10:20:37 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu,
 16 May 2019 10:20:36 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 16 May 2019 10:20:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "neilb@suse.com" <neilb@suse.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: RE: [PATCH 2/2] rhashtable: Fix cmpxchg RCU warnings
Thread-Topic: [PATCH 2/2] rhashtable: Fix cmpxchg RCU warnings
Thread-Index: AQHVC7fF5GfDDYzT5keRpnIN6lnpPKZtd9vQ
Date:   Thu, 16 May 2019 09:20:36 +0000
Message-ID: <e79357ea8fde45b281be9a8196b806f8@AcuMS.aculab.com>
References: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
 <E1hRAg8-0004Fy-0O@gondobar>
In-Reply-To: <E1hRAg8-0004Fy-0O@gondobar>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: AVS39ZqYMG-GN_QLUh8Hbw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu
> Sent: 16 May 2019 08:20
> As cmpxchg is a non-RCU mechanism it will cause sparse warnings
> when we use it for RCU.  This patch adds explicit casts to silence
> those warnings.  This should probably be moved to RCU itself in
> future.
> 
...
> -	if (cmpxchg(prev, NULL, ntbl) == NULL)
> +	if (cmpxchg((union nested_table **)prev, NULL, ntbl) == NULL)

I presume these casts remove an 'rcu' marker on the variable.
Is there a way of marking such casts as 'for sparse only' so
that the compiler does proper type checking.
(Clearly this isn't that relevant here as the cast could be (void **).)

Hmmm something should be checking that the type of the argument
to cmpxchg is 'pointer to "something the size of a pointer"'
Adding any kind of cast subverts that test.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

