Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AFD675734
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjATOaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjATOay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:30:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C390193D3;
        Fri, 20 Jan 2023 06:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674225037; x=1705761037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6F7jDCy4bGb8fFhQO+VTUhhv2mtV33Btd87bMh11kic=;
  b=YGnIoUN68RGH5vP3VMjwbawhFefIVEWV7KDBXtfBA/apfIZRgpzeT5CX
   HouvZT5OSpjsmDXAi4hE5mqdWJ3BxjcFmvF8+2OaNH1vyIv3zuXnzvupo
   lELUdVW+ccYovhffTzlXZUh1pbWnvJQuZWZCWNi0zcwh2i3WS9Yhr3pK4
   cKq2lhE6oIO81Sf86f2+8FWMiWWKhGEJ1BnW0MYcFYSV318fAL8eg0R59
   ftJUb5R6lCZT7qIv+wJLfCg6XXUZ9DZkRmj7fwbE1wkzJPCa5bhs2UDKk
   femdikoZ9UJksTfacX7SN9MmTWvVTX++EmJqXfZJVX00LM77Rb5aKL8LX
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,232,1669100400"; 
   d="scan'208";a="196712345"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 07:30:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:30:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 20 Jan 2023 07:30:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTFS8/KSAMEG65vYXgOetxrFkkYIgGXNCLxT6igCXjrrQNwKLRSAYrJB3L4Xn12cVMg3XF7zk6TqQ0X01w3gIKbDdbPHHXFwUtzycuVlsNNmBLi+Tba+oeeG2vIPNLpmpW6e93Aj/J2QUuAS5Di+OSHmuZsTgj0YEFX0W56TB6aL0aOg23avFkyHeF+7mNZh73zOB+l9wTeAzAxXmo0iFBtsye/t0F+lG40PcrJXFZovve4GXsWlUlz4ztRxnM3kEt6occ6bovL6f1b1zTfN1u71Bfhzv3bLigS7SgngqCgGJr/G+dvbdZapT+JnagpU7zNmO5I5sZpElwgbYePcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6F7jDCy4bGb8fFhQO+VTUhhv2mtV33Btd87bMh11kic=;
 b=arnGPxDRKPWDzW4qshQ8XPK28sEU4sbn69pFSVTwFtm1NZw2MXu/9Oyp15d+HOeZovs98gIVxqbOilh+NQ/MNNg2h3wI9nzcJijWnfvr7s/ErvUhGg1Ya4aaRpVVzMwFTv7Z2gKGYaQMvJmbR3elI8qr8097HBVlJdDMQ/Ry8ZSYFhQCOpFYutYnf2Cy7ACkT//sKhNVqFDAhOm0O+1B7j7sa/pFVYhxU/xjAWbCFR4GVCgTDIAMVm8RjlQWJDf4b3G75W8coEv59uP5uwP39EjfaWfcMh8c8jUtrmjLR+/YcbyqBuwBNi4IwafQ8Ly7/D270+Ybw5t3HpbamYuYkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6F7jDCy4bGb8fFhQO+VTUhhv2mtV33Btd87bMh11kic=;
 b=CIvF6gmSvFiQUyRG1XY6lFLA2J7oLf06vVmuYZs7Citm0D6avzUaCGj/0F79wutEYsA3O7iCkUCRLeyh7UoXIgxpFmJOAhG//AIxVQlPyXUhQME14RMg0lm+PTEm7uGGBWfVtExgHpq92QZvHzI7U0ayPShuCOTOMRcn1P+z4s8=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB5644.namprd11.prod.outlook.com (2603:10b6:510:ef::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Fri, 20 Jan 2023 14:30:17 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 14:30:17 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Thread-Topic: [PATCH net-next v2 2/4] net: phy: micrel: add EEE configuration
 support for KSZ9477 variants of PHYs
Thread-Index: AQHZLLCcAOFIoC3Q20eUK6koZdNs8K6nXgwA
Date:   Fri, 20 Jan 2023 14:30:17 +0000
Message-ID: <56ffbba6f3ef52949252a5ad5e83122332b076f8.camel@microchip.com>
References: <20230120092059.347734-1-o.rempel@pengutronix.de>
         <20230120092059.347734-3-o.rempel@pengutronix.de>
