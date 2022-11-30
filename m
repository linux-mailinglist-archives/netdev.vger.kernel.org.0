Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9FA63D4C5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiK3LkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiK3LkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:40:02 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2068.outbound.protection.outlook.com [40.107.249.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83852E68B;
        Wed, 30 Nov 2022 03:40:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1Wb+yWHr7wpDPbohAciQsB9yGMXyE+pl7222e9xDQe4uTGAEshB0ZwyvrSxgcMnhzWoxaLfumZxkGTMMSuxcbxhPbn0yUFJcQ6ZG6rUORO9ohMF3kLfR0PYPDe5QUeqA570qWGmZaV1hxgaPzESF0ML6bN9XokUYgspEAVKEZKJR7/eaMvTc1ONdY1LQgZaVsob+wNKRBDNkkJVqdEmhR615+JWmM6C9fNktm2nZSkpkOcn6aLkKtyvbJt+gSWGDRr3Wnn6W+1h7cmDowWo8osNNFO2vBENrIvNJrnkhprbJHl4LCA79IqxIpgSMVR9L8v71rcVvvGGAoJELkyZ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYYjiE1HA4yfuKzaaFmXY6wJVj9aU6v5x2i3oigLmfY=;
 b=JW26FiOtkV+mkmcF6dZNswnjM+fcIvh+r11spPq5y9FFgwtgNyE6G2CRGqKXiX/EjedjKRUeaE7Y3HCfnEOpzxTXN8cAkrPpOKP3bZ0Et5+TdprNHm2lXGWinEOm3IVXUtV0y0cbWOH7FPrIlJyGpn4/dP1lK4KDXnIVWeZ1+5kDAjLtpiBQOHUg34BZ2Szjg+Qqo0GNEEhDCRoSZBqwhNkReLTqPwO25UtNF+kXfwSSmfnmvA3QJyvvPJqwNYMezsBK5Uhz9Okx3SdwCplY9MoKlkNNl+IU7d2CRg4XmljGyKEUu8tpsroI26KtMuktcQHEQgons9C8Vc97WBQtyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYYjiE1HA4yfuKzaaFmXY6wJVj9aU6v5x2i3oigLmfY=;
 b=IwoXYVBwc1fgkq8faFmgWwEvQ79pUiZGGC0DAiRrg9IvCquSHtt3f9afpTmn+szH9mG9pIAnZq55D/Ovs0Cpo86iSe6bzxJ/gWMpAeGolMtyqvTk9yLczmlkYuG/r6gBWz4CMdqIFx3tfPQJXqlIR7vu1ehwfZg8uN2n/1wZYa0=
Received: from DB7PR04MB4010.eurprd04.prod.outlook.com (2603:10a6:5:21::30) by
 DB9PR04MB8186.eurprd04.prod.outlook.com (2603:10a6:10:25f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Wed, 30 Nov 2022 11:39:59 +0000
Received: from DB7PR04MB4010.eurprd04.prod.outlook.com
 ([fe80::3cee:dfa4:ad62:235a]) by DB7PR04MB4010.eurprd04.prod.outlook.com
 ([fe80::3cee:dfa4:ad62:235a%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 11:39:59 +0000
From:   Bough Chen <haibo.chen@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: add auto stop mode for IMX93 to support
 wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: add auto stop mode for IMX93 to
 support wakeup
Thread-Index: AQHY/mk4wwKpFHZUnky0iCvLq+XEWq5XV1yAgAAL5YA=
Date:   Wed, 30 Nov 2022 11:39:59 +0000
Message-ID: <DB7PR04MB40108B020348197573BF5AF090159@DB7PR04MB4010.eurprd04.prod.outlook.com>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
 <20221130105417.yhljwl5dtuu5f2du@pengutronix.de>
In-Reply-To: <20221130105417.yhljwl5dtuu5f2du@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB7PR04MB4010:EE_|DB9PR04MB8186:EE_
x-ms-office365-filtering-correlation-id: 311f72cd-74e7-49ad-2d5b-08dad2c79c67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /wwtYxc1nzfvQXow80X+M4a33YjidIdH0FpOFcb8vxY3jF952o+pCxmYUw6qaDbD37m07a5Ba0qEM5cLnZONuwIiuXKEi+bVwTUt5VSY0SDbpQ4CyUaeVdPd4iMApg3mkg9/xdDMzDRd1YrVVcYat0HYfN6N3OMsZt7nfGcP2/k1MGLyikKP6mqS1YAtwzYSQUK4BP6qSgHIHvNRzgRXlVkHqKoJo/7vC6btzdZU5UXrn2KHAlLhTY4XnpoEQXjt23QmdtvyjhbIBrERYWOIeXt6DVAEhJdeY4SBEQkX4sI1IwGjCg6t1L29TJerIjhLXTFkuCg/kPopLd780ceV2+uJk9cKldot4LEFnBZfCizGqhd+tkSwyuItzcBVKsUM9qX/1gTVjr6C4J7TX5piqn57NqHYWvp7gGXj2xj7dN9ZreWK7G3uu46rUS4njteE6+pRSISFgCiWOMl5utlJihVZVJV7nr3EiOMa+HBiuXZRBx6hOAgvYVGDmLvpIEIsrXyrwLHxbll1fTg5JwGxcNUdKrdhNG60+bfpYANWVaEjMSbkg0UmoEQ4cj2z1ykhJZzv3qA0ZFH0bZak77kspcUJJ//3T7vufTaeThlWXv3IPutMk17G65CFRWuYiHx2MEW0vMf5Mi+EJqjm71Zn3O4Y49IbzuPzATYuAJdey/E/jj8+RWc4xeKtZjIhz5iLA9uLtg6Bpkziv8uQL6BLU1a3h2tdg2VwS0DU9lBGV0I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4010.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(2906002)(478600001)(186003)(66946007)(9686003)(76116006)(7416002)(5660300002)(6506007)(53546011)(52536014)(26005)(7696005)(33656002)(8936002)(41300700001)(86362001)(38070700005)(55016003)(8676002)(83380400001)(4326008)(66476007)(66446008)(64756008)(6916009)(71200400001)(38100700002)(316002)(54906003)(122000001)(66556008)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTNTUjY0dTlmQlMzWE43aWd3a3VCUThiS3loNkVvbEFBUmlNUW43a3cvTWxi?=
 =?utf-8?B?cFVLazBSeVQ1Y0lLRE8xOGx6SklCT0NjTkJzZXZMUS9RS2lvbFE2RUxFZ2VC?=
 =?utf-8?B?RXJwTFduZHJZSVViMzN5STVodHEvQWNJSyt0eUwwcko4Qnk3aTdpV3N3MkZQ?=
 =?utf-8?B?b3lpbnE3Uk5zWUdYTHhRY3VYMG13NG5sWjhjMHdqbjRERldSR1FxN2RXRGxy?=
 =?utf-8?B?WUdHNnpaT0p3ejdZUUtJeW55Y0RwZVJlVHJyNG10K3p3b2h6T1BTbFNRd2R5?=
 =?utf-8?B?dStBMlc5ZTBoMUJuRXVYaHpxdVhGcnF2WC9BVnl1VTJKRzFoaDBJL0EvQUov?=
 =?utf-8?B?c29ENEZrTWFLTnNQUG1FdVh3MHc1L0gwdlRMWjZSazFoMkFSZ2ErZ1B4d1Mv?=
 =?utf-8?B?WFNHUlNWcVRxUmhWbWN4QWZHSFZjWC9jSEExVXdGYUs3V3p2em5yaFBseTRS?=
 =?utf-8?B?WEZHWTJkWE8xZDFzb2gxRUlXMzZuSkY2ak9NYUpGMjEvWmxxREVmUU1pdHdm?=
 =?utf-8?B?S2Y3emFYMXJCN1Frb01NVEJoUkNoMmhHRVRoaEkzYVYyQUtycFRoV280Z3pq?=
 =?utf-8?B?MHRwRGZkN3hUNGFmc1hKUi9xVXp2bnNJRGI0VFRpNzh5ZFZtcWpIM2c2VEhH?=
 =?utf-8?B?emsrdExnVjBSeXVOL0xKZlM2TzZ6Z2YyemZGOE9STnFHSjhIM1VOcWhESmdQ?=
 =?utf-8?B?OCtOUGVCSzMvcGpQMXltcDdWS0xpQTBGb3NId2VRN1NVZ2kyQnhHUHRkS1Vk?=
 =?utf-8?B?amFzb3ZsOFY5cjRUN1JUeDA1VmNxblc5aTZ2QU9COVloVEVzRVJFSTVXWi8z?=
 =?utf-8?B?QUdrZ2ZkUGxaOXZxSjJVblNZYjZGRGVPSXpxeHBNRnM5Q09VSy9nbnFMVi9I?=
 =?utf-8?B?VExhMWUrYkdaRFd0VWh1Q1VHL2RCWUR6K0FXTitSaGk5TGxQZnNzQTZzQWV4?=
 =?utf-8?B?aFVzUVVFSzVveTBXOG1lRjBRWExyRTNaeExPUmFscjEvT256cW0vVTlMV2Jq?=
 =?utf-8?B?ZDRJeDl1RjlVOHY1ZThVSG9mV2ExNFZNbCtvZ3hnL2hzSUpVUjI4cjJhKzE1?=
 =?utf-8?B?OXFzUldrTFUxWDFpS3paUVlmd3FpNllqcWNZdWIxQzk4S29rbmZ3RGxnM1VT?=
 =?utf-8?B?UXdCaGorUCs4Q3oydWRHd0gzRWtYWmh4UXdlak9RMHQ4Y3lBVG81MlZvdC9h?=
 =?utf-8?B?bVJIU0kwQ0x4RCtVQnYrVVpuZEJ3cXprTjhDSUlVMW1Ia2dZNFg2TDJlK3ha?=
 =?utf-8?B?L3FBOHVmQkZLVU5EVXA5ZU1qcGp2UTdGYitURENtSVhtNUwxYzVCRXNqVStz?=
 =?utf-8?B?aVRIR2dUUGpPQXNDNHQ1S1FJb2pKWTZNbkxUUlFLUU5kUlVxR0h2RHJzUEZt?=
 =?utf-8?B?eHBTWU1pMFhZaUJ3VFNTS0FSa1VZM2ViWCtCVlhVYVpYL25pdHdnQVVHeFFQ?=
 =?utf-8?B?dEZSeEY4b0JiVWlUN0tMZTY1OGZQcHZ2SVduQVVYcyt4SUdqMEJGMG0yeW56?=
 =?utf-8?B?aWUzdWdhYm15ZjVEemxMYWFYaTZob1loTDFHZUxzK1FjVXZ2YnNVQVAzS2U0?=
 =?utf-8?B?MElaU0Z1QTVydFBTU2Y5ZForS08wZnFYNng3MmJwc080dmZoeUdTRXB6ZXhQ?=
 =?utf-8?B?UDZQK0lMSDFJQ0dWSmdGMWhsSllLY205cTdWbno0bTU4ak4yZHZROFdnVE5p?=
 =?utf-8?B?NWp0YXFPUTZTWGlaazZ3RU1iMk5CVDRnbXF4ekpWTGJRT29WNUlTTzdvbUt0?=
 =?utf-8?B?Mml1UVVQMVQ5VVU4TUFCNVcxaElBRVM4Y28yNGtTRDI5cUV0N2tBSnJKLzBh?=
 =?utf-8?B?cWFtRmlldkREY1BLczc5YlJ1WUlWTnJTRHdDbVMxQkdyQzNaZWVVWnZQdlM2?=
 =?utf-8?B?ZUI3WVhmLzVOTjZOelloL0NwckVNdXVjRjBRKzNpR1VxM1UwOHFESVZJc0d1?=
 =?utf-8?B?ZzFWMXpLdjNPQ0dZd0JXRkJkR1F0YzN1cWxJWCtHS2RBQ244VHFiNE1FR3Bt?=
 =?utf-8?B?WWJ2V3VQMlFWMHVaVEhkT3RONUZFWlQycmwvQzcvZTZPK0J3elRDdzBDWVVM?=
 =?utf-8?B?bUEzRkkrL1VIMUZqWWRlazg2eENONWVsSm4zbGljV25MdkZEOU4rU1E5TDkx?=
 =?utf-8?Q?UWSDiReO8v3xF+FdHi3WqjJCs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4010.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 311f72cd-74e7-49ad-2d5b-08dad2c79c67
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 11:39:59.0522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SUc0OLlggIgEuxVuI4FCdFB0x/Hy+YWWshJLOCIcvpDeWNPPLF7G3WnoP9AaMSvz9Bbb1srjehlRL90ZCIbkgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8186
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIEtsZWluZS1CdWRkZSA8
bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDIy5bm0MTHmnIgzMOaXpSAxODo1NA0KPiBU
bzogQm91Z2ggQ2hlbiA8aGFpYm8uY2hlbkBueHAuY29tPg0KPiBDYzogd2dAZ3JhbmRlZ2dlci5j
b207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207DQo+IGt1YmFAa2Vy
bmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4ga3J6eXN6
dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOyBzaGF3bmd1b0BrZXJuZWwub3JnOw0KPiBzLmhh
dWVyQHBlbmd1dHJvbml4LmRlOyBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGZlc3RldmFtQGdtYWls
LmNvbTsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IGxpbnV4LWNhbkB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBjYW46IGZsZXhjYW46IGFkZCBh
dXRvIHN0b3AgbW9kZSBmb3IgSU1YOTMgdG8gc3VwcG9ydA0KPiB3YWtldXANCj4gDQo+IE9uIDIy
LjExLjIwMjIgMTk6MzI6MzAsIGhhaWJvLmNoZW5AbnhwLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBI
YWlibyBDaGVuIDxoYWliby5jaGVuQG54cC5jb20+DQo+ID4NCj4gPiBJTVg5MyBkbyBub3QgY29u
dGFpbiBhIEdQUiB0byBjb25maWcgdGhlIHN0b3AgbW9kZSwgaXQgd2lsbCBzZXQgdGhlDQo+ID4g
ZmxleGNhbiBpbnRvIHN0b3AgbW9kZSBhdXRvbWF0aWNhbGx5IG9uY2UgdGhlIEFSTSBjb3JlIGdv
IGludG8gbG93DQo+ID4gcG93ZXIgbW9kZSAoV0ZJIGluc3RydWN0KSBhbmQgZ2F0ZSBvZmYgdGhl
IGZsZXhjYW4gcmVsYXRlZCBjbG9jaw0KPiA+IGF1dG9tYXRpY2FsbHkuIEJ1dCB0byBsZXQgdGhl
c2UgbG9naWMgd29yayBhcyBleHBlY3QsIGJlZm9yZSBBUk0gY29yZQ0KPiA+IGdvIGludG8gbG93
IHBvd2VyIG1vZGUsIG5lZWQgdG8gbWFrZSBzdXJlIHRoZSBmbGV4Y2FuIHJlbGF0ZWQgY2xvY2sN
Cj4gPiBrZWVwIG9uLg0KPiA+DQo+ID4gVG8gc3VwcG9ydCBzdG9wIG1vZGUgYW5kIHdha2V1cCBm
ZWF0dXJlIG9uIGlteDkzLCB0aGlzIHBhdGNoIGFkZCBhIG5ldw0KPiA+IGZzbF9pbXg5M19kZXZ0
eXBlX2RhdGEgdG8gc2VwYXJhdGUgZnJvbSBpbXg4bXAuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBIYWlibyBDaGVuIDxoYWliby5jaGVuQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L2Nhbi9mbGV4Y2FuL2ZsZXhjYW4tY29yZS5jIHwgMzcgKysrKysrKysrKysrKysrKysrKysr
KystLS0NCj4gPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4vZmxleGNhbi5oICAgICAgfCAgMiAr
Kw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4vZmxleGNhbi1j
b3JlLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuL2ZsZXhjYW4tY29yZS5jDQo+ID4g
aW5kZXggOWJkYWRkNzE2ZjRlLi4wYWVmZjM0ZTVhZTEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9uZXQvY2FuL2ZsZXhjYW4vZmxleGNhbi1jb3JlLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9j
YW4vZmxleGNhbi9mbGV4Y2FuLWNvcmUuYw0KPiANCj4gWy4uLl0NCj4gDQo+ID4gQEAgLTIyOTks
OCArMjMyMiwxNiBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkDQo+IGZsZXhjYW5fbm9pcnFf
c3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+ID4gIAlpZiAobmV0aWZfcnVubmluZyhk
ZXYpKSB7DQo+ID4gIAkJaW50IGVycjsNCj4gPg0KPiA+IC0JCWlmIChkZXZpY2VfbWF5X3dha2V1
cChkZXZpY2UpKQ0KPiA+ICsJCWlmIChkZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQo+ID4g
IAkJCWZsZXhjYW5fZW5hYmxlX3dha2V1cF9pcnEocHJpdiwgdHJ1ZSk7DQo+ID4gKwkJCS8qIEZv
ciBhdXRvIHN0b3AgbW9kZSwgbmVlZCB0byBrZWVwIHRoZSBjbG9jayBvbiBiZWZvcmUNCj4gPiAr
CQkJICogc3lzdGVtIGdvIGludG8gbG93IHBvd2VyIG1vZGUuIEFmdGVyIHN5c3RlbSBnbyBpbnRv
DQo+ID4gKwkJCSAqIGxvdyBwb3dlciBtb2RlLCBoYXJkd2FyZSB3aWxsIGNvbmZpZyB0aGUgZmxl
eGNhbiBpbnRvDQo+ID4gKwkJCSAqIHN0b3AgbW9kZSwgYW5kIGdhdGUgb2ZmIHRoZSBjbG9jayBh
dXRvbWF0aWNhbGx5Lg0KPiA+ICsJCQkgKi8NCj4gPiArCQkJaWYgKHByaXYtPmRldnR5cGVfZGF0
YS5xdWlya3MgJg0KPiBGTEVYQ0FOX1FVSVJLX0FVVE9fU1RPUF9NT0RFKQ0KPiA+ICsJCQkJcmV0
dXJuIDA7DQo+ID4gKwkJfQ0KPiANCj4gV2l0aCB0aGlzIGNoYW5nZSB0aGUgZmxleGNhbl9ub2ly
cV9yZXN1bWUoKSBpcyBub3Qgc3ltbWV0cmljYWwgYW55IG1vcmU6DQo+IHBtX3J1bnRpbWVfZm9y
Y2Vfc3VzcGVuZCgpIGlzIG5vdCBjYWxsZWQgZm9yIG14OTMsIGJ1dA0KPiBwbV9ydW50aW1lX2Zv
cmNlX3Jlc3VtZSgpIGlzIGNhbGxlZC4NCg0KWWVzLCBJIGRvIG5vdCB1bmRlcnN0YW5kIHRoZSBs
b2dpYyBvZiBwbV9ydW50aW1lX2ZvcmNlX3N1c3BlbmQgY29ycmVjdGx5LiBJIGFsc28gZmluZCB0
aGVyZSBpcyBhbiB1bmJhbGFuY2Ugd2FybmluZyBzaG93IHVwLiBNeSBiYWQuDQoNCldpbGwgZml4
IHRoaXMgYW5kIHNlbmQgYSBWMiBwYXRjaC4NCg0KQmVzdCBSZWdhcmRzDQpIYWlibyBDaGVuDQo+
IA0KPiA+DQo+ID4gIAkJZXJyID0gcG1fcnVudGltZV9mb3JjZV9zdXNwZW5kKGRldmljZSk7DQo+
ID4gIAkJaWYgKGVycikNCj4gDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4g
ICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRk
ZWQgTGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAg
fA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4
MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAg
ICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg==
