Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17876778D5
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjAWKOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjAWKOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:14:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6CBEC69
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 02:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFaGIMiKwF+dIUR8vnK8cEa51ofA3tpwKw2xvGcIaqQ1/rIehfnJm6y23/63NOV2QZ44Qcw2zlduiQ7VvDx9VkPAnezIazCwySBQzBukIJhrV1ZSBpltoExEdf8JN1ublje2jBr8ykILLGIcja1uJ5mQ0ZHLTBvaQTG/LNB5HkklYWSaQP9ZYjFM3wQEIZKcUDc7LKt5tOLwe6Ch1yQfbgBayz9I3tbG57BtbLzQecgEHM1IDukAMuGSKaJHm34sjL1uNT/hy5uUVx15TYC3dGB1qwQYriWko+DgFFB3B8qPU5P7BJ989++LIJGF92oxro3tj+hTz9cQwJHh6z+3Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws6JJZpPAyphXjOKil1kdsHWH6JOrlYSEvzK0SfWbh0=;
 b=nrmuMtUpL/6uzaCTSA2Tl4tzqWqHIV+sWL04t4tQhu5uE5g+JHrmK5vXr9ZPy6YtdIERhyIr8bCIw1h417dBXTQfC6A70CzQ5hUdnMvCYYxlhq+oyu7oaPiC+qE5Yb9VH3luPD3Un78WoV51S8ASNhAP3o7Da++J0aUQJRSeXOB6YPV52pDykbMDY7tdMXv4pQM3tFpo+LKtDWMBBbG/PCkOhcDAu0M18qsinLB7uAnUzpTzEqZlTJOUAqC9GfhML5TGMI6DWX2Su/aclOo0HoFGab5l1g+4amf8W8gg5dHNhO4zUZdxPJ/Q5ECUcAK7gmhg4OZBbQbUkcnlNisePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws6JJZpPAyphXjOKil1kdsHWH6JOrlYSEvzK0SfWbh0=;
 b=Xd6XFgo7hpo02yLiUmclQ4uX01+q2Do+5EQ7ViWkIGmBoCROpACmUNkk2FxnMXnguF8O4Ia7Qc1/+qJJMNIzRwgpGRsbbrntMCUgFJwouMc0XXoW3uEI4KnIsscU+dZ6sJBR79LHYLBUXJvgpXUKO/5wJ1a90l1PQHD+r3/jVxjRlaLYedwJX/HdWvMOO7mPiFR4BJcCgBj1hNuTIgi306vtBYQQsEG87tDmXRdJUujFGDNLy9mbXSnsoLDMT3K0JqbLDUQVO63xlURC0hSZCLY5h2BN7IH9jRUdLFfIkMf30Z32fh03k/RGXl81pkYrHxTI9Z2imdu/Ww74oIqiNA==
Received: from BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6)
 by MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 10:13:58 +0000
