Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01EB583323
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiG0TLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbiG0TKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:10:48 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E2C6A4AA;
        Wed, 27 Jul 2022 11:52:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1gWJJLZJ2FjiPn1DUZx+BAy4QXYBaLHgwS77kboyW0nZQyJpvrQxBPKTNf9fPJXwzAjbTCp6v8T7/EbyJIneQ5+4UpnCx2M3BC1lb7ZkS7sSJub9UVMPj3nI3f5LkVHAAtg+5pwhiL0P0WeKPb+faSbG8oywslXmdKC/LTFCGUaocE3qj2ucwH48o+wbcotlg+CrO+rDZkEItGa3xg9U6YhStK9ZDzfme4EPtsPR2QVJ7uRFQovxmS8fOwaW0KhaV+QcLVXl8Kzfu8or+6/uJ4sKxmx4D2lywkkTozjjcLfMta1ORl/r2xP4CclpNxVxZs3QBWmkIfAaAhs7Uz8Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QCQeVWWaGUBEwfAv8gqS19DJg7xYt6bmhYERc/cYFmQ=;
 b=axykdodK0Y2aFcCQzANQ0UCpKS0P4EbMuxhxdsf0fVt/eMRou5NMtR9xJJ0+9SQ7RYBWKbc31pUz0yGEfcVgT2O0mAcfHEvJ5YUHv8dPmQ8CVfHnvgPTIt27FmLg+Rb5lzaBWMjDMxdWQhNj3nLzlMfJdRNBaXMNd2QgRRg2X2rYM9KHNU3V4UVjIgT1IyGqb6n/O27cByftr7G8BqJjeXV0vklHVij7I9zzyhyUmwdXZM47U1FSw6z4e+oB0KopBfuKuLxIpbd9M5mNm5wDSdlspyW1jVY3kfsNqKmKknWdG42c77e9DnXP0RfkQ9SbkMNIQHZ8fBl6rK69t+tDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QCQeVWWaGUBEwfAv8gqS19DJg7xYt6bmhYERc/cYFmQ=;
 b=2gHjAP58XnQhBu5TrPgCeAfkMqB1uf/siO9PcCT/ygTOE/4MZpw+2PxuqXIkA2B//ZUEMmWIIMz4L1qZskQ1m5jPdcjQ51PDI5OOQI5agHNOvxithqQjFUPh5fiuugoEW3AAC4KKqWyZZ+Cjnkcj3B4yLoZ6ZaoXHcSAGvajotM=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by DM6PR12MB4204.namprd12.prod.outlook.com (2603:10b6:5:212::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Wed, 27 Jul
 2022 18:52:25 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 18:52:25 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Saravana Kannan <saravanak@google.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Topic: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Index: AQHYjLtb1TFGTzmc5Uq+BMzIcSbNRq1pPD4AgAbloJCAAAbUAIAPrYYAgAAM6QCAEtQ/AA==
Date:   Wed, 27 Jul 2022 18:52:25 +0000
Message-ID: <MN0PR12MB5953F97B92EBDCE695D1C37DB7979@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch>
 <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
 <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com>
 <MN0PR12MB59539E587A8B46FDC190FB7AB78B9@MN0PR12MB5953.namprd12.prod.outlook.com>
 <CAGETcx9dh1hfqoFSRwNf3fGbH5Wsdhah8RT5R-JrGOS-rDFX3g@mail.gmail.com>
