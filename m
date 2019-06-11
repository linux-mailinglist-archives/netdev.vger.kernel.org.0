Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934603C278
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390492AbfFKEnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:43:09 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:58310
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388313AbfFKEnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 00:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XcU1CoAGusIHcuhD/xcscZiBuDzKIDN8bcgDJO7Ur0=;
 b=FVW8aLvScxIpN912AiQbZ5yDIuD3zilugczyvsDUp6Ei/9gYDwM1HKcYsZ69rhBOq3clNVi+VTN5E7QQe9CD/G9eHVUFvzId9CGQ+MpfGBalZeuTn5Au20vlN7KvwpvE4IrelyqB16ZUFf52knDUok4TJYDGtXC99haa8erayOc=
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com (20.179.9.78) by
 DB8PR05MB6105.eurprd05.prod.outlook.com (20.179.10.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Tue, 11 Jun 2019 04:43:02 +0000
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166]) by DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166%5]) with mapi id 15.20.1987.010; Tue, 11 Jun 2019
 04:43:02 +0000
From:   Eli Britstein <elibr@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Davide Caratti <dcaratti@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
Thread-Index: AQHVF9YCXzM5AJb6fEe3JxZQMbJbvaaFkZSAgAA3bgCAAAgFAIAB9OqAgAQHtICAAAbcAIACDfsAgABBmwCAB4wHAIAAQH4A
Date:   Tue, 11 Jun 2019 04:43:02 +0000
Message-ID: <de51a01e-f0bd-cc18-bba4-93c6e07bb910@mellanox.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
 <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
 <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
 <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
 <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
 <464000e5-3cb0-c837-4edb-9dfcbfeffcec@mellanox.com>
 <CAM_iQpX=KqnYP6O139WxH-ouF=vM2=42HS4WLK9PK0E76J-GGw@mail.gmail.com>
