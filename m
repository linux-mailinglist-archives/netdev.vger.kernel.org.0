Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21B856C203
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbiGHUEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 16:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238564AbiGHUEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 16:04:24 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531AD140CA
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 13:04:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1nTtaGBZO0bACZmY6f1xUp2EyMQixdXLC6tjaFVhhdEE4nDvMjBZ6ufYSBFW4ClNwflbXfh/ATydfLRuTYRKoe2fIZ1pUMx4QwWZ8Psd19QoaBbPaDLsfmmkCrZOJpgYlMzPdVBCk2dOTV0hDiuut7bGc677Ja73iJxU8vQT0LYyZTDpMsQhAxCv5PBawFL34BIsJIwmS6ODujc3tcA+K9CLSDSkXh1cZR9olV0keWyjUtYkdlmqvKm/6lXkLC52tIK2msP4s0aJ2cZe4yXdL0KoRm/hjDL5NLteiVCiO4l23SyF8BJbwYZeotq6Wi173ZSg1Whv0osERKfPfYqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtNB4mRpAbzUJ4QafG3SVw/qv/U4CO4eiZncuRZZyBU=;
 b=mT3udnI1IJ5enLrvmPFGyyhExIo4kajwVAmjgziybSPrEZf2djvMabAnBOsyMIt6h6kDobVkqYO+hB3ga439ET+2+mca5kVtQD0WZnOridE+0JL+2xJYfDmT1vYcDwUUxVuI7wujePO3aX3YeRDGmKpH/PxsgGarMgukk0YFtgqcVFHNOFj7Pn5gua9ia7Y3U1j3EkeYCCpA5lKiZQqLUG2hCowpq6dAu4EJKYm0zeTyoyf3Q88YwZBPamTrQneZZZ84wCmUUtn9vxV8guhwU2ufqT0pxAqnvCbAhx8X+OtUbDW4wA6V6CJTUCpBIKZjw32vz7OgDyC1Cf0btDzofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtNB4mRpAbzUJ4QafG3SVw/qv/U4CO4eiZncuRZZyBU=;
 b=CnSAUoVsU0jh4us0VPz1zwa8XqPAzQNPde5f1LTGREVnc0jbJjj8U/mNsTHtJTDWXeryuBHkjYfgnRXWrxEfdxaH5smb6CEUpkq9gri4MjzCDK2Ti5o1U/z2DtJiXwNqx1DANyQvnHDCGWnwMXUG0EXwbzukbNSQX7Lz4b6DCbA=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MW5PR13MB5440.namprd13.prod.outlook.com (2603:10b6:303:191::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 20:04:17 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::28a1:bc39:bd83:9f7]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::28a1:bc39:bd83:9f7%9]) with mapi id 15.20.5417.013; Fri, 8 Jul 2022
 20:04:16 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "edumazet@google.com" <edumazet@google.com>,
        "bcodding@redhat.com" <bcodding@redhat.com>
CC:     "smayhew@redhat.com" <smayhew@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "anna@kernel.org" <anna@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP
 context?
Thread-Topic: [RFC net] Should sk_page_frag() also look at the current GFP
 context?
Thread-Index: AQHYjXoj1cqSWQ6/u0eRgomhkg9WFK1zImKAgAGuxQCAAB+vAA==
Date:   Fri, 8 Jul 2022 20:04:16 +0000
Message-ID: <e8de4a15c934658b06ee1de10fd21975b972f902.camel@hammerspace.com>
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
         <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
         <429C561E-2F85-4DB5-993C-B2DD4E575BF0@redhat.com>
