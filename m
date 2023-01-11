Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF29665CCC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbjAKNkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbjAKNkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:40:08 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE545D78
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:38:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+eDkqVPeh/wgXQg0Nr55fXqehae/xXAIK41fPajnmKE51s2k3qn2Z1ErDvIT3QCVwqmOtzKnShvpb9CVuMYLklntZUO9WITF+4grL3JGM5MSVSxDwuYE8iDZhtRlskXcGNnV1KkgMqq1g7SK5y5/LCUwG75UB6hQriQ6lRViTMxjxkPDqonj/4JUYSJGlw8mB9BG4yFusfnWYy9dttqt35qSi1XHjXOk7yaFKLtkxZj2vV9zhvBrb37+Mr/+O3ZRH30Ihu/R7NrsO9Q7wng73jUzH7e/R+2yA6OJPVVSgzGdNFdJSm6kYlk3WutYebmvyXaaz2siqabeeODB0mxNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX4+eQZRYH3Grv3s//q1STLJpjNHycy1h6gM9O0+Gq0=;
 b=N8sGH6NeexWWdz6TR7sQOqEN2YTzuq8YyhKF2dT9spSWDZnlOdZOF0VpEekWMWA0nWU+u6/GQWofNekBrhikFgtY1unypoCsI2+RCvK7vM8tTSJMK/aBfRIG0Ck894FARfw6nRj2Xa7lDzgYoaHzIfTmDYw8FE1OC9Bj2UU9GjCI8MdIYpBuC6jEdy/vS0JQKhDg/eLPB2QLVB0X907ypuCB45nqB6xAr1B6OX9qW69fksF1MuJu9mjPMz0VT1P3HAZO6paADjBB/faulrTK8N7kUEff5wRpJfXctv4FkN98xAH2n5yB7P5z9PKiJEBdrEHeBTbQ50GsvBjGwEyBgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX4+eQZRYH3Grv3s//q1STLJpjNHycy1h6gM9O0+Gq0=;
 b=L3MKAQXsvz3+pgHTgpUT+TZtavqk5ysydJ1SM4+9eu9XLeyU6sR6eE84lMHcu8ccECBtdlUX+irUOmFIcMZpDd9MeswLbr3KrNiAunecMS1DsvCcbAl2G/1sSQP+HiP04OqVQD7078fTKQS7vztSuohfmbxLVUGxn9BK0dwv6w7hDl1TNHGfo2HQab4fGU3fi0bBr2TQ81WAWx49YjSvFjipaYwz9mF+pB9BivwvyS5NIkqLfEifUD2xXL90YlmRH1exKXa3FgChwEZsmfkYdMT30dQAexAwvcjR7w4W1p+kXAqfm+4ZGA81iQ83H2opiJuqzs+mWOA8+qp8XwRhtg==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SJ0PR12MB6760.namprd12.prod.outlook.com (2603:10b6:a03:44c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 13:38:13 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 13:38:13 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [PATCH net-next v8 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v8 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZJZRZyGzYWtwkFUSXfJ36ZV05wq6ZN8IAgAAAvfA=
Date:   Wed, 11 Jan 2023 13:38:13 +0000
Message-ID: <IA1PR12MB6353C094EFC78F8FAEE41519ABFC9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230111081112.21067-1-ehakim@nvidia.com>
 <20230111081112.21067-2-ehakim@nvidia.com> <Y7668voOCFqWXmdF@hog>
In-Reply-To: <Y7668voOCFqWXmdF@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SJ0PR12MB6760:EE_
x-ms-office365-filtering-correlation-id: a4dd3fe6-e078-4f2f-c61d-08daf3d91632
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5lqYcJhSvnkq/CjuNzVbFM2pfBUL7AENyZU6K39fwdgSDCvNuZdjYcqjvFa+ijMJrirpNaI7BaTBsfHndP5IKrv138NOdbt+FWrAwaxqkc8Gy9ikkOIV3Nd0G7Xva2KhrNRm35y97v4Ke06VV2d3XvSJTfqr9/Y9hwugsFtfv0eI6Wv1GPQj41HBmER3zgAWMFK0umfeS+lxF5jOghZYpR9ZHA6Z1HtgB+yupzcL0YzxgaKEr7nEEVXLRopl4lYzPlZ3N8VC5AF1sgmP6hZI70CkdJf0/tQ6MyBMDvHh2y2vTTzqb2J9eai8gf8AjEs/lblJq7mAFtuxYxeEfnVtrn5bQ2j6H5Tsgilc1XFvfXWxV163m3y5cWvliImYtqTIKRPeUjqn3HoqKw2FGwuRjefAN7LvAFut2dMih4MmM9fI2pYP/WWZBt3h8AfdtgPNhLlYghjurj53v1gU3+GnbBTgbjcoAb3cnTslnrbXTB4TtjkgJ7DbZjtu7A/X7y4k1MYaAYL8Tbx7yCkK1EL0D+DtoJMtgkbIUxKpGhdE71kwHHm8QCSDw6kVgFjAuKIowuYqX26sp88qduEb3qtStnJpU/ID8EGED+2HDV37+42LnpHQnIWwn3yCqCJfq2nZcTd+OFYmD7aeI5vCW5CfRtKElqYtmhTsRUyvB6Ug7WYX1SNa4Um8Ha/9rd1vkE+lMmj7zGV64GnLpcZvY+Hd5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199015)(5660300002)(6506007)(6916009)(4326008)(64756008)(8676002)(53546011)(83380400001)(122000001)(2906002)(52536014)(66476007)(66446008)(8936002)(33656002)(38100700002)(41300700001)(76116006)(38070700005)(478600001)(186003)(26005)(9686003)(66556008)(66946007)(55016003)(7696005)(71200400001)(86362001)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTdid21EbUx5M21DT0NrcnY4cmJFUVpWaUZGK3NVK1Jxa0hmdlQ5bjkxUTJx?=
 =?utf-8?B?bVBkTXduQWhib1JDRUorZ21KbVhFL3FWWXhBdlcwL3ZBV2oweUZKTFdMZWpu?=
 =?utf-8?B?cU4yYTQvd0dhbWFXREYrR2dRR3EyNVhmY3hwc2NPTlFnMHZGdTRNOXZ4OFll?=
 =?utf-8?B?Wi9MRVByek5sbFRaV2t1akFWSnBKZi9aM3dJTEhDTDVidmJWalBWcW1Ta1Y1?=
 =?utf-8?B?M0UyS3dVbWU4VmZNeVlwbGdIRFRHSmUwdE90QUMyNnQ1YVQveXV0STUxYWxU?=
 =?utf-8?B?Mk1FZjJ5ZmoyeXFxNU5LR2xGYjkzNHIvMU45K2JRNlNmMGF4RVl0YjY0OFlI?=
 =?utf-8?B?bTN3WUxya0hDZy81RWR1UFpQT3pXVEE5TEFLTnZNWkw5OThLZEU2bUg3VlIy?=
 =?utf-8?B?a0I2RmpBd2ljNGc5UWxFeU0rbmxUWS96TXB2TU5sZldaZFhTanFtZU5UMnpi?=
 =?utf-8?B?OWJMaXYrNHUzZEhHUUt3M3BFbEZUOXhuV0F6bTl5RlBOSmlJejhqdGR5ZUVS?=
 =?utf-8?B?VDVRd0FvR0hwRDJMYWNIUTQrQ2JsNjY1YWhPM2RmWDQ0TnJxcUxXcFBXMkV5?=
 =?utf-8?B?SmZiWGpJU2UyV2krOEJXQWp5cjJ5MElWeHBYZEU0NUloTWQ0WnU2dEx6M0dC?=
 =?utf-8?B?R1JnNGJqRVhtdURNejVRSlBoSU82Q2dQSFFoTWphbEZITk1WY0FEVis0ZUY1?=
 =?utf-8?B?TEVMdDhwbExTS3h1RjNLQVNnU3hpOWJib2dYeFZKRVpMUkNNcy8rQlVXdENO?=
 =?utf-8?B?a0FQUUJsanF5Ni9sdnpXVjhHamVVY2wyb3V0dUp2dmJXczZIT0JZVnFLVDhH?=
 =?utf-8?B?dlhoc2hIcmw5cWxyUjdvczJQSGVOL092Y1k4WWs4ZWN1cGc3c3k1Vk1kT3lQ?=
 =?utf-8?B?L04vV2JpQWJtQ1E4SmpXYUJ5MDJPMm11ZHFWTDJhVWxVc0l3V1hmaVVNQ05x?=
 =?utf-8?B?QWhTVlp2V1g4Mm5iRGlaMzJoZ1ZybC8rckFNMkZ6LzlaSm9IK2xpcXhBalpv?=
 =?utf-8?B?NCsxVlNTcVlNQktud21lWVFTRGdpRVlObk9PYWMwUGFtVjFsR3JsUHN5c1Ur?=
 =?utf-8?B?YXJ4YVYvdG1leWdvZitsK0hMZTRaRDBYMEx2Z003ZysxRDQxK0diZENvMDNO?=
 =?utf-8?B?cktRenRKb3p6dHIvdEJHd29kVDFQaG9KWUxtUnZvNXppQXdZK2lTN2ZnR2RD?=
 =?utf-8?B?RjhkdjNUall1Y0t3aUZGaFp3RXFlaytQQU53cFBQdFdRK0RGQnhOcFlZbXlC?=
 =?utf-8?B?Z0hsTGRJNHR6N09Ha0pUMzFtejlDa3MzWEpVeWVKME5XRjk5bkl5amVMV2lu?=
 =?utf-8?B?bDNySklPT250MTB3R2FnNmZKcnJucGl4VXJVVCtpOEtsR2hwSGNNYWY1Y1da?=
 =?utf-8?B?dlllQlk1S2tZYnR2ZTQycFRwT2xxK0hxc3ZoNHdZdUZsNTM5d1lWTnc2RUV5?=
 =?utf-8?B?eHNQS05UejIza3g4WU0zWDF4WkE4M2tIUUZDUzRSUFBOTnVKeFhqR01UWDFF?=
 =?utf-8?B?SWFzNjQvZk9kYkNManBoT3doMFgzVDBmOTRic2RONHdCZ2pEMzZzNEk4RzhI?=
 =?utf-8?B?dUQvSGV6TEh5Myt1cUN1Z1RRZlV2THdETGE1V3BkYVBFampKcFFIa1RJekRO?=
 =?utf-8?B?bi9kQWFWVVg5VnNwSjUrZ3RtNDFJQStDRG5sTkFnRjZXWXdIUHpVUFhyUmtW?=
 =?utf-8?B?RHVmdzlsbWF5RWN6NUxGRHFZVlZBcHF3STNGVzBWOVFEbk85ZklzNXUzR3Y2?=
 =?utf-8?B?b2tUN21YSTUzK1pGd2k4dHhLejFrSGc0MWxUTHNSenBZdW42V1ZZUTdUVnNn?=
 =?utf-8?B?ZTF0R0haRzhpeGFtdm8vQy9oV2RHcnA1VkhjeWVNS1hXZVg4dUZmQ3dGV3o2?=
 =?utf-8?B?YWJicm52MEdYVHdxWEtvMWJtRUlvL1NVUW5MZlJ1NkkrZ2VESGRsY3lSQklS?=
 =?utf-8?B?cjAzV29nV3ZXTFdOVGRkVnVyQk4zbDJKRWlsU0l0VXN0QmdOamRmRHQvSXVM?=
 =?utf-8?B?T1JEVUxzTnBMcUk2T2F1cWZYRnVHNlNYNjJyM1VPbWgyclVHWHlyV1ZLZ2pD?=
 =?utf-8?B?S2lUR05xMmNpYjNVTlBpbk9lYmRPSUdPN0o2UmROcGg4T1g3dk00Z3BteGw5?=
 =?utf-8?Q?LXLLPeWn51dJF09BiOuTwwABL?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4dd3fe6-e078-4f2f-c61d-08daf3d91632
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 13:38:13.1600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jDE1B0gO7U4FJgnULNIH9M0ygykx3NP30LxX5Ri24ArLevjzkLif9tUPKnCDqaUKMqknFciFDuWWbqqJrMcVyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6760
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgMTEgSmFudWFyeSAyMDIz
IDE1OjM1DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtIDxyYWVkc0BudmlkaWEuY29tPjsNCj4gZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0K
PiBwYWJlbmlAcmVkaGF0LmNvbTsgYXRlbmFydEBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgdjggMS8yXSBtYWNzZWM6IGFkZCBzdXBwb3J0IGZvcg0KPiBJRkxBX01B
Q1NFQ19PRkZMT0FEIGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+IA0KPiBFeHRlcm5hbCBlbWFpbDog
VXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IFNvcnJ5
IHRvIGRlbGF5IHRoaXMgYWdhaW4sIHRoZXJlJ3Mgc29tZXRoaW5nIHRvIGZpeCBpbiB0aGlzIHZl
cnNpb24uDQo+IEkgaG9wZSB5b3UncmUgbm90IHRvbyBmcnVzdHJhdGVkIGJ5IHRoZSByZXZpZXcg
cHJvY2Vzcy4NCg0KYWxsIGdvb2QgdGhhbmtzIGZvciB0aGUgZWZmb3J0IQ0KSSB3aWxsIGZpeCBB
U0FQLg0KDQo+IDIwMjMtMDEtMTEsIDEwOjExOjExICswMjAwLCBlaGFraW1AbnZpZGlhLmNvbSB3
cm90ZToNCj4gPiArc3RhdGljIGludCBtYWNzZWNfdXBkX29mZmxvYWQoc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IGdlbmxfaW5mbw0KPiA+ICsqaW5mbykgew0KPiA+ICsgICAgIHN0cnVjdCBu
bGF0dHIgKnRiX29mZmxvYWRbTUFDU0VDX09GRkxPQURfQVRUUl9NQVggKyAxXTsNCj4gPiArICAg
ICBzdHJ1Y3QgbmxhdHRyICoqYXR0cnMgPSBpbmZvLT5hdHRyczsNCj4gPiArICAgICBlbnVtIG1h
Y3NlY19vZmZsb2FkIG9mZmxvYWQ7DQo+ID4gKyAgICAgc3RydWN0IG1hY3NlY19kZXYgKm1hY3Nl
YzsNCj4gPiArICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2Ow0KPiA+ICsgICAgIGludCByZXQ7
DQo+IA0KPiAgICAgICAgIGludCByZXQgPSAwOw0KPiANCj4gT3RoZXJ3aXNlIHdlIGNhbiByZXR1
cm4gd2l0aCByZXQgdW5pbml0aWFsaXplZCB3aGVuIG1hY3NlYy0+b2ZmbG9hZCA9PSBvZmZsb2Fk
Lg0KDQpBY2sNCg0KPiAodW5mb3J0dW5hdGVseSB0aGUgY29tcGlsZXIgd2FybmluZyBpcyBkaXNh
YmxlZCBpbiB0aGUga2VybmVsIE1ha2VmaWxlKQ0KPg0KPiBbLi4uXQ0KPiA+IEBAIC0zODQwLDgg
KzM4MzcsMTcgQEAgc3RhdGljIGludCBtYWNzZWNfY2hhbmdlbGluayhzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2LA0KPiBzdHJ1Y3QgbmxhdHRyICp0YltdLA0KPiA+ICAgICAgIGlmIChyZXQpDQo+ID4g
ICAgICAgICAgICAgICBnb3RvIGNsZWFudXA7DQo+ID4NCj4gPiArICAgICBpZiAoZGF0YVtJRkxB
X01BQ1NFQ19PRkZMT0FEXSkgew0KPiA+ICsgICAgICAgICAgICAgb2ZmbG9hZCA9IG5sYV9nZXRf
dTgoZGF0YVtJRkxBX01BQ1NFQ19PRkZMT0FEXSk7DQo+ID4gKyAgICAgICAgICAgICBpZiAobWFj
c2VjLT5vZmZsb2FkICE9IG9mZmxvYWQpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgbWFj
c2VjX29mZmxvYWRfc3RhdGVfY2hhbmdlID0gdHJ1ZTsNCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgcmV0ID0gbWFjc2VjX3VwZGF0ZV9vZmZsb2FkKGRldiwgb2ZmbG9hZCk7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgIGlmIChyZXQpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgZ290byBjbGVhbnVwOw0KPiA+ICsgICAgICAgICAgICAgfQ0KPiA+ICsgICAgIH0NCj4gDQo+
IG5pdDogdGhlcmUgd2FzIGEgYmxhbmsgbGluZSBoZXJlIGluIHRoZSBwcmV2aW91cyB2ZXJzaW9u
LCBwbGVhc2UgYnJpbmcgaXQgYmFjay4NCg0KQWNrDQogDQo+ID4gICAgICAgLyogSWYgaC93IG9m
ZmxvYWRpbmcgaXMgYXZhaWxhYmxlLCBwcm9wYWdhdGUgdG8gdGhlIGRldmljZSAqLw0KPiA+IC0g
ICAgIGlmIChtYWNzZWNfaXNfb2ZmbG9hZGVkKG1hY3NlYykpIHsNCj4gPiArICAgICBpZiAoIW1h
Y3NlY19vZmZsb2FkX3N0YXRlX2NoYW5nZSAmJiBtYWNzZWNfaXNfb2ZmbG9hZGVkKG1hY3NlYykp
DQo+ID4gKyB7DQo+ID4gICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgbWFjc2VjX29wcyAqb3Bz
Ow0KPiA+ICAgICAgICAgICAgICAgc3RydWN0IG1hY3NlY19jb250ZXh0IGN0eDsNCj4gDQo+IFRo
YW5rcy4NCj4gDQo+IC0tDQo+IFNhYnJpbmENCg0K
