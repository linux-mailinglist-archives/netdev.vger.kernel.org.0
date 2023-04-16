Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252986E39CA
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjDPP0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 11:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjDPP0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 11:26:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2100.outbound.protection.outlook.com [40.107.8.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC082710
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 08:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbdxN1zEm51fh9I4KxjTdQtmi03VBjorckU/smY3k8b46zYkG+SOBDA9JGmlPwmHYE/FwlvMX3KAK82nxKmr3dRA/1jJY7U3EP547xB9qba0yrRHV3wyHJbmT2Y+aVfctJZchmNv/7UxIJXSD4fu68f6Z1uI7aIWHPiXX3dL7678bgNVgdctjG+tTXNFYTArAW9l3ePz06TiEOnhDLY6Urd3t4safNGVzaRU8Gvion4OEhu7yvQGkwi9o99fNcN9NDRnIOLhiDpXHNAU4Z0xSx7oGE77ptceBA9K1BjLLn2waO7x6ym6pvt69WFoiita/pRM0kRhCcAotO91WCoFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcYsEowBN6+swNzvIVLmkFCNxJWQRgNjy0Q1p0lV71A=;
 b=KmlwokA7n47wG7fnNowj5b/vAbriPQNHgRjmCU/YbuOL+vitWbRBJh7x8MJCNtfAz6lXC/S/oQFgx57URP/UW4yx5ayoyHag5Robm92YfmgD4DYXP/kNI+5d3+UzPfjgjqxa7Nkb2MdPVvTE2cheAovAA7uRnuGbnrR04qsfmQBPHdtfUmkbItEtV9rYTZ6Aa6z/2UUY5AEVe4VSA/eRXOAW0DXavFefzUgH4hPpxZvSDEs4Dh8dqb6h6YO4ksfLzSGRYGMgh8ZN6N2fZDXYFdHzer13t9MIQBhNzixDKugJ7vUxzC30w4n/UUmJR2exc3zBFKT7KfQd5OXfD8KgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcYsEowBN6+swNzvIVLmkFCNxJWQRgNjy0Q1p0lV71A=;
 b=Okm4Yugb64jXjIR18KAWKJPL3/WF5uzNZ17G8emIV3FvZmGIUD+1UbFOqc+09UGeUgYD4wn99fHqfg8UZ5z1NH0QvbuovK++Pca3r+H+a4Vi2qHVeICnfxw8sBWxxx5jRHeg26WIcdeagjVvpOnWlxEP4NiQbp5nvtxl0uxTS8s=
Received: from VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:5::17) by DU0PR01MB10115.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:319::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Sun, 16 Apr
 2023 15:25:56 +0000
Received: from VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
 ([fe80::a0b2:d7a9:4f7:4a70]) by
 VI1PR0102MB3117.eurprd01.prod.exchangelabs.com ([fe80::a0b2:d7a9:4f7:4a70%5])
 with mapi id 15.20.6298.030; Sun, 16 Apr 2023 15:25:56 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Thread-Topic: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Thread-Index: AQHZcG/3jS6cFCsc+UuSyaDRz1oYQq8uBT4AgAAJTQA=
Date:   Sun, 16 Apr 2023 15:25:55 +0000
Message-ID: <43513e82fcdf84ce363abe31d6998b4f40aaa49f.camel@siklu.com>
References: <6806f01c8a6281a15495f5ead08c8b4403b1a581.camel@siklu.com>
         <69b2616d-dfeb-4e06-8f9b-60ced06cca00@lunn.ch>
