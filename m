Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C872065E255
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjAEBNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjAEBNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:13:06 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CDA7203D;
        Wed,  4 Jan 2023 17:13:05 -0800 (PST)
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3050hqWP3021051, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3050hqWP3021051
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 5 Jan 2023 08:43:52 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 5 Jan 2023 08:44:48 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 5 Jan 2023 08:44:47 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 5 Jan 2023 08:44:47 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Thread-Topic: [PATCH 2/4] rtw88: Configure the registers from rtw_bf_assoc()
 outside the RCU lock
Thread-Index: AQHZG4P4QcWaotRoLEW+JDjR+fDHVK6FAuYAgAjmpgCAARxPsA==
Date:   Thu, 5 Jan 2023 00:44:47 +0000
Message-ID: <07f52b530360452c91f3d5e405791968@realtek.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
 <20221229124845.1155429-3-martin.blumenstingl@googlemail.com>
 <70d276b911fbf3d77baf2fbd7d5a8716a01f6c2a.camel@realtek.com>
 <CAFBinCD-ygjiGuqMgHEBjfr_U67JrqHE7oxNGvT5zhCtgetK7g@mail.gmail.com>
In-Reply-To: <CAFBinCD-ygjiGuqMgHEBjfr_U67JrqHE7oxNGvT5zhCtgetK7g@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvNCDkuIvljYggMTE6Mjg6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFydGluIEJsdW1lbnN0
aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVz
ZGF5LCBKYW51YXJ5IDQsIDIwMjMgMTE6NDQgUE0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGlo
QHJlYWx0ZWsuY29tPg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBrdmFs
b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyB0b255MDYyMGVtbWFAZ21haWwu
Y29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi80XSBydHc4ODogQ29uZmlndXJlIHRoZSByZWdp
c3RlcnMgZnJvbSBydHdfYmZfYXNzb2MoKSBvdXRzaWRlIHRoZSBSQ1UgbG9jaw0KPiANCj4gSGkg
UGluZy1LZSwNCj4gDQo+IE9uIEZyaSwgRGVjIDMwLCAyMDIyIGF0IDEyOjQ4IEFNIFBpbmctS2Ug
U2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3cm90ZToNCj4gWy4uLl0NCj4gPiA+IFJldmlld2Vk
LWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IE1hcnRpbiBCbHVtZW5zdGluZ2wgPG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5j
b20+DQo+ID4NCj4gPiBJIHRoaW5rIG15IHJldmlld2VkLWJ5IHNob3VsZCBiZWhpbmQgeW91ciBz
aWduZWQtb2ZmLWJ5Lg0KPiBNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgSSBoYXZlIHRvIHB1dCB5
b3VyIFJldmlld2VkLWJ5IGFib3ZlIG15DQo+IFNpZ25lZC1vZmYtYnkgc2luY2UgSSBhZGRlZCB0
aGUgUmV2aWV3ZWQtYnkgdG8gdGhlIGRlc2NyaXB0aW9uLg0KPiBJZiB0aGUgbWFpbnRhaW5lciBh
ZGRzIHlvdXIgUmV2aWV3ZWQtYnkgd2hpbGUgYXBwbHlpbmcgdGhlIHBhdGNoIHRvDQo+IHRoZSB0
cmVlIHRoZXkgd2lsbCBwdXQgeW91ciBSZXZpZXdlZC1ieSBiZXR3ZWVuIG15IFNpZ25lZC1vZmYt
YnkgYW5kDQo+IHRoZSBtYWludGFpbmVyJ3MgU2lnbmVkLW9mZi1ieS4NCj4gDQo+IElmIHRoaXMg
aXMgaW5jb3JyZWN0IHRoZW4gcGxlYXNlIGxldCBtZSBrbm93IGFuZCBJJ2xsIGNoYW5nZSBpdCBm
b3IgdjMuDQo+IA0KDQpNeSBvcmlnaW5hbCB0aG91Z2h0IGlzIHRvIGFkZCBteSByZXZpZXdlZC1i
eSBpbiB0aGUgb3JkZXIgbGlrZSBtYWludGFpbmVyDQphcHBsaWVzIHRoZSBwYXRjaCwgYnV0IHlv
dXIgdW5kZXJzdGFuZGluZyBsb29rcyByZWFzb25hYmxlLiBTb3JyeSBmb3IgdGhlIG5vaXNlLg0K
DQpQaW5nLUtlDQoNCg==
