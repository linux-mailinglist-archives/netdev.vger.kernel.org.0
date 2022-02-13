Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E6A4B3C9B
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbiBMRsF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Feb 2022 12:48:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiBMRsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 12:48:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA8F45A09C
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:47:57 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-186-LeVe8n1APwumlclMeJaqYQ-1; Sun, 13 Feb 2022 17:47:54 +0000
X-MC-Unique: LeVe8n1APwumlclMeJaqYQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Sun, 13 Feb 2022 17:47:52 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Sun, 13 Feb 2022 17:47:52 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Segher Boessenkool' <segher@kernel.crashing.org>
CC:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: Remove branch in csum_shift()
Thread-Topic: [PATCH] net: Remove branch in csum_shift()
Thread-Index: AQHYHyQqmTo4K/pb5UWdDmTfE7rfRayQxWFwgABxD4CAAIxicA==
Date:   Sun, 13 Feb 2022 17:47:52 +0000
Message-ID: <476aa649389345db92f86e9103a848be@AcuMS.aculab.com>
References: <efeeb0b9979b0377cd313311ad29cf0ac060ae4b.1644569106.git.christophe.leroy@csgroup.eu>
 <7f16910a8f63475dae012ef5135f41d1@AcuMS.aculab.com>
 <20220213091619.GY614@gate.crashing.org>
In-Reply-To: <20220213091619.GY614@gate.crashing.org>
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
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Segher Boessenkool 
> Sent: 13 February 2022 09:16
....
> 
> > What happens on x86-64?
> >
> > Trying to do the same in the x86 ipcsum code tended to make the code worse.
> > (Although that test is for an odd length fragment and can just be removed.)
> 
> In an ideal world the compiler could choose the optimal code sequences
> everywhere.  But that won't ever happen, the search space is way too
> big.  So compilers just use heuristics, not exhaustive search like
> superopt does.  There is a middle way of course, something with directed
> searches, and maybe in a few decades systems will be fast enough.  Until
> then we will very often see code that is 10% slower and 30% bigger than
> necessary.  A single insn more than needed isn't so bad :-)

But it can be a lot more than that.

> Making things branch-free is very much worth it here though!

I tried to find out where 'here' is.

I can't get godbolt to generate anything like that object code
for a call to csum_shift().

I can't actually get it to issue a rotate (x86 of ppc).

I think it is only a single instruction because the compiler
has saved 'offset & 1' much earlier instead of doing testing
'offset & 1' just prior to the conditional.
It certainly has a nasty habit of doing that pessimisation.

So while it helps a specific call site it may be much
worse in general.

I also suspect that the addc/addze pair could be removed
by passing the old checksum into csum_partial.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

