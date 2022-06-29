Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB1155FB6C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiF2JJm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jun 2022 05:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiF2JJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:09:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D044B3F
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:09:39 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-89-0bow6AXVPaapSvqyvZPCXg-1; Wed, 29 Jun 2022 10:09:36 +0100
X-MC-Unique: 0bow6AXVPaapSvqyvZPCXg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 29 Jun 2022 10:09:35 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 29 Jun 2022 10:09:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Lobakin' <alexandr.lobakin@intel.com>,
        Albert Huang <huangjie.albert@bytedance.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Antoine Tenart" <atenart@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        "Frederic Weisbecker" <frederic@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net : rps : supoort a single flow to use rps
Thread-Topic: [PATCH] net : rps : supoort a single flow to use rps
Thread-Index: AQHYiw+BtF4BFejA6Eeu6pKM0/Ynka1mGL6A
Date:   Wed, 29 Jun 2022 09:09:35 +0000
Message-ID: <2ed297c680f24879aba6f15df7630b96@AcuMS.aculab.com>
References: <20220628140044.65068-1-huangjie.albert@bytedance.com>
 <20220628152956.1407334-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220628152956.1407334-1-alexandr.lobakin@intel.com>
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

....
> I'd suggest to use some flags bitfield instead, so it would be way
> more scalable and at the same time have the pre-determined size. Ar
> per several LKML discussions, `bool` may have different size and
> logics depending on architecture and compiler, so when using it not
> on the stack inside a function, but in a structure, it might be not
> easy then to track cacheline layout etc.
> So, maybe
> 
> 	unsigned long rps_flags;
>  #define RPS_SINGLE_FLOW_ENABLE BIT(0)
> 
> or even
> 
> 	DECLARE_BITMAP(rps_flags);
>  #define RPS_SINGLE_FLOW_ENABLE 0

I don't think BITMAPs are a good idea unless you really
need a lot of bits and (probably) locked accesses.

You can use C bitfields - the compiler doesn't (usually)
make too much of a 'pigs breakfast' of them unless you
needs to set/test multiple ones at the same time.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

