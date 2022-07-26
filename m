Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19C9580A96
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 06:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiGZE5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 00:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiGZE5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 00:57:46 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8561A24BEA;
        Mon, 25 Jul 2022 21:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Omotzmrc73yf7ubMn9jhnmty6WRUZl/W3yVknwkeBEGb6vys7eFa05q9O0g1Gk/pp/ClB9enLsmHhq85mbLU285zba/J7PLjYfOzpZ92AUUs2KsgIwMWnG8oox+0XOcG4xdqiw8uC75/TusIPu0IduLlNgAxwAu0rRWh1xj3V7VQwXkwDDmPE4de0ncteIfxX8f/W7lPqBihY2xxz+5XB211+h4v/6F1qTTH8t81x+HbOUW5UVtc0HkeL32PQZ/pYr74XCpqP69tWfyIiZDoKddl1hNAcgl2L3epBMrhG8MRUHx1kuEUG7NcYQYGkSQY4wN5ibYI7eE2+oWtVPgh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK3w5XzI2APJBPIsAiRncsr6YE65rkDSLhUkn67awlU=;
 b=Qx4lX///Z9ENaixO6dpyOnwaBcIQNcSSNDR7QGHY/V3Hn0oBFC46S7BifK+xU3Cz3GVoTSDCjQ/grZMomtpfdKYaCLEaF/Zv5oS2+sIIQ2ewIZDjGIsoRwB6yucrG+i2QfeK3f9pZjo3dAEadQHdTZkO5ncZVoron80a/U6fXQuCpqrnpFfucoKYxSrbX1Y7G85RI7n+WaTP1z3BAMwrZPBgbjZnGyV5os2/H5BblNz9TzBmzen+WcuGoJqVvrvmuLvLp6/dvyrbrAOclkXaor/2SN0s0FESg9MnFmN2f5DVAEmDisDh9t5NrE//iv3ezAl/cidGRAZBTVLT7jpfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK3w5XzI2APJBPIsAiRncsr6YE65rkDSLhUkn67awlU=;
 b=FKzwEpc2YaiH8x3HbDCZFcQronK5px+/FKX1hkM9qfIJpufaINMWZAEYjm7GxwMlffcLllyWPAcw0EKoQtzXQNgNkDE4gbABKOCx6+i59gqqVmmBalqsin5DmKSP5KP4YO8Q2uf7fLn7NJGMJPSXSgQZ9OUjZgHO4apdRPgDPBE=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by MN2PR12MB3023.namprd12.prod.outlook.com (2603:10b6:208:c8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Tue, 26 Jul
 2022 04:57:39 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::444f:f2a:5b01:7ba6]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::444f:f2a:5b01:7ba6%5]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 04:57:39 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: RE: [PATCH v2 1/3] dt-bindings: net: cdns,macb: Add versal compatible
 string
Thread-Topic: [PATCH v2 1/3] dt-bindings: net: cdns,macb: Add versal
 compatible string
Thread-Index: AQHYnbq3f3yAE+TyNkGjaXAfnCK3W62Pf4AAgAABpICAAJkC4A==
Date:   Tue, 26 Jul 2022 04:57:39 +0000
Message-ID: <BYAPR12MB4773DFE029D5B30D05A580789E949@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
 <20220722110330.13257-2-harini.katakam@xilinx.com>
 <20220725193356.GA2561062-robh@kernel.org>
 <017a3722-d61f-6762-d17f-57417f1e3165@linaro.org>
