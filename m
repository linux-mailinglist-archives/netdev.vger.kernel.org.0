Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D50673D32
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 16:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjASPLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 10:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjASPLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 10:11:08 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF8883877
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 07:11:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zpzs4KY1WYS/HvZB0fi4z7AinaaYfRYvFKAXMRi1BteRwDD1d7CuO47lSE+C64dOQXPl9cT+oPxmNqfgq09o6oke6JlJi0RvBtfjdXXLSAfBHh+CutdX6LvaUgdultoYzu5/CpIWDw/hyMvkCJ5/tlhQUzuJoIWOlJov6jIO6viZ+dghSallaUdsFzjQvz90aSKA2FWg5ibrhxdqcs/poKnicsVGz1EH5JYuSt/Du3pyzNkZdp89g9InsCyPgzEgolAKQcipDoA+09VZmOTVv9ouG9done9+UUcXuKm4KqtvQZGz2poWTIEkVZtQl8x7jC7bHJk0BbyzvgHvatQWmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qya31qDBSHXO0B+HusY052JvZ2JT7DWDMYQ31TySDF4=;
 b=WKbc9B5cm6pU31BiVswoM8zDnDC9BEqrY60ZL5CuYmLwMznLEQTqLEj+COKxzBPjzxv6CPXPQfvs3lBHo9LG+GxYGDEII7uaKur1O+koIJKGAZNxQ4MKjgcKgN3frC/hLUQ75ScEzdJV8Zkuep8aUDTO4rg09pyrRfHyhBcANj8eyu1mYr3Nf7uCl2ut0i84f8lcchl2DPrW6mo6cvs4DIdV0KNvuN82/TeXdTsnhxzOUS4UqvE9Po5QjuBJgHOXa1R977ZpAkgPYd0J0wlr5ImViVfRT1+U1S2nDQaIFLfbGrrkp+HNzVIdi8BO7bfuiCDgKtxdwY/ACvwGiszqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qya31qDBSHXO0B+HusY052JvZ2JT7DWDMYQ31TySDF4=;
 b=oBTtTxAZwojDQCnB97kfp5xPz0aJtudi6otO6dsIWo/pBYSH95oNSI7V9OSeKx2Qjg76W8qRaJ0WUfJHyLdf+tXwR2QMEBX3BuuvgPBpOs+V77NQ4NxAUE6Af0e7SkmItMvG13hrHgPCSkTlDG8lgwXJtyfVeq14F7a+2adc/nY=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by BN9PR12MB5098.namprd12.prod.outlook.com (2603:10b6:408:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 15:10:59 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 15:10:59 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm@gmail.com" <habetsm@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 7/7] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Thread-Topic: [PATCH net-next 7/7] sfc: add support for devlink
 port_function_hw_addr_set in ef100
Thread-Index: AQHZK/m/3ReYmU1YPEO9sAqxgsrjy66lqsaAgAAtsYA=
Date:   Thu, 19 Jan 2023 15:10:59 +0000
Message-ID: <8716609b-4005-4388-206f-8918d25d7af9@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-8-alejandro.lucero-palau@amd.com>
 <Y8k3I2Ibd+xYlC5o@nanopsycho>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|BN9PR12MB5098:EE_
x-ms-office365-filtering-correlation-id: b43e0942-a6a6-4c03-991b-08dafa2f5f25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKFQSRd/5aJAflQIIVgh+hs6Oz+whTc1hVAoSbnToFrl/utAk79axXygYabmr2l0JC6/LsJjVeSzYzSxEBz01XPZmHi0vtam0I3np7V2Qk9mcV+3a45YWslF31MZ21qLCgYApmLqK4rgrvFT5gKcc2yE/WZnbe+kKncWvj5DnhT8KzG7+d04jv7y0LReCuSiWDfxz3QQpEy5menPRFMT2bAAIW97SvCFuMq5LLpHOtqdS87H+56/ab+0dMyz6QVTJBGXkC8Y0b/Ge/RjYU+kYKF8IWBziMrU8gpBex+5F1z8eQ9+jwBekVMkm8/QpMqLI1GGtWKAp3kkb6tdb+HKyc8RcKPoWaS8B/EnA2UCmjf/B11qqZ2xWp/n3rZAfhVD6GNPE+ONGjRlOTfZFnHEtDiUk2kNRErOqv1S2LCwfmrz4VV/X6ML2pk8KvxodENca0t3+s+jQywU84Mwhjc092JDzBxC2D7rfBwC+qb7QRFSwQ7OWhTu4jRNrR8SilYmEJ+cES3SMB2XTVEZiqX1Bz380KCFbJPHq7rctWY6pbTpzGJvgFWy1UMxVHyt+p3pqaZFd/I4dYxLx0iqKPxbUH3JFpPRS3iGwANrKGJavvvijkBHDTYHh+kqogfIgzRwsw8mWINI1im+0oQJ9+Of/lCbkhZPpUv/6sVO3A0fFpp9vK8SqkFfj98jmlx/4PlE/Sy05LMU5i2DYGaYqflr2BM6VB1gf8puPlvJZKvb8Lg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199015)(31696002)(38070700005)(31686004)(6486002)(478600001)(6506007)(71200400001)(53546011)(86362001)(2906002)(54906003)(110136005)(316002)(4326008)(5660300002)(2616005)(122000001)(66446008)(76116006)(66946007)(66556008)(66476007)(91956017)(64756008)(41300700001)(8936002)(38100700002)(6512007)(8676002)(186003)(26005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlJBTEgyVE8vSG9hZk93U20vZ3l3aU12Z0xPMDcvUmRRaWh5VlBwc3BGQ1dv?=
 =?utf-8?B?ZlhPWXhVZ0krWmFxZlBoTFRyL2V0WGFTaEZkWDdUWHI4TmRuT2lnckxQVU1E?=
 =?utf-8?B?ODVCQU5BeFNiSkZ4czBuMVpxMGxIOEg0UzhoaHdMZ2hsV2RHdFRHZnAxZkpR?=
 =?utf-8?B?Q29tZUp4emlpYXlJQjhWdy9OczJLb0hjZWR6ZGZUc2EvK1haeFAyeFZTbWRx?=
 =?utf-8?B?NmViaWtBTkV1SE1mK2xMcDlEdDB0UGQxYnVGYW5YNXZzUG9QdWlhQW9UcVdW?=
 =?utf-8?B?RUM2TWJ1Y0UrK1o0RERhQURId1V1QTBPajZ5NUJJMC95RkF1YTR6VVBnK0pm?=
 =?utf-8?B?M3A2ak90Um1KaXIxcGtIeGJQQ1ZpenA2TURiOTdQUDhvRmJpTWJjb3NiRVJD?=
 =?utf-8?B?b295U2RUT1EzekpuVTlYbXVMUDJ5UGN2R211K2VDRTdsUmZzZTNFYWl6bW1D?=
 =?utf-8?B?UWZhMEtZZG5IY0dPM3RuQ1gzUUtYZTlJSlRYcy9uay9ndlozd0ZsZGI0SDVN?=
 =?utf-8?B?L0pYM3JHOFdDcVNRcWpnUFd1TWhzWWk3TjFtSkozSVB3VGphV2x3RlJwRkl2?=
 =?utf-8?B?UFJpOUR3eDYvMlpHc252T2lXaTZFNThiTjkxZncrbUk0K1FIT3RpYk5Ld3k2?=
 =?utf-8?B?ZGI2ZmlIMEtqSlZSWnFDSkxqdDlqVkdMUVlCb01YSkZFQzBKWFlpSmFlRWxJ?=
 =?utf-8?B?aHZWUTlwNE5hSS91SWF4M000MXZPd3BZbElBWXNlL0psTlFGRnFabURXU0xU?=
 =?utf-8?B?cElDajZJY1BOQmRPWHExMzA4b2FIYUtTa3cvS1AwTUdkUFZsZ0hHblRoTVhK?=
 =?utf-8?B?UlZzekQ1Z3pnYjF3M24zc0VnS05VaVdyV0F5c01OeTVDRFlFaW5ON0xYKzRZ?=
 =?utf-8?B?RGVBT0hTbEU5UUd2ZVNrcmlmSzloMjBkYXlmWEJMYUk3dHlMeTU5YjJ5eG5h?=
 =?utf-8?B?aUo2MEMvNEVmQmhFM25ZMzAvbWhreGZ3bktwMmgwMmY4Z2RMSHFJMjlHTEdo?=
 =?utf-8?B?d1ZYM0p2cFdNMjdGMVZ2aGZkK25LVmRRTzBUNGRhNHZ6Nml1MFdsQlZaMys4?=
 =?utf-8?B?N1B5OVRhTTYyTURmdkFsdWZNZGszUVUyL3FySnpaMUVIVnRTOWE0elJCbnRv?=
 =?utf-8?B?RHN5cFdOdExRN0x4UUgveXdFdC9BRGtIVm1FcWFYY3RyVUJ0SEtkVVd2dVo3?=
 =?utf-8?B?S0JzL3R0ZkV5WDZ1TEp1UzU4d09HTkxnRTRUS3orTzNDMStETlJVMHBiM3Vt?=
 =?utf-8?B?MkFPUnlXdEJtMTFVNnZSdmZ1c2gzWTVTNE8zc0t1alh1bUk1QVMxOWh4KzZo?=
 =?utf-8?B?TTYzbzIremRjdytQTGYwUXpOcEVBYWkwOFNTakxWcGJrUnNYaFZlZE9MZXVG?=
 =?utf-8?B?RkM2OFVkelVoa2ROL0h2NG9Uak9QWDRmcGluRng2Mmtmc2lIUVkvUXpVc2Vn?=
 =?utf-8?B?cTMvV25uWUdxWVZYNjY2R1h6bkZ4TFBIZHhuWWpLNUw1eGJtaTBFUEVLK3Nh?=
 =?utf-8?B?L003ajlsTFJ5QzYzSUNiemhGeFpWcGFjV0h0RDNUSDhkdGVabUNES0ptcWhU?=
 =?utf-8?B?aExCY0xLeEg3dTNERXBjYlFVWFlFYURoWkdSNXpkcnBYVXpPa3JkbDJWSlNx?=
 =?utf-8?B?THJqUE5ieEl3Y3l1RjlkTVI5Slp6eFY3amVuL0ZMN0dxc1lJWlI1b0tZcFVL?=
 =?utf-8?B?NkM5cjFuUVRzcEU3dW9CQnFQTmREU3VqWkFFcTdGN0kvd1BBdy94VDRkNExh?=
 =?utf-8?B?MUV0T2ozVllKN3VpUi8yRWY5OXFiVFhrd3VTT01lUkw4Zkg1R3RNQVV2bXJZ?=
 =?utf-8?B?U0psWG9TQ0JBdjlidnRibHoyM3RUUlViTUMvUTFXTVVqUFhTUDNua3FObmlp?=
 =?utf-8?B?OGJPU0dlbmd6NHM3RW00TDJXSzQ5Z25IUjNJcElHUlZaSVZUVGUvN0U3WFA4?=
 =?utf-8?B?ampjTFJxbVJYVGJSWk9QL0dqUjZXR1p6Slo0MitrQXRYb3g3aDcwU3E2Smcv?=
 =?utf-8?B?M1pKYWJjYjhDejZHbEhvK1VlNGdDT3lablo3ME5jbnNldDgwbUZQbEwzL1cx?=
 =?utf-8?B?akVnL3BHSi83ZkFLb3hmWm4yT2ZTaEZlWldOZWNEbEpiNnlMa3Jmcms2T0RS?=
 =?utf-8?Q?rvcOzDL7WPRiQ12CrfxF2LLT6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F9D39BB0CB68E47BBFC4AEA9EE40B57@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43e0942-a6a6-4c03-991b-08dafa2f5f25
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 15:10:59.2740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDyja9c8Hjzc0L0FJKvOnEP1b3jGbXW/rbaZo+cMK4IWr/RP/YRb1ci43Zoo/B3+p3b3BxCSQtPO/v68BL4QiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5098
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzE5LzIzIDEyOjI3LCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBUaHUsIEphbiAxOSwgMjAy
MyBhdCAxMjozMTo0MFBNIENFVCwgYWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tIHdyb3Rl
Og0KPj4gRnJvbTogQWxlamFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQu
Y29tPg0KPj4NCj4+IFVzaW5nIHRoZSBidWlsdGluIGNsaWVudCBoYW5kbGUgaWQgaW5mcmFzdHJ1
Y3R1cmUsIHRoaXMgcGF0Y2ggYWRkcw0KPj4gc3VwcG9ydCBmb3Igc2V0dGluZyB0aGUgbWFjIGFk
ZHJlc3MgbGlua2VkIHRvIG1wb3J0cyBpbiBlZjEwMC4gVGhpcw0KPj4gaW1wbGllcyB0byBleGVj
dXRlIGFuIE1DREkgY29tbWFuZCBmb3IgZ2l2aW5nIHRoZSBhZGRyZXNzIHRvIHRoZQ0KPj4gZmly
bXdhcmUgZm9yIHRoZSBzcGVjaWZpYyBkZXZsaW5rIHBvcnQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1i
eTogQWxlamFuZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tPg0KPj4g
LS0tDQo+PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyB8IDQ0ICsrKysr
KysrKysrKysrKysrKysrKysrKysrDQo+PiAxIGZpbGUgY2hhbmdlZCwgNDQgaW5zZXJ0aW9ucygr
KQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2Rldmxp
bmsuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+PiBpbmRleCAy
YTU3YzRmNmQyYjIuLmE4NWIyZDRlNTRhYiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
ZmMvZWZ4X2RldmxpbmsuYw0KPj4gQEAgLTQ3Miw2ICs0NzIsNDkgQEAgc3RhdGljIGludCBlZnhf
ZGV2bGlua19wb3J0X2FkZHJfZ2V0KHN0cnVjdCBkZXZsaW5rX3BvcnQgKnBvcnQsIHU4ICpod19h
ZGRyLA0KPj4gCXJldHVybiByYzsNCj4+IH0NCj4+DQo+PiArc3RhdGljIGludCBlZnhfZGV2bGlu
a19wb3J0X2FkZHJfc2V0KHN0cnVjdCBkZXZsaW5rX3BvcnQgKnBvcnQsDQo+IFNpbWlsYXIgY29t
bWVudHMgaGVyZSBhcyBmb3IgdGhlIF9nZXQgY2FsbGJhY2s6IGVtYmVkIGRldmxpbmtfcG9ydA0K
PiBzdHJ1Y3QsIHVzZSBleHRhY2suDQo+DQoNCkknbGwgZG8uDQoNClRoYW5rcw0KDQoNCj4+ICsJ
CQkJICAgICBjb25zdCB1OCAqaHdfYWRkciwgaW50IGh3X2FkZHJfbGVuLA0KPj4gKwkJCQkgICAg
IHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCj4+ICt7DQo+PiArCU1DRElfREVDTEFS
RV9CVUYoaW5idWYsIE1DX0NNRF9TRVRfQ0xJRU5UX01BQ19BRERSRVNTRVNfSU5fTEVOKDEpKTsN
Cj4+ICsJc3RydWN0IGVmeF9kZXZsaW5rICpkZXZsaW5rID0gZGV2bGlua19wcml2KHBvcnQtPmRl
dmxpbmspOw0KPj4gKwlzdHJ1Y3QgbWFlX21wb3J0X2Rlc2MgKm1wb3J0X2Rlc2M7DQo+PiArCWVm
eF9xd29yZF90IHBjaWVmbjsNCj4+ICsJdTMyIGNsaWVudF9pZDsNCj4+ICsJaW50IHJjOw0KPj4g
Kw0KPj4gKwltcG9ydF9kZXNjID0gZWZ4X21hZV9nZXRfbXBvcnQoZGV2bGluay0+ZWZ4LCBwb3J0
LT5pbmRleCk7DQo+PiArCWlmICghbXBvcnRfZGVzYykNCj4+ICsJCXJldHVybiAtRUlOVkFMOw0K
Pj4gKw0KPj4gKwlpZiAoIWVmMTAwX21wb3J0X2lzX3ZmKG1wb3J0X2Rlc2MpKQ0KPj4gKwkJcmV0
dXJuIC1FUEVSTTsNCj4+ICsNCj4+ICsJRUZYX1BPUFVMQVRFX1FXT1JEXzMocGNpZWZuLA0KPj4g
KwkJCSAgICAgUENJRV9GVU5DVElPTl9QRiwgUENJRV9GVU5DVElPTl9QRl9OVUxMLA0KPj4gKwkJ
CSAgICAgUENJRV9GVU5DVElPTl9WRiwgbXBvcnRfZGVzYy0+dmZfaWR4LA0KPj4gKwkJCSAgICAg
UENJRV9GVU5DVElPTl9JTlRGLCBQQ0lFX0lOVEVSRkFDRV9DQUxMRVIpOw0KPj4gKw0KPj4gKwly
YyA9IGVmeF9lZjEwMF9sb29rdXBfY2xpZW50X2lkKGRldmxpbmstPmVmeCwgcGNpZWZuLCAmY2xp
ZW50X2lkKTsNCj4+ICsJaWYgKHJjKSB7DQo+PiArCQluZXRpZl9lcnIoZGV2bGluay0+ZWZ4LCBk
cnYsIGRldmxpbmstPmVmeC0+bmV0X2RldiwNCj4+ICsJCQkgICJGYWlsZWQgdG8gZ2V0IGNsaWVu
dCBJRCBmb3IgcG9ydCBpbmRleCAldSwgcmMgJWRcbiIsDQo+PiArCQkJICBwb3J0LT5pbmRleCwg
cmMpOw0KPj4gKwkJcmV0dXJuIHJjOw0KPj4gKwl9DQo+PiArDQo+PiArCU1DRElfU0VUX0RXT1JE
KGluYnVmLCBTRVRfQ0xJRU5UX01BQ19BRERSRVNTRVNfSU5fQ0xJRU5UX0hBTkRMRSwNCj4+ICsJ
CSAgICAgICBjbGllbnRfaWQpOw0KPj4gKw0KPj4gKwlldGhlcl9hZGRyX2NvcHkoTUNESV9QVFIo
aW5idWYsIFNFVF9DTElFTlRfTUFDX0FERFJFU1NFU19JTl9NQUNfQUREUlMpLA0KPj4gKwkJCWh3
X2FkZHIpOw0KPj4gKw0KPj4gKwlyYyA9IGVmeF9tY2RpX3JwYyhkZXZsaW5rLT5lZngsIE1DX0NN
RF9TRVRfQ0xJRU5UX01BQ19BRERSRVNTRVMsIGluYnVmLA0KPj4gKwkJCSAgc2l6ZW9mKGluYnVm
KSwgTlVMTCwgMCwgTlVMTCk7DQo+PiArDQo+PiArCXJldHVybiByYzsNCj4+ICt9DQo+PiArDQo+
PiBzdGF0aWMgaW50IGVmeF9kZXZsaW5rX2luZm9fZ2V0KHN0cnVjdCBkZXZsaW5rICpkZXZsaW5r
LA0KPj4gCQkJCXN0cnVjdCBkZXZsaW5rX2luZm9fcmVxICpyZXEsDQo+PiAJCQkJc3RydWN0IG5l
dGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPj4gQEAgLTQ4Niw2ICs1MjksNyBAQCBzdGF0aWMgaW50
IGVmeF9kZXZsaW5rX2luZm9fZ2V0KHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rLA0KPj4gc3RhdGlj
IGNvbnN0IHN0cnVjdCBkZXZsaW5rX29wcyBzZmNfZGV2bGlua19vcHMgPSB7DQo+PiAJLmluZm9f
Z2V0CQkJPSBlZnhfZGV2bGlua19pbmZvX2dldCwNCj4+IAkucG9ydF9mdW5jdGlvbl9od19hZGRy
X2dldAk9IGVmeF9kZXZsaW5rX3BvcnRfYWRkcl9nZXQsDQo+PiArCS5wb3J0X2Z1bmN0aW9uX2h3
X2FkZHJfc2V0CT0gZWZ4X2RldmxpbmtfcG9ydF9hZGRyX3NldCwNCj4+IH07DQo+Pg0KPj4gc3Rh
dGljIHN0cnVjdCBkZXZsaW5rX3BvcnQgKmVmMTAwX3NldF9kZXZsaW5rX3BvcnQoc3RydWN0IGVm
eF9uaWMgKmVmeCwgdTMyIGlkeCkNCj4+IC0tIA0KPj4gMi4xNy4xDQo+Pg0KDQo=
