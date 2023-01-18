Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3262B671906
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjARKf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjARKev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:34:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE382D68;
        Wed, 18 Jan 2023 01:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674034802; x=1705570802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jZcvfdXQfs/Pc4DWM+sh8ZOgnJz/GjG1jsUGPReA3EU=;
  b=1V+20613gjOxnVrSfhI5raKP+ypOOKVMtB07NeFBFCOGaKb9ozdvdwMa
   ZjnQzgEd2ulKBSVwS4kDybuVlczK5Hm4HDYdXThG7ERiqEvR5pwXntUDi
   RX4HOo+VgnTV+cOk9SofWpIX0hb43dzBgejLNH93c6Xx+r4bKBKQvKIX5
   WfR4fvOgMU6TgKAljz9+hVsOpcfa4haySx1NjnKa9a/uw2l25Ih7hXH5T
   IxRSYJU0eDXltuqLrv4rWxVw9l1reviK1MOUMw2Cij6dOTBceNJObrJGX
   95pVGyyx3s0lAR9jDw4DfEPcEEVilDBxr+b47hrpvx5np1+oODKjr1lFc
   g==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197280123"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 02:39:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 02:39:31 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 02:39:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0VLBHExynpb9/uPYvxS59mZDaDjMsHHAsXE7OcOQi91JXF4cRDe79Jpw7+9/e8LfeBUntwhJarvI1IZzfxi+AzaOo7bIXTV5V5H4pCBZ5aI83OiaArJHKX4tehqo68s0UoHPNbAVcBX6LKcSz5VXdRm/ghMlBGETDexwhRO5PmqWmFyIOc91xYapzghMS+RmN+LCyS1/FycoGicb+Tg4yl3H1YwjLcN6oHkmIE/7rcHoeo+w8lcmUtr5dP9sIFteaf1GHR/QacP58V3CdB2tsnfgGgW7kDrIGgiWYeLGL9xtgLxthX/4LtNHyQUV4mOIUsnBw+77uvRwXxdEE/Ypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZcvfdXQfs/Pc4DWM+sh8ZOgnJz/GjG1jsUGPReA3EU=;
 b=lIN5jEd7X9aTfr2UESrL7D5Z9swwhxdpDPorXvEVK+obKXFktdcNKSLBQ2gzAKiaCGsQbP+EXr2tyz6phbTaAWrP9ERUHjOqtKYA/cVQ7Uzp4C9d3iTY3pue3a91h2E7TVoI5Zqri4b7H/bTGzIFDJxDXm7rxOY6Kg+bUl5SDqgNZa+XjvN8PtASS+SxEEIrjiS5B/C7yqqTOJ8dseqOBwzv8pPSFz2AMetGLHX4wwilt7yI+/77Tsw4rATfFpolLD8AeYCHj5Y/KwauIdIE2ptV653BosuMBl4B2+s2A8cj9AsAkBJWg0NLJSky5wI6J6b1lvGuxX4Gy+Crzn7zlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZcvfdXQfs/Pc4DWM+sh8ZOgnJz/GjG1jsUGPReA3EU=;
 b=f2KLvx6aMXqg2GfbL1F8KY8PgX3TrhVJnM2j6eYdLyl+uR9e71XgyL65nZYWFWOzK1A/5NBa+AOlfTshr0mXTbHqQRJWZnykGeWtUOxeavG4k3FwxuW+BBDqUu55JTBFRtM1q7Ybmf9kJX02Ms3zCF07Jlgp099MjxaR1Tx7bTQ=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by CY8PR11MB7106.namprd11.prod.outlook.com (2603:10b6:930:52::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 09:39:28 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::2177:8dce:88bf:bec5]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::2177:8dce:88bf:bec5%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 09:39:28 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <robert.hancock@calian.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: macb: fix PTP TX timestamp failure due to packet
 padding
Thread-Topic: [PATCH net] net: macb: fix PTP TX timestamp failure due to
 packet padding