In-Reply-To: <429C561E-2F85-4DB5-993C-B2DD4E575BF0@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38a52940-1a91-437c-12ea-08da611d0987
x-ms-traffictypediagnostic: MW5PR13MB5440:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aux0WIvjPHKv6cW/aTxFXA4zq+jfEaSpe9yEkHZu5dm9dHbxTWYSalTGQfwtml+HHDyRcaEmNs4zKTDKYUK/b5hU6GFh7sQ731UbV429GndCkVBd1q8XZ3wuqUQayCOM5vqcZm8gj8Ldg6Y+8TSbd96s5DItzq6YrYVJdgbtRfhPpZlOqHN2l/rEH3tPsEkjVC2OwSQFhFg6cKhK0eODZn1rFtgg4kI1W3tji9xjkCXiffyUq1qW6O5G1vpM6aSt4kqix/CCRMv/wbKqxAM+S34D88ggDHqjJiscJyZaMCMVUcwUM3T1LFapLY6pwMAQms8qff7zwvXlPUKcvh9a2IuLYlXI5USQ33Ur5aYtbj+4gKIFuhvfgdMnqhAtK4jwoVEnzaoQPyCvLW9Su2TFdeFiuu/jvomeTdwV/RNxDs0vOIMa/XTh0WScex0GkmkZlfAZbMtq/YY45hs9LDDfAZqgg3Eu+E6kxGXfX6b+2tyoc8m0eJfeETPPJQTNGfZPMzG9L/z+3jKVrkd4o8zDlMTCG6rP8Br3pVjM0EO9vPO2qhm4x9rltJ4MWxJ7nJ0CxTOnWjW5tj9f+1y2HCxpjGWqo2utI4J+Q5gTwZREze4Luvk2ZPxZEyKswxc63mdb4MiY3byhIpY35L6Hq4pIIfnlomHBjPRdVmx7KZ7nf2RKsuojehSar1YjSp5hIqo4iH3VLJH1WkbWNIPv4CXZGiKnh9JHgYCze1yUyBFxdih6TKmZHyNo0lm/X1daFOfsaGfsxcl2vHukrtXVHVV81OzBRwMj4f24HFO07n0MKv+NbJlwzkU5cgN8TmK4FYGbGkeJx/MXpebQPFPogjokJuPB1mEa4+HNGjnpBy4OQVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(376002)(39840400004)(396003)(346002)(7416002)(5660300002)(6512007)(6506007)(83380400001)(122000001)(26005)(53546011)(478600001)(41300700001)(86362001)(2906002)(8936002)(6486002)(38100700002)(38070700005)(2616005)(186003)(36756003)(54906003)(110136005)(66476007)(71200400001)(66556008)(316002)(64756008)(76116006)(66946007)(4326008)(8676002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2N1TVFkL2lQL0FxRWdzb2o1NkNXb1pjd3FCNkhkekxnQlZIYTN5YStreUpn?=
 =?utf-8?B?bU81K2psSkxLVW9TUE93a2ZHZ0lDby85ZDdoWnVYOEx6SkRwcWljYitzMGFW?=
 =?utf-8?B?OGhXaTgyVTIxZUlzRE81Ymx5UjBiSk1Fa3JSOGJUdXQwQTRwMWVBTUVOL0JK?=
 =?utf-8?B?ZG16dUZNSTdNQXMyM25LZWdXT0ZEQ2YwVXlnbGtMZW96VUx4aE9XWVlrUDgz?=
 =?utf-8?B?WkgwL0VxOUVZaHZ6WTNLb2FRMUZKQ0xGT0xVY1lkMFlWM00vVk1XcTVobWpF?=
 =?utf-8?B?OXA5YjU1ajV0RmliUCs4THRKOGh3Nml6V2lXVmR3TlZkTEJSR0txZVVHNGxR?=
 =?utf-8?B?V3crUEtqQ0R4Nyt0NWhHL2JrVEJ0UktSemdxNjZaWXRyTldGV3hZdzhCY3pY?=
 =?utf-8?B?VjJuWk9LLy82c05Bczlwa0JmQTVmYzN0OXd2Z0x2MllRUko4cndOd2RKY2pk?=
 =?utf-8?B?aS81RGhUQXEyZm1qR2Myci9ETDFYanZrNHFUK05Dc2hXQ0pESnY0L2ROTzVP?=
 =?utf-8?B?blpCbUozK2NTZHN6UWtvcHFpdDBUUTh3aERnTno2YkxmYzhhNmN5aUdCQkNE?=
 =?utf-8?B?eHBZaExEdmNPSnFtcWtTLzRocjFzK0FaYWorekJQdFRLcml1ZVVOMlg3S2di?=
 =?utf-8?B?czl4S2l0ZHc0bW1jVlhXV1ZaanZxc3lYak9FQUVXL2pNbzJuYldPOXFSNWZ4?=
 =?utf-8?B?ZXdVNWR6R3UwNkUrYnZ0LzJZTEw3emNsMGVJRmVmZ2sreHVJUVpHRTlrSjYv?=
 =?utf-8?B?QldQV3Z1eUY0ckdBcXBCUGJlSkYvblNTM0hwYktEV1ZNRXNRRnJpUE95Rmpo?=
 =?utf-8?B?cUtPVUF2NmVPRk85Njcva25PRXJLaVVTVlRScGczanJ5emlMd2g4akdVaUdK?=
 =?utf-8?B?NkpvakpBcVpzSTJwQjNtYWdqaTlodXlqclNSLzY5V3I5VVJGazVmejRabW5P?=
 =?utf-8?B?MzJWMmZxZnpHRzcwWVpTY2t2NUhraitRdWJzTm1WVW05VU0wRWc0Z1YyUGYw?=
 =?utf-8?B?blZ5cmYvck55WCtrdWQrbnlrT0ZHOFRPNzJ4TklpbVQvd0cvcXZ6Smc4NmpJ?=
 =?utf-8?B?cm0yK3d5bnlVWUFIa3kwUzhJWFd5R25vVS83K3RBMVFTRDJKcGU0L2FrOXQz?=
 =?utf-8?B?Z0NOa0VadGlxWWZRSHgrV2ZiOE5TRDJpWkZTQ0txSS9zd2czRjA4OHMyeTc2?=
 =?utf-8?B?WjJVQVFYT0k1L0hYaVpUMzUvV2MzSW9nQmw5bXNsZmwzeDJqN3QrcWpVZERx?=
 =?utf-8?B?OUtTMHI4dFB3aFRiUURoTUx0WUFENGc3TC9Xd0xkb1htL3E4bXZ4NHNMd05B?=
 =?utf-8?B?cFUycjM3VFBFNzFOTkxTSHlKL1FBZ1RrbmVoMUZDT29ycWN6Ym1WY0w5MUlo?=
 =?utf-8?B?K202M3RkTXJxOXNZTkpBcjc5dDE1cEFGRHJvTEM0YWFBL0FVMkE3Z2ZOYWhJ?=
 =?utf-8?B?NUd6TzJYM3NRbEVEVlhwTHBORWdKQVdPK0E2bFIzdHdWK1pzQlpZVGwvNGlu?=
 =?utf-8?B?VW5GaThLTldrNGJTVHZkVjZGc083R0hQdVB0Y3BtSUE3YnU5cUMyUjZ6ajlM?=
 =?utf-8?B?dkNQS3JqTEtZN3pUbXJwN0VlMWgwL1NrV3hUN2pJWnJJeEJBZWtvdFBhQ1Ra?=
 =?utf-8?B?RGFpZ3lIeHlXMlIrUDY4cGNvcENlN2h2aVdaUHlBTnU2WDY1b1lCUHVLL05s?=
 =?utf-8?B?UENpMEI5blNRbFllRVgxSnZ6aFlBY3BXR3JrVWlDVnpScEk2aVlMbW9zamF4?=
 =?utf-8?B?V1M2bWI1TXpud1Q5WGhrZW5SVzZwcm5kK2dlNENyUFcyVCtYdlRqbFdvSWUw?=
 =?utf-8?B?VnJsNVhkRS8yVTFkajcrWmJ5d3NKbW8xZTRzeW9jQlJTbHZoZFlpMms0QTZP?=
 =?utf-8?B?Nm9ldkJ0V1E2Y0xoY2NCS20vSnNBdWdmbm8xNGpJVVdCRlBTcjFBWXJ6TmJ6?=
 =?utf-8?B?WEViN1RPOHhBVkk4MXFGM0pYak43YTMvcnZTWXQrbncxUlp4aUJwcUdsS2Rs?=
 =?utf-8?B?OENYd0JqVWUwalVZYUNjSnNSUTUzRkc5bTI0cEhudWhkRlRMb3o1VnpnYXhr?=
 =?utf-8?B?WCtEcmg1akg1VmlqRlRKNUNrTW9raFkyZnd0ckN4OVFhSXdCSDA4b3VRTVFM?=
 =?utf-8?B?WkNuQlpON1F3d2p3cFFvL3B3a2hJSnRITkMrNURuanNOdjJncE1qb1EzdlZa?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD5C63981CE8EC4AA8DDC6039D1FD383@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a52940-1a91-437c-12ea-08da611d0987
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 20:04:16.7983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K4FPPSz3hREn3daM8ZosfjY+xtLH+26m56jTu+PWrtoAnFlCS7FB+uq389u8qoQeRx7anUErQEOUdglY8oiuMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5440
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTA3LTA4IGF0IDE0OjEwIC0wNDAwLCBCZW5qYW1pbiBDb2RkaW5ndG9uIHdy
b3RlOg0KPiBPbiA3IEp1bCAyMDIyLCBhdCAxMjoyOSwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPiAN
Cj4gPiBPbiBGcmksIEp1bCAxLCAyMDIyIGF0IDg6NDEgUE0gR3VpbGxhdW1lIE5hdWx0IDxnbmF1
bHRAcmVkaGF0LmNvbT4gDQo+ID4gd3JvdGU6DQo+ID4gPiANCj4gPiA+IEknbSBpbnZlc3RpZ2F0
aW5nIGEga2VybmVsIG9vcHMgdGhhdCBsb29rcyBzaW1pbGFyIHRvDQo+ID4gPiAyMGViNGYyOWI2
MDIgKCJuZXQ6IGZpeCBza19wYWdlX2ZyYWcoKSByZWN1cnNpb24gZnJvbSBtZW1vcnkgDQo+ID4g
PiByZWNsYWltIikNCj4gPiA+IGFuZCBkYWNiNWQ4ODc1Y2MgKCJ0Y3A6IGZpeCBwYWdlIGZyYWcg
Y29ycnVwdGlvbiBvbiBwYWdlIGZhdWx0IikuDQo+ID4gPiANCj4gPiA+IFRoaXMgdGltZSB0aGUg
cHJvYmxlbSBoYXBwZW5zIG9uIGFuIE5GUyBjbGllbnQsIHdoaWxlIHRoZQ0KPiA+ID4gcHJldmlv
dXMgDQo+ID4gPiBienMNCj4gPiA+IHJlc3BlY3RpdmVseSB1c2VkIE5CRCBhbmQgQ0lGUy4gV2hp
bGUgTkJEIGFuZCBDSUZTIGNsZWFyIF9fR0ZQX0ZTDQo+ID4gPiBpbg0KPiA+ID4gdGhlaXIgc29j
a2V0J3MgLT5za19hbGxvY2F0aW9uIGZpZWxkICh1c2luZyBHRlBfTk9JTyBvcg0KPiA+ID4gR0ZQ
X05PRlMpLCANCj4gPiA+IE5GUw0KPiA+ID4gbGVhdmVzIHNrX2FsbG9jYXRpb24gdG8gaXRzIGRl
ZmF1bHQgdmFsdWUgc2luY2UgY29tbWl0DQo+ID4gPiBhMTIzMWZkYTdlOTQNCj4gPiA+ICgiU1VO
UlBDOiBTZXQgbWVtYWxsb2Nfbm9mc19zYXZlKCkgb24gYWxsIHJwY2lvZC94cHJ0aW9kIGpvYnMi
KS4NCj4gPiA+IA0KPiA+ID4gVG8gcmVjYXAgdGhlIG9yaWdpbmFsIHByb2JsZW1zLCBpbiBjb21t
aXQgMjBlYjRmMjliNjAyIGFuZCANCj4gPiA+IGRhY2I1ZDg4NzVjYywNCj4gPiA+IG1lbW9yeSBy
ZWNsYWltIGhhcHBlbmVkIHdoaWxlIGV4ZWN1dGluZyB0Y3Bfc2VuZG1zZ19sb2NrZWQoKS4gVGhl
DQo+ID4gPiBjb2RlDQo+ID4gPiBwYXRoIGVudGVyZWQgdGNwX3NlbmRtc2dfbG9ja2VkKCkgcmVj
dXJzaXZlbHkgYXMgcGFnZXMgdG8gYmUgDQo+ID4gPiByZWNsYWltZWQNCj4gPiA+IHdlcmUgYmFj
a2VkIGJ5IGZpbGVzIG9uIHRoZSBuZXR3b3JrLiBUaGUgcHJvYmxlbSB3YXMgdGhhdCBib3RoDQo+
ID4gPiB0aGUNCj4gPiA+IG91dGVyIGFuZCB0aGUgaW5uZXIgdGNwX3NlbmRtc2dfbG9ja2VkKCkg
Y2FsbHMgdXNlZCANCj4gPiA+IGN1cnJlbnQtPnRhc2tfZnJhZywNCj4gPiA+IHRodXMgbGVhdmlu
ZyBpdCBpbiBhbiBpbmNvbnNpc3RlbnQgc3RhdGUuIFRoZSBmaXggd2FzIHRvIHVzZSB0aGUNCj4g
PiA+IHNvY2tldCdzIC0+c2tfZnJhZyBpbnN0ZWFkIGZvciB0aGUgZmlsZSBzeXN0ZW0gc29ja2V0
LCBzbyB0aGF0DQo+ID4gPiB0aGUNCj4gPiA+IGlubmVyIGFuZCBvdXRlciBjYWxscyB3b3Vsbid0
IHN0ZXAgb24gZWFjaCBvdGhlcidzIHRvZXMuDQo+ID4gPiANCj4gPiA+IEJ1dCBub3cgdGhhdCBO
RlMgZG9lc24ndCBtb2RpZnkgLT5za19hbGxvY2F0aW9uIGFueW1vcmUsIA0KPiA+ID4gc2tfcGFn
ZV9mcmFnKCkNCj4gPiA+IHNlZXMgc3VucnBjIHNvY2tldHMgYXMgcGxhaW4gVENQIG9uZXMgYW5k
IHJldHVybnMgLT50YXNrX2ZyYWcgaW4NCj4gPiA+IHRoZQ0KPiA+ID4gaW5uZXIgdGNwX3NlbmRt
c2dfbG9ja2VkKCkgY2FsbC4NCj4gPiA+IA0KPiA+ID4gQWxzbyBpdCBsb29rcyBsaWtlIHRoZSB0
cmVuZCBpcyB0byBhdm9pZCBHRlNfTk9GUyBhbmQgR0ZQX05PSU8NCj4gPiA+IGFuZCANCj4gPiA+
IHVzZQ0KPiA+ID4gbWVtYWxsb2Nfbm97ZnMsaW99X3NhdmUoKSBpbnN0ZWFkLiBTbyBtYXliZSBv
dGhlciBuZXR3b3JrIGZpbGUgDQo+ID4gPiBzeXN0ZW1zDQo+ID4gPiB3aWxsIGFsc28gc3RvcCBz
ZXR0aW5nIC0+c2tfYWxsb2NhdGlvbiBpbiB0aGUgZnV0dXJlIGFuZCB3ZQ0KPiA+ID4gc2hvdWxk
DQo+ID4gPiB0ZWFjaCBza19wYWdlX2ZyYWcoKSB0byBsb29rIGF0IHRoZSBjdXJyZW50IEdGUCBm
bGFncy4gT3Igc2hvdWxkDQo+ID4gPiB3ZQ0KPiA+ID4gc3RpY2sgdG8gLT5za19hbGxvY2F0aW9u
IGFuZCBtYWtlIE5GUyBkcm9wIF9fR0ZQX0ZTIGFnYWluPw0KPiA+ID4gDQo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBHdWlsbGF1bWUgTmF1bHQgPGduYXVsdEByZWRoYXQuY29tPg0KPiA+IA0KPiA+IENh
biB5b3UgcHJvdmlkZSBhIEZpeGVzOiB0YWcgPw0KPiA+IA0KPiA+ID4gLS0tDQo+ID4gPiDCoGlu
Y2x1ZGUvbmV0L3NvY2suaCB8IDggKysrKysrLS0NCj4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbmV0L3NvY2suaCBiL2luY2x1ZGUvbmV0L3NvY2suaA0KPiA+ID4gaW5kZXggNzJj
YTk3Y2NiNDYwLi5iOTM0Yzk4NTEwNTggMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRlL25ldC9z
b2NrLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbmV0L3NvY2suaA0KPiA+ID4gQEAgLTQ2LDYgKzQ2
LDcgQEANCj4gPiA+IMKgI2luY2x1ZGUgPGxpbnV4L25ldGRldmljZS5oPg0KPiA+ID4gwqAjaW5j
bHVkZSA8bGludXgvc2tidWZmLmg+wqDCoMKgwqDCoCAvKiBzdHJ1Y3Qgc2tfYnVmZiAqLw0KPiA+
ID4gwqAjaW5jbHVkZSA8bGludXgvbW0uaD4NCj4gPiA+ICsjaW5jbHVkZSA8bGludXgvc2NoZWQv
bW0uaD4NCj4gPiA+IMKgI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+DQo+ID4gPiDCoCNpbmNs
dWRlIDxsaW51eC9zbGFiLmg+DQo+ID4gPiDCoCNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+DQo+
ID4gPiBAQCAtMjUwMywxNCArMjUwNCwxNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgDQo+ID4gPiBz
a19zdHJlYW1fbW9kZXJhdGVfc25kYnVmKHN0cnVjdCBzb2NrICpzaykNCj4gPiA+IMKgICogc29j
a2V0IG9wZXJhdGlvbnMgYW5kIGVuZCB1cCByZWN1cnNpbmcgaW50byBza19wYWdlX2ZyYWcoKQ0K
PiA+ID4gwqAgKiB3aGlsZSBpdCdzIGFscmVhZHkgaW4gdXNlOiBleHBsaWNpdGx5IGF2b2lkIHRh
c2sgcGFnZV9mcmFnDQo+ID4gPiDCoCAqIHVzYWdlIGlmIHRoZSBjYWxsZXIgaXMgcG90ZW50aWFs
bHkgZG9pbmcgYW55IG9mIHRoZW0uDQo+ID4gPiAtICogVGhpcyBhc3N1bWVzIHRoYXQgcGFnZSBm
YXVsdCBoYW5kbGVycyB1c2UgdGhlIEdGUF9OT0ZTIGZsYWdzLg0KPiA+ID4gKyAqIFRoaXMgYXNz
dW1lcyB0aGF0IHBhZ2UgZmF1bHQgaGFuZGxlcnMgdXNlIHRoZSBHRlBfTk9GUyBmbGFncw0KPiA+
ID4gKyAqIG9yIHJ1biB1bmRlciBtZW1hbGxvY19ub2ZzX3NhdmUoKSBwcm90ZWN0aW9uLg0KPiA+
ID4gwqAgKg0KPiA+ID4gwqAgKiBSZXR1cm46IGEgcGVyIHRhc2sgcGFnZV9mcmFnIGlmIGNvbnRl
eHQgYWxsb3dzIHRoYXQsDQo+ID4gPiDCoCAqIG90aGVyd2lzZSBhIHBlciBzb2NrZXQgb25lLg0K
PiA+ID4gwqAgKi8NCj4gPiA+IMKgc3RhdGljIGlubGluZSBzdHJ1Y3QgcGFnZV9mcmFnICpza19w
YWdlX2ZyYWcoc3RydWN0IHNvY2sgKnNrKQ0KPiA+ID4gwqB7DQo+ID4gPiAtwqDCoMKgwqDCoMKg
IGlmICgoc2stPnNrX2FsbG9jYXRpb24gJiAoX19HRlBfRElSRUNUX1JFQ0xBSU0gfCANCj4gPiA+
IF9fR0ZQX01FTUFMTE9DIHwgX19HRlBfRlMpKSA9PQ0KPiA+ID4gK8KgwqDCoMKgwqDCoCBnZnBf
dCBnZnBfbWFzayA9IGN1cnJlbnRfZ2ZwX2NvbnRleHQoc2stPnNrX2FsbG9jYXRpb24pOw0KPiA+
IA0KPiA+IFRoaXMgaXMgc2xvd2luZyBkb3duIFRDUCBzZW5kbXNnKCkgZmFzdCBwYXRoLCByZWFk
aW5nIGN1cnJlbnQtDQo+ID4gPmZsYWdzLA0KPiA+IHBvc3NpYmx5IGNvbGQgdmFsdWUuDQo+IA0K
PiBUcnVlIC0gY3VycmVudC0+ZmxhZ3MgaXMgcHJldHR5IGRpc3RhbnQgZnJvbSBjdXJyZW50LT50
YXNrX2ZyYWcuDQo+IA0KPiA+IEkgd291bGQgc3VnZ2VzdCB1c2luZyBvbmUgYml0IGluIHNrLCBj
bG9zZSB0byBzay0+c2tfYWxsb2NhdGlvbiB0bw0KPiA+IG1ha2UgdGhlIGRlY2lzaW9uLA0KPiA+
IGluc3RlYWQgb2YgdGVzdGluZyBzay0+c2tfYWxsb2NhdGlvbiBmb3IgdmFyaW91cyBmbGFncy4N
Cj4gPiANCj4gPiBOb3Qgc3VyZSBpZiB3ZSBoYXZlIGF2YWlsYWJsZSBob2xlcy4NCj4gDQo+IEl0
cyBsb29raW5nIHByZXR0eSBwYWNrZWQgb24gbXkgYnVpbGQuLiB0aGUgbmVhcmVzdCBob2xlIGlz
IDUNCj4gY2FjaGVsaW5lcw0KPiBhd2F5Lg0KPiANCj4gSXQnZCBiZSBuaWNlIHRvIGFsbG93IG5l
dHdvcmsgZmlsZXN5c3RlbSB0byB1c2UgdGFza19mcmFnIHdoZW4NCj4gcG9zc2libGUuDQo+IA0K
PiBJZiB3ZSBleHBlY3Qgc2tfcGFnZV9mcmFnKCkgdG8gb25seSByZXR1cm4gdGFza19mcmFnIG9u
Y2UgcGVyIGNhbGwgDQo+IHN0YWNrLA0KPiB0aGVuIGNhbiB3ZSBzaW1wbHkgY2hlY2sgaXQncyBh
bHJlYWR5IGluIHVzZSwgcGVyaGFwcyBieSBsb29raW5nIGF0DQo+IHRoZQ0KPiBzaXplIGZpZWxk
Pw0KPiANCj4gT3IgbWF5YmUgY2FuIHdlIHNldCBza19hbGxvY2F0aW9uIGVhcmx5IGZyb20gY3Vy
cmVudF9nZnBfY29udGV4dCgpIA0KPiBvdXRzaWRlDQo+IHRoZSBmYXN0IHBhdGg/DQoNCldoeSBu
b3QganVzdCBhZGQgYSBiaXQgdG8gc2stPnNrX2FsbG9jYXRpb24gaXRzZWxmLCBhbmQgaGF2ZQ0K
X19zb2NrX2NyZWF0ZSgpIGRlZmF1bHQgdG8gc2V0dGluZyBpdCB3aGVuIHRoZSAna2VybicgcGFy
YW1ldGVyIGlzIG5vbi0NCnplcm8/IE5GUyBpcyBub3QgYWxvbmUgaW4gZm9sbG93aW5nIHRoZSBy
ZXF1ZXN0IG9mIHRoZSBtbSB0ZWFtIHRvDQpkZXByZWNhdGUgdXNlIG9mIEdGUF9OT0ZTIGFuZCBH
RlBfTk9JTy4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRh
aW5lciwgSGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
