Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246E16E5E42
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjDRKJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjDRKJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:09:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2108.outbound.protection.outlook.com [40.107.22.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6267244AE;
        Tue, 18 Apr 2023 03:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1APdoQ3DIfS9Zswm/J67a8F+v59/3nBMsuUB/wwtBFxPQFkmxKYHFvHX64Jgy+0ThYCpOqO6VqY0xm6wf9/5CgLB3HBHmK+vol/gX9XKuhQYVHnet/KVfyWPLqjJ2ULgBShsJrH0AJ+EizIA5TcbbaCCN0gxzrgcPycGY7cDhhjnTU7FwrbV62fkUP5JGDkZAAs1HrxNEKZMOZxCT8q/8BQ3beS1YblMapEykm+YryYjaCdJu9tORmFcli0k1QCzs4YxdKYzcucM+xOcxj/X/5gnJG15Cqqca6FoMZjtjN9d7A8udYLzXQLx6ksWHC5RnINRdHR43dGyUz8TA6Ldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRVUmf2C2kJr9Uxx7GyJtPXZe1UfaNDMDcMlibXdwMY=;
 b=QsYKe5t8EeKkKocPEn38sT3ZR/Zq9xDYjfnnUwuTjxu3hbgBTVXuu/Tk5UEYHgNdPF4KBwhTLFXcR3Lk1SnjrM5XnGSfOHQ2vUW6sb/YxzHBhXp4kmFYkX0UqvpU8raLUexZd/U+o64LrYAtSi4n2aHbKKWGI6P8iLKTxiu5O4oXKYh8YJ/bAdHxOxnXxzTKfmkAdwAznoXRkoXKBKJtohNzYhai0K3T5AT3FjEEF4xdRyl6H8aCseB3genahKqNORg/7R/YSmVGGIY0BETBDM1svAYcyJUbunCc/YSRajg2/oEpquvqli9SbvqM1T76nMs+l4yz7gETruMYIIjoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRVUmf2C2kJr9Uxx7GyJtPXZe1UfaNDMDcMlibXdwMY=;
 b=LgUgK1VF6LAHCokDyHhsfHYVg3xtwzf/LB/8qxWtbuTC6hRy6xd3HEPjR1PH6PR+D4NuW/EHKFnsYz3dFnbrFgf/lpZchFElZMznZKt0XGjdgogaliYDQ//KyL30Yc04Gx/+6k3YJK9Ahhnc64T076QO8AQS2ElP74HdHS0sVLE=
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:26::11) by DB9PR01MB7211.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:21c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 10:09:16 +0000
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e]) by
 AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 10:09:15 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2 2/3] net: mvpp2: tai: add extts support
Thread-Topic: [PATCH v2 2/3] net: mvpp2: tai: add extts support
Thread-Index: AQHZcU8sy0bTBF0uGE6ydQzhQ1aqUq8w0D+AgAAIygA=
Date:   Tue, 18 Apr 2023 10:09:15 +0000
Message-ID: <ddbc260a41cb8203fcc1e9348557c7c35af01ee1.camel@siklu.com>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
         <20230417170741.1714310-3-shmuel.h@siklu.com>
         <20230418093747.jxxvoizofd6cgk6v@soft-dev3-1>
