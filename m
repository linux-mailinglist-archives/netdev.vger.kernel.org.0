Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673DB425CF4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241572AbhJGUL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:11:26 -0400
Received: from mail-eopbgr1400105.outbound.protection.outlook.com ([40.107.140.105]:8192
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232399AbhJGULZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:11:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHY9V3fQTqiUzJ3Yqe7T1n7VsiAVjUNi+g8nX0ijRi79Su77f1YmRm5gr/KgSyeWoxIzpJNlZUl2VYE2nADX7IDopV+ethipsee6fYr/3rFcHdT8FGJQ70RsriqWw4KzPvJ5Th7r/EZtkFz9l43G/8OYTWNhrHe+XyeELJByZ20iQ9aOF4f2FGaWvEhT/fO2XtYhCdqQHtdy0pOLQDICzQ6ILna+38u9rJGzLFsWs6Zr6L+1rYhnkiwVRTMMJ4WApj4oqdcpbo6oZwMVIkkrSPCI1JCjFDhKJx23UjA1V+kevgVtEFSaDbXQ3XAhj6dVdjIsxlagtr68/oURLyIKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQgfiHekNF0asiR6/Ze4A9yAAH2h/l3IcC70ItsAUW4=;
 b=IUKG8oyq+/3djoA6Ra2AkzXWFz3LwPFSarCHCRFPDDZ7ZCBsfJidCBfl0KWyYraAJ+kaw2W2mRb2vMB6PMEWbayoRvza0VDTZUsmYb4P9vnuIGTkzo7yLVRz/4NaH1pFbu6CcxOrbfHH8qXwBb/dNuBA9+jqSdUP/fqpJ8O06GY3gpbv7TFQ81Bhvil+cVI9+PtUwlUgyE3j+YXHFkg5fPYJ2yrs+UkZw0LV2BVXO/awjtv5UTWCD9+o20pyOMoOnJSBASMT+yiz8oQpOXpO2NOaSiI550rRsCIobEpbJTokCaqEWeOVi/Nwk7SoMIaXJ16uXy3ni4mhfpXOIOP/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQgfiHekNF0asiR6/Ze4A9yAAH2h/l3IcC70ItsAUW4=;
 b=ompKLh9Lpopon8HbfLUofILP8zYhPIvUi6/qk5c9EtwXOhndPK8Zci0xUb7EPi8pl09APfEa8BdEHDVTyGYSpmZB0uI7ZCDYkT0yOfdiK8wuz8HyL3mxHM11Js0scwwaZubWjyN1FDtl9RpQhmKZgvnSCvHCTHOVyfntfmbccCc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6659.jpnprd01.prod.outlook.com (2603:1096:604:10d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Thu, 7 Oct
 2021 20:09:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Thu, 7 Oct 2021
 20:09:27 +0000
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
Subject: RE: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Topic: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Index: AQHXudknyVYpSr19EUOWd3E+ko3swavGX+aAgAAJbzCAAAV1gIAAlePwgADj/ACAAAp2UA==
Date:   Thu, 7 Oct 2021 20:09:27 +0000
Message-ID: <OS0PR01MB5922BCF31F520F8F975606B286B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
 <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
 <OS0PR01MB5922239A85405F807AE3C79A86B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <04dea1e6-c014-613d-f2f9-9ba018ced2a3@omp.ru>
In-Reply-To: <04dea1e6-c014-613d-f2f9-9ba018ced2a3@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93762a98-37f9-405b-bbca-08d989ce5dbf
x-ms-traffictypediagnostic: OS3PR01MB6659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB6659B52275F8177964F0DA2B86B19@OS3PR01MB6659.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mWVW8dJFFO0dHtHymdpYYRtHPePk9YoSICYckrUHW+ShGqXbQn7QFTM9RYU0TTkqSaaqsVADw4tKcvfi5UzQxRYYhdiNmZw5A+eWm/5gL+GwMu7yorljZKqTIN59xgV7HTXVG7mMxCbC0BS2b0RK52NUkJAgSl/tMBHqs7ERT3V9Lvdgk4OwGS721MQ/W+OKCX85Ly3pC2GM446caGuYtp67hsC+von2aQb7DbHJRhwoEeKG1z+VE9x8AZVgFTjwi9uUXsOdyU9KilJlG34sXNlylgupZNc5uV27PU5+SKIPPyoXPN9n9FUxb0s0WPZVbl1YsD0Caak200rCURNq+SwNAUSAFHhi2s744HRmiOFdS/56YouYjsr4bPU1S9DR1/kbqlDX5KQuW8OYSisFMqFkz0tfupsBMWyX6ADoV0BvxCQMwZGCl6jxF3py69iWEsYmPEiDnmaC6e8F/TOF8vHSO8dUifw0ePZG3sQKZGAKGEkATvkE4vI2dbTvdvH0Zr1O3wNwDEeYmatig+LtffosSFAtdvHIP0WuiTMZlW8fOIAPiABN08axt2QofKqx480EIEiNnLwRBCJY30Xtj0HppMKwPd1aqOeZAF9CrVRY6/fN26KKOCGBF8ToHYaNDYFiguMAASGbD22WlkRX1MG94kQbGhYbsUSZ+VCvl6s8CLiTuB7G+3ayzUo3Zfn3w5IHzid9oi8XnRtRX92VQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(107886003)(86362001)(186003)(316002)(52536014)(122000001)(6506007)(2906002)(7696005)(71200400001)(8936002)(508600001)(8676002)(53546011)(5660300002)(38100700002)(66556008)(64756008)(66946007)(76116006)(26005)(55016002)(4326008)(33656002)(7416002)(38070700005)(54906003)(66446008)(110136005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VitoQVkwSStjTUhMNTdqSUErUG1LTXphdnBZaVdOWWc4NENCWTF3RVVmZEEz?=
 =?utf-8?B?eENjRXg2endmeFZLbWU5ajBjWUF0U1RlN0RsNDQxckkvVGM5UVJ2RERVRXNt?=
 =?utf-8?B?WHFHWWJOK2R4TzUzbEJvem9PN2hRcFc1OXE4QVFIQmhISFIzeGs5aDJ0Z0Jp?=
 =?utf-8?B?dEtrTXJVS3N5aXA2L091U2xPRHZkRUxGeGxPZ3ZWN2krbHEydndsd0FwbTVq?=
 =?utf-8?B?dG9WTHV6b1NFeHozSmtjRnB2ZGdPNWxsNkpNdEYyZ2ZYNWdKNmVDZHlONmVU?=
 =?utf-8?B?SW96NVFrVjZCRUFXTUN4c2FTYjltcXNTM0ZxOTBTOFlZeWNabTl0Z3hBTVVk?=
 =?utf-8?B?QnFLcDYyQkV6NzN0SDdEQ2xNVjJhRmFFZE5RbzE4L1RCZFV6ajJZeVVKYTlx?=
 =?utf-8?B?Smk3Z1JmLzR5Nko4R2NtQlFjNDNDZnpSeGFKYXNoWWoxMVhBSXhCdGZpMU5E?=
 =?utf-8?B?K1BCQXVMelY2dEhodHVyR2x5ZzlVb2YyL2ZsNmNtZEhheHl2N05TeTJxUDNt?=
 =?utf-8?B?ZVpncnZMTDlPL212a2F5QTNGRFl1bTFkTnJKbUc3cjArU0Vmb1lsOXZMUmtZ?=
 =?utf-8?B?ZmIyS1cwVGdxaTh4VEh6UzRDKzloS2ROcFZ0ZnMzK0h1dVNMalRvM0ZrOVFn?=
 =?utf-8?B?NjA1cUdtZjYvYnR6TDVnVlZaRUZiRm1Nb003SmYyVXkyOVdyZWZUM0RMSkNL?=
 =?utf-8?B?bCtvRkxxckNQOGN2UHhMTHhsQkR2RktWYXROUWNpenFwczdKR1BiMzFaRXM3?=
 =?utf-8?B?QXJsY0Z3UnptQnNicXF1QjFSa25JYUpLb1ZBNUVpMTlocVUwU2MxK0ErL1Bp?=
 =?utf-8?B?QVFGeDgxVDArb0xjQ3lyNzN6anJMeWtUZWpSTmMvN1l1MmMzVUFJeDhmQUUr?=
 =?utf-8?B?S1NTQzFjOFJoQ29CdGlCMDRpeEJqeHY4TEZSa2VWbmFON1BneWNwc0w0TTRa?=
 =?utf-8?B?cUZERTVxSEcxR3ozMVI4VnE2TjJuZnh3NVBuV2VHSVVROHVBUnk2YlQxdW9Z?=
 =?utf-8?B?RU9obTZ3OThoZU9yMjFwKy9ydmVzMDJHUlU4N3NWYVRjaUlxTTNCUCtFZ1hh?=
 =?utf-8?B?YXZwZkRDKzE1NkdqUFpXSzJKejRMenI1Njd2ODBSMGdTZC9vcjV3QkExK3BI?=
 =?utf-8?B?cDU2TlJZaG1oYjVURlN2bkJkSmJGajg2WnF3UUY4VmlnSjF3TE8rV3J6TjRx?=
 =?utf-8?B?MkhUdVl2ZmhnYVdsTytoMG1HZStWV3BPbEF0L1ZsRi9DK0M1dE1Ta1U0b1RZ?=
 =?utf-8?B?TVErSUJ3c2tHczNSaVhuQUhMc0tuZGRIMEtxYzhqa3NlYld4b0ZtR3lMU0ow?=
 =?utf-8?B?dGtVY0JTOU1ZRzZtaThOOHFBc0hCWk1YQVlFcmFGams4MmcyZkJGMTAzUDRC?=
 =?utf-8?B?YmpUQnZ2RzkvcGZZN0htbkcxNXFWVzYwQ0lQUkRPWmhPbjdab2thWkZlTHBD?=
 =?utf-8?B?Y2h4bE5KcmZlNzZaa2ZtTzI0VHpqS21wWktSYVlsVHViOXZ4TktKU2FUYkRv?=
 =?utf-8?B?NXdVK0J1N3p6N1BsZnJkZytKWHhIWWlwRnFkckdrWjhyWk9rRm1iVm9KejUy?=
 =?utf-8?B?NFJZZTR6dTRQWFJLTGF4SnoxVXFGd2o5VjdmZjlsZGJGUEdMbG9mSHJZWm9l?=
 =?utf-8?B?SGd4MjRaZ1cwaHFnbXQvSlNkTlBScXN3UFNYbDlXUFpEN0tZOFp1b3ZWMytN?=
 =?utf-8?B?U2NvS0tRV2s5SUhncE9JQXQwSFRHbGx1YWJJWlE4UDcyblJoUlowT1lnU2xL?=
 =?utf-8?Q?52HHFkm5zSAcj4clXw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93762a98-37f9-405b-bbca-08d989ce5dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 20:09:27.5524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HlVbCwLLn47Qx0Sebm/vivGQl0pizdJ3hJG/uxinhVqYKrEqcqYPyLJUybm/hpxprnG/fNZY9DqvxW/QYC5t77irOB7RqGoxI//nPV3y4L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJl
OiBbUkZDIDA3LzEyXSByYXZiOiBGaWxsdXAgcmF2Yl9yeF9nYmV0aCgpIHN0dWINCj4gDQo+IE9u
IDEwLzcvMjEgODo0OSBBTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiBbLi4uXQ0KPiA+Pj4+PiBG
aWxsdXAgcmF2Yl9yeF9nYmV0aCgpIGZ1bmN0aW9uIHRvIHN1cHBvcnQgUlovRzJMLg0KPiA+Pj4+
Pg0KPiA+Pj4+PiBUaGlzIHBhdGNoIGFsc28gcmVuYW1lcyByYXZiX3JjYXJfcnggdG8gcmF2Yl9y
eF9yY2FyIHRvIGJlDQo+ID4+Pj4+IGNvbnNpc3RlbnQgd2l0aCB0aGUgbmFtaW5nIGNvbnZlbnRp
b24gdXNlZCBpbiBzaF9ldGggZHJpdmVyLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBTaWduZWQtb2ZmLWJ5
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+Pj4+IFJldmlld2Vk
LWJ5OiBMYWQgUHJhYmhha2FyDQo+ID4+Pj4+IDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAu
cmVuZXNhcy5jb20+Wy4uLl0NCj4gPj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+Pj4+IGluZGV4IDM3MTY0YTk4MzE1Ni4uNDI1NzNlYWM4
MmI5IDEwMDY0NA0KPiA+Pj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmJfbWFpbi5jDQo+ID4+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yl9tYWluLmMNCj4gPj4+Pj4gQEAgLTcyMCw2ICs3MjAsMjMgQEAgc3RhdGljIHZvaWQgcmF2Yl9n
ZXRfdHhfdHN0YW1wKHN0cnVjdA0KPiA+Pj4+PiBuZXRfZGV2aWNlDQo+ID4+Pj4gKm5kZXYpDQo+
ID4+Pj4+ICAJfQ0KPiA+Pj4+PiAgfQ0KPiA+Pj4+Pg0KPiA+Pj4+PiArc3RhdGljIHZvaWQgcmF2
Yl9yeF9jc3VtX2diZXRoKHN0cnVjdCBza19idWZmICpza2IpIHsNCj4gPj4+Pj4gKwl1OCAqaHdf
Y3N1bTsNCj4gPj4+Pj4gKw0KPiA+Pj4+PiArCS8qIFRoZSBoYXJkd2FyZSBjaGVja3N1bSBpcyBj
b250YWluZWQgaW4gc2l6ZW9mKF9fc3VtMTYpICgyKQ0KPiBieXRlcw0KPiA+Pj4+PiArCSAqIGFw
cGVuZGVkIHRvIHBhY2tldCBkYXRhDQo+ID4+Pj4+ICsJICovDQo+ID4+Pj4+ICsJaWYgKHVubGlr
ZWx5KHNrYi0+bGVuIDwgc2l6ZW9mKF9fc3VtMTYpKSkNCj4gPj4+Pj4gKwkJcmV0dXJuOw0KPiA+
Pj4+PiArCWh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSBzaXplb2YoX19zdW0xNik7
DQo+ID4+Pj4NCj4gPj4+PiAgICBOb3QgMzItYml0PyBUaGUgbWFudWFsIHNheXMgdGhlIElQIGNo
ZWNrc3VtIGlzIHN0b3JlZCBpbiB0aGUNCj4gPj4+PiBmaXJzdA0KPiA+Pj4+IDIgYnl0ZXMuDQo+
ID4+Pg0KPiA+Pj4gSXQgaXMgMTYgYml0LiBJdCBpcyBvbiBsYXN0IDIgYnl0ZXMuDQo+IA0KPiAg
ICBUaGUgSVAgY2hlY2tzdW0gaXMgYXQgdGhlIDFzdCAyIGJ5dGVzIG9mIHRoZSBvdmVyYWxsIDQt
Ynl0ZSBjaGVja3N1bQ0KPiAoY29taW5nIGFmdGVyIHRoZSBwYWNrZXQgcGF5bG9hZCksIG5vPw0K
DQpTb3JyeSwgSSBnb3QgY29uZnVzZWQgd2l0aCB5b3VyIHF1ZXN0aW9uIGVhcmxpZXIuIE5vdyBp
dCBpcyBjbGVhciBmb3IgbWUuDQoNCkkgYWdyZWUgdGhlIGNoZWNrc3VtIHBhcnQgaXMgc3RvcmVk
IGluIGxhc3QgNGJ5dGVzLiBPZiB0aGlzLCB0aGUgZmlyc3QgMiBieXRlcyBJUFY0IGNoZWNrc3Vt
DQphbmQgbGFzdCAyIGJ5dGVzIFRDUC9VRFAvSUNNUCBjaGVja3N1bS4NCg0KPiANCj4gPj4gICAg
U28geW91J3JlIHNheWluZyB0aGUgbWFudWFsIGlzIHdyb25nPw0KPiA+DQo+ID4gSSBhbSBub3Qg
c3VyZSB3aGljaCBtYW51YWwgeW91IGFyZSByZWZlcnJpbmcgaGVyZS4NCj4gPg0KPiA+IEkgYW0g
cmVmZXJyaW5nIHRvIFJldi4xLjAwIFNlcCwgMjAyMSBvZiBSWi9HMkwgaGFyZHdhcmUgbWFudWFs
IGFuZA0KPiANCj4gICAgU2FtZSBoZXJlLg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gUGxlYXNlIGNo
ZWNrIHRoZSBzZWN0aW9uIDMwLjUuNi4xIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGhhbmRsaW5nPiBB
bmQNCj4gPiBmaWd1cmUgMzAuMjUgdGhlIGZpZWxkIG9mIGNoZWNrc3VtIGF0dGFjaGluZyBmaWVs
ZA0KPiANCj4gICAgSSBoYXZlLg0KPiANCj4gPiBBbHNvIHNlZSBUYWJsZSAzMC4xNyBmb3IgY2hl
Y2tzdW0gdmFsdWVzIGZvciBub24tZXJyb3IgY29uZGl0aW9ucy4NCj4gDQo+ID4gVENQL1VEUC9J
Q1BNIGNoZWNrc3VtIGlzIGF0IGxhc3QgMmJ5dGVzLg0KPiANCj4gICAgV2hhdCBhcmUgeW91IGFy
Z3Vpbmcgd2l0aCB0aGVuPyA6LSkNCj4gICAgTXkgcG9pbnQgd2FzIHRoYXQgeW91ciBjb2RlIGZl
dGNoZWQgdGhlIFRDUC9VRFAvSUNNUCBjaGVja3N1bSBJU08gdGhlDQo+IElQIGNoZWNrc3VtIGJl
Y2F1c2UgaXQgc3VidHJhY3RzIHNpemVvZihfX3N1bTE2KSwgd2hpbGUgc2hvdWxkIHByb2JhYmx5
DQo+IHN1YnRyYWN0IHNpemVvZihfX3dzdW0pDQoNCkFncmVlZC4gTXkgY29kZSBtaXNzZWQgSVA0
IGNoZWNrc3VtIHJlc3VsdC4gTWF5IGJlIHdlIG5lZWQgdG8gZXh0cmFjdCAyIGNoZWNrc3VtIGlu
Zm8NCmZyb20gbGFzdCA0IGJ5dGVzLiAgRmlyc3QgY2hlY2tzdW0oMmJ5dGVzKSBpcyBJUDQgaGVh
ZGVyIGNoZWNrc3VtIGFuZCBuZXh0IGNoZWNrc3VtKDIgYnl0ZXMpICBmb3IgVENQL1VEUC9JQ01Q
IGFuZCB1c2UgdGhpcyBpbmZvIGZpbmRpbmcgdGhlIG5vbiBlcnJvciBjYXNlIG1lbnRpb25lZCBp
biAgVGFibGUgMzAuMTcuDQoNCkZvciBlZzotDQpJUFY2IG5vbiBlcnJvci1jb25kaXRpb24gLS0+
ICAiMHhGRkZGIi0tPklQVjRIZWFkZXJDU3VtIHZhbHVlIGFuZCAiMHgwMDAwIiBUQ1AvVURQL0lD
TVAgQ1NVTSB2YWx1ZQ0KDQpJUFY0IG5vbiBlcnJvci1jb25kaXRpb24gLS0+ICAiMHgwMDAwIi0t
PklQVjRIZWFkZXJDU3VtIHZhbHVlIGFuZCAiMHgwMDAwIiBUQ1AvVURQL0lDTVAgQ1NVTSB2YWx1
ZQ0KDQpEbyB5b3UgYWdyZWU/DQoNClJlZ2FyZHMsDQpCaWp1DQo+IA0KPiA+Pj4+PiArDQo+ID4+
Pj4+ICsJaWYgKCpod19jc3VtID09IDApDQo+ID4+Pj4NCj4gPj4+PiAgICBZb3Ugb25seSBjaGVj
ayB0aGUgMXN0IGJ5dGUsIG5vdCB0aGUgZnVsbCBjaGVja3N1bSENCj4gPj4+DQo+ID4+PiBBcyBJ
IHNhaWQgZWFybGllciwgIjAiIHZhbHVlIG9uIGxhc3QgMTYgYml0LCBtZWFucyBubyBjaGVja3N1
bSBlcnJvci4NCj4gPj4NCj4gPj4gICAgSG93J3MgdGhhdD8gJ2h3X2NzdW0nIGlzIGRlY2xhcmVk
IGFzICd1OCAqJyENCj4gPg0KPiA+IEl0IGlzIG15IG1pc3Rha2UsIHdoaWNoIHdpbGwgYmUgdGFr
ZW4gY2FyZSBpbiB0aGUgbmV4dCBwYXRjaCBieSB1c2luZw0KPiB1MTYgKi4NCj4gDQo+ICAgIE5v
dGUgdGhhdCB0aGlzICd1MTYnIGhhbGZ3b3JkIGNhbiBiZSB1bmFsaWduZWQsIHRoYXQncyB3aHkg
dGhlIGN1cnJlbnQNCj4gY29kZSB1c2VzIGdldF91bmFsaWduZWRfbGUxNigpLg0KPiANCj4gPj4+
Pj4gKwkJc2tiLT5pcF9zdW1tZWQgPSBDSEVDS1NVTV9VTk5FQ0VTU0FSWTsNCj4gPj4+Pj4gKwll
bHNlDQo+ID4+Pj4+ICsJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fTk9ORTsNCj4gPj4+Pg0K
PiA+Pj4+ICAgU28gdGhlIFRDUC9VRFAvSUNNUCBjaGVja3N1bXMgYXJlIG5vdCBkZWFsdCB3aXRo
PyBXaHkgZW5hYmxlIHRoZW0NCj4gPj4gdGhlbj8NCj4gPj4+DQo+ID4+PiBJZiBsYXN0IDJieXRl
cyBpcyB6ZXJvLCBtZWFucyB0aGVyZSBpcyBubyBjaGVja3N1bSBlcnJvciB3LnIudG8NCj4gPj4g
VENQL1VEUC9JQ01QIGNoZWNrc3Vtcy4NCj4gPj4NCj4gPj4gICAgV2h5IGNoZWNrc3VtIHRoZW0g
aW5kZXBlbmRlbnRseSB0aGVuPw0KPiA+DQo+ID4gSXQgaXMgYSBoYXJkd2FyZSBmZWF0dXJlLg0K
PiANCj4gICAgU3dpdGNoYWJsZSwgaXNuJ3QgaXQ/DQoNCj4gDQo+ID4gUmVnYXJkcywNCj4gPiBC
aWp1DQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
