Return-Path: <netdev+bounces-121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CC36F5445
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 967511C20CE1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54B08F7E;
	Wed,  3 May 2023 09:15:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59D1EA5
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:15:48 +0000 (UTC)
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACC449F6;
	Wed,  3 May 2023 02:15:20 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
	by mx0.infotecs.ru (Postfix) with ESMTP id 12512108AFAA;
	Wed,  3 May 2023 12:08:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 12512108AFAA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
	t=1683104898; bh=vPxxxy7yV8868nj9fGRfvJrPnweJYozvSJXXZIINGZo=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=O0+p5usXS6dDvhwZJJh9p0mrY6Q80lT/FA3VYIZ37f6MaxjcmQMBshFwqsBI9ikjh
	 inCvROSbr4fQGrnU17RK8j+vzP55ntmQwrgMBynBwNaaPx8fqprgjfWuE7NfyD39km
	 cvIrRGeF0nAjjhFCU2juhf+qydl3gtI6d655pFqc=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
	by mx0.infotecs-nt (Postfix) with ESMTP id 095E830B3400;
	Wed,  3 May 2023 12:08:18 +0300 (MSK)
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Kuniyuki Iwashima
	<kuniyu@amazon.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"lucien.xin@gmail.com" <lucien.xin@gmail.com>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>
Subject: Re: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Thread-Topic: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Thread-Index: AQHZfRha2tve32hJCkW0xqVNIsz0zK9HEG0AgAEAqYA=
Date: Wed, 3 May 2023 09:08:17 +0000
Message-ID: <95bc9b12-9e1e-5054-c2df-ad9201d94ed5@infotecs.ru>
References: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
 <20230502170516.39760-1-kuniyu@amazon.com>
 <ZFFNLtBYepvBzoPr@t14s.localdomain>
