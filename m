Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB39E33A07
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFCVor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:44:47 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:55545
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbfFCVor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 17:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olU0hpppv+S2hVIC6lK11fYUdJNDRVVHO4z+Odr29pg=;
 b=qNhezd5k+uhn32bJp30rmtqdjat5opN8qG4olYgZ/vW3w62QLK6hVpAm/JIp3qIC7OoszhR15/0cQjIY/sZrm0C+YNG0yr1nKOQuKD4aO32VDzzT7PyCWtlInZ0ZdIHxRI9GQaniXdb2gc+QQQlfAJIc2S+A/vCX8V7hqIjwhHQ=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5996.eurprd05.prod.outlook.com (20.179.10.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 21:20:30 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 21:20:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "bjorn.topel@gmail.com" <bjorn.topel@gmail.com>
CC:     "toke@redhat.com" <toke@redhat.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Thread-Topic: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Thread-Index: AQHVF5UyingDVomLXU+x48iNqvXUO6aFnAaAgAGZH4CAAnJWAIAAza8A
Date:   Mon, 3 Jun 2019 21:20:30 +0000
Message-ID: <f7e9b1c8f358a4bb83f01ab76dcc95195083e2bf.camel@mellanox.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
         <20190531094215.3729-2-bjorn.topel@gmail.com>
         <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
         <20190601124233.5a130838@cakuba.netronome.com>
         <CAJ+HfNjbALzf4SaopKe3pA4dV6n9m30doai_CLEDB9XG2RzjOg@mail.gmail.com>
In-Reply-To: <CAJ+HfNjbALzf4SaopKe3pA4dV6n9m30doai_CLEDB9XG2RzjOg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 598706f8-31f7-4d89-1bf4-08d6e8694e88
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5996;
x-ms-traffictypediagnostic: DB8PR05MB5996:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB8PR05MB59967A01A98576B253F39750BE140@DB8PR05MB5996.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(376002)(366004)(396003)(189003)(199004)(86362001)(4326008)(186003)(76176011)(102836004)(6506007)(66574012)(2616005)(99286004)(5024004)(256004)(6436002)(5660300002)(71200400001)(446003)(71190400001)(26005)(118296001)(6246003)(6486002)(6116002)(316002)(3846002)(66066001)(53936002)(8936002)(6512007)(486006)(966005)(11346002)(25786009)(229853002)(508600001)(6306002)(58126008)(2906002)(68736007)(8676002)(81166006)(81156014)(66446008)(66946007)(73956011)(36756003)(476003)(54906003)(64756008)(14454004)(66476007)(2501003)(305945005)(7416002)(7736002)(110136005)(66556008)(76116006)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5996;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ns7BZ+H6Kl5akERsipUAI03hpjEeDb+Ib2kc15M90ct3ZkUf8qca7m2CqTKYxpoGL0QpJHQFyceds6rs5dNBUfJoLqPNcC51fXg6X/Wu6GCx/8reeNRtdjZoR6PDGjJQ2V8+yTr/5hcEHW3aFvbxxxyWVLn/prLR535dZ8QbkY03jfFZHVqaH9Eq1sw8NWPDZi2xV8kP+eSfWFtcx0IJzkLwZoPY4OKXSYNBby5qWgwKBHO68R0+tSQayquRQK8J2clDIs7MzBiu12oEf1HlNwM4DVphDHvgb7eURS/WpGx5pFtmcIvMIITaooVKw2NgzrBM64GeNQLyW2iONfNLECfMLkDLFklOF3dhF9NykX8LExOVvhxM9NLJCrnnLPMKcgFITvi5wNdetl923bP00mfAyD0yEmqxOkAd5tstsWY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA54FFF36169E8478822E5964402D355@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598706f8-31f7-4d89-1bf4-08d6e8694e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 21:20:30.4787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5996
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTAzIGF0IDExOjA0ICswMjAwLCBCasO2cm4gVMO2cGVsIHdyb3RlOg0K
PiBPbiBTYXQsIDEgSnVuIDIwMTkgYXQgMjE6NDIsIEpha3ViIEtpY2luc2tpDQo+IDxqYWt1Yi5r
aWNpbnNraUBuZXRyb25vbWUuY29tPiB3cm90ZToNCj4gPiBPbiBGcmksIDMxIE1heSAyMDE5IDE5
OjE4OjE3ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiA+IE9uIEZyaSwgMjAxOS0w
NS0zMSBhdCAxMTo0MiArMDIwMCwgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gPiA+ID4gRnJvbTog
QmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiA+ID4gPiANCj4gPiA+ID4g
QWxsIFhEUCBjYXBhYmxlIGRyaXZlcnMgbmVlZCB0byBpbXBsZW1lbnQgdGhlDQo+ID4gPiA+IFhE
UF9RVUVSWV9QUk9HeyxfSFd9DQo+ID4gPiA+IGNvbW1hbmQgb2YgbmRvX2JwZi4gVGhlIHF1ZXJ5
IGNvZGUgaXMgZmFpcmx5IGdlbmVyaWMuIFRoaXMNCj4gPiA+ID4gY29tbWl0DQo+ID4gPiA+IHJl
ZmFjdG9ycyB0aGUgcXVlcnkgY29kZSB1cCBmcm9tIHRoZSBkcml2ZXJzIHRvIHRoZSBuZXRkZXYN
Cj4gPiA+ID4gbGV2ZWwuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgc3RydWN0IG5ldF9kZXZpY2Ug
aGFzIGdhaW5lZCB0d28gbmV3IG1lbWJlcnM6IHhkcF9wcm9nX2h3DQo+ID4gPiA+IGFuZA0KPiA+
ID4gPiB4ZHBfZmxhZ3MuIFRoZSBmb3JtZXIgaXMgdGhlIG9mZmxvYWRlZCBYRFAgcHJvZ3JhbSwg
aWYgYW55LCBhbmQNCj4gPiA+ID4gdGhlDQo+ID4gPiA+IGxhdHRlciB0cmFja3MgdGhlIGZsYWdz
IHRoYXQgdGhlIHN1cHBsaWVkIHdoZW4gYXR0YWNoaW5nIHRoZQ0KPiA+ID4gPiBYRFANCj4gPiA+
ID4gcHJvZ3JhbS4gVGhlIGZsYWdzIG9ubHkgYXBwbHkgdG8gU0tCX01PREUgb3IgRFJWX01PREUs
IG5vdA0KPiA+ID4gPiBIV19NT0RFLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIHhkcF9wcm9nIG1l
bWJlciwgcHJldmlvdXNseSBvbmx5IHVzZWQgZm9yIFNLQl9NT0RFLCBpcw0KPiA+ID4gPiBzaGFy
ZWQNCj4gPiA+ID4gd2l0aA0KPiA+ID4gPiBEUlZfTU9ERS4gVGhpcyBpcyBPSywgZHVlIHRvIHRo
ZSBmYWN0IHRoYXQgU0tCX01PREUgYW5kDQo+ID4gPiA+IERSVl9NT0RFIGFyZQ0KPiA+ID4gPiBt
dXR1YWxseSBleGNsdXNpdmUuIFRvIGRpZmZlcmVudGlhdGUgYmV0d2VlbiB0aGUgdHdvIG1vZGVz
LCBhDQo+ID4gPiA+IG5ldw0KPiA+ID4gPiBpbnRlcm5hbCBmbGFnIGlzIGludHJvZHVjZWQgYXMg
d2VsbC4NCj4gPiA+IA0KPiA+ID4gSnVzdCB0aGlua2luZyBvdXQgbG91ZCwgd2h5IGNhbid0IHdl
IGFsbG93IGFueSBjb21iaW5hdGlvbiBvZg0KPiA+ID4gSFcvRFJWL1NLQiBtb2Rlcz8gdGhleSBh
cmUgdG90YWxseSBkaWZmZXJlbnQgYXR0YWNoIHBvaW50cyBpbiBhDQo+ID4gPiB0b3RhbGx5DQo+
ID4gPiBkaWZmZXJlbnQgY2hlY2twb2ludHMgaW4gYSBmcmFtZSBsaWZlIGN5Y2xlLg0KPiA+IA0K
PiA+IEZXSVcgc2VlIE1lc3NhZ2UtSUQ6IDwyMDE5MDIwMTA4MDIzNi40NDZkODRkNEByZWRoYXQu
Y29tPg0KPiA+IA0KPiANCj4gSSd2ZSBhbHdheXMgc2VlbiB0aGUgU0tCLW1vZGUgYXMgc29tZXRo
aW5nIHRoYXQgd2lsbCBldmVudHVhbGx5IGJlDQo+IHJlbW92ZWQuDQo+IA0KDQpJIGRvbid0IHRo
aW5rIHNvLCB3ZSBhcmUgdG9vIGRlZXAgaW50byBTS0ItbW9kZS4NCg0KPiBDbGlja2FibGUgbGlu
azoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMTkwMjAxMDgwMjM2LjQ0NmQ4
NGQ0QHJlZGhhdC5jb20vIDotDQo+IFANCj4gDQoNClNvIHdlIGFyZSBhbGwgaGFuZ2luZyBvbiBK
ZXNwZXIncyByZWZhY3RvcmluZyBpZGVhcyB0aGF0IGFyZSBub3QNCmdldHRpbmcgYW55IHByaW9y
aXR5IGZvciBub3cgOikuDQoNCg0KPiA+ID4gRG93biB0aGUgcm9hZCBpIHRoaW5rIHdlIHdpbGwg
dXRpbGl6ZSB0aGlzIGZhY3QgYW5kIHN0YXJ0DQo+ID4gPiBpbnRyb2R1Y2luZw0KPiA+ID4gU0tC
IGhlbHBlcnMgZm9yIFNLQiBtb2RlIGFuZCBkcml2ZXIgaGVscGVycyBmb3IgRFJWIG1vZGUuLg0K
PiA+IA0KPiA+IEFueSByZWFzb24gd2h5IHdlIHdvdWxkIHdhbnQgdGhlIGV4dHJhIGNvbXBsZXhp
dHk/ICBUaGVyZSBpcw0KPiA+IGNsc19icGYNCj4gPiBpZiBzb21lb25lIHdhbnRzIHNrYiBmZWF0
dXJlcyBhZnRlciBhbGwuLg0KDQpEb25ubywgU0tCIG1vZGUgaXMgZWFybGllciBpbiB0aGUgc3Rh
Y2sgbWF5YmUgLi4gDQogDQoNCg==
