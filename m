Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8E239D19
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfFHLT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:19:29 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:35333
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726879AbfFHLT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wa4pYUkDQzf9LojyJ7zI/585XvcjJqCRL735atONZgA=;
 b=kwAyUFfFpp+M+1G641fjnNQ1gJuEhPdoP+wKSU3z09qvKkKnohshxq58yQs738J9VtKts/T6zIYYAnbcA1ytiaJeKYyaVwAw4oxzrFIURCxgaTsajJ4wYRzc8H28ads+B1nP2Tzu+lFp1tkTymOvnUyQpLeKjnl/0DHIpQ1kdGY=
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com (20.179.9.78) by
 DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Sat, 8 Jun 2019 11:19:23 +0000
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166]) by DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166%5]) with mapi id 15.20.1965.017; Sat, 8 Jun 2019
 11:19:23 +0000
From:   Eli Britstein <elibr@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
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
Thread-Index: AQHVF9YCXzM5AJb6fEe3JxZQMbJbvaaFkZSAgAA3bgCAAAgFAIAB9OqAgAQHtICAAAbcAIACDfsAgAKpIgCAARy7gA==
Date:   Sat, 8 Jun 2019 11:19:23 +0000
Message-ID: <da3d2c8d-7e20-c50f-b8ea-4ec7183721ee@mellanox.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
 <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
 <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
 <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
 <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
 <f596bf75a8ed664291fa3a7b81a5693a14ae8f9e.camel@redhat.com>