In-Reply-To: <20230120092059.347734-3-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB5644:EE_
x-ms-office365-filtering-correlation-id: a39709e2-563d-4902-a370-08dafaf2d9da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1M79ch1Yzp8oz0aMWxD9vJ+9OTSzkkUBiYfl2Mh1Wtu9/Wg5Ve2dNU+uXbBgG9U//a+Ro8/j77yciGrwy4zBD9R6hSoxY9r5AUeHDjE35MdAnRYN3RcJeo2GWHGNS4guTBCSIR2sc+L64j7Uo8OY5ujKchx0D1QDj9a+iKyLyYujaO+UUHpgQk6MqBH+uBkIXwV/U8pkWKET/D85V2h1g81XyzRYX170h0cyUk+vDcbBRCfXM7bJ9ji5RqbzUQfpjUAEieeNUTJE3mAQMQuA/LxsYGpCl1/b3pUbvo1KG7XhN9+AyTMU/SiO8Y0jVQxYsm8KPQl4s03ELqGCbwjO0CWcczBpEBCde1uPNj5TnqkSKo18ez5NXfWPKP4uNzQC/eVS1STDLTfEst4gN01xAXZ68kaAGr87ml9KcMwfR6LKYRFbwVIZKAmTkDdhOTpSMxcDw+RKSqe36mSNsorbGiw+3W8c9Qgg4ua6/Sjw3bAq0ASEMONzXW7c2WLVNyce8d6LUY2W9Eu4pXDS6wJ92ldLSw2TjXj5ihBPE9srJ7BZdBAOll65KB0/rBUNamEsE0B8FrUWXVPFsIZ/1Dr1WpOyWZcoDwF28tOkJAkxpgpCyl7uOwaNpJwpQB8M7roMGruFAaCg3tj88hlYVfkLgLnsZ2y5QoM0h9zc6r6OVVxI+/ryETmy80hqTUqnk5d11/QyTI0AinZiDxa/c8ISLkGmHmkiuujm9ylvLMwTwJVLstM6Tdhaiag3W9BBecQP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(6506007)(478600001)(54906003)(71200400001)(6486002)(110136005)(4326008)(66556008)(76116006)(8676002)(66476007)(316002)(66946007)(186003)(6512007)(91956017)(5660300002)(8936002)(7416002)(41300700001)(36756003)(2616005)(2906002)(86362001)(64756008)(66446008)(38100700002)(921005)(38070700005)(122000001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzlIYzYxT09VeU9YTmdCRWRWa3lGaEErbXZxaUJ0aG9vc1QvdkdYTzRSTHAw?=
 =?utf-8?B?aW5BRThNeWI1ZWc0dENUZXJCdUswamRDM2pxcnl4aEJpOWs3SHNndi9OWFJW?=
 =?utf-8?B?MFM0bDdFMXZzZGlqRWJpU2RJS0d4b2dzd0VzcDdLUXFKQ3NaWGh1UmlQYkhI?=
 =?utf-8?B?K1lRZElMSmhRenBXQXNoakZuMlEycGpsOE9SeTRpaUpuNGlJQmhYYU1oK3Z6?=
 =?utf-8?B?TGNnN2xMdmpYdGFPaExxTW1makRvcGRaNDk2WW9EMmNIN0tmU2VZL1Joenlw?=
 =?utf-8?B?YkxwKzRTcDJXOWdqZmpTcGpIM2dJWnNNMjYxdUNvK0taV3p5SDl1SHFNNStW?=
 =?utf-8?B?RFM3dnZqcmhSYVh0bnBUcjYwQ3FPNDBVR0Jxa0tmT1p1aG1jUVlnZlRvckdZ?=
 =?utf-8?B?RldMMysxQ3VJeVU0SHNrcWFVY1ZDaWpiQk5GOTQ2SXZpU1JId1hGTjRwU2NQ?=
 =?utf-8?B?ZXpXVjRZRitDYWZvYjF0VkFrMGp0alpWTDNOQlk2Unc3aVA1dE8zM1JsdkdF?=
 =?utf-8?B?WWQyMkROSHhKT1l3bWdPOEgzWCtPekdBZkduUk8vZTR1VFE1YnllelJ5YkMz?=
 =?utf-8?B?dXRzcDM1MitzRnFYNjR2RlhVSi9xSnJmaGc5ZVhtYmVkWm5MTkVBbUpXY1VX?=
 =?utf-8?B?djA0NUU1TElxaEgyM24zZUFUdkhJcStkb1lCNk5iUWJEaER3eHlEV2dZbXpr?=
 =?utf-8?B?MzFLbXVCWGtrcENJY3doSmI5alRNWFdmL001TXFucnJKV3F0L3ZwOU9GYnpM?=
 =?utf-8?B?cnh1MldxQU5Sb0NCMFB4azJ6QkJZY1l1Nm5wd2FLaWhMRGFRV3JYaVM0NDJ4?=
 =?utf-8?B?eXZYSld2RVc4SGJjU2dDSVVISCtGQlNKdGJ0a2l2Q1RPVnlLUVZ6eUx3T3Nt?=
 =?utf-8?B?cFRzb0ZzaVNiTEt6amRRTUZkZmFYVVUxKytDQmV3eU5JUFlHaE93eldzR0E4?=
 =?utf-8?B?NmdRL202MnZNbDNlQ1FIdVowS0Q3dWMyNWJUUmNpZmJuYmZ4VnVEeW5tYzlx?=
 =?utf-8?B?NllnblVPSElVQ0FYWTlsSmNETmpta3BuNmJYVXI0aEI1aGZObVRVLzdpd2pS?=
 =?utf-8?B?elNoRnVpOW1ucm9BT1FsaG5SN05XcndNazZFN1lJKzY2YjBQZmJtU0NYZkNE?=
 =?utf-8?B?eStBcDVqdU1LRGswZ0FZTGNRd3BEeGRmNll2cFhVZUJSdlFjVnJBcVB2Q3pB?=
 =?utf-8?B?R1loR0VVdE1zRlQ5TzR0UlJ2Q1RiczVpS1hlL3duRUl4cm15K3l2RHpRMzRa?=
 =?utf-8?B?U24vdFJwczVkWFlFRnVqWXczUTE4a2JaK2xDNldwZWh5R3hxeGxiSVpySzdi?=
 =?utf-8?B?Mm0yaERLVlJ5Q0J0dnplb1RLRXBPbW5mQ0JNOXJWV1JIbFM2YlFhMm9PLzRU?=
 =?utf-8?B?d1JRaXhDQmVRVzVmUlBDNFd0U1dISCs3RldZREV1S3AwczFaTXBxT09PWlNn?=
 =?utf-8?B?Z2lXMXoxOHJoT1BBeHdoLzI5Z0k1ZDd2SHpaNm13V3Z6SEZlQjBodnNTS2VY?=
 =?utf-8?B?NXBYVFVydmRmTk1DT202a1pIc2U3eS9paWJONkxrNnRuU0RnMU01UkIxYVJQ?=
 =?utf-8?B?WWZ3emJ3ZEFRMlhyYitBV2o2eHNsd1VOL1BHSkRjWnMxQ3dkSmhBZ0tCbnd6?=
 =?utf-8?B?QzJtbDduSU5oQjRoOFhYaXlKV1llOG1ZTG03Q1NiSldnNWZaY2R1cWZyOCts?=
 =?utf-8?B?V0FDaHNNVEluNU1DYmNva2l6aFdjekl2ZGRFNW1tdys2Y3ZhbEh4V1p1WHph?=
 =?utf-8?B?Wk1VclRTUFIyRFA5ZG5hUDBTQkxxdGorNGR0VjhiczNVYU92MTlZY2FrMDcy?=
 =?utf-8?B?UW1keDRFVkZmaXFNQ1ZkcUhPM2w1WmRPL2JvNEsxWUJ3dUFWaFFRLzR0RnJD?=
 =?utf-8?B?RHVVSWlKcXlkQkszZTBDMnlTbzRBTHpuUGlBbzN2SHYwWTNCN2dCWncvVW91?=
 =?utf-8?B?QjRxS05XeU5iK3JwRCtmT0gzQWswa0VFeG1yM2N4cUhhVU1kN0twZGZObWxa?=
 =?utf-8?B?NisvWiszSWVOd1B2SUJvSEUzcHVvaWZPWVZTdkk0Q211R1hZYWJpa2I2ZXVp?=
 =?utf-8?B?WEh3NTJxZ0dkTG1hWUdWQjFOOFg2TnhSbVMySUpVY2J4SjB0MnJOcmNOZEk2?=
 =?utf-8?B?Wmp0L1I3QlZrZzFxVnRTSUpUSWg4N2hjVmUwZDhtb3VGU3k1NzBsa1VCalJT?=
 =?utf-8?B?MkVIMjYyZE9OcmxBdFRwWTR2SmlvUS9KbG1sS1JQU1kzbnRjOVM1Ky8rSDgr?=
 =?utf-8?Q?gH1oUW8ygJnRp0etVqZff47kflZA28Ue3HCq6WeLmw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <103C78640D50764787ED6CB6CB8C6303@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39709e2-563d-4902-a370-08dafaf2d9da
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 14:30:17.0204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UulMg211R+D1qfCUJgAWY2sJ0Xe+X6SuhgP2aej8ec6XeOwdbvdvqOjpGiI6ZisRHz1CZzscesOzuPlP9zqGFB281ljGSFMxHCiC+TnRcts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5644
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gRnJpLCAyMDIzLTAxLTIwIGF0IDEwOjIwICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBLU1o5NDc3IHZhcmlhbnRzIG9mIFBIWXMgYXJlIG5vdCBjb21wbGV0ZWx5IGNvbXBhdGli
bGUgd2l0aCBnZW5lcmljDQo+IHBoeV9ldGh0b29sX2dldC9zZXRfZWVlKCkgaGFuZGxlcnMuIEZv
ciBleGFtcGxlIE1ESU9fUENTX0VFRV9BQkxFDQo+IGFjdHMNCj4gbGlrZSBhIG1pcnJvciBvZiBN
RElPX0FOX0VFRV9BRFYgcmVnaXN0ZXIuIElmIE1ESU9fQU5fRUVFX0FEViBzZXQgdG8NCj4gMCwN
Cj4gTURJT19QQ1NfRUVFX0FCTEUgd2lsbCBiZSAwIHRvby4gSXQgbWVhbnMsIGlmIHdlIGRvDQo+
ICJldGh0b29sIC0tc2V0LWVlZSBsYW4yIGVlZSBvZmYiLCB3ZSB3b24ndCBiZSBhYmxlIHRvIGVu
YWJsZSBpdA0KPiBhZ2Fpbi4NCj4gDQo+IFdpdGggdGhpcyBwYXRjaCwgaW5zdGVhZCBvZiByZWFk
aW5nIE1ESU9fUENTX0VFRV9BQkxFIHJlZ2lzdGVyLCB0aGUNCj4gZHJpdmVyIHdpbGwgcHJvdmlk
ZSBwcm9wZXIgYWJpbGl0aWVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogT2xla3NpaiBSZW1wZWwg
PG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3BoeS9taWNy
ZWwuYyB8IDgxDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4g
IDEgZmlsZSBjaGFuZ2VkLCA4MSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvcGh5L21pY3JlbC5jIGIvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jDQo+IGluZGV4
IGQ1YjgwYzMxYWI5MS4uZGNhNjFhNzNjMTQ0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9w
aHkvbWljcmVsLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jDQo+IEBAIC0xMzcw
LDYgKzEzNzAsODUgQEAgc3RhdGljIGludCBrc3o5MTMxX2NvbmZpZ19hbmVnKHN0cnVjdA0KPiBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+ICAgICAgICAgcmV0dXJuIGdlbnBoeV9jb25maWdfYW5lZyhw
aHlkZXYpOw0KPiAgfQ0KPiANCj4gK3N0YXRpYyBpbnQga3N6OTQ3N19zZXRfZWVlKHN0cnVjdCBw
aHlfZGV2aWNlICpwaHlkZXYsIHN0cnVjdA0KPiBldGh0b29sX2VlZSAqZGF0YSkNCj4gK3sNCj4g
KyAgICAgICBpbnQgb2xkX2FkdiwgYWR2ID0gMCwgcmV0Ow0KDQpuaXQ6IHlvdSBjYW4gY29uc2lk
ZXIgZGVjbGFyaW5nIHZhcmlhYmxlIGluIHR3byBsaW5lcywgb25lIHdpdGgNCmluaXRpYWxpemVk
IGFuZCBvdGhlciB3aXRoIHVuaW5pdGlhbGl6ZWQuDQppbnQgb2xkX2FkdiwgcmV0Ow0KaW50IGFk
diA9IDA7DQoNCj4gKw0KPiArICAgICAgIGtzejk0NzdfZ2V0X2VlZV9jYXBzKHBoeWRldiwgZGF0
YSk7DQo+ICsNCj4gKyAgICAgICBvbGRfYWR2ID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19N
TURfQU4sIE1ESU9fQU5fRUVFX0FEVik7DQo+ICsgICAgICAgaWYgKG9sZF9hZHYgPCAwKQ0KPiAr
ICAgICAgICAgICAgICAgcmV0dXJuIG9sZF9hZHY7DQo+ICsNCj4gKyAgICAgICBpZiAoZGF0YS0+
ZWVlX2VuYWJsZWQpIHsNCj4gKyAgICAgICAgICAgICAgIGlmICghZGF0YS0+YWR2ZXJ0aXNlZCkN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgYWR2ID0gZXRodG9vbF9hZHZfdG9fbW1kX2VlZV9h
ZHZfdChkYXRhLQ0KPiA+c3VwcG9ydGVkKTsNCj4gKyAgICAgICAgICAgICAgIGVsc2UNCj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgYWR2ID0gZXRodG9vbF9hZHZfdG9fbW1kX2VlZV9hZHZfdChk
YXRhLQ0KPiA+YWR2ZXJ0aXNlZCAmDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZGF0YS0NCj4gPnN1cHBvcnRlZCk7DQo+ICsgICAg
ICAgICAgICAgICAvKiBNYXNrIHByb2hpYml0ZWQgRUVFIG1vZGVzICovDQo+ICsgICAgICAgICAg
ICAgICBhZHYgJj0gfnBoeWRldi0+ZWVlX2Jyb2tlbl9tb2RlczsNCj4gKyAgICAgICB9DQo+ICsN
Cj4gKyAgICAgICBpZiAob2xkX2FkdiAhPSBhZHYpIHsNCj4gKyAgICAgICAgICAgICAgIHJldCA9
IHBoeV93cml0ZV9tbWQocGh5ZGV2LCBNRElPX01NRF9BTiwNCj4gTURJT19BTl9FRUVfQURWLCBh
ZHYpOw0KPiArICAgICAgICAgICAgICAgaWYgKHJldCA8IDApDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiByZXQ7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIC8qIFJlc3RhcnQgYXV0
b25lZ290aWF0aW9uIHNvIHRoZSBuZXcgbW9kZXMgZ2V0IHNlbnQNCj4gdG8gdGhlDQo+ICsgICAg
ICAgICAgICAgICAgKiBsaW5rIHBhcnRuZXIuDQo+ICsgICAgICAgICAgICAgICAgKi8NCj4gKyAg
ICAgICAgICAgICAgIGlmIChwaHlkZXYtPmF1dG9uZWcgPT0gQVVUT05FR19FTkFCTEUpIHsNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gcGh5X3Jlc3RhcnRfYW5lZyhwaHlkZXYpOw0K
PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAocmV0IDwgMCkNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiArICAgICAgICAgICAgICAgfQ0KPiArICAg
ICAgIH0NCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0KPiArfQ0KPiArDQo+IA0KPiANCg==