Thread-Index: AQHZKyDCP7eDvXlFkkupFIpmR7I2DQ==
Date:   Wed, 18 Jan 2023 09:39:28 +0000
Message-ID: <e5960c25-1243-e9cf-2421-acddbf17b8e5@microchip.com>
References: <20230116214133.1834364-1-robert.hancock@calian.com>
In-Reply-To: <20230116214133.1834364-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|CY8PR11MB7106:EE_
x-ms-office365-filtering-correlation-id: a3090825-6a49-4c38-9293-08daf937e4c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xPkTq/Fe734KtCEwV7kT09LLcRnNEr/tRd9hwoZUkLiyjR2WhSNWbSdwyX9Ut/zxYLVmG/s7aq0W8EE53Zv76ILT5Go3sfyAsk7VnJ1f1tGqU93HMYPOehJ7uVETRLKwxnhevh6tgSVmMTEo62FHjR2tGCImLCfwAS3Kf1ZC2BecjPMz/mkamZScuZF+WXKDC64eQXCdcZ+ULLX+L2bgs8vOYLEHlv2mBClB8s/iD7yBtNfCa0Ncvy+AufDYeerY9hggfTFRsF6ZF5+Lpm7hxZPSj7uAnR2qR6klHiBxYwmxeuWIOiGsE/7ssLpDC4BYT9gKVPHzY9om2qaaqAbpnP81qXGj40ob85mzMvuIapdrKe3CKGuByKPoLkOiVsV+VxGAJBjZQJ8pRJzXJ7fdDIqgUC5KdQjhVaPpUU1HiwBBdqgUjNiQpR2RNzUTRJqlKyaBzALr5+hi/C7Qg2fDp/OMwnnyg9db9jp9BkXGwv81uCaZ+V0HLrrfPFdxS8sHiDSBb/WeFRkCUJMAtCIVJ4R1A9ZVRMziXDGusfMq1fpO/sIBeHAOdeVT033ZaWwQ86zUoi2bbiwSdJvGxp+5ZKoDTtpXQMWQgjJkUg+OdM3PhlkC4bUl6qWrUNLLq2N4MtCGbz4Yxin9LAXAZDp0BaqZiW5Te+sUEotqnr+k69xSNlYUV+oMxm8/mc9A+SX4uFcL0am3vaj2A5dG7RqUbZV529gn1t4rEp1vnUm/Ww12I9IPtYkhw1PP4PUwwbLL7mI8OZJVeeK/CD4qTJzyBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(38100700002)(83380400001)(122000001)(86362001)(2906002)(38070700005)(5660300002)(8676002)(66946007)(66476007)(64756008)(8936002)(76116006)(31696002)(4326008)(66556008)(66446008)(91956017)(41300700001)(2616005)(186003)(26005)(6486002)(53546011)(6512007)(6506007)(110136005)(71200400001)(316002)(54906003)(478600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm9CM0h1ZDJYV1dQSC9hK0JOY2tTV0IvQWd4SGs4STNEU3BIUHRLbTU3aXVH?=
 =?utf-8?B?aS9hNVBLVXEzVVhVSThyMVl2cWRFd2RONDRPM0xDcFFDUW9RaGhCZFllSld1?=
 =?utf-8?B?NDBCeHRtVDVIUThrRGIzMWxzeEpnTUllZUUvUEJKNjVVYTNqYm1LNGxJTFU4?=
 =?utf-8?B?eWIxdjAwSWo5dFdwUGJ4eGwyTVRIV05hcDArcndvYWcvdG9KTEE1OU1Ea28v?=
 =?utf-8?B?OGxEV0pDVHhjeEZXV1lmNHY3TFVQdXUzZm9RYlJoMkJtMlpEZWNWQWVkRmcx?=
 =?utf-8?B?R20xOE8vUWFIaXhXN1JTKzdBYnB0djlOQ0pqYXMwNElBQjNQOEgxUUVTMkIz?=
 =?utf-8?B?cnpPVCtFNEZsNy9Ud1FhdzhCTkhBVUU1dEJNQWkyS3ZSZTFwM29CRFJZM0Jl?=
 =?utf-8?B?c211cTFpVFZBR0c2Q1BKL2ZjQlNOcVZ5cStsZkMxUERka3F4UGcxWmxpWVh4?=
 =?utf-8?B?aHl3ZWNXUlh3RzZoWnVBdUVCWmxjcm51d0c0dWNlNjR3clYzRXlDY3RzR1dH?=
 =?utf-8?B?VFFiVFQ3ZU9NTHg1U2FDdmZDMGN5SS8rdjQ0SEl1M0RvbmxQVTE3Q1kyNUVR?=
 =?utf-8?B?TEF6L3AyZVp5d3B2SWtGL1A0MkNYS1BtVXFHdjVoYlpPdCtmSFRJMUV4WUVk?=
 =?utf-8?B?KytHbHBHUUY0b3lTdkRWMnZqa0tTQ1lVVlRPNkxDeTJENURNKzRvRFV1dXp4?=
 =?utf-8?B?b3ZZMUZjb2twQ1owejNtN0RhUUFWVFFJd3pwQ3hIUjN3S0ZEeWRGdUNabkNL?=
 =?utf-8?B?R3p1dDQveTdxVG5yVVJMUDVtdFdMdUhhS0NxTHc0cGtJVkFYUVFCQWh4Zms1?=
 =?utf-8?B?Wlk0MTZsRGwwazJHRHNsV1hPM0ZIN0g2WjFiZFBnbFlUQmUvdFJzUUJpNW5Z?=
 =?utf-8?B?VVBmTGkyNjBHcjExckM1aWZFajRzV0l0clVjVkF1WVRSSU1VQTdydURLL2ps?=
 =?utf-8?B?TG9LYzFoZE9PK1BkQVFRa2xSaHpwWmRpdVFPOXVFQnM2WldzbDduSFBQeDh5?=
 =?utf-8?B?L2V0ZkV1TEYxM21aUkZTWGhXb1hzcHRDS2FrbndBT2VjMWhpWlJlUDczOEtn?=
 =?utf-8?B?Wis0ZTRXTE1sZFllMHdiZE1oU1VBa2lXWlMxczRBeWVyRDcreVRKMDcyK2t2?=
 =?utf-8?B?VFltUGFrRjNRemF2YUVpV3NMS3gwRnE2MFlhN1lTdFBnSHRpWWNWV3RKSG1L?=
 =?utf-8?B?QmJibHpPbXh4Vld5OTAxQXEwTVlOVDcrMVdYNmlLcS81QjVJc1dLRzBVL2RB?=
 =?utf-8?B?TjFmdmQxU3BxSVcrN3h3NHJXOUZCc0hKeHk3UHdJSXBXTVpIa3VMOERLcnd4?=
 =?utf-8?B?V0Nkb09LMGxtK3MwVWZmNEd1QVlVNVNwa0VyV3VUdTA4eDI2VjRUbFZaZWMw?=
 =?utf-8?B?c01XbFgyUW5iOEZaV3VWZGRvUjZCbE5XTDhYeHRxaStFZUZnUHdQQ3l2YVZJ?=
 =?utf-8?B?aXU3Nk84RlZET1h3R2tpOEx3azkzNnpTcmFvZ2dFMkFwWlFQVXhuaEg3aHZF?=
 =?utf-8?B?Zm1SSzlSM2N6aDhxWGt2dnRwQytLQ00zOFQreFVldVZrQVBSQ2tOWlJzTkFI?=
 =?utf-8?B?UjhOVkdGam9KSUg3cjdzM20yM1RaV0huZG5KYzBHcHdrYVZUOUVPRFJmTEND?=
 =?utf-8?B?YzJ3cmVYMFRhN00xMzQ3YVdNaWlBV1VKUG9SUlkxMUZqbzNXZVNoNTZBWXh1?=
 =?utf-8?B?RCsxN2pVTDFaNWgrdzVKRHpiREdnamVCUUxxdzJxNWtkbHU1YU4vSVE0a016?=
 =?utf-8?B?R0l5NkVyK2NmdVFYa3lKcFVzbDljVGU4bXF0dlNra1hHQ2ZFMjVDK3BlK1BE?=
 =?utf-8?B?WmV6L2J1YUh5MVBsUFg0TEw2elIrdzRieUIrYjlzenl1WU82aFFaNHZzc251?=
 =?utf-8?B?QUMrSzV3SjAxWGRmUGhaaVAyaU85VWZlZlgwc1FhcVpvb1RwS2tTRnNOVXEx?=
 =?utf-8?B?SmtsZGdxRTd2TUZNa0dlRERFaVNJMnhPMFNyS1J2KzZVcVp2RlF6SkYzdlhT?=
 =?utf-8?B?dnFBd3A2alU5Z3ZPaTFuM0Fudjg4czAxOGczWFJqemhvbysveFh3L0h2Z2Uy?=
 =?utf-8?B?WmR3dG1odkpuMUpyTWl3TWQxb3ovWHdZcWZZOExiUUVtUUlsYXVwbXpjTlNQ?=
 =?utf-8?B?T21nVVY3c2tVQWdmR1hYSlZtQXVYN2VpZ0UyWWhic0d5Ymg3QlA3SWFGYlFC?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D25F35F9FF8FC54FB59ADC65A694D299@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3090825-6a49-4c38-9293-08daf937e4c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 09:39:28.2967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oYWNKG0hqNU8IWxOg8qtZLaZrO+wagerG03uJwsg0+uxvj08lXBJpkz1TgOmDJ5OVrCjQByVLWMYll9F6hJVe+ndaL6ZZ98GtTwk5h0qs50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7106
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDEuMjAyMyAyMzo0MSwgUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gUFRQIFRYIHRpbWVzdGFtcCBoYW5kbGluZyB3
YXMgb2JzZXJ2ZWQgdG8gYmUgYnJva2VuIHdpdGggdGhpcyBkcml2ZXINCj4gd2hlbiB1c2luZyB0
aGUgcmF3IExheWVyIDIgUFRQIGVuY2Fwc3VsYXRpb24uIHB0cDRsIHdhcyBub3QgcmVjZWl2aW5n
DQo+IHRoZSBleHBlY3RlZCBUWCB0aW1lc3RhbXAgYWZ0ZXIgdHJhbnNtaXR0aW5nIGEgcGFja2V0
LCBjYXVzaW5nIGl0IHRvDQo+IGVudGVyIGEgZmFpbHVyZSBzdGF0ZS4NCj4gDQo+IFRoZSBwcm9i
bGVtIGFwcGVhcnMgdG8gYmUgZHVlIHRvIHRoZSB3YXkgdGhhdCB0aGUgZHJpdmVyIHBhZHMgcGFj
a2V0cw0KPiB3aGljaCBhcmUgc21hbGxlciB0aGFuIHRoZSBFdGhlcm5ldCBtaW5pbXVtIG9mIDYw
IGJ5dGVzLiBJZiBoZWFkcm9vbQ0KPiBzcGFjZSB3YXMgYXZhaWxhYmxlIGluIHRoZSBTS0IsIHRo
aXMgY2F1c2VkIHRoZSBkcml2ZXIgdG8gbW92ZSB0aGUgZGF0YQ0KPiBiYWNrIHRvIHV0aWxpemUg
aXQuIEhvd2V2ZXIsIHRoaXMgYXBwZWFycyB0byBjYXVzZSBvdGhlciBkYXRhIHJlZmVyZW5jZXMN
Cj4gaW4gdGhlIFNLQiB0byBiZWNvbWUgaW5jb25zaXN0ZW50LiBJbiBwYXJ0aWN1bGFyLCB0aGlz
IGNhdXNlZCB0aGUNCj4gcHRwX29uZV9zdGVwX3N5bmMgZnVuY3Rpb24gdG8gbGF0ZXIgKGluIHRo
ZSBUWCBjb21wbGV0aW9uIHBhdGgpIGZhbHNlbHkNCj4gZGV0ZWN0IHRoZSBwYWNrZXQgYXMgYSBv
bmUtc3RlcCBTWU5DIHBhY2tldCwgZXZlbiB3aGVuIGl0IHdhcyBub3QsIHdoaWNoDQo+IGNhdXNl
ZCB0aGUgVFggdGltZXN0YW1wIHRvIG5vdCBiZSBwcm9jZXNzZWQgd2hlbiBpdCBzaG91bGQgYmUu
DQo+IA0KPiBVc2luZyB0aGUgaGVhZHJvb20gZm9yIHRoaXMgcHVycG9zZSBzZWVtcyBsaWtlIGFu
IHVubmVjZXNzYXJ5IGNvbXBsZXhpdHkNCj4gYXMgdGhpcyBpcyBub3QgYSBob3QgcGF0aCBpbiB0
aGUgZHJpdmVyLCBhbmQgaW4gbW9zdCBjYXNlcyBpdCBhcHBlYXJzDQo+IHRoYXQgdGhlcmUgaXMg
c3VmZmljaWVudCB0YWlscm9vbSB0byBub3QgcmVxdWlyZSB1c2luZyB0aGUgaGVhZHJvb20NCj4g
YW55d2F5LiBSZW1vdmUgdGhpcyB1c2FnZSBvZiBoZWFkcm9vbSB0byBwcmV2ZW50IHRoaXMgaW5j
b25zaXN0ZW5jeSBmcm9tDQo+IG9jY3VycmluZyBhbmQgY2F1c2luZyBvdGhlciBwcm9ibGVtcy4N
Cj4gDQo+IEZpeGVzOiA2NTNlOTJhOTE3NWUgKCJuZXQ6IG1hY2I6IGFkZCBzdXBwb3J0IGZvciBw
YWRkaW5nIGFuZCBmY3MgY29tcHV0YXRpb24iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFu
Y29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCg0KVGVzdGVkLWJ5OiBDbGF1ZGl1IEJl
em5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4gIyBvbiBTQU1BN0c1DQoNCj4gLS0t
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgOSArLS0tLS0t
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgOCBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRleCA5NTY2
N2I5NzlmYWIuLjcyZTQyODIwNzEzZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jDQo+IEBAIC0yMTg3LDcgKzIxODcsNiBAQCBzdGF0aWMgaW50IG1hY2Jf
cGFkX2FuZF9mY3Moc3RydWN0IHNrX2J1ZmYgKipza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2
KQ0KPiAgICAgICAgIGJvb2wgY2xvbmVkID0gc2tiX2Nsb25lZCgqc2tiKSB8fCBza2JfaGVhZGVy
X2Nsb25lZCgqc2tiKSB8fA0KPiAgICAgICAgICAgICAgICAgICAgICAgc2tiX2lzX25vbmxpbmVh
cigqc2tiKTsNCj4gICAgICAgICBpbnQgcGFkbGVuID0gRVRIX1pMRU4gLSAoKnNrYiktPmxlbjsN
Cj4gLSAgICAgICBpbnQgaGVhZHJvb20gPSBza2JfaGVhZHJvb20oKnNrYik7DQo+ICAgICAgICAg
aW50IHRhaWxyb29tID0gc2tiX3RhaWxyb29tKCpza2IpOw0KPiAgICAgICAgIHN0cnVjdCBza19i
dWZmICpuc2tiOw0KPiAgICAgICAgIHUzMiBmY3M7DQo+IEBAIC0yMjAxLDkgKzIyMDAsNiBAQCBz
dGF0aWMgaW50IG1hY2JfcGFkX2FuZF9mY3Moc3RydWN0IHNrX2J1ZmYgKipza2IsIHN0cnVjdCBu
ZXRfZGV2aWNlICpuZGV2KQ0KPiAgICAgICAgICAgICAgICAgLyogRkNTIGNvdWxkIGJlIGFwcGVk
ZWQgdG8gdGFpbHJvb20uICovDQo+ICAgICAgICAgICAgICAgICBpZiAodGFpbHJvb20gPj0gRVRI
X0ZDU19MRU4pDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gYWRkX2ZjczsNCj4gLSAg
ICAgICAgICAgICAgIC8qIEZDUyBjb3VsZCBiZSBhcHBlZGVkIGJ5IG1vdmluZyBkYXRhIHRvIGhl
YWRyb29tLiAqLw0KPiAtICAgICAgICAgICAgICAgZWxzZSBpZiAoIWNsb25lZCAmJiBoZWFkcm9v
bSArIHRhaWxyb29tID49IEVUSF9GQ1NfTEVOKQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICBw
YWRsZW4gPSAwOw0KPiAgICAgICAgICAgICAgICAgLyogTm8gcm9vbSBmb3IgRkNTLCBuZWVkIHRv
IHJlYWxsb2NhdGUgc2tiLiAqLw0KPiAgICAgICAgICAgICAgICAgZWxzZQ0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICBwYWRsZW4gPSBFVEhfRkNTX0xFTjsNCj4gQEAgLTIyMTIsMTAgKzIyMDgs
NyBAQCBzdGF0aWMgaW50IG1hY2JfcGFkX2FuZF9mY3Moc3RydWN0IHNrX2J1ZmYgKipza2IsIHN0
cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiAgICAgICAgICAgICAgICAgcGFkbGVuICs9IEVUSF9G
Q1NfTEVOOw0KPiAgICAgICAgIH0NCj4gDQo+IC0gICAgICAgaWYgKCFjbG9uZWQgJiYgaGVhZHJv
b20gKyB0YWlscm9vbSA+PSBwYWRsZW4pIHsNCj4gLSAgICAgICAgICAgICAgICgqc2tiKS0+ZGF0
YSA9IG1lbW1vdmUoKCpza2IpLT5oZWFkLCAoKnNrYiktPmRhdGEsICgqc2tiKS0+bGVuKTsNCj4g
LSAgICAgICAgICAgICAgIHNrYl9zZXRfdGFpbF9wb2ludGVyKCpza2IsICgqc2tiKS0+bGVuKTsN
Cj4gLSAgICAgICB9IGVsc2Ugew0KPiArICAgICAgIGlmIChjbG9uZWQgfHwgdGFpbHJvb20gPCBw
YWRsZW4pIHsNCj4gICAgICAgICAgICAgICAgIG5za2IgPSBza2JfY29weV9leHBhbmQoKnNrYiwg
MCwgcGFkbGVuLCBHRlBfQVRPTUlDKTsNCj4gICAgICAgICAgICAgICAgIGlmICghbnNrYikNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+IC0tDQo+IDIuMzkuMA0K
PiANCg0K
