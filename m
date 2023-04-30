Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B952D6F289F
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjD3Llj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 07:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjD3Lli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 07:41:38 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A626BF
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 04:41:36 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-195-2egkSrpHP12dQvLiFNJyww-1; Sun, 30 Apr 2023 12:41:34 +0100
X-MC-Unique: 2egkSrpHP12dQvLiFNJyww-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 30 Apr
 2023 12:41:32 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sun, 30 Apr 2023 12:41:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: RE: [PATCH v2 net] tcp: fix skb_copy_ubufs() vs BIG TCP
Thread-Topic: [PATCH v2 net] tcp: fix skb_copy_ubufs() vs BIG TCP
Thread-Index: AQHZeYp5MWg0BiPw+U+M7x6meJcYt69Dsj4Q
Date:   Sun, 30 Apr 2023 11:41:32 +0000
Message-ID: <b8a108252a6342f2ba24d8ef769cf4f7@AcuMS.aculab.com>
References: <20230428043231.501494-1-edumazet@google.com>
In-Reply-To: <20230428043231.501494-1-edumazet@google.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDI4IEFwcmlsIDIwMjMgMDU6MzMNCi4uLg0KPiAt
CW5ld19mcmFncyA9IChfX3NrYl9wYWdlbGVuKHNrYikgKyBQQUdFX1NJWkUgLSAxKSA+PiBQQUdF
X1NISUZUOw0KPiArCS8qIFdlIG1pZ2h0IGhhdmUgdG8gYWxsb2NhdGUgaGlnaCBvcmRlciBwYWdl
cywgc28gY29tcHV0ZSB3aGF0IG1pbmltdW0NCj4gKwkgKiBwYWdlIG9yZGVyIGlzIG5lZWRlZC4N
Cj4gKwkgKi8NCj4gKwlvcmRlciA9IDA7DQo+ICsJd2hpbGUgKChQQUdFX1NJWkUgPDwgb3JkZXIp
ICogTUFYX1NLQl9GUkFHUyA8IF9fc2tiX3BhZ2VsZW4oc2tiKSkNCj4gKwkJb3JkZXIrKzsNCj4g
Kwlwc2l6ZSA9IChQQUdFX1NJWkUgPDwgb3JkZXIpOw0KPiArDQo+ICsJbmV3X2ZyYWdzID0gKF9f
c2tiX3BhZ2VsZW4oc2tiKSArIHBzaXplIC0gMSkgPj4gKFBBR0VfU0hJRlQgKyBvcmRlcik7DQoN
ClRoYXQgbG9va3MgbGlrZSBpdCB3aWxsIGdlbmVyYXRlIHF1aXRlIGhvcnJpZCBjb2RlLg0KUGVy
aGFwcyBzb21ldGhpbmcgbGlrZToNCg0KCW5ld19mcmFncyA9IChfX3NrYl9wYWdlbGVuKHNrYikg
KyBQQUdFX1NJWkUgLSAxKSA+PiBQQUdFX1NISUZUOw0KCW9yZGVyID0gMDsNCglwc2l6ZSA9IFBB
R0VfU0laRTsNCglpZiAobmV3X2ZyYWdzID4gTUFYX1NLQl9GUkFHUykgew0KCQkvKiBBbGxvY2F0
ZSBoaWdoIG9yZGVyIHBhZ2VzIHRvIHJlZHVjZSB0aGUgbnVtYmVyIG9mIGZyYWdzLiAqLw0KCQlv
cmRlciA9IGlsb2cyKERJVl9ST1VORFVQKG5ld19mcmFncywgTUFYX1NLQl9GUkFHUykgLSAxKSAr
IDE7DQoJCXBzaXplIDw8PSBvcmRlcjsNCgl9DQoNClRoZXJlIG1pZ2h0IGJlIGFuICdvZmYtYnkt
b25lJyBpbiB0aGVyZSBzb21ld2hlcmUgdGhvdWdoLi4uDQoNCglEYXZpZA0KDQotDQpSZWdpc3Rl
cmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtl
eW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

