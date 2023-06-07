Return-Path: <netdev+bounces-8838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93190725F81
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D665281439
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD548BEE;
	Wed,  7 Jun 2023 12:32:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DCE35B3C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:32:18 +0000 (UTC)
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5FCE62;
	Wed,  7 Jun 2023 05:32:16 -0700 (PDT)
From: "Duan,Muquan" <duanmuquan@baidu.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] tcp: fix connection reset due to tw hashdance race.
Thread-Topic: [PATCH v1] tcp: fix connection reset due to tw hashdance race.
Thread-Index: AQHZl2EOPgCVvIYh+EyVtuZIPXSv7q989RIAgAHFnQA=
Date: Wed, 7 Jun 2023 12:01:23 +0000
Message-ID: <A280D6B1-6CAE-4255-9542-21268D9F8997@baidu.com>
References: <20230605035140.89106-1-duanmuquan@baidu.com>
 <ZH71DvVRewnmRdC9@corigine.com>
In-Reply-To: <ZH71DvVRewnmRdC9@corigine.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.22.196.162]
Content-Type: text/plain; charset="utf-8"
Content-ID: <26401C5E3F057C4DBF421F6F2C8CB3FE@internal.baidu.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.56
X-FE-Last-Public-Client-IP: 100.100.100.49
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGksIFNpbW9uLA0KDQpUaGFuayB5b3UgZm9yIHBvaW50aW5nIG91dCB0aGUgZXJyb3IsIEkgd2ls
bCBjb3JyZWN0IGl0IGluIG5leHQgcGF0Y2guDQoNCkJlc3QgUmVnYXJkcyENCkR1YW4NCg0KPiAy
MDIz5bm0NuaciDbml6Ug5LiL5Y2INDo1N++8jFNpbW9uIEhvcm1hbiA8c2ltb24uaG9ybWFuQGNv
cmlnaW5lLmNvbT4g5YaZ6YGT77yaDQo+IA0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAxMTo1
MTo0MEFNICswODAwLCBEdWFuIE11cXVhbiB3cm90ZToNCj4gDQo+IC4uLg0KPiANCj4+IEJyaWVm
IG9mIHRoZSBzY2VuYXJpbzoNCj4+IA0KPj4gMS4gU2VydmVyIHJ1bnMgb24gQ1BVIDAgYW5kIENs
aWVudCBydW5zIG9uIENQVSAxLiBTZXJ2ZXIgY2xvc2VzDQo+PiBjb25uZWN0aW9uIGFjdGl2ZWx5
IGFuZCBzZW5kcyBhIEZJTiB0byBjbGllbnQuIFRoZSBsb29rYmFjaydzIGRyaXZlcg0KPj4gZW5x
dWV1ZXMgdGhlIEZJTiBzZWdtZW50IHRvIGJhY2tsb2cgcXVldWUgb2YgQ1BVIDAgdmlhDQo+PiBs
b29wYmFja194bWl0KCktPm5ldGlmX3J4KCksIG9uZSBvZiB0aGUgY29uZGl0aW9ucyBmb3Igbm9u
LWRlbGF5IGFjaw0KPj4gbWVldHMgaW4gX190Y3BfYWNrX3NuZF9jaGVjaygpLCBhbmQgdGhlIEFD
SyBpcyBzZW50IGltbWVkaWF0ZWx5Lg0KPj4gDQo+PiAyLiBPbiBsb29wYmFjayBpbnRlcmZhY2Us
IHRoZSBBQ0sgaXMgcmVjZWl2ZWQgYW5kIHByb2Nlc3NlZCBvbiBDUFUgMCwNCj4+IHRoZSAnZGFu
Y2UnIGZyb20gb3JpZ2luYWwgc29jayB0byB0dyBzb2NrIHdpbGwgcGVyZnJvbSwgdHcgc29jayB3
aWxsDQo+IA0KPiBIaSBEdWFuIE11cXVhbiwNCj4gDQo+IGEgbWlub3Igbml0IGZyb20gbXkgc2lk
ZTogcGVyZnJvbSAtPiBwZXJmb3JtDQo+IA0KPj4gYmUgaW5zZXJ0ZWQgdG8gZWhhc2ggdGFibGUs
IHRoZW4gdGhlIG9yaWdpbmFsIHNvY2sgd2lsbCBiZSByZW1vdmVkLg0KPiANCj4gLi4uDQoNCg==

