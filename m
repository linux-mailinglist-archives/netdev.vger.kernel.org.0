Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0CC292481
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 11:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgJSJTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 05:19:11 -0400
Received: from mail-eopbgr1320118.outbound.protection.outlook.com ([40.107.132.118]:42720
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727987AbgJSJTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 05:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPuorc39Qk6Z4TGNX4IM0WXC4/jUsd6fDyETPNPjLPembhbK4z9aQtGuMuquuUVAAlKcZv4pnw2GS8VseVjR8r9JuPatLXni8uC0tX6F4DUAfi+7vdwtOvI8v0Dl9tPE2IewFMOw9aG6Ij0I48tIDnwCxl8j9LHqYk2vP7YvhDgzJZbBLs6iFW+Cj4iz/cFb9fa56e84y/8E5uqK/nfcw9gWxf5qA5B6N1avnXo9TuRMSRpgYgKWoFiPnTCl3uhPsVcvDSqfM5+IoETf0jF5UNmkmk5EG1DNsb5CN9lvu4MXqXo1BqNQfsuuNIbFl4/zvFD9QCa9F+XSAEWjoaWM3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3nA9icBgmk1bz8JAvkfvrJNiP5P3mnxIJqg8vKHLcM=;
 b=kSE1FYSI7NMCjwCZuH035HfaLwNJc39E8wJr8PvDkB6mV9xvSQQFky7rvxTrbgNpmYx2KAOjY6UQvFWGLmUl2vEp0S9Uj16CscrT05/6BkXZHdOOTKZGUlgdco2ueVmIZYz/VnF1cpJK6C005WStryBMGT5z1Npc3T98Z9yaHTYPMtNFw1DopBDuD4xbU1CwyGtHXfiEUnDP79IyGNNaue1k5dqmmHCHvAmBcLizzNoqip6cwCZyR9+yt5q24ThY45KK68VnzFBcgu2aWIMuPqOmNFfab+7d+hqXxE7i1UGBpIuHQFXvVZniybZy81YyUJlSaOM8F8V3eKLBkLy5SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com (2603:1096:803:6::17)
 by PSAPR06MB4086.apcprd06.prod.outlook.com (2603:1096:301:2a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.18; Mon, 19 Oct
 2020 09:19:07 +0000
Received: from PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc]) by PS1PR0601MB1849.apcprd06.prod.outlook.com
 ([fe80::31d5:24c7:7ac6:a5cc%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 09:19:07 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Thread-Topic: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Thread-Index: AQHWper5b6m5IMpmJk2Uyk3yAiWzCqmen8qAgAAAVTA=
Date:   Mon, 19 Oct 2020 09:19:07 +0000
Message-ID: <PS1PR0601MB1849B2D01A2D9C2EEF6D58069C1E0@PS1PR0601MB1849.apcprd06.prod.outlook.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
 <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
In-Reply-To: <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: jms.id.au; dkim=none (message not signed)
 header.d=none;jms.id.au; dmarc=none action=none header.from=aspeedtech.com;
x-originating-ip: [211.20.114.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96fbdecb-4d72-4647-02a3-08d8741007ef
x-ms-traffictypediagnostic: PSAPR06MB4086:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PSAPR06MB4086203C53338912B8366B7C9C1E0@PSAPR06MB4086.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nX+M0Ij2497GkHoenT9ZoJupDiOhNtJhXBxWXUlvra9usxa3LociU2jt/ymqrjGs/skVFkw39WEWwGeZjStyxuOezXUvwdNosWC4lE8yVyq0wXg6DpVUA48taQrJ/bY/uCDtb4cgh3JYNMjeRzZTLD2iA1yeeKM4UHow3qd9hyqdOtY1l5cDSgR4g/jr4RAIODv1SyRUqCYYdNCOGFH6oa1tgduQm50UEo/V90tjPJ1+zqhjtLo2xfR2//Op9p+0c4Pr7MRfr+7Zxux9c/vfsu6byJANaMniB+aOl5adOQvuY7VMioq1QfTuuXQO8SXU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB1849.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(136003)(346002)(376002)(366004)(86362001)(110136005)(71200400001)(8936002)(54906003)(7696005)(8676002)(316002)(66476007)(76116006)(5660300002)(52536014)(33656002)(64756008)(9686003)(66556008)(66446008)(66946007)(83380400001)(107886003)(186003)(4326008)(26005)(478600001)(55236004)(6506007)(53546011)(55016002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yRZY8T4vG8nqlXUYteHXrbC6weUf58b7bcHFuf+yT51h47vaDYN7zK5J0tRhPHmaWvYsKZJJmcK2SVuztw3Htuhyuq/jcjKD1WsSAHu8jIoGD2Q2z9OsE4N3316+AoD4XQpN59qZZdD68Y8RwO2WFYMbdo4tlVtvBmKaOcgcB5xT+rmcyDGdRhcDlp+Vz8ilu5k3QfasUfJdFDKpxA977Vc/kG4aUO+oRVm60Jmc/Ux2U8mYEWzpmwLJkFa+T1wq0fw5tTRk81tNoiR/wkxlFJnut08C/y1q2e+WSJKmE6RfK7mDRojCauDuBrYiL5VpV2+gPAiFyP67W4pTT1cIAu6Bkf/mtA+FB6H+MHtAqSurMGvt1tc7EDzb8H1fP081g8vWYSW9hM2n+FAMyIUjyQfSm0A+YCc9tFQNmUTnwSxJoCKBuaZAwSp4hI08Nkdf2DJQbQiDhVHrcCQIueVHaiestqdEuY59PsDIzAomRvB4gKqBt9TxZK7jIpKLnJJhpG1tN9UdmXPkIGP40+uTmlN1tC5ar3mxX93nPO3qCZdVSel4DXdHDBK4JxFbcKnA9e9hNkJjk7+lY1hftQpy9Ekpg148SO9H+y2C/frMl6C5Ym87KYNTfLn1dwb0uXkUHv/W0dqdaEC/kj7JCiPlPQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB1849.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fbdecb-4d72-4647-02a3-08d8741007ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 09:19:07.2788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hhPDxvuksDfiCc8Fci/0CaYYFxG8AvvgkXqOEvjJq2cQGyTBiNcfjp0Uo0PTk3w9XAyhKgnFGeSG+yW5nJ1lKcHo5zjQksxSl+fsrHB40Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9lbCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2VsIFN0
YW5sZXkgW21haWx0bzpqb2VsQGptcy5pZC5hdV0NCj4gU2VudDogTW9uZGF5LCBPY3RvYmVyIDE5
LCAyMDIwIDQ6NTcgUE0NCj4gVG86IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVjaC5j
b20+OyBCZW5qYW1pbiBIZXJyZW5zY2htaWR0DQo+IDxiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmc+
DQo+IENjOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2lj
aW5za2kNCj4gPGt1YmFAa2VybmVsLm9yZz47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IExpbnV4
IEtlcm5lbCBNYWlsaW5nIExpc3QNCj4gPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBQ
by1ZdSBDaHVhbmcgPHJhdGJlcnRAZmFyYWRheS10ZWNoLmNvbT47DQo+IGxpbnV4LWFzcGVlZCA8
bGludXgtYXNwZWVkQGxpc3RzLm96bGFicy5vcmc+OyBPcGVuQk1DIE1haWxsaXN0DQo+IDxvcGVu
Ym1jQGxpc3RzLm96bGFicy5vcmc+OyBCTUMtU1cgPEJNQy1TV0Bhc3BlZWR0ZWNoLmNvbT4NCj4g
U3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBmdGdtYWMxMDA6IEZpeCBtaXNzaW5nIFRYLXBvbGwg
aXNzdWUNCj4gDQo+IE9uIE1vbiwgMTkgT2N0IDIwMjAgYXQgMDc6MzksIER5bGFuIEh1bmcgPGR5
bGFuX2h1bmdAYXNwZWVkdGVjaC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gVGhlIGNwdSBhY2Nl
c3NlcyB0aGUgcmVnaXN0ZXIgYW5kIHRoZSBtZW1vcnkgdmlhIGRpZmZlcmVudCBidXMvcGF0aCBv
bg0KPiA+IGFzcGVlZCBzb2MuICBTbyB3ZSBjYW4gbm90IGd1YXJhbnRlZSB0aGF0IHRoZSB0eC1w
b2xsIGNvbW1hbmQNCj4gDQo+IEp1c3QgdGhlIDI2MDAsIG9yIG90aGVyIHZlcnNpb25zIHRvbz8N
Cg0KSnVzdCB0aGUgMjYwMC4gIEFuZCB0aGlzIGlzc3VlIG9ubHkgb2NjdXJyZWQgb24gRXRoZXJu
ZXQgbWFjLg0KDQo+IA0KPiA+IChyZWdpc3RlciBhY2Nlc3MpIGlzIGFsd2F5cyBiZWhpbmQgdGhl
IHR4IGRlc2NyaXB0b3IgKG1lbW9yeSkuICBJbg0KPiA+IG90aGVyIHdvcmRzLCB0aGUgSFcgbWF5
IHN0YXJ0IHdvcmtpbmcgZXZlbiB0aGUgZGF0YSBpcyBub3QgeWV0IHJlYWR5Lg0KPiA+IEJ5DQo+
IA0KPiBldmVuIGlmIHRoZQ0KPiANCj4gPiBhZGRpbmcgYSBkdW1teSByZWFkIGFmdGVyIHRoZSBs
YXN0IGRhdGEgd3JpdGUsIHdlIGNhbiBlbnN1cmUgdGhlIGRhdGENCj4gPiBhcmUgcHVzaGVkIHRv
IHRoZSBtZW1vcnksIHRoZW4gZ3VhcmFudGVlIHRoZSBwcm9jZXNzaW5nIHNlcXVlbmNlDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBIdW5nIDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29t
Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5j
IHwgMyArKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkv
ZnRnbWFjMTAwLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAw
LmMNCj4gPiBpbmRleCAwMDAyNGRkNDExNDcuLjlhOTlhODdmMjlmMyAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KPiA+IEBAIC04MDQsNyArODA0
LDggQEAgc3RhdGljIG5ldGRldl90eF90DQo+IGZ0Z21hYzEwMF9oYXJkX3N0YXJ0X3htaXQoc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwNCj4gPiAgICAgICAgICAqIGJlZm9yZSBzZXR0aW5nIHRoZSBPV04g
Yml0IG9uIHRoZSBmaXJzdCBkZXNjcmlwdG9yLg0KPiA+ICAgICAgICAgICovDQo+ID4gICAgICAg
ICBkbWFfd21iKCk7DQo+ID4gLSAgICAgICBmaXJzdC0+dHhkZXMwID0gY3B1X3RvX2xlMzIoZl9j
dGxfc3RhdCk7DQo+ID4gKyAgICAgICBXUklURV9PTkNFKGZpcnN0LT50eGRlczAsIGNwdV90b19s
ZTMyKGZfY3RsX3N0YXQpKTsNCj4gPiArICAgICAgIFJFQURfT05DRShmaXJzdC0+dHhkZXMwKTsN
Cj4gDQo+IEkgdW5kZXJzdGFuZCB3aGF0IHlvdSdyZSB0cnlpbmcgdG8gZG8gaGVyZSwgYnV0IEkn
bSBub3Qgc3VyZSB0aGF0IHRoaXMgaXMgdGhlDQo+IGNvcnJlY3Qgd2F5IHRvIGdvIGFib3V0IGl0
Lg0KPiANCj4gSXQgZG9lcyBjYXVzZSB0aGUgY29tcGlsZXIgdG8gcHJvZHVjZSBhIHN0b3JlIGFu
ZCB0aGVuIGEgbG9hZC4NCj4gDQo+ID4NCj4gPiAgICAgICAgIC8qIFVwZGF0ZSBuZXh0IFRYIHBv
aW50ZXIgKi8NCj4gPiAgICAgICAgIHByaXYtPnR4X3BvaW50ZXIgPSBwb2ludGVyOw0KPiA+IC0t
DQo+ID4gMi4xNy4xDQo+ID4NCg==
