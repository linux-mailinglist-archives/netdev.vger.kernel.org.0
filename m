Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBF6659E8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 12:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjAKLTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjAKLTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:19:23 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A53101E3;
        Wed, 11 Jan 2023 03:18:56 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 10AA0132EAE9;
        Wed, 11 Jan 2023 14:18:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 10AA0132EAE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1673435933; bh=u6clYul3DTm2mKDh7DV/6GRx4J3QK/GQ9pTJSDwpvKQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VIHfj9wtovGmkcG/6n9+8rsq/UFkP4ei/wH0q298b6lmRPhBLFhk9hqg2Nrt1rE78
         vkOPn9GaVpdBX8TT/Z/7/j386WnrvpgX4kz3J48bj5ntJbTjUsD5rFUCxwGxG359od
         nv0XwiLMn6RosDyfuVKI1rbYh226eMlfMzTPrRPQ=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 0D3403100ABA;
        Wed, 11 Jan 2023 14:18:53 +0300 (MSK)
Received: from msk-exch-01.infotecs-nt (10.0.7.191) by msk-exch-01.infotecs-nt
 (10.0.7.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.12; Wed, 11 Jan
 2023 14:18:52 +0300
Received: from msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07]) by
 msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07%14]) with mapi id
 15.02.1118.012; Wed, 11 Jan 2023 14:18:52 +0300
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Thread-Topic: [PATCH] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Thread-Index: AQHZJa588H6nj6krsk+2NVbkFBIg8A==
Date:   Wed, 11 Jan 2023 11:18:52 +0000
Message-ID: <5bad74e6-46fb-ebd0-4662-bc66e0f5ab5d@infotecs.ru>
References: <20230109115432.3001636-1-Ilia.Gavrilov@infotecs.ru>
 <Y76NQ7tQVB7kE0dG@corigine.com>
