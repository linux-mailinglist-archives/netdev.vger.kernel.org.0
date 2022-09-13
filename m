Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B245B7AA4
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIMTRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiIMTRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:17:32 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2096.outbound.protection.outlook.com [40.107.113.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ADD67168;
        Tue, 13 Sep 2022 12:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVM4YvfRqgqUZRQJ8s/PCuF5fLs/WIEtzeYqCtxKucGnjQlPx8QR42izjpd1pGEWs6/KUiIcLErXOVxwejgKqycgvcTyWPydR3Mk028CXIZTNujC0rfpcVZzlFwr0AmmzKBqUu+idDDoRSkl+xetjgLPTrs2bhTtqggvHMZ1x6/QhKGHmPs25o/z8X9C3Sw8F1n8DNPLkCsHBaY5xQv3lHnLQKjk42GgYof/IyX2odCtzvqsc4RdR531EqyDieGjTySSXgASBrTGLcc1X9RUn4cbDfeB4kyI/AYXmMiYkQRzoJ9IndbeuanW3AJsfEBfE6tvQab5+E2PRlOsySzEPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8Ske9nmUwGHZswecTVmG13rkjEUNlum6DMPsQJSXmk=;
 b=HfGJ4vl/3ZrwkQH2vUCnOO2auQd8jQ8CJ/s+x9w5UBt0zh3zpjljjNYuUM0Q0bfrCfHCCZyG13SShvlBaWY1IE7wLypqoG+/OefYghxPXb55K+DFfdlMo6FmvTfmsqQyysmPbhU2yTtNdtX2iI9MezlR+kAuXcH3Kfq1Y2PWR4xYkqlGKiPw2vmipnololchcMIHlCJcjqYObrxL/XtaxGjddwjDeBN3tjAMomNFoskzK5T6MknIlu7QcQtauSAZuWruu8F1uvbCdXkSyzdwMdpToGyq/2tMd0MUH8ItLDbURDWHeNmAhDY/eseCyelZrtw5DaAs9yXUAB1ES4iRRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8Ske9nmUwGHZswecTVmG13rkjEUNlum6DMPsQJSXmk=;
 b=qxJ3tTnTrxUJsO4HNzVXyb5ToaOcXZfkENKcOxGfSIXUMR4qujPthi8QuhgDPVZkjUXvXC3d4kxQtCNapkCvf52pZ8GyvpLNj7PacGUD3hqIymE/AIXpEJJBO1XAoI3dqpPz09qgKXdnu9RHelm+TfiJpSFqgVPFK4hEId3swKg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5459.jpnprd01.prod.outlook.com (2603:1096:604:af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Tue, 13 Sep
 2022 19:17:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 19:17:28 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next v2] ravb: Add RZ/G2L MII interface support
Thread-Topic: [PATCH net-next v2] ravb: Add RZ/G2L MII interface support
Thread-Index: AQHYxpWmr5xyMUG2eUOXfoXEFFpH1a3dkmGAgAAqzEA=
Date:   Tue, 13 Sep 2022 19:17:28 +0000
Message-ID: <OS0PR01MB5922461A6822870B79145DF686479@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220912105137.302648-1-biju.das.jz@bp.renesas.com>
 <8b01cd1e-dd7a-2504-27bc-c8bcdb97145a@omp.ru>
In-Reply-To: <8b01cd1e-dd7a-2504-27bc-c8bcdb97145a@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS0PR01MB5459:EE_
x-ms-office365-filtering-correlation-id: 29e496ae-d7e6-44d8-96eb-08da95bc9961
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3mHBZfPwSWMCBHgvPFc48JcW4E5w06pLl2428avQGF/6yDjgdFXOEz6zZbdj4/9GpvmciF//cw//vxdz7rtwmqHpF5e3YPf2DrpyoGfuyfGEvEARFz/SbvLHUIxHVjALR4wvR/OI9/eg5JveeMAe1Jj1g6Xe330+Ng+wwZv9iRNagL7ffRAmZ1eXKk6/+dh+A38nItLn4l4MBXXpfEc4mSMS5bXxsKk4EUUjwasOxJ57nq0rP10jczgn6NmRJJ4HDiPPDxtNlMKD+FZ2oC2j+FNX/y5S4cbLmWa7qSO7eXLpnhSQqbbJIPPiliFxkHGeHlDmFkcA0YYLxUem835AO92+C6Usd7ujc+W4jEPe7cRbubw18bI6yxdSXYUTLMEaojiZ3kmRg2d3kNlTsk3cQe8t0z/q+wFCaVBhzwv2wJUUfdxA8p2C+Qf55NKLJPxlRf0yhdhpU4IaEfIGxwADNyqxMs2uQ0f0lx4JsKvC3HeIFF3LdrwXxzf+87UpXddkY+n4nZimXMw7CNaX2w+jJg5spcL8DQpMXoa3Ncv1O3qs0tNEI/Z8NGqEWIOlSDbRxd4WcCvTeD80geUU4JvUzUMLXWWO65BJ5irnFSkndAuZpoQgt9LJFmLMDNkZXTfaZHPYeFiGe+0IrhiRBx31+2P+WqGJ1M7kmmO8g7+fWSXwUlFApP8ifIC8oEhPujzofa9wcI+jccAxatDVN+zTtAqUQB3lVPBZUKR47vGAK7bQA+0Nxiy0sxHxL07glZISdNOZmri0TMwSCeYhB8e/4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199015)(86362001)(33656002)(478600001)(41300700001)(55016003)(7696005)(110136005)(9686003)(64756008)(53546011)(66446008)(26005)(107886003)(4326008)(8676002)(66556008)(38070700005)(71200400001)(6506007)(5660300002)(4744005)(186003)(54906003)(316002)(8936002)(66476007)(122000001)(76116006)(38100700002)(2906002)(66946007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0J0MVNaVWFDblV1cHFWdWsxeFptSXVDa0JvYW4zMWZEVzU4WmxjS29vYUkv?=
 =?utf-8?B?QU1BMXpPanpXRVp2Mkc2b2RUTXJJbWRlUXFJWEZ5VHQxTjVVUWU0Tk9qdVZp?=
 =?utf-8?B?MkVkeDdNekxkakxBMFpCYUZoc1lEUWljcHNZV0dhV0pPc2xnWGcweVYxa1lr?=
 =?utf-8?B?UDIzMmd6SXNQbkNNRFJEYzRDRWJVTGdhWDNTeElIaHVIQWhPZnhPM3JNQUVi?=
 =?utf-8?B?dk5oYW9SemFjS25ib1NWa1U2UkNtMkI2TnVhRzZJWEZyYmlaeHlpbEp6VWhy?=
 =?utf-8?B?TGhsN2JVajYrUTZvbE41S2lTdUwreWRIcCtPNTZvRmdoNXg1cHBtTWZ4dWVW?=
 =?utf-8?B?Mm42akJVaWlnMkxOTFBwaWY1SW9KUERIZGMrRXg3cmNaVFdrbVJHMXlYN212?=
 =?utf-8?B?V3hXYm01Q0RSTE1iNmRzWjZORWc4VThtT0hJSGIzSFQveTVSb2xTTXBYd2ZK?=
 =?utf-8?B?M0RRU0d2QTB2SzdSdDlmdG5pblRoMVBHRlNuekdNRUZIVkNadEN0YWVSRmlE?=
 =?utf-8?B?aHZSdHlXYUdlSitvcW1IeXRNUmVWRXJGdE1FOVFBMWlyQnlteGpuMFBuUE5i?=
 =?utf-8?B?OEdUZEEyMmhKQXFGcm9RaUFoUnM5OTg2NHcveS8wTlN4RW0xdEtCa2lHS2FM?=
 =?utf-8?B?dHp1RmlTZ1RNdUsyUXZJWDVwZEpQdmRZTmtJYlJjbVNsaGJBNDJ6YTFmRG9B?=
 =?utf-8?B?N2Vac08zVVkxN2FlOWk4RkNhWk5JZXFKRENlelZsK2FYTjhyZEw5cFdvWkRt?=
 =?utf-8?B?cVpRUHRHUHB2N3BlTDVOWk9kd1JtSDBnWFRrNWZUUDBoRWY1MVZkY2pWOS9I?=
 =?utf-8?B?a0RaWm9hYnZta3lrK3JRQllEWlNxbWRaY29hS0l2YndCTEtrdHlmbHJQb0tz?=
 =?utf-8?B?dURWRk9uTjdSREptQTFOQk9ZZVRrT3ExSkpyb2Q1MzFxQjVTekp0QVBxSUFn?=
 =?utf-8?B?QW9EK290QzZpL29lclRxYzFJTkM3d20zTGxlWnJNcEhLeWNBdy9DMXA0Nmgv?=
 =?utf-8?B?eE4zNHQ4bU42S2x6OGFVVnFRQzh5c0Q1VTFQRWRmRnJqL0cwOTFHRDVXZjdX?=
 =?utf-8?B?bUI5cDRpZnRlSDFYdjd3VXV3V0VVMHBVaHEwbngyWFJ1TitTek5NME4xaDgx?=
 =?utf-8?B?d2l6UEtDMXJHMFQzeGIzLzEzVnVJVmltRG1TL29CYWtsWm8xTUpOQWtmL1RD?=
 =?utf-8?B?WE5ZeXJBODVDSEhRZGtRSnRqcnVCckh5ay9JUTRLdjdISW4yYVZxaDA4L05j?=
 =?utf-8?B?SktXVUxYWWZkSnhUU1lBWElkbDI2Y1N1N2llNUloeElVUU13QmRTTGM3VWNr?=
 =?utf-8?B?YzV3bC8za285ekVsaTI1a1dYQnl0bldTTnowQ3BlcDFhOVZjVWZKdzAyWnpt?=
 =?utf-8?B?dHI1cnlzZ25vbWxwdFVNWGpsQy8rY1dmM3FRUGlIVjhMYWVjd1NvTE8xdlNi?=
 =?utf-8?B?TERwVEIwQi82eTV5bmZMbW5Lc1lJYlpBQkJ1dkFtWkhEVUNiRG1iMkJ5dFZu?=
 =?utf-8?B?WmtYR3F4cUMvdUxyakhBWjRTQ28xSzNGT1B6V2JQazBEb3ErSkU2KzFyaVBJ?=
 =?utf-8?B?QlB4c0lyclBXRHYwSXdrT3VzaXpVMlNtWVFtTS9jeGsrTDZBYWRhYXU2MFA3?=
 =?utf-8?B?cEQxWDRucExNNWYrVDhWNjdHMzlXYlNLT0NxaVNrL1psVS8yNVVEejBtOHJ4?=
 =?utf-8?B?N0RUY092aFhsVVdwK21yL09OU3JqNE9xMFBLY2h3ZEtDYm1nNWl1RzlOc3Rn?=
 =?utf-8?B?Nm1HRE5WbTYxSElremxVQ2pweDVTVVhoazIxTjNQcnpyRkpLMUlZMENvbVZs?=
 =?utf-8?B?ZUNrVldCanJyTk50OXNxaUIyRzZHK0JSdmJDSTNvSkkzRVJzbkxaMmM3dm9a?=
 =?utf-8?B?dzRjdzVqbUFLcmFiUWFUVy9ONEpXMEg2QlNjZ3JQT1lHR3dMeTBwaGhSUVlX?=
 =?utf-8?B?aWd1R0Z5NUxKa0MyT3UwY0JjMzM3aDlCNEx3SGlOZG56RERUUjhzVWxDSzNu?=
 =?utf-8?B?OHl4RVlZVU1vWlg2M2hnNUE5bHh4dHVBd0dZdlJkOHVKLysvTFlaVndLZDA5?=
 =?utf-8?B?LzkrVGMxVzB3d245MDNMWW4vd1Q5NlJBd3N3Qi9zTEF0NVNpZEQ3aDF3Q29K?=
 =?utf-8?Q?6T+VgsKcdylHXpO1q+PNmPSiJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e496ae-d7e6-44d8-96eb-08da95bc9961
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 19:17:28.5733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hnf1918Gzujuq6y92vtKfovbQYfuAmNm/W8tQoYS8aQ9QurFYnFvQpmBUcYxY9kHfL+03hfIpYkBwlG5wEohuTDGALV3uhHIdpOUKewQjFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5459
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5IFNodHlseW92LA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkIGJhY2suDQoNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2Ml0gcmF2YjogQWRkIFJaL0cyTCBNSUkgaW50ZXJm
YWNlIHN1cHBvcnQNCj4gDQo+IE9uIDkvMTIvMjIgMTo1MSBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+
IA0KPiA+IEVNQUMgSVAgZm91bmQgb24gUlovRzJMIEdiIGV0aGVybmV0IHN1cHBvcnRzIE1JSSBp
bnRlcmZhY2UuDQo+ID4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQgZm9yIHNlbGVjdGluZyBNSUkg
aW50ZXJmYWNlIG1vZGUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5k
YXMuanpAYnAucmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBiOTgwYmNlNzYzZDMuLjBjN2MwZDQwNGRjYiAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+IFsuLi5dDQo+ID4g
QEAgLTk2NSw2ICs5NjYsMTAgQEAgZW51bSBDWFIzMV9CSVQgew0KPiA+ICAJQ1hSMzFfU0VMX0xJ
TksxCT0gMHgwMDAwMDAwOCwNCj4gPiAgfTsNCj4gPg0KPiA+ICtlbnVtIENYUjM1X0JJVCB7DQo+
ID4gKwlDWFIzNV9TRUxfTUlJCT0gMHgwM0U4MDAwMiwNCj4gDQo+ICAgIEknZCByZWFsbHkgcHJl
ZmVyIHRoYXQgU0VMX1hNSUlbMTowXSBhbmQgSEFMRkNZQ19DTEtTV1sxNTowXSBmaWVsZHMgdG8N
Cj4gYmUgZXhwbGljaXRseSBzcGVsbGVkIG91dCBoZXJlIChhcyB0aGV5IGFyZSBpbiB0aGUgbWFu
dWFsKS4uLg0KDQpPSyAsIHdpbGwgYWRkIENYUjM1X0hBTEZDWUNfQ0xLU1dfMTAwMCBhbmQgQ1hS
MzVfU0VMX1hNSUlfTUlJLg0KDQoNCkNoZWVycywNCkJpanUNCg==
