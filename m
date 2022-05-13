Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35895260B4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379755AbiEMLI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379752AbiEMLI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:08:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DC94134E3E
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:08:55 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-40-9SbU5vY1PJqweIlksZC4vw-1; Fri, 13 May 2022 12:08:52 +0100
X-MC-Unique: 9SbU5vY1PJqweIlksZC4vw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 13 May 2022 12:08:51 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 13 May 2022 12:08:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
CC:     Marco Elver <elver@google.com>, Liu Jian <liujian56@huawei.com>,
        "Dmitry Vyukov" <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
Thread-Topic: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
Thread-Index: AQHYZloamBVkYEnoB0GrcOa4F+j2Ra0cpszQ
Date:   Fri, 13 May 2022 11:08:51 +0000
Message-ID: <61020a29e421414b8ddf723641b150da@AcuMS.aculab.com>
References: <20220512103322.380405-1-liujian56@huawei.com>
 <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
 <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
 <CANn89iKJ+9=ug79V_bd8LSsLaSu0VLtzZdDLC87rcvQ6UYieHQ@mail.gmail.com>
 <20220512231031.GT1790663@paulmck-ThinkPad-P17-Gen-1>
 <CANn89iKiTiGwMvV6K+Zbr_9+knaR-x1N3tOeMX+2No2=4zn6pA@mail.gmail.com>
In-Reply-To: <CANn89iKiTiGwMvV6K+Zbr_9+knaR-x1N3tOeMX+2No2=4zn6pA@mail.gmail.com>
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
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdGF0aXN0aWNzIGFyZSBzdXBwb3NlZCB0byBiZSBtb25vdG9uaWNhbGx5IGluY3JlYXNpbmcg
OykNCj4gDQo+IFNvbWUgU05NUCBhZ2VudHMgd291bGQgYmUgdmVyeSBjb25mdXNlZCBpZiB0aGV5
IGNvdWxkIG9ic2VydmUgJ2dhcmJhZ2UnIHRoZXJlLg0KDQpEb24ndCBsb29rIGluc2lkZSB0ZzMg
Oi0pDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=

