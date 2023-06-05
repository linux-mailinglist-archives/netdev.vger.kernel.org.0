Return-Path: <netdev+bounces-8034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD83722804
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 184BC1C20B84
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9607A1D2C0;
	Mon,  5 Jun 2023 13:58:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8998F19BBF
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:58:26 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BB6E5
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:58:24 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-182-gQGc-ds6PtmkvBSdlpr_Eg-1; Mon, 05 Jun 2023 14:58:22 +0100
X-MC-Unique: gQGc-ds6PtmkvBSdlpr_Eg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 5 Jun
 2023 14:58:10 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 5 Jun 2023 14:58:10 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Alexander Duyck' <alexander.duyck@gmail.com>, Eric Dumazet
	<edumazet@google.com>
CC: Alexander Duyck <alexanderduyck@meta.com>, "David S . Miller"
	<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Xin
 Long" <lucien.xin@gmail.com>, David Ahern <dsahern@kernel.org>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: RE: [PATCH net] tcp: gso: really support BIG TCP
Thread-Topic: [PATCH net] tcp: gso: really support BIG TCP
Thread-Index: AQHZlWhvwvFx4uqt6EmH/UKt2+ZZYK98O16w
Date: Mon, 5 Jun 2023 13:58:10 +0000
Message-ID: <b0ecec17f9c1409ba476cf370730278a@AcuMS.aculab.com>
References: <20230601211732.1606062-1-edumazet@google.com>
 <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
 <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com>
 <db5f5b88ccbd40cadea8417822a3722239b7fc04.camel@gmail.com>
 <CANn89iLDzPcD-ASM8266dELMqe-innWtU2wgBV2Vfv1pRYRbrw@mail.gmail.com>
 <CANn89iJoA7U_j6pPX1CXmRtZG2XNGYhFzjRyNUBn+BbfM1gfbw@mail.gmail.com>
 <CAKgT0Uffq97JF7cpkyQPmFh0mreHx+yKxgExnOGn6KzEoQ0HyA@mail.gmail.com>
In-Reply-To: <CAKgT0Uffq97JF7cpkyQPmFh0mreHx+yKxgExnOGn6KzEoQ0HyA@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RnJvbTogQWxleGFuZGVyIER1eWNrDQo+IFNlbnQ6IDAyIEp1bmUgMjAyMyAxNjozOQ0KLi4uDQo+
IEkgd291bGRuJ3QgZXZlbiBib3RoZXIgd2l0aCBhbnkgb2YgdGhlc2UgY2hhbmdlcy4NCj4gDQo+
ID4gQEAgLTc4LDcgKzc4LDcgQEAgc3RydWN0IHNrX2J1ZmYgKnRjcF9nc29fc2VnbWVudChzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLA0KPiA+ICAgICAgICAgaWYgKCFwc2tiX21heV9wdWxsKHNrYiwgdGhs
ZW4pKQ0KPiA+ICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPg0KPiA+IC0gICAgICAgb2xk
bGVuID0gKHUxNil+c2tiLT5sZW47DQo+ID4gKyAgICAgICBvbGRsZW4gPSBza2ItPmxlbjsNCj4g
PiAgICAgICAgIF9fc2tiX3B1bGwoc2tiLCB0aGxlbik7DQo+ID4NCj4gPiAgICAgICAgIG1zcyA9
IHNrYl9zaGluZm8oc2tiKS0+Z3NvX3NpemU7DQo+IA0KPiBBcyBJIHN0YXRlZCBiZWZvcmUgSSB3
b3VsZCBqdXN0IGRyb3AgdGhlICIodTE2KSIuIFdlIGFyZSBleHBhbmRpbmcgdGhlDQo+IG9sZGxl
biB0byBhIHUzMiwgYnV0IGRvbid0IGhhdmUgdG8gd29ycnkgYWJvdXQgaXQgb3ZlcmZsb3dpbmcg
YmVjYXVzZQ0KPiBza2ItPmxlbiBzaG91bGQgYWx3YXlzIGJlIGdyZWF0ZXIgdGhhbiBvciBlcXVh
bCB0byBvdXIgc2VnbWVudGVkDQo+IGxlbmd0aC4gU28gdGhlIG1vc3QgaXQgY291bGQgcmVhY2gg
aXMgfjAgaWYgc2tiLT5sZW4gPT0gc2VnbWVudGVkDQo+IGxlbmd0aC4NCg0KSGF2ZSB5b3UgbWlz
c2VkIHRoZSB+ID8NClRoZSAodTE2KSBtYWtlcyBpdCBlcXVpdmFsZW50IHRvIHNrYi0+bGVuIF4g
MHhmZmZmLg0KT3RoZXJ3aXNlIGFsbCB0aGUgaGlnaCBiaXQgYXJlIHNldCBhbmQgYW55IGFyaXRo
bWV0aWMgd2lsbCBnZW5lcmF0ZQ0KYSBjYXJyeSBhbmQgdGhlIHdyb25nIHZhbHVlLg0KDQpGV0lX
IHRoaXMgQyB2ZXJzaW9uIG9mIGNzdW1fZm9sZCgpIChlZyBmcm9tIGFyY2gvYXJjKQ0KZ2VuZXJh
dGVzIGJldHRlciBjb2RlIHRoYW4gdGhlIGV4aXN0aW5nIHZlcnNpb25zIG9uIHByZXR0eQ0KbXVj
aCBldmVyeSBhcmNoaXRlY3R1cmUuDQoNCglyZXR1cm4gKH5zdW0gLSByb3IzMihzdW0sIDE2KSkg
Pj4gMTY7DQoNClRoZSBtYWluIGV4Y2VwdGlvbiB3aWxsIGJlIHNwYXJjICh3aGljaCBoYXMgYSBj
YXJyeSBmbGFnIGJ1dA0Kbm8gcm90YXRlKSBhbmQgYXJtIHdpdGggaXRzIGJhcnJlbCBzaGlmdGVy
Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K


