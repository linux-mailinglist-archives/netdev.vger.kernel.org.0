Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F3936BB6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 07:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfFFFhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 01:37:54 -0400
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:10247
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFFFhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 01:37:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2syX4BFwNv+1iCTMc9bpxeTCAT37bN0Tq1gv7ZB648=;
 b=li8SnMBXO6JDpf5t+AOUiZDxPypgZRoiY3dj8bL9gfWQ8r9pa1Vz0A1x/uKgtQkuJn15cH42dTBg5VL6Epmtuxo2UOfSkGILm2QJgmLjx0ytx+ejY7O0S1dI4aHfmGSpVmUptCt02VotLiB/Y39zlp5rjY6C5uOAFekb1EgFMD8=
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com (20.179.9.78) by
 DB8PR05MB6091.eurprd05.prod.outlook.com (20.179.9.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 05:37:10 +0000
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166]) by DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166%5]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 05:37:10 +0000
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
Thread-Index: AQHVF9YCXzM5AJb6fEe3JxZQMbJbvaaFkZSAgAA3bgCAAAgFAIAB9OqAgAQHtICAAAbcAIACDfsAgABBmwA=
Date:   Thu, 6 Jun 2019 05:37:10 +0000
Message-ID: <464000e5-3cb0-c837-4edb-9dfcbfeffcec@mellanox.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
 <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
 <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
 <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
 <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
 <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
 <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
