Return-Path: <netdev+bounces-12106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4290B736229
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 05:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68FA51C20AD3
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 03:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BF915B2;
	Tue, 20 Jun 2023 03:31:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1670F15AE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:31:11 +0000 (UTC)
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E02139;
	Mon, 19 Jun 2023 20:31:09 -0700 (PDT)
From: "Duan,Muquan" <duanmuquan@baidu.com>
To: Eric Dumazet <edumazet@google.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Thread-Topic: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Thread-Index: AQHZmEIvBn0+XWKPJ0K4vDCWGljg2q981HwAgAHkBoCAABoBgIAAHXsAgAACgQCAANIxAIAAA7oAgAB4gQCAAAhSgIALBeGAgAA1TACABxQTAA==
Date: Tue, 20 Jun 2023 03:30:29 +0000
Message-ID: <AF8804B1-D096-4B80-9A1F-37FA03B04123@baidu.com>
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
In-Reply-To: <CANn89iK1yo6R4kZneD_1OZYocQCWp1sxviYzjJ+BBn4HeFSNhw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.22.196.192]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6BA1C92C72B914BB681677FF6FA1FB6@internal.baidu.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.21
X-FE-Last-Public-Client-IP: 100.100.100.49
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGksIEVyaWMsDQoNClRoYW5rcyBmb3IgeW91ciBjb21tZW50cyENCg0KV2h5IG5vdCBzcGVhayBv
ZiB0aGUgRklOOiANCkZvciBjdXJyZW50IGltcGxlbWVudGF0aW9uLCBoYXNoZGFuY2UgY2FuIGJl
IGRvbmUgb24gc3RhdGUgRklOX1dBSVQyLCAgaXQgbWF5IHJhY2Ugd2l0aCB0aGUgZWhhc2ggbG9v
a3VwIHByb2Nlc3Mgb2YgIHBhc3NpdmUgY2xvc2Vy4oCZcyBGSU4uIE15IG5ldyBwYXRjaCAzIGRv
ZXMgdGhlIHR3IGhhc2hkYW5jZSB1bnRpbCByZWNlaXZpbmcgcGFzc2l2ZSBjbG9zZXIncyBGSU4o
cmVhbCBUSU1FX1dBSVQpLCAgc28gdGhpcyByYWNlIGRvZXMgbm90IGV4aXN0IGFuZCAgdGhlICdj
b25uZWN0aW9uIHJlZnVzZWQnIGlzc3VlIHdpbGwgbm90IG9jY3VyLCBzbyBJIGRpZCBub3Qgc3Bl
YWsgb2YgdGhlIEZJTiBhZ2FpbiB3aXRoIHRoZSBuZXcgcGF0Y2guICANCiAgDQpXaHkgc3BlYWsg
b2YgdGhlIFNZTjoNClRoZW9yZXRpY2FsbHkgbmV3IFNZTiBtYXkgcmFjZSB3aXRoIGhhc2hkYW5j
ZSB3aXRoIG9yIHdpdGhvdXQgbXkgcGF0Y2gsIGFuZCByZXN1bHRzIGluIGEgcmV0cmFuc21pc3Np
b24gb2YgaXQuIEJ1dCBJdCBpcyBhbG1vc3QgaW1wb3NzaWJsZSB0byBnZXQgbmV3IFNZTiBiZWZv
cmUgaGFzaGRhbmNlLCB0aGVyZSBhcmUgb25lIFJUVCBiZXR3ZWVuIHRoZSBwYXNzaXZlIGNsb3Nl
cidzIEZJTiBhbmQgbmV3IFNZTi4gVGhlIHByb2JhYmlsaXR5IGlzIHRvbyBzbWFsbCB0byBhbmQg
bWF5IG5ldmVyIG9jY3VyIGluIHByYWN0aWNlLiBJIG5ldmVyIG1lMHQgdGhpcyBpc3N1ZSBpbiBt
eSByZXByb2R1Y2luZyBlbnZpcm9ubWVudC4NCiBGb3IgdGhlIGNvbm5lY3Rpb24gcmV1c2UgaXNz
dWUgSSBtZXQsIEkgdGhpbmsgIG5vIHRyaWNrcyBuZWVkZWQgd2l0aCBwYXRjaCAzLg0KDQpBYm91
dCBpbnRyb2R1Y2luZyB0aGUgbG9jazoNCklmIHdlIHJlYWxseSBuZWVkIHRvIGludHJvZHVjZSB0
aGUgbG9jaywgSSB0aGluayBiZXNpZGVzIHByb3RlY3RpbmcgdGhlIGxpc3QgaW4gZWhhc2ggYnVj
a2V0LCB3ZSBhbHNvIG5lZWQgdG8gcHJvdGVjdCB0aGUgc29jayBkdXJpbmcgY29uc3VtaW5nIHRo
ZSBwYXRja2V0LiBCZWNhdXNlIGFmdGVyIHdlIGZpbmQgdGhlIHNvY2sgYW5kIGNvbnN1bWluZyAg
dGhlIHBhY2tldCwgd2UgY2FuIG1lZXQgc29jayBsZXZlbCByYWNlIGF0IGRpZmZlcmVudCBDUFVz
LCBmb3IgZXhhbXBsZSwgIHRoZSBwYXNzaXZlIGNsb3NlcidzIEZJTiBhcnJpdmVzIHRvbyBmYXN0
IGFuZCBmaW5kcyB0aGUgb3JpZ2luYWwgc29jayBiZWZvcmUgdGhlIGhhc2hkYW5jZSBiZWdpbnMs
IHRoZSBGSU4gbWF5IGJlIGRyb3BwZWQgaW4gZnVydGhlciBwcm9jZXNzIGlmIHRoZSBzb2NrIGlz
IGRlc3Ryb3llZCBvbiBhbm90aGVyIENQVSBhZnRlciBoYXNoZGFuY2UuICANCiAgICAgDQpJIHRv
b2sgYSBsb29rIGF0IEZyZWVCU0QsIGl0IHVzZXMgaGFzaCB0YWJsZSBsb2NrIGFuZCBwZXIgc29j
ayBsZXZlbCBsb2NrLkl0IGFsc28gbmVlZHMgc29tZSB0cmlja3MgdG8gcmV0cnkgZm9yIHNvbWUg
Y2FzZXMsIGZvciBleGFtcGxlLCBzb2NrIGRyb3BwZWQgYnkgYW5vdGhlciB0aHJlYWQgd2hlbiB3
YWl0aW5nIGZvciBwZXIgc29jayBsb2NrIGR1cmluZyB0aGUgbG9va3VwOiANCiAgIC8qICANCiAg
ICAgKiBXaGlsZSB3YWl0aW5nIGZvciBpbnAgbG9jayBkdXJpbmcgdGhlIGxvb2t1cCwgYW5vdGhl
ciB0aHJlYWQNCiAgICAgKiBjYW4gaGF2ZSBkcm9wcGVkIHRoZSBpbnBjYiwgaW4gd2hpY2ggY2Fz
ZSB3ZSBuZWVkIHRvIGxvb3AgYmFjayANCiAgICAgKiBhbmQgdHJ5IHRvIGZpbmQgYSBuZXcgaW5w
Y2IgdG8gZGVsaXZlciB0by4gDQogICAgICovICAgDQogICAgaWYgKGlucC0+aW5wX2ZsYWdzICYg
SU5QX0RST1BQRUQpIHsNCiAgICAgICAgSU5QX1dVTkxPQ0soaW5wKTsNCiAgICAgICAgaW5wID0g
TlVMTDsNCiAgICAgICAgZ290byBmaW5kcGNiOw0KfSAgICANCg0KDQpJIHdvcnJ5IGFib3V0IHRo
YXQgbG9ja2luZyBvbiBlaGFzaCBidWNrZXQgYW5kIHBlciBzb2NrIHdpbGwgaW50cm9kdWNlIHBl
cmZvcm1hbmNlIGFuZCBzY2FsaW5nIGlzc3VlICwgZXNwZWNpYWxseSB3aGVuICAgIHRoZXJlIGFy
ZSBhIGxhcmdlIG51bWJlciBvZiBzb2NrcyBvciBtYW55IHNob3J0IGNvbm5lY3Rpb25zLiBJIGNh
biB0YWtlIHNvbWUgdGltZSBvdXQgdG8gZGVhbCB3aXRoIHRoaXMgaXNzdWUgaW4gdGhlIGZsb3dp
bmcgYSBmZXcgd2Vla3MsIEkgd2lsbCB0cnkgdG8gaW50cm9kdWNlIGxvY2sgYW5kIHdyaXRlIHNv
bWUgdGVzdCBwcm9ncmFtcyB0byBldmFsdWF0ZSB0aGUgcGVyZm9ybWFuY2UgaGl0Lg0KDQpSZWdh
cmRzIQ0KRHVhbm11cXVhbg==