In-Reply-To: <f596bf75a8ed664291fa3a7b81a5693a14ae8f9e.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0701CA0004.eurprd07.prod.outlook.com
 (2603:10a6:200:42::14) To DB8PR05MB5897.eurprd05.prod.outlook.com
 (2603:10a6:10:a5::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elibr@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.120.174.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 857e3b7d-a570-4573-fdb4-08d6ec0328c9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5898;
x-ms-traffictypediagnostic: DB8PR05MB5898:
x-microsoft-antispam-prvs: <DB8PR05MB5898BE3BB5043A6B851E34FAD5110@DB8PR05MB5898.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0062BDD52C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39860400002)(376002)(366004)(396003)(51444003)(189003)(199004)(256004)(14444005)(229853002)(6486002)(71190400001)(71200400001)(478600001)(66066001)(6512007)(66946007)(5660300002)(3846002)(73956011)(6116002)(6436002)(66556008)(66476007)(25786009)(66446008)(68736007)(14454004)(64756008)(2906002)(53936002)(110136005)(36756003)(6506007)(486006)(31696002)(54906003)(386003)(4326008)(102836004)(99286004)(316002)(81156014)(6246003)(2616005)(8936002)(53546011)(86362001)(7736002)(81166006)(26005)(8676002)(11346002)(31686004)(476003)(76176011)(305945005)(446003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5898;H:DB8PR05MB5897.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YyLSR1ez0P94hM8WLRTHb7Z/OjFd89myHnCQj9DjiwMsAT9gox08T1ceDM1nuh+2ArjsZbY7A/Z/isDmJVDCiva3tk6yF2JOYIre81T16xPqD9PqzSEH72jJGZoQj8i3ut8C/KNrj0M1Hr9vAssvbn6Se86chSuLX8iuV+IqwfwsN/iiBcyetQSJ+X3xI7jrR7KBWwa6Ilx8UexoGAqueMwaxjZL//vmv1gvVv5kReyEA8CN+Ryp4wd0R0lQ8mdxa8lPK/8MwksSepDvH8O6i4YDG+rP+P0FEf9g9XfUNNOPZMwoozcMigsEUyVDWI4xZHXZAbQb1CNiR2MWReYRtsVszLnXE+2VKkYuy3EF1OfDTF46ZInnHZOVMiPvyk3vcrxOUogqPj+sh1QrvpdNlGHzRb8ZvS+L6NktLNu+rdg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A50B5A2C7F7D545AF8F25908BFECDD2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 857e3b7d-a570-4573-fdb4-08d6ec0328c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2019 11:19:23.5175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elibr@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5898
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzcvMjAxOSA5OjIwIFBNLCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToNCj4gT24gV2VkLCAy
MDE5LTA2LTA1IGF0IDE4OjQyIC0wNzAwLCBDb25nIFdhbmcgd3JvdGU6DQo+PiBPbiBUdWUsIEp1
biA0LCAyMDE5IGF0IDExOjE5IEFNIEVsaSBCcml0c3RlaW4gPGVsaWJyQG1lbGxhbm94LmNvbT4g
d3JvdGU6DQo+IGhlbGxvIENvbmcgYW5kIEVsaSwNCj4NCj4gYW5kIHRoYW5rcyBmb3IgYWxsIHRo
ZSB0aG91Z2h0cy4NCj4NCj4+PiBPbiA2LzQvMjAxOSA4OjU1IFBNLCBDb25nIFdhbmcgd3JvdGU6
DQo+Pj4+IE9uIFNhdCwgSnVuIDEsIDIwMTkgYXQgOToyMiBQTSBFbGkgQnJpdHN0ZWluIDxlbGli
ckBtZWxsYW5veC5jb20+IHdyb3RlOg0KPj4+Pj4gSSB0aGluayB0aGF0J3MgYmVjYXVzZSBRaW5R
LCBvciBWTEFOIGlzIG5vdCBhbiBlbmNhcHN1bGF0aW9uLiBUaGVyZSBpcw0KPj4+Pj4gbm8gb3V0
ZXIvaW5uZXIgcGFja2V0cywgYW5kIGlmIHlvdSB3YW50IHRvIG1hbmdsZSBmaWVsZHMgaW4gdGhl
IHBhY2tldA0KPj4+Pj4geW91IGNhbiBkbyBpdCBhbmQgdGhlIHJlc3VsdCBpcyB3ZWxsLWRlZmlu
ZWQuDQo+Pj4+IFNvcnQgb2YsIHBlcmhhcHMgVkxBTiB0YWdzIGFyZSB0b28gc2hvcnQgdG8gYmUg
Y2FsbGVkIGFzIGFuDQo+Pj4+IGVuY2Fwc3VsYXRpb24sIG15IHBvaW50IGlzIHRoYXQgaXQgc3Rp
bGwgbmVlZHMgc29tZSBlbmRwb2ludHMgdG8gcHVzaA0KPj4+PiBvciBwb3AgdGhlIHRhZ3MsIGlu
IGEgc2ltaWxhciB3YXkgd2UgZG8gZW5jYXAvZGVjYXAuDQo+Pj4+DQo+Pj4+DQo+Pj4+PiBCVFcs
IHRoZSBtb3RpdmF0aW9uIGZvciBteSBmaXggd2FzIGEgdXNlIGNhc2Ugd2VyZSAyIFZHVCBWTXMN
Cj4+Pj4+IGNvbW11bmljYXRpbmcgYnkgT1ZTIGZhaWxlZC4gU2luY2UgT1ZTIHNlZXMgdGhlIHNh
bWUgVkxBTiB0YWcsIGl0DQo+Pj4+PiBkb2Vzbid0IGFkZCBleHBsaWNpdCBWTEFOIHBvcC9wdXNo
IGFjdGlvbnMgKGkuZSBwb3AsIG1hbmdsZSwgcHVzaCkuIElmDQo+Pj4+PiB5b3UgZm9yY2UgZXhw
bGljaXQgcG9wL21hbmdsZS9wdXNoIHlvdSB3aWxsIGJyZWFrIHN1Y2ggYXBwbGljYXRpb25zLg0K
Pj4+PiAgIEZyb20gd2hhdCB5b3Ugc2FpZCwgaXQgc2VlbXMgYWN0X2NzdW0gaXMgaW4gdGhlIG1p
ZGRsZSBvZiBwYWNrZXQNCj4+Pj4gcmVjZWl2ZS90cmFuc21pdCBwYXRoLiBTbywgd2hpY2ggaXMg
dGhlIG9uZSBwb3BzIHRoZSBWTEFOIHRhZ3MgaW4NCj4+Pj4gdGhpcyBzY2VuYXJpbz8gSWYgdGhl
IFZNJ3MgYXJlIHRoZSBlbmRwb2ludHMsIHdoeSBub3QgdXNlIGFjdF9jc3VtDQo+Pj4+IHRoZXJl
Pw0KPj4+IEluIGEgc3dpdGNoZGV2IG1vZGUsIHdlIGNhbiBwYXNzdGhydSB0aGUgVkZzIHRvIFZN
cywgYW5kIGhhdmUgdGhlaXINCj4+PiByZXByZXNlbnRvcnMgaW4gdGhlIGhvc3QsIGVuYWJsaW5n
IHVzIHRvIG1hbmlwdWxhdGUgdGhlIEhXIGVzd2l0Y2gNCj4+PiB3aXRob3V0IGtub3dsZWRnZSBv
ZiB0aGUgVk1zLg0KPj4+DQo+Pj4gVG8gc2ltcGxpZnkgaXQsIGNvbnNpZGVyIHRoZSBmb2xsb3dp
bmcgc2V0dXA6DQo+Pj4NCj4+PiB2MWEgPC0+IHYxYiBhbmQgdjJhIDwtPiB2MmIgYXJlIHZldGgg
cGFpcnMuDQo+Pj4NCj4+PiBOb3csIHdlIGNvbmZpZ3VyZSB2MWEuMjAgYW5kIHYyYS4yMCBhcyBW
TEFOIGRldmljZXMgb3ZlciB2MWEvdjJhDQo+Pj4gcmVzcGVjdGl2ZWx5IChhbmQgcHV0IHRoZSAi
YSIgZGV2cyBpbiBzZXBhcmF0ZSBuYW1lc3BhY2VzKS4NCj4+Pg0KPj4+IFRoZSBUQyBydWxlcyBh
cmUgb24gdGhlICJiIiBkZXZzLCBmb3IgZXhhbXBsZToNCj4+Pg0KPj4+IHRjIGZpbHRlciBhZGQg
ZGV2IHYxYiAuLi4gYWN0aW9uIHBlZGl0IC4uLiBhY3Rpb24gY3N1bSAuLi4gYWN0aW9uDQo+Pj4g
cmVkaXJlY3QgZGV2IHYyYg0KPj4+DQo+Pj4gTm93LCBwaW5nIGZyb20gdjFhLjIwIHRvIHYxYi4y
MC4gVGhlIG5hbWVzcGFjZXMgdHJhbnNtaXQvcmVjZWl2ZSB0YWdnZWQNCj4+PiBwYWNrZXRzLCBh
bmQgYXJlIG5vdCBhd2FyZSBvZiB0aGUgcGFja2V0IG1hbmlwdWxhdGlvbiAoYW5kIHRoZSByZXF1
aXJlZA0KPj4+IGFjdF9jc3VtKS4NCj4+IFRoaXMgaXMgd2hhdCBJIHNhaWQsIHYxYiBpcyBub3Qg
dGhlIGVuZHBvaW50IHdoaWNoIHBvcHMgdGhlIHZsYW4gdGFnLA0KPj4gdjFiLjIwIGlzLiBTbywg
d2h5IG5vdCBzaW1wbHkgbW92ZSBhdCBsZWFzdCB0aGUgY3N1bSBhY3Rpb24gdG8NCj4+IHYxYi4y
MD8gV2l0aCB0aGF0LCB5b3UgY2FuIHN0aWxsIGZpbHRlciBhbmQgcmVkaXJlY3QgcGFja2V0cyBv
biB2MWIsDQo+PiB5b3Ugc3RpbGwgZXZlbiBtb2RpZnkgaXQgdG9vLCBqdXN0IGRlZmVyIHRoZSBj
aGVja3N1bSBmaXh1cCB0byB0aGUNCj4+IGVuZHBvaW50Lg0KPj4NCj4+IEFuZCB0byBiZSBmYWly
LCBpZiB0aGlzIGNhc2UgaXMgYSB2YWxpZCBjb25jZXJuLCBzbyBpcyBWWExBTiBjYXNlLA0KPj4g
anVzdCByZXBsYWNlIHYxYS4yMCBhbmQgdjJhLjIwIHdpdGggVlhMQU4gdHVubmVscy4gSWYgeW91
IG1vZGlmeQ0KPj4gdGhlIGlubmVyIGhlYWRlciwgeW91IGhhdmUgdG8gZml4dXAgdGhlIGNoZWNr
c3VtIGluIHRoZSBvdXRlcg0KPj4gVURQIGhlYWRlci4NCj4gYXQgbGVhc3Qgd2l0aCBzaW5nbGUg
ImFjY2VsZXJhdGVkIiB2bGFuIHRhZ3MsIEkgdGhpbmsgdGhhdCB1c2VycyBvZg0KPiB0Y19za2Jf
cHJvdG9jb2woKSB0aGF0IGV4cGxpY2l0bHkgYWNjZXNzIHRoZSBJUCBoZWFkZXIgc2hvdWxkIGJl
IGZpeGVkIHRoZQ0KPiBzYW1lIHdheSB0aGF0IEVsaSBkaWQgdG8gJ2NzdW0nLg0KPg0KPiAobm90
ZSB0aGF0ICdwZWRpdCcgaXMgKm5vdCogYW1vbmcgdGhlbSwgYW5kIHRoYXQncyB3aHkgRWxpIG9u
bHkgbmVlZGVkIHRvDQo+IGZpeCAnY3N1bScgaW4gaGlzIHNldHVwIDopICkNCj4gICANCj4gTm93
IEknbSBubyBtb3JlIHN1cmUgYWJvdXQgd2hhdCB0byBkbyB3aXRoIHRoZSBRaW5RIGNhc2UsIHdo
ZXRoZXIgd2UNCj4gc2hvdWxkOg0KPg0KPiBhKSBmaXggbWlzc2luZyBza2JfbWF5X3B1bGwoKSBp
biBjc3VtLCBhbmQgZml4IChhIGNvdXBsZSBvZikgb3RoZXIgYWN0aW9ucw0KPiBpbiB0aGUgc2Ft
ZSB3YXksDQpJJ20gZm9yIHRoYXQuDQo+DQo+IG9yDQo+DQo+IGIpIHJld29yayBhY3RfY3N1bSB3
aGVuIGl0IHdhbnRzIHRvIHJlYWQgdGhlIElQIGhlYWRlciwgaW4gYSB3YXkgdGhhdCBvbmx5DQo+
IGlwIGhlYWRlciBpcyBtYW5nbGVkIG9ubHkgd2hlbiB0aGVyZSBhcmUgb25seSB6ZXJvIG9yIGEg
c2luZ2xlDQo+ICJhY2NlbGVyYXRlZCIgdGFnLCBhbmQgZG8gdGhlIHNhbWUgZm9yIChhIGNvdXBs
ZSBvZikgb3RoZXIgYWN0aW9ucy4NCg0KV2hhdCBpcyB0aGUgY29uY2VwdHVhbGx5IGRpZmZlcmVu
Y2UgYmV0d2VlbiBzaW5nbGUgVkxBTiBhbmQgUWluUT8gT3IsIA0KZXZlbiBiZXR3ZWVuICJhY2Nl
bGVyYXRlZCIgdG8gbm9uLWFjY2VsZXJhdGVkPw0KDQpGdXJ0aGVybW9yZSwgZG9pbmcgdGhhdCB5
b3Ugd291bGQgcmVkdWNlIGZ1bmN0aW9uYWxpdHkgYWxyZWFkeSBleGlzdHMuIA0KRG9uJ3QgZG8g
aXQuDQoNCj4NCj4gVGhlIHBvcC9wdXNoIGFwcHJvYWNoIGJ1aWx0IGluIHRoZSBhY3Rpb24gKCBv
cHRpb24gYSkgKSBmaXhlcyBteQ0KPiBlbnZpcm9ubWVudCAtIGJ1dCBsaWtlIENvbmcgc2F5cywg
aXQgb25seSB3b3VsZCB3b3JrIHdpdGggVkxBTnMsIGFuZCBub3QNCj4gd2l0aCBvdGhlciBlbmNh
cHN1bGF0aW9ucy4gUHJvYmFibHkgaXQgcmVhbGx5IG1ha2VzIHNlbnNlIHRvIHNlZSBpZiBpdCdz
DQo+IHBvc3NpYmxlIHRvIGV4dGVuZCBhY3RfdmxhbiBpbiBhIHdheSB0aGF0IGl0IHJlY29uc3Ry
dWN0cyB0aGUgcGFja2V0IGFmdGVyDQo+IGFuIGl0ZXJhdGlvbiBvZiAndmxhbiBwb3AnLiBUaGlz
IG1pZ2h0IG5vdCBiZSBlYXN5LCBiZWNhdXNlIGV2ZW4gdGhlIGFib3ZlDQo+IGNvbW1hbmQgYXNz
dW1lcyB0aGF0IGlubmVyIGFuZCBvdXRlciB0YWcgaGF2ZSB0aGUgc2FtZSBldGhlcnR5cGUgKHdo
aWNoIGlzDQo+IG5vdCBnZW5lcmFsbHkgdHJ1ZSBmb3IgUWluUSkuDQpBZ2FpbiwgSSB0aGluayBW
TEFOcyBhbmQgZW5jYXBzdWxhdGlvbnMgYXJlIG5vdCB0aGUgc2FtZS4gQWN0aW9ucyBmb3IgDQp0
YWdnZWQgcGFja2V0cyBhcmUgd2VsbCBkZWZpbmVkLCB0aGUgc2FtZSBhcyB0aGV5IGFyZSBvbiBu
YXRpdmUgcGFja2V0cy4gDQpJbiBlbmNhcHN1bGF0aW9ucyB5b3Ugd291bGQgKkhBVkUqIHRvIGRv
IG1ha2UgZGVjYXAvZW5jYXAgaW4gb3JkZXIgdG8gDQphY3Qgb24gaW5uZXIgcGFja2V0Lg0KPg0K
PiBCdXQgdW50aWwgdGhlbiwgd2Ugc2hvdWxkIGFzc3VtZSB0aGF0IHJlYWQvd3JpdGVzIG9mIHRo
ZSBJUCBoZWFkZXIgYXJlIG5vdA0KPiBmZWFzaWJsZSBmb3IgUWluUSB0cmFmZmljLCBqdXN0IGxp
a2UgaXQncyBub3QgcG9zc2libGUgZm9yIHR1bm5lbGVkDQo+IHBhY2tldHMsIGFuZCBhZGp1c3Qg
Y29uZmlndXJhdGlvbiBhY2NvcmRpbmdseS4NCj4NCj4gV0RZVD8NCj4NCg==