In-Reply-To: <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0050.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::27) To DB8PR05MB5897.eurprd05.prod.outlook.com
 (2603:10a6:10:a5::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elibr@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.120.174.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f1b402f-a22c-4554-4941-08d6ea41053a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6091;
x-ms-traffictypediagnostic: DB8PR05MB6091:
x-microsoft-antispam-prvs: <DB8PR05MB6091993DE490426903DB747ED5170@DB8PR05MB6091.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(39860400002)(366004)(346002)(199004)(189003)(51444003)(76176011)(71190400001)(53936002)(99286004)(6246003)(71200400001)(52116002)(26005)(3846002)(6916009)(54906003)(31686004)(6116002)(6512007)(316002)(11346002)(6486002)(229853002)(8676002)(2616005)(6436002)(446003)(25786009)(5660300002)(14454004)(7736002)(305945005)(68736007)(478600001)(66066001)(73956011)(66946007)(66556008)(64756008)(66446008)(53546011)(6506007)(386003)(66476007)(2906002)(86362001)(256004)(36756003)(102836004)(31696002)(4326008)(476003)(8936002)(186003)(486006)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6091;H:DB8PR05MB5897.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KwiwFbI1Y/viL9TnKUZ2oHgE5wlHT6f7is8qdNlFtxwd9h78kIyghArf5ayUZ1to3l+zJY9QG+tgkk7MhUFENY8EZms0Mwdn+zE3+z9Evm3fBjnPMq32mfNTrmtCndm5Bw5pV7/iLklhc4BhS/Q3W3ZA8+pInHaez2J4DNJHWQua9v+4hvGjdbci4n9ImsChOhXCZU6ip5yNQCEAepirNFF0HDTe/Gv0pOoGGseYcATom/IR5bd1DbHHp+Sim30qA/CoQGXNPljk/MSRa1bhb0Ke9hfxmOw1Xlf8qp9oQFFezmruXqdAIyIiLroCm2LJKDNpkW2TWGWVNQwPIRKmr0SsjAI05C9sKmF2rQi9yCBqKkSSzXMFlSdT69TMjDLWbKEuOu1CtkxiZ9NlHZi2YVv6XD+HSAIqtQ70a1h5x9o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <061720D507686D4098204B19BEF4487C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1b402f-a22c-4554-4941-08d6ea41053a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 05:37:10.4371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elibr@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzYvMjAxOSA0OjQyIEFNLCBDb25nIFdhbmcgd3JvdGU6DQo+IE9uIFR1ZSwgSnVuIDQs
IDIwMTkgYXQgMTE6MTkgQU0gRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPiB3cm90
ZToNCj4+DQo+PiBPbiA2LzQvMjAxOSA4OjU1IFBNLCBDb25nIFdhbmcgd3JvdGU6DQo+Pj4gT24g
U2F0LCBKdW4gMSwgMjAxOSBhdCA5OjIyIFBNIEVsaSBCcml0c3RlaW4gPGVsaWJyQG1lbGxhbm94
LmNvbT4gd3JvdGU6DQo+Pj4+IEkgdGhpbmsgdGhhdCdzIGJlY2F1c2UgUWluUSwgb3IgVkxBTiBp
cyBub3QgYW4gZW5jYXBzdWxhdGlvbi4gVGhlcmUgaXMNCj4+Pj4gbm8gb3V0ZXIvaW5uZXIgcGFj
a2V0cywgYW5kIGlmIHlvdSB3YW50IHRvIG1hbmdsZSBmaWVsZHMgaW4gdGhlIHBhY2tldA0KPj4+
PiB5b3UgY2FuIGRvIGl0IGFuZCB0aGUgcmVzdWx0IGlzIHdlbGwtZGVmaW5lZC4NCj4+PiBTb3J0
IG9mLCBwZXJoYXBzIFZMQU4gdGFncyBhcmUgdG9vIHNob3J0IHRvIGJlIGNhbGxlZCBhcyBhbg0K
Pj4+IGVuY2Fwc3VsYXRpb24sIG15IHBvaW50IGlzIHRoYXQgaXQgc3RpbGwgbmVlZHMgc29tZSBl
bmRwb2ludHMgdG8gcHVzaA0KPj4+IG9yIHBvcCB0aGUgdGFncywgaW4gYSBzaW1pbGFyIHdheSB3
ZSBkbyBlbmNhcC9kZWNhcC4NCj4+Pg0KPj4+DQo+Pj4+IEJUVywgdGhlIG1vdGl2YXRpb24gZm9y
IG15IGZpeCB3YXMgYSB1c2UgY2FzZSB3ZXJlIDIgVkdUIFZNcw0KPj4+PiBjb21tdW5pY2F0aW5n
IGJ5IE9WUyBmYWlsZWQuIFNpbmNlIE9WUyBzZWVzIHRoZSBzYW1lIFZMQU4gdGFnLCBpdA0KPj4+
PiBkb2Vzbid0IGFkZCBleHBsaWNpdCBWTEFOIHBvcC9wdXNoIGFjdGlvbnMgKGkuZSBwb3AsIG1h
bmdsZSwgcHVzaCkuIElmDQo+Pj4+IHlvdSBmb3JjZSBleHBsaWNpdCBwb3AvbWFuZ2xlL3B1c2gg
eW91IHdpbGwgYnJlYWsgc3VjaCBhcHBsaWNhdGlvbnMuDQo+Pj4gICBGcm9tIHdoYXQgeW91IHNh
aWQsIGl0IHNlZW1zIGFjdF9jc3VtIGlzIGluIHRoZSBtaWRkbGUgb2YgcGFja2V0DQo+Pj4gcmVj
ZWl2ZS90cmFuc21pdCBwYXRoLiBTbywgd2hpY2ggaXMgdGhlIG9uZSBwb3BzIHRoZSBWTEFOIHRh
Z3MgaW4NCj4+PiB0aGlzIHNjZW5hcmlvPyBJZiB0aGUgVk0ncyBhcmUgdGhlIGVuZHBvaW50cywg
d2h5IG5vdCB1c2UgYWN0X2NzdW0NCj4+PiB0aGVyZT8NCj4+IEluIGEgc3dpdGNoZGV2IG1vZGUs
IHdlIGNhbiBwYXNzdGhydSB0aGUgVkZzIHRvIFZNcywgYW5kIGhhdmUgdGhlaXINCj4+IHJlcHJl
c2VudG9ycyBpbiB0aGUgaG9zdCwgZW5hYmxpbmcgdXMgdG8gbWFuaXB1bGF0ZSB0aGUgSFcgZXN3
aXRjaA0KPj4gd2l0aG91dCBrbm93bGVkZ2Ugb2YgdGhlIFZNcy4NCj4+DQo+PiBUbyBzaW1wbGlm
eSBpdCwgY29uc2lkZXIgdGhlIGZvbGxvd2luZyBzZXR1cDoNCj4+DQo+PiB2MWEgPC0+IHYxYiBh
bmQgdjJhIDwtPiB2MmIgYXJlIHZldGggcGFpcnMuDQo+Pg0KPj4gTm93LCB3ZSBjb25maWd1cmUg
djFhLjIwIGFuZCB2MmEuMjAgYXMgVkxBTiBkZXZpY2VzIG92ZXIgdjFhL3YyYQ0KPj4gcmVzcGVj
dGl2ZWx5IChhbmQgcHV0IHRoZSAiYSIgZGV2cyBpbiBzZXBhcmF0ZSBuYW1lc3BhY2VzKS4NCj4+
DQo+PiBUaGUgVEMgcnVsZXMgYXJlIG9uIHRoZSAiYiIgZGV2cywgZm9yIGV4YW1wbGU6DQo+Pg0K
Pj4gdGMgZmlsdGVyIGFkZCBkZXYgdjFiIC4uLiBhY3Rpb24gcGVkaXQgLi4uIGFjdGlvbiBjc3Vt
IC4uLiBhY3Rpb24NCj4+IHJlZGlyZWN0IGRldiB2MmINCj4+DQo+PiBOb3csIHBpbmcgZnJvbSB2
MWEuMjAgdG8gdjFiLjIwLiBUaGUgbmFtZXNwYWNlcyB0cmFuc21pdC9yZWNlaXZlIHRhZ2dlZA0K
Pj4gcGFja2V0cywgYW5kIGFyZSBub3QgYXdhcmUgb2YgdGhlIHBhY2tldCBtYW5pcHVsYXRpb24g
KGFuZCB0aGUgcmVxdWlyZWQNCj4+IGFjdF9jc3VtKS4NCj4gVGhpcyBpcyB3aGF0IEkgc2FpZCwg
djFiIGlzIG5vdCB0aGUgZW5kcG9pbnQgd2hpY2ggcG9wcyB0aGUgdmxhbiB0YWcsDQo+IHYxYi4y
MCBpcy4gU28sIHdoeSBub3Qgc2ltcGx5IG1vdmUgYXQgbGVhc3QgdGhlIGNzdW0gYWN0aW9uIHRv
DQo+IHYxYi4yMD8gV2l0aCB0aGF0LCB5b3UgY2FuIHN0aWxsIGZpbHRlciBhbmQgcmVkaXJlY3Qg
cGFja2V0cyBvbiB2MWIsDQo+IHlvdSBzdGlsbCBldmVuIG1vZGlmeSBpdCB0b28sIGp1c3QgZGVm
ZXIgdGhlIGNoZWNrc3VtIGZpeHVwIHRvIHRoZQ0KPiBlbmRwb2ludC4NCg0KVGhlcmUgYXJlIG5v
IHZ4Yi4yMCBwb3J0czoNCg0KbnMwOsKgwqDCoMKgIHYxYS4yMCAtLS0tKFZMQU4pLS0tLSB2MWEg
bnMxOsKgwqDCoCB2MmEgLS0tLSAoVkxBTikgLS0tLSB2MmEuMjANCg0KfC0tLS0odmV0aCktLS0t
IHYxYsKgwqDCoMKgIDwtLS0tIChUQykgLS0tLT7CoMKgwqAgdjJiIC0tLS0odmV0aCktLS0tfA0K
DQo+DQo+IEFuZCB0byBiZSBmYWlyLCBpZiB0aGlzIGNhc2UgaXMgYSB2YWxpZCBjb25jZXJuLCBz
byBpcyBWWExBTiBjYXNlLA0KPiBqdXN0IHJlcGxhY2UgdjFhLjIwIGFuZCB2MmEuMjAgd2l0aCBW
WExBTiB0dW5uZWxzLiBJZiB5b3UgbW9kaWZ5DQo+IHRoZSBpbm5lciBoZWFkZXIsIHlvdSBoYXZl
IHRvIGZpeHVwIHRoZSBjaGVja3N1bSBpbiB0aGUgb3V0ZXINCj4gVURQIGhlYWRlci4NCj4NCj4g
VGhhbmtzLg0K
