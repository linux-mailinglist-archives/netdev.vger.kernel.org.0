Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0624C659363
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 00:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiL2Xsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 18:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbiL2Xsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 18:48:43 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD6729590;
        Thu, 29 Dec 2022 15:48:42 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BTNlYY81026617, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BTNlYY81026617
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 30 Dec 2022 07:47:34 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 30 Dec 2022 07:48:29 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 30 Dec 2022 07:48:28 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 30 Dec 2022 07:48:28 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Thread-Topic: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc()
 outside the RCU lock
Thread-Index: AQHZG4P4QcWaotRoLEW+JDjR+fDHVK6FAuYA
Date:   Thu, 29 Dec 2022 23:48:28 +0000
Message-ID: <70d276b911fbf3d77baf2fbd7d5a8716a01f6c2a.camel@realtek.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
         <20221229124845.1155429-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221229124845.1155429-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.22.50]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI5IOS4i+WNiCAwNzozNDowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <89829913CD482440811018E42C7294B0@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTI5IGF0IDEzOjQ4ICswMTAwLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBVU0IgYW5kICh1cGNvbWluZykgU0RJTyBzdXBwb3J0IG1heSBzbGVlcCBpbiB0aGUg
cmVhZC93cml0ZSBoYW5kbGVycy4NCj4gU2hyaW5rIHRoZSBSQ1UgY3JpdGljYWwgc2VjdGlvbiBz
byBpdCBvbmx5IGNvdmVyIHRoZSBjYWxsIHRvDQo+IGllZWU4MDIxMV9maW5kX3N0YSgpIGFuZCBm
aW5kaW5nIHRoZSBpY192aHRfY2FwL3ZodF9jYXAgYmFzZWQgb24gdGhlDQo+IGZvdW5kIHN0YXRp
b24uIFRoaXMgbW92ZXMgdGhlIGNoaXAncyBCRkVFIGNvbmZpZ3VyYXRpb24gb3V0c2lkZSB0aGUN
Cj4gcmN1X3JlYWRfbG9jayBzZWN0aW9uIGFuZCB0aHVzIHByZXZlbnQgInNjaGVkdWxpbmcgd2hp
bGUgYXRvbWljIiBvcg0KPiAiVm9sdW50YXJ5IGNvbnRleHQgc3dpdGNoIHdpdGhpbiBSQ1UgcmVh
ZC1zaWRlIGNyaXRpY2FsIHNlY3Rpb24hIg0KPiB3YXJuaW5ncyB3aGVuIGFjY2Vzc2luZyB0aGUg
cmVnaXN0ZXJzIHVzaW5nIGFuIFNESU8gY2FyZCAod2hpY2ggaXMNCj4gd2hlcmUgdGhpcyBpc3N1
ZSBoYXMgYmVlbiBzcG90dGVkIGluIHRoZSByZWFsIHdvcmxkIC0gYnV0IGl0IGFsc28NCj4gYWZm
ZWN0cyBVU0IgY2FyZHMpLg0KPiANCj4gUmV2aWV3ZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGlo
QHJlYWx0ZWsuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gQmx1bWVuc3RpbmdsIDxtYXJ0
aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tPg0KDQpJIHRoaW5rIG15IHJldmlld2VkLWJ5
IHNob3VsZCBiZWhpbmQgeW91ciBzaWduZWQtb2ZmLWJ5Lg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9iZi5jIHwgMTMgKysrKysrKy0tLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L2JmLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L2JmLmMNCj4gaW5kZXggMDM4YTMwYjE3MGVmLi5j
ODI3YzRhMjgxNGIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvYmYuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L2Jm
LmMNCj4gQEAgLTQ5LDE5ICs0OSwyMyBAQCB2b2lkIHJ0d19iZl9hc3NvYyhzdHJ1Y3QgcnR3X2Rl
diAqcnR3ZGV2LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLA0KPiAgDQo+ICAJc3RhID0gaWVl
ZTgwMjExX2ZpbmRfc3RhKHZpZiwgYnNzaWQpOw0KPiAgCWlmICghc3RhKSB7DQo+ICsJCXJjdV9y
ZWFkX3VubG9jaygpOw0KPiArDQo+ICAJCXJ0d193YXJuKHJ0d2RldiwgImZhaWxlZCB0byBmaW5k
IHN0YXRpb24gZW50cnkgZm9yIGJzcyAlcE1cbiIsDQo+ICAJCQkgYnNzaWQpOw0KPiAtCQlnb3Rv
IG91dF91bmxvY2s7DQo+ICsJCXJldHVybjsNCj4gIAl9DQo+ICANCj4gIAlpY192aHRfY2FwID0g
Jmh3LT53aXBoeS0+YmFuZHNbTkw4MDIxMV9CQU5EXzVHSFpdLT52aHRfY2FwOw0KPiAgCXZodF9j
YXAgPSAmc3RhLT5kZWZsaW5rLnZodF9jYXA7DQo+ICANCj4gKwlyY3VfcmVhZF91bmxvY2soKTsN
Cj4gKw0KPiAgCWlmICgoaWNfdmh0X2NhcC0+Y2FwICYgSUVFRTgwMjExX1ZIVF9DQVBfTVVfQkVB
TUZPUk1FRV9DQVBBQkxFKSAmJg0KPiAgCSAgICAodmh0X2NhcC0+Y2FwICYgSUVFRTgwMjExX1ZI
VF9DQVBfTVVfQkVBTUZPUk1FUl9DQVBBQkxFKSkgew0KPiAgCQlpZiAoYmZpbmZvLT5iZmVyX211
X2NudCA+PSBjaGlwLT5iZmVyX211X21heF9udW0pIHsNCj4gIAkJCXJ0d19kYmcocnR3ZGV2LCBS
VFdfREJHX0JGLCAibXUgYmZlciBudW1iZXIgb3ZlciBsaW1pdFxuIik7DQo+IC0JCQlnb3RvIG91
dF91bmxvY2s7DQo+ICsJCQlyZXR1cm47DQo+ICAJCX0NCj4gIA0KPiAgCQlldGhlcl9hZGRyX2Nv
cHkoYmZlZS0+bWFjX2FkZHIsIGJzc2lkKTsNCj4gQEAgLTc1LDcgKzc5LDcgQEAgdm9pZCBydHdf
YmZfYXNzb2Moc3RydWN0IHJ0d19kZXYgKnJ0d2Rldiwgc3RydWN0IGllZWU4MDIxMV92aWYgKnZp
ZiwNCj4gIAkJICAgKHZodF9jYXAtPmNhcCAmIElFRUU4MDIxMV9WSFRfQ0FQX1NVX0JFQU1GT1JN
RVJfQ0FQQUJMRSkpIHsNCj4gIAkJaWYgKGJmaW5mby0+YmZlcl9zdV9jbnQgPj0gY2hpcC0+YmZl
cl9zdV9tYXhfbnVtKSB7DQo+ICAJCQlydHdfZGJnKHJ0d2RldiwgUlRXX0RCR19CRiwgInN1IGJm
ZXIgbnVtYmVyIG92ZXIgbGltaXRcbiIpOw0KPiAtCQkJZ290byBvdXRfdW5sb2NrOw0KPiArCQkJ
cmV0dXJuOw0KPiAgCQl9DQo+ICANCj4gIAkJc291bmRfZGltID0gdmh0X2NhcC0+Y2FwICYNCj4g
QEAgLTk4LDkgKzEwMiw2IEBAIHZvaWQgcnR3X2JmX2Fzc29jKHN0cnVjdCBydHdfZGV2ICpydHdk
ZXYsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsDQo+ICANCj4gIAkJcnR3X2NoaXBfY29uZmln
X2JmZWUocnR3ZGV2LCBydHd2aWYsIGJmZWUsIHRydWUpOw0KPiAgCX0NCj4gLQ0KPiAtb3V0X3Vu
bG9jazoNCj4gLQlyY3VfcmVhZF91bmxvY2soKTsNCj4gIH0NCj4gIA0KPiAgdm9pZCBydHdfYmZf
aW5pdF9iZmVyX2VudHJ5X211KHN0cnVjdCBydHdfZGV2ICpydHdkZXYsDQo=
