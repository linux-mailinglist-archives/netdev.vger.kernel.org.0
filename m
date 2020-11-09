Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319ED2AC264
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbgKIRcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:32:48 -0500
Received: from mail-eopbgr700119.outbound.protection.outlook.com ([40.107.70.119]:60001
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729879AbgKIRcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 12:32:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3b0sKaoajG9p01bS5q9ZM872pYt4CL8RtJ2/vJqif/Ur75Yhryz4a41C3cyZ3VsYFwb5TkPPLAdxSp5R7xiATZxM22x9pu6OgyJ3VbkSU+Udf9/RUrZPLdBRizLlLesduIzwIFyZ85ZDzdyltXDQr4uWiTRNbBRn405PXIMQdUdZnTYB6UhebWe0xL4PCxl4bVomB7aJmJe8tDkdB5NvQpCXLCVuiPI6v9JLJnMuXkAC/dT4rLUssT+VVRJA3IM2P+a3GMHHUB1PoB8q0Ov6wv+yPCK9wqJJ7lM3gMJTEKZwJTbhHrRlUQFGHryoN975V6sIRJqaAcbhAmAhqC0aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjFA8d/X7ciGCf7RFzlSeMv/Nipo7S27Gq347DzJZgE=;
 b=LGZtKyQlyn/fVvbIRT8MjjCqNcRTJOrFS6Ucp8wU9SaRR4KrZ8+17c99FqXMeagJ2AbukYwHtKe99Z22jnPv6AHsrrBNVpHTiCQSlkxR6SI3ekc1QabJLPfJdh8PHGKSTqZs3wmRhgmeowKq5Pn1k0bVf5hsimLo1hVoI4WbWtSqyTR/AaYKYMEljS3km19pyb8u6XDTirB0ld/DgMnQ5UUQzInBmFbDiBuMkeEcHbaXp5LRbXYJwy28j+FT0WaBJY02RuSJXhvK1FMU9Uk5mepLpd/QXQEfJuHW0QMypz+gPX9/fAmA4f4mBHy3ZD0NJW4859wxXkFJzJrU0iq0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjFA8d/X7ciGCf7RFzlSeMv/Nipo7S27Gq347DzJZgE=;
 b=DYA0MZqSAmoYOMiosYqbX7t6xzotlTc1tSRQ0UB+njPZHhsfvkRubKbRFf1fzv+oM7YT83L2eJqdDS7Eo4q6ujNDCuZc9hvQiCA/5U0+0yw4ehRm9ele9y+P9Lv3GEW6a3x+vYYH9i0DwHK62G/kgn3ayydjW9vLju+3KWkBwg4=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11)
 by MN2PR13MB3925.namprd13.prod.outlook.com (2603:10b6:208:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.15; Mon, 9 Nov
 2020 17:32:44 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210%9]) with mapi id 15.20.3541.018; Mon, 9 Nov 2020
 17:32:44 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Thread-Topic: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
Thread-Index: AQHWtrHgQGMAEXnlr0WTJWA0fWWPg6nACJ0AgAABGQCAAAWNAA==
Date:   Mon, 9 Nov 2020 17:32:44 +0000
Message-ID: <f03dae6d36c0f008796ae01bbb6de3673e783571.camel@hammerspace.com>
References: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
         <9ce015245c916b2c90de72440a22f801142f2c6e.camel@hammerspace.com>
         <0313136F-6801-434F-8304-72B9EADD389E@oracle.com>
