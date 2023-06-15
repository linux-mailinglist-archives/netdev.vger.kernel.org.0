Return-Path: <netdev+bounces-11084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A7F73184E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75E23281776
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99748154AA;
	Thu, 15 Jun 2023 12:14:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC0B125DA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:14:32 +0000 (UTC)
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D34199D;
	Thu, 15 Jun 2023 05:14:29 -0700 (PDT)
From: "Duan,Muquan" <duanmuquan@baidu.com>
To: Eric Dumazet <edumazet@google.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Thread-Topic: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
Thread-Index: AQHZmEIvBn0+XWKPJ0K4vDCWGljg2q981HwAgAHkBoCAABoBgIAAHXsAgAACgQCAANIxAIAAA7oAgAB4gQCAAAhSgIALBeGA
Date: Thu, 15 Jun 2023 12:14:03 +0000
Message-ID: <FD0FE67D-378D-4DDE-BB35-6FFDE2AD3AA5@baidu.com>
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
In-Reply-To: <CANn89iJ5kHmksR=nGSMVjacuV0uqu5Hs0g1s343gvAM9Yf=+Bg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.22.196.206]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6ADD5303F58CC43ABB31704ADAB3788@internal.baidu.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.36
X-FE-Last-Public-Client-IP: 100.100.100.49
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGksIEVyaWMsIA0KDQpDb3VsZCB5b3UgcGxlYXNlIGhlbHAgY2hlY2sgd2hldGhlciB0aGUgZm9s
bG93aW5nIG1ldGhvZCBtYWtlcyBzZW5zZSwgYW5kIA0KYW55IHNpZGUgZWZmZWN0PyBUaGFua3Mh
DQoNCklmICBkbyB0aGUgdHcgaGFzaGRhbmNlIGluIHJlYWwgVENQX1RJTUVfV0FJVCBzdGF0ZSB3
aXRoIHN1YnN0YXRlDQpUQ1BfVElNRV9XQUlULCBpbnN0ZWFkIG9mIGluIHN1YnN0YXRlIFRDUF9G
SU5fV0FJVDIsIHRoZSBjb25uZWN0aW9uDQpyZWZ1c2VkIGlzc3VlIHdpbGwgbm90IG9jY3VyLiBU
aGUgcmFjZSBvZiB0aGUgbG9va3VwIHByb2Nlc3MgZm9yIHRoZSANCm5ldyBTWU4gc2VnbWVudCBh
bmQgdGhlIHR3IGhhc2hkYW5jZSBjYW4gY29tZSB0byB0aGUgZm9sbG93aW5nDQpyZXN1bHRzOg0K
MSkgZ2V0IHR3IHNvY2ssIFNZTiBzZWdtZW50IHdpbGwgYmUgYWNjZXB0ZWQgdmlhIFRDUF9UV19T
WU4uDQoyKSBmYWlsIHRvIGdldCB0dyBzb2NrIGFuZCBvcmlnaW5hbCBzb2NrLCBnZXQgYSBsaXN0
ZW5lciBzb2NrLA0KICAgU1lOIHNlZ21lbnQgd2lsbCBiZSBhY2NlcHRlZCBieSBsaXN0ZW5lciBz
b2NrLg0KMykgZ2V0IG9yaWdpbmFsIHNvY2ssIFNZTiBzZWdtZW50IGNhbiBiZSBkaXNjYXJkZWQg
aW4gZnVydGhlcg0KcHJvY2VzcyBhZnRlciB0aGUgc29jayBpcyBkZXN0cm95ZWQsIGluIHRoaXMg
Y2FzZSB0aGUgcGVlciB3aWxsDQpyZXRyYW5zbWl0IHRoZSBTWU4gc2VnbWVudC4gVGhpcyBpcyBh
IHZlcnkgcmFyZSBjYXNlLCBzZWVtcyBubyBuZWVkIHRvDQphZGQgbG9jayBmb3IgaXQuIA0KDQpJ
IHRlc3RlZCB0aGlzIG1vZGlmaWNhdGlvbiBpbiBteSByZXByb2R1Y2luZyBlbnZpcm9ubWVudCwN
CnRoZSBjb25uZWN0aW9uIHJlc2V0IGlzc3VlIGRpZCBub3Qgb2NjdXIgYW5kIG5vIHBlcmZvcm1h
bmNlIGltcGFjdA0Kb2JzZXJ2ZWQuVGhlIHNpZGUgZWZmZWN0IEkgY3VycmVudGx5IGNhbiB0aGlu
ayBvdXQgaXMgdGhhdCB0aGUgb3JpZ2luYWwNCnNvY2sgd2lsbCBsaXZlIGEgbGl0dGxlIGxvbmdl
ciBhbmQgaG9sZCBzb21lIHJlc291cmNlcyBsb25nZXIuDQpUaGUgbmV3IHBhdGNoIGlzIGEgdGVt
cG9yYXJ5IHZlcnNpb24gd2hpY2ggaGFzIGEgc3lzY3RsDQpzd2l0Y2ggZm9yIGNvbXBhcmluZyB0
aGUgMiBtZXRob2RzLCBhbmQgc29tZSBtb2RpZmljYXRpb25zDQpmb3Igc3RhdGlzdGljcyBvZiB0
aGUgc3RhdGVzIG5vdCBpbmNsdWRlZC4NCkkgY2hlY2tlZCB0aGUgaW1wbGVtZW50YXRpb24gaW4g
RnJlZUJTRCAxMy4xLCBpdCBkb2VzIHRoZSBkYW5jZSBpbg0Kc3RhdGUgVENQX1RJTUVXQUlULg0K
DQoNCg0KUmVnYXJkcyENCkR1YW4NCg0KPiAyMDIz5bm0NuaciDjml6Ug5LiL5Y2INzo1NO+8jEVy
aWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4g5YaZ6YGT77yaDQo+IA0KPiBPbiBUaHUs
IEp1biA4LCAyMDIzIGF0IDE6MjTigK9QTSBEdWFuLE11cXVhbiA8ZHVhbm11cXVhbkBiYWlkdS5j
b20+IHdyb3RlOg0KPj4gDQo+PiBCZXNpZGVzIHRyeWluZyB0byBmaW5kIHRoZSByaWdodCB0dyBz
b2NrLCBhbm90aGVyIGlkZWEgaXMgdGhhdCBpZiBGSU4gc2VnbWVudCBmaW5kcyBsaXN0ZW5lciBz
b2NrLCBqdXN0IGRpc2NhcmQgdGhlIHNlZ21lbnQsIGJlY2F1c2UgdGhpcyBpcyBvYnZpb3VzIGEg
YmFkIGNhc2UsIGFuZCB0aGUgcGVlciB3aWxsIHJldHJhbnNtaXQgaXQuIE9yIGZvciBGSU4gc2Vn
bWVudCB3ZSBvbmx5IGxvb2sgdXAgaW4gdGhlIGVzdGFibGlzaGVkIGhhc2ggdGFibGUsIGlmIG5v
dCBmb3VuZCB0aGVuIGRpc2NhcmQgaXQuDQo+PiANCj4gDQo+IFN1cmUsIHBsZWFzZSBnaXZlIHRo
ZSBSRkMgbnVtYmVyIGFuZCBzZWN0aW9uIG51bWJlciB0aGF0IGRpc2N1c3Nlcw0KPiB0aGlzIHBv
aW50LCBhbmQgdGhlbiB3ZSBtaWdodCBjb25zaWRlciB0aGlzLg0KPiANCj4gSnVzdCBhbm90aGVy
IHJlbWluZGVyIGFib3V0IFRXIDogdGltZXdhaXQgc29ja2V0cyBhcmUgImJlc3QgZWZmb3J0Ii4N
Cj4gDQo+IFRoZWlyIGFsbG9jYXRpb24gY2FuIGZhaWwsIGFuZCAvcHJvYy9zeXMvbmV0L2lwdjQv
dGNwX21heF90d19idWNrZXRzDQo+IGNhbiBjb250cm9sIHRoZWlyIG51bWJlciB0byAwDQo+IA0K
PiBBcHBsaWNhdGlvbnMgbXVzdCBiZSBhYmxlIHRvIHJlY292ZXIgZ3JhY2VmdWxseSBpZiBhIDQt
dHVwbGUgaXMgcmV1c2VkIHRvbyBmYXN0Lg0KPiANCj4+IA0KPj4gMjAyM+W5tDbmnIg45pelIOS4
i+WNiDEyOjEz77yMRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPiDlhpnpgZPvvJoN
Cj4+IA0KPj4gT24gVGh1LCBKdW4gOCwgMjAyMyBhdCA1OjU54oCvQU0gRHVhbixNdXF1YW4gPGR1
YW5tdXF1YW5AYmFpZHUuY29tPiB3cm90ZToNCj4+IA0KPj4gDQo+PiBIaSwgRXJpYywNCj4+IA0K
Pj4gVGhhbmtzIGEgbG90IGZvciB5b3VyIGV4cGxhbmF0aW9uIQ0KPj4gDQo+PiBFdmVuIGlmIHdl
IGFkZCByZWFkZXIgbG9jaywgIGlmIHNldCB0aGUgcmVmY250IG91dHNpZGUgc3Bpbl9sb2NrKCkv
c3Bpbl91bmxvY2soKSwgZHVyaW5nIHRoZSBpbnRlcnZhbCBiZXR3ZWVuIHNwaW5fdW5sb2NrKCkg
YW5kIHJlZmNudF9zZXQoKSwgIG90aGVyIGNwdXMgd2lsbCBzZWUgdGhlIHR3IHNvY2sgd2l0aCBy
ZWZjb250IDAsIGFuZCB2YWxpZGF0aW9uIGZvciByZWZjbnQgd2lsbCBmYWlsLg0KPj4gDQo+PiBB
IHN1Z2dlc3Rpb24sIGJlZm9yZSB0aGUgdHcgc29jayBpcyBhZGRlZCBpbnRvIGVoYXNoIHRhYmxl
LCBpdCBoYXMgYmVlbiBhbHJlYWR5IHVzZWQgYnkgdHcgdGltZXIgYW5kIGJoYXNoIGNoYWluLCB3
ZSBjYW4gZmlyc3RseSBhZGQgcmVmY250IHRvIDIgYmVmb3JlIGFkZGluZyB0d28gdG8gZWhhc2gg
dGFibGUsLiBvciBhZGQgdGhlIHJlZmNudCBvbmUgYnkgb25lIGZvciB0aW1lciwgYmhhc2ggYW5k
IGVoYXNoLiBUaGlzICBjYW4gYXZvaWQgdGhlIHJlZmNvbnQgdmFsaWRhdGlvbiBmYWlsdXJlIG9u
IG90aGVyIGNwdXMuDQo+PiANCj4+IFRoaXMgY2FuIHJlZHVjZSB0aGUgZnJlcXVlbmN5IG9mIHRo
ZSBjb25uZWN0aW9uIHJlc2V0IGlzc3VlIGZyb20gMjAgbWluIHRvIDE4MCBtaW4gZm9yIG91ciBw
cm9kdWN0LCAgV2UgbWF5IHdhaXQgcXVpdGUgYSBsb25nIHRpbWUgYmVmb3JlIHRoZSBiZXN0IHNv
bHV0aW9uIGlzIHJlYWR5LCBpZiB0aGlzIG9idmlvdXMgZGVmZWN0IGlzIGZpeGVkLCB1c2VybGFu
ZCBhcHBsaWNhdGlvbnMgY2FuIGJlbmVmaXQgZnJvbSBpdC4NCj4+IA0KPj4gTG9va2luZyBmb3J3
YXJkIHRvIHlvdXIgb3BpbmlvbnMhDQo+PiANCj4+IA0KPj4gQWdhaW4sIG15IG9waW5pb24gaXMg
dGhhdCB3ZSBuZWVkIGEgcHJvcGVyIGZpeCwgbm90IHdvcmsgYXJvdW5kcy4NCj4+IA0KPj4gSSB3
aWxsIHdvcmsgb24gdGhpcyBhIGJpdCBsYXRlci4NCj4+IA0KPj4gSW4gdGhlIG1lYW50aW1lIHlv
dSBjYW4gYXBwbHkgbG9jYWxseSB5b3VyIHBhdGNoIGlmIHlvdSBmZWVsIHRoaXMgaXMNCj4+IHdo
YXQgeW91IHdhbnQuDQo+PiANCj4+IA0KDQo=

