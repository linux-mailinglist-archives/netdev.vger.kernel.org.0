Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C3C6D789A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbjDEJli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbjDEJlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:41:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4109FC3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahePwiTyVE5pCBLzHYx6lWhRM5Ht5vC+M0DIlkR8VImHI/HAg6LyWJwBKOf2/4LUHZUSrTb0kwwKJy1Xzez7qDYOg1WDh/t3GGxx/FcZQ446Fgx0blOKN/L1qZ6RQ5Sg8+2j6Xq82j85f6zWQJ77W991PuBSQZ13K2KA9ghDEiXLPo9kDPYYm5qSXe4a2ZrQTSFJIOehKSkC+aKVQgEzfQxX+NRLKr6IZ5wZYEHWpBXakbJLAiaBgTorYZngqlHV+9P0X6JREdioKsZuon/F5tSAUS/qt6rjTXnEM1fiPRVCVVtBgku5lxikP9+tZ+B2hBxIgpXDmrElGeReVVMsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlmE9f3pmMuITSy64/wJR5CVJNUVp5Ws5ta8FxyJvIs=;
 b=DmE6IZ9hY8HXfW7iHqOXeqn+IjHJNa7dGzgD5/2qILLerg8TX0tJUSxjGVtL5LW0a6O2T04ob68Nq38zbejwJBkLSrc3U9AT3j7K/RrIBDmoRYuxJGD+Vq+CLj4icwLQ23rsoq1pDTeyLc3t0r7nptntfegluC6mHhuEIxJ+9VdJJbiYoRxBUXwIOtoPiNgjqlqUxR+V/uLeOOuBjEN/97SMxvcHssCp50c38eW6xXMHztWxDHFmogCEVUwTAppjIycGCfQK72503Bp7n9ka2kzj+dFSRw8C96ietovVhINXwdnFx8yQ0L2rZ5CPgvYege1bK/m6ukTcfMD3w63wDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlmE9f3pmMuITSy64/wJR5CVJNUVp5Ws5ta8FxyJvIs=;
 b=tVpuy1jQ3cHcKot4tHHAlRkyOi/+pO9KeJbxap9CfmvmSOX/3fudy+AZBR9jbxyN4wqPAp8NEBo9Cn+0GqmbGycwPpF7NBOHW9Tihb1reEanG8gr+NWAdu/qrQOB2Ir3uoDi5tUS6sSi5eUZ7C997yQivrS/vsZq0c+rIvjj+uONAWpZSJomUuPxdIxChodZAdq38XFlrR2UkOAS4NrwXyC6Var7yisB2ctJ/E0YWiH1o6CRVJzmWlil01Hql1WhvXMAjbB0H0Xd3JdxxT7k2Cf64WJihdAxB2q2GeShBR2uowhuamtpzIsKhWaUgbeOra6BHJbEVcwRgAtiOkMpkQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS0PR12MB7630.namprd12.prod.outlook.com (2603:10b6:8:11d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Wed, 5 Apr
 2023 09:41:33 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:41:33 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 4/4] macsec: Add MACsec rx_handler change support
Thread-Topic: [PATCH net-next 4/4] macsec: Add MACsec rx_handler change
 support
