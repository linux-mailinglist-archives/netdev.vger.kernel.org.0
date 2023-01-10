Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9186642F3
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjAJOPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjAJOPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:15:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0D6271E;
        Tue, 10 Jan 2023 06:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673360135; x=1704896135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AQRIsyoZmw7gIhdFTF6q2IGY64GWBtMv0S9+ZYQmXJI=;
  b=EdbhPyuVylfnf6Dtg4n4/jbVfUJMbXMXD9ouO7XFylIfpbiWMppqMeoo
   0+aou9M0a+FYh7lrdJY0gKCRvu7RD0ioRWLe3CZ74up6/bahhRhGcppnW
   IKii7DIEQfNUDUT39VTJmKfi6eQqFMqWFrMXfTVp+I2sx4/z4XfIJVuPA
   9lusxAlmWqqGGQAd2RDymlFKMeExeqZXIlYU06iHuz5pNrlsSzWbpFuxx
   0DMHOHHvvQ4rP7Ose5SHZ74+ovsrpBTIeOcwh5NivButKJplzRLq4zXka
   a37XvY/Q87xrIQ5W9XtPhtsdiXMS7y08z7WUU8OWXHfhveCCvzIYcWJZe
   w==;
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="131662760"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2023 07:15:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 07:15:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 07:15:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXusNEXNRqPb8NPj5U8znedTNVxHnO5qq3IgnXl+vt2H0hNPNIBOmiFqpDrQANjIAaQDr0QugodkepofC2gC54cAbynJ9EeppHWyYnYqP5uCrDuNCwI29Lzt3tcA5zsEaY/IpRzevvCLDrZoTAVuEEfWRjd2DxnhFuRGV10PXK0g0L5jyWKhPtLHmd0hLWcrJJFRCLwSc8g5q/2a3tfT0MYF2qNBk309YReUnWbKi2mI9Uo0aYl6wZ/42oby92JSLcW449K8QQHXq2nLR8inhe5a9w4CrRGMD1oxQ9ql81+ZAkhcsx/vDbYC/6oh2PyPIR+uNS+1miKtVm7H+LZiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQRIsyoZmw7gIhdFTF6q2IGY64GWBtMv0S9+ZYQmXJI=;
 b=jpj+VmjPKWStmYixDafLgtiyCSh2k6cLpYZ3LfyGGOZyDy+uNf2q42XPCd789igWRBQoAkoBy25bLeF2QEtTS+oJarMtndFDacxafpwGwO1KrBAo5oUwLAx3CRGif/G7mzThpzOknPzh8QGqegZrMQTkbgC3iVDJcSLxyNh3m19A7Z8jS/cLTzjqglyRsOFjPN0rv0n+8qUAO+LMqdxURBRs2QSzLAm6ZvP0OON+GvEgC7htKgjoo/5wMtxiiFSJbGSPONUgDCk0YUiR+ECsmu6gwG4QOerA4OQTHpKfAHwWdyvvD0+0EZMKMHCO5Lnsb7buYnTJnbRfgwTW4CuzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQRIsyoZmw7gIhdFTF6q2IGY64GWBtMv0S9+ZYQmXJI=;
 b=EtSiKDSwv4Vs/rogwIsSFtRD0GkS/9Ds8rRPranGUKszCZq51IU8zn34JOsUjMGglH9W3aAGQto2l8EEmPscdWuwfxny3QjicbfG7czM+w9acfTVHkUF+5x1NF26cZVwcLFeweabea2DKNnVIQRlXC97W/7krG2L9jOKwab5Ats=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA2PR11MB5161.namprd11.prod.outlook.com (2603:10b6:806:fa::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 14:15:29 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 14:15:29 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>, <yoshihiro.shimoda.uh@renesas.com>,
        <linux@armlinux.org.uk>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/4] net: ethernet: renesas: rswitch: Simplify
 struct phy * handling
Thread-Topic: [PATCH net-next v2 2/4] net: ethernet: renesas: rswitch:
 Simplify struct phy * handling
Thread-Index: AQHZJP1iR3Ap5WK77kSx2DiWrzpPbq6Xsf8A
Date:   Tue, 10 Jan 2023 14:15:29 +0000
Message-ID: <8f29ef6f855d965cf86fc776cbfc463c7d20258f.camel@microchip.com>
References: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
         <20230110050206.116110-3-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230110050206.116110-3-yoshihiro.shimoda.uh@renesas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA2PR11MB5161:EE_
