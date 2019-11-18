Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9DFFF46
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfKRHF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:05:28 -0500
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:54542
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbfKRHF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 02:05:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTmKlfZqYvAetgsN7sAQuivoQ8Sz5gQRiGWrxoZ/Q83bGVvBf0fdBY2I0jWAcqhEl49kFsHSZDUuV/980oaKtNEn4iHTij4n9dj4wV4mj0OdwNDiOt7689J0f8iLW4ztzhRao33/uDVf+1y3ARV9zmDc0rTinpuBsxVqNPL2/MREAZKC4GEpsMsPl751iUDz66xht+DxfM5WeoFCfW5S2VxXBG6/MpJspVmMtDhsQkMKmK+zE3Nivjh0JYgLTOq/nfeoHbs/EEWCmYqI7Jt9HR7xreKr0/rMKE4mTGmRjQN4dZysQcL1xYGYJiCFCefG8Uepbp+GrgzlMF5aoWPzxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C1ztmnIlcrrJTruR/hINpCEM2AAo/BRWp94tW0QuZ8=;
 b=XgTLVxycS20v7MYYOWllGHPcEgwn+TvPvVXbuM5z0Qr2kTEFk9832osNj4S2JNNWf5kqf0OmJKdlNJwUPUiKP7HYcRtM1Sdt5/rAb2joDnqOsh/R7fT7pdvozrHTyAkd74bk69ThtdbtzPnCGJymOIg3Wf0x6dmMZwxRAv/hJLmkRYTJO9H4Cd8Pn7eUk3g0jCXZe7hMc9YzRmnLn10hURBXhPVf57rkNmFmbPRs5ZN0P8ZZnL4hgh1/2uTxBGcp22fKUxSy/U8glIlEhbmc41pkskV8VRsA6OlwTv0m5hJ7RWsegy6rBh9Hr60wg9/V+hzer1AvCqDm7l7ll0H1uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C1ztmnIlcrrJTruR/hINpCEM2AAo/BRWp94tW0QuZ8=;
 b=CZnCMlfbxmyFPfbxJFw7xS6/S+lLZQ1y+7IkN6OYyyKbLbztCDHtBne/SmG+BiFjt3mzn1sgJxWwHKG5XrGq/Os9847AtuherbKKz2LqB1P+CrE1jxHludotmqMtw2BMWRBeDBSXxro6gNatErq4FtcmyL/cNsth8rdeqtwAlfQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4634.eurprd04.prod.outlook.com (52.135.140.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Mon, 18 Nov 2019 07:05:22 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 07:05:22 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcKeL8V8AgAQ78GA=
Date:   Mon, 18 Nov 2019 07:05:22 +0000
Message-ID: <DB7PR04MB4618220095E1F844A44DB480E64D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
In-Reply-To: <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51d8bf91-45ac-454b-7691-08d76bf5ade3
x-ms-traffictypediagnostic: DB7PR04MB4634:|DB7PR04MB4634:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB463491B34FB0D8E55C735D0DE64D0@DB7PR04MB4634.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(13464003)(199004)(189003)(66556008)(6246003)(53546011)(7736002)(256004)(305945005)(2501003)(99286004)(6436002)(476003)(86362001)(110136005)(8676002)(71200400001)(5660300002)(52536014)(54906003)(8936002)(446003)(486006)(2906002)(316002)(81166006)(55016002)(76176011)(11346002)(81156014)(7696005)(66476007)(66946007)(74316002)(9686003)(6506007)(4326008)(71190400001)(14444005)(26005)(14454004)(25786009)(76116006)(478600001)(186003)(229853002)(3846002)(6116002)(66066001)(33656002)(66446008)(64756008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4634;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OF2SsVtQANDoo/XtY0L20+A0eP18NFOmH4H5tphwhnfrVSUVHs+ypqfqau8HS8w37y+gIo+IZbzXqUKYKlMu5C0/CBF3zydptQzXs8S9V4Og0Had3S0ALztxIbWPQwD4/pgrXEtS8k4xfQgYeZE6euCroU2/4MmZpX+in6oJ3nkPxdoGDBYuD2slnZrmz0dxEZWqlynF4xaNVfStjwrAF8G/PHAcWtxI905xfSEZhFVngg05h21inwCaUVRksVtvFVc8MD1PoZ+eDqdsl2b+RmujyyWQNH2/hB/quaNMOhjOEIsTnlBl5Y8q/9E5cU5dIk5+qkPYn+jm04DbPKVkZZwlU2fzuEWVRw5RpRumwqFlP8meJbD/El9hbfPIip4v6muZZ3dZeZvk6vFcJT8kwouV/Z/YpnK+WxYeEqt6797l3Agrg2+XIDPohhIT5ntb
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d8bf91-45ac-454b-7691-08d76bf5ade3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 07:05:22.3849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j4tngONaZAQlpt3uGoeuy5m+V5bGQRvRcta8SSkjDGq1644DFTGLbsPNCfakFUvCskbIHKqJWWu7WwbwsikFEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4634
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNhbi1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+IE9uIEJl
aGFsZiBPZiBTZWFuIE55ZWtqYWVyDQo+IFNlbnQ6IDIwMTnlubQxMeaciDE15pelIDE3OjA4DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgbWtsQHBlbmd1dHJv
bml4LmRlDQo+IENjOiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXggPGxp
bnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIDEvM10gY2FuOiBmbGV4Y2FuOiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxm
IHdha2V1cA0KPiANCj4gDQo+IA0KPiBPbiAxNS8xMS8yMDE5IDA2LjAzLCBKb2FraW0gWmhhbmcg
d3JvdGU6DQo+ID4gRnJvbTogU2VhbiBOeWVramFlciA8c2VhbkBnZWFuaXguY29tPg0KPiA+DQo+
ID4gV2hlbiBzdXNwZW5kaW5nLCB3aGVuIHRoZXJlIGlzIHN0aWxsIGNhbiB0cmFmZmljIG9uIHRo
ZSBpbnRlcmZhY2VzIHRoZQ0KPiA+IGZsZXhjYW4gaW1tZWRpYXRlbHkgd2FrZXMgdGhlIHBsYXRm
b3JtIGFnYWluLiBBcyBpdCBzaG91bGQgOi0pLiBCdXQgaXQNCj4gPiB0aHJvd3MgdGhpcyBlcnJv
ciBtc2c6DQo+ID4gWyAzMTY5LjM3ODY2MV0gUE06IG5vaXJxIHN1c3BlbmQgb2YgZGV2aWNlcyBm
YWlsZWQNCj4gPg0KPiA+IE9uIHRoZSB3YXkgZG93biB0byBzdXNwZW5kIHRoZSBpbnRlcmZhY2Ug
dGhhdCB0aHJvd3MgdGhlIGVycm9yIG1lc3NhZ2UNCj4gPiBkb2VzIGNhbGwgZmxleGNhbl9zdXNw
ZW5kIGJ1dCBmYWlscyB0byBjYWxsIGZsZXhjYW5fbm9pcnFfc3VzcGVuZC4NCj4gPiBUaGF0IG1l
YW5zIHRoZSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZSBpcyBjYWxsZWQsIGJ1dCBvbiB0aGUgd2F5
IG91dA0KPiA+IG9mIHN1c3BlbmQgdGhlIGRyaXZlciBvbmx5IGNhbGxzIGZsZXhjYW5fcmVzdW1l
IGFuZCBza2lwcw0KPiA+IGZsZXhjYW5fbm9pcnFfcmVzdW1lLCB0aHVzIGl0IGRvZXNuJ3QgY2Fs
bCBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlLg0KPiA+IFRoaXMgbGVhdmVzIHRoZSBmbGV4Y2FuIGlu
IHN0b3AgbW9kZSwgYW5kIHdpdGggdGhlIGN1cnJlbnQgZHJpdmVyIGl0DQo+ID4gY2FuJ3QgcmVj
b3ZlciBmcm9tIHRoaXMgZXZlbiB3aXRoIGEgc29mdCByZWJvb3QsIGl0IHJlcXVpcmVzIGEgaGFy
ZCByZWJvb3QuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGNhbiBmaXggZGVhZGxvY2sgd2hlbiB1c2lu
ZyBzZWxmIHdha2V1cCwgaXQgaGFwcGVuZXMgdG8gYmUNCj4gPiBhYmxlIHRvIGZpeCBhbm90aGVy
IGlzc3VlIHRoYXQgZnJhbWVzIG91dC1vZi1vcmRlciBpbiBmaXJzdCBJUlENCj4gPiBoYW5kbGVy
IHJ1biBhZnRlciB3YWtldXAuDQo+ID4NCj4gPiBJbiB3YWtldXAgY2FzZSwgYWZ0ZXIgc3lzdGVt
IHJlc3VtZSwgZnJhbWVzIHJlY2VpdmVkIG91dC1vZi1vcmRlcix0aGUNCj4gPiBwcm9ibGVtIGlz
IHdha2V1cCBsYXRlbmN5IGZyb20gZnJhbWUgcmVjZXB0aW9uIHRvIElSUSBoYW5kbGVyIGlzIG11
Y2gNCj4gPiBiaWdnZXIgdGhhbiB0aGUgY291bnRlciBvdmVyZmxvdy4gVGhpcyBtZWFucyBpdCdz
IGltcG9zc2libGUgdG8gc29ydA0KPiA+IHRoZSBDQU4gZnJhbWVzIGJ5IHRpbWVzdGFtcC4gVGhl
IHJlYXNvbiBpcyB0aGF0IGNvbnRyb2xsZXIgZXhpdHMgc3RvcA0KPiA+IG1vZGUgZHVyaW5nIG5v
aXJxIHJlc3VtZSwgdGhlbiBpdCBjYW4gcmVjZWl2ZSB0aGUgZnJhbWUgaW1tZWRpYXRlbHkuDQo+
ID4gSWYgbm9pcnEgcmV1c21lIHN0YWdlIGNvbnN1bWVzIG11Y2ggdGltZSwgaXQgd2lsbCBleHRl
bmQgaW50ZXJydXB0DQo+ID4gcmVzcG9uc2UgdGltZS4NCj4gPg0KPiA+IEZpeGVzOiBkZTM1Nzhj
MTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gDQo+IEhpIEpv
YWtpbSBhbmQgTWFyYw0KPiANCj4gV2UgaGF2ZSBxdWl0ZSBhIGZldyBkZXZpY2VzIGluIHRoZSBm
aWVsZCB3aGVyZSBmbGV4Y2FuIGlzIHN0dWNrIGluIFN0b3AtTW9kZS4NCj4gV2UgZG8gbm90IGhh
dmUgdGhlIHBvc3NpYmlsaXR5IHRvIGNvbGQgcmVib290IHRoZW0sIGFuZCBob3QgcmVib290IHdp
bGwgbm90IGdldA0KPiBmbGV4Y2FuIG91dCBvZiBzdG9wLW1vZGUuDQo+IFNvIGZsZXhjYW4gY29t
ZXMgdXAgd2l0aDoNCj4gWyAgMjc5LjQ0NDA3N10gZmxleGNhbjogcHJvYmUgb2YgMjA5MDAwMC5m
bGV4Y2FuIGZhaWxlZCB3aXRoIGVycm9yIC0xMTANCj4gWyAgMjc5LjUwMTQwNV0gZmxleGNhbjog
cHJvYmUgb2YgMjA5NDAwMC5mbGV4Y2FuIGZhaWxlZCB3aXRoIGVycm9yIC0xMTANCj4gDQo+IFRo
ZXkgYXJlIG9uLCBkZTM1NzhjMTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBz
dXBwb3J0IikNCj4gDQo+IFdvdWxkIGl0IGJlIGEgc29sdXRpb24gdG8gYWRkIGEgY2hlY2sgaW4g
dGhlIHByb2JlIGZ1bmN0aW9uIHRvIHB1bGwgaXQgb3V0IG9mDQo+IHN0b3AtbW9kZT8NCg0KSGkg
U2VhbiwNCg0KU29mdCByZXNldCBjYW5ub3QgYmUgYXBwbGllZCB3aGVuIGNsb2NrcyBhcmUgc2h1
dCBkb3duIGluIGEgbG93IHBvd2VyIG1vZGUuIFRoZSBtb2R1bGUgc2hvdWxkIGJlIGZpcnN0IHJl
bW92ZWQgZnJvbSBsb3cgcG93ZXIgbW9kZSwgYW5kIHRoZW4gc29mdCByZXNldCBjYW4gYmUgYXBw
bGllZC4NCkFuZCBleGl0IGZyb20gc3RvcCBtb2RlIGhhcHBlbnMgd2hlbiB0aGUgU3RvcCBtb2Rl
IHJlcXVlc3QgaXMgcmVtb3ZlZCwgb3Igd2hlbiBhY3Rpdml0eSBpcyBkZXRlY3RlZCBvbiB0aGUg
Q0FOIGJ1cyBhbmQgdGhlIFNlbGYgV2FrZSBVcCBtZWNoYW5pc20gaXMgZW5hYmxlZC4NCg0KU28g
ZnJvbSBteSBwb2ludCBvZiB2aWV3LCB3ZSBjYW4gYWRkIGEgY2hlY2sgaW4gdGhlIHByb2JlIGZ1
bmN0aW9uIHRvIHB1bGwgaXQgb3V0IG9mIHN0b3AgbW9kZSwgc2luY2UgY29udHJvbGxlciBhY3R1
YWxseSBjb3VsZCBiZSBzdHVjayBpbiBzdG9wIG1vZGUgaWYgc3VzcGVuZC9yZXN1bWUgZmFpbGVk
IGFuZCB1c2VycyBqdXN0IA0Kd2FudCBhIHdhcm0gcmVzZXQgZm9yIHRoZSBzeXN0ZW0uDQoNCkNv
dWxkIHlvdSBwbGVhc2UgdGVsbCBtZSBob3cgY2FuIEkgZ2VuZXJhdGUgYSB3YXJtIHJlc2V0PyBB
RkFJSywgYm90aCAicmVib290IiBjb21tYW5kIHB1dCBpbnRvIHByb21wdCBhbmQgUlNUIEtFWSBp
biBvdXIgRVZLIGJvYXJkIGFsbCBwbGF5IGEgcm9sZSBvZiBjb2xkIHJlc2V0Lg0KDQpCZXN0IFJl
Z2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gL1NlYW4NCg==