In-Reply-To: <69b2616d-dfeb-4e06-8f9b-60ced06cca00@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR0102MB3117:EE_|DU0PR01MB10115:EE_
x-ms-office365-filtering-correlation-id: dfdb2a89-d8db-451e-6727-08db3e8edf71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ewCmJEFv+tS9H3AdlDicx9wWNOqRU07L1jJpJ4/yx9UB2btD5L1UNhavteNfsY1fxgOV5IbJ6JxfCBclD7PolMfRMcagTd8GtCD3ZV/mBI324y8AGayEQMxCSBxCje3QvwcwQNw1Kq/U/jal1Ytx6aL+gz8G3hWlrds+Ornpwgu93wes4VlVnCNKnlvyMegh9XBvje5mq+XEjlvbbrRK9hP5euk//HFVbKXWnM3Zr3SvynLPzY9/+YlGNGw6OqRPTu9hgHK6xYQEHES8Dc/ph4uYmMQYNf/a8y9MRyS/2VRf0E782TuPuI/9AgtIiPna8KoLv3Ome3IUkYaovrCqvSOYsEI/VKYA796OcL0UkxCAteXHW/+AdZeNJsE5m6uzqr5N+hcmK2NhduszWegADUk1Qyt3/hOKN/BfRpgacbtRMa/H5IQkoHO7bbmVPwlNF5/ZMrIrS5gtembFdeOe2VE28SS8lSFZbXioJ9Y6+as8Yft72l92COxsSj/vzBtRP/SxkPIPq6OD1iRlRa+sVQfmMdFe9YSE/5U+FwseT9hPbTiDwlJCF9Ws3mq0+uiHzIPcl028la/8FvBWjSpei4fugRjDPlJH7KLjZTGsCTZT6KLO/36+tKV1MR3Atn35
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3117.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(376002)(346002)(136003)(451199021)(86362001)(4326008)(6916009)(66446008)(66946007)(64756008)(66556008)(8676002)(66476007)(6486002)(316002)(71200400001)(76116006)(41300700001)(36756003)(478600001)(54906003)(6512007)(2616005)(6506007)(26005)(83380400001)(38070700005)(38100700002)(8936002)(186003)(122000001)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFU2bkQzOTd4SG40NXBSbm42UmZUVkNiWnlVeU5IQ0FkM3B5NU1MZ05XWDRh?=
 =?utf-8?B?VDIzSzJnWnNZZEpycUtxcDFHakxrRkZ3eWxyZDY4QjBSdWVCSHhxNU9wTkVz?=
 =?utf-8?B?RzF6UGhKdmMvUDZyRWI0QjlJZ01FY29UUk5kWVBLQXA5MmZpUktSa2h5UG8v?=
 =?utf-8?B?THU2UUoxeDFFUHlhYWYrcmRKbHVMRHVuVmVVdHNLZFB2ZjVIRS8wVHF6dTc2?=
 =?utf-8?B?R3RUa1hLYTZxdFpkUTVuWlBpTjRkVkxad1pPRDQrU2FhSlJqK3E0OFptQ0xH?=
 =?utf-8?B?czhBQjBnTkE5cmVkRnJpeDhDZEVTOHlKcXQydFVxc0dFbi9VZytOQkNuR3Nl?=
 =?utf-8?B?VzVPQzVTNHdYQWRaYzg0UGR1U2FnZkc0YmdkM0ZjbFkxU1FoblN5VUx1Vmpo?=
 =?utf-8?B?Q0ZRSU1wZ1RhRll0MS9FS0hGWkVsd29hNWlFallnaTh4Skc0cDNtMGY5QmpQ?=
 =?utf-8?B?Ykk3dVU4UXpKaFVGemFaMms2bTZPbkFnR1d0RzlnMVBDSE0wZkIrZlNRMXo2?=
 =?utf-8?B?azU5eTZ1dGNWd3JPOWJwVFZkT2R0NnlTUmloT2xXcDZPNEJnK2lKbVFDTzdk?=
 =?utf-8?B?Y2ptM0k5NGhUT1EydStCTmsxSEdXa0FLbmRuT29TNnRQUHhzbER2QzBoVmRP?=
 =?utf-8?B?WVoyd3B5L251Q29LTEY4LythalVxYkxjVjZMZ2hoN2pDQTlMQnFjdGhtcTdP?=
 =?utf-8?B?Vms0YW5CcUVmU0c4YlliZW8yYzR4STQ1WHJBZnNNZS82Qk9kY0R3L2kza1Ro?=
 =?utf-8?B?UXIydWFRdU1uNGpOLzhuMDdKT2hCNjYxM2FTRkMwVmc2d3hPS0U1ZGdrd0w2?=
 =?utf-8?B?Z3REaDlxN2Q5OHVPY2ZJRFFDY3U4UkIwU1FkYTBtVS9LSzBSTEQ1cnFFcnZR?=
 =?utf-8?B?QTBUNFBzajRrMlF6Y2JSd0NQY2dhNFpyZkgxMzJ3cWtlMmIra3hvS2FuSjYy?=
 =?utf-8?B?VGl4aGlIeHRNd0JlMG9oRTloZTNLajVrdUxoWVp1RHE2cU85dHhxN2x0VGNR?=
 =?utf-8?B?WG9YUUV2R0FDa1U3VUFoSXZjRDJjYWRKRjhkeSt3UlZNZzBMMzFiSTZ2TUlU?=
 =?utf-8?B?VTEyZ0M1TEhac0YxS3dUTmhGaWtmK3hjMVBjazE1Qm5yRTJRdWZsQTFGdC9Q?=
 =?utf-8?B?WUVtU254d0k4MVcvRVRDNXE0d040cmVRYURGWWtSSDROUnlERE0yVSs1UzJ2?=
 =?utf-8?B?eUo0TU13dStOaERZejRYNmxwNkZqQ0EvcWZCVnZRU0toTWsrU3ZXQUdxQzBv?=
 =?utf-8?B?WDV3YXNBK3RUbHJrenVucWR6bnE1Z1lETDhSanp1bXlOYktlaTY2NFR0d1M1?=
 =?utf-8?B?U29JRENHNUpLQWluOEw5ZjkrazdydVJGd0VJZ2NCWkxJOE9rZ29ZVkZkaGlW?=
 =?utf-8?B?eUl0VHlKei9jR3RBdmx5ckFQUFJrV285UDZiMTlHZS8wUlhVVmpoVC9HeWtD?=
 =?utf-8?B?dmdWcmpkZ3VaZW94bmZMeFFRQWhYQ0N1a0VCZVNUWGZjWTcrdGxSUWtXQ2Rq?=
 =?utf-8?B?MWlGZUNXVGlHS1RWZ2h5eWZkS2tXOGoycnZhWm1DNFh3MGlZU0g0WVNlZ2V0?=
 =?utf-8?B?dWNPdTBzL0liZUs0UmdqaTdxdU9va2FWQmVhL1UyT1JNU2gwL1R6WlNJYzg0?=
 =?utf-8?B?d0VIb1ZqTnRkNVd4TGlFK0FsRUlVWVBXeFdpMzUrL0ptczFPUDRNZjdWQmRD?=
 =?utf-8?B?NVo3Q3JJMkhTM01pcHRqYXBuZW0zY2dQNWsxV2VJSm9kMHZBNTMra2R1UzJy?=
 =?utf-8?B?dVdQN1U4bUlVbUhzaks1NUZWMUtpb0RIY0czSnRFQjVqRFhKaWNmamtOTmFN?=
 =?utf-8?B?OVBQTWdGdDZ0WUR4WDFFUXIyb0tHblZoQXgwWk1OVnVMUGpyYmQxSVA1dTQ2?=
 =?utf-8?B?SElaRGhuMDYvNDNMVkhTbExsWXJkSmMyUDVFeHp1V2lCbzkyRkZXNEtIaXFS?=
 =?utf-8?B?S05HMzlVTTZ4TjB5MHVTS0RuMW96bStaZk5pOU5lLzg1enBjVENpT0l5cmRS?=
 =?utf-8?B?elF4eUgySzhDMVR3eDNsTmhCdE5EUzFCa2tiKzhMMkdvbENUQ0tEejJPWXdO?=
 =?utf-8?B?MGNmSG5JSzVLTWhKQzAxS0RBRWo5R1krbkZ4dk9mYVVmRTN1ZmtWeDVVRWV1?=
 =?utf-8?Q?lYNZto+77IFpMl/PxeyCTAHUr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <837B24F3092F364383EF5979EF6E8765@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3117.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfdb2a89-d8db-451e-6727-08db3e8edf71
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2023 15:25:55.7866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XAXd8doOu8NS3IvL6VI+CuNT7e4KwP68crujVuWgnzC5bRqJGb1DljgGaiaFPC9fIr2oozI/J06pN4iysSXkdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR01MB10115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIzLTA0LTE2IGF0IDE2OjUyICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZw
cDJfdGFpLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZwcDIvbXZwcDJf
dGFpLmMNCj4gPiBpbmRleCA5NTg2MmFmZjQ5ZjEuLjFiNTc1NzNkZDg2NiAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212cHAyL212cHAyX3RhaS5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl90YWkuYw0KPiA+
IEBAIC02MSw2ICs2MSw3IEBAIHN0cnVjdCBtdnBwMl90YWkgew0KPiA+ICAgICAgIHU2NCBwZXJp
b2Q7ICAgICAgICAgICAgIC8vIG5hbm9zZWNvbmQgcGVyaW9kIGluIDMyLjMyIGZpeGVkDQo+ID4g
cG9pbnQNCj4gPiAgICAgICAvKiBUaGlzIHRpbWVzdGFtcCBpcyB1cGRhdGVkIGV2ZXJ5IHR3byBz
ZWNvbmRzICovDQo+ID4gICAgICAgc3RydWN0IHRpbWVzcGVjNjQgc3RhbXA7DQo+ID4gKyAgICAg
dTE2IHBvbGxfd29ya2VyX3JlZmNvdW50Ow0KPiANCj4gV2hhdCBsb2NrIGlzIHByb3RlY3Rpbmcg
dGhpcz8gSXQgd291bGQgYmUgbmljZSB0byBjb21tZW50IGluIHRoZQ0KPiBjb21taXQgbWVzc2Fn
ZSB3aHkgaXQgaXMgc2FmZSB0byB1c2UgYSBzaW1wbGUgdTE2Lg0KDQpIaSBBbmRyZXcsIA0KDQp0
aGFua3MgZm9yIHlvdXIgcmVzcG9uc2UuIEluIHRoZW9yeSwgdGhlIG9ubHkgY29kZSBwYXRoDQp0
byB0aGVzZSBmdW5jdGlvbnMgKG12cHAyMl90YWlfc3RhcnQgYW5kIG12cHAyMl90YWlfc3RvcCkN
CmlzIGlvY3RsIChtdnBwMl9pb2N0bCAtPiBtdnBwMl9zZXRfdHNfY29uZmlnKSB3aGljaCBzaG91
bGQgbG9jaw0KcnRubC4gSG93ZXZlciwgDQpJdCB3b3VsZCBwcm9iYWJseSBiZSBhIGdvb2QgaWRl
YSB0byBhbHNvIGxvY2sgbXZwcDJfdGFpLT5sb2NrIHRvby4NCg0KQXMgZm9yIHRoZSBpbnRlZ2Vy
IHNpemUsIGl0IHdpbGwgYmUgaW5jcmVhc2VkIG9uY2UgcGVyIGV0aGVybmV0IGRldmljZQ0Kb24g
dGhhdCBDUCwgd2hpY2ggY3VycmVudGx5IGhhcyBvbmx5IG1heGltdW0gb2YgMyBldGhlcm5ldCBw
b3J0cy4gSQ0KZ2F2ZSBpdCB1MTYganVzdCB0byBiZSBmdXR1cmVwcm9vZi4gSG93ZXZlciwgSSBj
YW4gY2hhbmdlIGl0IHRvIGEgbW9yZQ0KYXBwcm9wcmlhdGUgdHlwZSBpZiBpdCBsb29rcyBtb3Jl
IGFwcHJvcHJpYXRlIHRvIHlvdS4gDQoNCj4gDQo+ICAgICAgICBBbmRyZXcNCg0K
