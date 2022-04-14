Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31765003E7
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbiDNCBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 22:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiDNCBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 22:01:18 -0400
X-Greylist: delayed 446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Apr 2022 18:58:41 PDT
Received: from mail10.tencent.com (mail10.tencent.com [14.18.183.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E2A31535
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 18:58:41 -0700 (PDT)
Received: from EX-SZ020.tencent.com (unknown [10.28.6.40])
        by mail10.tencent.com (Postfix) with ESMTP id C1F0FD4231;
        Thu, 14 Apr 2022 09:51:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1649901071;
        bh=MBOeNEr8kWDhNZDeSsc/8Z45ootPChSDpwnf8R5Cbco=;
        h=From:To:CC:Subject:Date;
        b=Tro4oPRJBLaPlywT7I+rXNgO03Ru1NsqQHA/8QdDhqpfqW1PZIetmn7PiWX5GDpzI
         dzKtVTh9E32tSEANbRhio+rYNRfKOSZmwsylTPoURNwtARvX2mCiVTj32btTCNbqiU
         TE5a742uFCPhlt2gU9FWXGi0RJDFKN+pTMMKN1Y0=
Received: from EX-SZ048.tencent.com (10.28.6.99) by EX-SZ020.tencent.com
 (10.28.6.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 14 Apr
 2022 09:51:11 +0800
Received: from EX-SZ079.tencent.com (10.28.6.51) by EX-SZ048.tencent.com
 (10.28.6.99) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 14 Apr
 2022 09:51:11 +0800
Received: from EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7]) by
 EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7%3]) with mapi id
 15.01.2242.008; Thu, 14 Apr 2022 09:51:11 +0800
From:   =?utf-8?B?aW1hZ2Vkb25nKOiRo+aipum+mSk=?= <imagedong@tencent.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        =?utf-8?B?YmVuYmppYW5nKOiSi+W9qik=?= <benbjiang@tencent.com>,
        =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] ipv6: fix NULL deref in ip6_rcv_core()
Thread-Topic: [PATCH net-next] ipv6: fix NULL deref in ip6_rcv_core()
Thread-Index: AQHYT6IdJmoIw09KdkmvC+CdMQH5Dw==
Date:   Thu, 14 Apr 2022 01:51:10 +0000
Message-ID: <E2595146-5AD0-4030-ABF2-C93B06897123@tencent.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.16.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC7235463FB93548B8AB94DDE87927EC@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAyMi80LzE0IDA0OjU377yM4oCcRXJpYyBEdW1hemV04oCdPGVyaWMuZHVtYXpldEBnbWFp
bC5jb20+IHdyaXRlOg0KPiBGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+
DQo+IA0KPiBpZGV2IGNhbiBiZSBOVUxMLCBhcyB0aGUgc3Vycm91bmRpbmcgY29kZSBzdWdnZXN0
cy4NCj4gDQo+IEZpeGVzOiA0ZGFmODQxYTJlZjMgKCJuZXQ6IGlwdjY6IGFkZCBza2IgZHJvcCBy
ZWFzb25zIHRvIGlwNl9yY3ZfY29yZSgpIikNCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBEdW1hemV0
IDxlZHVtYXpldEBnb29nbGUuY29tPg0KPiBDYzogTWVuZ2xvbmcgRG9uZyA8aW1hZ2Vkb25nQHRl
bmNlbnQuY29tPg0KPiBDYzogSmlhbmcgQmlhbyA8YmVuYmppYW5nQHRlbmNlbnQuY29tPg0KPiBD
YzogSGFvIFBlbmcgPGZseWluZ3BlbmdAdGVuY2VudC5jb20+DQo+IC0tLQ0KPiAgbmV0L2lwdjYv
aXA2X2lucHV0LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcDZfaW5wdXQuYyBiL25l
dC9pcHY2L2lwNl9pbnB1dC5jDQo+IGluZGV4IDEyNmFlM2FhNjdlMWRjNTc5YmMwZWVjZDIxNDE2
ZTlkODlkY2JmMDguLjAzMjJjYzg2Yjg0ZWFhZWQ3NTI5YTRiNjVmZGZiYTRjOTdhMzgzNzUgMTAw
NjQ0DQo+IC0tLSBhL25ldC9pcHY2L2lwNl9pbnB1dC5jDQo+ICsrKyBiL25ldC9pcHY2L2lwNl9p
bnB1dC5jDQo+IEBAIC0xNjYsNyArMTY2LDcgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICppcDZf
cmN2X2NvcmUoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4g
IAlpZiAoKHNrYiA9IHNrYl9zaGFyZV9jaGVjayhza2IsIEdGUF9BVE9NSUMpKSA9PSBOVUxMIHx8
DQo+ICAJICAgICFpZGV2IHx8IHVubGlrZWx5KGlkZXYtPmNuZi5kaXNhYmxlX2lwdjYpKSB7DQo+
ICAJCV9fSVA2X0lOQ19TVEFUUyhuZXQsIGlkZXYsIElQU1RBVFNfTUlCX0lORElTQ0FSRFMpOw0K
PiAtCQlpZiAodW5saWtlbHkoaWRldi0+Y25mLmRpc2FibGVfaXB2NikpDQo+ICsJCWlmIChpZGV2
ICYmIHVubGlrZWx5KGlkZXYtPmNuZi5kaXNhYmxlX2lwdjYpKQ0KPiAgCQkJU0tCX0RSX1NFVChy
ZWFzb24sIElQVjZESVNBQkxFRCk7DQo+ICAJCWdvdG8gZHJvcDsNCj4gIAl9DQoNClJldmlld2Vk
LWJ5OiBNZW5nbG9uZyBEb25nIDxpbWFnZWRvbmdAdGVuY2VudC5jb20+DQoNCj4gLS0gDQo+IDIu
MzUuMS4xMTc4Lmc0ZjE2NTlkNDc2LWdvb2cNCg0KDQo=