x-ms-office365-filtering-correlation-id: 7fe9d3ee-c4c7-4ae5-d836-08daf31520e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CInWdx9OJKykgrNXoJSHSghTsB+RMjrWzft//XnfeRNPKKQS1TLp5IrBMF3wCsr4xfMlYf+6BBf0o67nWUx5vX7EctPeArycLU9qGmZEF1H4zxkxgqynakMjQakW4u1HZQD8QQwtcyPunYmWXddY9c3ddxnv1rdDYiw3G+gdsLhjjq26A33NBxGQOutoFkaaFfLrL7ZU0RUb5HYYrV6iB7E9gQCvnw5CbT1tQbe8y/+QKKujIdFc6ZXO46N2ngo3uqdlXADMNjAajNHPHzR3cnZ0A0h6cLbYhyT84d9purTBx1hMkxwLtvMTiKuXoggs63cpZeNEWIinxuxGVdg7GyS5eBEA0L+O9JsPVdwxNv/Bln4UsCcELbzzZKemfRzErzrEOOhaRbSwa6B3I0x6ACu5qUbcXGvYQruxR3D/COqCr7KdUcpi12RgbtlsgGS6q9gSGGQl+BKY+WHTzs4xWH679t1v1RxqZ8PB5Y1n9SqauLUv/PxMgIHHLw9kCD5T4TyrMUKcT5xajxtOSjo4+8PbKTnd74vad1sS5E6uvUu2ffdv5DGwv69/b9KxslHpcT8AntBal4Fc1ci9C3+GGcSfSooWzJ31oGVYp9pB2KHI7nme5y0mfX2fmuvJgamcG8nLDH4F1mKG76kZT2j6vNcYCtbx30WcVsGLR6Sp5zComcbfPxlw0RHbWtqKh0ct8HIX8mvwD4KD+xaacrRYSYCqNQoBGHgqAN5yCc4QvbM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(36756003)(186003)(122000001)(8936002)(6512007)(6506007)(2616005)(66946007)(5660300002)(66446008)(66476007)(7416002)(66556008)(64756008)(316002)(91956017)(4326008)(38070700005)(86362001)(71200400001)(76116006)(38100700002)(478600001)(6486002)(54906003)(41300700001)(8676002)(110136005)(83380400001)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0x3czIyRXFwYXRtMllJTmdLcXhkNXhRSmNoWG1IcDdBS24rU3FwRUFldU9S?=
 =?utf-8?B?K3hrVy9oQWhIQUVJV2xTUjgva3hlaXdZNlZUSU1kZ3o1TTFJN29OTnV2akN5?=
 =?utf-8?B?NllJUWpXWVBVWmhpNWd6cnFsQ3AvNHFxaWpmUlhhMWFnK1Nrdy84VW9FZStk?=
 =?utf-8?B?Q1R3Lyt6WUdPeFd2Znc3MkMvMGNRalNGSWhQUUR2SUoyMjkzZUN6c0FWOUVu?=
 =?utf-8?B?NmZzZkhvOHlQNy9ZVGYrVFNjSElORE5nVnFkZDltTHNRSEw2dTJ5SFlFcC9G?=
 =?utf-8?B?bnVrREZrNXQydXJReEIwQ0l2c29Sb2F2T0ZzdEl2amRuUzVEQ3hMU3Q3YUtH?=
 =?utf-8?B?UkZmcWZaSHUvdUR2U1dZSlU5WXY5UzcyTTV2STJ6UzROb1FIRmNSNGhFOE5O?=
 =?utf-8?B?RFIwcVhvRC9ZQzJ6Rnp2L2wzM0dsVEZZaVhnZ3RhTG91SE5JbWNjTnNaSGU3?=
 =?utf-8?B?N1diWjN3d0lPVnJoam1KVnA4azJLNVZMbWJSWG81QW1rd1RNVHZkUmpEb0la?=
 =?utf-8?B?eXVVR0hiN2I3WUVHNm8yM050Wk9TT2x0MjA4dVdLQUxLdDZwc01MOUY3K1R6?=
 =?utf-8?B?L1ozYjRhQlcySytQQWtqUG9BTi95YTZsRWg1MGdFR0VrSG9Yczhyek8yL0lM?=
 =?utf-8?B?YlMvUVo5VzZsVWUvT1Z6STlPS3NnMWlpbFp0V1ZyYXhGZEIyZ0Y2UE9wQXp6?=
 =?utf-8?B?UDF2QklBWlFMWmdrd0RNdWF4bVVxWkVFZFE0VUlGaXNxcHh0SUpGODE4Wmx2?=
 =?utf-8?B?QjhlUERuU3VUVmU2bVdDNjVMWVp0Z2dRb0JsWWdMN0x1d0c0NkJjc05UcGcx?=
 =?utf-8?B?d2ZQQ09DWXN6ZDA1YjJKdFBSSDY3ZkdJNkp2eXRCWW1JQ3phZW4yN2tDWlpR?=
 =?utf-8?B?cXFyRUc1citLUW5lV3czdGhQMTh3M3Byd1hvVWVIazdjbDZRcFRJM2tIUmlE?=
 =?utf-8?B?YnpEdmxiRE9MQ29BVU9jM0UwZjN6YmNIclNBRksvK1JWcW9BckFFT0VhclZV?=
 =?utf-8?B?NitBT0VYUmdmZkp3YWxlSTFLZ2sxZWIzdGkzRjdwZms2Mm14b0R0QXBPK0ZM?=
 =?utf-8?B?RHNhVG8vMkhXSXBVc04xVWVaZ1FyYkw0M2RZSUNBWjdDWWxRdXlaNHc1YjRT?=
 =?utf-8?B?M3Z2OTZVbHFBY3ErLzdtNHJMNFRIM0F3ekJFMXhJN0ZadGRqb2Y5S3daUWVG?=
 =?utf-8?B?dW15QTJrWjVKalQvbG1ScUlydUZ5RTVhcWZudEk3Yk13YS8wRmdvVXVZL2Rt?=
 =?utf-8?B?Qk5uMENzMEkwdlQvSEJ0ZTliRGZHaytRWitZc1ZiOGVPS2E4elhNUDl4a0Jk?=
 =?utf-8?B?M0c3bmkzR1dLdERWWEtkUFVHM0pVREtpWC9NRkFWUXpCQUc1bkMvZHEyNHhk?=
 =?utf-8?B?OHRtM09rSEpJemVqbXk5S0t3Q3hJRXJTendlc1RjTEFQQngyb2loME9VclhL?=
 =?utf-8?B?N1hIcXBsTE40NmNZaE5vOHk5bVkwNDE5dDgxTFd1UlVTc2h2cDNWeU1BY0gy?=
 =?utf-8?B?enBVajdQY1BXZXFEMXVnN24vcnNUOHE3T1hneFRMTTA3bGllYTBZTnhTb2hY?=
 =?utf-8?B?U0dqaVFFMlBHV3N1L1hJc3pCYkltNEFzakdUWStmMlBKWUR4b0lBaTNDYmVr?=
 =?utf-8?B?WStmYmtSeE90YkVuenhQQnJyU2RqUnFpZU1NdUFpK0FLR251b1dsa3VjY0Zy?=
 =?utf-8?B?WlVLNGp4U1ZSZEN3N3YyczJiZWtnbklqdmJjYzVPTTB6djFkc3c4UXNWY3Mz?=
 =?utf-8?B?T3V3Tncwb2ZHTzg2SVlvdGpNYW5BQXZtMmp3dmtpMUJGYXMzeGtPeXdmZWZU?=
 =?utf-8?B?TU84NnhNUWZRRUtBekhUSmlscWJrUk9ZMHR4dTRObVZPYUNYZ29zV0JOcW1B?=
 =?utf-8?B?dittZ0wvR1Bhak1yaDRpYjdhbzlGVVVURWlPaEsvS3lrcWpCclFVOTdJUXlP?=
 =?utf-8?B?TjBoN21TRHo3emxGSkxoSmJZamkyejFsSVFhaDRTVkdHSUlDL1Q5Z204emNZ?=
 =?utf-8?B?eFFLMHcvak52N2k4S2orWGY3cHk3bGViTFVoN0tidHlpR3FLUkF5MkM3QUkv?=
 =?utf-8?B?Rkd6WVljVTFzcSt3b3BxWTltTlIyclJSZ2x1dDdiZHRoWjlFUDdMNi96VjFl?=
 =?utf-8?B?cVlwUWlycnNPMFBMWnVINHo4ZTB1WkR1MUR1dVZ6bjJzekY2K0NuV1haUnhL?=
 =?utf-8?B?WEh0SkEvY3ltZUdFOVI0dW5PMGlFNWo1K2x5ZUcwaktlUjRmTFo5NDFrejlm?=
 =?utf-8?Q?HcFeoYrwwcBV2TcNWCM98K6yaeGEHaNkmgtXTvqAl0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA1315F73BA24B48B03125E5808DD85E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe9d3ee-c4c7-4ae5-d836-08daf31520e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 14:15:29.7543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aaoZT11lq7M9p89DGOEXLMnHBnaj+2/3x/c+LmK0hOi9CdKzLfMg7HJTTqOFRSFTr5LvUj8j9vku56LJzXne6CCU8de9ZG6UblUOU3XBGC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5161
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWW9zaGloaXJvLA0KT24gVHVlLCAyMDIzLTAxLTEwIGF0IDE0OjAyICswOTAwLCBZb3NoaWhp
cm8gU2hpbW9kYSB3cm90ZToNCj4gU2ltcGxpZnkgc3RydWN0IHBoeSAqc2VyZGVzIGhhbmRsaW5n
IGJ5IGtlZXBpbmcgdGhlIHZhbGlhYmxlIGluDQo+IHRoZSBzdHJ1Y3QgcnN3aXRjaF9kZXZpY2Uu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZb3NoaWhpcm8gU2hpbW9kYSA8eW9zaGloaXJvLnNoaW1v
ZGEudWhAcmVuZXNhcy5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yc3dpdGNoLmMgfCA0MCArKysrKysrKysrKystLS0tLS0tLS0tDQo+IC0tLS0NCj4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcnN3aXRjaC5oIHwgIDEgKw0KPiAgMiBmaWxlcyBjaGFu
Z2VkLCAxOSBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkNCj4gDQo+IA0KPiAgDQo+IC1z
dGF0aWMgaW50IHJzd2l0Y2hfc2VyZGVzX3NldF9wYXJhbXMoc3RydWN0IHJzd2l0Y2hfZGV2aWNl
ICpyZGV2KQ0KPiANCj4gIA0KPiAgc3RhdGljIGludCByc3dpdGNoX2V0aGVyX3BvcnRfaW5pdF9v
bmUoc3RydWN0IHJzd2l0Y2hfZGV2aWNlICpyZGV2KQ0KPiBAQCAtMTI5OSw2ICsxMjkwLDEwIEBA
IHN0YXRpYyBpbnQgcnN3aXRjaF9ldGhlcl9wb3J0X2luaXRfb25lKHN0cnVjdA0KPiByc3dpdGNo
X2RldmljZSAqcmRldikNCj4gIAlpZiAoZXJyIDwgMCkNCj4gIAkJZ290byBlcnJfcGh5bGlua19p
bml0Ow0KPiAgDQo+ICsJZXJyID0gcnN3aXRjaF9zZXJkZXNfcGh5X2dldChyZGV2KTsNCj4gKwlp
ZiAoZXJyIDwgMCkNCj4gKwkJZ290byBlcnJfc2VyZGVzX3BoeV9nZXQ7DQoNCkkgdGhpbmssIHdl
IGNhbiB1c2UgKmVycl9zZXJkZXNfc2V0X3BhcmFtcyogaW5zdGVhZCBvZiBjcmVhdGluZyBuZXcN
CmxhYmVsIGVycl9zZXJkZXNfcGh5X2dldCwgc2luY2UgdGhlIGxhYmVsIGlzIG5vdCBkb2luZyBh
bnkgd29yay4NCg0KPiArDQo+ICAJZXJyID0gcnN3aXRjaF9zZXJkZXNfc2V0X3BhcmFtcyhyZGV2
KTsNCj4gIAlpZiAoZXJyIDwgMCkNCj4gIAkJZ290byBlcnJfc2VyZGVzX3NldF9wYXJhbXM7DQo+
IEBAIC0xMzA2LDYgKzEzMDEsNyBAQCBzdGF0aWMgaW50IHJzd2l0Y2hfZXRoZXJfcG9ydF9pbml0
X29uZShzdHJ1Y3QNCj4gcnN3aXRjaF9kZXZpY2UgKnJkZXYpDQo+ICAJcmV0dXJuIDA7DQo+ICAN
Cj4gIGVycl9zZXJkZXNfc2V0X3BhcmFtczoNCj4gK2Vycl9zZXJkZXNfcGh5X2dldDoNCj4gIAly
c3dpdGNoX3BoeWxpbmtfZGVpbml0KHJkZXYpOw0KPiAgDQo+ICBlcnJfcGh5bGlua19pbml0Og0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yc3dpdGNoLmgNCj4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jzd2l0Y2guaA0KPiBpbmRleCBlZGJkZDFi
OThkM2QuLmQ5YTBiZTY2NjZmNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yc3dpdGNoLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
c3dpdGNoLmgNCj4gQEAgLTk0MSw2ICs5NDEsNyBAQCBzdHJ1Y3QgcnN3aXRjaF9kZXZpY2Ugew0K
PiAgDQo+ICAJaW50IHBvcnQ7DQo+ICAJc3RydWN0IHJzd2l0Y2hfZXRoYSAqZXRoYTsNCj4gKwlz
dHJ1Y3QgcGh5ICpzZXJkZXM7DQo+ICB9Ow0KPiAgDQo+ICBzdHJ1Y3QgcnN3aXRjaF9tZndkX21h
Y190YWJsZV9lbnRyeSB7DQo=
