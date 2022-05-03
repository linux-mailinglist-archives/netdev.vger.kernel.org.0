Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA573517CCA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 07:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiECFRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 01:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiECFRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 01:17:40 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C843EF37
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 22:14:08 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 969992C023A;
        Tue,  3 May 2022 05:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651554845;
        bh=uXLsApaTeOe74BqVE4TAhpLEbo2upZzqfmVhXsR58nA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=hFeZgBM9wPyD46dgSsAkN681YB1INZ7HzMNKIazfLF200AN15dLbNAjWqGkrSfDsB
         K7iOH28R5SJ52SZ6FbB+k4mThX+m6/ZBAeke2Y6cGPvqBD7gqNhK1oFl7LR2uNTUPp
         PILD2b14F0jfaa1INF96Qn/M+mOW5e/yYY3N+Ge9powgBdT8/MrK0WjM5kNKUzzyI9
         KFg3+XGRICDem5V6OuR/Mam5KEOJuuoD3FR72otuIQD8vShvfDuhrSOgQdlCkzkdp7
         3QUEvt2fPBW5KHwe6KviLfluzskQUck6s3w94WF3yJvDeVW+zqjl1KeOvJTHtFQB6q
         brbUj6/uUoOOw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6270ba1d0001>; Tue, 03 May 2022 17:14:05 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 3 May 2022 17:14:05 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Tue, 3 May 2022 17:14:05 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Lokesh Dhoundiyal <Lokesh.Dhoundiyal@alliedtelesis.co.nz>,
        "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Regarding _skb_refdst memory alloc/dealloc