In-Reply-To: <Y76NQ7tQVB7kE0dG@corigine.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF08E108AF643344AF0346C913D2CF39@infotecs.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174635 [Jan 11 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_msgid_8}, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/11 06:26:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/11 02:11:00 #20757923
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8xMS8yMyAxMzoxOSwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPiBIaSBHYXZyaWxvdiwNCj4g
DQo+IE9uIE1vbiwgSmFuIDA5LCAyMDIzIGF0IDExOjU0OjAyQU0gKzAwMDAsIEdhdnJpbG92IEls
aWEgd3JvdGU6DQo+PiBXaGVuIGZpcnN0X2lwIGlzIDAsIGxhc3RfaXAgaXMgMHhGRkZGRkZGLCBh
bmQgbmV0bWFzayBpcyAzMSwgdGhlIHZhbHVlIG9mDQo+PiBhbiBhcml0aG1ldGljIGV4cHJlc3Np
b24gMiA8PCAobmV0bWFzayAtIG1hc2tfYml0cyAtIDEpIGlzIHN1YmplY3QNCj4+IHRvIG92ZXJm
bG93IGR1ZSB0byBhIGZhaWx1cmUgY2FzdGluZyBvcGVyYW5kcyB0byBhIGxhcmdlciBkYXRhIHR5
cGUNCj4+IGJlZm9yZSBwZXJmb3JtaW5nIHRoZSBhcml0aG1ldGljLg0KPj4NCj4+IE5vdGUgdGhh
dCBpdCdzIGhhcm1sZXNzIHNpbmNlIHRoZSB2YWx1ZSB3aWxsIGJlIGNoZWNrZWQgYXQgdGhlIG5l
eHQgc3RlcC4NCj4gDQo+IERvIHlvdSBtZWFuIDB4RkZGRkZGRkYgKDggcmF0aGVyIHRoYW4gOCAn
RidzKSA/DQo+IElmIHNvLCBJIGFncmVlIHdpdGggdGhpcyBwYXRjaC4NCj4gDQoNClllcywgaXQn
cyBteSB0eXBvLiBJIG1lYW50IDB4RkZGRkZGRkYuDQoNCj4+IEZvdW5kIGJ5IEluZm9UZUNTIG9u
IGJlaGFsZiBvZiBMaW51eCBWZXJpZmljYXRpb24gQ2VudGVyDQo+PiAobGludXh0ZXN0aW5nLm9y
Zykgd2l0aCBTVkFDRS4NCj4+DQo+PiBGaXhlczogYjlmZWQ3NDgxODVhICgibmV0ZmlsdGVyOiBp
cHNldDogQ2hlY2sgYW5kIHJlamVjdCBjcmF6eSAvMCBpbnB1dCBwYXJhbWV0ZXJzIikNCj4+IFNp
Z25lZC1vZmYtYnk6IElsaWEuR2F2cmlsb3YgPElsaWEuR2F2cmlsb3ZAaW5mb3RlY3MucnU+DQo+
PiAtLS0NCj4+ICAgbmV0L25ldGZpbHRlci9pcHNldC9pcF9zZXRfYml0bWFwX2lwLmMgfCAyICst
DQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4N
Cj4+IGRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL2lwc2V0L2lwX3NldF9iaXRtYXBfaXAuYyBi
L25ldC9uZXRmaWx0ZXIvaXBzZXQvaXBfc2V0X2JpdG1hcF9pcC5jDQo+PiBpbmRleCBhOGNlMDRh
NGJiNzIuLmI4ZjBmYjM3Mzc4ZiAxMDA2NDQNCj4+IC0tLSBhL25ldC9uZXRmaWx0ZXIvaXBzZXQv
aXBfc2V0X2JpdG1hcF9pcC5jDQo+PiArKysgYi9uZXQvbmV0ZmlsdGVyL2lwc2V0L2lwX3NldF9i
aXRtYXBfaXAuYw0KPj4gQEAgLTMwOSw3ICszMDksNyBAQCBiaXRtYXBfaXBfY3JlYXRlKHN0cnVj
dCBuZXQgKm5ldCwgc3RydWN0IGlwX3NldCAqc2V0LCBzdHJ1Y3QgbmxhdHRyICp0YltdLA0KPj4g
ICANCj4+ICAgCQlwcl9kZWJ1ZygibWFza19iaXRzICV1LCBuZXRtYXNrICV1XG4iLCBtYXNrX2Jp
dHMsIG5ldG1hc2spOw0KPj4gICAJCWhvc3RzID0gMiA8PCAoMzIgLSBuZXRtYXNrIC0gMSk7DQo+
IA0KPiBJIHRoaW5rIHRoYXQgaG9zdHMgYWxzbyBvdmVyZmxvd3MsIGluIHRoZSBjYXNlIHlvdSBo
YXZlIGRlc2NyaWJlZC4NCj4gQWx0aG91Z2ggaXQgYWxzbyBkb2Vzbid0IG1hdHRlciBmb3IgdGhl
IHNhbWUgcmVhc29uIHlvdSBzdGF0ZS4NCj4gQnV0IGZyb20gYSBjb3JyZWN0bmVzcyBwb2ludCBv
ZiB2aWV3IHBlcmhhcHMgaXQgc2hvdWxkIGFsc28gYmUgYWRkcmVzc2VkPw0KPiANCg0KDQpBcyBm
b3IgJ2hvc3RzJywgdGhlIGV4cHJlc3Npb24gIjIgPDwgKDMyIC0gbmV0bWFzayAtIDEpIiBpcyBh
bHNvIHN1YmplY3QgDQp0byBvdmVyZmxvdywgYnV0IHRoZSB0eXBlIG9mIHRoZSB2YXJpYWJsZSAn
aG9zdHMnIGlzIHUzMiwgYW5kIHRoZSB0eXBlIA0KY2FzdGluZyBnaXZlcyB0aGUgY29ycmVjdCBy
ZXN1bHQuIEJ1dCBJIHdpbGwgZml4IGl0IGZvciBjb3JyZWN0bmVzcy4NCg0KDQpUaGFuayB5b3Ug
Zm9yIHJldmlldy4gSSB3aWxsIGNoYW5nZSB0aGF0IGluIFYyLg0KDQpJbGlhLg0KDQo+PiAtCQll
bGVtZW50cyA9IDIgPDwgKG5ldG1hc2sgLSBtYXNrX2JpdHMgLSAxKTsNCj4+ICsJCWVsZW1lbnRz
ID0gMlVMIDw8IChuZXRtYXNrIC0gbWFza19iaXRzIC0gMSk7DQo+PiAgIAl9DQo+PiAgIAlpZiAo
ZWxlbWVudHMgPiBJUFNFVF9CSVRNQVBfTUFYX1JBTkdFICsgMSkNCj4+ICAgCQlyZXR1cm4gLUlQ
U0VUX0VSUl9CSVRNQVBfUkFOR0VfU0laRTsNCj4+IC0tIA0KPj4gMi4zMC4yDQo+Pg0KDQo=