In-Reply-To: <0313136F-6801-434F-8304-72B9EADD389E@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f83d973-8135-44eb-9f49-08d884d577de
x-ms-traffictypediagnostic: MN2PR13MB3925:
x-microsoft-antispam-prvs: <MN2PR13MB3925859E6EC54A8D3A541E8BB8EA0@MN2PR13MB3925.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: auNRPMV4zvznfKNXyb1oQHKjUjGA/+FQgq/++MuZOikUtxClgaxh731Uvq1TG0+bxFSHQN4iKCgCUz5cgMMxzr4yV+6X/+7BwkzSUJMoRupxm11EUFHAYP5JJ4gbJdY2spuCk3XnueUY/ez4jLVZ62Yny/D2snAtWOpsLcArqEic9mR6Px1Nj+Uh77/6zr0I/8uZQR5Dr66Tdrb7VRtCHqQTPKg2eMFvqLDgYnpWvvQRuViHig3Pe0N+dVctRiuP0vVdJKZMMgIYybjessnmA3UBAwY3Nm2gUOtPgLcFSAAJfAh5YJtp8JcQyGlG0bu4t1Jr8EEYg6pgwy2S7Iwy3H05rB6XeQH8oSc2n+lThU9pa7/GGGpwqYZREKPrEgsLRHCf+VEJGq6gzInGhSLiDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(366004)(346002)(376002)(86362001)(2906002)(6486002)(26005)(2616005)(66946007)(6916009)(54906003)(5660300002)(966005)(91956017)(76116006)(66476007)(64756008)(66446008)(66556008)(478600001)(4326008)(6512007)(6506007)(186003)(8936002)(53546011)(8676002)(83380400001)(36756003)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /KojvZAwnV+mkd6/1TizRq4b22TZvILhC6zZXIH9FiafBsFUeHhO8XFHG8ww1dnyMS9n3d6d9z36qCNAqfJpkORUWqAftE580z6BwbFVWxIu/YbcnWmEoy4T/+goVeLx45a0roEBIAJK5Crt+njOdYl8HkWmdFlOeEIz0HAWe6tgmhUZSf0ChUy566fQ28U8p2SR7s8bY5oU3GOYEM+fo5Hgb+eDwjc6SM45T15hvYEmhxRqISAG/i8/L7ZIQmZo6aCPavbbKF41lVh2WgDjNekw9cL6xHQHubMJmHAPrtdoxq32ovhNK9Yh7EX659A4FIvq+dDEZKKLhL441lKgjMOYdmFxjiqupQo0ft2rar1zfXeN5ztcTW2wLO6vCLglIPbqhE9S4j3t07dVUFZCPZ4FUAfqJme31BQyr0x+43zDRgX4R+3akVi9NpBl5MgjPVwu+4qj85JzOv3NvdPG0vWaLMFRX1gAur6P71h49SqtYYElqQusEjYT3g/cNQppHLprwbSWwsmnu1i/I7I5v2InLaHzqGmQl48ZJHbnA/UCTyxepMDoHE+d5ff1wXinoVVyNFBvJCzFi8gNYZpUJNFPqw4GckkcThj7fsINVAygJJUbRXnChDRxqGKy5omAyDWPh8tsaC2rTXXztIEpfA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDF5B23DF0765744A7CE58EA30B49CBB@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f83d973-8135-44eb-9f49-08d884d577de
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 17:32:44.5241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EysVcFWSoKJUJiFrFaXYmbO+/V7Fx3gO/nitdLPM1wbGzQu39PZURkiGMN5TZ+HQTiM6ir/T1d9NFscJnaVuMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3925
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTA5IGF0IDEyOjEyIC0wNTAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
DQo+IA0KPiA+IE9uIE5vdiA5LCAyMDIwLCBhdCAxMjowOCBQTSwgVHJvbmQgTXlrbGVidXN0DQo+
ID4gPHRyb25kbXlAaGFtbWVyc3BhY2UuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIDIw
MjAtMTEtMDkgYXQgMTE6MDMgLTA1MDAsIENodWNrIExldmVyIHdyb3RlOg0KPiA+ID4gRGFpcmUg
QnlybmUgcmVwb3J0cyBhIH41MCUgYWdncmVncmF0ZSB0aHJvdWdocHV0IHJlZ3Jlc3Npb24gb24N
Cj4gPiA+IGhpcw0KPiA+ID4gTGludXggTkZTIHNlcnZlciBhZnRlciBjb21taXQgZGExNjYxYjkz
YmY0ICgiU1VOUlBDOiBUZWFjaCBzZXJ2ZXINCj4gPiA+IHRvDQo+ID4gPiB1c2UgeHBydF9zb2Nr
X3NlbmRtc2cgZm9yIHNvY2tldCBzZW5kcyIpLCB3aGljaCByZXBsYWNlZA0KPiA+ID4ga2VybmVs
X3NlbmRfcGFnZSgpIGNhbGxzIGluIE5GU0QncyBzb2NrZXQgc2VuZCBwYXRoIHdpdGggY2FsbHMg
dG8NCj4gPiA+IHNvY2tfc2VuZG1zZygpIHVzaW5nIGlvdl9pdGVyLg0KPiA+ID4gDQo+ID4gPiBJ
bnZlc3RpZ2F0aW9uIHNob3dlZCB0aGF0IHRjcF9zZW5kbXNnKCkgd2FzIG5vdCB1c2luZyB6ZXJv
LWNvcHkNCj4gPiA+IHRvDQo+ID4gPiBzZW5kIHRoZSB4ZHJfYnVmJ3MgYnZlYyBwYWdlcywgYnV0
IGluc3RlYWQgd2FzIHJlbHlpbmcgb24gbWVtY3B5Lg0KPiA+ID4gDQo+ID4gPiBTZXQgdXAgdGhl
IHNvY2tldCBhbmQgZWFjaCBtc2doZHIgdGhhdCBiZWFycyBidmVjIHBhZ2VzIHRvIHVzZQ0KPiA+
ID4gdGhlDQo+ID4gPiB6ZXJvLWNvcHkgbWVjaGFuaXNtIGluIHRjcF9zZW5kbXNnLg0KPiA+ID4g
DQo+ID4gPiBSZXBvcnRlZC1ieTogRGFpcmUgQnlybmUgPGRhaXJlQGRuZWcuY29tPg0KPiA+ID4g
QnVnTGluazogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMDk0
MzkNCj4gPiA+IEZpeGVzOiBkYTE2NjFiOTNiZjQgKCJTVU5SUEM6IFRlYWNoIHNlcnZlciB0byB1
c2UNCj4gPiA+IHhwcnRfc29ja19zZW5kbXNnDQo+ID4gPiBmb3Igc29ja2V0IHNlbmRzIikNCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0K
PiA+ID4gLS0tDQo+ID4gPiDCoG5ldC9zdW5ycGMvc29ja2xpYi5jwqAgfMKgwqDCoCA1ICsrKyst
DQo+ID4gPiDCoG5ldC9zdW5ycGMvc3Zjc29jay5jwqAgfMKgwqDCoCAxICsNCj4gPiA+IMKgbmV0
L3N1bnJwYy94cHJ0c29jay5jIHzCoMKgwqAgMSArDQo+ID4gPiDCoDMgZmlsZXMgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiANCj4gPiA+IFRoaXMgcGF0Y2gg
ZG9lcyBub3QgZnVsbHkgcmVzb2x2ZSB0aGUgaXNzdWUuIERhaXJlIHJlcG9ydHMgaGlnaA0KPiA+
ID4gc29mdElSUSBhY3Rpdml0eSBhZnRlciB0aGUgcGF0Y2ggaXMgYXBwbGllZCwgYW5kIHRoaXMg
YWN0aXZpdHkNCj4gPiA+IHNlZW1zIHRvIHByZXZlbnQgZnVsbCByZXN0b3JhdGlvbiBvZiBwcmV2
aW91cyBwZXJmb3JtYW5jZS4NCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0
L3N1bnJwYy9zb2NrbGliLmMgYi9uZXQvc3VucnBjL3NvY2tsaWIuYw0KPiA+ID4gaW5kZXggZDUy
MzEzYWY4MmJjLi5hZjQ3NTk2YTdiZGQgMTAwNjQ0DQo+ID4gPiAtLS0gYS9uZXQvc3VucnBjL3Nv
Y2tsaWIuYw0KPiA+ID4gKysrIGIvbmV0L3N1bnJwYy9zb2NrbGliLmMNCj4gPiA+IEBAIC0yMjYs
OSArMjI2LDEyIEBAIHN0YXRpYyBpbnQgeHBydF9zZW5kX3BhZ2VkYXRhKHN0cnVjdCBzb2NrZXQN
Cj4gPiA+ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQo+ID4gPiDCoMKgwqDCoMKgwqDCoCBp
ZiAoZXJyIDwgMCkNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
ZXJyOw0KPiA+ID4gwqANCj4gPiA+ICvCoMKgwqDCoMKgwqAgbXNnLT5tc2dfZmxhZ3MgfD0gTVNH
X1pFUk9DT1BZOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqAgaW92X2l0ZXJfYnZlYygmbXNnLT5tc2df
aXRlciwgV1JJVEUsIHhkci0+YnZlYywNCj4gPiA+IHhkcl9idWZfcGFnZWNvdW50KHhkciksDQo+
ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgeGRyLT5wYWdl
X2xlbiArIHhkci0+cGFnZV9iYXNlKTsNCj4gPiA+IC3CoMKgwqDCoMKgwqAgcmV0dXJuIHhwcnRf
c2VuZG1zZyhzb2NrLCBtc2csIGJhc2UgKyB4ZHItPnBhZ2VfYmFzZSk7DQo+ID4gPiArwqDCoMKg
wqDCoMKgIGVyciA9IHhwcnRfc2VuZG1zZyhzb2NrLCBtc2csIGJhc2UgKyB4ZHItPnBhZ2VfYmFz
ZSk7DQo+ID4gPiArwqDCoMKgwqDCoMKgIG1zZy0+bXNnX2ZsYWdzICY9IH5NU0dfWkVST0NPUFk7
DQo+ID4gPiArwqDCoMKgwqDCoMKgIHJldHVybiBlcnI7DQo+ID4gPiDCoH0NCj4gPiA+IMKgDQo+
ID4gPiDCoC8qIENvbW1vbiBjYXNlOg0KPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMvc3Zj
c29jay5jIGIvbmV0L3N1bnJwYy9zdmNzb2NrLmMNCj4gPiA+IGluZGV4IGMyNzUyZTJiOWNlMy4u
YzgxNGI0OTUzYjE1IDEwMDY0NA0KPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy9zdmNzb2NrLmMNCj4g
PiA+ICsrKyBiL25ldC9zdW5ycGMvc3Zjc29jay5jDQo+ID4gPiBAQCAtMTE3Niw2ICsxMTc2LDcg
QEAgc3RhdGljIHZvaWQgc3ZjX3RjcF9pbml0KHN0cnVjdCBzdmNfc29jaw0KPiA+ID4gKnN2c2ss
DQo+ID4gPiBzdHJ1Y3Qgc3ZjX3NlcnYgKnNlcnYpDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc3Zzay0+c2tfZGF0YWxlbiA9IDA7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgbWVtc2V0KCZzdnNrLT5za19wYWdlc1swXSwgMCwgc2l6ZW9mKHN2c2st
DQo+ID4gPiA+IHNrX3BhZ2VzKSk7DQo+ID4gPiDCoA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgc29ja19zZXRfZmxhZyhzaywgU09DS19aRVJPQ09QWSk7DQo+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGNwX3NrKHNrKS0+bm9uYWdsZSB8PSBUQ1BfTkFH
TEVfT0ZGOw0KPiA+ID4gwqANCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
ZXRfYml0KFhQVF9EQVRBLCAmc3Zzay0+c2tfeHBydC54cHRfZmxhZ3MpOw0KPiA+ID4gZGlmZiAt
LWdpdCBhL25ldC9zdW5ycGMveHBydHNvY2suYyBiL25ldC9zdW5ycGMveHBydHNvY2suYw0KPiA+
ID4gaW5kZXggNzA5MGJiZWUwZWM1Li4zNDNjNjM5NmIyOTcgMTAwNjQ0DQo+ID4gPiAtLS0gYS9u
ZXQvc3VucnBjL3hwcnRzb2NrLmMNCj4gPiA+ICsrKyBiL25ldC9zdW5ycGMveHBydHNvY2suYw0K
PiA+ID4gQEAgLTIxNzUsNiArMjE3NSw3IEBAIHN0YXRpYyBpbnQgeHNfdGNwX2ZpbmlzaF9jb25u
ZWN0aW5nKHN0cnVjdA0KPiA+ID4gcnBjX3hwcnQgKnhwcnQsIHN0cnVjdCBzb2NrZXQgKnNvY2sp
DQo+ID4gPiDCoA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIHNvY2tl
dCBvcHRpb25zICovDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc29ja19y
ZXNldF9mbGFnKHNrLCBTT0NLX0xJTkdFUik7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBzb2NrX3NldF9mbGFnKHNrLCBTT0NLX1pFUk9DT1BZKTsNCj4gPiA+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0Y3Bfc2soc2spLT5ub25hZ2xlIHw9IFRDUF9OQUdMRV9P
RkY7DQo+ID4gPiDCoA0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhwcnRf
Y2xlYXJfY29ubmVjdGVkKHhwcnQpOw0KPiA+ID4gDQo+ID4gPiANCj4gPiBJJ20gdGhpbmtpbmcg
d2UgYXJlIG5vdCByZWFsbHkgYWxsb3dlZCB0byBkbyB0aGF0IGhlcmUuIFRoZSBwYWdlcw0KPiA+
IHdlDQo+ID4gcGFzcyBpbiB0byB0aGUgUlBDIGxheWVyIGFyZSBub3QgZ3VhcmFudGVlZCB0byBj
b250YWluIHN0YWJsZSBkYXRhDQo+ID4gc2luY2UgdGhleSBpbmNsdWRlIHVubG9ja2VkIHBhZ2Ug
Y2FjaGUgcGFnZXMgYXMgd2VsbCBhcyBPX0RJUkVDVA0KPiA+IHBhZ2VzLg0KPiANCj4gSSBhc3N1
bWUgeW91IG1lYW4gdGhlIGNsaWVudCBzaWRlIG9ubHkuIFRob3NlIGlzc3VlcyBhcmVuJ3QgYSBm
YWN0b3INCj4gb24gdGhlIHNlcnZlci4gTm90IHNldHRpbmcgU09DS19aRVJPQ09QWSBoZXJlIHNo
b3VsZCBiZSBlbm91Z2ggdG8NCj4gcHJldmVudCB0aGUgdXNlIG9mIHplcm8tY29weSBvbiB0aGUg
Y2xpZW50Lg0KPiANCj4gSG93ZXZlciwgdGhlIGNsaWVudCBsb3NlcyB0aGUgYmVuZWZpdHMgb2Yg
c2VuZGluZyBhIHBhZ2UgYXQgYSB0aW1lLg0KPiBJcyB0aGVyZSBhIGRlc2lyZSB0byByZW1lZHkg
dGhhdCBzb21laG93Pw0KDQpXaGF0IGFib3V0IHNwbGljZSByZWFkcyBvbiB0aGUgc2VydmVyIHNp
ZGU/DQoNCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5l
ciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
