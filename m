Return-Path: <netdev+bounces-12192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2744D736975
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6029280D49
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1007AC15A;
	Tue, 20 Jun 2023 10:38:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E432F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:38:10 +0000 (UTC)
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70342A0;
	Tue, 20 Jun 2023 03:38:06 -0700 (PDT)
From: "Duan,Muquan" <duanmuquan@baidu.com>
To: Eric Dumazet <edumazet@google.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Thread-Topic: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Thread-Index: AQHZmEIvBn0+XWKPJ0K4vDCWGljg2q981HwAgAHkBoCAABoBgIAAHXsAgAACgQCAANIxAIAAA7oAgAB4gQCAAAhSgIALBeGAgAA1TACABxQTAIAAV6MAgAAfqAA=
Date: Tue, 20 Jun 2023 10:37:27 +0000
Message-ID: <D984749A-EACD-4408-9C8F-0B3222281C39@baidu.com>
References: <20230606064306.9192-1-duanmuquan@baidu.com>
 <CANn89iKwzEtNWME+1Xb57DcT=xpWaBf59hRT4dYrw-jsTdqeLA@mail.gmail.com>
 <DFBEBE81-34A5-4394-9C5B-1A849A6415F1@baidu.com>
 <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
 <D8D0327E-CEF0-4DFC-83AB-BC20EE3DFCDE@baidu.com>
 <CANn89iKXttFLj4WCVjWNeograv=LHta4erhtqm=fpfiEWscJCA@mail.gmail.com>
 <8C32A1F5-1160-4863-9201-CF9346290115@baidu.com>
 <CANn89i+JBhj+g564rfVd9gK7OH48v3N+Ln0vAgJehM5xJh32-g@mail.gmail.com>
 <7FD2F3ED-A3B5-40EF-A505-E7A642D73208@baidu.com>
 <CANn89iJ5kHmksR=nGSMVjacuV0uqu5Hs0g1s343gvAM9Yf=+Bg@mail.gmail.com>
 <FD0FE67D-378D-4DDE-BB35-6FFDE2AD3AA5@baidu.com>
 <CANn89iK1yo6R4kZneD_1OZYocQCWp1sxviYzjJ+BBn4HeFSNhw@mail.gmail.com>
 <AF8804B1-D096-4B80-9A1F-37FA03B04123@baidu.com>
 <CANn89i+fNWbRLYx7gvF7q_AGdQOhRxgFnwMqnpZK91kkEEg=Uw@mail.gmail.com>
