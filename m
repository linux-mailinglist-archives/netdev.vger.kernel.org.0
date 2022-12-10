Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC5648EDB
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLJNRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJNRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:17:34 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F217AB7D2;
        Sat, 10 Dec 2022 05:17:32 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BADEXm44001842, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BADEXm44001842
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Sat, 10 Dec 2022 21:14:33 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Sat, 10 Dec 2022 21:15:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Sat, 10 Dec 2022 21:15:21 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Sat, 10 Dec 2022 21:15:21 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lizetao1@huawei.com" <lizetao1@huawei.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Thread-Topic: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in
 _rtl8812ae_phy_set_txpower_limit()
Thread-Index: AQHZCkbbXqqj5E4pa0em0g/eG4ORkq5lAS7wgAGPU4CAAAd3AA==
Date:   Sat, 10 Dec 2022 13:15:20 +0000
Message-ID: <4b0f5ddb6d5ccc2785f9c4e9f97eadd06a945ed7.camel@realtek.com>
References: <20221207152319.3135500-1-lizetao1@huawei.com>
         <e985ead3ea7841b8b3a94201dfb18776@realtek.com>
         <40c4ace2-68f3-5e7d-2e68-7ea36a104a28@huawei.com>
In-Reply-To: <40c4ace2-68f3-5e7d-2e68-7ea36a104a28@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [125.224.72.88]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzEwIOS4i+WNiCAxMjoyNTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <026CA66E1C85B140B5ACD3AC79F5F84E@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIyLTEyLTEwIGF0IDIwOjQ3ICswODAwLCBMaSBaZXRhbyB3cm90ZToNCj4gSGkg
UGluZy1LZSwNCj4gDQo+IE9uIDIwMjIvMTIvOSAxMzoxMSwgUGluZy1LZSBTaGloIHdyb3RlOg0K
PiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IExpIFpldGFvIDxs
aXpldGFvMUBodWF3ZWkuY29tPg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciA3LCAy
MDIyIDExOjIzIFBNDQo+ID4gPiBUbzogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+
OyBrdmFsb0BrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyANCj4gPiA+IGVkdW1hemV0
QGdvb2dsZS5jb207DQo+ID4gPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tDQo+
ID4gPiBDYzogbGl6ZXRhbzFAaHVhd2VpLmNvbTsgTGFycnkuRmluZ2VyQGx3ZmluZ2VyLm5ldDsg
bGludmlsbGVAdHV4ZHJpdmVyLmNvbTsNCj4gPiA+IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVs
Lm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiA+ID4gU3ViamVjdDogW1BBVENIXSBydGx3aWZpOiBydGw4ODIxYWU6IEZpeCBnbG9iYWwt
b3V0LW9mLWJvdW5kcyBidWcgaW4NCj4gPiA+IF9ydGw4ODEyYWVfcGh5X3NldF90eHBvd2VyX2xp
bWl0KCkNCj4gPiA+IA0KPiA+ID4gVGhlcmUgaXMgYSBnbG9iYWwtb3V0LW9mLWJvdW5kcyByZXBv
cnRlZCBieSBLQVNBTjoNCj4gPiA+IA0KPiA+ID4gICAgQlVHOiBLQVNBTjogZ2xvYmFsLW91dC1v
Zi1ib3VuZHMgaW4NCj4gPiA+ICAgIF9ydGw4ODEyYWVfZXFfbl9ieXRlLnBhcnQuMCsweDNkLzB4
ODQgW3J0bDg4MjFhZV0NCj4gPiA+ICAgIFJlYWQgb2Ygc2l6ZSAxIGF0IGFkZHIgZmZmZmZmZmZh
MDc3M2M0MyBieSB0YXNrIE5ldHdvcmtNYW5hZ2VyLzQxMQ0KPiA+ID4gDQo+ID4gPiAgICBDUFU6
IDYgUElEOiA0MTEgQ29tbTogTmV0d29ya01hbmFnZXIgVGFpbnRlZDogRyAgICAgIEQNCj4gPiA+
ICAgIDYuMS4wLXJjOCsgIzE0NCBlMTU1ODg1MDg1MTcyNjdkMzcNCj4gPiA+ICAgIEhhcmR3YXJl
IG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKFEzNSArIElDSDksIDIwMDkpLA0KPiA+ID4gICAgQ2Fs
bCBUcmFjZToNCj4gPiA+ICAgICA8VEFTSz4NCj4gPiA+ICAgICAuLi4NCj4gPiA+ICAgICBrYXNh
bl9yZXBvcnQrMHhiYi8weDFjMA0KPiA+ID4gICAgIF9ydGw4ODEyYWVfZXFfbl9ieXRlLnBhcnQu
MCsweDNkLzB4ODQgW3J0bDg4MjFhZV0NCj4gPiA+ICAgICBydGw4ODIxYWVfcGh5X2JiX2NvbmZp
Zy5jb2xkKzB4MzQ2LzB4NjQxIFtydGw4ODIxYWVdDQo+ID4gPiAgICAgcnRsODgyMWFlX2h3X2lu
aXQrMHgxZjVlLzB4NzliMCBbcnRsODgyMWFlXQ0KPiA+ID4gICAgIC4uLg0KPiA+ID4gICAgIDwv
VEFTSz4NCj4gPiA+IA0KPiA+ID4gVGhlIHJvb3QgY2F1c2Ugb2YgdGhlIHByb2JsZW0gaXMgdGhh
dCB0aGUgY29tcGFyaXNvbiBvcmRlciBvZg0KPiA+ID4gInByYXRlX3NlY3Rpb24iIGluIF9ydGw4
ODEyYWVfcGh5X3NldF90eHBvd2VyX2xpbWl0KCkgaXMgd3JvbmcuIFRoZQ0KPiA+ID4gX3J0bDg4
MTJhZV9lcV9uX2J5dGUoKSBpcyB1c2VkIHRvIGNvbXBhcmUgdGhlIGZpcnN0IG4gYnl0ZXMgb2Yg
dGhlIHR3bw0KPiA+ID4gc3RyaW5ncywgc28gdGhpcyByZXF1aXJlcyB0aGUgbGVuZ3RoIG9mIHRo
ZSB0d28gc3RyaW5ncyBiZSBncmVhdGVyDQo+ID4gPiB0aGFuIG9yIGVxdWFsIHRvIG4uIEluIHRo
ZSAgX3J0bDg4MTJhZV9waHlfc2V0X3R4cG93ZXJfbGltaXQoKSwgaXQgd2FzDQo+ID4gPiBvcmln
aW5hbGx5IGludGVuZGVkIHRvIG1lZXQgdGhpcyByZXF1aXJlbWVudCBieSBjYXJlZnVsbHkgZGVz
aWduaW5nDQo+ID4gPiB0aGUgY29tcGFyaXNvbiBvcmRlci4gRm9yIGV4YW1wbGUsICJwcmVndWxh
dGlvbiIgYW5kICJwYmFuZHdpZHRoIiBhcmUNCj4gPiA+IGNvbXBhcmVkIGluIG9yZGVyIG9mIGxl
bmd0aCBmcm9tIHNtYWxsIHRvIGxhcmdlLCBmaXJzdCBpcyAzIGFuZCBsYXN0DQo+ID4gPiBpcyA0
LiBIb3dldmVyLCB0aGUgY29tcGFyaXNvbiBvcmRlciBvZiAicHJhdGVfc2VjdGlvbiIgZG9zZSBu
b3Qgb2JleQ0KPiA+ID4gc3VjaCBvcmRlciByZXF1aXJlbWVudCwgdGhlcmVmb3JlIHdoZW4gInBy
YXRlX3NlY3Rpb24iIGlzICJIVCIsIGl0IHdpbGwNCj4gPiA+IGxlYWQgdG8gYWNjZXNzIG91dCBv
ZiBib3VuZHMgaW4gX3J0bDg4MTJhZV9lcV9uX2J5dGUoKS4NCj4gPiA+IA0KPiA+ID4gRml4IGl0
IGJ5IGFkZGluZyBhIGxlbmd0aCBjaGVjayBpbiBfcnRsODgxMmFlX2VxX25fYnl0ZSgpLiBBbHRo
b3VnaCBpdA0KPiA+ID4gY2FuIGJlIGZpeGVkIGJ5IGFkanVzdGluZyB0aGUgY29tcGFyaXNvbiBv
cmRlciBvZiAicHJhdGVfc2VjdGlvbiIsIHRoaXMNCj4gPiA+IG1heSBjYXVzZSB0aGUgdmFsdWUg
b2YgInJhdGVfc2VjdGlvbiIgdG8gbm90IGJlIGZyb20gMCB0byA1LiBJbg0KPiA+ID4gYWRkaXRp
b24sIGNvbW1pdCAiMjFlNGIwNzI2ZGM2IiBub3Qgb25seSBtb3ZlZCBkcml2ZXIgZnJvbSBzdGFn
aW5nIHRvDQo+ID4gPiByZWd1bGFyIHRyZWUsIGJ1dCBhbHNvIGFkZGVkIHNldHRpbmcgdHhwb3dl
ciBsaW1pdCBmdW5jdGlvbiBkdXJpbmcgdGhlDQo+ID4gPiBkcml2ZXIgY29uZmlnIHBoYXNlLCBz
byB0aGUgcHJvYmxlbSB3YXMgaW50cm9kdWNlZCBieSB0aGlzIGNvbW1pdC4NCj4gPiA+IA0KPiA+
ID4gRml4ZXM6IDIxZTRiMDcyNmRjNiAoInJ0bHdpZmk6IHJ0bDg4MjFhZTogTW92ZSBkcml2ZXIg
ZnJvbSBzdGFnaW5nIHRvIHJlZ3VsYXIgdHJlZSIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMaSBa
ZXRhbyA8bGl6ZXRhbzFAaHVhd2VpLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gICBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgyMWFlL3BoeS5jIHwgMiArLQ0KPiA+ID4g
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+IA0K
PiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9y
dGw4ODIxYWUvcGh5LmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL3J0bDg4MjFhZS9waHkuYw0KPiA+ID4gaW5kZXggYTI5MzIxZTJmYTcyLi43MjAxMTRhOWRk
YjIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcnRsODgyMWFlL3BoeS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvcnRsODgyMWFlL3BoeS5jDQo+ID4gPiBAQCAtMTYwMCw3ICsxNjAwLDcgQEAg
c3RhdGljIGJvb2wgX3J0bDg4MTJhZV9nZXRfaW50ZWdlcl9mcm9tX3N0cmluZyhjb25zdCBjaGFy
ICpzdHIsIHU4DQo+ID4gPiAqcGludCkNCj4gPiA+IA0KPiA+ID4gICBzdGF0aWMgYm9vbCBfcnRs
ODgxMmFlX2VxX25fYnl0ZShjb25zdCBjaGFyICpzdHIxLCBjb25zdCBjaGFyICpzdHIyLCB1MzIg
bnVtKQ0KPiA+ID4gICB7DQo+ID4gVGhpcyBjYW4gY2F1c2VzIHByb2JsZW0gYmVjYXVzZSBpdCBj
b21wYXJlcyBjaGFyYWN0ZXJzIGZyb20gdGFpbCB0byBoZWFkLCBhbmQNCj4gPiB3ZSBjYW4ndCBz
aW1wbHkgcmVwbGFjZSB0aGlzIGJ5IHN0cm5jbXAoKSB0aGF0IGRvZXMgc2ltaWxhciB3b3JrLiBC
dXQsIEkgYWxzbw0KPiA+IGRvbid0IGxpa2Ugc3RybGVuKCkgdG8gbG9vcCAnc3RyMScgY29uc3Rh
bnRseS4NCj4gPiANCj4gPiBIb3cgYWJvdXQgaGF2aW5nIGEgc2ltcGxlIGxvb3AgdG8gY29tcGFy
ZSBjaGFyYWN0ZXJzIGZvcndhcmQ6DQo+ID4gDQo+ID4gZm9yIChpID0gMDsgaSA8IG51bTsgaSsr
KQ0KPiA+ICAgICAgaWYgKHN0cjFbaV0gIT0gc3RyMltpXSkNCj4gPiAgICAgICAgICAgcmV0dXJu
IGZhbHNlOw0KPiA+IA0KPiA+IHJldHVybiB0cnVlOw0KPiANCj4gVGhhbmtzIGZvciB5b3VyIGNv
bW1lbnQsIGJ1dCBJIGRvbid0IHRoaW5rIHRoZSBwcm9ibGVtIGhhcyBhbnl0aGluZyB0byANCj4g
ZG8gd2l0aCBoZWFkLXRvLXRhaWwgb3INCj4gDQo+IHRhaWwtdG8taGVhZCBjb21wYXJpc29uLiBU
aGUgcHJvYmxlbSBpcyB0aGF0IG51bSBpcyB0aGUgbGVuZ3RoIG9mIHN0cjIsIA0KPiBidXQgdGhl
IGxlbmd0aCBvZiBzdHIxIG1heQ0KPiANCj4gYmUgbGVzcyB0aGFuIG51bSwgd2hpY2ggbWF5IGxl
YWQgdG8gcmVhZGluZyBzdHIxIG91dCBvZiBib3VuZHMsIGZvciANCj4gZXhhbXBsZSwgd2hlbiBj
b21wYXJpbmcNCj4gDQo+ICJwcmF0ZV9zZWN0aW9uIiwgc3RyMSBtYXkgYmUgIkhUIiwgd2hpbGUg
c3RyMiBtYXkgYnkgIkNDSyIsIGFuZCBudW0gaXMgDQo+IDMuIFNvIEkgdGhpbmsgaXQgaXMgbmVj
Y3NzYXJ5DQo+IA0KPiB0byBjaGVjayB0aGUgbGVuZ3RoIG9mIHN0cjEgdG8gZW5zdXJlIHRoYXQg
d2lsbCBub3QgcmVhZCBvdXQgb2YgYm91bmRzLg0KPiANCg0KSSBrbm93IHlvdXIgcG9pbnQsIGFu
ZCBJIGJlbGlldmUgeW91ciBwYXRjaCBjYW4gd29yayB3ZWxsLCBidXQgSSB3b3VsZCBsaWtlDQp0
byBoYXZlIHNpbXBsZSBjb2RlIHRoYXQgY2FuIHNvbHZlIHRoaXMgc3BlY2lmaWMgcHJvYmxlbS4N
Cg0KU2luY2UgYm90aCBzdHIxIGFuZCBzdHIyIGFyZSBudWxsLXRlcm1pbmF0b3Igc3RyaW5ncywg
c28gc3RyMVsyXT0nXDAnIGlzDQphY2Nlc3NpYmxlIGlmIHN0cjE9IkhUIiwgcmlnaHQ/IFRoZW4s
IGlmIGxlbmd0aCBvZiBzdHIxIGFuZCBzdHIyIGlzDQpkaWZmZXJlbnQsIG51bGwtdGVybWluYXRv
ciBjYW4gaGVscCB0byBicmVhayBoZWFkLXRvLXRhaWwgbG9vcC4NCg0KVGFrZSAiMTIiIGFuZCAi
MTIzNCIgYXMgYW4gZXhhbXBsZToNClRoZW4sIG51bT00LA0KDQpoZWFkLXRvLXRhaWwgICAgICAg
ICAgICAgICAgdGFpbC10by1oZWFkDQotLS0tLS0tLS0tLS0tLS0tLS0tICAgICAgICAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpzdHIxWzBdID09IHN0
cjJbMF0gICAgICAgICAgc3RyMVszXSA+PCBzdHIyWzNdICAgKHN0cjFbM10gaXMgaW5hY2Nlc3Np
YmxlKQ0Kc3RyMVsxXSA9PSBzdHIyWzFdDQpzdHIxWzJdICE9IHN0cjJbMl0NCg0KDQpJIGhvcGUg
dGhpcyBjYW4gaGVscCB0byBleHBsYWluIG15IHBvaW50Lg0KDQoNCkFmdGVyIEkgdGhpbmsgZGVl
cGVyLCBpdCBzZWVtcyBsaWtlIHRoaXJkIHBhcmFtZXRlciAndTMyIG51bScgaXNuJ3QgbmVjZXNz
YXJ5LA0KYW5kIHRoZW4ganVzdCBzdHJjbXAoc3RyMSwgc3RyMikgaXMgZW5vdWdoLg0KDQpQaW5n
LUtlDQoNCg0K
