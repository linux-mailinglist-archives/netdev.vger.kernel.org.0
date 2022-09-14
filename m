Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8C5B8E19
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiINRUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiINRUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:20:20 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2103.outbound.protection.outlook.com [40.107.114.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D08157E3C;
        Wed, 14 Sep 2022 10:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvKoMMDItHKjSUQr6MgZ+H88l/CG+Uim0qJoETRjCwG9u9VYYvG+QEd1feQ6NpA6t56JXo9CmGXvFsBk9/z1XJo1h33XLtf3/pPJRsxY+wrm1n1ex32K2c08xEitcc+8TNE0RYart6+nv/KZW4R2HwsrPzspvnaOtC+EwI4+vJ+jdYQOQIE4PX9bGmAk3nI/lhZXzqabX43W6XVd6Yd8oASoZhCbuvIROFeuO+vXrLLQWlGNoNlZCQqvpzZgNpJVYRMfl9nRr6LLef4maFDNA0rHQpnGf5YH8gFVtuh62/Tnqt+Dej8RnlN4IBAQn6rlVTEr5H4LnsMAuBXWgOoxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXTSQYsrEyFqKv/GM+OuH5OD87uOJNpM9UewMX6/iTY=;
 b=aESaOMAX91QndDnq1cR7gw1yZUoMOwEoCquAJht7gLQ+2haZRpR+4sV5RVOQaKbwToaIc/8cPwytAdkJ2BGPSalYwzrlmfDwqG5tErJQrG+FSEHeiP3RNHREqyQJrZxZQQUHa/XcXpaLoGDSEwLO5brrCLJ3s7sTD9McbkOn5lxmYWRogTvvwgTtOaKfsTetJxD4BxDoXiESK8uyq5Hm3GuZCND2LmK5O+lmJmcRFsvtL1Vc7jpHdmNsZ8aPakcotlMVxbZdplD5NBTf87sAvBvqXVLyUil1L/q2I1+A0GIdoSE1mWGblbJW+bHzjcwA0D0Ue+nuNgR3XkjbnyWafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXTSQYsrEyFqKv/GM+OuH5OD87uOJNpM9UewMX6/iTY=;
 b=REbi/FTmiSgME+vkZpKtiu2MM0iAHOP4/WjnYCEZnN75cN8jyqxNjsVw2NZiJV3zLjbaomeJm2SAmmf/FRRD+8vwmQsxWFfei615HM9Hr3KPe0LxYeAS+zDoruIJVY17Y09Ru88D+vY02SGPipKo6gH9pE+vZz4dceO1Q45/Kx0=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB10216.jpnprd01.prod.outlook.com (2603:1096:604:1e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 17:20:14 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f%3]) with mapi id 15.20.5632.014; Wed, 14 Sep 2022
 17:20:13 +0000
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
Subject: RE: [PATCH net-next v3] ravb: Add RZ/G2L MII interface support
Thread-Topic: [PATCH net-next v3] ravb: Add RZ/G2L MII interface support
Thread-Index: AQHYyAXhcDwFSsslx0u3BQUD3D9PoK3fKQ2AgAAAbaA=
Date:   Wed, 14 Sep 2022 17:20:13 +0000
Message-ID: <OS0PR01MB592297F89124DD62211582AE86469@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220914064730.1878211-1-biju.das.jz@bp.renesas.com>
 <631f13b7-9cab-68b7-a0b1-368bb591c4d2@omp.ru>