In-Reply-To: <CANn89i+fNWbRLYx7gvF7q_AGdQOhRxgFnwMqnpZK91kkEEg=Uw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.14.117.47]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD1E75636C0AB44DA371567B9E8C5AB5@internal.baidu.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.19
X-FE-Last-Public-Client-IP: 100.100.100.49
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGksIEVyaWMsDQoNClRoYW5rcyBmb3IgeW91ciByZXBseSENCg0KDQo+PiBXaHkgbm90IHNwZWFr
IG9mIHRoZSBGSU46DQo+PiBGb3IgY3VycmVudCBpbXBsZW1lbnRhdGlvbiwgaGFzaGRhbmNlIGNh
biBiZSBkb25lIG9uIHN0YXRlIEZJTl9XQUlUMiwgIGl0IG1heSByYWNlIHdpdGggdGhlIGVoYXNo
IGxvb2t1cCBwcm9jZXNzIG9mICBwYXNzaXZlIGNsb3NlcuKAmXMgRklOLiBNeSBuZXcgcGF0Y2gg
MyBkb2VzIHRoZSB0dyBoYXNoZGFuY2UgdW50aWwgcmVjZWl2aW5nIHBhc3NpdmUgY2xvc2VyJ3Mg
RklOKHJlYWwgVElNRV9XQUlUKSwgIHNvIHRoaXMgcmFjZSBkb2VzIG5vdCBleGlzdCBhbmQgIHRo
ZSAnY29ubmVjdGlvbiByZWZ1c2VkJyBpc3N1ZSB3aWxsIG5vdCBvY2N1ciwgc28gSSBkaWQgbm90
IHNwZWFrIG9mIHRoZSBGSU4gYWdhaW4gd2l0aCB0aGUgbmV3IHBhdGNoLg0KPj4gDQo+IHNoZGFu
Y2UgYmVnaW5zLCB0aGUgRklOIG1heSBiZSBkcm9wcGVkIGluIGZ1cnRoZXIgcHJvY2VzcyBpZiB0
aGUgc29jaw0KPiBpcyBkZXN0cm95ZWQgb24gYW5vdGhlciBDUFUgYWZ0ZXIgaGFzaGRhbmNlLg0K
ICAgDQpXaXRoIG15IHBhdGNoIDMsIHBhc3NpdmUgY2xvc2Vy4oCZcyBGSU4gd2lsbCBmaW5kIG9y
aWdpbmFsIHNvY2sgYmVjYXVzZSBoYXNoZGFuY2Ugd2lsbCBub3QgYmUgZG9uZSBiZWZvcmUgcmVj
ZWl2aW5nIGl0LA0KQWZ0ZXIgaGFzaGRhbmNlLCB0aGUgdHcgc29ja+KAmXMgc3RhdGUgaXMgc2V0
IHRvIFRJTUVfV0FJVCBhbHJlYWR5LCBpdCBjYW4gYWNjZXB0IG5ldyBTWU4gd2l0aCB0aGUgc2Ft
cGUgNC10dXBsZXMuIA0KSWYgdGhlIG9yaWdpbmFsIHNvY2sgaXMgZGVzdHJveWVkIG9uIGFub3Ro
ZXIgQ1BVIG9yIHRoZSBGSU4gaXMgZHJvcGVkIGFmdGVyIGhhc2hkYW5jZSwgIGl0IHdpbGwgbm90
IGFmZmVjdCB0aGUgdHcgc29jay4NCkkgZG9u4oCZdCBrbm93IHdoZXRoZXIgSSBnZXQgeW91ciBw
b2ludCBjb3JyZWN0bHk/DQoNCg0KPj4gDQo+PiBJIHRvb2sgYSBsb29rIGF0IEZyZWVCU0QsIGl0
IHVzZXMgaGFzaCB0YWJsZSBsb2NrIGFuZCBwZXIgc29jayBsZXZlbCBsb2NrLkl0IGFsc28gbmVl
ZHMgc29tZSB0cmlja3MgdG8gcmV0cnkgZm9yIHNvbWUgY2FzZXMsIGZvciBleGFtcGxlLCBzb2Nr
IGRyb3BwZWQgYnkgYW5vdGhlciB0aHJlYWQgd2hlbiB3YWl0aW5nIGZvciBwZXIgc29jayBsb2Nr
IGR1cmluZyB0aGUgbG9va3VwOg0KPj4gICAvKg0KPj4gICAgICogV2hpbGUgd2FpdGluZyBmb3Ig
aW5wIGxvY2sgZHVyaW5nIHRoZSBsb29rdXAsIGFub3RoZXIgdGhyZWFkDQo+PiAgICAgKiBjYW4g
aGF2ZSBkcm9wcGVkIHRoZSBpbnBjYiwgaW4gd2hpY2ggY2FzZSB3ZSBuZWVkIHRvIGxvb3AgYmFj
aw0KPj4gICAgICogYW5kIHRyeSB0byBmaW5kIGEgbmV3IGlucGNiIHRvIGRlbGl2ZXIgdG8uDQo+
PiAgICAgKi8NCj4+ICAgIGlmIChpbnAtPmlucF9mbGFncyAmIElOUF9EUk9QUEVEKSB7DQo+PiAg
ICAgICAgSU5QX1dVTkxPQ0soaW5wKTsNCj4+ICAgICAgICBpbnAgPSBOVUxMOw0KPj4gICAgICAg
IGdvdG8gZmluZHBjYjsNCj4+IH0NCj4+IA0KPiANCj4gVGhpcyBpcyB0aGUgbGFzdCB0aW1lIHlv
dSBicmluZyBGcmVlQlNEIGNvZGUgaGVyZS4NCj4gDQo+IFdlIGRvIG5vdCBjb3B5IEZyZWVCU0Qg
Y29kZSBmb3Igb2J2aW91cyByZWFzb25zLg0KPiBJIG5ldmVyIGxvb2tlZCBhdCBGcmVlQlNEIGNv
ZGUgYW5kIG5ldmVyIHdpbGwuDQo+IA0KPiBTdG9wIHRoaXMsIHBsZWFzZSwgb3IgSSB3aWxsIGln
bm9yZSB5b3VyIGZ1dHVyZSBlbWFpbHMuDQoNCg0KSSBhbSB2ZXJ5IHNvcnJ5LCBJIHdpbGwgbm90
IGRvIHRoaXMgYWdhaW4uDQoNCg0KDQoNCg0KDQpSZWdhcmRzIQ0KRHVhbm11cXVhbg0KDQo+IDIw
MjPlubQ25pyIMjDml6Ug5LiL5Y2INDo0NO+8jEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xl
LmNvbT4g5YaZ6YGT77yaDQo+IA0KPiBPbiBUdWUsIEp1biAyMCwgMjAyMyBhdCA1OjMw4oCvQU0g
RHVhbixNdXF1YW4gPGR1YW5tdXF1YW5AYmFpZHUuY29tPiB3cm90ZToNCj4+IA0KPj4gSGksIEVy
aWMsDQo+PiANCj4+IFRoYW5rcyBmb3IgeW91ciBjb21tZW50cyENCj4+IA0KPj4gV2h5IG5vdCBz
cGVhayBvZiB0aGUgRklOOg0KPj4gRm9yIGN1cnJlbnQgaW1wbGVtZW50YXRpb24sIGhhc2hkYW5j
ZSBjYW4gYmUgZG9uZSBvbiBzdGF0ZSBGSU5fV0FJVDIsICBpdCBtYXkgcmFjZSB3aXRoIHRoZSBl
aGFzaCBsb29rdXAgcHJvY2VzcyBvZiAgcGFzc2l2ZSBjbG9zZXLigJlzIEZJTi4gTXkgbmV3IHBh
dGNoIDMgZG9lcyB0aGUgdHcgaGFzaGRhbmNlIHVudGlsIHJlY2VpdmluZyBwYXNzaXZlIGNsb3Nl
cidzIEZJTihyZWFsIFRJTUVfV0FJVCksICBzbyB0aGlzIHJhY2UgZG9lcyBub3QgZXhpc3QgYW5k
ICB0aGUgJ2Nvbm5lY3Rpb24gcmVmdXNlZCcgaXNzdWUgd2lsbCBub3Qgb2NjdXIsIHNvIEkgZGlk
IG5vdCBzcGVhayBvZiB0aGUgRklOIGFnYWluIHdpdGggdGhlIG5ldyBwYXRjaC4NCj4+IA0KPiBz
aGRhbmNlIGJlZ2lucywgdGhlIEZJTiBtYXkgYmUgZHJvcHBlZCBpbiBmdXJ0aGVyIHByb2Nlc3Mg
aWYgdGhlIHNvY2sNCj4gaXMgZGVzdHJveWVkIG9uIGFub3RoZXIgQ1BVIGFmdGVyIGhhc2hkYW5j
ZS4NCj4+IA0KPj4gSSB0b29rIGEgbG9vayBhdCBGcmVlQlNELCBpdCB1c2VzIGhhc2ggdGFibGUg
bG9jayBhbmQgcGVyIHNvY2sgbGV2ZWwgbG9jay5JdCBhbHNvIG5lZWRzIHNvbWUgdHJpY2tzIHRv
IHJldHJ5IGZvciBzb21lIGNhc2VzLCBmb3IgZXhhbXBsZSwgc29jayBkcm9wcGVkIGJ5IGFub3Ro
ZXIgdGhyZWFkIHdoZW4gd2FpdGluZyBmb3IgcGVyIHNvY2sgbG9jayBkdXJpbmcgdGhlIGxvb2t1
cDoNCj4+ICAgLyoNCj4+ICAgICAqIFdoaWxlIHdhaXRpbmcgZm9yIGlucCBsb2NrIGR1cmluZyB0
aGUgbG9va3VwLCBhbm90aGVyIHRocmVhZA0KPj4gICAgICogY2FuIGhhdmUgZHJvcHBlZCB0aGUg
aW5wY2IsIGluIHdoaWNoIGNhc2Ugd2UgbmVlZCB0byBsb29wIGJhY2sNCj4+ICAgICAqIGFuZCB0
cnkgdG8gZmluZCBhIG5ldyBpbnBjYiB0byBkZWxpdmVyIHRvLg0KPj4gICAgICovDQo+PiAgICBp
ZiAoaW5wLT5pbnBfZmxhZ3MgJiBJTlBfRFJPUFBFRCkgew0KPj4gICAgICAgIElOUF9XVU5MT0NL
KGlucCk7DQo+PiAgICAgICAgaW5wID0gTlVMTDsNCj4+ICAgICAgICBnb3RvIGZpbmRwY2I7DQo+
PiB9DQo+PiANCj4gDQo+IFRoaXMgaXMgdGhlIGxhc3QgdGltZSB5b3UgYnJpbmcgRnJlZUJTRCBj
b2RlIGhlcmUuDQo+IA0KPiBXZSBkbyBub3QgY29weSBGcmVlQlNEIGNvZGUgZm9yIG9idmlvdXMg
cmVhc29ucy4NCj4gSSBuZXZlciBsb29rZWQgYXQgRnJlZUJTRCBjb2RlIGFuZCBuZXZlciB3aWxs
Lg0KPiANCj4gU3RvcCB0aGlzLCBwbGVhc2UsIG9yIEkgd2lsbCBpZ25vcmUgeW91ciBmdXR1cmUg
ZW1haWxzLg0KDQo=

