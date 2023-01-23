Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD1677C09
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjAWM7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjAWM73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:59:29 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2101.outbound.protection.outlook.com [40.107.113.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9948D10E9;
        Mon, 23 Jan 2023 04:59:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4rYkLeRQiQ0VB+gxdRxv+2rpok29cF/GMI8dJTp/YqbicsfR6dtMfbPGJb8H7laRkMBQX4LZ/SzOmmLm6LzyYNh7xE8gq0WI0mwRxvcGQbwhUc+XlmQp/7oMIq/OGgkC/S0ggkA33RB+dZ7y6N/yoValp6bXBSRrIQl8c/CHU2K+oS9zVhmN4E+y72Y/evm1i7K95PTn3IOjkDoSyo8B0asOkj+VGOllyDwrOMo+cP0tRpumlDjF58R0ohXVUWwLCegOGuKitdYAqSP+/Kt5iloy3wGzxYyNmvkZIlxZr9Tq/+ChGxBAIjrzD19RGgYKlJrCEvR3yf0VKnmuKnSyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQSCj9VB8IrFhCxlFJmyoU0EY7JFRdErN0y+PlSubpg=;
 b=DXUAy5Eh5u20EJIOEhhGPXFLYLDNgRBXMG47ZEU8pbq8ua81Th+0bd845zPHuU5uwkRghcoPQeLLnlHjI/FJtHFiwz+8QKR9QSnhAroUBOLVagparG0RsfWqB+hLjBvJYvX0gj/daj3oCWTVhTFWSz+JmicAbjFpTRIoF7bSSR2f8Z8R3l3XzotY+9EpKW8oYZQQymPnUbtNG6Tra6iOD9iIIO47doINZ5+WIppROPgzNVrKam0Xl1jdsLAnZmBUCLwYMChM4tXDAjWCgGTnosPFH3axK/wzt5/17/RTIsFdySBwDJntPadEMa0QgovCm3QCbrPSuRjvd7dkHexWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQSCj9VB8IrFhCxlFJmyoU0EY7JFRdErN0y+PlSubpg=;
 b=drBbLIc3wjZwV6bydtJwNTDwraMNB1jFS6mHGYVeJs5MxUNsl/FxdJR1NB1yyAj9rxMTg6G83jo6k3wQUzZer6aqGwyS7pKEBlrWaYxOBdyGNGsNtVziJ/vKAKhIx7O/tSXA29DhflHqyRHAkaV0G93GbIXXs1PT7Dq+Pt6WxBE=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB8282.jpnprd01.prod.outlook.com
 (2603:1096:400:165::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:59:25 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 12:59:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net 2/2] net: ravb: Fix possible hang if RIS2_QFF1 happen
Thread-Topic: [PATCH net 2/2] net: ravb: Fix possible hang if RIS2_QFF1 happen
Thread-Index: AQHZK8ACFODQwuKeS0mesltm2ApVUq6nv4kAgAQ887A=
Date:   Mon, 23 Jan 2023 12:59:25 +0000
Message-ID: <TYBPR01MB5341503D6E7CA4B576D556F7D8C89@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
 <20230119043920.875280-3-yoshihiro.shimoda.uh@renesas.com>
 <e315c6d6-c088-2cb4-5c8d-f7578bc8404e@omp.ru>
In-Reply-To: <e315c6d6-c088-2cb4-5c8d-f7578bc8404e@omp.ru>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB8282:EE_
x-ms-office365-filtering-correlation-id: 6d844519-2bb2-4433-d2ef-08dafd41a7b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6fhD/inSGVsFqBh/N6xSIcj3Kh40fW2veS9TPUDNNp6Hl26Lffj5NaRaeS0GPjqPRM4TVj8LU6HBbrRoW3EcwypA0DJfteeyQ33AUe0yPdassbH3QNo2G4nGkhsPJn57qy64kPJZoCb20sae22SlmnqvTlS5t6uUZGZ9pPq29WEuZKlxip8uPRl/WCyZyjY53JCboRbExhS30G7XPvilc3E7Zt8eYlPMGYcbCvoeOi4mgKP01nV5qeVjua7Iy3AENWoW1UdsNsFq3ZmPlz6iwzUM2n0ggYuF2lbDJCUn3a4cf8AFgfLxEBO6S6nK36Vi0nKVLNOmOOtYaXMtnvoIc+WXHmkKwW3Fe/9aD2h2xX0uZOsPUCvRTO3jK86BQpNYezJ/yOSzPmDCLgJc0ovb+FFausXxt+NKD+fpS/wJ5kuROTptiizL0N9CVTREQwU7XdfEgvAVHuaIrtit/7TNxgfeHw98L4Hacz5pRQdqaV4QCfCNZU4Sy+uJTIo3LiiozSjzIbs9ZFw02BSbvsHy5L02qUKDDZ8vj4tsAt1PRrIx6N0dfaxVYkalz+J9u67uyHkLvfKiDXbO+t1o+3xnJ/WFVz1kn+dShEPaQlffGtrJbBfbfV1mx99yFK7cXs6HcfJ3PcKSPFmABnCxaS7a986NQfGKidVOwpQ1DKCEL0zFRmVHweyPsW8PzRbQ5qeiRvmCEWuDNMb0d4QDp14wwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(122000001)(38100700002)(33656002)(55016003)(86362001)(478600001)(38070700005)(316002)(110136005)(54906003)(64756008)(66446008)(8676002)(66946007)(66556008)(76116006)(4326008)(66476007)(7696005)(71200400001)(2906002)(6506007)(53546011)(8936002)(9686003)(52536014)(186003)(41300700001)(83380400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUhnZHQ0M0tYNi8xcjhBTXUzSVJXclA0Q05rMFlHYzl0MHhwanpFa0JaWU5P?=
 =?utf-8?B?aWdjd3FrbGR0RE95OG56cDM5ZXl4L0ZCNDRqZktrK05xMFVFUkdoa01jbGRV?=
 =?utf-8?B?NitDeE9BZlRFYXF4ZlZKa2ZhWGozVk8ydlRlUi9lNEtyVG9zQWlUODJzTXlz?=
 =?utf-8?B?bEhjRWJYaEkydUUwZ05PTnZjS21VRlJXdDA2Lzd1YnVvQUFBOG9ObEsxYllI?=
 =?utf-8?B?V29RQ1M5aGNxWXpUajJ2NG1yU2hNYWlDRk8rVVpOcEdrYUVCK3plaEVsZC90?=
 =?utf-8?B?WWlMSnh4bTl1eUw5c25RaURXZUhiZU1kbm8wWDZyRHlzSHV1UFRnYzdJaXhL?=
 =?utf-8?B?a3p2M2E5OUxkeXNlUnhjV2Y5eVdBSjdhQU9DcjhjVEQwSXpDanp5OE8rMmJF?=
 =?utf-8?B?VnlHb3k5c1UwcHY1L2N3dU4vL3JJcmtlUG82aWxyK2xFaDI3WlU0bSt5dDRO?=
 =?utf-8?B?UFZDQ2JycHZ6bHNZM0d1blRoR2pwb3hhaXE2YngxdEVja051ZDJXeTg1WnNR?=
 =?utf-8?B?VCtwYTB1cFJmYmRpb3Y1VkVKVzUrc2VjU2h6UUcySk5JL2Yrb2Y3NzRaU25J?=
 =?utf-8?B?LzBmVys1TG5RTDZpRzcrbHRZNE9OaWl2MWhrV0tyUWVXRDREQTd6b2N1Ny9r?=
 =?utf-8?B?MDBOU2xqZzZYWDI2UldmeTV5NWpLR0J1NXRsN2N2NmNuT2RRblpWUEJuRjNv?=
 =?utf-8?B?K09Fa081aW92SnYrczdvTDF3YjFjaWhwSHQvMjE0amNxVHZkL2F0RUVEMFU3?=
 =?utf-8?B?bktRN1FJMUNSa0t0WDIrVVpTSE9ZV05ucTVLMVdYM0RDa2RwbjQzTklxaHpw?=
 =?utf-8?B?anFKSkJzRE1ZS2x5WXplczBzVHFoMHA2V2w4RzY1VUlFb01zUGZ3YUFWRDlj?=
 =?utf-8?B?dUVtakV2NGNnTW1kRkF4ZGNVcFJvQng5Q2d5M1k4dEg4YUZaR3F3c1ZPUFNT?=
 =?utf-8?B?U01YSXZRcGdZM21KQXZmTzgreE1CL0g2bWlPQ3NsN0U1M3B2bG9NbHBNTkk2?=
 =?utf-8?B?NG5GdGE3MGs5ZGNhTUlMZGd3Vkh6VUJOa1BCaE41ejlpMEtCN1VWaTNpOUdi?=
 =?utf-8?B?eENvRHhTUmdsbG8wSlQ5eWhkLzIzNVpsblZYZUJrUkVHRldkMHROU3RuQ01X?=
 =?utf-8?B?WUQ5dGRnSXR1TVRocy9mNUtkY0VmVis3KzZtY3VyeTBwbVpOZnB2S2w1U1Jt?=
 =?utf-8?B?Sm5qV2Fmb1dVNVpLQ2RDZUppU1VZSi9tVTVQQnlDQTNvSEd4OEhBMnQ0Zmc3?=
 =?utf-8?B?ZTlkb0tPNC9WM0d5ODBwekpVVFdoNzlwVGtPZTF6eHk0NTZaMHc1V3h2VG9u?=
 =?utf-8?B?cEJnamJJdTNGWTJxU3ZaazlERzJSdERiS2h0NlNBTU5mdmU5SGhielJGQmow?=
 =?utf-8?B?WlFGWDhhWjRRekpwYmlhMnNTQWkwVjVEZ0JyMDE3aHZEdTRlWTBNNjZMaG5G?=
 =?utf-8?B?d3FrU2JXMU1PcVZUYUZxcFhxdnVQUjFCajZNNFBBcTB6VDNBWjVjVFFDK1hn?=
 =?utf-8?B?OWNXbjNWaVNkTWk0WFZTcmFlOUMyYjFLZnFLcm9VZm5MMDlNOFJtcVU2MnZx?=
 =?utf-8?B?S3RQSzlxVXF6eEI3aUVzVG00Rjc0YVNOZEhjRm1ZNXhuYnphanMzazVvL2Nq?=
 =?utf-8?B?bTJlUXhqbjlKVkJPUThaRHpYZUVoOERCcWsvTkJJUzBaZlFvVW5RYThVZWZx?=
 =?utf-8?B?cFJHYWRRTG1LZVlIS2ppdW1XdG5BNTFVWE5GVEY2RU9lS0tsbjdTTXFJU1FF?=
 =?utf-8?B?L1NKZEdCSTZ1Y1pqalVOZjJseHVZaTN0TFJrZ1dvaENJWldSOWhyUytuVmhE?=
 =?utf-8?B?UjFnc2YvQTdxa3kvOEhNLzE0TUNZSTB4bjlSMTcwQnE2TGFTL210TmVhQjJ6?=
 =?utf-8?B?anlIREhIS1BNKy8yV3hydXNDRTlVNjk0ZkM4VDVRQXlLUmxaOE8zUnBXWEJR?=
 =?utf-8?B?V0tHd1Nma3A2Tkg5QU9xUUlqMmE2eWswMGZPNVVZbFh6NktQbEk2RURmMXhN?=
 =?utf-8?B?S1hkZjBmOWdyQ29VUDU2OElSYmdZY0JrU2xEd1hhMGN2bzg4bkRoRVFodFR4?=
 =?utf-8?B?L0JmNis1c0V5L050UWhSVXA2ek5tSE5rajk3dXVtK0s4MktuTmwzK1IwNFB4?=
 =?utf-8?B?Y29sWkx5VTVRMGFiWnZsVno4Q0E5VmZMMVVKcGlHR3ZWa1gwb29Ca09DQUZO?=
 =?utf-8?B?eGVGclhsMERnajVMeTh1OTJqUGliWThTa1h6bWpWbHkxN29oOS9rZXl5YnVa?=
 =?utf-8?B?RWEvdHpEeDgwOUhzRWhZVVBxSHBRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d844519-2bb2-4433-d2ef-08dafd41a7b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 12:59:25.4552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IELpdU8JuFDZkHrfqGP1VzkZ2n0Rajf0q2x/MS/NnqViPWr5aEePo2q/h6qKrQ8I6bnWcYMANawOCOfZu/lTbb7mAgariW4QcZbT3Y5Fi+4acH5v96fd+r/r9jeq1pmf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LXNhbiwNCg0KPiBGcm9tOiBTZXJnZXkgU2h0eWx5b3YsIFNlbnQ6IFNhdHVyZGF5
LCBKYW51YXJ5IDIxLCAyMDIzIDU6MTIgQU0NCj4gDQo+IE9uIDEvMTkvMjMgNzozOSBBTSwgWW9z
aGloaXJvIFNoaW1vZGEgd3JvdGU6DQo+IA0KPiA+IFNpbmNlIHRoaXMgZHJpdmVyIGVuYWJsZXMg
dGhlIGludGVycnVwdCBieSBSSUMyX1FGRTEsIHRoaXMgZHJpdmVyDQo+ID4gc2hvdWxkIGNsZWFy
IHRoZSBpbnRlcnJ1cHQgZmxhZyBpZiBpdCBoYXBwZW5zLiBPdGhlcndpc2UsIHRoZSBpbnRlcnJ1
cHQNCj4gPiBjYXVzZXMgdG8gaGFuZyB0aGUgc3lzdGVtLg0KPiA+DQo+ID4gRml4ZXM6IGEwZDJm
MjA2NTBlOCAoIlJlbmVzYXMgRXRoZXJuZXQgQVZCIFBUUCBjbG9jayBkcml2ZXIiKQ0KPiANCj4g
ICAgTm8sIGl0J3MgYWN0dWFsbHkgYzE1NjYzM2YxMzUzICgiUmVuZXNhcyBFdGhlcm5ldCBBVkIg
ZHJpdmVyIHByb3BlcnwpIQ0KDQpJJ2xsIGZpeCBpdCBvbiB2Mi4NCg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFlvc2hpaGlybyBTaGltb2RhIDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4N
Cj4gWy4uLl0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5j
DQo+ID4gaW5kZXggM2Y2MTEwMGMwMmY0Li5iY2JiNjJmOTBmYjcgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBAQCAtMTEwMSw3ICsxMTAx
LDcgQEAgc3RhdGljIHZvaWQgcmF2Yl9lcnJvcl9pbnRlcnJ1cHQoc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYpDQo+ID4gIAlyYXZiX3dyaXRlKG5kZXYsIH4oRUlTX1FGUyB8IEVJU19SRVNFUlZFRCks
IEVJUyk7DQo+ID4gIAlpZiAoZWlzICYgRUlTX1FGUykgew0KPiA+ICAJCXJpczIgPSByYXZiX3Jl
YWQobmRldiwgUklTMik7DQo+ID4gLQkJcmF2Yl93cml0ZShuZGV2LCB+KFJJUzJfUUZGMCB8IFJJ
UzJfUkZGRiB8IFJJUzJfUkVTRVJWRUQpLA0KPiA+ICsJCXJhdmJfd3JpdGUobmRldiwgfihSSVMy
X1FGRjAgfCBSSVMyX1FGRjEgfCBSSVMyX1JGRkYgfCBSSVMyX1JFU0VSVkVEKSwNCj4gDQo+ICAg
IE1pZ2h0IGFzIHdlbGwgZml4IHRoZSBRRkYxIGNvbW1lbnQgaW5kZW50YXRpb24gYmVsb3cuLi4N
Cg0KT0ssIEkgd2lsbCBhbHNvIGZpeCBpdC4NCg0KQmVzdCByZWdhcmRzLA0KWW9zaGloaXJvIFNo
aW1vZGENCg0K
