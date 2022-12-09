Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BC2647BD4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLICEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiLICEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:04:34 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2053.outbound.protection.outlook.com [40.107.8.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6BB7D082;
        Thu,  8 Dec 2022 18:04:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ere5b08fFgiDAalCn4G9TO42Vq2/N98PO3UYOZaEokpKPSwsenuSE6DNHKzdalqLAqw37vkqDBbWylGc+Z3+QHA2BBqxku/03bd+UDMWiuiw1ctGUVPuhqWRTt9K4jt93H72Oy809k+djQq5mZssi5c2+s9Ecp3Vahog/9WMKycsZesHfnXS/kJYWk/PS6K5cKjC+lmNCDCCKTCNK34uXX7FzTmxO2xVmqSWuyXk3e/JZBVKyHVNd7LRSmS4/hlPDPiKAWXt3mZ1TPtLHg6MqiyKVemHXsWNPRq8Vanb4tncob/QzdbWL6JvH7eBg0jIBAwCh0MK/w2EBbHIg8IkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/BWUpBGMmsF0GVnKHa8TdeMapGlR6TYfDk0eES7l14=;
 b=OHfgTUF3BYDLYRjjTTBMsTlnppE6CXqkvtmcJc57AbPMUzfQ4ZYZOL53UuU99z7eALcNWoOmTFOzjIJ4S8ptiNp/b7xbWNzT5HXVtlu6QwEg139s+pkVZwfwBg9bMX3bwg1pA4b205S12NWTyacE/TWvSXScALLRaYi5fHILM/0I+BH4dyM+x/B5R8eayofTNZpoyAOGKIGHMd4VNVsB7gFrxjoLnLwAi7DKyBQbQclxGY1uVtldRGV85yb7qD6n6RU+4bw2kUJhkUpZvuBCOutxvIU1g+FMGFasPE/G8B4Rqwjbf6wHcb2OMapN+w00vhMUCpLFc5tLES+jBh+u0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/BWUpBGMmsF0GVnKHa8TdeMapGlR6TYfDk0eES7l14=;
 b=MPfT/vGwgsJnxobyP0OrH5DNOjKlmbtYrRqy92IrpKa8s3qayRKX//MPjxmOj6YDpehvTDzjaNRP6ZprkZZHAX0jD/FEIy/JoxfH+PkpifAJ/cBH6nOfIDlHADSQWu0GaSh50HpC62hF3neJgCmz3AbwSsaiA/IKEybjdwwxLDw=
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by PA4PR04MB8047.eurprd04.prod.outlook.com (2603:10a6:102:cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 02:04:30 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d%10]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 02:04:30 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "open list:IRQCHIP DRIVERS" <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net 2/2] dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer
Thread-Topic: [PATCH net 2/2] dt-bindings: FEC/i.MX DWMAC and INTMUX
 maintainer
Thread-Index: AQHZCO/fL9TxDs0RJkirIgBV3qt6365k0rMw
Date:   Fri, 9 Dec 2022 02:04:30 +0000
Message-ID: <HE1PR0402MB2939E8D7DB1164240E3D2F49F31C9@HE1PR0402MB2939.eurprd04.prod.outlook.com>
References: <20221205212340.1073283-1-f.fainelli@gmail.com>
 <20221205212340.1073283-3-f.fainelli@gmail.com>