In-Reply-To: <631f13b7-9cab-68b7-a0b1-368bb591c4d2@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB10216:EE_
x-ms-office365-filtering-correlation-id: 045f1c5a-3d4c-40a5-b325-08da96756280
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WuGuWsw9M7r06EI7mg/TRq5TMV2AF8DtcuAUTnwclgJ+WqdJ9eQ09Gl1MUP6+i1g1mrwZr8rS+FYUlHU/ENEtz/83BZKqRmKVjV4WOOzAbzVoK1DXl2LCDN10R1ooUM7No1SV1Yc9lxqiJFq2i3oCq09zsuPl1JS6ipf0o6AUVvEQAKstEzznZmNMkfAPGM5XW0rgvhLfP9uSb/bb+slqsmtcNxBEb7nA3xYEfDL4UFAUR05ReMmrkbQzMjYem5OANvqHA7BN8gAgu8o62xs8P+uCxCI4l/SXje587/vuOXjsrHDkaeLBYAyOyrXsZJvmcacT/dhabL22hsbzlKrs1dLx+MK6Mwpj79GCUwHNStE2FpurzJG/7OcoF9r4hewpWY+PA3VEVM4PsNhw+yBVqCz3UWbPD6vXGgpgqqstzfKzS2Untll88O1zJlv/TP+AcQO5Fe1Lg9nLAtN0dpaCIKJxjNZCl1gqtNFVQL8ir3QWJ1cn7aRtPe66PqmDntaK5Ih0UCopYpGGb9sa3JiUjSaXDeaXEe8q9lKwneo0AAM6Aap9kmTddKkXB24h+kDcZCcvSkwo+QghrNMHYDNoQuJ2b9ElIJ29ipw4t9e/rR4lzYcRwLb5fz+0C/zIP/OzVaI8ws/yYoHhFymgg5z3uqHGpclUNarVe1BuEo9LxUzAeBfTaJuksfi5yVfsMYl6SngxCobypuVMd4X00nYF3UNpz3lWlWdBgavYsWxH0W5W2eLiww9JRIvSu44UDsFNrXurNdC86pIrhSODd68+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(122000001)(5660300002)(4326008)(52536014)(8936002)(76116006)(64756008)(8676002)(66446008)(107886003)(2906002)(66946007)(53546011)(316002)(55016003)(38100700002)(41300700001)(71200400001)(33656002)(86362001)(54906003)(66556008)(66476007)(6506007)(38070700005)(186003)(110136005)(83380400001)(478600001)(26005)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVdtdnkrY3hlSG1NQXFFQU8remd6Znc3aTRCOVg1WXdWNzlxTzNaVUMxSVRQ?=
 =?utf-8?B?ZUtMUkxnV0QyQUMrT3ZkMC91bWNPK3ZLSkNlZWdLU0FRUHdaWStpOGtFKzM2?=
 =?utf-8?B?bmhpcFUyazdod0FLTXNCdGY0UFFJVm1lbUV6amlCUWdTMGo5R3pSdlQwbWNN?=
 =?utf-8?B?c1hYY29WSXpmTXhFNjJySjBVSEtRSW4wQnV1QzAyRHpQbjFFemNIWG5CdHYw?=
 =?utf-8?B?K3VYVmJQa0ZzOGdrbmhVc3l5aXhuc3gxenZYQWRHYnFpZ0pibkdqMHpIZlh1?=
 =?utf-8?B?VDg0TmFaLzIyZGc3dThzL1NWcTlEVXd2TlVDb1JDNW5yWXJRNUtiMzIvakJ2?=
 =?utf-8?B?QW1zcTkyVGQxaUUzR0lGQjN1YlZLV213QjFMeXp2eW9tbS9KSXRrdVR1MGph?=
 =?utf-8?B?UDhXTDlrK2NCbi9GdHZLMDM5WU16alJncmhtRGtZVjVGMDd3N3RjeXA3cjFQ?=
 =?utf-8?B?eU04U1NvcWhyOWhCWmdaclZzc1hiR29Qay9Rc0RmbXN0MlZmbC84OGd0S0hV?=
 =?utf-8?B?STdJakJCSEZVc0ZSalZ5ZGRPdmZBTUZTK1ZIK3B0ekZsdWhtMzdYdUVEQW80?=
 =?utf-8?B?ZnNBVlVHZEFZdlVwQThqUXVYalR6ekdYRVl3OTRHQTdFUmJMMDhwVVlENGxa?=
 =?utf-8?B?WnRMaVQvb3BxZXc0WmtFMUl1KzJUUnVmS3NtM21SOUJ6bU53YjJJWXVUZ2JF?=
 =?utf-8?B?ZE1pMllNcFdMRE55a0JoYW9ORWxRazBKMXhwalZrOEhEcFhxYjRmRk16cVNC?=
 =?utf-8?B?ZnppY3BtUlVNRW41T0I1NlVBWEhtZGRJcjdUVW4wQ0JCR1JsSW8wYi9jUWxM?=
 =?utf-8?B?MVhqVEpxNWxjUmhOd1l1Z0lHYmlUMDFUYXdYVDZlblk3ZldWMTl5K2tSMDVU?=
 =?utf-8?B?anB4K0ZRVHY5WFhTbC9na0ZBYTU2NFFaYUFMT0toMG5BNEVWeWtHajUrMmxP?=
 =?utf-8?B?d2R1WTU1aVZjSEJVMTlVMHN3aTE2TDR2UlVGNnVZQVNpNHpSWXhQU2o3ekZ5?=
 =?utf-8?B?RFJJeUxOd1hJN1BnbWJlNGVvaDhlSUNSRGNnYmdmcjAyN2tyUHd0RGVFQmlF?=
 =?utf-8?B?TWdxbC9ua2RJdmJaSGgzWkZ6VW81c2FDeXpwQUZ3d2lqY0w1UVVGd0RNZTNY?=
 =?utf-8?B?NlhCbkZPemtIQTF0a2JaUG90UEtwckRqZzM4WHF5dXdFSDJmN3Vib3N3Y2Ri?=
 =?utf-8?B?UTZrOVZMeUdkRW9IOWRpWTJVcXd5and6dElBRW83TUlQSGZtdXZ4RWl4Zms5?=
 =?utf-8?B?aFNKWlhuVmQwdGJHYmN2SzQxMGlDRGgra3NESUtWNjlBaUx4anVZQWxjaWJk?=
 =?utf-8?B?Ykx2ZGRtcytiQjhqbGxYU2U1ZkhIYnkwZ3FZQmF4OHJscjZ5YVh0NHV4U0tp?=
 =?utf-8?B?RTdzNUM4cEhSdnA3V1hhc1VhRGJXNGtadWZTOEgxZmtCQkdaRGpjRSsvZlRW?=
 =?utf-8?B?eGcwRENjNzF6aVJmT1pzSElIZW1ZNGMxNVJkNDZsMzlHWHBEWVAya1RLTDB6?=
 =?utf-8?B?NnBBaUduWGcvOFFzU3hkZk5yQ0liZTlYd2M0L3JIelZMTUdmNWZKcVBEN2o2?=
 =?utf-8?B?bERESlJOV2ZiN01mMUpmZFFrSk9IUHJYV2l3UE9qeG9uODdnckljRUdwRDBZ?=
 =?utf-8?B?elNCdFdoNXMweFFUUkNJZ1lhOVhmUURKY3B0UDgyRDNLbFQ2Q2NVMlQ3ckY2?=
 =?utf-8?B?d0ttSmhiT2poTmR3QUtEUmJ1WVlGTCtHWldrWlZpTWNYWHM2eWwyaVJUQXJ2?=
 =?utf-8?B?cEJScGdyNHpZWktvNHhiM2RGRFJYeDN0bVBiREo0S1N0Y28rV0owTWl6eVgz?=
 =?utf-8?B?Uk5ON1laM3oxQlorTHV0aktBVXRaRi9IS2sxTWNzblZ0WHM2NUw5ZlpDblFa?=
 =?utf-8?B?MUlGbFF1clpCQXpWM09xcld6RWxORDVzcEFWZGJVbHBDVzFXTUMvNzBNakRN?=
 =?utf-8?B?U0lmK2EyU2tHSWNqU25NMVRoRzV0NDhzSVI0WExRbG5ZRzNsbG01OWQ0WWJX?=
 =?utf-8?B?SzdTeFhjZXRTZ3FCTG5IdlRVWlRsUWhOTThQTDQxSVRKUXdDcDUyZHFIN2Fk?=
 =?utf-8?B?S1pVMGRoOFZjdDRNTXJEcmQ4US9IUit4K2ZkWVg0cWFDWlZXOG1wUm9GSUpM?=
 =?utf-8?B?N3ZFRldCZUJrVDJ5K3V2WC85ekxpVWlrV1JDYnRSWkVMT00vM3NvclpqSUx1?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045f1c5a-3d4c-40a5-b325-08da96756280
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:20:13.3807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ll+ghlbdIaSocz7CGK1C0ywwFz2m1/AgxLmP6XiqWV4NrD/LnUyVePbSsHrE4YrfCYehGGI9lgIzKjBbmLc/WiRFkMfIyxk3BS3jdQeYeaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB10216
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYzXSByYXZiOiBBZGQgUlovRzJMIE1JSSBpbnRlcmZhY2Ugc3VwcG9y
dA0KPiANCj4gT24gOS8xNC8yMiA5OjQ3IEFNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gRU1B
QyBJUCBmb3VuZCBvbiBSWi9HMkwgR2IgZXRoZXJuZXQgc3VwcG9ydHMgTUlJIGludGVyZmFjZS4N
Cj4gPiBUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBmb3Igc2VsZWN0aW5nIE1JSSBpbnRlcmZhY2Ug
bW9kZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5y
ZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiB2Mi0+djM6DQo+ID4gICogRG9jdW1lbnRlZCBDWFIz
NV9IQUxGQ1lDX0NMS1NXMTAwMCBhbmQgQ1hSMzVfU0VMX1hNSUlfTUlJIG1hY3Jvcy4NCj4gDQo+
ICAgIEkgZGVmaW5pdGVseSBkaWRuJ3QgbWVhbiBpdCBkb25lIHRoaXMgd2F5Li4uDQo+IA0KPiBb
Li4uXQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBi
OTgwYmNlNzYzZDMuLjA1OGFjZWFjOGM5MiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yi5oDQo+IFsuLi5dDQo+ID4gQEAgLTk2NSw2ICs5NjYsMTEgQEAgZW51bSBDWFIz
MV9CSVQgew0KPiA+ICAJQ1hSMzFfU0VMX0xJTksxCT0gMHgwMDAwMDAwOCwNCj4gPiAgfTsNCj4g
Pg0KPiA+ICtlbnVtIENYUjM1X0JJVCB7DQo+ID4gKwlDWFIzNV9IQUxGQ1lDX0NMS1NXMTAwMAk9
IDB4MDNFODAwMDAsCS8qIDEwMDAgY3ljbGUgb2YgY2xrX2NoaQ0KPiAqLw0KPiANCj4gICAgTm8s
IHBsZWFzZSBqdXN0IGRlY2xhcmU6DQoNCg0KPiANCj4gCUNYUjM1X0hBTEZDWUNfQ0xLU1cJPSAw
eGZmZmYwMDAwLA0KDQpRMSkgV2h5IGRvIHlvdSB0aGluayB3ZSBzaG91bGQgdXNlIHRoaXMgdmFs
dWUgZm9yIHNldHRpbmcgTUlJPw0KDQpBcyBwZXIgaGFyZHdhcmUgbWFudWFsIHRoZSB2YWx1ZSB5
b3Ugc3VnZ2VzdGVkIGlzIHdyb25nIGZvciBNSUkgc2V0dGluZ3MuDQpTZWUgcGFnZSAyMTU3DQoN
CltBXSBUaGUgY2FzZSB3aGljaCBDWFIzNSBTRUxfWE1JSSBpcyB1c2VkIGZvciB0aGUgc2VsZWN0
aW9uIG9mIFJHTUlJL01JSSBpbiBBUEIgQ2xvY2sgMTAwIE1Iei4NCg0KKDEpIFRvIHVzZSBSR01J
SSBpbnRlcmZhY2UsIFNldCDigJhI4oCZMDNFOCAwMDAw4oCZIHRvIHRoaXMgcmVnaXN0ZXIuDQoo
MikgVG8gdXNlIE1JSSBpbnRlcmZhY2UsIFNldCDigJhI4oCZMDNFOCAwMDAy4oCZIHRvIHRoaXMg
cmVnaXN0ZXIuDQoNCj4gDQo+ID4gKwlDWFIzNV9TRUxfWE1JSV9NSUkJPSAweDAwMDAwMDAyLAkv
KiBNSUkgaW50ZXJmYWNlIGlzIHVzZWQNCj4gKi8NCj4gDQo+ICAgIEFsbCB0aGUgb3RoZXIgcmVn
aXN0ZXIgKmVudW0qcyBhcmUgZGVjbGFyZWQgZnJvbSBMU0IgdG8gTVNCLiBUaGUNCj4gY29tbWVu
dCBpcyBwcmV0dHkgc2VsZi1vYnZpb3VzIGhlcmUsIHBsZWFzZSByZW1vdmUgaXQuIEFuZCBkZWNs
YXJlIHRoZQ0KPiB3aG9sZSBmaWVsZCB0b286DQo+IA0KPiAJQ1hSMzVfU0VMX1hNSUkJCT0gMHgw
MDAwMDAwMywNCg0KVmFsdWVzIDEgYW5kIDMgYXJlIHJlc2VydmVkIHNvIHdlIGNhbm5vdCB1c2Ug
My4NCg0KSSB0aGluayB0aGUgY3VycmVudCBwYXRjaCBob2xkcyBnb29kIGFzIHBlciB0aGUgaGFy
ZHdhcmUgbWFudWFsDQpmb3Igc2VsZWN0aW5nIE1JSSBpbnRlcmZhY2UuIFBsZWFzZSByZWNoZWNr
IGFuZCBjb3JyZWN0IG1lDQppZiBpdCBpcyB3cm9uZy4NCg0KQ2hlZXJzLA0KQmlqdQ0KDQo+IAlD
WFIzNV9TRUxfWE1JSV9SR01JSQk9IDB4MDAwMDAwMDAsDQo+IAlDWFIzNV9TRUxfWE1JSV9NSUkJ
PSAweDAwMDAwMDAyLA0KPiANCj4gWy4uLl0NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IGIzNTdhYzRjNTZjNS4uOWEwZDA2ZGQ1ZWI2
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4gQEAgLTU0MCw3ICs1NDAsMTQgQEAgc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2luaXRfZ2JldGgo
c3RydWN0IG5ldF9kZXZpY2UNCj4gKm5kZXYpDQo+ID4gIAkvKiBFLU1BQyBpbnRlcnJ1cHQgZW5h
YmxlIHJlZ2lzdGVyICovDQo+ID4gIAlyYXZiX3dyaXRlKG5kZXYsIEVDU0lQUl9JQ0RJUCwgRUNT
SVBSKTsNCj4gPg0KPiA+IC0JcmF2Yl9tb2RpZnkobmRldiwgQ1hSMzEsIENYUjMxX1NFTF9MSU5L
MCB8IENYUjMxX1NFTF9MSU5LMSwNCj4gQ1hSMzFfU0VMX0xJTkswKTsNCj4gPiArCWlmIChwcml2
LT5waHlfaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9NSUkpIHsNCj4gPiArCQlyYXZi
X21vZGlmeShuZGV2LCBDWFIzMSwgQ1hSMzFfU0VMX0xJTkswIHwgQ1hSMzFfU0VMX0xJTksxLA0K
PiAwKTsNCj4gPiArCQlyYXZiX3dyaXRlKG5kZXYsIENYUjM1X0hBTEZDWUNfQ0xLU1cxMDAwIHwg
Q1hSMzVfU0VMX1hNSUlfTUlJLA0KPiA+ICsJCQkgICBDWFIzNSk7DQo+IA0KPiAJCXJhdmJfd3Jp
dGUobmRldiwgKDEwMDAgPDwgMTYpIHwgQ1hSMzVfU0VMX1hNSUlfTUlJLCBDWFIzNSk7DQo+IA0K
PiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