In-Reply-To: <CAGETcx9dh1hfqoFSRwNf3fGbH5Wsdhah8RT5R-JrGOS-rDFX3g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ddf157d-9a6f-4573-2550-08da70012597
x-ms-traffictypediagnostic: DM6PR12MB4204:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i4iWAf0JfPZuKkKQYRdxCos5eHEFnwAlWkN/4J2K5Mb9P4vBn6YRprNuSeidbVqq5z4assXITShPYYod5drYY5OpxLh2fL1EFNc8UeNtpENoE7qEBFbLfRiU2T5aOPbUE0fKyHx0RjjbaYdJ72d6kT0Z02Qfo1gIMJUYWEuZhD45TOKLbdYkceqCruUalcqsN9lSZuXTjZWQ+e92WaHjECWj0wf8GgS3D3YI7w+DW/IIiYHrDvxnprq4Ad37SoSb5potaRiu4gotdC1b9TExTJTumsFnXJtreqXtDvmU0aDEC0CF7zkX5glwxyrP3F8I/tOwqpX74/xVrSKdeuUSQhQPKOw5lGRWwWgVCVrsjVshF6mHAQFkbFD8R+kuKtN7jG3K27PQCpiNVg6PCF3CdUxyYN5dYUU8PoamLtGMut7ZcGGnu/R0ZE7+lEqPSL0B3pRjp/EdND0zjKiTiUqV61zh3eiOUuWdOAFaBozozM8OJJRF9pGX8d1HDVajasuZE0rKeDJNXGgnykRhyzUQ1jHt8Xe751qUS7+6t7iI9QnedYFdWUznCJMiNVA0zfUkQM2rz7ky1+kdtbNmg4op772MVS9LnKlrla4IaRNAgjrN8fXKlKMkeVVT0sUidLjuniCC1DMJExZ+Gt9A35LuV4BM8ZO7jtUuJgz19vcbGoaWdPCqKfT1As7w2Ij6BsyCXuT4BSgEQ0CN5TWLZ9qkRqPbdkMvVjdMauWXeDXjejCOa7hXGPSbtpsN12+rmL44ioj0GbL6wPpkTmHa4WZf57UxLUrt0Y1+Lc+JVnqgIi95Ud33t+DLsNpsFU4JRSb7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(9686003)(478600001)(53546011)(186003)(8936002)(4326008)(2906002)(7696005)(66556008)(55016003)(6506007)(33656002)(71200400001)(66946007)(86362001)(41300700001)(38070700005)(83380400001)(76116006)(122000001)(66476007)(5660300002)(54906003)(52536014)(316002)(7416002)(64756008)(8676002)(38100700002)(66446008)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWJnUDVEcjdpR216UGEzMkFWb3krN2lvQUhaZEFTREw5bmlVVDk2OHdsbkl6?=
 =?utf-8?B?RUtKMDU4RkJXMmg1VithcEdORVJaNUdPV1IvT1NpdVdNRHZGQmJvMDVyY1RU?=
 =?utf-8?B?UkdKZ3lWNXcyMjhBSXRKa2JaaDdpRkRmcVg3NUplRXArRTNacW05c2NQbHlG?=
 =?utf-8?B?QzJCdDhWdWgvWGFKQThITkdSZSt0aWRKWFJNQVg2QytNenBzclg4Mmx3eG9o?=
 =?utf-8?B?Uk8zcnYzcVFnSHdCS0lwL1BLK1JpQVQ2eVZvek9jemVTWHdVRiszeUZvZGJ1?=
 =?utf-8?B?aFZPVHFwZk1DTGVkRis4eXpWN3JSYUlwY0w3L0JKVG1YbXUxT1FyV0hibURO?=
 =?utf-8?B?NUwyaWpIZW1za0ZyZ2l0OTFaajZON0kwS3BDOEpKcGVXUVIvbGlFL2kwSnI4?=
 =?utf-8?B?TUkwdGFqcHltYzVFaUpkR0piZmh1NWpjU1NmcDRQby9tN3FILytFSTRKeE43?=
 =?utf-8?B?YnZUWk1XVTRDN2M2bDFEVTNrbytvY0NFMmNLdnh4Zk10S1ZPckNhNllZM3kw?=
 =?utf-8?B?NkF3QXZGMW1DcER6eC9oMUdVRXFtM0lyUlU2cXQxYTEwYnlBRXFxYWpGdUln?=
 =?utf-8?B?L1VuS3kvVWZqYjM5RHdmeGEyb2xKS2VFYmNTV3BVdWpvSkRnVklLOEVGRDhP?=
 =?utf-8?B?QVh0N1g1RWZYQWgrZng3eVhvV0xLZlFTZmVrVnd4TkxOSllnTTNhbTRMUmxJ?=
 =?utf-8?B?N1BqN0VSb2NzSGdkdkpjQ3EvRWxqekMrYVkyYkY5WkFVVXltYWw0bHprZVM3?=
 =?utf-8?B?T3JsT09wb3hzQmQ5bmEycFlEeUdjdjdLeFJRVkpzYkNxbStOK25kZmh5UTE5?=
 =?utf-8?B?clpEcFV0OGRGaEhWZGdEcEkwTDA0VGo4dmVOb1p5ZEV2M25OT3pHK1VsTk5K?=
 =?utf-8?B?cjg0T29NTGlWak5tdnpjMStlOXhVQjY5TnlLS0psaENvdGFlcXVhN3FIZ05s?=
 =?utf-8?B?eFRxUUt3UnJ4dHJSNVg3N1ZMekFvaExiZk9LV2E2MTQ0MlNUeFN0czZZZDF1?=
 =?utf-8?B?WEUxcFVRTElBTFRtQlc5bUhSbFRTcm5CQmNscStKOFd5ZDAxOStKanpqWkNW?=
 =?utf-8?B?WXJibHdOend3Zmh5eUxRVkoyaFlwdzlSSXlkR28xMi9TTVc2aFVETkNPaGZh?=
 =?utf-8?B?OVI1bytlMkdvTG5uM1dyRDRMOENNZjB5Vk1sTDFXMTdBQk9qb3BZTWViSHhE?=
 =?utf-8?B?MkhHV0NHRjgvR1dxNVM5d3QzNFN0dWp1Sk9leHAyMVhQNE01S050R3ErVWRn?=
 =?utf-8?B?VzhKSS9IdndFdHE0L0hxQ2NRd3Q5Vi8yUUtFWjQwT1hGcEloWHUrbWRaMEhm?=
 =?utf-8?B?ZWRFVk5kNEIvWHZqaDMrU1VSNjg4VWpmdkdBR2w3eXNiak5rQ0JsdExocnZk?=
 =?utf-8?B?Mmsvck5tUXNHbHFrN1VDbHhZdTllRXZyWXpUYVpyOEJmRi8vSXduSEkxODlr?=
 =?utf-8?B?S09hemdQNmpuWXZ1eXhGSnBML2cwb1hHZTJwWlc4K0VxS1NVeTRsb1ZiYkJw?=
 =?utf-8?B?TzFPTVdMcWw1Sk1MM0pmUXIzakdnRnZ6ck9WZjVOdkFHU280MWZ6dlRVVEp5?=
 =?utf-8?B?RWZ2cytyZG53NUk0NWlZU00rTzYybkV6NkJwYjdhS09WSGI1UXpPTDhkU28v?=
 =?utf-8?B?SzlFUjgzNGtQbGtROFFnYmdiWFIxOGtGK3I1MkpNbmtqaEhSeDFyWE52S2pY?=
 =?utf-8?B?MDQySXZzL1dXZkpLZVdBbnR2NDNFdEZsaHNoeVRDcDRFMHpLb09LRXVUOEVp?=
 =?utf-8?B?RFV1amVtQXhyR2FhUzY2cXV5Wmk1ZkhZd2dDRGIraWNsdTJGdWsvQ3ZaWXU2?=
 =?utf-8?B?andGQ1QrRFJCVVdpVU1RcG84cmhHbXNQanp3UTk0NWk3YTBaNURFRFF4elBG?=
 =?utf-8?B?dGtWS3hhMnRWYmx5K21jK2VYZjFOa3dWbVJvRitoWjQybkl4Vm1ZcXRBbnpj?=
 =?utf-8?B?clNTYUJjaURVWm5LOXFBVDhSMVVZY3VGUnliRzRJd3hvYjVKVEtDTnQ0T0RN?=
 =?utf-8?B?TUlsd2pnV0VnTkprQk9QTmQ3cUtyNUY2cTBVbzQ2c2VLWWIrWmttM1FCM3ND?=
 =?utf-8?B?RldvM1N2S3VBa0h1OTcvMllZbWp1N2JlU0xWdUtpQ0EwT25LdzV0NkcvUkVp?=
 =?utf-8?B?a1JscjVwU2d4YW9EOWt0N0lPYzljbXRsZnNtZ1J0TENiUTBIeXRXMnBVWVRH?=
 =?utf-8?Q?PE4O6YXwr3nyR9u0/sA9JVA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddf157d-9a6f-4573-2550-08da70012597
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 18:52:25.3974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tjCIcsKdRoZ0V7ijFJl+ZkJZOc/ih/yx/TPCx9zB1k0oHNXQtO4n9pFPQ4ZuOXKZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4204
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYXJhdmFuYSBLYW5uYW4gPHNh
cmF2YW5ha0Bnb29nbGUuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgSnVseSAxNiwgMjAyMiAxMjoz
OSBBTQ0KPiBUbzogUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5kZXlAYW1k
LmNvbT4NCj4gQ2M6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IG5pY29sYXMuZmVycmVA
bWljcm9jaGlwLmNvbTsNCj4gY2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbTsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJl
bmlAcmVkaGF0LmNvbTsNCj4gaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9y
Zy51azsNCj4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IHJhZmFlbEBrZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBn
aXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQt
bmV4dCB2Ml0gbmV0OiBtYWNiOiBJbiBzaGFyZWQgTURJTyB1c2VjYXNlIG1ha2UNCj4gTURJTyBw
cm9kdWNlciBldGhlcm5ldCBub2RlIHRvIHByb2JlIGZpcnN0DQo+IA0KPiBPbiBGcmksIEp1bCAx
NSwgMjAyMiBhdCAxMjowMCBQTSBQYW5kZXksIFJhZGhleSBTaHlhbQ0KPiA8cmFkaGV5LnNoeWFt
LnBhbmRleUBhbWQuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gPiA+IEZyb206IFNhcmF2YW5hIEthbm5hbiA8c2FyYXZhbmFrQGdvb2dsZS5jb20+
DQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgNiwgMjAyMiAxMjoyOCBBTQ0KPiA+ID4gVG86
IFBhbmRleSwgUmFkaGV5IFNoeWFtIDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+DQo+ID4g
PiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgbmljb2xhcy5mZXJyZUBtaWNyb2No
aXAuY29tOw0KPiA+ID4gY2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbTsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4gPiA+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFi
ZW5pQHJlZGhhdC5jb207DQo+ID4gPiBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGlu
dXgub3JnLnVrOw0KPiA+ID4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IHJhZmFlbEBrZXJu
ZWwub3JnOw0KPiA+ID4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsgZ2l0DQo+ID4gPiAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiA+ID4g
U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2Ml0gbmV0OiBtYWNiOiBJbiBzaGFyZWQgTURJ
TyB1c2VjYXNlDQo+ID4gPiBtYWtlIE1ESU8gcHJvZHVjZXIgZXRoZXJuZXQgbm9kZSB0byBwcm9i
ZSBmaXJzdA0KPiA+ID4NCj4gPiA+IE9uIFR1ZSwgSnVsIDUsIDIwMjIgYXQgMTE6NDkgQU0gUGFu
ZGV5LCBSYWRoZXkgU2h5YW0NCj4gPiA+IDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+IHdy
b3RlOg0KPiA+ID4gPg0KPiA+ID4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4g
PiA+ID4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiA+ID4gPiA+IFNlbnQ6
IEZyaWRheSwgSnVseSAxLCAyMDIyIDI6NDQgUE0NCj4gPiA+ID4gPiBUbzogUGFuZGV5LCBSYWRo
ZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNvbT4NCj4gPiA+ID4gPiBDYzogbmlj
b2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tOyBjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tOw0K
PiA+ID4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFA
a2VybmVsLm9yZzsNCj4gPiA+ID4gPiBwYWJlbmlAcmVkaGF0LmNvbTsgaGthbGx3ZWl0MUBnbWFp
bC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51azsNCj4gPiA+ID4gPiBncmVna2hAbGludXhmb3Vu
ZGF0aW9uLm9yZzsgcmFmYWVsQGtlcm5lbC5vcmc7DQo+ID4gPiBzYXJhdmFuYWtAZ29vZ2xlLmNv
bTsNCj4gPiA+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBnaXQNCj4gPiA+ID4gPiAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiA+
ID4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJdIG5ldDogbWFjYjogSW4gc2hh
cmVkIE1ESU8NCj4gPiA+ID4gPiB1c2VjYXNlIG1ha2UgTURJTyBwcm9kdWNlciBldGhlcm5ldCBu
b2RlIHRvIHByb2JlIGZpcnN0DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBGcmksIEp1bCAwMSwg
MjAyMiBhdCAwMToyNTowNkFNICswNTMwLCBSYWRoZXkgU2h5YW0gUGFuZGV5DQo+IHdyb3RlOg0K
PiA+ID4gPiA+ID4gSW4gc2hhcmVkIE1ESU8gc3VzcGVuZC9yZXN1bWUgdXNlY2FzZSBmb3IgZXgu
IHdpdGggTURJTw0KPiA+ID4gPiA+ID4gcHJvZHVjZXINCj4gPiA+ID4gPiA+ICgweGZmMGMwMDAw
KSBldGgxIGFuZCBNRElPIGNvbnN1bWVyKDB4ZmYwYjAwMDApIGV0aDAgdGhlcmUgaXMNCj4gPiA+
ID4gPiA+IGEgY29uc3RyYWludCB0aGF0IGV0aGVybmV0IGludGVyZmFjZShmZjBjMDAwMCkgTURJ
TyBidXMNCj4gPiA+ID4gPiA+IHByb2R1Y2VyIGhhcyB0byBiZSByZXN1bWVkIGJlZm9yZSB0aGUg
Y29uc3VtZXIgZXRoZXJuZXQNCj4gaW50ZXJmYWNlKGZmMGIwMDAwKS4NCj4gPiA+ID4gPiA+DQo+
ID4gPiA+ID4gPiBIb3dldmVyIGFib3ZlIGNvbnN0cmFpbnQgaXMgbm90IG1ldCB3aGVuIEdFTTAo
ZmYwYjAwMDApIGlzDQo+ID4gPiA+ID4gPiByZXN1bWVkDQo+ID4gPiBmaXJzdC4NCj4gPiA+ID4g
PiA+IFRoZXJlIGlzIHBoeV9lcnJvciBvbiBHRU0wIGFuZCBpbnRlcmZhY2UgYmVjb21lcw0KPiA+
ID4gPiA+ID4gbm9uLWZ1bmN0aW9uYWwgb24NCj4gPiA+ID4gPiByZXN1bWUuDQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gc3VzcGVuZDoNCj4gPiA+ID4gPiA+IFsgNDYuNDc3Nzk1XSBtYWNiIGZm
MGMwMDAwLmV0aGVybmV0IGV0aDE6IExpbmsgaXMgRG93biBbDQo+ID4gPiA+ID4gPiA0Ni40ODMw
NThdIG1hY2IgZmYwYzAwMDAuZXRoZXJuZXQ6IGdlbS1wdHAtdGltZXIgcHRwIGNsb2NrDQo+ID4g
PiB1bnJlZ2lzdGVyZWQuDQo+ID4gPiA+ID4gPiBbIDQ2LjQ5MDA5N10gbWFjYiBmZjBiMDAwMC5l
dGhlcm5ldCBldGgwOiBMaW5rIGlzIERvd24gWw0KPiA+ID4gPiA+ID4gNDYuNDk1Mjk4XSBtYWNi
IGZmMGIwMDAwLmV0aGVybmV0OiBnZW0tcHRwLXRpbWVyIHB0cCBjbG9jaw0KPiA+ID4gdW5yZWdp
c3RlcmVkLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IHJlc3VtZToNCj4gPiA+ID4gPiA+IFsg
NDYuNjMzODQwXSBtYWNiIGZmMGIwMDAwLmV0aGVybmV0IGV0aDA6IGNvbmZpZ3VyaW5nIGZvcg0K
PiA+ID4gPiA+ID4gcGh5L3NnbWlpIGxpbmsgbW9kZSBtYWNiX21kaW9fcmVhZCAtPg0KPiA+ID4g
PiA+ID4gcG1fcnVudGltZV9nZXRfc3luYyhHRU0xKQ0KPiA+ID4gaXQNCj4gPiA+ID4gPiA+IHJl
dHVybiAtDQo+ID4gPiA+ID4gRUFDQ0VTIGVycm9yLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
IFRoZSBzdXNwZW5kL3Jlc3VtZSBpcyBkZXBlbmRlbnQgb24gcHJvYmUgb3JkZXIgc28gdG8gZml4
IHRoaXMNCj4gPiA+ID4gPiA+IGRlcGVuZGVuY3kgZW5zdXJlIHRoYXQgTURJTyBwcm9kdWNlciBl
dGhlcm5ldCBub2RlIGlzIGFsd2F5cw0KPiA+ID4gPiA+ID4gcHJvYmVkIGZpcnN0IGZvbGxvd2Vk
IGJ5IE1ESU8gY29uc3VtZXIgZXRoZXJuZXQgbm9kZS4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4g
PiBEdXJpbmcgTURJTyByZWdpc3RyYXRpb24gZmluZCBvdXQgaWYgTURJTyBidXMgaXMgc2hhcmVk
IGFuZA0KPiA+ID4gPiA+ID4gY2hlY2sgaWYgTURJTyBwcm9kdWNlciBwbGF0Zm9ybSBub2RlKHRy
YXZlcnNlIGJ5ICdwaHktaGFuZGxlJw0KPiA+ID4gPiA+ID4gcHJvcGVydHkpIGlzIGJvdW5kLiBJ
ZiBub3QgYm91bmQgdGhlbiBkZWZlciB0aGUgTURJTyBjb25zdW1lcg0KPiA+ID4gPiA+ID4gZXRo
ZXJuZXQgbm9kZQ0KPiA+ID4gcHJvYmUuDQo+ID4gPiA+ID4gPiBEb2luZyBpdCBlbnN1cmVzIHRo
YXQgaW4gc3VzcGVuZC9yZXN1bWUgTURJTyBwcm9kdWNlciBpcw0KPiA+ID4gPiA+ID4gcmVzdW1l
ZCBmb2xsb3dlZCBieSBNRElPIGNvbnN1bWVyIGV0aGVybmV0IG5vZGUuDQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiBJIGRvbid0IHRoaW5rIHRoZXJlIGlzIGFueXRoaW5nIHNwZWNpZmljIHRvIE1BQ0Ig
aGVyZS4gVGhlcmUgYXJlDQo+ID4gPiA+ID4gRnJlZXNjYWxlIGJvYXJkcyB3aGljaCBoYXZlIGFu
IE1ESU8gYnVzIHNoYXJlZCBieSB0d28gaW50ZXJmYWNlcw0KPiBldGMuDQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiBQbGVhc2UgdHJ5IHRvIHNvbHZlIHRoaXMgaW4gYSBnZW5lcmljIHdheSwgbm90IHNw
ZWNpZmljIHRvIG9uZQ0KPiA+ID4gPiA+IE1BQyBhbmQgTURJTyBjb21iaW5hdGlvbi4NCj4gPiA+
ID4NCj4gPiA+ID4gVGhhbmtzIGZvciB0aGUgcmV2aWV3LiAgSSB3YW50IHRvIGdldCB5b3VyIHRo
b3VnaHRzIG9uIHRoZSBvdXRsaW5lDQo+ID4gPiA+IG9mIHRoZSBnZW5lcmljIHNvbHV0aW9uLiBJ
cyB0aGUgY3VycmVudCBhcHByb2FjaCBmaW5lIGFuZCB3ZSBjYW4NCj4gPiA+ID4gZXh0ZW5kIGl0
IGZvciBhbGwgc2hhcmVkIE1ESU8gdXNlIGNhc2VzLyBvciBkbyB3ZSBzZWUgYW55IGxpbWl0YXRp
b25zPw0KPiA+ID4gPg0KPiA+ID4gPiBhKSBGaWd1cmUgb3V0IGlmIHRoZSBNRElPIGJ1cyBpcyBz
aGFyZWQuICAobmV3IGJpbmRpbmcgb3IgcmV1c2UNCj4gPiA+ID4gZXhpc3RpbmcpDQo+ID4gPiA+
IGIpIElmIHRoZSBNRElPIGJ1cyBpcyBzaGFyZWQgYmFzZWQgb24gRFQgcHJvcGVydHkgdGhlbiBm
aWd1cmUgb3V0DQo+ID4gPiA+IGlmIHRoZSBNRElPIHByb2R1Y2VyIHBsYXRmb3JtIGRldmljZSBp
cyBwcm9iZWQuIElmIG5vdCwgZGVmZXIgTURJTw0KPiA+ID4gPiBjb25zdW1lciBNRElPIGJ1cyBy
ZWdpc3RyYXRpb24uDQo+ID4gPg0KPiA+ID4gUmFkaGV5LA0KPiA+ID4NCj4gPiA+IEkgdGhpbmsg
QW5kcmV3IGFkZGVkIG1lIGJlY2F1c2UgaGUncyBwb2ludGluZyB5b3UgdG93YXJkcyBmd19kZXZs
aW5rLg0KPiA+ID4NCj4gPiA+IEFuZHJldywNCj4gPiA+DQo+ID4gPiBJIGhhdmUgaW50ZW50aW9u
YWxseSBub3QgYWRkZWQgcGh5LWhhbmRsZSBzdXBwb3J0IHRvIGZ3X2RldmxpbmsNCj4gPiA+IGJl
Y2F1c2UgaXQgd291bGQgYWxzbyBwcmV2ZW50IHRoZSBnZW5lcmljIGRyaXZlciBmcm9tIGJpbmRp
bmcvY2F1c2UNCj4gPiA+IGlzc3VlcyB3aXRoIERTQS4gSSBoYXZlIHNvbWUgaGlnaCBsZXZlbCBp
ZGVhcyBvbiBmaXhpbmcgdGhhdCBidXQgaGF2ZW4ndA0KPiBnb3R0ZW4gYXJvdW5kIHRvIGl0IHll
dC4NCj4gPg0KPiA+IFRoYW5rcywganVzdCB3YW50IHRvIHVuZGVyc3RhbmQgb24gaW1wbGVtZW50
YXRpb24gd2hlbiBwaHktaGFuZGxlDQo+ID4gc3VwcG9ydCBpcyBhZGRlZCB0byBmd19kZXZsaW5r
LiBEb2VzIGl0IGVuc3VyZSB0aGF0IHN1cHBsaWVyIG5vZGUgaXMNCj4gPiBwcm9iZWQgZmlyc3Q/
IE9yIGl0IHVzZXMgZGV2aWNlX2xpbmsgZnJhbWV3b3JrIHRvIHNwZWNpZnkNCj4gPiBzdXNwZW5k
L3Jlc3VtZSBkZXBlbmRlbmN5IGFuZCBkb24ndCBjYXJlIG9uIGNvbnN1bWVyL3Byb2R1Y2VyIHBy
b2JlDQo+IG9yZGVyLg0KPiANCj4gZndfZGV2bGluayB3aWxsIGVuZm9yY2UgcHJvYmUgb3JkZXJp
bmcgYW5kIHN1c3BlbmQvcmVzdW1lIG9yZGVyaW5nLg0KPiBCdHcsIGZ3X2RldmxpbmsgdXNlcyBk
ZXZpY2UgbGlua3MgdW5kZXJuZWF0aC4gSXQganVzdCB1c2VkIHRoZSBmaXJtd2FyZSAoRWc6DQo+
IERUKSB0byBmaWd1cmUgb3V0IHRoZSBkZXBlbmRlbmNpZXMuIFRoYXQncyB3aHkgaXQncyBjYWxs
ZWQgZndfZGV2bGluay4NClRoYW5rcyEgRm9yZ290IHRvIGFzayBlYXJsaWVyLCB3aGVuIGFyZSB5
b3UgcGxhbm5pbmcgdG8gYWRkIHBoeS1oYW5kbGUgc3VwcG9ydCANCnRvIGZ3X2RldmxpbmsgPyBz
ZWVtcyBsaWtlIHdlIGhhdmUgYSBkZXBlbmRlbmN5IG9uIHRoaXMgZmVhdHVyZSB0byBtYWtlDQpz
aGFyZWQgTURJTyB1c2UgY2FzZSB3b3JrIGluIGEgZ2VuZXJpYyB3YXkuDQo=