In-Reply-To: <20221205212340.1073283-3-f.fainelli@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0402MB2939:EE_|PA4PR04MB8047:EE_
x-ms-office365-filtering-correlation-id: 0c747a16-f253-4f23-431f-08dad989b53d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 224Yj1SyuF4D3g7AzpFg5ExnIwuQ0eYZ24yN5p9EbSb341F94rhOrB3l/i+/BuQClRt1CNnNqV81f0uYuEClm6mm5SH07Umeh3E3FiUxtjh7BJL/htWWTdgdQFmgwLwjZ8ffDlHFkIydR2P7P9RTS0mrfHA9MSwfry9ZYD5khRDtfWxWOdy1m4laMUdgvCU74e9DopyYUc5INph0KgX2wRhy3/ibPPzaJUMxnBGow+UZkuA8/FHPjd+Jb+4KrssqIdvzZpn21/EjJ2hN0FfwMyiSCroNB5EbBfZc2oqdmRylrus2ZBDITK597OIqVvZ8d6FNFUPNYHsGqFM0NDFkbjtFF6CI7xlTusTcDSnAcDX16Ke/6jkDLwa7FwbIVKwNyw9D039tadVK/eaM5eBrd54sO/YVfhNdyWpxEf5H/c+DbABiA1YtFe1+CRn66/IxMEVO2OS0HenkQrgag0G8hLshIlMjHnyl6StLqIwpfD++b3s9lnN0eZmJoDZukDhPPHaUFKn3gZmsIyLGdzUMuSgjGMKvFyighOIhIdc31ZKOJzrAuM58kaw7wH4DqjniI/T09nnvbwzxfaT3gEzYM0p/E4h867R9Iay0mkcShW5av2YBjGk9i0eF2walFE0qrWm9A/kLPV+U1JzdnyI4TlO/6in2Gg4Tj5mwouTWqnLGfpMXoy+ZCjOzQFIfOObapxmPrmjsTjznr0IuQWfbd3FH19grpKSF/ael2L8w070=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(122000001)(2906002)(38100700002)(64756008)(66476007)(66556008)(66946007)(8676002)(41300700001)(66446008)(4326008)(76116006)(33656002)(55016003)(86362001)(26005)(45080400002)(9686003)(38070700005)(8936002)(83380400001)(316002)(5660300002)(52536014)(186003)(7416002)(966005)(110136005)(54906003)(478600001)(6506007)(53546011)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?SEU5d1U2dEl0OHBjdmpXbktpV1lSOXBFWlh2citCLzcwemlrM1NtWXB2QjBG?=
 =?gb2312?B?Y1hHRjdrUll3VWtlcFFTeWFLN1NRZmx5M2VGQ1NiQ0JPQjUvdS9Zc2p4R0ta?=
 =?gb2312?B?S2NwQStUWTQvVlFmK1daaGs4Ty9TeGVVZUYyUzl0UU4rR2p2NUY5K05GVjJI?=
 =?gb2312?B?V2x0RjdobUI1QWovV29STHc4VFVTMnExZ1FQb0Vwc0szeGh5anBFZ3o3djJH?=
 =?gb2312?B?NFlna3NpL3B6bGxLYSt6NDJVQXpaaW5BdXppb2laNm82UHQ1UGExU3RzOUZX?=
 =?gb2312?B?bzBzaXVEV042NFhpWWo0NEQwbDdpNk9OUW9UdXo5NFZCRUhaOWM1SUJsOWpp?=
 =?gb2312?B?NHI3K1J3bnRSdE5MOGhkdjMwbHNoL1JudDljd3c1Wk5Lcm1QWDRrZWw5Q1RQ?=
 =?gb2312?B?bU9OeFdnR2dEOVpTSjd4bWNXZlRvNXdweHdLb3dET09UaVlYL2N5cllRRytY?=
 =?gb2312?B?eGpMdlZocUpBNUp0am1zMkhWRlZ1NU4rSzIxVFFZc1grL3V6c3VNcTJBOUJP?=
 =?gb2312?B?ZUYvVTNLR3h3YVNMTHViWGdHekRuYnkzYnoyMENSN2ppTktiOU04WndxU1JY?=
 =?gb2312?B?VElraGFNRGs4dVFCUEV0QS9RVEU1dW9GWHdQOHRuMXN6LzVxKzN4ek5OUjhi?=
 =?gb2312?B?aEY1Qmhkb0FRZHFJMXB6SWlTNGI2QTNObzdaR1g2Q1V6V1RVNFpvVkY0eTJ2?=
 =?gb2312?B?RFdMNDZZaG1IdTNzTTJhZ3RqZXFEWllpSVlpcC9oT2VGNHlLY1MrTjdKVGN3?=
 =?gb2312?B?VVFRaktla042ZkplSDFlWFFIak9xSmpLd2ZyY1E0SmVYeWRqYzhSQ01ZdlZk?=
 =?gb2312?B?eHNOOEtkcG9KZjhhbWJWWkRwd1c2SWg4bnQvdW5Cc0Z2ZTdVMzh1WHk1Z2U1?=
 =?gb2312?B?NzBMS2VHM09FRVdPeVJCMU50dDAxNHRNQUoyOURLb3hIb09wVWpSd051QmVR?=
 =?gb2312?B?Y3hvaVZzNGYrNG44LzZyUFlXNmk0d0xmeEQzMzV6VDV3bHRTdFBYdit6dXps?=
 =?gb2312?B?RVhnSG1JQ1Y1TFlVeCs2Um54enFvOHZqQ0lldWovdStnTFU3MXR4ZWU4V3h4?=
 =?gb2312?B?OWplclloRUltcm93VmFmZFdHY0xlak94eUgwTVdHdGwxdnJKN1lFdTlKeUtD?=
 =?gb2312?B?bG1nRTlLNXM3U0VBVnl5WldlRGFMbzczNm9ZVzROZGk1UElJY08wdG5rMDBY?=
 =?gb2312?B?b200Vm5QL24vdFh1WDNEVWN2T1ZDTUJxMzl0UDdTOFk5QU1kMmNJS2lvUnNT?=
 =?gb2312?B?a0FzNTZQN2NYY1puVGtvRmZmTnMwVFpKZzlyRjR1b1RNbTMrdFZzaHBqVFBQ?=
 =?gb2312?B?N3d4TitTUjhUTk1KVEtVYy8xNVhkTTF1MFZxQTMySW5hdlRGSFdLT0pndTVv?=
 =?gb2312?B?cHl2ZTI4N2xINmV2RlJNYWxFVGU4UWUyeUxIZzJZRXc1SURRU0tLdmQ4cGFB?=
 =?gb2312?B?ZHYzYjRweDZrNjJoMUw2a0Q2WTNrUzNja2YyR3hvc2JyTUw5eWdxcldTU1Vi?=
 =?gb2312?B?bWduYm9vMC9ySGVWWXMydnd2V1ZIQzBpb2tUT0VZV21kdzAxdk95UEc4UFc3?=
 =?gb2312?B?VTc0cDN0L2JjK05TMWowT1VEUmRLMTJwUlVseW1XU0FUU0UvcFlhNlFRL2l2?=
 =?gb2312?B?Q3Y1V2dDRnRqODh4NXNjb216Qmt0Qm9NeWFKWEhsMHVSYThKamJBT3NEYlZM?=
 =?gb2312?B?RmtxYk1qbkVieUdOU2ZZUFFkUWdvRHZHOHkyT1QwK0JBMS9JYndYUnI1VkxQ?=
 =?gb2312?B?VFFNSFNIdmh2TTVjWVIzR2k2UW10TXJ0UVBFSGJYTThZY3RROU9nenQ5YlBs?=
 =?gb2312?B?KzdxM05nRmZnRXNmZ1REYWFXYk9YcGg0VDdGZHFFY0xNaXNJQjY0QTVKLzR4?=
 =?gb2312?B?TW1RSGl1dm1rYWhBdFlLeUFyOWN3dHpobVJKb1QrWUtxZnJoYzJQN3c0VXdx?=
 =?gb2312?B?ZmN3SFhHc3BQVUh5T3RxQThYczBIL0JQYktHRmJKeXZyWDQ2L09tdElQdlFP?=
 =?gb2312?B?NHBIT0x0TE1UeWZpSWR1Q1ByZlJOQ3VGOVVwdkxFbmZFQlFBVlN4MFlhUnFS?=
 =?gb2312?B?RmhNSkd6RDhCeGJwZjJEZGtudThqOUQ4cGRiUDNRYmVJUXNGUkhQeXJVYVpL?=
 =?gb2312?Q?6fTAiK0I2C00eSNTT/O/RvZHt?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c747a16-f253-4f23-431f-08dad989b53d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 02:04:30.0628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QlSDOFZ3PPB+1Tf/34ozQzBTE96rpDGC+tEa/zMzQ29jJ4cnBbjhYsW3KrYPhDL5xp4XcyGLZ88RulRqVBLIqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8047
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZh
aW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMsTqMTLUwjbI1SA1OjI0
DQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT47IFRob21hcyBHbGVpeG5lcg0KPiA8dGdseEBsaW51dHJvbml4
LmRlPjsgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz47IFJvYiBIZXJyaW5nDQo+IDxyb2Jo
K2R0QGtlcm5lbC5vcmc+OyBLcnp5c3p0b2YgS296bG93c2tpDQo+IDxrcnp5c3p0b2Yua296bG93
c2tpK2R0QGxpbmFyby5vcmc+OyBTaGF3biBHdW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+Ow0KPiBk
bC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBk
YXZlbWxvZnQubmV0PjsNCj4gRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVk
aGF0LmNvbT47IFNhc2NoYSBIYXVlciA8cy5oYXVlckBwZW5ndXRyb25peC5kZT47DQo+IFBlbmd1
dHJvbml4IEtlcm5lbCBUZWFtIDxrZXJuZWxAcGVuZ3V0cm9uaXguZGU+OyBGYWJpbyBFc3RldmFt
DQo+IDxmZXN0ZXZhbUBnbWFpbC5jb20+OyBvcGVuIGxpc3Q6SVJRQ0hJUCBEUklWRVJTDQo+IDxs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgb3BlbiBsaXN0Ok9QRU4gRklSTVdBUkUgQU5E
IEZMQVRURU5FRA0KPiBERVZJQ0UgVFJFRSBCSU5ESU5HUyA8ZGV2aWNldHJlZUB2Z2VyLmtlcm5l
bC5vcmc+OyBtb2RlcmF0ZWQNCj4gbGlzdDpBUk0vRlJFRVNDQUxFIElNWCAvIE1YQyBBUk0gQVJD
SElURUNUVVJFDQo+IDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+DQo+IFN1
YmplY3Q6IFtQQVRDSCBuZXQgMi8yXSBkdC1iaW5kaW5nczogRkVDL2kuTVggRFdNQUMgYW5kIElO
VE1VWA0KPiBtYWludGFpbmVyDQo+IA0KPiBFbWFpbHMgdG8gSm9ha2ltIFpoYW5nIGJvdW5jZSwg
YWRkIFNoYXduIEd1byAoaS5NWCBhcmNoaXRlY3R1cmUNCj4gbWFpbnRhaW5lcikgYW5kIHRoZSBO
WFAgTGludXggVGVhbSBleHBsb2RlciBlbWFpbC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEZsb3Jp
YW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiAtLS0NCj4gIC4uLi9kZXZpY2V0
cmVlL2JpbmRpbmdzL2ludGVycnVwdC1jb250cm9sbGVyL2ZzbCxpbnRtdXgueWFtbCAgIHwgMyAr
Ky0NCj4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1s
ICAgICAgICAgICAgIHwgMyArKy0NCj4gIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbnhwLGR3bWFjLWlteC55YW1sICAgICAgIHwgMyArKy0NCj4gIDMgZmlsZXMgY2hhbmdl
ZCwgNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdA0KPiBh
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9m
c2wsaW50bXV4LnlhbWwNCj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvaW50
ZXJydXB0LWNvbnRyb2xsZXIvZnNsLGludG11eC55YW1sDQo+IGluZGV4IDFkNmUwZjY0YTgwNy4u
OTg1YmZhNGY2ZmRhIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvZnNsLGludG11eC55YW1sDQo+ICsrKyBiL0RvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9mc2wsaW50
bXV4LnlhbWwNCj4gQEAgLTcsNyArNyw4IEBAICRzY2hlbWE6DQo+IGh0dHBzOi8vZXVyMDEuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwJTNBJTJGJTJGZGV2aWNldHJl
DQo+IGUub3JnJTJGbWV0YS1zY2hlbWFzJTJGY29yZS55YW1sJTIzJmFtcDtkYXRhPTA1JTdDMDEl
N0N4aWFvbmluZy4NCj4gd2FuZyU0MG54cC5jb20lN0M0MTliYjc0YTkwNGM0YmE2ZDExMDA4ZGFk
NzA3MDEzYyU3QzY4NmVhMWQzYmMNCj4gMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdD
NjM4MDU4NzIyMzI0NjQ4NDUxJTdDVW5rbm93bg0KPiAlN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1D
NHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhVw0KPiB3aUxDSlhWQ0k2TW4w
JTNEJTdDMzAwMCU3QyU3QyU3QyZhbXA7c2RhdGE9RTJMbDBRQ0V5JTJGSjNUSWdaDQo+ICUyRkQx
cnN5MyUyRlRHRSUyRkMlMkZLSFN2ZSUyQmpCVkVGaW8lM0QmYW1wO3Jlc2VydmVkPTANCj4gIHRp
dGxlOiBGcmVlc2NhbGUgSU5UTVVYIGludGVycnVwdCBtdWx0aXBsZXhlcg0KPiANCj4gIG1haW50
YWluZXJzOg0KPiAtICAtIEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+
ICsgIC0gU2hhd24gR3VvIDxzaGF3bmd1b0BrZXJuZWwub3JnPg0KPiArICAtIE5YUCBMaW51eCBU
ZWFtIDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gDQo+ICBwcm9wZXJ0aWVzOg0KPiAgICBjb21wYXRp
YmxlOg0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC9mc2wsZmVjLnlhbWwNCj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L2ZzbCxmZWMueWFtbA0KPiBpbmRleCBlMGYzNzZmN2UyNzQuLjgzYjM5MGVmOWFiYiAxMDA2NDQN
Cj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlh
bWwNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVj
LnlhbWwNCj4gQEAgLTcsNyArNyw4IEBAICRzY2hlbWE6DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxp
bmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwJTNBJTJGJTJGZGV2aWNldHJlDQo+
IGUub3JnJTJGbWV0YS1zY2hlbWFzJTJGY29yZS55YW1sJTIzJmFtcDtkYXRhPTA1JTdDMDElN0N4
aWFvbmluZy4NCj4gd2FuZyU0MG54cC5jb20lN0M0MTliYjc0YTkwNGM0YmE2ZDExMDA4ZGFkNzA3
MDEzYyU3QzY4NmVhMWQzYmMNCj4gMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM4
MDU4NzIyMzI0NjQ4NDUxJTdDVW5rbm93bg0KPiAlN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdM
akF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhVw0KPiB3aUxDSlhWQ0k2TW4wJTNE
JTdDMzAwMCU3QyU3QyU3QyZhbXA7c2RhdGE9RTJMbDBRQ0V5JTJGSjNUSWdaDQo+ICUyRkQxcnN5
MyUyRlRHRSUyRkMlMkZLSFN2ZSUyQmpCVkVGaW8lM0QmYW1wO3Jlc2VydmVkPTANCj4gIHRpdGxl
OiBGcmVlc2NhbGUgRmFzdCBFdGhlcm5ldCBDb250cm9sbGVyIChGRUMpDQo+IA0KPiAgbWFpbnRh
aW5lcnM6DQo+IC0gIC0gSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
KyAgLSBTaGF3biBHdW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+DQo+ICsgIC0gTlhQIExpbnV4IFRl
YW0gPGxpbnV4LWlteEBueHAuY29tPg0KDQpGb3IgRkVDIHlhbWwgZmlsZSBtYWludGFpbmVyLCBw
bGVhc2UgYWRkOg0KV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQoNCj4gDQo+ICBhbGxPZjoN
Cj4gICAgLSAkcmVmOiBldGhlcm5ldC1jb250cm9sbGVyLnlhbWwjDQo+IGRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L254cCxkd21hYy1pbXgueWFtbA0K
PiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbnhwLGR3bWFjLWlteC55
YW1sDQo+IGluZGV4IDRjMTU1NDQxYWNiZi4uYmQ0MzBkZWRlMjQyIDEwMDY0NA0KPiAtLS0gYS9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L254cCxkd21hYy1pbXgueWFtbA0K
PiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L254cCxkd21hYy1p
bXgueWFtbA0KPiBAQCAtNyw3ICs3LDggQEAgJHNjaGVtYToNCj4gaHR0cHM6Ly9ldXIwMS5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAlM0ElMkYlMkZkZXZpY2V0cmUN
Cj4gZS5vcmclMkZtZXRhLXNjaGVtYXMlMkZjb3JlLnlhbWwlMjMmYW1wO2RhdGE9MDUlN0MwMSU3
Q3hpYW9uaW5nLg0KPiB3YW5nJTQwbnhwLmNvbSU3QzQxOWJiNzRhOTA0YzRiYTZkMTEwMDhkYWQ3
MDcwMTNjJTdDNjg2ZWExZDNiYw0KPiAyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2
MzgwNTg3MjIzMjQ2NDg0NTElN0NVbmtub3duDQo+ICU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTUM0
d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXDQo+IHdpTENKWFZDSTZNbjAl
M0QlN0MzMDAwJTdDJTdDJTdDJmFtcDtzZGF0YT1FMkxsMFFDRXklMkZKM1RJZ1oNCj4gJTJGRDFy
c3kzJTJGVEdFJTJGQyUyRktIU3ZlJTJCakJWRUZpbyUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiAgdGl0
bGU6IE5YUCBpLk1YOCBEV01BQyBnbHVlIGxheWVyDQo+IA0KPiAgbWFpbnRhaW5lcnM6DQo+IC0g
IC0gSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gKyAgLSBTaGF3biBH
dW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+DQo+ICsgIC0gTlhQIExpbnV4IFRlYW0gPGxpbnV4LWlt
eEBueHAuY29tPg0KDQpGb3IgZHdtYWMgZ2x1ZSB5YW1sIG1haW50YWluZXIsIHBsZWFzZSBhZGQ6
DQpDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+DQoNClRoYW5rcyENCg0KQmVzdCBS
ZWdhcmRzLA0KQ2xhcmsgV2FuZw0KDQo+IA0KPiAgIyBXZSBuZWVkIGEgc2VsZWN0IGhlcmUgc28g
d2UgZG9uJ3QgbWF0Y2ggYWxsIG5vZGVzIHdpdGggJ3NucHMsZHdtYWMnDQo+ICBzZWxlY3Q6DQo+
IC0tDQo+IDIuMzQuMQ0KDQo=
