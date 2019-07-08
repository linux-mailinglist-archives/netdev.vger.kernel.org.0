Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC461AEA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 09:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfGHHIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 03:08:02 -0400
Received: from mail-eopbgr10060.outbound.protection.outlook.com ([40.107.1.60]:29251
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbfGHHIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 03:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8kLjqoEoGY/E5j0gbVp89cKvOkTRyXbnpDuqLVn4BY=;
 b=O3LgUSyx3xX8fvJ9uc4Bh7BLWRwr65k5aOjkk4PKTEUEMZSn4E5yME4mh4YGaD71XxUUUwW4WT18GiWI/n+iWPp5vugHQ4OihBgicKwosqEC8t6DmYEaSrCOWjDY/GRKtdIX3EP5lkMLmsyYzEtzQsVLx9VWs+/OEgN0xAs7Ouw=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3233.eurprd05.prod.outlook.com (10.171.188.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 07:07:56 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2052.019; Mon, 8 Jul 2019
 07:07:55 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v4 1/4] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next v4 1/4] net/sched: Introduce action ct
Thread-Index: AQHVNJqX6fF8cNViiUqL/dqGMj+bRaa/DyuAgAE/VwA=
Date:   Mon, 8 Jul 2019 07:07:55 +0000
Message-ID: <55a5a05f-b2c0-dda0-e961-75a7b4821dc1@mellanox.com>
References: <1562486612-22770-1-git-send-email-paulb@mellanox.com>
 <1562486612-22770-2-git-send-email-paulb@mellanox.com>
 <20190707120455.6li4tfb5ppht4xy7@breakpoint.cc>
In-Reply-To: <20190707120455.6li4tfb5ppht4xy7@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR10CA0004.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::17) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97d13176-1a76-407b-9e3c-08d70373000f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3233;
x-ms-traffictypediagnostic: AM4PR05MB3233:
x-microsoft-antispam-prvs: <AM4PR05MB323359B715009F719F97540ACFF60@AM4PR05MB3233.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(199004)(189003)(66066001)(53936002)(99286004)(52116002)(76176011)(7736002)(6246003)(6436002)(26005)(31686004)(6486002)(81156014)(8936002)(81166006)(102836004)(386003)(6506007)(53546011)(8676002)(229853002)(186003)(3846002)(6116002)(4326008)(25786009)(316002)(6512007)(2906002)(36756003)(54906003)(478600001)(486006)(5660300002)(7416002)(2616005)(71190400001)(71200400001)(446003)(476003)(86362001)(66946007)(14444005)(256004)(31696002)(73956011)(6916009)(11346002)(68736007)(305945005)(66446008)(14454004)(66556008)(66476007)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3233;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lcf/rD3XrCiF/42NkANOPm21Uvfsin0jjRTnGFbeJHWXhh1J8e4tegvOjUmXWYc8S8Z75ppw3h+NoQiHvb/TTXznB4w2xZ822pEwbWRFfpU8b/zDOSmIgFOJiEDHv9SoQmuDj99he6n7tEKlrQDVyW+SgurgZn0oAGQfzDlV+f0p2gWTtqtBLrYta3lCFc3pNUUBlwWYTGBxRR/LoH+gAB0FDMh1wmC0VPUt06mFjckBV7y8pZuxReA/0DWZbCtXA/QxNOlg0Iue72DTzIXnIYmvhZRSSakWSrdBmGzPx4wliB+Fsof7Dq+1hQ13jlv5CexofkQjci9bprXCJq3BgH9Fzt2kYLA2D/bwF3YCafzI+a6DZ1OWJ8VQf3zYAF2ddigvwYM6R5oj+nOOwks2GV0TNqA2hdeFJcaxo7tMG5c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F060FBF6530FF4FB56ACE06F36F9A5A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d13176-1a76-407b-9e3c-08d70373000f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 07:07:55.7158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzcvMjAxOSAzOjA0IFBNLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3RlOg0KPiBQYXVsIEJs
YWtleSA8cGF1bGJAbWVsbGFub3guY29tPiB3cm90ZToNCj4+ICsvKiBEZXRlcm1pbmUgd2hldGhl
ciBza2ItPl9uZmN0IGlzIGVxdWFsIHRvIHRoZSByZXN1bHQgb2YgY29ubnRyYWNrIGxvb2t1cC4g
Ki8NCj4+ICtzdGF0aWMgYm9vbCB0Y2ZfY3Rfc2tiX25mY3RfY2FjaGVkKHN0cnVjdCBuZXQgKm5l
dCwgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4+ICsJCQkJICAgdTE2IHpvbmVfaWQsIGJvb2wgZm9y
Y2UpDQo+PiArew0KPj4gKwllbnVtIGlwX2Nvbm50cmFja19pbmZvIGN0aW5mbzsNCj4+ICsJc3Ry
dWN0IG5mX2Nvbm4gKmN0Ow0KPj4gKw0KPj4gKwljdCA9IG5mX2N0X2dldChza2IsICZjdGluZm8p
Ow0KPj4gKwlpZiAoIWN0KQ0KPj4gKwkJcmV0dXJuIGZhbHNlOw0KPj4gKwlpZiAoIW5ldF9lcShu
ZXQsIHJlYWRfcG5ldCgmY3QtPmN0X25ldCkpKQ0KPj4gKwkJcmV0dXJuIGZhbHNlOw0KPj4gKwlp
ZiAobmZfY3Rfem9uZShjdCktPmlkICE9IHpvbmVfaWQpDQo+PiArCQlyZXR1cm4gZmFsc2U7DQo+
PiArDQo+PiArCS8qIEZvcmNlIGNvbm50cmFjayBlbnRyeSBkaXJlY3Rpb24uICovDQo+PiArCWlm
IChmb3JjZSAmJiBDVElORk8yRElSKGN0aW5mbykgIT0gSVBfQ1RfRElSX09SSUdJTkFMKSB7DQo+
PiArCQluZl9jb25udHJhY2tfcHV0KCZjdC0+Y3RfZ2VuZXJhbCk7DQo+PiArCQluZl9jdF9zZXQo
c2tiLCBOVUxMLCBJUF9DVF9VTlRSQUNLRUQpOw0KPj4gKw0KPj4gKwkJaWYgKG5mX2N0X2lzX2Nv
bmZpcm1lZChjdCkpDQo+PiArCQkJbmZfY3Rfa2lsbChjdCk7DQo+IFRoaXMgbG9va3MgbGlrZSBh
IHBvc3NpYmxlIFVBRjoNCj4gbmZfY29ubnRyYWNrX3B1dCgpIG1heSBmcmVlIHRoZSBjb25udHJh
Y2sgZW50cnkuDQo+DQo+IEl0IHNlZW1zIGJldHRlciB0byBkbyBkbzoNCj4gCWlmIChuZl9jdF9p
c19jb25maXJtZWQoY3QpKQ0KPiAJCW5mX2N0X2tpbGwoY3QpOw0KPg0KPiAJbmZfY29ubnRyYWNr
X3B1dCgmY3QtPmN0X2dlbmVyYWwpOw0KPiAJbmZfY3Rfc2V0KHNrYiwgLi4uDQoNCkxpa2UgaWYg
Y29ubnRyYWNrIGhhcyBqdXN0IHRpbWVkIGl0IG91dCAob3IgY29ubnRyYWNrIGZsdXNoZWQpLCBh
bmQgc2tiIA0KaG9sZHMgdGhlIGxhc3QgcmVmPw0KDQp0aGFua3MsIHdpbGwgcmV2ZXJzZSB0aGUg
b3JkZXIuDQoNCg==
