Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CCD423862
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbhJFGzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:55:23 -0400
Received: from mail-eopbgr1410138.outbound.protection.outlook.com ([40.107.141.138]:26528
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237347AbhJFGzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:55:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG8S1cwSe/iTIss3qdsO1I31Ube1KjDlUM0FRuT/M/FR+iLRPAWY/aEyz7r6AdcP71lZ3DwUxd8dPE16cisXCEYoM0/aecpx3StTMvVQkuFW0gzbT+5fKL1JYvAdT2td6w7cS1qcwb1BuDOTg97zK84Po8tOs4NmjXshnIT0PsWw8jIUtr+x8pCQgV64UfR+GNF030txx7ZlgIUczYORDEEfpd6+RlKyG4SpKOFETBJ7yAH4/uAY46YquuqkHlfxw0p97OnF+x6wgCxXEx0ym+eC1H8tXIlWYbJkpqnMYX2qYUNtF5jqAFrmNVp6zYrL0Y1tteijImeLy7dTwDNe2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SbjblsSIMXfNNXBHvjGPYT2/6oaXzhOanT+36ocqSyQ=;
 b=YDZcNtfVbdKjs+D6OGWgiAwHhiAnkMEdb8lwUntHJvWbYKzZ1HzOmjBI1Pks2jaup7BtHPr060kTF8PEYT5J8S/StptfEkS6TNDXJBcF5qHo2txYOGYvkbA2IxjhSIEx8Y868ERv/ho5dIDOr9BCy7xYYR4wFeyRj0JWS2bnd1sV0vbRTTJ9wYWX/zy/HDMRRIfWLj9o/gjgERSlu1V/lzf8AiMsgnhbHH7JtnpBLO4+UQ13VoUiYXY+xndPPSY1nef57I+ZKH9VfEpIw31s2KkY/xAQnD4b7DRmcF35lH0FsRkx0Lq1EV6lhy1vQjkQI5mgL+IgTf5o2r1QEiU34w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbjblsSIMXfNNXBHvjGPYT2/6oaXzhOanT+36ocqSyQ=;
 b=QBgmW13Zn1YzA6F0g/eZ0nUKTgWoyQqn8HENmtmi9cxfPDpsyMC7xH/u7/fCihGa9omusL/7akXF3FYNAp9GYdUXiEh0P8CLhD50xAetwZBEjft3qjscHOEhmR6mvK1JygJwPUpVImF60ULE8QYiFh2idIkUOMsi1PPcFJY0kcY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4023.jpnprd01.prod.outlook.com (2603:1096:604:4a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Wed, 6 Oct
 2021 06:53:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 06:53:28 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 12/12] ravb: Update/Add comments
Thread-Topic: [RFC 12/12] ravb: Update/Add comments
Thread-Index: AQHXudkyP8df+Mawy0uMRLYBRDoxP6vEyg8AgAC/UEA=
Date:   Wed, 6 Oct 2021 06:53:28 +0000
Message-ID: <OS0PR01MB5922A21D4274A5E3941A1E2886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-13-biju.das.jz@bp.renesas.com>
 <983e7d02-ae9e-0c30-a7b8-f94855e7927b@omp.ru>
In-Reply-To: <983e7d02-ae9e-0c30-a7b8-f94855e7927b@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d368954-55fc-40aa-6a3a-08d9889600ba
x-ms-traffictypediagnostic: OSBPR01MB4023:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4023237ADD0110CC3913E85986B09@OSBPR01MB4023.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y0A7KgT23skd+5CGQXlc1xgfzmr90BDUfZ3EqJaursV0EdkkmfDQJ3pZj/h7x2sY0T4ks8ai4QV2XRCPNLaBlrjRsLhy7jeKW3dt0v5PEOYh0nXs09px6mnOmAQwnzjJKsGSrwwTi5I16mPHD5uM5UwZp0nja0WG44m6vc6AWGENxTO9dQJbTnmMYSE42cWDuO6xdr3SXLCNoqUFmrgR1pxyEQsvcDMykMiWqr0st9P9gwZSLA/lmKOWjJLVmOY/l+ZRWE1d4cBy8CQBRQU+TXa6yw+ZFKzexyC66k9OxCG+iKDug706bN9ai1JSC8YpFrbXZ7QyYZzGT/+QvXbt75og5/rv3RRgVzg3dkXSmnYxiPIw8i5l8OUOZhgUaOga7G6wkCKJ/UkeAGfaCRLXeMGvc6wGFDyGlAjF6l3/d2YJv/ybtenQ2zzuUqRa5w449vsMqtzsD1NmWn8nGSQu9dS7AstA6bjB7Su7g3YYz4trCaUh9UwfA1YGNs0FLe21zGxlB9A0xRSEY4MnfJPuCacQatupL1QjEWTHdGLu2pelKwkVcNc6d843lcIX/IcD4XGAGGD7EQtsWz+g4Y2DHDe66Mf0HyoXlRp9lLH1vcllcXi4BsuBZCj3P/EOuWPbtkNYles0hUgdheczmbK38/01KTp4UkLeuUltj3pmbdjj1N5FhYtDAV+N5MeDstr69CD7DpTR5EdQYOcN+uLgOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(15650500001)(66556008)(66476007)(83380400001)(52536014)(186003)(7416002)(316002)(38100700002)(86362001)(122000001)(33656002)(2906002)(64756008)(53546011)(76116006)(54906003)(508600001)(6506007)(71200400001)(110136005)(66946007)(7696005)(8676002)(26005)(8936002)(66446008)(55016002)(9686003)(107886003)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qmh2Qy9DNkJsam5LV3pwb05jMGVTS1lkZjdla0pLc011SWFsbFlaak9wNDd2?=
 =?utf-8?B?ci96RHVtQmVmWFNGUU0wSXV2OEpqZkU1YXNpN3BENHptZmIwL29vYkJ1RnI0?=
 =?utf-8?B?d1pjZEVXdENSMjc4cmpYdFlVeHIyZk54VHE1blhXWTNML2l0ZmNRMHp6MzM3?=
 =?utf-8?B?STUvalN5MGI0eGdqODhpeTlwY2R5M3Uxd3dKM2FIdmUyMDhObVlRMnAyOTlh?=
 =?utf-8?B?VmxWdk1kb0dUd1RMWEN5ZXlVbC9hZ1owaGFGd3V4dWNpTVhTVjRCcUkvcDJW?=
 =?utf-8?B?WE9LVGtyMVZ1U1dFaFJ6b2Q5Q2RMWlFxamJpeTkyT2Q1U2tDd09udmE5ZFU3?=
 =?utf-8?B?WHdtRTEwR2F5MjlTc3NLbzd5cG4xb1hkdkp5NVplbU1PK2hpZmVicTA1RUl3?=
 =?utf-8?B?dU8zVUFtdDhSVHlVUTFCVlFnWVlWSFhEZzNRcXlIRkpoWHZ3SktUT0FHVlAx?=
 =?utf-8?B?WVp2Z1JYVEhtVmlObzNHTlJxYlkzNjVBVWtjc1ltNmVyTGJkWWhUdW5SbS9L?=
 =?utf-8?B?cHRZNUFlNkhVSjN3cEk2YWVpZWJuS3p4cTBZbGUvd05ISTVjVWV3d1pUMDcv?=
 =?utf-8?B?THc2NHBqQVdtQ3dSYlI2a0VxcWkzcW16U0tqTzh0S3B6ekZMQWg5RVlSdm5p?=
 =?utf-8?B?MjF6WXhuN2VleGdjR1lBMW5iay85NzlSWExVUWt6cTJvdWx0NHF5VVYrWFc1?=
 =?utf-8?B?bkV3WDJ0Mm5Dd3E1NHJ3eXMyOHBWNkdoS1h5RVZZMm1kYWRpV2lqcm1kQUZh?=
 =?utf-8?B?RFpxUVN1YXZKajdzR01LdXI1Q2puNE5mK0llVGZVbEZYeDhjRDd0MG8xb2Ey?=
 =?utf-8?B?eGU0MzBqSVNWN0hmSFNNMHJKTzVtVGQ5M3pKbWkzL1hVaVNIMHAzK0gzRjRK?=
 =?utf-8?B?Yk1leHpNVHBrSjZaMlhWdmNVYTBWdmZBMytrWjhQSWNGS2lmZTlqY2d6dzho?=
 =?utf-8?B?clUzVDA1VXZmUUh3b0E0M09TSS9WWU1LbkZnTVpLWW95Q3BVZlp5Y1lYOEdw?=
 =?utf-8?B?U1phTURYUkY0NWZsMDdWR2dMbmRWNEFzRFhhTDNMcmdmY28yM1o2R0h6dldD?=
 =?utf-8?B?dktzbkNvYTNyY3hZZFJneFR2WGRoYVpQcFNyS0E4cmlvWnBoSG85aTljY0ha?=
 =?utf-8?B?OHpQMWpibisyRnRiZkNRZXo3QlRwdG9JUnBkdXMxVTRNamJMQVNsSzlHdUNE?=
 =?utf-8?B?VWlsQVBmWWxacmdqampVMDQ3clgwbHRZWHhCa0QyNGVaYWtGRDFnQld0N0xX?=
 =?utf-8?B?UFFoOEp1cUkvUHpYWnVMVGlpbWoyeXluc1E2TndSRWwwK2d2ZkFLRjFNUDRU?=
 =?utf-8?B?SEFieDhUalZ1aU5qbGV2eDJ5Zm5pcE1LcHFkeUZBTXRrQ1FuSmpveGM1YkdT?=
 =?utf-8?B?M0YvTFBHM1lJT2RHTzJ4blZaOG9FK2x4R08xcGVJZGpHQTFUVmZSa2ZjRUhn?=
 =?utf-8?B?ZXh0dGFaNXIwVmY5R3lubFhFcDVHSEwwOGxnZFBNMlVPSFdGQVRHeUpGTlhk?=
 =?utf-8?B?OThVenlwSzhpSHQzRDFQcG11RG9zT0lLQVJHM1dpK2FtSWlja1Q0QVduSURS?=
 =?utf-8?B?ZjhkMEMydmZjOTU1WVdCOWRtQ0JQL3d1RUlQOXEzWUVBQVNqVDVWNklyNXJY?=
 =?utf-8?B?SlJMb05Vak9SVHVnNmY3dmY1d0trWTVtVURMQldua3E2eVFGVmxXNWlYR1d3?=
 =?utf-8?B?eENSRUwvNmxKRFQvVDJnaGMwNHRsWTlJN29rbGpOcXBwRU5DWXZyeFdXSG15?=
 =?utf-8?Q?fCwew57bY6hTi8OTZ8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d368954-55fc-40aa-6a3a-08d9889600ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 06:53:28.6960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jc2FGw/mfmv+gs4f3S5I88px34Vf7gBdIfiZ0O2Y/c8TUo61ayDot7tq1VEIDrYjwD8ilk9Sd2tThxIBuNue1vAjNo3ILTsoks3jmBtJN8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4023
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDEyLzEyXSByYXZiOiBVcGRhdGUvQWRk
IGNvbW1lbnRzDQo+IA0KPiBPbiAxMC81LzIxIDI6MDYgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiAN
Cj4gPiBUaGlzIHBhdGNoIHVwZGF0ZS9hZGQgdGhlIGZvbGxvd2luZyBjb21tZW50cw0KPiA+DQo+
ID4gMSkgRml4IHRoZSB0eXBvIEFWQi0+RE1BQyBpbiBjb21tZW50LCBhcyB0aGUgY29kZSBmb2xs
b3dpbmcgdGhlIGNvbW1lbnQNCj4gPiAgICBpcyBmb3IgR2JFdGhlcm5ldCBETUFDIGluIHJhdmJf
ZG1hY19pbml0X2diZXRoKCkNCj4gDQo+ICAgIDsgbm90IG5lZWRlZCBhdCB0aGUgZW5kIG9mIHRo
ZSBjb21tZW50LiA6LSkNCj4gDQo+ID4NCj4gPiAyKSBVcGRhdGUgdGhlIGNvbW1lbnQgIlBBVVNF
IHByb2hpYml0aW9uIi0+ICJFTUFDIE1vZGU6IFBBVVNFDQo+ID4gICAgcHJvaGliaXRpb247IER1
cGxleDsgVFg7IFJYOyIgaW4gcmF2Yl9lbWFjX2luaXRfZ2JldGgoKQ0KPiA+DQo+ID4gMykgRG9j
dW1lbnQgUEZSSSByZWdpc3RlciBiaXQsIGFzIGl0IGlzIG9ubHkgc3VwcG9ydGVkIGZvcg0KPiA+
ICAgIFItQ2FyIEdlbjMgYW5kIFJaL0cyTC4NCj4gDQo+ICAgIE5vdCBhIGdvb2QgaWRlYSB0byBk
byAzIGRpZmZlcmVudCB0aGluZ3MgaW4gMSBwYXRjaC4uLiBJIGtub3cgSSBzYWlkDQo+IHRoYXQg
KDIpIGlzbid0IHdvcnRoIGEgc2VwYXJhdGUgcGF0Y2ggYnV0IEkgbWVhbnQgdGhhdCBpdCBzaG91
bGRiZSBkb25lIGFzDQo+IGEgcGFydCBvZiBhIGxyZ2VyIHJhdmJfZW1hY19pbml0X2diZXRoKCkg
Y2hhbmdlLiBTb3JyeSBmb3Igbm90IGJlaW5nIGNsZWFyDQo+IGVub3VnaC4uLg0KDQpXZSBhcmUg
aW1wcm92aW5nIGNvbW1lbnRzIG9uIEdiZXRoZXJuZXQgZHJpdmVyLCBzbyBJIHRob3VnaHQgMSBw
YXRjaCB3aWxsIGFkZHJlc3MNCkFsbCB0aGUgY29tbWVudHMsIHNpbmNlIHRoZXJlIGlzIG5vIGZ1
bmN0aW9uYWwgY2hhbmdlLg0KDQpPSyB3aWxsIGNyZWF0ZSAzIHNlcGFyYXRlIHBhdGNoZXMgZm9y
IGZpeGluZyB0aGVzZSBjb21tZW50cy4NCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERh
cyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gUkZDIGNoYW5nZXM6
DQo+ID4gICogTmV3IHBhdGNoLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmIuaCAgICAgIHwgMiArLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jIHwgNCArKy0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IGRmYmJkYTM2ODFmOC4uNGEw
NTcwMDVhNDcwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gQEAgLTUxOSw3ICs1MTksNyBAQCBzdGF0aWMgdm9pZCByYXZiX2VtYWNfaW5p
dF9nYmV0aChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmRldikNCj4gPiAgCS8qIFJlY2VpdmUgZnJh
bWUgbGltaXQgc2V0IHJlZ2lzdGVyICovDQo+ID4gIAlyYXZiX3dyaXRlKG5kZXYsIEdCRVRIX1JY
X0JVRkZfTUFYICsgRVRIX0ZDU19MRU4sIFJGTFIpOw0KPiA+DQo+ID4gLQkvKiBQQVVTRSBwcm9o
aWJpdGlvbiAqLw0KPiA+ICsJLyogRU1BQyBNb2RlOiBQQVVTRSBwcm9oaWJpdGlvbjsgRHVwbGV4
OyBUWDsgUlg7ICovDQo+IA0KPiAgICBObyBuZWVkIGZvciA7IGFmdGVyIFJYLg0KDQpPSy4NCg0K
UmVnYXJkcywNCkJpanUNCg==
