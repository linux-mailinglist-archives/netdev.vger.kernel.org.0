Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484736D7883
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbjDEJhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbjDEJhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:37:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65AB5B8B
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:36:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeltRBBNkn9c9rHpzhxFod4aJW09syuek/cQTnGxePpDzRr5j6pynNz5sRYIR2M8s2laFDahEIH5Swafpy25pMwcfMe9syjQR3hx5s3gxE1EgXpEAOsiS9mqlGlXupOIagK1Mh0m54Pb6AsvvCO2YH/1xEwfgpWAY3PaO26ifQmkdmA9TvHGYj66TBuVqNfRYphgDemag+0MtKa2D7i44jc9Ldgy56uctlF06Xy55PWTtv2ienYKDyja5Evw00F7rV9HPy135GE5OYvOhKAjMvGMl3h+lemhVXKk4ki0O+dxvUjyJpxnvowdTLbSOzqzcbDV5Z3RCbYxxSwkXBd4Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPzIpzBjt+bnfFKzYsfZW2fNUNQW5nC4yWhuoMb2Wvc=;
 b=fG+tLk2hHwBIySTW3eef0EIlzqkcV1w5f/TjabfSMCTfJIIxXvFW/QprXxGOGhC71WIozow0Z5rasnJQngWFVfYEGS3zGAh83/9ceXfvzEjTTBs2O3W7bD/cYrpr7G2O/YOcHSFB69Hg82vP+Rj6XabrlcsNjr3I0l3Fv/LzRBnt/Y+VRcqMvHMUJk4kHjSUP2hqZGlZ+9PxBNqh6Ul/Z1F8CSY2p79L7fDaqwzlFLE28xjVOC/FWliJr07Xp4rS8nv1Zgp2oxORatJoYCqo78aVNaGv9PMAEJ4QooHZAZGldVxXTmkOvk7VAg8tv7nGXwfYmGFsu7Agpro9S+wzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPzIpzBjt+bnfFKzYsfZW2fNUNQW5nC4yWhuoMb2Wvc=;
 b=M+6mvwEfbnUaxzhfqoOe/dK/cT4b2i6fMrNygL0MK8rkkYjSjJg2dNyYq+Zak5d6cNvPyfHhg4XGSswIGsL6vS9YKfOBKu9lPsy08dVJcjZUj0fN1Kl3yQKKl+oaGzWf0RIU87JkPtNv6oeTdl2x9qAaEqfyc4BWqxMWH8Drn3Pp265sVaRvPLp0cQjmZit7h1DuEGtOECwPrWQcogELYyImGrHmX/pqAFJV2yQCKJqeU9OBGcTbymUfl814l7osKyqG93XFua9cbALpE3s0saEFwuuj4IJtxJXDXR3AvLwWvdNXJRKx4uTlApab2vZ/++7F++SOvFZrx5SLajJk6A==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by MW3PR12MB4537.namprd12.prod.outlook.com (2603:10b6:303:5b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 09:36:43 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:36:43 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Topic: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZYjj7BMU6ZLQ8MEG7TiLdHIsIA68cfSEAgAAB3qA=
Date:   Wed, 5 Apr 2023 09:36:43 +0000
Message-ID: <IA1PR12MB6353C7F6A3CBFC62DC23AA89AB909@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com> <ZC0+6hNkTLiDvWEQ@hog>
In-Reply-To: <ZC0+6hNkTLiDvWEQ@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|MW3PR12MB4537:EE_
x-ms-office365-filtering-correlation-id: ddb17cfe-75ea-45b4-9aa9-08db35b94446
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0q8/a+r0b7ilnhozMRhLJ4K0h6m2b9uF3fdSa+4J7VH7rnqPSD/tR46S5BqKl1O0dMBZAadOud5o4Ux2uoIDrK643kJpYKiqQjKj5aD451Ll/pGxFNeJwnUrtZYCeqr3fVw/i0VbEd/lWFzR/TxtLa/SoP2790Vy7oeZxi7sYVoVeNRvpq6hN6efBlWKZdm107uCyUzelUoSp+jgiepWAgaa1hRyKOBEng3neaVgW26OgyDfL6gsEpJDMJsneuj9OvpVzR1kYxtGFpAWUnLQeVBz2+EiLI/WcCUIakvnB+6CCwcrwjCdEQe9m05tcDJyx5isrWISGV9sGwterCDxl8NKeQrsR0/tcVSg66Vgumrht+zEnVzoY8L/WY7+rTW9mviZG5+ol0TgZVRXn3d2PwQAhZI0gkozFYoE+TyQFBgfV3jzXqw+pC3iLNbwFIfq02DsD0kf/7Z6Z6JULsCDTBTQSU+TBDWVCkQueyYHJpugm6VdqpHAttFxRUx1M8l0UNj/QlYCdq8Be3dBIo2FQAOqisUvdlbAYCfpD0Y41RY+BPBkpNqSz4OBLYAokNEMZg7AbqBqHhFX1ciVG0JlhEmF2QFs0/FxJu8nVxCGyY43hoGG0vnSGM/kccI8P5VU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199021)(33656002)(38100700002)(52536014)(66946007)(122000001)(8676002)(5660300002)(38070700005)(55016003)(66556008)(66476007)(64756008)(76116006)(8936002)(41300700001)(6916009)(4326008)(66446008)(86362001)(83380400001)(53546011)(6506007)(9686003)(2906002)(71200400001)(7696005)(26005)(316002)(478600001)(54906003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVpFQmpyM1VCbFlOZjlsM29EWDJCbC82dXdnMENaT0tVc1gyYWZVbWZxNll5?=
 =?utf-8?B?eFgxUHprVStxVU5UeDNyZnI1cEt5cnRTa2RYR2s4OTd0ZmsvbzFtWUY1UWtL?=
 =?utf-8?B?dThhTm1WbWhHbndUL01KY0VPMVNKcWxHUURDTVBnbHhXeG5wWVdPbVI5M1Fk?=
 =?utf-8?B?eTNmekVNTUJxaEU0TmtMT2NwNkF4U05TKzVOMk5YenQ2YkkrSkR3V0UzRWo0?=
 =?utf-8?B?c0I4Ykpqd1lxNnFMVzh2UnpDUzBCYlV3U0hlbzV6Zm14TlRhbVVnR3VnaGtB?=
 =?utf-8?B?a1BXejNDNjVJMlRKcGV1bnVwYjdHSVRjcllTTTdWbVFWQVdlWnozRlFuVnd2?=
 =?utf-8?B?SDd4ci9uL2FKOFdKWmJ2eWRxT1E0MlVva3BJVTN1dW5GVzlUeHp3d081OCs5?=
 =?utf-8?B?MmhGeEVFcTBDc3JPcUpmaWZQdmVBazFPWm42VUR6eitRT2QwUXlDYnJqSUZ2?=
 =?utf-8?B?dFo3aXVJczJBYWlld2p0UGtOaURhd05Pd1VxeDdoM2ZEMCt4RVp6TnFVaExK?=
 =?utf-8?B?b2l6MUkvckRLdjI4OTdZck1NRlJDVUl3VXZ6VXc5VXFpcG10Y1V4N0lQNEVZ?=
 =?utf-8?B?cmlsbjFRUnZPb2g4OEVPT2VvV2lXTndPRlNkYzZKZWlmdEhqZ29KeEpZMGtT?=
 =?utf-8?B?S09zcGl0aGcrckNyTFdYMUdNZlllc1RuVGNGcVdGT0xTSEdDTTVUS3cyRlp1?=
 =?utf-8?B?U05JU2tZQ3VRNU5BL2VkVER0ckRRQkR4RlE3MHNMYjJ0WEhtVmZxTElmbG1q?=
 =?utf-8?B?aHBBNjEzWWlDQktXdGJrcWJ0V1cvT0xLODZuSXE1NldVWVB5Z1V6ZXNrVVR0?=
 =?utf-8?B?R1Z2WXNORUVqaEwrU0RudG1nYmh4VDZzSDQ5MS9rcWs2cHN3TmxyMnY5a1lu?=
 =?utf-8?B?UHZZNnp5azc5QnpjU2lGSjF1cTdYakhjeHZOVXp4WVN6MDlSWG40YjUzdjlx?=
 =?utf-8?B?cHVSS2lnc1ZncElKMHI5aXBCb1ZQb1JwdG9XVWp1L2RCYjAvY3BJOHpqK0ZX?=
 =?utf-8?B?eTJtVDBrWnQvbWEvSkVJK0EzSkZCOTkwRFpFcFZjV09WN2ZubnF4SnAvRmVY?=
 =?utf-8?B?RGJ5L0tkNXFHSE9UOThmT245OFVZdGpDTXpuRGdLSVlQdGdoaWNOenlab2xt?=
 =?utf-8?B?NThrVHpNUFZRZStSVmhqVE9PM1Rha2R1WDJaREhlZHJvZzRXazdvR3Fnc1Vv?=
 =?utf-8?B?R0tBR2prTCs5dGF1WHZOMGFqa09LblZLWjhBMFR6M2hVei9DUEhqNm54RFRC?=
 =?utf-8?B?QnMvZmdtQ2QzMjliMTZvYThxcXYwemIxN2ZPajUrTWxkQnhyK2RLYlhCQTZG?=
 =?utf-8?B?Z2hCb0xCeSt2bmRCS1MvV091a05aVWJkdVZtYTZ5MWFYU3k3RFVlRk4wRzhS?=
 =?utf-8?B?ZkFTcTdqdE5iWWlaY21vbXFNbnMrUE5nVUtIREV6WUpYeE9qbzhhS0lqT0pL?=
 =?utf-8?B?V1htNWlZbkVtUkwzUWYzcW9zbktrNVFkR0lBYy81aVE5emZuRytndEVieVhI?=
 =?utf-8?B?WDQrWStleHBncXppNzFhV2ZNdEtleEJKTlVvamJEUFBYRExlMmExd2hONkZM?=
 =?utf-8?B?N1IzTjhZbkZIU0ZLZEk2VnNxdjl1SkNGZEZXekZNVTlNS1V0MkpRQWFPaGFF?=
 =?utf-8?B?Q3lWeW5odGlhSzdLSlNWR1ZsQVNDTmFiYllNUkMrUVlDNnpzUUR1VlJIYlJr?=
 =?utf-8?B?K0s0aXJaYnA0VjhSYTRjN2l4UStnSWJ5ZHV6aGJTWm5Zd2p5WFJySk8rdkty?=
 =?utf-8?B?aWl4R3l1MUpsQnhJNmcvcEEwMlpuZzhIYStGc1BNOTZ5TkVYN1FtVEwySUpR?=
 =?utf-8?B?eElzS01QbTVUeW93WFVrQUVWMnAwREQ5QXUxeGdIYnJNNnh2d2lvd0lvdGdm?=
 =?utf-8?B?KytWSkxUaTc4WUF5R1RSRGNjTk1aekJIa1ZJUElIbkdJdk5wRzFEZkZ6eGxi?=
 =?utf-8?B?Yk83WkE1NW1YTFRGUnc2YzNCNC9xOGIzNTIvQjZxNVBMZ0xTUW1mSHpnRHlh?=
 =?utf-8?B?aVFkTmpBLzBnUk5mRE5vYWtrbUNuRWtmSndrQWNyZDloRUhUajZ2THZCWWd6?=
 =?utf-8?B?bnhtSWdmM3VvUVF0STRXbzNEcHNUNmRyczV3YUVkaElLd0d6bW54aWdERW5X?=
 =?utf-8?Q?O8KA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb17cfe-75ea-45b4-9aa9-08db35b94446
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:36:43.3678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gr7v6+mFLo1qYICJOYjuu6BbdTbqVUKpEomd9nglI1iNn9BLzN1yPdRrcsGdcuDK4dUDaQuk4DVnIZzeAnCxhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4537
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgNSBBcHJpbCAyMDIzIDEy
OjI3DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBlZHVt
YXpldEBnb29nbGUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgdjIgMS80XSB2bGFuOiBBZGQgTUFDc2VjIG9mZmxvYWQgb3BlcmF0aW9u
cyBmb3INCj4gVkxBTiBpbnRlcmZhY2UNCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlv
biBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gMjAyMy0wMy0yOSwgMTU6
MjE6MDQgKzAzMDAsIEVtZWVsIEhha2ltIHdyb3RlOg0KPiA+IEFkZCBzdXBwb3J0IGZvciBNQUNz
ZWMgb2ZmbG9hZCBvcGVyYXRpb25zIGZvciBWTEFOIGRyaXZlciB0byBhbGxvdw0KPiA+IG9mZmxv
YWRpbmcgTUFDc2VjIHdoZW4gVkxBTidzIHJlYWwgZGV2aWNlIHN1cHBvcnRzIE1hY3NlYyBvZmZs
b2FkIGJ5DQo+ID4gZm9yd2FyZGluZyB0aGUgb2ZmbG9hZCByZXF1ZXN0IHRvIGl0Lg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiA+IC0t
LQ0KPiA+IFYxIC0+IFYyOiAtIENvbnN1bHQgdmxhbl9mZWF0dXJlcyB3aGVuIGFkZGluZyBORVRJ
Rl9GX0hXX01BQ1NFQy4NCj4gPiAgICAgICAgICAgICAgICAgLSBBbGxvdyBncmVwIGZvciB0aGUg
ZnVuY3Rpb25zLg0KPiA+ICAgICAgICAgICAgICAgICAtIEFkZCBoZWxwZXIgZnVuY3Rpb24gdG8g
Z2V0IHRoZSBtYWNzZWMgb3BlcmF0aW9uIHRvIGFsbG93IHRoZSBjb21waWxlcg0KPiB0byBtYWtl
IHNvbWUgY2hvaWNlLg0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9tYWluLmMgfCAgIDEgKw0KPiA+ICBuZXQvODAyMXEvdmxhbl9kZXYuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAxMDEgKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgMTAyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+ID4gaW5kZXggNmRiMWFmZjg3
NzhkLi41ZWNlZjI2ZTgzYzYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gPiBAQCAtNTA3Niw2ICs1MDc2LDcg
QEAgc3RhdGljIHZvaWQgbWx4NWVfYnVpbGRfbmljX25ldGRldihzdHJ1Y3QNCj4gPiBuZXRfZGV2
aWNlICpuZXRkZXYpDQo+ID4NCj4gPiAgICAgICBuZXRkZXYtPnZsYW5fZmVhdHVyZXMgICAgfD0g
TkVUSUZfRl9TRzsNCj4gPiAgICAgICBuZXRkZXYtPnZsYW5fZmVhdHVyZXMgICAgfD0gTkVUSUZf
Rl9IV19DU1VNOw0KPiA+ICsgICAgIG5ldGRldi0+dmxhbl9mZWF0dXJlcyAgICB8PSBORVRJRl9G
X0hXX01BQ1NFQzsNCj4gPiAgICAgICBuZXRkZXYtPnZsYW5fZmVhdHVyZXMgICAgfD0gTkVUSUZf
Rl9HUk87DQo+ID4gICAgICAgbmV0ZGV2LT52bGFuX2ZlYXR1cmVzICAgIHw9IE5FVElGX0ZfVFNP
Ow0KPiA+ICAgICAgIG5ldGRldi0+dmxhbl9mZWF0dXJlcyAgICB8PSBORVRJRl9GX1RTTzY7DQo+
IA0KPiBJTU8gdGhhdCBzaG91bGRuJ3QgYmUgcGFydCBvZiB0aGlzIHBhdGNoLiBPbmUgcGF0Y2gg
Zm9yIFZMQU4gdG8gYWRkIE1BQ3NlYw0KPiBvZmZsb2FkLCB0aGVuIG9uZSBmb3IgbWx4NSB0byBl
bmFibGUgdGhlIGZlYXR1cmUuDQoNCkkgY2FuIHNwbGl0IHRoZSBwYXRjaCBpbnRvIHR3byBwYXRj
aGVzIGFuZCBzZW5kIGFsbCBhcyBuZXcgdmVyc2lvbiwgDQpzaG91bGQgSXQgYmUgYXMgYSBuZXcg
VjMgKHNpbmNlIGxhc3QgVjMgZ290IGRpc2NhcmRlZCkgb3IgSSBzZW5kIGFzIGEgVjQ/IA0KDQo+
IC0tDQo+IFNhYnJpbmENCg0K