Thread-Index: AQHZYjkAG751iTRHWEKeeGez8eMpKa8cf3oAgAABYYA=
Date:   Wed, 5 Apr 2023 09:41:33 +0000
Message-ID: <IA1PR12MB63532F0ABDB8D2F34CBD8690AB909@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-5-ehakim@nvidia.com> <ZC1A4r9TtR8VP3sr@hog>
In-Reply-To: <ZC1A4r9TtR8VP3sr@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS0PR12MB7630:EE_
x-ms-office365-filtering-correlation-id: 111f12b9-7d51-4509-5473-08db35b9f151
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C+i37cGlpmpnP9mjoIyq/VyU71hrPsevucm98kaEWyGczmUh/qbN03fbHRJPhacav7N93uCrvRz/VCHiHYE0XPjAenmHW5nOEc620s8rQRFrjo3HQrctfyPbiBL3J56fF+u3gdd+JvcQrVDyoJQpcycvU5pw66EBfwlUNqC/k8GLs7s/w1CQFANMW9asUZsimmjqWRcJFQMcBA3S4g+qav9wnQqqgiYhL1WwnB9tWafjU9K5ci7FZAc/oz/A4298OLcdfW2JtEcfj2XI6L59ji8iqhzwfK+OuXpMk8AGLMH0lOkt1yg3AVdi0fFVaEg8gBY35gms/BI8XVS6iePSA+IrglFWQ7SXRobX0pZ571V5vktPQBQmeMicYr+2C/wT/MUNmr9TqjMYxXGAmEva+blK+gywElMB5p82YaFxbtuXRgJ/5x6t1As138IIHzzbWBrvmHEI419pu9Kvlhu7QpPpYeix4UB3coWhz0WjNrritkZvEAxCH2BaXz74XT9/tBX2FiCZN53GR9OFCwr4/TzjXkauBWvTlVAdMbe+DqXvmLcxFcryrdGVjojShmqQApYdr6r/ytYXPA9QtiBiEVlyGO3mk/jeC5hJi9qKNzG6uFo8C5VpxtPUnXwreJkt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199021)(71200400001)(55016003)(6506007)(122000001)(66446008)(66946007)(5660300002)(64756008)(66476007)(6916009)(478600001)(76116006)(66556008)(316002)(8936002)(4326008)(52536014)(54906003)(38100700002)(8676002)(41300700001)(186003)(83380400001)(9686003)(26005)(53546011)(7696005)(38070700005)(33656002)(2906002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?di9Kbm5jSkVPM085U0xIZFNwa2k2N0FCSTEzbm9jS0xXVTFSaGxXdk9LRXc3?=
 =?utf-8?B?b1BjMGErTG9lY25mN1B4OHlkMVdrQUYzZ3FjVjVFNytSWTY5bytuNGxFaWNz?=
 =?utf-8?B?L3h0Znd1OUpDby9kNHV4Mms4aHF1K2YrWUJZemt4SFgzclAvRFFXOVJSUnln?=
 =?utf-8?B?K29kTUhZZzFlcVlTemdSNjUxZzlpRGRlWkE1elhwQjlXbEJhUG41MHI5Z3o0?=
 =?utf-8?B?OTZJNXAyNHpLMDZBOWlMN3FUY05ya29vRUJwZ0JqNzFQTHZQbHVUMXU5dTFT?=
 =?utf-8?B?MWFjdWdtd0JKNGpQaXdjZ1FyeC8rOE8xbFM3Rk9HK3VLNUNVNzBzNUM5YmNW?=
 =?utf-8?B?eDNQdVYzanNIT1BrbktsWDhpR1BsUDJtK3gyc3drVjNlNldvZ3VOM29KdkFO?=
 =?utf-8?B?RkxDOGROZ3U2RjEvZlhLZXZkODJnd040Zy9ZWFkzMUVFWVZRTWt3M0VmNGxZ?=
 =?utf-8?B?bjJnSmFyazB6Wnp1M25IU3hpem94QjRSWmlmS0NxbVcvby9yZWd3bm4wY296?=
 =?utf-8?B?R3owbU5FUTkvUVMrM1BYTWNpd1lxaGxIMFF3cC9OaTJCK0ZwQzdlZFlLUk90?=
 =?utf-8?B?SjBhOFpFVTdUUjZKNzlsL2F1Ui85SWtOaXVveEtDb1YyOFdnT3lKRG1tYmVv?=
 =?utf-8?B?TGhxVWd3cmN5TG8yQzc4cFE2c3phMndWa2NYQ1kvN0hVUmRNc3h2dk1ZbVJv?=
 =?utf-8?B?TVdCNHJEcGIvRk85N0V4R3Q0Ukw5OTFmbEJNcStocklxQ1RDMHFyMDU2Nmc2?=
 =?utf-8?B?WjMrdXVCUVA4S2pGTXhHMm9Dc3p4VitsL1I2VkFqWTV0d1ZEVkpXN1NzaGRa?=
 =?utf-8?B?M24vOUlsYTY5ZnN1ZWxtdk5IRWduUmMrWExFMCtGaDhJeTYrendZZDVvb1do?=
 =?utf-8?B?ck8wZ2hyTWVlYjVmSjNRS2hqVTlrbmo2TUhINWtwRnFwRWh1QXJ3QlZPUjZO?=
 =?utf-8?B?TVNjaGY4QnZqbGQ3T1c0cmRwcGhtcE5kcEZyNHIzWEFQdjdKaDJibDYwalB3?=
 =?utf-8?B?YkJwRHVWZTdXRi8yZTkzdkxIUjFNZGZZRW1BY3RQZTBXQUNBZjdkbFNHSmcv?=
 =?utf-8?B?Tk14MmlEVUZWQ1JHQUtlRTJwaFFQWFBqYllMRWxkK1pnR2xSOEl5cGt6bytE?=
 =?utf-8?B?SE5HaXRuRndTR2NJS3Y0RW1rREplTFhzWlY1MWlNbEcvZ01jWnZ1Q1Zoa1BR?=
 =?utf-8?B?eUhxSEF2cEdmRmJVQU9jU1BqUDZKeEorb201cld5UXd1eldDUkdSd1BJNEJZ?=
 =?utf-8?B?OHRXUHRCRG15eDRtcGF6VTNhaE9ZY2tvV3NmbzdEN0V5RXFpbzlzRFB6OXFS?=
 =?utf-8?B?ZWpXWGpJR20wNXhhT0RPM0JCdzgwRGxiQXhVNmxWM3E3eVY5OTBPK0V0RjQ2?=
 =?utf-8?B?KzJmcXVPa29qWnpZVURHaVhsdFhENUduTStmT0FLRkdaSktQbjdmZUU4WVQ1?=
 =?utf-8?B?RTFoRU0vTzhmMm9JcUdEOUdxWlk3UTgzTTN6T0w0UnFvVnA0M3V1YnhwYTNR?=
 =?utf-8?B?a1NiRFJsdmRLOGRZcUNnODNqK29TWVY0YVJ2dVFCSjdtWUhNeUlxV3hEWWgz?=
 =?utf-8?B?QzB2dEhzTnB5TEQ1L2s0RE1QUDBHL0NwQ2kxVHVjbGtxdndPTUVEN1I0dXIx?=
 =?utf-8?B?bm1DR3VkTFBvQ0FrT1FNRExmbytpSjREeVVtMjdOWEVoWStMV2RxWW5nZ2Z1?=
 =?utf-8?B?ZkVvK1ZWV2pMYW1wS2ZFZHlGMDNZcWxQU2Zrd2Q2UDBNY0F4d2pnalFQUFRT?=
 =?utf-8?B?dXZxaXcwSUY0VmsvMFVRc0o2QTRQcHhtZmlOVTZxc0NDUVVKWUF0aDArSXda?=
 =?utf-8?B?RFlQV0IvQXIvSUVZaFY5eUd0N3NWdmx0bGtpcVp6SG5XcDU1eWlScnZCOVBP?=
 =?utf-8?B?MjhOdFBaQllucE81NGR1QUdia2MxL0RicTJsaHppK21Jd0dKMmNxYkMwbkdN?=
 =?utf-8?B?SlhkQThZOGxSUzF3OFo0VnBtN3JQRTZiZ3J4NDJENEMySUhobFBwbGZIbkxP?=
 =?utf-8?B?S3I0cmlsU0I1bkNMdzlXOHdwaTVyTzNFV21mSmgwdHNDVVc4cy92cFhjTVZo?=
 =?utf-8?B?dHVQTjJmWGlweVlmdHpRaExxTkhyVW5yaFlKRlNJTjg0MjI3ZTNvOXFRZm5m?=
 =?utf-8?Q?n5CA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111f12b9-7d51-4509-5473-08db35b9f151
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:41:33.6577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t+OydYn0ShDTL/6QuuturuWjddBT7cyI1SkgNh4fPOTCpcQ8vT+vorgUHl5LSv+vVvgu1ra8ylg/ScBeb12WkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7630
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgNSBBcHJpbCAyMDIzIDEy
OjM2DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBlZHVt
YXpldEBnb29nbGUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgNC80XSBtYWNzZWM6IEFkZCBNQUNzZWMgcnhfaGFuZGxlciBjaGFuZ2UN
Cj4gc3VwcG9ydA0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlu
a3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiAyMDIzLTAzLTI5LCAxNToyMTowNyArMDMwMCwg
RW1lZWwgSGFraW0gd3JvdGU6DQo+ID4gT2ZmbG9hZGluZyBkZXZpY2UgZHJpdmVycyB3aWxsIG1h
cmsgb2ZmbG9hZGVkIE1BQ3NlYyBTS0JzIHdpdGggdGhlDQo+ID4gY29ycmVzcG9uZGluZyBTQ0kg
aW4gdGhlIHNrYl9tZXRhZGF0YV9kc3Qgc28gdGhlIG1hY3NlYyByeCBoYW5kbGVyDQo+ID4gd2ls
bCBrbm93IHRvIHdoaWNoIGludGVyZmFjZSB0byBkaXZlcnQgdGhvc2Ugc2ticywgaW4gY2FzZSBv
ZiBhIG1hcmtlZA0KPiA+IHNrYiBhbmQgYSBtaXNtYXRjaCBvbiB0aGUgZHN0IE1BQyBhZGRyZXNz
LCBkaXZlcnQgdGhlIHNrYiB0byB0aGUNCj4gPiBtYWNzZWMgbmV0X2RldmljZSB3aGVyZSB0aGUg
bWFjc2VjIHJ4X2hhbmRsZXIgd2lsbCBiZSBjYWxsZWQuDQo+IA0KPiBTb3JyeSwgSSBkb24ndCB1
bmRlcnN0YW5kIHdoYXQgeW91J3JlIHRyeWluZyB0byBzYXkgaGVyZSBhbmQgaW4gdGhlIHN1Ympl
Y3QgbGluZS4NCj4gDQo+IFRvIG1lLCAiQWRkIE1BQ3NlYyByeF9oYW5kbGVyIGNoYW5nZSBzdXBw
b3J0IiBzb3VuZHMgbGlrZSB5b3UncmUgY2hhbmdpbmcNCj4gd2hhdCBmdW5jdGlvbiBpcyB1c2Vk
IGFzIC0+cnhfaGFuZGxlciwgd2hpY2ggaXMgbm90IHdoYXQgdGhpcyBwYXRjaCBpcyBkb2luZy4N
Cj4gDQo+ID4gRXhhbXBsZSBvZiBzdWNoIGEgY2FzZSBpcyBoYXZpbmcgYSBNQUNzZWMgd2l0aCBW
TEFOIGFzIGFuIGlubmVyIGhlYWRlcg0KPiA+IEVUSEVSTkVUIHwgU0VDVEFHIHwgVkxBTiBwYWNr
ZXQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L21hY3NlYy5jIHwgOSArKysrKysrKysNCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L21hY3NlYy5jIGIvZHJpdmVycy9uZXQvbWFjc2VjLmMgaW5kZXgNCj4gPiAy
NTYxNjI0N2Q3YTUuLjg4YjAwZWE0YWY2OCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9t
YWNzZWMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L21hY3NlYy5jDQo+ID4gQEAgLTEwNDgsNiAr
MTA0OCwxNSBAQCBzdGF0aWMgZW51bSByeF9oYW5kbGVyX3Jlc3VsdA0KPiA+IGhhbmRsZV9ub3Rf
bWFjc2VjKHN0cnVjdCBza19idWZmICpza2IpDQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBfX25ldGlmX3J4KG5za2IpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICB9
DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBpZiAobWRfZHN0ICYmIG1kX2RzdC0+
dHlwZSA9PSBNRVRBREFUQV9NQUNTRUMgJiYNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
IChmaW5kX3J4X3NjKCZtYWNzZWMtPnNlY3ksDQo+ID4gKyBtZF9kc3QtPnUubWFjc2VjX2luZm8u
c2NpKSkpIHsNCj4gDQo+IFdlIGFscmVhZHkgZG8gdGhhdCBleGFjdCBmaW5kX3J4X3NjIGNhbGwg
ZWFybGllciBpbiB0aGUgc2FtZSBsb29wLCBjYW4ndCB3ZSBza2lwIGl0DQo+IG5vdz8NCg0KSSBj
YW4gc2F2ZSB0aGUgcmVzdWx0IGludG8gYSBwYXJhbWV0ZXIgYW5kIHVzZSB0aGF0Lg0KVGhhbmtz
IGZvciBwb2ludGluZyB0aGF0Lg0KDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
c2tiLT5kZXYgPSBuZGV2Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNrYi0+
cGt0X3R5cGUgPSBQQUNLRVRfSE9TVDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICByZXQgPSBSWF9IQU5ETEVSX0FOT1RIRVI7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgZ290byBvdXQ7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiArDQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ICAgICAgICAgICAgICAgfQ0KPiA+
DQo+ID4gLS0NCj4gPiAyLjIxLjMNCj4gPg0KPiANCj4gLS0NCj4gU2FicmluYQ0KDQo=