In-Reply-To: <017a3722-d61f-6762-d17f-57417f1e3165@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 082bc51e-d592-4baf-559e-08da6ec35da3
x-ms-traffictypediagnostic: MN2PR12MB3023:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jSKBdbXXtpMslyHf++9QrYruqqAyFkJ01A/UxBIYEv305ku43+mdu6b7gB2lj/yIYQlY+3oDZHRCUoH1xNg/HNUgnv/9Kedmzum+eRk1a/j3+xZJNcxRAZrO4pfIhHXrrjSO80kANxaDSCFhK/Yr4dTYBbu3D67gK/R//5cdzab1JJpFuEnEjoWemwNxxYS0czZ6C5V/ZrsdVNCx/YdFVc01bpe2eweRvpCqAlwv5QeR3kHW1bNuErmQybT41oPJ4SmJ+ks3R484agxitGsnPIqpDyX8NbBdvP4wkIVMJbyJ3BucQNyIn178NAhuCjwuM5wX/HTDb65I8raf0L68fESVE9Jy1cghT6dFBYp1z2Fe12OK7pAb2+TcX61pu2Fsbe9nxgfT/C0v61ZglRqyGR1krkLPVE2+eFcaYIB9hKfEQ++8ASw+RzkvjZH7qLazGCTwohngtna07hMZcGPzHy8yED2SJLbnGQyqV4aJWBrqUXOrtfxOyMjeWuYMgk2hwVeh+m9f4woloUooefkNXsd6dgUtHz3QE9iFKc5jhqJz+QgcG1UpwLPXCNAsnyhj47/bBYbUy/IcWMsWJbHA/aMQ7+2gs9H8Hf6Qk98sqk/cINqMCVKNj7YtILaHrZGe3gyt1dmifru1mRUMSFkTJCWckbIkGrEpI1W8uP9EwLefrzSr1FZYYCNAwTQ6z1Zh3b8Hz2cRR1R2W+zD3UpdWPW241DYnMCarV3GHDpsYW/lxj5qOrV4e7vAH44n9UeUj/XF1GjC5V7VHYoKRC8qIarfgHO+KOoGCHnlG5cE/yzK7IGULswSlV2qYrpF7gZwqVtVF3ZYh3RNd+OgkKALT0Xwt+wOTJtXbIQinOTH75kXew5EYBLlVTIJuHgPsZ9H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(38100700002)(110136005)(54906003)(316002)(122000001)(2906002)(41300700001)(76116006)(66476007)(4326008)(66446008)(86362001)(8676002)(64756008)(66946007)(38070700005)(66556008)(26005)(7416002)(5660300002)(6506007)(7696005)(55016003)(966005)(71200400001)(52536014)(478600001)(8936002)(53546011)(33656002)(83380400001)(186003)(107886003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zk91ZzN6NFVLVFJ3eGdUV3VyZ05tWW0vT2l4N0I2MWpURDNySlpXRkF4aVBN?=
 =?utf-8?B?Q3pBeUtubGZRb3M3R2hhbEd3dmI1OTJYMmhER2xaVURGSitTNkt5R2N5R1FX?=
 =?utf-8?B?TVU2a1NZdkZadW9JbmZYUXZTRE14ZTdrNjlSbHhZd3JpR2wxaGNFTTF1NG5h?=
 =?utf-8?B?eHJ1eEZONVlFejJFMnNwV0FialdUU1FyT05Na2Jtd3d5NFZPaEozVkJFajdT?=
 =?utf-8?B?UGpBSysyaFkvOEZSYTlFclUwN2xVaVE2SkdFSDl4dXBEK1RuRlNCZ1Jnd2hX?=
 =?utf-8?B?WitnMTY4SWE3d3QyS1hpZ0hwV2VKZ29kbEtpbjgxa05pREh0V2xoQmNjeUlR?=
 =?utf-8?B?bHVxZjdTblMyYkJlT0lRNWNaUGNmYkc0MlBMUUNIR3pSNlZQWXVCNVRmYnJa?=
 =?utf-8?B?RDVjakExNFFmc3A3YVJpZ2Rsd2xmWFVtczhvN1psRDlwOTkxZExQRE5KRWZV?=
 =?utf-8?B?emZMcm9RWU1ValcwYTRocmxnMkRhcHJCQ2VrOThBMFl6dklKek5VeGgrNnRF?=
 =?utf-8?B?QmVqSElWU2tRZ2FlaFdpSE02akRvWGZQT2Y3RmVqODUwU2F1RStiL3psWkt5?=
 =?utf-8?B?a2VvT1hVV2IzSWRuM3lsNEF5ZEtsZTlkaTRWS29ZNzlOT3V3a0k2cHZXSjBX?=
 =?utf-8?B?dWc1TE41ekFoOG5wNkpFT1krOVNXcUlGdFBBbmNsbGM0R2tkNHZvc1lJWGdO?=
 =?utf-8?B?ZzcvbjhvZkdkOVkyR2ZQU3BDYU1weDcwSm9YR1NnQjdHV25UTnNtMXVqSVhs?=
 =?utf-8?B?Z3dWdkJLcFdCUTdROUhRK3ZKbnRNM1JsNjErTEw5Vks5SjdXa005OFJoQWgw?=
 =?utf-8?B?bncrak0zbjlkaWs0RGtYRWJ3YlF1MWRZQWVnRjVxckR0aXgvTStQQzdVak9v?=
 =?utf-8?B?S3luMWF2bFRsYVVHc0xQNkVTT0o3UE1OMEpzaVRSWlJnUkJXWVkzMDJZRlVG?=
 =?utf-8?B?U2haeU1sVkQ0N2NqMEx2eWVqdXpudytZMGgzWlRTSTU4dW9Ec0xjbVlOTDhQ?=
 =?utf-8?B?cVRNNzR2YWdudHI1OExqUWVpSDJYclZpNVpOZU9mVDh5bkYxL2RqNTdncXZ2?=
 =?utf-8?B?NkpobmVpQS83MkxGZEtvZm9Ra2c5d3g0Y1dEZE9GVlo0OE1ha0hrWEYwVzg2?=
 =?utf-8?B?a1lwaGdkZkdIcEUvK3BvbjRSMG9teGJnL2dKOUsyNSt3ZmlFTlZpRVAwc1dZ?=
 =?utf-8?B?ZlVMUjVvY0ErQ2ZhN3g3M0pSYjNsQUNNMWJDK05FanBOVHZFb0VLenpPbk1R?=
 =?utf-8?B?WGJqN1VDOXBZMlJ1Z0tWSy8zWUhkQ2YvZHhLQWR5eDQwcUFxeGFOZXFBNy9h?=
 =?utf-8?B?NDhhTC9FdHZtTVdpcXI4NUFqU0VSK1RTbHRaSkZtaXZOQ0VTd204Ym4xL1o5?=
 =?utf-8?B?NkRNQlNKN0hSRS8wVFFvQTJtdmpLMm1DRnN6VkpybjhBRjRxUU0rWEh4eUZz?=
 =?utf-8?B?TUdlcG9NMjBVeXhydHhFYngyZm56SlJEZXcyTzdGWi9XQnMyRURwV240S3hI?=
 =?utf-8?B?YkUxdjFlTmR5UEZvazhncTlmanFQSzVSQ3hOdHc5Y0tvTXNUZ2R4bE91VmFy?=
 =?utf-8?B?UkZOMGphVXBzbXdwSzJpOTkwdWRCeW5hN1NpMUR4VG1VOFk4Y2VmbEtrSW1a?=
 =?utf-8?B?THhiT3ZrV3ZkcUwzY2xyZEx5c3MzZU9LSG9EaVNsMzE0anFPb3R4bit3Umxi?=
 =?utf-8?B?d2EzcFJjZUNqQ1NKbkxSS0VPMCtxandPb0t6ekl1bTFDVU13WUxyRUhJZms0?=
 =?utf-8?B?bis0bFlKUTl6R2FRVmVNb0xxd0xPWUhTd2pnMjBYTnVSS1pWUVZ5eWtkK1RS?=
 =?utf-8?B?dkFzS2c0dWgzU2RHNzVCOVFER2YzKzd4S0FEL3Z6aGJkZ3ZmcWtUTlUzVWcr?=
 =?utf-8?B?RHNjSFl5REFJWDlYa2hyMDgza2tIZm9iYmpCQU1yelRpWXVXNnlEbWIxOG5z?=
 =?utf-8?B?c002L0Vwam9QN0h2d1dPY2RSSm1ocWorejJKS1ZzYnpLNERibzVGbDY4TitM?=
 =?utf-8?B?Wit4Q3lQL0picU9kdDVtS3BPalFUV21SL0xNL2ZxVUJxYUxZa3d2ZjlFTVNn?=
 =?utf-8?B?ZkhmVGdnRzJWK1ZhMlBKUkJOTFAwc1lBMEVwUjJrdndrVUMvaTRIcEtsanc5?=
 =?utf-8?Q?Hj4w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 082bc51e-d592-4baf-559e-08da6ec35da3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 04:57:39.4697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvsZ2mkO3XUZAS/6bFmNaa4JOnE17RR8GmovChbDu7ErwvOy3q+KHsj4MddYt+Sv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9iLCBLcnp5c3p0b2YsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJv
bTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0K
PiBTZW50OiBUdWVzZGF5LCBKdWx5IDI2LCAyMDIyIDE6MTAgQU0NCj4gVG86IFJvYiBIZXJyaW5n
IDxyb2JoQGtlcm5lbC5vcmc+OyBIYXJpbmkgS2F0YWthbQ0KPiA8aGFyaW5pLmthdGFrYW1AeGls
aW54LmNvbT4NCj4gQ2M6IG5pY29sYXMuZmVycmVAbWljcm9jaGlwLmNvbTsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4gY2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbTsga3ViYUBrZXJuZWwub3Jn
OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsga3J6eXN6dG9mLmtv
emxvd3NraStkdEBsaW5hcm8ub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgaGFyaW5p
a2F0YWthbWxpbnV4QGdtYWlsLmNvbTsgS2F0YWthbSwgSGFyaW5pDQo+IDxoYXJpbmkua2F0YWth
bUBhbWQuY29tPjsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHJhZGhleS5zaHlhbS5w
YW5kZXlAeGlsaW54LmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDEvM10gZHQtYmluZGlu
Z3M6IG5ldDogY2RucyxtYWNiOiBBZGQgdmVyc2FsDQo+IGNvbXBhdGlibGUgc3RyaW5nDQo+IA0K
PiBPbiAyNS8wNy8yMDIyIDIxOjMzLCBSb2IgSGVycmluZyB3cm90ZToNCj4gPiBPbiBGcmksIEp1
bCAyMiwgMjAyMiBhdCAwNDozMzoyOFBNICswNTMwLCBIYXJpbmkgS2F0YWthbSB3cm90ZToNCjxz
bmlwPg0KPiA+Pg0KPiA+PiAgICAgICAgLSBpdGVtczoNCj4gPj4gICAgICAgICAgICAtIGVudW06
DQo+ID4+ICsgICAgICAgICAgICAgIC0gY2Rucyx2ZXJzYWwtZ2VtICAgICAgICMgWGlsaW54IFZl
cnNhbA0KPiA+PiAgICAgICAgICAgICAgICAtIGNkbnMsenlucS1nZW0gICAgICAgICAjIFhpbGlu
eCBaeW5xLTd4eHggU29DDQo+ID4+ICAgICAgICAgICAgICAgIC0gY2Rucyx6eW5xbXAtZ2VtICAg
ICAgICMgWGlsaW54IFp5bnEgVWx0cmFzY2FsZSsgTVBTb0MNCj4gPg0KPiA+IFVoLCBob3cgZGlk
IHdlIHN0YXJ0IHRoaXMgcGF0dGVybj8gVGhlIHZlbmRvciBoZXJlIGlzIFhpbGlueCwgbm90DQo+
ID4gQ2FkZW5jZS4gSXQgc2hvdWxkIGJlIHhsbngsdmVyc2FsLWdlbSBpbnN0ZWFkLg0KDQpJJ20g
bm90IHN1cmUgaG93IHRoZSBwYXR0ZXJuIHN0YXJ0ZWQgYnV0IEkgc2VlIHRoYXQgYWxsIHRoZSBl
YXJseSB2ZXJzaW9ucw0Kb2YgY29tcGF0aWJsZSBzdHJpbmdzIGFkZGVkIChYaWxpbngsIEF0bWVs
LCBNaWNyb2NoaXApIGhhcyBjZG5zIHByZWZpeC4NCkxpbmtzIGZvciByZWZlcmVuY2U6DQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9sa21sLzE0MzI3NTY3MjgtNjc3OC0xLWdpdC1zZW5kLWVtYWls
LW5hdGhhbi5zdWxsaXZhbkBuaS5jb20vDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzE0
MzIyNDQ4NDUtMjkzMTUtMS1naXQtc2VuZC1lbWFpbC1uYXRoYW4uc3VsbGl2YW5AbmkuY29tLw0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8xNDMwOTMxNDM4LTMyNTkyLTEtZ2l0LXNlbmQt
ZW1haWwtaGFyaW5pa0B4aWxpbnguY29tLw0KDQpJIGNhbiBzd2l0Y2ggdG8geGxueCx2ZXJzYWwt
Z2VtIG5vdy4NCg0KUmVnYXJkcywNCkhhcmluaQ0K