In-Reply-To: <20230418093747.jxxvoizofd6cgk6v@soft-dev3-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR0102MB3106:EE_|DB9PR01MB7211:EE_
x-ms-office365-filtering-correlation-id: cd88e59d-4193-4df6-3b14-08db3ff4f75e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gzQNgJD9ZGUpdVaPFuXWUiQhNzxt7MEnqbmral0vJrmZeU5xkn69diQ96lnTdNspEuN319x8iuEkObXEhagUbqTe5AmuyUyCVUT9NkJjzR/uKzJWqLRgadDKdkD4hRBpAJiRplTTwvezzbbhwBBpAQ/T3TysAacnzi35zkLlSJsEPlSyDG7NhGJoXedEJBjbRB48gXUG0Re1BTe5WcIpu0Q5HU9JXy1sb/wL4mY2HxfJP4SIwvJZRTXKVqATFgsemukYoQcn/5Xv92IMVnZmwIha6pu0ytWQR6JRnbBBjZPycC2SKO3iubqRe+wBcbbVFNsxfWTMRr7xu7tA05ZqI+MuXXL5jCXlHHODslTH5fKxlAmYQ9GPAEc97ONsDuMzyGO5yV4DC2u2qdqnQ2s5GHPZyIyudFxNAnBK3jzTysxaQ88bzTu7Aa3WPp2iZUAA+zCgCyRWwawjf+MtXFvhrsigthrs34FAVkdcvb6pFFBLwZCXInRd1PrXyqopQ7mdAGunxWFbrEdiNHsuENoCSbgL6aOjN9tf3cAQjLjeb6eG7eU8UN8fKHBopjJUR2WJBQUxr2Aa51oFj38wvC80rI08qmKgOUlihQXKTp6b++6oTAOf1bh355tbVFLL9nd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0102MB3106.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39850400004)(396003)(376002)(136003)(346002)(451199021)(54906003)(71200400001)(478600001)(6486002)(83380400001)(316002)(91956017)(41300700001)(6916009)(64756008)(4326008)(66556008)(2616005)(186003)(66446008)(6506007)(26005)(6512007)(76116006)(66476007)(66946007)(5660300002)(7416002)(2906002)(8936002)(38100700002)(8676002)(38070700005)(122000001)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z096V3ZaNWxXVGZvUThTNUY4NEJwaEJ0a0ZnaG1IWUV1c3RBblN3MytkUmxF?=
 =?utf-8?B?a01pSk9tVHJRcmplLzBCU2Q0dWZ3M1N0Nngra0ExRk9kZHJjZ3RSWlE5V3JC?=
 =?utf-8?B?Tk1EN3lCZ2hOblRsNFdjZ3ViUEZ4UjJDdTNoK3NDVHU1Mm51MVlTdTl2RWUr?=
 =?utf-8?B?bHBOa0dNWGNrRnVNWk1mUmVyYkNyTlF2Tk5nTWZTZXpTb3VmRWRucU94cGxn?=
 =?utf-8?B?dHlSeWU5MDFQRmtZdngrVFp1QVA0TGQ5dU94Q0JFZGtwdzQ2Y2UxRWZVdEpl?=
 =?utf-8?B?VFRPOEp3N0ErZ3ZoRnZKeTJPWXJWTjBYTTExbk1sSXVmZEVQcnpKeWdMZG14?=
 =?utf-8?B?dlkyWUswd3pscU91VUpVelZjTk8rcUxnM3hHTnVVTlI1a3NaZk5xTWV1aGdE?=
 =?utf-8?B?YkpaS0NkSXFzajRLV1VveHRTb3F4VWFRSnB0U3YwYlRHamx4TUdoZTdaSXZl?=
 =?utf-8?B?Q3VTeGhaMlRyMWxlZEQ1VkwwT2hnUnp2ZldFQmxCV3lVQ1FYTjU4R241QW55?=
 =?utf-8?B?NkVXTUlWYTFaWUdibTZveXFUQ1A0cFlLL2RGamVMMUdzZkZpYkJRTUNCQ294?=
 =?utf-8?B?RXoyRWYxSG53aXBCKzJETkg0Qm1kVjFwMzJUbHIydWZaSkpFekFpMzJsY1JG?=
 =?utf-8?B?cy9RZHdSWGFvNWc1TFp0aVZZOE1WdHoyMTdXN1FreXhZWVFXS0RqLzlKUnNn?=
 =?utf-8?B?Sjl4WXpaVDZiamRpQ0tyaStOcWF3ZW9rSVhtWVFpeElJZjBWQlZWMU1JRmk0?=
 =?utf-8?B?S0ZYdGV4Yk9aLzB2Ri9vaXhTaUUwYThDQ0pEY3UvK2xFQnJlN1Y0VVVOZjdI?=
 =?utf-8?B?MWJ1a0NXSm9DYWViekhDejVDbkd3dE1lM1J5RDdkQzVXcjI4ZmZJQU90R3VE?=
 =?utf-8?B?cXFHSE1YZUc0WjBrakM5SVVnQk5rd0NqbnRLWUNQdWJSc1ZETXIzRHJqL0M5?=
 =?utf-8?B?N0pPVWs0bWJLbTRZY0Fhc09FQ1hqSHBCWXpNME00T1RQVDBGam43ZWFka0Zr?=
 =?utf-8?B?cWNLZWlQemRMNitSVmFhUlFnWnBRV2tXK0VFZ25RZkozaDErOS9tbHdUVnhS?=
 =?utf-8?B?MUZ0Q2FKRmJOUzIyd3ZMdllUcmVzU2NnMDk3N3FKay8wWGlBeW1HK016Y2M1?=
 =?utf-8?B?a2I3aktUUGdjVUR1RUdqelN3Y2NlS1hkR2dKLzRxdHNyZUwzc0pWc2dPNmRY?=
 =?utf-8?B?Ky9LV3ZmMEFsRG8yY2NvOXdJTjljckF1bGt1dTFZVzZHem5lVUlLMWtpclJQ?=
 =?utf-8?B?Z1VvVHZEemNGc0xSMEFYTzdkOThPcXpLRHNzM3BWQ1pMV0NoczBMRlZMQVQv?=
 =?utf-8?B?NnJwOWphWnR1aW1RWk5WZlVrRGlycXFPQVZ5YjF6K05YZmw1NGVkV0Y2Y2Fz?=
 =?utf-8?B?eExZMDN4ajc3N2xqdnBoZmUrNVNKTnRlZmVDaVZySExpYSt6a3FNY2ZZZFI1?=
 =?utf-8?B?QWx1WENmeXBwSDM4c0F4K1VZQjNKNUgwd2E2Vm5OZWNrNmVXRmZadDl1Vkg3?=
 =?utf-8?B?Q0NUdnBacmt3QlZUQis4aW9UNXlBTGRyRkJVRFJsUS9STmdLSE5WUHVEdjNY?=
 =?utf-8?B?aW1uaDJtZjF6Nys1ZEQxRldET28vNUlzd1FXRWtZQ3ovME91ampUR2FONXlE?=
 =?utf-8?B?ZEw4NVdZYVlVZkVWbFgzTjVQVHRaNFJuZjlKWkJuTTRXZGJReW5LSDhvMHpu?=
 =?utf-8?B?YzY0Mzhjc0Z3bVhmK0pXbDBrSVIyNlI3K3VtUlRKTDRacEtVWmpraUxHUFM2?=
 =?utf-8?B?ZnZFSndkV2FvNXhPTmNFRkFLVG9vb0tPT0tGN2s1UVk4R0pxam9ISkE3bHAy?=
 =?utf-8?B?bGFVTFo4dk9uQmtmWlJ4cUJ3ODg1NmZnc0RJT3R0cG1zV1IvN25iRXl6ZmRT?=
 =?utf-8?B?WDVVSFg5SE0wMVMxdU1uMVFVRGpYM21aKzNuRUx0ZFRWT0Y5OUVUZzJtcUJH?=
 =?utf-8?B?UldkbzlubGswaUlyK3BQVnBrUWhLekxrTSsvM2krejJ4THRyaHUwZmluRURn?=
 =?utf-8?B?ZmZsNFBXMGRmS0hSWEw0THF1WS9MV2oxMlJPbGV2M2RyRUJEbGhhVnNxSnBl?=
 =?utf-8?B?bWIwVkxGb24rSjlOQk8yUGRudWNiTEFCY1NORm5haENpdWNBVnVvY0dIYURu?=
 =?utf-8?Q?aoEzlYvFddmB7kUFjS46f35Fb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24F837946AC6FC4D86E45C883BF0131A@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd88e59d-4193-4df6-3b14-08db3ff4f75e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 10:09:15.7273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H4mjIUrJ16Tbo7pGZOuLA7qWvT0bHRB4TxPAN3Sc5ipG7D0whmxAqmkVFoupb9z5SrQtnwJN+jhUhw151OIFGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR01MB7211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTE4IGF0IDExOjM3ICswMjAwLCBIb3JhdGl1IFZ1bHR1ciB3cm90ZToN
