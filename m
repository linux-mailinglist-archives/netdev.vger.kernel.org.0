Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A4A5B7819
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiIMRhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiIMRgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:36:51 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0184558B53;
        Tue, 13 Sep 2022 09:26:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hi5dK6jCILfpYbbAPL/hOj95gYQrhvI3dK6MM4YTaMaqlcCABeDg9PsT+3teWvqX9JfnKzsKo4yhTCgnU86wykOpyPIMB52U4+/da0UgmW0HQCGJlQ6j5TiSKgXNgT6Uw5xgRyjkmwjC3qLkjQk8iikpyAHfgfTv75VxQr/vTdYe7OgXvtC9p8Zn/pViDOAOqfYbg5P8+4hf8opfm9gS91vgbEDHlVw1ajlvQ6Wcaf0RplzrM/o+hnlCv0mXZVGoxQJ6nBpMpSGUPAMraGtVpPIQyopocx6j7XAwMNVVguoKOG+PQyZNBunGiKYT5X4bW0FUesE7gSP3Xtc0vtMmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bneaA6Can9EltQ9Idu83GL3ml+XS+3QAoChRHElZZ8c=;
 b=lGY2v2vxddUr5K0+aN/eZL0qM57SRVSvhCOWtxznzFlO7cNT53bE5Vf9C5Lu5rU2xT0RjpzLKthtCvFjxa6pwgg0cVdHMnOljxRodGjZXu28e0gtQxfmg2QKmqGS/ilVfHMsoXRnJJhOGabsrM1sQIEbJX3O3sy5my6xege/L76CAbK35uvSw/j5owTcWp+RNXbsuE0t7Ob1sqSNpjRkyZ+0bI5ycOfzNykz0WDyNh6rVAEhYG7ewZqBPbS0hNWF11PrpZtyQ1ASoJFjkB6GgwS2C5U5tyfMCb7LVnDZBK8iOJKi7ZZoOm3tXFGnh8P+Az7AnIgK4/uKQ6J18MHGOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bneaA6Can9EltQ9Idu83GL3ml+XS+3QAoChRHElZZ8c=;
 b=Hau5V3WfsHofCe1tvNMy8ovu1wHY3J3k2/KC4v+N015N+sejjbFS9FKtSa6QvSU1sd16ugOvkcIgfSreg0qMi8Fni5EYMWGKmib38mPXrsrbYw4tBSB00u+wIWdchPmBhBRRWvHDH6n/BmdXfOLwfCYe9d2JxE0eoYNuSeeCKu8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8362.eurprd04.prod.outlook.com (2603:10a6:10:241::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 16:26:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 16:26:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: dsa: mt7530: replace label
 = "cpu" with proper checks
Thread-Topic: [PATCH net-next 1/3] dt-bindings: net: dsa: mt7530: replace
 label = "cpu" with proper checks
Thread-Index: AQHYxtA/dY6uSTfa90GnMoLAnp7gyK3dhMGAgAAI24A=
Date:   Tue, 13 Sep 2022 16:26:48 +0000
Message-ID: <20220913162647.zylrml4giqxgqngq@skbuf>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-2-vladimir.oltean@nxp.com>
 <68902e34-8ef4-994b-8e89-d42b55aeaaec@arinc9.com>
In-Reply-To: <68902e34-8ef4-994b-8e89-d42b55aeaaec@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8362:EE_
x-ms-office365-filtering-correlation-id: beeabaaf-31b4-42a7-dfa8-08da95a4c1a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E2s7m4klFFw38njZ6nx1bDbCW0BVKuz78/LXXPCXfulhiLgbmxpaD4qTkXQRBSdc2hZ7gsMbAstFtU3J3ISMngjC1PWo08uA8x4uo+Yz7GrwmSBP3vgLDbrGLo6IP8mFNM0I7N/DytO24LYyLEuwHAM4wzNiXVtfyLruuyDRA2QOFGQnCrZkG1LY9EDCS2GBP/TWn8bnvC4DXaArGbXmW8plMwm/GiUnVAb1h80FlLq5htSAu+gwEAY2ag9r8Fl+ZblOReYYDivW1j28OpfBXGXurAREF6budbWSt5elCrSd9VHX6NAzBy4QR/9RqdMnXy63fNVQ5XT1ukRiV+lOKWbseJ7K9DSGOJamvkETOfIIPuSyVkV8s6kDUP/f7R74LfbkbQUO6JSOb3Ife+n7F23JyYYfeht8a96jwHnfM7FLctY0bxNea51/2UCSUDDclNNtUwok00o3P0M8SUHkvjOem12u4V41kvbNIZzC9e/KM/PhMNuPorgU6oa3BEdG0mPTthoC3igbkWY/zcsEMCsSHNgK47Vkqt4rNNXKZJtTPb53a6mY3idV4ii40anrRETeAmXNDOT9a5xyKuznt1DtTli1ARUq/ShKPfDLJPuvP72hP1yGdYNJy3syY2PLLAC0FTJAEyqdeQN+Tw5UHuESQUXOxJDCVMh6UQ1vI5d9n4D149NPFgZE4UPbd3VOw3Kg9O6Eb9maoh8eGyGODDiInK93CYkArdnNMaq8vJA1lc6dYbOUROlHWqPAHOgm7sK6VKueDsYxv/hjX3D2dg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(6512007)(66574015)(38070700005)(66476007)(478600001)(86362001)(44832011)(2906002)(4326008)(4744005)(41300700001)(66946007)(76116006)(8936002)(26005)(316002)(53546011)(71200400001)(6916009)(54906003)(1076003)(9686003)(5660300002)(186003)(91956017)(6506007)(6486002)(38100700002)(122000001)(66556008)(7406005)(7416002)(66446008)(64756008)(33716001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWRDQklKekpnV0c2UmZiQWFoZGVub3I0RlJvOW1zOWo0Rng1anZZcjNNaGZT?=
 =?utf-8?B?ZllxWktYZW9WTGFrdWg5L0RDMFNhTkNLam5NcnIwa0NkUnluVUpsb2x5Ync2?=
 =?utf-8?B?UDU5RGNrMDR1QWlNSVA1QllHWGhVc3dwc3h4SDRKRURYdGM1YzNEb09yZmZv?=
 =?utf-8?B?bmJRMlVyZUlBeVM1bXJ1T1doM1k2eUIvT3lDdWMxRng3dU0vUVhwbXc4TUFk?=
 =?utf-8?B?U1ZQbXBqMHhJL1hkMVVoY3R2Z3I2WUNpNU0yVkJ4cWdDa29uUldXcTJqN2t1?=
 =?utf-8?B?UUV6QitkVDFFMHNDRG1pMi92TUJnMlZsYWp4MzhqMXF3aS9nWm4rcjZsNDRo?=
 =?utf-8?B?dktmVkg5VDMzSEE4VTd4K0hYaE1OMmRaVFkyVitUd2JrSVRIVUNBR2E0U0NP?=
 =?utf-8?B?RDJpRUxnSUQzUmh2UzJOMTJrVW96dU9NYmsxdWdqNWQ0NFB5YVV6SjRwL0dX?=
 =?utf-8?B?TFNWa2Z3UUFMQUVOU2RackIxbEhZcGd1RmlNUW9LZFBtSGRuSVVOYmsyTFFo?=
 =?utf-8?B?SzdMVkUrUjZZQTFkNHB2akJjNS9KK1E2dW8rRHRQby9GbTJFa29DWjdYNzd4?=
 =?utf-8?B?NGdTSEFjRnQxNEhPMmhiT04vNk1OQnBGelV5MmRPUmRlQ0E4S0xBYkFMLzZM?=
 =?utf-8?B?OC9DWDhhbG1QVTI3WG5NbjJWcWNscGl1SkxlMy93SWR3amlQcGdkMUcvbkdr?=
 =?utf-8?B?Y29XKzJFelpRY0dWMERKQmlUQWZEU1JsY21iSUs1UFkwdjRiRnlJdElnM0lh?=
 =?utf-8?B?b2tWSjVqSCtnaEp1UzZSTFA0NnFwNEpjN1NOdkYvc285aTdzSXYvNHhpSm1v?=
 =?utf-8?B?QkdEMFUveFByMDB0ekZlSXFLdEhpZVM0ajg5TUJxdTVRUHNWSVpLTVYraUdv?=
 =?utf-8?B?UE91Q3A2bXU5ZW9CN3h1b1JqUUJ4dlFOeG9TRUFnTXJLT3NSWDNLQUtqbURS?=
 =?utf-8?B?SG9XV1RDL3VhNzBYMEpobUVOQkNQa2xrdVRvMVBjVURWbHVOZW01eWR3bjFC?=
 =?utf-8?B?N3d2RUpRdlZwa2x3Vnp4NWlldXVHVE5rY0RraUJOTEROWENsUWU2Vko2Y2RT?=
 =?utf-8?B?VGtzZi8zU0ozcjYzbTZFdlVOTDlKSHM5NXFKOFhPUTRHYzdiWUdBV1ovR1hZ?=
 =?utf-8?B?Qm1FSHVGVHNHOVNxNVFCTDZUWWc4WlVSMkR0S3h1ck5OekU5cktjNHExcXNJ?=
 =?utf-8?B?eVQ4VVNIMTYvc1FBRjlEVVF3QjRwNzF0WlRmVkwvTUZvQ1NKTnc1L1pUY25Y?=
 =?utf-8?B?d0c2RWtWNEtxYTNlRjh4WDllWTRxUUZyaFp0SFJRN3VBMlI5WkZMd2JzSHA2?=
 =?utf-8?B?Q0JhWHVQTE9td1hYZU0zY3AwdGpwMXppTUV6UTJETDNaM0hmSEw2RmZuUFRp?=
 =?utf-8?B?SzNtNHFOTEtnd0ZCc1lBRmRwL0tpVWptQUwyUjMrclFEdmRWdFc5TndIbktF?=
 =?utf-8?B?UmpjQzQyeitZeFN3SCsvbWtCODN3VVg2RFFLWWtFRVEzeFB4VjFvdE1NRDkz?=
 =?utf-8?B?aHhKR09tdEI2THUwcnJPS1FKMnpyNVQ1aW1zdFB6dlBodGVCUVo4SjdWczky?=
 =?utf-8?B?T3owRk00YVRCczFYZnVRVTBSY0Q5Z0ZlZmJHK2NJbnZReUtEaytnK1NWRFZL?=
 =?utf-8?B?RWFTVGs0VVU3NVIxZzdHNlRLZFV3Wkwzd3g5WVgzckN6dzQxanlXSnhhRUU0?=
 =?utf-8?B?K1lzaHBneEpDTitSNmVlcHdpbWhneDRxYnFLaHZXUFpqMjV0VzYvdDR4ZFFm?=
 =?utf-8?B?TDJrUEQvMnFpMXovd1RFUnZRcnV1bTJxVDdYRGpncnlqNEUrVjhLKy9pTE9I?=
 =?utf-8?B?YU5kcHRIb21nNlpKN3B3MzJtWE1PcGZtR0dyeEV1YkFMZFZTWm5OLy9PWG1I?=
 =?utf-8?B?anVkdlNRYzlHS3NGT3pOODB4RGxjN09iRkhtZmFodjhKQm1yeFhBNnpMTm9S?=
 =?utf-8?B?Y2JJYXlWc3ZzNllwdEN0cFJhSnVqMnlGOGd2NFZwZUlobGtPSVJFVnlqa25z?=
 =?utf-8?B?d1Vub2ZwNHdESENQSU9WMGg4VlpTOU0xZlZFZ1gyanJsVXlQNnNoeG94Rlgw?=
 =?utf-8?B?OGUxTlRjbHcrSUJNL3E5UUx1Z2xjcmkxSmwrTUpYQjdNMUZKSnJaZEpTOUVD?=
 =?utf-8?B?NmRsaWxsbTdkU1FLaWhBUnBabDJvQVZONmZDM3FQV3dyMnM2cFV3UFNBOHds?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE384459A9982B42AB6021C4C6AFB193@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beeabaaf-31b4-42a7-dfa8-08da95a4c1a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 16:26:48.2057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ClUrXAsFlju+0P+KCQw3W0vzCG154eSzQm0AdxLvqoV6dNBuvIycTllmR/oIPYh9BzPVdIylYeebpaqiG97njQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8362
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBTZXAgMTMsIDIwMjIgYXQgMDY6NTU6MDVQTSArMDMwMCwgQXLEsW7DpyDDnE5BTCB3
cm90ZToNCj4gT24gMTIuMDkuMjAyMiAyMDo1MCwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiA+
IFRoZSBmYWN0IHRoYXQgc29tZSBEU0EgZGV2aWNlIHRyZWVzIHVzZSAnbGFiZWwgPSAiY3B1Iicg
Zm9yIHRoZSBDUFUgcG9ydA0KPiA+IGlzIG5vdGhpbmcgYnV0IGJsaW5kIGNhcmdvIGN1bHQgY29w
eWluZy4gVGhlICdsYWJlbCcgcHJvcGVydHkgd2FzIG5ldmVyDQo+ID4gcGFydCBvZiB0aGUgRFNB
IERUIGJpbmRpbmdzIGZvciBhbnl0aGluZyBleGNlcHQgdGhlIHVzZXIgcG9ydHMsIHdoZXJlIGl0
DQo+ID4gcHJvdmlkZWQgYSBoaW50IGFzIHRvIHdoYXQgbmFtZSB0aGUgY3JlYXRlZCBuZXRkZXZz
IHNob3VsZCB1c2UuDQo+ID4gDQo+ID4gRFNBIGRvZXMgdXNlIHRoZSAiY3B1IiBwb3J0IGxhYmVs
IHRvIGlkZW50aWZ5IGEgQ1BVIHBvcnQgaW4gZHNhX3BvcnRfcGFyc2UoKSwNCj4gPiBidXQgdGhp
cyBpcyBvbmx5IGZvciBub24tT0YgY29kZSBwYXRocyAocGxhdGZvcm0gZGF0YSkuDQo+ID4gDQo+
ID4gVGhlIHByb3BlciB3YXkgdG8gaWRlbnRpZnkgYSBDUFUgcG9ydCBpcyB0byBsb29rIGF0IHdo
ZXRoZXIgdGhlDQo+ID4gJ2V0aGVybmV0JyBwaGFuZGxlIGlzIHByZXNlbnQuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4N
Cj4gDQo+IEkgcmVhbGlzZWQgImR0LWJpbmRpbmdzOiBuZXQ6IGRzYTogbXQ3NTMwOiIgcHJlZml4
IGlzIHVzZWQgaGVyZSBpbnN0ZWFkIG9mDQo+IHRoZSB1c3VhbCAiZHQtYmluZGluZ3M6IG5ldDog
ZHNhOiBtZWRpYXRlayxtdDc1MzA6Ii4gRG9lcyB0aGlzIG1hdHRlcj8NCg0KU2luY2UgIm10NzUz
MCIgaW1wbGllcyAibWVkaWF0ZWsiLCBJIHByZWZlcnJlZCB0byBza2lwIGl0Lg==
