Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4A4144085
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAUPas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:30:48 -0500
Received: from mail-eopbgr150119.outbound.protection.outlook.com ([40.107.15.119]:59265
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728992AbgAUPas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 10:30:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmV4td8hw962iMzkmEKRVT7Pu/aagJ7sUsg/akz1lTrq9/qPZAr665B+hgHQn1FEW+osrNb0WFlKpzNRCcJfzto4+Z1hA7zVrLd850nO8+e6wOvzg/Y4Wq3LnewIVHXJC1aPejt9Tv25oyEWECrEO7q5Ggca2NDq8MInhXV4ZVaQr+gJHsVCCfV1iLiNrdIZKKbhskTpIq2creulGGPsaja++NG4v38BMdy/Hb3/hETyMlEWuf7pBm+ohcINJ0xrhOWWtu4YL5hpFZQE5CQ0hs0dYHEHlMgH5UzhlYSqnFinGF86D0/xAM7uWnB2a1fIVikZLfHWjazBLUcbsMR+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvpYm5yzAwzVTQAP7USWAzb3YeKcrauS5sxNl5tp4zw=;
 b=cW8prkJQNLCDRonGg9s86w+JmmS5ffUzwGfSHiJKmRGEGoIsqnm+bvbmcV1v0aXeG/ufBMUhVsrJpMadeat2yCF7Dv0npu6Ci6q0Pdn6KX3RDvKmBQFumHDRWpZC0YdBI8QL6FEeNGdvlDssAXknLH9p0nxZxxHlruk1jAPH7YAytwXXIokuIA27gZ3ZUqvXV0xMrBkwFJjcGItI81nDQ1ky2dQxGosNb7qkxh9blvRvm5ae6Xl94jJsmphpwVu1kFjOoKD/qzhy+9YcPnNRsUg4/VMvMy2aSYGVQAZTbdSBz4UXEWNboYpDEBi6FSb+Gk49OXmZgwtivoBJ6VbVEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvpYm5yzAwzVTQAP7USWAzb3YeKcrauS5sxNl5tp4zw=;
 b=KJk+8+udPd6gE9zHq/UuGh4U6y7g/qU8MRLas1tc6C76fWhoGhwYKRQhhxzemtUUBrd1DQdtmo4Vs6+UTZP72C4xGcjO/0r5632TyLAZcmvXLZ7pdX8g193hODuA9BpGWsZWY3W01F9Z8LP91plDXhYWzQ3odoyuei120eRQoCE=
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3835.eurprd04.prod.outlook.com (52.134.65.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Tue, 21 Jan 2020 15:30:45 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 15:30:45 +0000
Received: from mail-lj1-f169.google.com (209.85.208.169) by AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Tue, 21 Jan 2020 15:30:44 +0000
Received: by mail-lj1-f169.google.com with SMTP id u1so3230412ljk.7        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 07:30:44 -0800 (PST)
From:   William Dauchy <w.dauchy@criteo.com>
To:     David Miller <davem@davemloft.net>
CC:     William Dauchy <w.dauchy@criteo.com>,
        NETDEV <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v2] net, ip_tunnel: fix namespaces move
Thread-Topic: [PATCH v2] net, ip_tunnel: fix namespaces move
Thread-Index: AQHV0GbbFfF0BnZqmkmcf4NAgDeaIqf1N+KAgAAE+YA=
Date:   Tue, 21 Jan 2020 15:30:45 +0000
Message-ID: <CAJ75kXZ_=rpOgoSycvvgvntq8qiJmNQ1wEt62EMow1Q+By+GQg@mail.gmail.com>
References: <8f942c9f-206e-fecc-e2ba-8fa0eaa14464@6wind.com>
 <20200121142624.40174-1-w.dauchy@criteo.com>
 <20200121.160623.280587258366100601.davem@davemloft.net>
In-Reply-To: <20200121.160623.280587258366100601.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.85.208.169]
x-clientproxiedby: AM0PR10CA0001.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::11) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-gm-message-state: APjAAAUxLsuheVpgIDfHcLQ+GGwDFRJekiTdcYvUjSxeUsgvaVxr+w8D
        h19MIzg4JTpy7gQU0JUABgg7/lv9Md3Y+z2y+MM=
x-google-smtp-source: APXvYqyowQXFlt7ibdWsFw2aPId5R1o04X4lb0xrnkLcYiWDj4noYvy7MbeqxstSObymov4SyeQhSMAz314AQu5eD+A=
x-received: by 2002:a05:651c:118b:: with SMTP id
 w11mr16763872ljo.54.1579620263139; Tue, 21 Jan 2020 07:24:23 -0800 (PST)