Thread-Topic: Regarding _skb_refdst memory alloc/dealloc
Thread-Index: AQHYXqyb1UtYAHq8hUG4DXsiYkLvkA==
Date:   Tue, 3 May 2022 05:14:05 +0000
Message-ID: <3bfb736b-9964-5543-434e-2f7452674920@alliedtelesis.co.nz>
References: <53f2dbc3-3562-6d91-978e-63392010a668@alliedtelesis.co.nz>
In-Reply-To: <53f2dbc3-3562-6d91-978e-63392010a668@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD0A93F76FB9C44DBA90BF308E528ECB@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=NZKYDc1SXFvqZeSGMLcA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KyBEYXZlIGFuZCBXZW4NCg0KT24gMy8wNS8yMiAxNToxMCwgTG9rZXNoIERob3VuZGl5YWwgd3Jv
dGU6DQoNCj4gSGksDQo+DQo+IEkgaGF2ZSB0aGUgdHVubmVsIGRlc3RpbmF0aW9uIGVudHJ5IHNl
dCB2aWEgc2tiX2RzdF9zZXQgaW5zaWRlDQo+IGlwX3R1bm5lbF9yY3YuIEkgd2lzaCB0byByZWxl
YXNlIHRoZSBtZW1vcnkgcmVmZXJlbmNlZCBieQ0KPiBza2ItPl9za2JfcmVmZHN0IGFmdGVyIHVz
ZS4NCj4NCj4gQ291bGQgeW91IHBsZWFzZSBhZHZpc2UgdGhlIGFwaSB0byB1c2UgZm9yIGl0LiBJ
IGFtIGFzc3VtaW5nIHRoYXQgaXQgaXMNCj4gc2tiX2RzdF9kcm9wLCBJcyB0aGF0IGNvcnJlY3Q/
DQoNCkEgYml0IG1vcmUgY29udGV4dC4gV2UndmUgYmVlbiBzZWVpbmcgYSBtZW1vcnkgbGVhayB0
aGF0IHNlZW1zIHRvIGhhdmUgDQphcHBlYXJlZCB3aGVuIHdlIHVwZGF0ZWQgb3VyIExpbnV4IGtl
cm5lbCBmcm9tIHY0LjQuMTYgdG8gdjUuNy4xOS4gVGhlIA0KdGVzdCBzY2VuYXJpbyBpbnZvbHZl
cyBsZWFybmluZyBPU1BGIHJvdXRlcyBvdmVyIGEgdHVubmVsLiBJIGRvbid0IA0KaW1hZ2luZSB0
aGVyZSdzIGFueXRoaW5nIHBhcnRpY3VsYXJseSBzcGVjaWFsIGFib3V0IE9TRlAganVzdCB0aGF0
IGl0IA0KdXNlcyBtdWx0aWNhc3QgdHJhZmZpYyB0byBjb21tdW5pY2F0ZS4NCg0KU29tZSBkZWJ1
Z2dpbmcgcG9pbnRlZCB1cyBhdCB0aGUga21hbGxvYy0yNTYgc2xhYiBhbmQga21lbWxlYWsgc2Vl
bWVkIHRvIA0KY29uZmlybSB0aGUgc3VzcGljaW9uLg0KDQp1bnJlZmVyZW5jZWQgb2JqZWN0IDB4
ODAwMDAwMDA0NGJlYjkwMCAoc2l6ZSAyNTYpOg0KIMKgIGNvbW0gInNvZnRpcnEiLCBwaWQgMCwg
amlmZmllcyA0Mjk0OTg0NDU1IChhZ2UgMzUuOTgwcykNCiDCoCBoZXggZHVtcCAoZmlyc3QgMzIg
Ynl0ZXMpOg0KIMKgwqDCoCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCA4MCAwMCAwMCAwMCAwNSAx
MyA3NCA4MCAuLi4uLi4uLi4uLi4uLnQuDQogwqDCoMKgIDgwIDAwIDAwIDAwIDA0IDliIGJmIGY5
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIC4uLi4uLi4uLi4uLi4uLi4NCiDCoCBiYWNrdHJhY2U6
DQogwqDCoMKgIFs8MDAwMDAwMDBmODM5NDdlMD5dIF9fa21hbGxvYysweDFlOC8weDMwMA0KIMKg
wqDCoCBbPDAwMDAwMDAwYjdlZDhkY2E+XSBtZXRhZGF0YV9kc3RfYWxsb2MrMHgyNC8weDU4DQog
wqDCoMKgIFs8MDAwMDAwMDA4MWQzMmMyMD5dIF9faXBncmVfcmN2KzB4MTAwLzB4MmI4DQogwqDC
oMKgIFs8MDAwMDAwMDA4MjRmNmNmMT5dIGdyZV9yY3YrMHgxNzgvMHg1NDANCiDCoMKgwqAgWzww
MDAwMDAwMGNjZDRlMTYyPl0gZ3JlX3JjdisweDdjLzB4ZDgNCiDCoMKgwqAgWzwwMDAwMDAwMGMw
MjRiMTQ4Pl0gaXBfcHJvdG9jb2xfZGVsaXZlcl9yY3UrMHgxMjQvMHgzNTANCiDCoMKgwqAgWzww
MDAwMDAwMDZhNDgzMzc3Pl0gaXBfbG9jYWxfZGVsaXZlcl9maW5pc2grMHg1NC8weDY4DQogwqDC
oMKgIFs8MDAwMDAwMDBkOTI3MWIzYT5dIGlwX2xvY2FsX2RlbGl2ZXIrMHgxMjgvMHgxNjgNCiDC
oMKgwqAgWzwwMDAwMDAwMGJkNDk2OGFlPl0geGZybV90cmFuc19yZWluamVjdCsweGI4LzB4ZjgN
CiDCoMKgwqAgWzwwMDAwMDAwMDcxNjcyYTE5Pl0gdGFza2xldF9hY3Rpb25fY29tbW9uLmlzcmEu
MTYrMHhjNC8weDFiMA0KIMKgwqDCoCBbPDAwMDAwMDAwNjJlOWMzMzY+XSBfX2RvX3NvZnRpcnEr
MHgxZmMvMHgzZTANCiDCoMKgwqAgWzwwMDAwMDAwMDAxM2Q3OTE0Pl0gaXJxX2V4aXQrMHhjNC8w
eGUwDQogwqDCoMKgIFs8MDAwMDAwMDBhNGQ3M2U5MD5dIHBsYXRfaXJxX2Rpc3BhdGNoKzB4N2Mv
MHgxMDgNCiDCoMKgwqAgWzwwMDAwMDAwMDA3NTFlYjhlPl0gaGFuZGxlX2ludCsweDE2Yy8weDE3
OA0KIMKgwqDCoCBbPDAwMDAwMDAwYTBjNDNiM2U+XSBwdXRfb2JqZWN0KzB4MjAvMHhkOA0KIMKg
wqDCoCBbPDAwMDAwMDAwOTQzOWFjYmI+XSBzY2FuX2dyYXlfbGlzdCsweDE4Yy8weDI2OA0KDQpJ
dCBhcHBlYXJzIHRoYXQgdGhlIGxlYWsgaXMgZHVlIHRvIGNvbW1pdCBjMGQ1OWRhNzk1MzQgKCJp
cF9ncmU6IE1ha2UgDQpub25lLXR1bi1kc3QgZ3JlIHR1bm5lbCBzdG9yZSB0dW5uZWwgaW5mbyBh
cyBtZXRhZGF0X2RzdCBpbiByZWN2IikuIA0KUHJpb3IgdG8gYzBkNTlkYTc5NTM0IHdlJ2Qgb25s
eSBhbGxvY2F0ZSBhIG5ldyBkc3QgaWYgdHVubmVsLT5jb2xsZWN0X21kIA0Kd2VyZSB0cnVlIGJ1
dCBub3cgd2UnbGwgYWxzbyBhbGxvY2F0ZSBvbmUgaWYgdG5sX3BhcmFtcy0+ZGFkZHIgPT0gMC4g
DQpXaGVuIGlwX3JvdXRlX2lucHV0X21jKCkgaXMgZXZlbnR1YWxseSBjYWxsZWQgaXQgd2lsbCBj
YWxsIHNrYl9kc3Rfc2V0KCkgDQpsZWFraW5nIHdoYXRldmVyIGlzIGluIHNrYi0+X3NrYl9yZWZk
c3QuDQoNCkEgbmFpdmUgZml4IHdvdWxkIGJlIHRvIGNhbGwgc2tiX2RzdF9kcm9wKCkgaW4gaXBf
cm91dGVfaW5wdXRfbWMoKSBqdXN0IA0KYmVmb3JlIGNhbGxpbmcgc2tiX2RzdF9zZXQoKSAoaGVu
Y2UgTG9rZXNoJ3MgcXVlc3Rpb24pIGJ1dCBJJ20gd29ycmllZCANCndlJ3ZlIG1pc3NlZCBzb21l
dGhpbmcuIEkgY2FuJ3QgcnVsZSBvdXQgdGhhdCB0aGlzIGhhcyBhbHJlYWR5IGJlZW4gDQpmaXhl
ZCBvciBpcyBkdWUgdG8gb3RoZXIgY2hhbmdlcyBpbiBvdXIga2VybmVsIGZvcmsuIEkgY2FuJ3Qg
c2VlIA0KYW55dGhpbmcgdGhhdCBzYXlzICJGaXhlczogYzBkNTlkYTc5NTM0IiBzbyBpZiBpdCBo
YXMgYmVlbiBmaXhlZCANCmMwZDU5ZGE3OTUzNCBkb2Vzbid0IGFwcGVhciB0byBoYXZlIGJlZW4g
bm90ZWQgYXMgdGhlIGN1bHByaXQuIEkndmUgDQphc2tlZCBMb2tlc2ggdG8gdHJ5IGFuZCByZXBy
b2R1Y2UgdGhlIHByb2JsZW0gd2l0aCB0aGUgbGF0ZXN0IGtlcm5lbCBzbyANCndlIGNhbiBydWxl
IG91dCBhbnkgY2hhbmdlcyB3ZSd2ZSBtYWRlIGFuZCBjb25maXJtIHRoYXQgdGhlIGxlYWsgc3Rp
bGwgDQpleGlzdHMuDQoNCkkgd2FudGVkIHRvIGdldCB0aGlzIG91dCBub3cganVzdCBpbiBjYXNl
IGl0IHJpbmdzIGFueSBiZWxscyBvciBpZiANCnNvbWVvbmUgaGFzIGdvdCBhIHR1bm5lbCttdWx0
aWNhc3Qgc2V0dXAgdGhhdCBtaWdodCBzaG93IHRoZSBwcm9ibGVtLg0KDQpUaGFua3MsDQpDaHJp
cw0KDQoNCg==