Cj4gDQo+IFRoZSAwNC8xNy8yMDIzIDIwOjA3LCBTaG11ZWwgSGF6YW4gd3JvdGU6DQo+ID4gDQo+
ID4gVGhpcyBjb21taXQgYWRkIHN1cHBvcnQgZm9yIGNhcHR1cmluZyBhIHRpbWVzdGFtcCBpbiB3
aGljaCB0aGUgUFRQX1BVTFNFDQo+ID4gcGluLCByZWNlaXZlZCBhIHNpZ25hbC4NCj4gPiANCj4g
PiBUaGlzIGZlYXR1cmUgaXMgbmVlZGVkIGluIG9yZGVyIHRvIHN5bmNocm9uaXplIG11bHRpcGxl
IGNsb2NrcyBpbiB0aGUNCj4gPiBzYW1lIGJvYXJkLCB1c2luZyB0b29scyBsaWtlIHRzMnBoYyBm
cm9tIHRoZSBsaW51eHB0cCBwcm9qZWN0Lg0KPiA+IA0KPiA+IE9uIHRoZSBBcm1hZGEgODA0MCwg
dGhpcyBpcyB0aGUgb25seSB3YXkgdG8gZG8gc28gYXMgYSByZXN1bHQgb2YNCj4gPiBtdWx0aXBs
ZSBlcmF0dGFzIHdpdGggdGhlIFBUUF9QVUxTRV9JTiBpbnRlcmZhY2UgdGhhdCB3YXMgZGVzaWdu
ZWQgdG8NCj4gPiBzeW5jaHJvbml6ZSB0aGUgVEFJIG9uIGFuIGV4dGVybmFsIFBQUyBzaWduYWwg
KHRoZSBlcnJhdHRhcyBhcmUNCj4gPiBGRS02ODU2Mjc2LCBGRS03MzgyMTYwIGZyb20gZG9jdW1l
bnQgTVYtUzUwMTM4OC0wMCkuDQo+ID4gDQo+ID4gVGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGEgcGlu
Y3RybCBjb25maWd1cmF0aW9uICJleHR0cyIgdGhhdCB3aWxsIGJlDQo+ID4gc2VsZWN0ZWQgb25j
ZSB0aGUgdXNlciBoYWQgZW5hYmxlZCBleHR0cywgYW5kIHRoZW4gd2lsbCBiZSByZXR1cm5lZCBi
YWNrDQo+ID4gdG8gdGhlICJkZWZhdWx0IiBwaW5jdHJsIGNvbmZpZyBvbmNlIGl0IGhhcyBiZWVu
IGRpc2FibGVkLiBBZGRpdGlvbmFsbHkNCj4gPiB0aGVzZSBjb25maWd1cmF0aW9ucyB3aWxsIGJl
IGFsc28gdXNlZCBpbiBhbnkgY2FzZSB0aGF0IHRoZSB1c2VyIGFza3MgdXMNCj4gPiB0byBwZXJm
b3JtIGFueSBhY3Rpb24gdGhhdCBpbnZvbHZlcyAidHJpZ2dlcmVyaW5nIiB0aGUgVEFJIHN1YnN5
c3RlbSwgaW4NCj4gPiBvcmRlciB0byBhdm9pZCBhIGNhc2Ugd2hlcmUgdGhlIGV4dGVybmFsIHRy
aWdnZXIgd291bGQgdHJpZ2dlciB3aXRoIHRoZQ0KPiA+IHdyb25nIGFjdGlvbi4NCj4gPiANCj4g
PiBUaGlzIHBpbmN0cmwgbWVzcyBpcyBuZWVkZWQgZHVlIHRvIHRoZSBmYWN0IHRoYXQgdGhlcmUg
aXMgbm8gd2F5IGZvciB1cw0KPiA+IHRvIGRpc3Rpbmd1aXNoIGJldHdlZSBhbiBleHRlcm5hbCB0
cmlnZ2VyIChlLmcuIGZyb20gdGhlIFBUUF9QVUxTRV9JTg0KPiA+IHBpbikgb3IgYW4gaW50ZXJu
YWwgb25lLCB0cmlnZ2VyZWQgYnkgdGhlIHJlZ2lzdGVycy4NCj4gPiANCj4gPiBUaGlzIGZlYXR1
cmUgaGFzIGJlZW4gdGVzdGVkIG9uIGFuIEFyYW1kYQ0KPiA+IDgwNDAgYmFzZWQgYm9hcmQsIHdp
dGggbGludXhwdHAgMy4xLjEncyB0czJwaGMuDQo+IA0KPiBJdCBsb29rcyBnb29kIHRvIG1lLCBq
dXN0IG9uZSBtb3JlIHF1ZXN0aW9ucyBiZWxsb3cuDQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1
bHR1ciA8aG9yYXRpdS52dWx0dXJAbWljcm9jaGlwLmNvbT4NCj4gDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogU2htdWVsIEhhemFuIDxzaG11ZWwuaEBzaWtsdS5jb20+DQo+ID4gLS0tDQo+ID4g
IC4uLi9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl90YWkuYyAgICB8IDMwNCArKysr
KysrKysrKysrKysrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDI3MyBpbnNlcnRpb25zKCspLCAz
MSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWFydmVsbC9tdnBwMi9tdnBwMl90YWkuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZl
bGwvbXZwcDIvbXZwcDJfdGFpLmMNCj4gPiBpbmRleCAyZTNkNDNiMWJhYzEuLmZmNTcwNzVjNmVi
YyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212cHAyL212
cHAyX3RhaS5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9t
dnBwMl90YWkuYw0KPiA+IEBAIC0zLDggKzMsMTEgQEANCj4gPiAgICogTWFydmVsbCBQUDIuMiBU
QUkgc3VwcG9ydA0KPiA+ICAgKg0KPiA+ICAgKiBOb3RlOg0KPiA+IC0gKiAgIERvIE5PVCB1c2Ug
dGhlIGV2ZW50IGNhcHR1cmUgc3VwcG9ydC4NCj4gPiAtICogICBEbyBOb3QgZXZlbiBzZXQgdGhl
IE1QUCBtdXhlcyB0byBhbGxvdyBQVFBfRVZFTlRfUkVRIHRvIGJlIHVzZWQuDQo+ID4gKyAqICAg
SW4gb3JkZXIgdG8gdXNlIHRoZSBldmVudCBjYXB0dXJlIHN1cHBvcnQsIHBsZWFzZSBzZWUgdGhl
IGV4YW1wbGUNCj4gPiArICogICBpbiBtYXJ2ZWxsLHBwMi55YW1sLg0KPiA+ICsgKiAgIERvIG5v
dCBtYW51YWxseSAoZS5nLiB3aXRob3V0IHBpbmN0cmwtMSwgYXMgZGVzY3JpYmVkIGluDQo+ID4g
KyAqICAgbWFydmVsbCxwcDIueWFtbCkgc2V0IHRoZSBNUFAgbXV4ZXMgdG8gYWxsb3cgUFRQX0VW
RU5UX1JFUSB0byBiZQ0KPiA+ICsgKiAgIHVzZWQuDQo+ID4gICAqICAgSXQgd2lsbCBkaXNydXB0
IHRoZSBvcGVyYXRpb24gb2YgdGhpcyBkcml2ZXIsIGFuZCB0aGVyZSBpcyBub3RoaW5nDQo+ID4g
ICAqICAgdGhhdCB0aGlzIGRyaXZlciBjYW4gZG8gdG8gcHJldmVudCB0aGF0LiAgRXZlbiB1c2lu
ZyBQVFBfRVZFTlRfUkVRDQo+ID4gICAqICAgYXMgYW4gb3V0cHV0IHdpbGwgYmUgc2VlbiBhcyBh
IHRyaWdnZXIgaW5wdXQsIHdoaWNoIGNhbid0IGJlIG1hc2tlZC4NCj4gPiBAQCAtMzMsNiArMzYs
OCBAQA0KPiA+ICAgKiBDb25zZXF1ZW50bHksIHdlIHN1cHBvcnQgbm9uZSBvZiB0aGVzZS4NCj4g
PiAgICovDQo+ID4gICNpbmNsdWRlIDxsaW51eC9pby5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgv
cGluY3RybC9jb25zdW1lci5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvcHRwX2Nsb2NrLmg+DQo+
ID4gICNpbmNsdWRlIDxsaW51eC9wdHBfY2xvY2tfa2VybmVsLmg+DQo+ID4gICNpbmNsdWRlIDxs
aW51eC9zbGFiLmg+DQo+ID4gDQo+ID4gQEAgLTUzLDYgKzU4LDEwIEBADQo+ID4gICNkZWZpbmUg
VENTUl9DQVBUVVJFXzFfVkFMSUQgICAgICAgICAgIEJJVCgxKQ0KPiA+ICAjZGVmaW5lIFRDU1Jf
Q0FQVFVSRV8wX1ZBTElEICAgICAgICAgICBCSVQoMCkNCj4gPiANCj4gPiArI2RlZmluZSBNVlBQ
Ml9QSU5DVFJMX0VYVFRTX1NUQVRFICAgICAgICAgICAgICAiZXh0dHMiDQo+ID4gKyNkZWZpbmUg
TUFYX1BJTlMgMQ0KPiA+ICsjZGVmaW5lIEVYVFRTX1BFUklPRF9NUyA5NQ0KPiANCj4gSG93IGhh
dmUgeW91IGNvbWUgd2l0aCB0aGlzIDk1IHZhbHVlPw0KDQpIaSBIb3JhdGl1LA0KDQpUaGFua3Mg
Zm9yIHlvdXIgcmV2aWV3LsKgDQoNCkFzIGZvciB0aGUgOTUgdmFsdWUsIEkganVzdCBib3Jyb3dl
ZCBpdCBmcm9tIGEgc2ltaWxhciBkcml2ZXINCihwdHBfY2xvY2ttYXRyaXgpIHRoYXQgYWxzbyBl
bXBsb3lzIGEgc2ltaWxhciBwb2xsaW5nIG1lY2hhbmlzbSBmb3INCmV4dHRzIHN1cHBvcnQuIEl0
IHNlZW1zIHRvIHdvcmsgcHJldHR5IHdlbGwgaW4gdGVzdGluZyBzbyBJIGhhZCBubw0KcmVhc29u
IHRvIGNoYW5nZSBpdC4NCg0KPiANCj4gPiA8c25pcD4NCj4gLS0NCj4gL0hvcmF0aXUNCg0K
