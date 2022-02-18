Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A904BB3D9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiBRIDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:03:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiBRIDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:03:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2138.outbound.protection.outlook.com [40.107.236.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6721F29B9E9
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:03:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2dmfcnXP24PpMry3TE7UGlheVgAFCA4u3lBo4Zoh60Wg2LTICCQVABd8GfjhnpqiDHptyqo/lUkLlXFviRDb8WmQZ/Y+aT9TruEMMNtwtX7DBK8ad3Pyc/CGrRy4hgnyc0mw/WPi+a+y925ZETo7hxK7ffUfNW0Zy9mmal4xCMGFFAlgTIXSwi/OFq75Bbd9HMFWEP/voVVjpKpZbZFQ7gDwfZcdw5ZsNuTMwkzGpmT8hlDZhCApF4eMLhGKu2K0rQGDORcb8XB/ISPngQJ8/iw5yYW2FBylAdOxbn1USn3ybNzk1Jesw9UYHq75sV6v2TDB4nv1jypJRwNswvEXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jC22Uf8142hbRwkAMG8IY8HO/AF8X7iXvYH9knH1nKQ=;
 b=BUo+PlgNsgugHRHt/neP53QejXIhFqNhGoUVpcmS4OWeTS6GGdnEYPrnPPQCG7LlwSzpA+mkndYffzUGaFVQIrZQxSEuxjNpIppksmNGIgOn6W1jbPRiBISxlnI6ItZt2GtVo7P5Bb+nuGFkslqwKXOtLV5/rX7R52+E9DtPLvTl238F1t0QJc0kRYdYmkWhctGHWLdgeK1hGOl4PzDcOAL4EZI4o6M/iO3MWM9QtGy36RbUMkD2HFpRcQlX5OQIKhFWWfdblNCddSzKCP4EkGyDdSmJfAg7FabD4ss2HuWdd91vUD0hMQuTMoJp/Dwl4Wm3h8UFngirg9KV38X0mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jC22Uf8142hbRwkAMG8IY8HO/AF8X7iXvYH9knH1nKQ=;
 b=VHYLRfjSPjLE/dLJTMq67EsFqNFyOFEQUsgw3VjZe394Gltpu+8YYNZtMAx+2UwtmJnstLdZGIz3BBUuJlmuzBpoXcPStwHPkl5ijrwavwEDe5PLWqwrSO+nJDui5c3CisrScIefbl6Q6lSK4+A9PEwynMIZhlEG4s3ycdIyxVI=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BY3PR13MB4961.namprd13.prod.outlook.com (2603:10b6:a03:36d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9; Fri, 18 Feb
 2022 08:03:10 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5017.007; Fri, 18 Feb 2022
 08:03:10 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 2/6] nfp: add support to offload tc action to
 hardware
Thread-Topic: [PATCH net-next 2/6] nfp: add support to offload tc action to
 hardware
Thread-Index: AQHYI+0ghOHsaj0R4kuQVc0RHZvk76yYu0QAgAA3oVA=
Date:   Fri, 18 Feb 2022 08:03:10 +0000
Message-ID: <DM5PR1301MB21723E0751D556E87ADA4EDFE7379@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
        <20220217105652.14451-3-simon.horman@corigine.com>
 <20220217203948.7eb7835e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217203948.7eb7835e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4c907e4-9411-4a5e-4280-08d9f2b51b1d
x-ms-traffictypediagnostic: BY3PR13MB4961:EE_
x-microsoft-antispam-prvs: <BY3PR13MB4961FEE650C902A75FA046C4E7379@BY3PR13MB4961.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4w3Fj2NlpifAhFiuaKvmG2P+ikLE2hsvPVR8QIm5MwymZNH1SbfVK8K9E9CNCUKI21Gf8SpgOZLDa7YIKm6ZnSa26vwzRDLr6gPvKGdCdtohwkTNdwOHY45NEUFzSorwMc7yExccbuWIwyoO+Cz7QPD+GEqdiHXBviDX70pVZWNTFF5sw5f5Wsyj3rZj3yIhqgiBvUL8Wmr+Fuklcjpp11CLNLQP8Q14lgX4RIVP7+VTC5PQoCNrPeTX6/nOA2JGtcFMVK7e2ohY4AQrbAAL3xnfTvKa1RyK4ATdFtM++71CMyDWGx8EzSG1EJJ2uz+GQ0perKpXLaxJFjqxNHe4yrMKiRzPiGlffSL2zh/Ink6PAh7Z+F/0tNcIld5HwDCWpLCRXr7CgMpr+o1metzQphCdNb0MP+2ogPgNDUNEZQuh4Qv3Q6lalpLVUyd4akOnsZkmgBLhpyQy7wG2aLO5rmamb1sAWOBGM7hCPyhwtOCkGAbzs94yiauXdeEa3SPHCKVk0cq5sJegRYabkWCUY61eWxFMJBeDcdaEIe1GuNe//3QHZVfzCptLBxfWTWg3WrklaZQUn7TYl+RkR+0t029IEnt1KzvDy7bjD+639xB0dywpkIepzStzJ5z27HQlnYswoOQVwunKJ60vTH/Y1EjztvP9eQYR/p8TlZiiUjbz+Oj4Hf1JnnBmwq9DqESSmnU7mkRBlLQhAcZ9WsLVdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(136003)(396003)(376002)(39830400003)(8676002)(64756008)(66556008)(66446008)(66476007)(6636002)(76116006)(107886003)(33656002)(55016003)(4326008)(66946007)(71200400001)(38100700002)(26005)(316002)(86362001)(38070700005)(122000001)(8936002)(2906002)(52536014)(9686003)(6506007)(7696005)(508600001)(110136005)(54906003)(5660300002)(44832011)(186003)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2d6ZjNZWmpVa1MvSlYzb2ZLRzNidnFVcWxqZDFmZHMrNVdOM3VQWSthTHZo?=
 =?utf-8?B?VnZzN1J0VUdza0NxSlBZZXJZRDlsek5SY1VwcFMvd0VHR2dlZE5wRUE3K3NJ?=
 =?utf-8?B?OTBJUmk2ZjhaVE00K0pWZVZmLzV3MnZsYTRyd2xoZERUNE9CZjd3WTRDbnlT?=
 =?utf-8?B?dVMvRmpQbFZIYWM2dXc5L1MzZDlIV1ZPdHNld04yMEFIMml5R2EyMkIvMHcx?=
 =?utf-8?B?UmtybE5uRmFCYk1HN21ydjFFSzlLa2FpdUk4QmxpUGRMckxIM0xsZ0VqTUR6?=
 =?utf-8?B?WFhsSHhlcGRVQjhndUgyd3dVdW5jWEdScUpjS2pnZ3k2c2RUY1VZbTMyRm9n?=
 =?utf-8?B?d1ZRQTg0NS9xZ01hZWNNb1R6Qm9qVm1LQU1NRW5hVnk2RUNvSmdBck1hL295?=
 =?utf-8?B?T3dFUG8zSU5WeWZZK21KcTZmWXQ2aVVSQ29lWWEwN2VCbGR3ZzdSeWF3WWt2?=
 =?utf-8?B?dk1lMXFEZFlqOERwbDZVRGlkRnlFU096RjA3RFc5QXdZQkd4WE5zdDQzTzYx?=
 =?utf-8?B?eHk3ZUlSVEt2cVpGMnFEc3hkQnEzemIvb0FkMll2R25TY2dpekF2UjJtRzlj?=
 =?utf-8?B?L1Q3eWMwR2gyNUxhQ1g5RkhHM1d4T3hBb2ZSMUVnN01qTmt5QTlQVUNCU3VS?=
 =?utf-8?B?TnJwc0s4L1ZaUHJiQTVCZHYxcCtNdjc1bGZ6YmdXNDVzV2o1b0kxamVsSkZT?=
 =?utf-8?B?bXpKc09SQWJBR283aCt2Rjk2ZEZ2VHIzOE9vdlNlRVJEZG42R3I0M0JxUmp4?=
 =?utf-8?B?cFJWVXR1aFl4UTR3ZnlXT24wV2MzbXFaL0JVR2plbnU3TXM1T2l1eTc3WCtQ?=
 =?utf-8?B?cGZVSEdqZG02QVU0YnQ2MTA5UStUdWFHb0RFRVMwc1pwSUxBQyt6QVpjSUlz?=
 =?utf-8?B?c0poZ1lTSlNpRFFWd1lZNjB0a3RjSnphdkdlaGJpYWJqNFlEMUhqZXhBSUJ4?=
 =?utf-8?B?RDBWZmk0NHduY1NybVFvOGYvY1piWi80TnNPR3dWWVFEdkIwUTJyZ3pGNWJl?=
 =?utf-8?B?OXpnTEZCWitqNVdGd2lHTDh5clVRcmFsYU90OGtrZlBQSjBBTE9MZEdwSHJV?=
 =?utf-8?B?MmRuTE9Fd2lEemVVTFM4QTN2OHJNUWRGUXhseFNGME5NcEpjZ1JUQXFJcFJJ?=
 =?utf-8?B?THFrU3NVNlFiK2JDdnZSNU45SEsxVGh5VWdScmdGVE5Od0RCYmM5czlWWEVz?=
 =?utf-8?B?UW5kM3A5WjFEK2RiTHZnc2RSM1orUVBWQW9SRmZsc1N3VFZBOHArSUxMNVFx?=
 =?utf-8?B?cGZPM0Y5K2VFUHFmSGkxZjFXWFRQelVkTi85OFo1eENPczlEYjQ3eTJVeWRt?=
 =?utf-8?B?OWtJQnRaQVF4NE1tTVNoK3BLMFMzTW1PWDVEQjUwbGJsbHo2MVNVTWNyeHNS?=
 =?utf-8?B?TXp3Q2xFamRXeFBLS0VBRDNKTi9FZm1UVVR3ZWhsTGN4a1RVS01mRytUV014?=
 =?utf-8?B?ZEo1RWNUSWVma293V01hYU41b1QyQVlsdnlHalU3b0FnZTh5amV6NXFlekd1?=
 =?utf-8?B?SHpETXVCSWxQOW5zMnhSVS91NW1tZU13UENNRjluaWJQV3RlM1FJMUdBcHJZ?=
 =?utf-8?B?cE5BM2Z0RldDZzdSdGV4aVdOQmRRNkszVWFvVU81SW9jQzJEZE0zakRmUmxG?=
 =?utf-8?B?YnBZZzB5OTFxNUhuRWozUWRLRUZOUi94L1hZclNyaHA2UnVtRUVSYkJVWTdr?=
 =?utf-8?B?a1B4MkJLQ1BtZGdnUHhrVDRtV1ArM3lsV0pOUll3aTJDbFBUbXNCN2FWTEl2?=
 =?utf-8?B?b0MzVWNCVTVBTGJKYnkwc0t5K3lBekcyUU8rOFQ3TUZXUSt6NFpvbXdDQ0pm?=
 =?utf-8?B?WTRxcDZQSFRPQWxTVVUrbVNFbGJVTktKeHdXQjRYU1V3ZjFnSTZ1SzJWdHgy?=
 =?utf-8?B?MFdscXFwc1JVRGRZczBjNFpyeDZSL0xDTDViWjE5N0h0V2VGTEIyeUFCRDdS?=
 =?utf-8?B?OENHeUU1NjVTU0x6aVFpeVpJelhscUlTRVJFakh1d3E3VU1HMUppM29vd1BX?=
 =?utf-8?B?K2QvU04zeE5VdTZSQ2VlZkkraHM5WEtyUDQ4VFpIYzA3d1g2U2dWUUlja1Q0?=
 =?utf-8?B?S1VqZWR4enZ4ZVNDWXE4Y0FrZjM0VzE0RDdGOEJBVnMra09Vcmc0T0UvejZY?=
 =?utf-8?B?UjVLdGVyN3J6cEdsK3BsK1kzT1Rac09tS1QvdHRXRzRPV2NOTFN1aTExSjlG?=
 =?utf-8?B?RzdmSmpTMTlkSFJJUWpDbGlYMGJQOWVFQ2RpR0JzL1o1ZW1lOVZFdG1ZaUhX?=
 =?utf-8?B?c1ByZW9ZbUpoekZVZU1oVjlWaGpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c907e4-9411-4a5e-4280-08d9f2b51b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 08:03:10.6915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZxGHMlY4YNNcHRkLkYhSaHJ6sPPtFpOyqD6iAkqc626ouXV3fhrA80VXtZmnxfLpoKbRbcNxVwn3M5MIIkcJJwOReZSjadM/2ZoX/jSzX8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4961
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBGZWJydWFyeSAxOCwgMjAyMiAxMjo0MCBQTSwgSmFrdWI6DQo+VG86IFNpbW9u
IEhvcm1hbiA8c2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbT4NCj5DYzogRGF2aWQgTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsgQmFvd2VuIFpoZW5nDQo+PGJhb3dlbi56aGVuZ0Bjb3JpZ2lu
ZS5jb20+OyBMb3VpcyBQZWVucyA8bG91aXMucGVlbnNAY29yaWdpbmUuY29tPjsNCj5uZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBvc3MtZHJpdmVycyA8b3NzLWRyaXZlcnNAY29yaWdpbmUuY29tPg0K
PlN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMi82XSBuZnA6IGFkZCBzdXBwb3J0IHRvIG9m
ZmxvYWQgdGMgYWN0aW9uIHRvDQo+aGFyZHdhcmUNCj4NCj5PbiBUaHUsIDE3IEZlYiAyMDIyIDEx
OjU2OjQ4ICswMTAwIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4+ICsJaWYgKGFkZCkNCj4+ICsJCXJl
dHVybiAwOw0KPj4gKwllbHNlDQo+PiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+DQo+CXJldHVy
biBhZGQgPyAwIDogLUVPUE5PVFNVUFA7DQo+DQo+b3IgYXQgbGVhc3QgcmVtb3ZlIHRoZSBlbHNl
LCBldmVyeXRoaW5nIGFmdGVyIGlmICgpIHJldHVybjsgaXMgaW4gYW4gJ2Vsc2UnIGJyYW5jaC4N
ClRoYW5rcywgd2lsbCBtYWtlIHRoZSBjaGFuZ2UgaW4gVjIgcGF0Y2guDQo=
