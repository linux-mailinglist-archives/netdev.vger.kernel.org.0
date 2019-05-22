Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A42264E4
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 15:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfEVNiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 09:38:55 -0400
Received: from mail-eopbgr720060.outbound.protection.outlook.com ([40.107.72.60]:61360
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729071AbfEVNiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 09:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43MLB4HPgA58dKsgI10JdOzmiqlGl4F3P7XGhZUHTYE=;
 b=mEKH4j963OZWLzyQ1OQzBvV8SxUyKZ35D6uXid7w4qhklHvibc+nMEdLG2FHOcr5pgS+1bFoD9WuYRsG+VnqvjO23XKN9SJAe2tCM267pbco+1JIbrRfmvD3BGUZXe/FqVC4e5BADtWMQh8Xt1iQYgcuiTvDLyoHeLfpeSC/LSw=
Received: from BL0PR1501MB2003.namprd15.prod.outlook.com (52.132.21.33) by
 BL0PR1501MB2004.namprd15.prod.outlook.com (52.132.21.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 22 May 2019 13:38:49 +0000
Received: from BL0PR1501MB2003.namprd15.prod.outlook.com
 ([fe80::ec20:2800:8222:be11]) by BL0PR1501MB2003.namprd15.prod.outlook.com
 ([fe80::ec20:2800:8222:be11%7]) with mapi id 15.20.1922.017; Wed, 22 May 2019
 13:38:49 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     syzbot <syzbot+6440134c13554d3abfb0@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hujunwei4@huawei.com" <hujunwei4@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "wangxiaogang3@huawei.com" <wangxiaogang3@huawei.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>
Subject: RE: WARNING: locking bug in rhashtable_walk_enter
Thread-Topic: WARNING: locking bug in rhashtable_walk_enter
Thread-Index: AQHVDUtNbnu/4SfwKUSdAx29g20ccqZ2F/MAgAEUXhA=
Date:   Wed, 22 May 2019 13:38:49 +0000
Message-ID: <BL0PR1501MB20031626FEB1022DB74D08219A000@BL0PR1501MB2003.namprd15.prod.outlook.com>
References: <000000000000ac9447058924709c@google.com>
 <00000000000071c8a105896c3ef2@google.com>
In-Reply-To: <00000000000071c8a105896c3ef2@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [198.24.6.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90b695a5-37ba-4558-7a8c-08d6debad29e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BL0PR1501MB2004;
x-ms-traffictypediagnostic: BL0PR1501MB2004:
x-ms-exchange-purlcount: 8
x-microsoft-antispam-prvs: <BL0PR1501MB2004FA470A77D6401031A1539A000@BL0PR1501MB2004.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:94;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(366004)(396003)(13464003)(189003)(199004)(2906002)(6116002)(110136005)(3846002)(53936002)(8936002)(55016002)(6246003)(305945005)(81166006)(81156014)(6436002)(8676002)(6306002)(9686003)(7736002)(2501003)(316002)(71190400001)(71200400001)(66066001)(229853002)(256004)(14444005)(966005)(14454004)(478600001)(74316002)(68736007)(76176011)(44832011)(33656002)(86362001)(52536014)(186003)(26005)(11346002)(7696005)(486006)(2201001)(6506007)(53546011)(5660300002)(76116006)(66476007)(66946007)(64756008)(66556008)(102836004)(66446008)(73956011)(446003)(99286004)(476003)(25786009)(99710200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR1501MB2004;H:BL0PR1501MB2003.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Yl39kwJLjJM5MScK7PQdoQZDKLXyhEdraOe1ENi1ZAT8gV4iqpm0zSjWyxzCSRezoAXiXhV87bCXNf4TcTAxFY4itz8WOVwktS1DYmLNbMObzBOL4NqObX1sWxjsuT3wvF21Zl9z5Zg8acBbfoUIGhhMpVNqbXdaT0EaFotvQQESdhdW+3r4m1Ki6NQ19rNb/5KSnCwD3A8IxWIfMrQ8lyMT3F/sgdy9LUubC3VpcSQroOT03EjX4zyZ4OLfacVoLsWiCuXeHq99eCsfE2LaUCrvu27BBnsCnE18WKGdiZDpfLSatCDNHLZss5iXWcwr0hNRgFTgRvrrFXmBXGfSzbWy6mmOli3at5f/N2DV8CoEJGqF2rn4cMkbjvfjOfh/zpNoiIe0ABKweYiES5CxxnrhPIZH29Wq4987nRTPopc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b695a5-37ba-4558-7a8c-08d6debad29e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 13:38:49.5450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2004
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2LW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4NCj4gT24gQmVoYWxm
IE9mIHN5emJvdA0KPiBTZW50OiAyMS1NYXktMTkgMTc6MDgNCj4gVG86IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IGh1anVud2VpNEBodWF3ZWkuY29tOyBKb24gTWFsb3kNCj4gPGpvbi5tYWxveUBlcmlj
c3Nvbi5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBzeXprYWxsZXItYnVnc0Bnb29nbGVncm91cHMuY29tOyB0aXBjLQ0KPiBkaXNj
dXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldDsgd2FuZ3hpYW9nYW5nM0BodWF3ZWkuY29tOw0K
PiB5aW5nLnh1ZUB3aW5kcml2ZXIuY29tDQo+IFN1YmplY3Q6IFJlOiBXQVJOSU5HOiBsb2NraW5n
IGJ1ZyBpbiByaGFzaHRhYmxlX3dhbGtfZW50ZXINCj4gDQo+IHN5emJvdCBoYXMgYmlzZWN0ZWQg
dGhpcyBidWcgdG86DQo+IA0KPiBjb21taXQgN2UyN2U4ZDYxMzBjNWU4OGZhYzlkZGVjNDI0OWY3
ZjIzMzdmZTdmOA0KPiBBdXRob3I6IEp1bndlaSBIdSA8aHVqdW53ZWk0QGh1YXdlaS5jb20+DQo+
IERhdGU6ICAgVGh1IE1heSAxNiAwMjo1MToxNSAyMDE5ICswMDAwDQo+IA0KPiAgICAgIHRpcGM6
IHN3aXRjaCBvcmRlciBvZiBkZXZpY2UgcmVnaXN0cmF0aW9uIHRvIGZpeCBhIGNyYXNoDQoNClRo
aXMgYnVnIHdhcyBmaXhlZCBieToNCmNvbW1pdCA1MjZmNWI4NTFhOTYgKCIgdGlwYzogZml4IG1v
ZHByb2JlIHRpcGMgZmFpbGVkIGFmdGVyIHN3aXRjaCBvcmRlciBvZiBkZXZpY2UgcmVnaXN0cmF0
aW9uIikNCg0KLy8vam9uDQoNCj4gDQo+IGJpc2VjdGlvbiBsb2c6ICBodHRwczovL3Byb3RlY3Qy
LmZpcmVleWUuY29tL3VybD9rPWM0ZmEwZDZlLTk4MmUwOGQxLQ0KPiBjNGZhNGRmNS04NjhmNjMz
ZGJmMjUtDQo+IDI2NWVlYWI4OWMzYzYyZTMmcT0xJnU9aHR0cHMlM0ElMkYlMkZzeXprYWxsZXIu
YXBwc3BvdC5jb20lMkZ4JTINCj4gRmJpc2VjdC50eHQlM0Z4JTNEMTI4NWQzOWNhMDAwMDANCj4g
c3RhcnQgY29tbWl0OiAgIGY0OWFhMWRlIE1lcmdlIHRhZyAnZm9yLTUuMi1yYzEtdGFnJyBvZiBn
aXQ6Ly9naXQua2VybmVsLm8uLg0KPiBnaXQgdHJlZTogICAgICAgdXBzdHJlYW0NCj4gZmluYWwg
Y3Jhc2g6ICAgIGh0dHBzOi8vcHJvdGVjdDIuZmlyZWV5ZS5jb20vdXJsP2s9Zjg5MmMzYmYtYTQ0
NmM2MDAtDQo+IGY4OTI4MzI0LTg2OGY2MzNkYmYyNS0NCj4gYTFmMjU5ZjQxYzJlM2M3MCZxPTEm
dT1odHRwcyUzQSUyRiUyRnN5emthbGxlci5hcHBzcG90LmNvbSUyRnglMkYNCj4gcmVwb3J0LnR4
dCUzRnglM0QxMTg1ZDM5Y2EwMDAwMA0KPiBjb25zb2xlIG91dHB1dDogaHR0cHM6Ly9wcm90ZWN0
Mi5maXJlZXllLmNvbS91cmw/az1hMjY1ZTk5Ny1mZWIxZWMyOC0NCj4gYTI2NWE5MGMtODY4ZjYz
M2RiZjI1LQ0KPiAzNTM2YzE4NDE0ZjA5ODVkJnE9MSZ1PWh0dHBzJTNBJTJGJTJGc3l6a2FsbGVy
LmFwcHNwb3QuY29tJTJGeCUyDQo+IEZsb2cudHh0JTNGeCUzRDE2ODVkMzljYTAwMDAwDQo+IGtl
cm5lbCBjb25maWc6ICBodHRwczovL3Byb3RlY3QyLmZpcmVleWUuY29tL3VybD9rPWUwNjNkOWNl
LWJjYjdkYzcxLQ0KPiBlMDYzOTk1NS04NjhmNjMzZGJmMjUtDQo+IDM0ZmI2OWRlYjNkOWJiNjAm
cT0xJnU9aHR0cHMlM0ElMkYlMkZzeXprYWxsZXIuYXBwc3BvdC5jb20lMkZ4JQ0KPiAyRi5jb25m
aWclM0Z4JTNEZmMwNDUxMzE0NzI5NDdkNw0KPiBkYXNoYm9hcmQgbGluazogaHR0cHM6Ly9wcm90
ZWN0Mi5maXJlZXllLmNvbS91cmw/az1iMWFjODQzNS1lZDc4ODE4YS0NCj4gYjFhY2M0YWUtODY4
ZjYzM2RiZjI1LQ0KPiA5MmY5NWJmZjFhZTRiMDVkJnE9MSZ1PWh0dHBzJTNBJTJGJTJGc3l6a2Fs
bGVyLmFwcHNwb3QuY29tJTJGYnVnDQo+ICUzRmV4dGlkJTNENjQ0MDEzNGMxMzU1NGQzYWJmYjAN
Cj4gc3l6IHJlcHJvOiAgICAgIGh0dHBzOi8vcHJvdGVjdDIuZmlyZWV5ZS5jb20vdXJsP2s9MDQ3
M2Y1ZTUtNThhN2YwNWEtDQo+IDA0NzNiNTdlLTg2OGY2MzNkYmYyNS0NCj4gM2Q4ZGEzN2RkODUy
YWMzYiZxPTEmdT1odHRwcyUzQSUyRiUyRnN5emthbGxlci5hcHBzcG90LmNvbSUyRnglMg0KPiBG
cmVwcm8uc3l6JTNGeCUzRDEwYzU4NmJjYTAwMDAwDQo+IEMgcmVwcm9kdWNlcjogICBodHRwczov
L3Byb3RlY3QyLmZpcmVleWUuY29tL3VybD9rPTA3OTdiYWM1LTViNDNiZjdhLQ0KPiAwNzk3ZmE1
ZS04NjhmNjMzZGJmMjUtDQo+IGJhNWRhMDRhOTYwNGJlODYmcT0xJnU9aHR0cHMlM0ElMkYlMkZz
eXprYWxsZXIuYXBwc3BvdC5jb20lMkZ4JTINCj4gRnJlcHJvLmMlM0Z4JTNEMTQ3NTlmYjJhMDAw
MDANCj4gDQo+IFJlcG9ydGVkLWJ5OiBzeXpib3QrNjQ0MDEzNGMxMzU1NGQzYWJmYjBAc3l6a2Fs
bGVyLmFwcHNwb3RtYWlsLmNvbQ0KPiBGaXhlczogN2UyN2U4ZDYxMzBjICgidGlwYzogc3dpdGNo
IG9yZGVyIG9mIGRldmljZSByZWdpc3RyYXRpb24gdG8gZml4IGENCj4gY3Jhc2giKQ0KPiANCj4g
Rm9yIGluZm9ybWF0aW9uIGFib3V0IGJpc2VjdGlvbiBwcm9jZXNzIHNlZToNCj4gaHR0cHM6Ly9w
cm90ZWN0Mi5maXJlZXllLmNvbS91cmw/az1kZDg0NDNkMy04MTUwNDY2Yy1kZDg0MDM0OC0NCj4g
ODY4ZjYzM2RiZjI1LQ0KPiBlODc2NmViNjMzZDRlNDNkJnE9MSZ1PWh0dHBzJTNBJTJGJTJGZ29v
LmdsJTJGdHBzbUVKJTIzYmlzZWN0aW8NCj4gbg0K