In-Reply-To: <ZFFNLtBYepvBzoPr@t14s.localdomain>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C74EF4D003C8D4B85C674386ED3FD4C@infotecs.ru>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177140 [May 03 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_msgid_8}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/03 08:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/03 05:22:00 #21210527
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCg0K0KEg0YPQstCw0LbQtdC90LjQtdC8LA0K0JjQu9GM0Y8g0JPQsNCy0YDQuNC70L7Qsg0K
0JLQtdC00YPRidC40Lkg0L/RgNC+0LPRgNCw0LzQvNC40YHRgg0K0J7RgtC00LXQuyDRgNCw0LfR
gNCw0LHQvtGC0LrQuA0K0JDQniAi0JjQvdGE0L7QotC10JrQoSIg0LIg0LMuINCh0LDQvdC60YIt
0J/QtdGC0LXRgNCx0YPRgNCzDQoxMjcyODcsINCzLiDQnNC+0YHQutCy0LAsINCh0YLQsNGA0YvQ
uSDQn9C10YLRgNC+0LLRgdC60L4t0KDQsNC30YPQvNC+0LLRgdC60LjQuSDQv9GA0L7QtdC30LQs
INC00L7QvCAxLzIzLCDRgdGC0YAuIDENClQ6ICs3IDQ5NSA3MzctNjEtOTIgKCDQtNC+0LEuIDQ5
MjEpDQrQpDogKzcgNDk1IDczNy03Mi03OA0KDQoNCklsaWEuR2F2cmlsb3ZAaW5mb3RlY3MucnUN
Cnd3dy5pbmZvdGVjcy5ydQ0KDQoNCk9uIDUvMi8yMyAyMDo0OSwgTWFyY2VsbyBSaWNhcmRvIExl
aXRuZXIgd3JvdGU6DQo+IE9uIFR1ZSwgTWF5IDAyLCAyMDIzIGF0IDEwOjA1OjE2QU0gLTA3MDAs
IEt1bml5dWtpIEl3YXNoaW1hIHdyb3RlOg0KPj4gRnJvbTogICBHYXZyaWxvdiBJbGlhIDxJbGlh
LkdhdnJpbG92QGluZm90ZWNzLnJ1Pg0KPj4gRGF0ZTogICBUdWUsIDIgTWF5IDIwMjMgMTM6MDM6
MjQgKzAwMDANCj4+PiBUaGUgJ3NjaGVkJyBpbmRleCB2YWx1ZSBtdXN0IGJlIGNoZWNrZWQgYmVm
b3JlIGFjY2Vzc2luZyBhbiBlbGVtZW50DQo+Pj4gb2YgdGhlICdzY3RwX3NjaGVkX29wcycgYXJy
YXkuIE90aGVyd2lzZSwgaXQgY2FuIGxlYWQgdG8gYnVmZmVyIG92ZXJmbG93Lg0KPj4NCj4+IE9P
QiBhY2Nlc3MgPw0KPg0KPiBNeSB0aG91Z2h0IGFzIHdlbGwuDQo+DQoNCkknbSBzb3JyeS4gWWVz
LCBJIG1lYW50IG91dC1vZi1ib3VuZHMgYWNjZXNzLg0KDQo+PiBCdXQgaXQncyBub3QgdHJ1ZSBi
ZWNhdXNlIGl0IGRvZXMgbm90IGhhcHBlbiBpbiB0aGUgZmlyc3QgcGxhY2UuDQo+Pg0KPj4+DQo+
Pj4gTm90ZSB0aGF0IGl0J3MgaGFybWxlc3Mgc2luY2UgdGhlICdzY2hlZCcgcGFyYW1ldGVyIGlz
IGNoZWNrZWQgYmVmb3JlDQo+Pj4gY2FsbGluZyAnc2N0cF9zY2hlZF9zZXRfc2NoZWQnLg0KPj4+
DQo+Pj4gRm91bmQgYnkgSW5mb1RlQ1Mgb24gYmVoYWxmIG9mIExpbnV4IFZlcmlmaWNhdGlvbiBD
ZW50ZXINCj4+PiAobGludXh0ZXN0aW5nLm9yZykgd2l0aCBTVkFDRS4NCj4+Pg0KPj4+IEZpeGVz
OiA1YmJiYmUzMmE0MzEgKCJzY3RwOiBpbnRyb2R1Y2Ugc3RyZWFtIHNjaGVkdWxlciBmb3VuZGF0
aW9ucyIpDQo+Pj4gUmV2aWV3ZWQtYnk6IFNpbW9uIEhvcm1hbiA8c2ltb24uaG9ybWFuQGNvcmln
aW5lLmNvbT4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBJbGlhLkdhdnJpbG92IDxJbGlhLkdhdnJpbG92
QGluZm90ZWNzLnJ1Pg0KPj4+IC0tLQ0KPj4+IFYyOg0KPj4+ICAgLSBDaGFuZ2UgdGhlIG9yZGVy
IG9mIGxvY2FsIHZhcmlhYmxlcw0KPj4+ICAgLSBTcGVjaWZ5IHRoZSB0YXJnZXQgdHJlZSBpbiB0
aGUgc3ViamVjdA0KPj4+ICAgbmV0L3NjdHAvc3RyZWFtX3NjaGVkLmMgfCA5ICsrKysrLS0tLQ0K
Pj4+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4+
Pg0KPj4+IGRpZmYgLS1naXQgYS9uZXQvc2N0cC9zdHJlYW1fc2NoZWQuYyBiL25ldC9zY3RwL3N0
cmVhbV9zY2hlZC5jDQo+Pj4gaW5kZXggMzMwMDY3MDAyZGViLi40ZDA3NmE5Yjg1OTIgMTAwNjQ0
DQo+Pj4gLS0tIGEvbmV0L3NjdHAvc3RyZWFtX3NjaGVkLmMNCj4+PiArKysgYi9uZXQvc2N0cC9z
dHJlYW1fc2NoZWQuYw0KPj4+IEBAIC0xNDYsMTggKzE0NiwxOSBAQCBzdGF0aWMgdm9pZCBzY3Rw
X3NjaGVkX2ZyZWVfc2NoZWQoc3RydWN0IHNjdHBfc3RyZWFtICpzdHJlYW0pDQo+Pj4gICBpbnQg
c2N0cF9zY2hlZF9zZXRfc2NoZWQoc3RydWN0IHNjdHBfYXNzb2NpYXRpb24gKmFzb2MsDQo+Pj4g
ICAgZW51bSBzY3RwX3NjaGVkX3R5cGUgc2NoZWQpDQo+Pj4gICB7DQo+Pj4gLXN0cnVjdCBzY3Rw
X3NjaGVkX29wcyAqbiA9IHNjdHBfc2NoZWRfb3BzW3NjaGVkXTsNCj4+PiAgIHN0cnVjdCBzY3Rw
X3NjaGVkX29wcyAqb2xkID0gYXNvYy0+b3V0cXVldWUuc2NoZWQ7DQo+Pj4gICBzdHJ1Y3Qgc2N0
cF9kYXRhbXNnICptc2cgPSBOVUxMOw0KPj4+ICtzdHJ1Y3Qgc2N0cF9zY2hlZF9vcHMgKm47DQo+
Pj4gICBzdHJ1Y3Qgc2N0cF9jaHVuayAqY2g7DQo+Pj4gICBpbnQgaSwgcmV0ID0gMDsNCj4+Pg0K
Pj4+IC1pZiAob2xkID09IG4pDQo+Pj4gLXJldHVybiByZXQ7DQo+Pj4gLQ0KPj4+ICAgaWYgKHNj
aGVkID4gU0NUUF9TU19NQVgpDQo+Pj4gICByZXR1cm4gLUVJTlZBTDsNCj4+DQo+PiBJJ2QganVz
dCByZW1vdmUgdGhpcyBjaGVjayBpbnN0ZWFkIGJlY2F1c2UgdGhlIHNhbWUgdGVzdCBpcyBkb25l
DQo+PiBpbiB0aGUgY2FsbGVyIHNpZGUsIHNjdHBfc2V0c29ja29wdF9zY2hlZHVsZXIoKSwgYW5k
IHRoaXMgZXJybm8NCj4+IGlzIG5ldmVyIHJldHVybmVkLg0KPj4NCj4+IFRoaXMgdW5uZWNlc3Nh
cnkgdGVzdCBjb25mdXNlcyBhIHJlYWRlciBsaWtlIHNjaGVkIGNvdWxkIGJlIG92ZXINCj4+IFND
VFBfU1NfTUFYIGhlcmUuDQo+DQo+IEl0J3MgYWN0dWFseSBiZXR0ZXIgdG8ga2VlcCB0aGUgdGVz
dCBoZXJlIGFuZCByZW1vdmUgaXQgZnJvbSB0aGUNCj4gY2FsbGVyczogdGhleSBkb24ndCBuZWVk
IHRvIGtub3cgdGhlIHNwZWNpZmljcywgYW5kIGZ1cnRoZXIgbmV3IGNhbGxzDQo+IHdpbGwgYmUg
cHJvdGVjdGVkIGFscmVhZHkuDQo+DQoNCkkgYWdyZWUgdGhhdCB0aGUgY2hlY2sgc2hvdWxkIGJl
IHJlbW92ZWQsIGJ1dCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvDQprZWVwIHRoZSB0ZXN0IG9uIHRo
ZSBjYWxsaW5nIHNpZGUsIGJlY2F1c2UgcGFyYW1zLT5hc3NvY192YWx1ZSBpcyBzZXQgYXMNCnRo
ZSBkZWZhdWx0ICJzdHJlYW0gc2NoZWR1bGUiIGZvciB0aGUgc29ja2V0IGFuZCBpdCBuZWVkcyB0
byBiZSBjaGVja2VkIHRvby4NCg0Kc3RhdGljIGludCBzY3RwX3NldHNvY2tvcHRfc2NoZWR1bGVy
KC4uLiwgc3RydWN0IHNjdHBfYXNzb2NfdmFsdWUNCipwYXJhbXMsIC4uLikNCnsNCi4uLg0KICAg
aWYgKHBhcmFtcy0+YXNzb2NfaWQgPT0gU0NUUF9GVVRVUkVfQVNTT0MgfHwNCiAgICAgICBwYXJh
bXMtPmFzc29jX2lkID09IFNDVFBfQUxMX0FTU09DKQ0KICAgICAgIHNwLT5kZWZhdWx0X3NzID0g
cGFyYW1zLT5hc3NvY192YWx1ZTsNCi4uLg0KfQ0KDQo+Pg0KPj4gU2luY2UgdGhlIE9PQiBhY2Nl
c3MgZG9lcyBub3QgaGFwcGVuLCBJIHRoaW5rIHRoaXMgcGF0Y2ggc2hvdWxkDQo+PiBnbyB0byBu
ZXQtbmV4dCB3aXRob3V0IHRoZSBGaXhlcyB0YWcgYWZ0ZXIgdGhlIG1lcmdlIHdpbmRvdy4NCj4N
Cj4gWXVwLg0KPg0KPj4NCj4+IFRoYW5rcywNCj4+IEt1bml5dWtpDQo+Pg0KPj4NCj4+Pg0KPj4+
ICtuID0gc2N0cF9zY2hlZF9vcHNbc2NoZWRdOw0KPj4+ICtpZiAob2xkID09IG4pDQo+Pj4gK3Jl
dHVybiByZXQ7DQo+Pj4gKw0KPj4+ICAgaWYgKG9sZCkNCj4+PiAgIHNjdHBfc2NoZWRfZnJlZV9z
Y2hlZCgmYXNvYy0+c3RyZWFtKTsNCj4+Pg0KPj4+IC0tDQo+Pj4gMi4zMC4yDQoNCg==