In-Reply-To: <CAM_iQpX=KqnYP6O139WxH-ouF=vM2=42HS4WLK9PK0E76J-GGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0082.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::23) To DB8PR05MB5897.eurprd05.prod.outlook.com
 (2603:10a6:10:a5::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elibr@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.120.174.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f34b9f9b-503d-45cd-d522-08d6ee274987
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6105;
x-ms-traffictypediagnostic: DB8PR05MB6105:
x-microsoft-antispam-prvs: <DB8PR05MB6105E9CAA6138EC0FE4F87BFD5ED0@DB8PR05MB6105.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(366004)(39860400002)(376002)(189003)(199004)(51444003)(2616005)(26005)(256004)(66946007)(73956011)(5660300002)(64756008)(8676002)(476003)(81166006)(8936002)(81156014)(66476007)(66446008)(66556008)(6246003)(6486002)(86362001)(31696002)(4326008)(7736002)(486006)(54906003)(102836004)(6512007)(6436002)(305945005)(229853002)(53546011)(99286004)(6506007)(386003)(68736007)(66574012)(76176011)(53936002)(31686004)(25786009)(36756003)(52116002)(2906002)(186003)(316002)(3846002)(478600001)(71200400001)(71190400001)(6116002)(14454004)(66066001)(11346002)(6916009)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6105;H:DB8PR05MB5897.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hsj1LaCBlxZv0YyDpA3iSCbGdEVXYjsv8Od/fgVRmAqOV1evSuFs8C4cu0ymSq1agh1ckI5c6jkmqX4z2xyZkxHVbEETYeAd8baqX9o/+vsP4xUTK+gorWZ5mQ1Zdsm3w5udWLCdoeAn2fMeWNYAjgzCOshb5EbuLUYx5hMLfAhBSF8CW+RyBdPzoIizneDIFU/TpZziK9OCJBBvvOZ3Fiom0Sse9xAWzzxKQp8rQmFEvFPXp7u6uHG97aAHJgCu+2OM86Ch/bTMn5Xyya/PIyhOr/PCc5F23797zbddf/TQWuio8hqulE3XF77c3UtqpdjylaUQQt1XvOAT1BV6l6yRJeTDm4287lfLXSBt7r0K6E0e4ompJ+hzUGdDGwYrKeGraFi7Q3s2tinxMxD1zfT6+p1/5d93nmwr8cuwWy0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5ACDF175032B9F468BC425FDAF63EF28@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34b9f9b-503d-45cd-d522-08d6ee274987
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 04:43:02.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elibr@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzExLzIwMTkgMzo1MiBBTSwgQ29uZyBXYW5nIHdyb3RlOg0KPiBPbiBXZWQsIEp1biA1
LCAyMDE5IGF0IDEwOjM3IFBNIEVsaSBCcml0c3RlaW4gPGVsaWJyQG1lbGxhbm94LmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gT24gNi82LzIwMTkgNDo0MiBBTSwgQ29uZyBXYW5nIHdyb3RlOg0KPj4+IE9u
IFR1ZSwgSnVuIDQsIDIwMTkgYXQgMTE6MTkgQU0gRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFu
b3guY29tPiB3cm90ZToNCj4+Pj4gT24gNi80LzIwMTkgODo1NSBQTSwgQ29uZyBXYW5nIHdyb3Rl
Og0KPj4+Pj4gT24gU2F0LCBKdW4gMSwgMjAxOSBhdCA5OjIyIFBNIEVsaSBCcml0c3RlaW4gPGVs
aWJyQG1lbGxhbm94LmNvbT4gd3JvdGU6DQo+Pj4+Pj4gSSB0aGluayB0aGF0J3MgYmVjYXVzZSBR
aW5RLCBvciBWTEFOIGlzIG5vdCBhbiBlbmNhcHN1bGF0aW9uLiBUaGVyZSBpcw0KPj4+Pj4+IG5v
IG91dGVyL2lubmVyIHBhY2tldHMsIGFuZCBpZiB5b3Ugd2FudCB0byBtYW5nbGUgZmllbGRzIGlu
IHRoZSBwYWNrZXQNCj4+Pj4+PiB5b3UgY2FuIGRvIGl0IGFuZCB0aGUgcmVzdWx0IGlzIHdlbGwt
ZGVmaW5lZC4NCj4+Pj4+IFNvcnQgb2YsIHBlcmhhcHMgVkxBTiB0YWdzIGFyZSB0b28gc2hvcnQg
dG8gYmUgY2FsbGVkIGFzIGFuDQo+Pj4+PiBlbmNhcHN1bGF0aW9uLCBteSBwb2ludCBpcyB0aGF0
IGl0IHN0aWxsIG5lZWRzIHNvbWUgZW5kcG9pbnRzIHRvIHB1c2gNCj4+Pj4+IG9yIHBvcCB0aGUg
dGFncywgaW4gYSBzaW1pbGFyIHdheSB3ZSBkbyBlbmNhcC9kZWNhcC4NCj4+Pj4+DQo+Pj4+Pg0K
Pj4+Pj4+IEJUVywgdGhlIG1vdGl2YXRpb24gZm9yIG15IGZpeCB3YXMgYSB1c2UgY2FzZSB3ZXJl
IDIgVkdUIFZNcw0KPj4+Pj4+IGNvbW11bmljYXRpbmcgYnkgT1ZTIGZhaWxlZC4gU2luY2UgT1ZT
IHNlZXMgdGhlIHNhbWUgVkxBTiB0YWcsIGl0DQo+Pj4+Pj4gZG9lc24ndCBhZGQgZXhwbGljaXQg
VkxBTiBwb3AvcHVzaCBhY3Rpb25zIChpLmUgcG9wLCBtYW5nbGUsIHB1c2gpLiBJZg0KPj4+Pj4+
IHlvdSBmb3JjZSBleHBsaWNpdCBwb3AvbWFuZ2xlL3B1c2ggeW91IHdpbGwgYnJlYWsgc3VjaCBh
cHBsaWNhdGlvbnMuDQo+Pj4+PiAgICBGcm9tIHdoYXQgeW91IHNhaWQsIGl0IHNlZW1zIGFjdF9j
c3VtIGlzIGluIHRoZSBtaWRkbGUgb2YgcGFja2V0DQo+Pj4+PiByZWNlaXZlL3RyYW5zbWl0IHBh
dGguIFNvLCB3aGljaCBpcyB0aGUgb25lIHBvcHMgdGhlIFZMQU4gdGFncyBpbg0KPj4+Pj4gdGhp
cyBzY2VuYXJpbz8gSWYgdGhlIFZNJ3MgYXJlIHRoZSBlbmRwb2ludHMsIHdoeSBub3QgdXNlIGFj
dF9jc3VtDQo+Pj4+PiB0aGVyZT8NCj4+Pj4gSW4gYSBzd2l0Y2hkZXYgbW9kZSwgd2UgY2FuIHBh
c3N0aHJ1IHRoZSBWRnMgdG8gVk1zLCBhbmQgaGF2ZSB0aGVpcg0KPj4+PiByZXByZXNlbnRvcnMg
aW4gdGhlIGhvc3QsIGVuYWJsaW5nIHVzIHRvIG1hbmlwdWxhdGUgdGhlIEhXIGVzd2l0Y2gNCj4+
Pj4gd2l0aG91dCBrbm93bGVkZ2Ugb2YgdGhlIFZNcy4NCj4+Pj4NCj4+Pj4gVG8gc2ltcGxpZnkg
aXQsIGNvbnNpZGVyIHRoZSBmb2xsb3dpbmcgc2V0dXA6DQo+Pj4+DQo+Pj4+IHYxYSA8LT4gdjFi
IGFuZCB2MmEgPC0+IHYyYiBhcmUgdmV0aCBwYWlycy4NCj4+Pj4NCj4+Pj4gTm93LCB3ZSBjb25m
aWd1cmUgdjFhLjIwIGFuZCB2MmEuMjAgYXMgVkxBTiBkZXZpY2VzIG92ZXIgdjFhL3YyYQ0KPj4+
PiByZXNwZWN0aXZlbHkgKGFuZCBwdXQgdGhlICJhIiBkZXZzIGluIHNlcGFyYXRlIG5hbWVzcGFj
ZXMpLg0KPj4+Pg0KPj4+PiBUaGUgVEMgcnVsZXMgYXJlIG9uIHRoZSAiYiIgZGV2cywgZm9yIGV4
YW1wbGU6DQo+Pj4+DQo+Pj4+IHRjIGZpbHRlciBhZGQgZGV2IHYxYiAuLi4gYWN0aW9uIHBlZGl0
IC4uLiBhY3Rpb24gY3N1bSAuLi4gYWN0aW9uDQo+Pj4+IHJlZGlyZWN0IGRldiB2MmINCj4+Pj4N
Cj4+Pj4gTm93LCBwaW5nIGZyb20gdjFhLjIwIHRvIHYxYi4yMC4gVGhlIG5hbWVzcGFjZXMgdHJh
bnNtaXQvcmVjZWl2ZSB0YWdnZWQNCj4+Pj4gcGFja2V0cywgYW5kIGFyZSBub3QgYXdhcmUgb2Yg
dGhlIHBhY2tldCBtYW5pcHVsYXRpb24gKGFuZCB0aGUgcmVxdWlyZWQNCj4+Pj4gYWN0X2NzdW0p
Lg0KPj4+IFRoaXMgaXMgd2hhdCBJIHNhaWQsIHYxYiBpcyBub3QgdGhlIGVuZHBvaW50IHdoaWNo
IHBvcHMgdGhlIHZsYW4gdGFnLA0KPj4+IHYxYi4yMCBpcy4gU28sIHdoeSBub3Qgc2ltcGx5IG1v
dmUgYXQgbGVhc3QgdGhlIGNzdW0gYWN0aW9uIHRvDQo+Pj4gdjFiLjIwPyBXaXRoIHRoYXQsIHlv
dSBjYW4gc3RpbGwgZmlsdGVyIGFuZCByZWRpcmVjdCBwYWNrZXRzIG9uIHYxYiwNCj4+PiB5b3Ug
c3RpbGwgZXZlbiBtb2RpZnkgaXQgdG9vLCBqdXN0IGRlZmVyIHRoZSBjaGVja3N1bSBmaXh1cCB0
byB0aGUNCj4+PiBlbmRwb2ludC4NCj4+IFRoZXJlIGFyZSBubyB2eGIuMjAgcG9ydHM6DQo+Pg0K
Pj4gbnMwOiAgICAgdjFhLjIwIC0tLS0oVkxBTiktLS0tIHYxYSBuczE6ICAgIHYyYSAtLS0tIChW
TEFOKSAtLS0tIHYyYS4yMA0KPj4NCj4+IHwtLS0tKHZldGgpLS0tLSB2MWIgICAgIDwtLS0tIChU
QykgLS0tLT4gICAgdjJiIC0tLS0odmV0aCktLS0tfA0KPg0KPiBUaGlzIGRpYWdyYW0gbWFrZXMg
bWUgZXZlbiBtb3JlIGNvbmZ1c2luZy4uLg0KPg0KPiBDYW4geW91IGV4cGxpY2l0bHkgZXhwbGFp
biB3aHkgdGhlcmUgaXMgbm8gdnhiLjIwPyBJcyBpdCBhIHJvdXRlciBvcg0KPiBzb21ldGhpbmc/
DQpZZXMuDQo+DQo+IEJ5IHRoZSB3YXksIGV2ZW4gaWYgaXQgaXMgcm91dGVyIGFuZCB5b3UgcmVh
bGx5IHdhbnQgdG8gY2hlY2tzdW0gdGhlDQo+IHBhY2tldCBhdCB0aGF0IHBvaW50LCB5b3Ugc3Rp
bGwgZG9uJ3QgaGF2ZSB0byBtb3ZlIHRoZSBza2ItPmRhdGENCj4gcG9pbnRlciwgeW91IGp1c3Qg
bmVlZCB0byBwYXJzZSB0aGUgaGVhZGVyIGFuZCBjYWxjdWxhdGUgdGhlIG9mZnNldA0KPiB3aXRo
b3V0IHRvdWNoaW5nIHNrYi0+ZGF0YS4gVGhpcyBjb3VsZCBhdCBsZWFzdCBhdm9pZCByZXN0b3Jp
bmcNCj4gc2tiLT5kYXRhIGFmdGVyIGl0Lg0KU3VyZSwgdGhpcyBpcyBhbm90aGVyIGltcGxlbWVu
dGF0aW9uIG1ldGhvZC4gSXQgZG9lc24ndCBjaGFuZ2UgdGhlIA0KZXNzZW5jZS4gSSBqdXN0IHdh
bnRlZCB0byByZXVzZSB0aGUgZXhpc3RpbmcgdGNmX2NzdW1faXB2NC82Lg0KPg0KPiBUaGFua3Mu
DQo=