x-gmail-original-message-id: <CAJ75kXZ_=rpOgoSycvvgvntq8qiJmNQ1wEt62EMow1Q+By+GQg@mail.gmail.com>
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc2a76a5-566e-4622-7114-08d79e86e1e6
x-ms-traffictypediagnostic: DB3PR0402MB3835:
x-microsoft-antispam-prvs: <DB3PR0402MB383533B5BCA86A617C581E50E80D0@DB3PR0402MB3835.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(199004)(189003)(42186006)(6862004)(8676002)(478600001)(2906002)(55446002)(66446008)(316002)(66946007)(64756008)(54906003)(26005)(66556008)(66476007)(186003)(4326008)(8936002)(86362001)(52116002)(53546011)(107886003)(71200400001)(4744005)(81166006)(81156014)(9686003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3835;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3R4b2fRfLSJ6FT/Utajo7yezbc+wNBCnZ1ORa32yjolxcy0xq7L1FkQIhgz176xkzuQE3gLJ54SBUpIFwF6OSok8zAxB2/G112o1KblsgpFbWAznTKY9ZJMIBm+m0r/GZVB3x4u7JGXuoUdgKM9nrBS8W5VKri+g0hnKT/QwYltWpfT1ZmEOuZFqSOP2tFHImQ1kN+FJMPtzkWPCXBJxfjO/FnDbdtzuSKu17c2TjZ9fmUB9ScTYkulPxsymi1sC6lI8UVBGoTvzrE0ifMo+Ewbe72XoOEzkPHunat6xLn6YTF2c5EId6jz+7+xBMFzoJLPe5O9V2nHFDuo9jTC6+eK7imy0H/ZW0Lwe5a2aaS8BraUoUVj9MKfMjUB35BdLYYHyaW9QBQdwi3sROpluv1iAVBf2w6xLdqelOzHCDEwpZGVtDbtVDGcOWY8XnzWx
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6205038783231847B86D177988F98E83@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2a76a5-566e-4622-7114-08d79e86e1e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 15:30:45.0915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ED8tpy4pR232Il6EPM0I6HkwhqVLzb3jWIXY+kN0l0gLovhOIOk5XhNMhjz1be6CuofZGBf1NbPQpVuMeUukgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3835
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCk9uIFR1ZSwgSmFuIDIxLCAyMDIwIGF0IDQ6MDcgUE0gRGF2aWQgTWlsbGVy
IDxkYXZlbUBkYXZlbWxvZnQubmV0PiB3cm90ZToNCj4gRnJvbTogV2lsbGlhbSBEYXVjaHkgPHcu
ZGF1Y2h5QGNyaXRlby5jb20+DQo+IERhdGU6IFR1ZSwgMjEgSmFuIDIwMjAgMTU6MjY6MjQgKzAx
MDANCj4NCj4gPiBpbiB0aGUgc2FtZSBtYW5uZXIgYXMgY29tbWl0IDY5MGFmYzE2NWJiMyAoIm5l
dDogaXA2X2dyZTogZml4IG1vdmluZw0KPiA+IGlwNmdyZSBiZXR3ZWVuIG5hbWVzcGFjZXMiKSwg
Zml4IG5hbWVzcGFjZSBtb3ZpbmcgYXMgaXQgd2FzIGJyb2tlbiBzaW5jZQ0KPiA+IGNvbW1pdCAy
ZTE1ZWEzOTBlNmYgKCJpcF9ncmU6IEFkZCBzdXBwb3J0IHRvIGNvbGxlY3QgdHVubmVsIG1ldGFk
YXRhLiIpLg0KPiA+IEluZGVlZCwgdGhlIGlwNl9ncmUgY29tbWl0IHJlbW92ZWQgdGhlIGxvY2Fs
IGZsYWcgZm9yIGNvbGxlY3RfbWQNCj4gPiBjb25kaXRpb24sIHNvIHRoZXJlIGlzIG5vIHJlYXNv
biB0byBrZWVwIGl0IGZvciBpcF9ncmUvaXBfdHVubmVsLg0KPiA+DQo+ID4gdGhpcyBwYXRjaCB3
aWxsIGZpeCBib3RoIGlwX3R1bm5lbCBhbmQgaXBfZ3JlIG1vZHVsZXMuDQo+ID4NCj4gPiBGaXhl
czogMmUxNWVhMzkwZTZmICgiaXBfZ3JlOiBBZGQgc3VwcG9ydCB0byBjb2xsZWN0IHR1bm5lbCBt
ZXRhZGF0YS4iKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFdpbGxpYW0gRGF1Y2h5IDx3LmRhdWNoeUBj
cml0ZW8uY29tPg0KPg0KPiBBcHBsaWVkIGFuZCBxdWV1ZWQgdXAgZm9yIC1zdGFibGUsIHRoYW5r
cy4NCg0KQXMgZGlzY3Vzc2VkIGluIHRoaXMgdGhyZWFkLCB3ZSBzaG91bGQgcHJvYmFibHkgcXVl
dWUgdXANCmNvbW1pdCA2OTBhZmMxNjViYjMgKCJuZXQ6IGlwNl9ncmU6IGZpeCBtb3ZpbmcgaXA2
Z3JlIGJldHdlZW4gbmFtZXNwYWNlcyIpDQoiRml4ZXMiIHdhcyBmb3Jnb3R0ZW47IGl0IHdhcyBm
aXhpbmcgY29tbWl0IDY3MTJhYmMxNjhlYiAoImlwNl9ncmU6DQphZGQgaXA2IGdyZSBhbmQgZ3Jl
dGFwIGNvbGxlY3RfbWQgbW9kZSIpDQoNCkJlc3QsDQotLSANCldpbGxpYW0NCg==
