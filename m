Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D084321BC
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 06:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFBEWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 00:22:44 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:43461
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbfFBEWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 00:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20OneEJYlIpeGoAav34hclsWMwbFO5ppc7tLfTKAQjo=;
 b=SXkPxKi+1eWrTBlKy3eW6HWgl/JVAyyey5EUjndsWH/jdsw+kk6dX+hAh4StXnAYUn+v31ft6e4bVOlXq8woNiZad7Gl9GpMhaWqXx6Wxk3T0qVCKYisPUZLrH7Z6CRJ7679TufzXgHmLbqAQT1ANXKXJO4u2gQIZ1HoihQmYpo=
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com (20.179.9.78) by
 DB8PR05MB6604.eurprd05.prod.outlook.com (20.179.11.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Sun, 2 Jun 2019 04:22:40 +0000
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166]) by DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166%5]) with mapi id 15.20.1943.018; Sun, 2 Jun 2019
 04:22:40 +0000
From:   Eli Britstein <elibr@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
Thread-Topic: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
Thread-Index: AQHVF9YCXzM5AJb6fEe3JxZQMbJbvaaFkZSAgAA3bgCAAAgFAIAB9OqA
Date:   Sun, 2 Jun 2019 04:22:40 +0000
Message-ID: <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
In-Reply-To: <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0020.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::32) To DB8PR05MB5897.eurprd05.prod.outlook.com
 (2603:10a6:10:a5::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elibr@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.120.174.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faff2d76-ca6f-4b65-c221-08d6e711f361
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6604;
x-ms-traffictypediagnostic: DB8PR05MB6604:
x-microsoft-antispam-prvs: <DB8PR05MB66045E903C2C1D6A335EF9CBD51B0@DB8PR05MB6604.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(51444003)(43544003)(86362001)(53546011)(386003)(6506007)(31696002)(25786009)(316002)(53936002)(31686004)(229853002)(256004)(66066001)(66476007)(66446008)(64756008)(26005)(3846002)(66556008)(73956011)(14454004)(66946007)(478600001)(7736002)(99286004)(6116002)(186003)(305945005)(5660300002)(81156014)(486006)(81166006)(8936002)(11346002)(2616005)(446003)(476003)(68736007)(2906002)(54906003)(71190400001)(71200400001)(6436002)(102836004)(6246003)(76176011)(6486002)(6512007)(8676002)(4326008)(36756003)(110136005)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6604;H:DB8PR05MB5897.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ALEaiorP132LY6P/Esjcx2lVHfgcs3DUwXTgPTmALhKPO5HXy+vJcenUq+pq3vQgcgbR89v6KnvcSycIeLMb6DJRGjyXlFnlmLA7VfTpRCz5N4T7dEHFL6Mve4On3dv24pFH+hHqwmzHlOmvBRLYVZmTguxDlZ3N5Oz6qJb48IVdMcEAc05NHGHKPJhtsIaUnMtWvxgolAYcHJyKApitFthMlu7b8c7JadaCKQLFAWE2ADdY6gplzCjdyFMBPHaNg7y2GF4+Z9w94faA6P5/OEnpPTRCUYm0zOUPfoOpTGI0tggLLLnq83P7TvDmadklORalDgV4bZjyPy21ojJI45HVkDKP3lJPCPkvtIVE59Ikv3RyzEF3MIF7LdSBjOhnWynl+gxOZAFPjS2Shcp6g4vHX+Pkid8SuZ7bQJa5nug=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40C1B70F680D4E4BBA27BB61A376DC70@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faff2d76-ca6f-4b65-c221-08d6e711f361
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 04:22:40.5503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elibr@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6604
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzEvMjAxOSAxOjI5IEFNLCBDb25nIFdhbmcgd3JvdGU6DQo+IE9uIEZyaSwgTWF5IDMx
LCAyMDE5IGF0IDM6MDEgUE0gRGF2aWRlIENhcmF0dGkgPGRjYXJhdHRpQHJlZGhhdC5jb20+IHdy
b3RlOg0KPj4gT24gRnJpLCAyMDE5LTA1LTMxIGF0IDExOjQyIC0wNzAwLCBDb25nIFdhbmcgd3Jv
dGU6DQo+Pj4gT24gRnJpLCBNYXkgMzEsIDIwMTkgYXQgMTA6MjYgQU0gRGF2aWRlIENhcmF0dGkg
PGRjYXJhdHRpQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+PiAnYWN0X2NzdW0nIHdhcyByZWNlbnRs
eSBmaXhlZCB0byBtYW5nbGUgdGhlIElQdjQvSVB2NiBoZWFkZXIgaWYgYSBwYWNrZXQNCj4+Pj4g
aGF2aW5nIG9uZSBvciBtb3JlIFZMQU4gaGVhZGVycyB3YXMgcHJvY2Vzc2VkOiBwYXRjaCAjMSBl
bnN1cmVzIHRoYXQgYWxsDQo+Pj4+IFZMQU4gaGVhZGVycyBhcmUgaW4gdGhlIGxpbmVhciBhcmVh
IG9mIHRoZSBza2IuDQo+Pj4+IE90aGVyIGFjdGlvbnMgbWlnaHQgcmVhZCBvciBtYW5nbGUgdGhl
IElQdjQvSVB2NiBoZWFkZXI6IHBhdGNoICMyIGFuZCAjMw0KPj4+PiBmaXggJ2FjdF9wZWRpdCcg
YW5kICdhY3Rfc2tiZWRpdCcgcmVzcGVjdGl2ZWx5Lg0KPj4+IE1heWJlLCBqdXN0IG1heWJlLCB2
bGFuIHRhZ3MgYXJlIHN1cHBvc2VkIHRvIGJlIGhhbmRsZWQgYnkgYWN0X3ZsYW4/DQo+Pj4gV2hp
Y2ggbWVhbnMgbWF5YmUgdXNlcnMgaGF2ZSB0byBwaXBlIGFjdF92bGFuIHRvIHRoZXNlIGFjdGlv
bnMuDQo+PiBidXQgaXQncyBub3QgcG9zc2libGUgd2l0aCB0aGUgY3VycmVudCBhY3RfdmxhbiBj
b2RlLg0KPj4gRWFjaCAndmxhbicgYWN0aW9uIHB1c2hlcyBvciBwb3BzIGEgc2luZ2xlIHRhZywg
c286DQo+Pg0KPj4gMSkgd2UgZG9uJ3Qga25vdyBob3cgbWFueSB2bGFuIHRhZ3MgdGhlcmUgYXJl
IGluIGVhY2ggcGFja2V0LCBzbyBJIHNob3VsZA0KPj4gcHV0IGFuIChlbm91Z2gpIGhpZ2ggbnVt
YmVyIG9mICJwb3AiIG9wZXJhdGlvbnMgdG8gZW5zdXJlIHRoYXQgYSAncGVkaXQnDQo+PiBydWxl
IGNvcnJlY3RseSBtYW5nbGVzIHRoZSBUVEwgaW4gYSBJUHY0IHBhY2tldCBoYXZpbmcgMSBvciBt
b3JlIDgwMi4xUQ0KPj4gdGFncyBpbiB0aGUgTDIgaGVhZGVyLg0KPiBOb3QgdHJ1ZSwgd2UgZG8g
a25vdyB3aGV0aGVyIHRoZSBsYXN0IHZsYW4gdGFnIGlzIHBvcCdlZCBieSBjaGVja2luZw0KPiB0
aGUgcHJvdG9jb2wuIFRoZXJlIHdhcyBhbHJlYWR5IGEgdXNlIGNhc2UgaW4gbmV0ZGV2IGJlZm9y
ZToNCj4NCj4gdGMgZmlsdGVyIGFkZCBkZXYgdmV0aDEgZWdyZXNzIHByaW8gMTAwICBwcm90b2Nv
bCA4MDIuMVEgIG1hdGNoYWxsDQo+IGFjdGlvbiB2bGFuIHBvcCBjb250aW51ZSAjcmVjbGFzc2lm
eQ0KPiB0YyBmaWx0ZXIgYWRkIGRldiB2ZXRoMSBlZ3Jlc3MgcHJpbyAyMDAgIHByb3RvY29sIGlw
ICAgICAgdTMyIG1hdGNoIGlwDQo+IHNyYyAxOTIuMTY4LjEuMC8yNCAgYWN0aW9uIGRyb3ANCj4g
dGMgZmlsdGVyIGFkZCBkZXYgdmV0aDEgZWdyZXNzIHByaW8gMjAxICBwcm90b2NvbCBpcCAgICAg
IHUzMiBtYXRjaCBpcA0KPiBkc3QgMTkyLjE2OC4xMDAuMC8yNCAgYWN0aW9uIGRyb3ANCj4NCj4g
d2hpY2ggaXMgZnJvbSBhIGJ1ZyByZXBvcnQuDQo+DQo+PiAyKSBhZnRlciBhIHZsYW4gaXMgcG9w
cGVkIHdpdGggYWN0X3ZsYW4sIHRoZSBrZXJuZWwgZm9yZ2V0cyBhYm91dCB0aGUgVkxBTg0KPj4g
SUQgYW5kIHRoZSBWTEFOIHR5cGUuIFNvLCBpZiBJIHdhbnQgdG8ganVzdCBtYW5nbGUgdGhlIFRU
TCBpbiBhIFFpblENCj4+IHBhY2tldCwgSSBuZWVkIHRvIHJlaW5qZWN0IGl0IGluIGEgcGxhY2Ug
d2hlcmUgYm90aCB0YWdzIChpbmNsdWRpbmcgVkxBTg0KPj4gdHlwZSAqYW5kKiBWTEFOIGlkKSBh
cmUgcmVzdG9yZWQgaW4gdGhlIHBhY2tldC4NCj4gSXQgaXMgZm9yZ290dGVuIGJ5IGFjdF92bGFu
IG9ubHksIHRoZSB2bGFuIGluZm8gaXMgc3RpbGwgaW5zaWRlIHRoZQ0KPiBwYWNrZXQgaGVhZGVy
Lg0KPiBQZXJoYXBzIHdlIGp1c3QgbmVlZCBzb21lIGFjdGlvbiB0byBwdXNoIGl0IGJhY2suDQpU
aGVyZSBpcyBtZW1tb3ZlIGluIHRob3NlIGZ1bmN0aW9ucywgc28gdGhlIFZMQU4gaXMgb3Zlcndy
aXR0ZW4sIGFuZCB5b3UgDQp3aWxsIGFsc28gbmVlZCBhbm90aGVyIG1lbW9yeSB0byBzdG9yZSB0
aGUgVkxBTnMuDQo+DQo+PiBDbGVhcmx5LCBhY3RfdmxhbiBjYW4ndCBiZSB1c2VkIGFzIGlzLCBi
ZWNhdXNlICdwdXNoJyBoYXMgaGFyZGNvZGVkIFZMQU4NCj4+IElEIGFuZCBldGhlcnR5cGUuIFVu
bGVzcyB3ZSBjaGFuZ2UgYWN0X3ZsYW4gY29kZSB0byBlbmFibGUgcm9sbGJhY2sgb2YNCj4+IHBy
ZXZpb3VzICdwb3AnIG9wZXJhdGlvbnMsIGl0J3MgcXVpdGUgaGFyZCB0byBwaXBlIHRoZSBjb3Jy
ZWN0IHNlcXVlbmNlIG9mDQo+PiB2bGFuICdwb3AnIGFuZCAncHVzaCcuDQo+IFdoYXQgYWJvdXQg
b3RoZXIgZW5jYXBzdWxhdGlvbnMgbGlrZSBWWExBTj8gV2hhdCBpZiBJIGp1c3Qgd2FudCB0bw0K
PiBtYW5nbGUgdGhlIGlubmVyIFRUTCBvZiBhIFZYTEFOIHBhY2tldD8gWW91IGtub3cgdGhlIGFu
c3dlciBpcyBzZXR0aW5nDQo+IHVwIFRDIGZpbHRlcnMgYW5kIGFjdGlvbnMgb24gVlhMQU4gZGV2
aWNlIGluc3RlYWQgb2YgZXRoZXJuZXQgZGV2aWNlLg0KPg0KPiBJT1csIHdoeSBRaW5RIGlzIHNv
IHNwZWNpYWwgdGhhdCB3ZSBoYXZlIHRvIHRha2UgY2FyZSBvZiBpbnNpZGUgVEMgYWN0aW9uDQo+
IG5vdCB0aGUgZW5jYXBzdWxhdGlvbiBlbmRwb2ludD8NCg0KSSB0aGluayB0aGF0J3MgYmVjYXVz
ZSBRaW5RLCBvciBWTEFOIGlzIG5vdCBhbiBlbmNhcHN1bGF0aW9uLiBUaGVyZSBpcyANCm5vIG91
dGVyL2lubmVyIHBhY2tldHMsIGFuZCBpZiB5b3Ugd2FudCB0byBtYW5nbGUgZmllbGRzIGluIHRo
ZSBwYWNrZXQgDQp5b3UgY2FuIGRvIGl0IGFuZCB0aGUgcmVzdWx0IGlzIHdlbGwtZGVmaW5lZC4N
Cg0KQlRXLCB0aGUgbW90aXZhdGlvbiBmb3IgbXkgZml4IHdhcyBhIHVzZSBjYXNlIHdlcmUgMiBW
R1QgVk1zIA0KY29tbXVuaWNhdGluZyBieSBPVlMgZmFpbGVkLiBTaW5jZSBPVlMgc2VlcyB0aGUg
c2FtZSBWTEFOIHRhZywgaXQgDQpkb2Vzbid0IGFkZCBleHBsaWNpdCBWTEFOIHBvcC9wdXNoIGFj
dGlvbnMgKGkuZSBwb3AsIG1hbmdsZSwgcHVzaCkuIElmIA0KeW91IGZvcmNlIGV4cGxpY2l0IHBv
cC9tYW5nbGUvcHVzaCB5b3Ugd2lsbCBicmVhayBzdWNoIGFwcGxpY2F0aW9ucy4NCg0KPg0KPg0K
Pj4+ICBGcm9tIHRoZSBjb2RlIHJldXNlIHBlcnNwZWN0aXZlLCB5b3UgYXJlIGFkZGluZyBUQ0Ff
VkxBTl9BQ1RfUE9QDQo+Pj4gdG8gZWFjaCBvZiB0aGVtLg0KPj4gTm8sIHRoZXNlIHBhdGNoZXMg
ZG9uJ3QgcG9wIFZMQU4gdGFncy4gQWxsIHRhZ3MgYXJlIHJlc3RvcmVkIGFmdGVyIHRoZQ0KPj4g
YWN0aW9uIGNvbXBsZXRlZCBoaXMgd29yaywgYmVmb3JlIHJldHVybmluZyBhLT50Y2ZhX2FjdGlv
bi4NCj4+DQo+PiBNYXkgSSBhc2sgeW91IHRvIHJlYWQgaXQgYXMgYSBmb2xsb3d1cCBvZiBjb21t
aXQgMmVjYmEyZDFlNDViICgibmV0Og0KPj4gc2NoZWQ6IGFjdF9jc3VtOiBGaXggY3N1bSBjYWxj
IGZvciB0YWdnZWQgcGFja2V0cyIpLCB3aGVyZSB0aGUgJ2NzdW0nDQo+PiBhY3Rpb24gd2FzIG1v
ZGlmaWVkIHRvIG1hbmdsZSB0aGUgY2hlY2tzdW0gb2YgSVB2NCBoZWFkZXJzIGV2ZW4gd2hlbg0K
Pj4gbXVsdGlwbGUgODAyLjFRIHRhZ3Mgd2VyZSBwcmVzZW50Pw0KPiBZZXMsIEkgYWxyZWFkeSBy
ZWFkIGl0IGFuZCBJIHRoaW5rIHRoYXQgY29tbWl0IHNob3VsZCBiZSByZXZlcnRlZCBmb3IgdGhl
DQo+IHNhbWUgcmVhc29uIGFzIEkgYWxyZWFkeSBzdGF0ZWQgYWJvdmUuDQo+DQo+DQo+PiBXaXRo
IHRoaXMgc2VyaWVzIGl0IGJlY29tZXMgcG9zc2libGUgdG8gbWFuZ2xlIGFsc28gdGhlIFRUTCBm
aWVsZCAod2l0aA0KPj4gcGVkaXQpLCBhbmQgYXNzaWduIHRoZSBkaWZmc2VydiBiaXRzIHRvIHNr
Yi0+cHJpb3JpdHkgKHdpdGggc2tiZWRpdCkuDQo+IFNvcnJ5LCBJIGFtIG5vdCB5ZXQgY29udmlu
Y2VkIHdoeSB3ZSBzaG91bGQgZG8gaXQgaW4gVEMuDQo+DQo+IFRoYW5rcy4NCg==