Received: from BL1PR12MB5286.namprd12.prod.outlook.com
 ([fe80::db3c:8645:45d9:50c5]) by BL1PR12MB5286.namprd12.prod.outlook.com
 ([fe80::db3c:8645:45d9:50c5%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 10:13:58 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Tariq Toukan <tariqt@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Frantisek Krenzelok <fkrenzel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Thread-Topic: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Thread-Index: AQHZKnpHsd19608HRkW/Wa/fUIyV4K6jbUOAgACG1ICAARnmAIAAbaaAgAZWPoA=
Date:   Mon, 23 Jan 2023 10:13:58 +0000
Message-ID: <bb406004-f344-4783-b1f0-883d254f2146@nvidia.com>
References: <cover.1673952268.git.sd@queasysnail.net>
 <20230117180351.1cf46cb3@kernel.org> <Y8fEodSWeJZyp+Sh@hog>
 <20230118185522.44c75f73@kernel.org>
 <516756d7-0a99-da18-2818-9bef6c3b6c24@nvidia.com>
In-Reply-To: <516756d7-0a99-da18-2818-9bef6c3b6c24@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5286:EE_|MN0PR12MB5979:EE_
x-ms-office365-filtering-correlation-id: 4a42cc47-baac-4a01-f6d8-08dafd2a8a8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: heZ4I0GOWP9drpDeJjL5+ud0NCukuCiOxThCZGbM8jpmZavWdB65w36HGq6zmmtGUQdft2ZbtMrk5CQ8morVk2yTh59tTeQaqB7neH033LVt55ZQ5Mx2lZM2HVg50uf/j1i9h7hvoh+aP0fly0yiu70q7CUpJ5ulpxDgL80LqxTUUj1itetlbDNeu/Cq8+qLNyh92B8/aP7w4tGKDUg1AWIGCAc3ShksKu+Af2ZOdEezBhsxwRmUcGjYwOu1cFFFusGutvwxlr0LqU7wbBrWr4kfX7BGNJYhabbbuEryX/OwjkM/QmajMz7ga/esgXD1U/ktj9wKI0f2L9w0sDED4V/3imK5SqNay3VvQELmsG+qmIwIC+notuSCJmA0PRV+lNBna810RzHFBW0K6mgL3GRNRVzLBA+20RSccaPaOvtUVkquOKBc1Rkm39AiuqaRcrFEWjnw4Cs0lZCuwKra+ZRMZa425C7iP/pmkwypjK59KyQwcmlkE8e0CcqXzHp7Y8xTht5hA8Zul/YJ+0+CE4pHeTgUXKdp4ELiuL4k4tVnjkm2I+CLfYl+V8d/eqNmaJCV4aS2lnJTrshxvT2UCakyW4D0cV/K5loUQB9GgFeUrTMwtKOdyyGPP4f3jZ6306KpDb5/u9+OEJ/L2rGbhwK/3y7ypVqePe01Zdb+Lk9k8jaYHWzqheyxSUrKofFTBEmDTbM9HGjLsuFzB78XzInLCVQe24dMrwrMaKkmmoKL6ojxWPsEMxZ/uJUmKnkj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5286.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199015)(54906003)(26005)(6512007)(186003)(110136005)(2906002)(6636002)(2616005)(478600001)(36756003)(316002)(6486002)(15650500001)(38100700002)(53546011)(122000001)(71200400001)(31696002)(86362001)(38070700005)(83380400001)(41300700001)(6506007)(4326008)(5660300002)(31686004)(8936002)(91956017)(76116006)(66556008)(64756008)(66946007)(66476007)(66446008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnZ1VXA1bXJZY2VFcEY4dndYeEVyMUtJeXIrcXNrc3c0N2x2bnRaNUFZa3FF?=
 =?utf-8?B?amtyKzZXSVd0cllKcTBKd1FzVmZtTDBVVTNUK0gxVGxxVjNFYmIvQkpHQURS?=
 =?utf-8?B?ZDJVSmRQaG1ZVDZzamk0aGg2L0R6ZFI4Y0U0T1dIQUhtbEk0QldvZ2pseTQ0?=
 =?utf-8?B?Zm9CRDN6eittOU9aR3NLVUp0clBDY3ZIM1NwRU5GMmEwSHJ1akJxWVFHZXht?=
 =?utf-8?B?cGFxODAzS20wZG9CY1A0SzhtTkV5M2hnSVQxdkZiR3I5Wnd2RjBHT3B6QWtV?=
 =?utf-8?B?NnhVdGFpZmRJZndWM0VUODJoMWRiVHlwWEZoV1U0c3VTM0s3clg0a3YxZnU1?=
 =?utf-8?B?RU9FNmlhalJjM3YzQUdHL3g4R0pqSnRFQ3Era2M2dXFiSFRlTVc4ODRxVFZt?=
 =?utf-8?B?YWg0Mk1QT2JySEhSSVpnajBDN0FiM1M4V2hQZ2RxaitHL3RuVC9QaDJwV0cr?=
 =?utf-8?B?TzRBT3BUbng1WVFFU2JoYWt4RkFFOWYvbEl5OTA3NVgzdk9PMEZUZklMVzB3?=
 =?utf-8?B?RmUzT2lEQ2pGWlZWVHArZ2J6ZmxkUGVCSDN1RXBKZnFxV1U4ZU1lWG9mODNo?=
 =?utf-8?B?dW5JNHJSZlhWbmFScGQxeUVyaW5tTjhyN3lSUDNWREJhM0NrdXYwVmpzREgv?=
 =?utf-8?B?bDUxUmtaQ0U0QjBVNmdvVWZWQ0xqY3d2NTY1c1d0dUtEMno5TGxhWGo3TDhm?=
 =?utf-8?B?WXdMbTExT01FM2JiTE01NnZFak9Fb1JHN3h6VjQ2L1duZGo4MVN3VlFHK0po?=
 =?utf-8?B?dnozSzdQSEU2K0FzYjBPUm91RzFpR2ZacE5uQ25EdGRUVW9sNjg4T0xzN3Ju?=
 =?utf-8?B?eUx1MXRoZWlCU3hic2htVTAva1FBVG9wV3pFVTlNVlA4K3MxM01Vbm1UdWRa?=
 =?utf-8?B?SEhPb1pWY1g1MUpHVlNqUnlCUUVqOEptZ1pjbGhnckJlaUsydkRJK21LU3o3?=
 =?utf-8?B?MFg5SERGK001OXEzTVU0MVY1SWFjNU8rY1RvZFh6ZzhrQlJpYUVuNUpGenFh?=
 =?utf-8?B?djJWTGlpc2tBS0xPY2UrRTFYV2t2Z2s5YmU3dFdVdE1HQlVWYmtRVnRNRlQy?=
 =?utf-8?B?R0JYbHhlTWE0N2Z6K0c5a2pXS2Z1Y1IwOENlaWJKaENWakJxRDJGMmZyN0Uy?=
 =?utf-8?B?S0RITUxob1FIVlFQaWd0K1JCam8xQmpPbi9sL1pHTHM3WWJNbm85NXhxcjF1?=
 =?utf-8?B?U2hXVFhLcFdVOU1jdEhlMWlYbEJMK0l0bURrZi9IQ3RzcCt6Z2I4RnlGQU1V?=
 =?utf-8?B?OWlkTlM0M3puWHljQ2NmQ3RZS0ZCT0Z6MWpZL2tDbEx3MTFkUVVna2FmbUwv?=
 =?utf-8?B?c1dEd1lIdS85NzdhQ3RRVVhxUlFOL1RVYkI3aWo2clhaQmF5MUluSVN2RC8w?=
 =?utf-8?B?dWN2cHJSMnpTR1ZOSTR5M0xqbjdSYVlZakxuOS9iVlBDVmdKK2g0ejhYemRG?=
 =?utf-8?B?dVlza3dJSGFDTkt0U211eW1IeDg5ZXFoM0JWRHVUaWJPem9JdFZUeERWQ2RN?=
 =?utf-8?B?V3RsYmtRRlBWckRPTGRCOVJoVmx0NnViQjF5dHFpcDZld3g2eHRQeXRjR2tY?=
 =?utf-8?B?SExIVUJMTVdNdTEveWNOVUYxcnlWbDZuZVcyeVI3QStzc2xKU015THpkaEJB?=
 =?utf-8?B?aW9tVC9NaFhRUWkwS2IwYU5uYjc4VHI0Q1kzeWdzWUNmQzhxdzY2Znp3Vmd3?=
 =?utf-8?B?Q1VxUzVXRUtKdG9LQUxJTWNoOXg0RGw2VjNkZUNDTXBGRHBWUDJMUWFrZEYx?=
 =?utf-8?B?RmhJY0o4SVhTMFNsTGY0bmlaTHNUMlI4bXNocG9FYUpyQlhoNStmVmJzRnZF?=
 =?utf-8?B?VXBQajVYNDd4RGFLeTBXekFRejNhUUpHcXFvQnNYUTVyWG9mVFBuRnlGQk1i?=
 =?utf-8?B?R1RFQXZiclFVS2JFRmtFb0k3ek9MZWp6cFZoWmhnRTF5M2ZldkQxN1ZtVEwy?=
 =?utf-8?B?UVVlY3BUSXFEUDJEa2tSeWxwSmlkQVRDRHQvYUswQTRuM3JGRXJsYThTbTlK?=
 =?utf-8?B?Zm96aStIcjFGWTFiSVZhaTByUjZtQlpsRSsvZE5uQ2pwSS8xbENTZE5pbWdC?=
 =?utf-8?B?L29zU0ZYbElneHpQL0l2dWVRSkNEK0JOTWtnMStGeGx5VDk0TFdYcy9UZEtl?=
 =?utf-8?Q?Dkso=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B79A8B27EA01B448C05BB1C4614F04A@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5286.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a42cc47-baac-4a01-f6d8-08dafd2a8a8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 10:13:58.0916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+eHEeb3S6OTUb1ixE1sRObaZ2MwvGrbxQQ2e6AHhn/4SS/7FR9ZDnpJC7XviQEdD1casBU+hKUj6mDamQl9iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5979
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkvMDEvMjAyMyAxMDoyNywgR2FsIFByZXNzbWFuIHdyb3RlOg0KPiBPbiAxOS8wMS8yMDIz
IDQ6NTUsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4gT24gV2VkLCAxOCBKYW4gMjAyMyAxMTow
NjoyNSArMDEwMCBTYWJyaW5hIER1YnJvY2Egd3JvdGU6DQo+Pj4gMjAyMy0wMS0xNywgMTg6MDM6
NTEgLTA4MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4+PiBPbiBUdWUsIDE3IEphbiAyMDIz
IDE0OjQ1OjI2ICswMTAwIFNhYnJpbmEgRHVicm9jYSB3cm90ZTogIA0KPj4+Pj4gVGhpcyBhZGRz
IHN1cHBvcnQgZm9yIHJlY2VpdmluZyBLZXlVcGRhdGUgbWVzc2FnZXMgKFJGQyA4NDQ2LCA0LjYu
Mw0KPj4+Pj4gWzFdKS4gQSBzZW5kZXIgdHJhbnNtaXRzIGEgS2V5VXBkYXRlIG1lc3NhZ2UgYW5k
IHRoZW4gY2hhbmdlcyBpdHMgVFgNCj4+Pj4+IGtleS4gVGhlIHJlY2VpdmVyIHNob3VsZCByZWFj
dCBieSB1cGRhdGluZyBpdHMgUlgga2V5IGJlZm9yZQ0KPj4+Pj4gcHJvY2Vzc2luZyB0aGUgbmV4
dCBtZXNzYWdlLg0KPj4+Pj4NCj4+Pj4+IFRoaXMgcGF0Y2hzZXQgaW1wbGVtZW50cyBrZXkgdXBk
YXRlcyBieToNCj4+Pj4+ICAxLiBwYXVzaW5nIGRlY3J5cHRpb24gd2hlbiBhIEtleVVwZGF0ZSBt
ZXNzYWdlIGlzIHJlY2VpdmVkLCB0byBhdm9pZA0KPj4+Pj4gICAgIGF0dGVtcHRpbmcgdG8gdXNl
IHRoZSBvbGQga2V5IHRvIGRlY3J5cHQgYSByZWNvcmQgZW5jcnlwdGVkIHdpdGgNCj4+Pj4+ICAg
ICB0aGUgbmV3IGtleQ0KPj4+Pj4gIDIuIHJldHVybmluZyAtRUtFWUVYUElSRUQgdG8gc3lzY2Fs
bHMgdGhhdCBjYW5ub3QgcmVjZWl2ZSB0aGUNCj4+Pj4+ICAgICBLZXlVcGRhdGUgbWVzc2FnZSwg
dW50aWwgdGhlIHJla2V5IGhhcyBiZWVuIHBlcmZvcm1lZCBieSB1c2Vyc3BhY2UgIA0KPj4+Pg0K
Pj4+PiBXaHk/IFdlIHJldHVybiB0byB1c2VyIHNwYWNlIGFmdGVyIGhpdHRpbmcgYSBjbXNnLCBk
b24ndCB3ZT8NCj4+Pj4gSWYgdGhlIHVzZXIgc3BhY2Ugd2FudHMgdG8ga2VlcCByZWFkaW5nIHdp
dGggdGhlIG9sZCBrZXkgLSDwn6S377iPICANCj4+Pg0KPj4+IEJ1dCB0aGV5IHdvbid0IGJlIGFi
bGUgdG8gcmVhZCBhbnl0aGluZy4gRWl0aGVyIHdlIGRvbid0IHBhdXNlDQo+Pj4gZGVjcnlwdGlv
biwgYW5kIHRoZSBzb2NrZXQgaXMganVzdCBicm9rZW4gd2hlbiB3ZSBsb29rIGF0IHRoZSBuZXh0
DQo+Pj4gcmVjb3JkLCBvciB3ZSBwYXVzZSwgYW5kIHRoZXJlJ3Mgbm90aGluZyB0byByZWFkIHVu
dGlsIHRoZSByZWtleSBpcw0KPj4+IGRvbmUuIEkgdGhpbmsgdGhhdCAtRUtFWUVYUElSRUQgaXMg
YmV0dGVyIHRoYW4gYnJlYWtpbmcgdGhlIHNvY2tldA0KPj4+IGp1c3QgYmVjYXVzZSBhIHJlYWQg
c251Y2sgaW4gYmV0d2VlbiBnZXR0aW5nIHRoZSBjbXNnIGFuZCBzZXR0aW5nIHRoZQ0KPj4+IG5l
dyBrZXkuDQo+Pg0KPj4gSURLLCB3ZSBkb24ndCBpbnRlcnByZXQgYW55IG90aGVyIGNvbnRlbnQg
dHlwZXMvY21zZ3MsIGFuZCBmb3Igd2VsbA0KPj4gYmVoYXZlZCB1c2VyIHNwYWNlIHRoZXJlIHNo
b3VsZCBiZSBubyBwcm9ibGVtIChyaWdodD8pLg0KPj4gSSdtIHdlYWtseSBhZ2FpbnN0LCBpZiBu
b2JvZHkgYWdyZWVzIHdpdGggbWUgeW91IGNhbiBrZWVwIGFzIGlzLg0KPj4NCj4+Pj4+ICAzLiBw
YXNzaW5nIHRoZSBLZXlVcGRhdGUgbWVzc2FnZSB0byB1c2Vyc3BhY2UgYXMgYSBjb250cm9sIG1l
c3NhZ2UNCj4+Pj4+ICA0LiBhbGxvd2luZyB1cGRhdGVzIG9mIHRoZSBjcnlwdG9faW5mbyB2aWEg
dGhlIFRMU19UWC9UTFNfUlgNCj4+Pj4+ICAgICBzZXRzb2Nrb3B0cw0KPj4+Pj4NCj4+Pj4+IFRo
aXMgQVBJIGhhcyBiZWVuIHRlc3RlZCB3aXRoIGdudXRscyB0byBtYWtlIHN1cmUgdGhhdCBpdCBh
bGxvd3MNCj4+Pj4+IHVzZXJzcGFjZSBsaWJyYXJpZXMgdG8gaW1wbGVtZW50IGtleSB1cGRhdGVz
IFsyXS4gVGhhbmtzIHRvIEZyYW50aXNlaw0KPj4+Pj4gS3JlbnplbG9rIDxma3JlbnplbEByZWRo
YXQuY29tPiBmb3IgcHJvdmlkaW5nIHRoZSBpbXBsZW1lbnRhdGlvbiBpbg0KPj4+Pj4gZ251dGxz
IGFuZCB0ZXN0aW5nIHRoZSBrZXJuZWwgcGF0Y2hlcy4gIA0KPj4+Pg0KPj4+PiBQbGVhc2UgZXhw
bGFpbiB3aHkgLSB0aGUga2VybmVsIFRMUyBpcyBub3QgZmFzdGVyIHRoYW4gdXNlciBzcGFjZSwg
DQo+Pj4+IHRoZSBwb2ludCBvZiBpdCBpcyBwcmltYXJpbHkgdG8gZW5hYmxlIG9mZmxvYWQuIEFu
ZCB5b3UgZG9uJ3QgYWRkDQo+Pj4+IG9mZmxvYWQgc3VwcG9ydCBoZXJlLiAgDQo+Pj4NCj4+PiBX
ZWxsLCBUTFMxLjMgc3VwcG9ydCB3YXMgYWRkZWQgNCB5ZWFycyBhZ28sIGFuZCB5ZXQgdGhlIG9m
ZmxvYWQgc3RpbGwNCj4+PiBkb2Vzbid0IHN1cHBvcnQgMS4zIGF0IGFsbC4NCj4+DQo+PiBJJ20g
cHJldHR5IHN1cmUgc29tZSBkZXZpY2VzIHN1cHBvcnQgaXQuIE5vbmUgb2YgdGhlIHZlbmRvcnMg
Y291bGQgDQo+PiBiZSBib3RoZXJlZCB0byBwbHVtYiBpbiB0aGUga2VybmVsIHN1cHBvcnQsIHll
dCwgdGhvLg0KPiANCj4gT3VyIGRldmljZSBzdXBwb3J0cyBUTFMgMS4zLCBpdCdzIGluIG91ciBw
bGFucyB0byBhZGQgZHJpdmVyL2tlcm5lbCBzdXBwb3J0Lg0KPiANCj4+IEkgZG9uJ3Qga25vdyBv
ZiBhbnlvbmUgc3VwcG9ydGluZyByZWtleWluZy4NCj4gDQo+IEJvcmlzLCBUYXJpcSwgZG8geW91
IGtub3c/DQoNClJla2V5aW5nIGlzIG5vdCB0cml2aWFsIHRvIGdldCByaWdodCB3aXRoIG9mZmxv
YWQuIFRoZXJlIGFyZSBhdCBsZWFzdA0KdHdvIHByb2JsZW1zIHRvIHNvbHZlOg0KMS4gT24gdHJh
bnNtaXQsIHdlIG5lZWQgdG8gaGFuZGxlIGJvdGggdGhlIG5ldyBhbmQgdGhlIG9sZCBrZXkgZm9y
IG5ldw0KYW5kIG9sZCAocmV0cmFuc21pdHRlZCkgZGF0YSwgcmVzcGVjdGl2ZWx5LiBPdXIgZGV2
aWNlIHdpbGwgYmUgYWJsZSB0bw0KaG9sZCBib3RoIGtleXMgaW4gcGFyYWxsZWwgYW5kIHRvIGNo
b29zZSB0aGUgcmlnaHQgb25lIGF0IHRoZSBjb3N0IG9mIGFuDQppZiBzdGF0ZW1lbnQgaW4gdGhl
IGRhdGEtcGF0aC4gQWx0ZXJuYXRpdmVseSwgd2UgY2FuIGp1c3QgZmFsbGJhY2sgdG8NCnNvZnR3
YXJlIGZvciB0aGUgb2xkIGtleSBhbmQgZm9jdXMgb24gdGhlIG5ldyBrZXkuDQoyLiBPbiBSeCwg
cGFja2V0cyB3aXRoIHRoZSBuZXcga2V5IG1heSBhcnJpdmUgYmVmb3JlIHRoZSBrZXkgaXMNCmlu
c3RhbGxlZCB1bmxlc3Mgd2UgZGVzaWduIGEgbWVjaGFuaXNtIGZvciBwcmVlbXB0aXZlbHkgc2V0
dGluZyB0aGUgbmV4dA0Ka2V5IGluIEhXLiBBcyBhIHJlc3VsdCwgd2UgbWF5IGdldCBhIHJlc3lu
YyBvbiBldmVyeSByZWtleS4NCg0KSGF2ZSB5b3UgY29uc2lkZXJlZCBhbiBBUEkgdG8gcHJlZW1w
dGl2ZWx5IHNldCB0aGUgbmV4dCBrZXkgaW4gdGhlDQprZXJuZWwgc3VjaCB0aGF0IHRoZXJlIGlz
IG5ldmVyIGEgbmVlZCB0byBzdG9wIHRoZSBkYXRhcGF0aD8gSSB0aGluaw0KdGhhdCB0aGUgY2hh
bmdlIGluIFNTTCBsaWJyYXJpZXMgaXMgbWlub3IgYW5kIGl0IGNhbiByZWFsbHkgaGVscCBLVExT
Lg0K
