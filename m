Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203EE60E147
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiJZM4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiJZM4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:56:40 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2102.outbound.protection.outlook.com [40.107.113.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBCB36431;
        Wed, 26 Oct 2022 05:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ92zRzR9sIFiOZC5fYWS2/bFYRXNeGgjc+9My8JQs80mbVxLs4k2feT6kSiRn7dfXN4yIEQ4sze/pL54Di5Smy2zcf9RRU2K4cW1Myilpa10E8SxR7+UQ5ZC32q9SLEj/07xFuyfMWsdQKDfvJ4LKTUGUEtjv6OZ/v2csjaLHLHOmoSYry48b60yknXmrNMCjpyDqzGAq5zoexQscKdg/XNvdILBoUZjq/8fWxrKHsTUSIVms+8CmOK+p5TacSEHIrlyavn7L3DFlIlgxZpSWDvM3xR/EYcwPPR5b/zzi3331sey0sAmpVVF9qa6FWNpgqgy+DFPLjBi99k/bAcPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SdoGDkxqKoy5MxaTGMuclJKOapqN7EjMJur1X7F0dM=;
 b=YxqKByIvv/1f3nHldxDZkrUdl/onvC6xF7oUX9D3GvHlLLsN/lcMaqb8AMgW9yBz6IAH0Hx0P7S6Pbx2NvwEYewFf7ycZeuFyt/kl0bpeX51M7ZOjLS0tep+ichfPP3XTSTNdEl6mVsnIFuUnI7AJmDhMmzhicKbRk3Gc5RKqN2nTM5vOoMXT5CAHA8FgKPJzmX3QKKxv4bNrJueoYJ5UjInYJhTMTn4lTvj7GH/YJQL4/oBEAVsaHLHcV81dIH7UX76H0x6rKVkMQzF0bQtYgMKEDmThAZEnJ72WvfjMoPuZCUKAQXHwZy3M8BGiHMdzhUlRFRSVB48+RIGA8tD6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+SdoGDkxqKoy5MxaTGMuclJKOapqN7EjMJur1X7F0dM=;
 b=DDo8u2wdMA29z/GoZsq/fbtiEj/Iaeomw3AFw7sPsh0ljwH4HU7QDUdeRJSduI2go+FzjaG5Jehe5eF/J+QhRjXQWsj6pagfKEhSEKySKyFYafPtdIt949S9gKChGyjElWtG6jsjuvVn7Yb1Bw5681ll8a08f/aut/p2JldM5Gg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB9646.jpnprd01.prod.outlook.com (2603:1096:400:1a3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 12:56:35 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 12:56:35 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] can: rcar_canfd: Fix channel specific IRQ handling
 for RZ/G2L
Thread-Topic: [PATCH v2 2/3] can: rcar_canfd: Fix channel specific IRQ
 handling for RZ/G2L
Thread-Index: AQHY6Ip2RBA8f39PzUqILbm0/1Sk/64gSiQAgAAUPdCAAD8zAIAABM6Q
Date:   Wed, 26 Oct 2022 12:56:35 +0000
Message-ID: <OS0PR01MB5922B83EE681BFAE56B420D386309@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
 <20221025155657.1426948-3-biju.das.jz@bp.renesas.com>
 <20221026073608.7h47b2axcayakfnn@pengutronix.de>
 <OS0PR01MB5922FCC50E590DFDD041F99386309@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20221026123446.c6ob45mbke5aj7f5@pengutronix.de>
In-Reply-To: <20221026123446.c6ob45mbke5aj7f5@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB9646:EE_
x-ms-office365-filtering-correlation-id: 81449d3d-9351-4f3d-0538-08dab75183af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QHth/u9K+q9InnyDcjBD/8ukdyMbAqGBPH0yWUe3uBWLemTcmCwVmmgYltXNf14KoVHCHIhjvFlwZoQNQO+9ZyQSlWTlEOZbCUrHHXxNSuFD7A/5NHRX4RHUZS87sWgiwVgViaV9T7Y1hxMoUp8ZdVSlZ5Jv0JBpIX9uTZO7eBcTDl0iVXIJ+AhEBEnEEvTXjqq7kRj3t2N3WX/+rcfN0LIUb/izX+iZhzTIJVvpdsXatpCCuDe+zgOIVGamiCRCREIU6xPJTQ2ywiWm5tN5J86I4kOuM4MOOm7vZPVUZse1+A2SwNfG6jSXKVxJUANCAfsvA7QOzHqeO+ZGQTgmZPQCbE4x+b/OZ7GKoYR703qifovIKQkOPyapeb61ji75L/+uLwTyTQHo+ZW+33Pj+YY1yPyGEaKlG0DmtC0sj2oqnsLaOuOUAlZ2+pmldh5QMPt1IeHLaCmautEhTIqdNIrnCg8XbJNNf3Ln+gViit71OchcJDDj9bXHi/4xUJrmWroaQSs6U2cvnSJPopcHtgxiQyORyJs4QQoq5EqHDJEIyuE0e/E1HFLtGykqPTdzWXXSTQRmewANgxgUkRpHo2SJHdOcVfNQcZ9Sn7njCBzGTCcfQPIcdo83Qz/VKgdjCfuVfBlg7BaoSrLvQnq21xVfCwZf8N4DNe/fbZwwrDSF2TEPb1hFhX/cGhTH/HG/19zWdKN8u6LK7kKnkfC/d6dW/cR716YyYbPoB/K9Nderu+E8CBNhNOtGQmkEMruNY0/GW1VKtOJ3xO5G6DE8AQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199015)(478600001)(86362001)(71200400001)(66446008)(66946007)(53546011)(66476007)(64756008)(7696005)(66556008)(8676002)(4326008)(41300700001)(5660300002)(9686003)(76116006)(7416002)(52536014)(8936002)(6916009)(33656002)(122000001)(54906003)(55016003)(6506007)(186003)(2906002)(38100700002)(316002)(26005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U01uY0tSSUxBOUViN21PQ2pocDBkLzdQYWI5dWJ3UlFIQmNneWsxbklwK2p1?=
 =?utf-8?B?Nno4T0orOHVvZnE4RDNoYWZiODBUWU5wZkYvbkQxMGdrbnVsazNpWE1BMGJN?=
 =?utf-8?B?ZURzcERKV3ZxV0pCYVJxUXVxR3o4NXZjOHJ3enQxTEdzOCsvWGQ4Y2Y3dlpC?=
 =?utf-8?B?aTI4b0VSUHhtN08rK1lJN3JyUjFnL1hFT1FrYXNtcDBVV0kvOXd5TnhSaDM1?=
 =?utf-8?B?Y2Jpdm91YzgwUFU3QUw4VzRrSFNOSzdDYlRxNU9VVytoYjF3a1FPbDZwdGhX?=
 =?utf-8?B?YWdYY1N0SU5wdFE1dEdNUXZ5VXpyb3VsN1FMQ3YzdjhZZWZHT3FKUysxSG1D?=
 =?utf-8?B?T2dJTVV2TWV3VEZMUkprUGlhdlBPVmNNQXkrRHZScWhlYnNMdG0wRjh6ZERH?=
 =?utf-8?B?Rm5ZRFhNQll1L0V0akU2d3hDSXZxZXQ4L3ZNSEVERkR5L2l5bUhVZWRsN2dV?=
 =?utf-8?B?ZVFia2hSL2c4ZHdNcExDUGhidmZLV1dQY3ZTQlZRcUQzNEF3Uytjd1FUNVdY?=
 =?utf-8?B?NWRXeFNCOXNTUTFtZHN5S2U5WDlZRkFOdmZrd25WTEpHRXRwd2YxT1BwV1NU?=
 =?utf-8?B?amVUdnBPcmhhdGNlbjduQUlMUlBjTVZFbmVGeUp0dFNoOEo0S2pzWjVtdWxZ?=
 =?utf-8?B?b3RaRzQxUXZzaHA3dVhNdWQzcTJQWjJNd2h1ZTRjcFZFLzVNOUNGR2poUTZq?=
 =?utf-8?B?TFVmZ20yOGVnSmEvOEs4VDBoUFlQUFA5cDJNY1d1KzZ4VEdtR2tsekRaR0xv?=
 =?utf-8?B?dml3VWlFWUVsS3QzdWd0a05HT1hhcXZjUTR4L0cvdHdhNStka0FJTmhPb3Ra?=
 =?utf-8?B?MnZWbWE0dzlFMjVjY3RmMkQzMnRpMFpzaGNPMEIyQkpSOFZBU3Zwam4xY01H?=
 =?utf-8?B?Y3hwWm1JWWgzbzJqem5BMjBwQmFhb1hIejIwV0s4My9zVjl5bWxGcTZJbjkz?=
 =?utf-8?B?cUkvUHlKZ1pobExBbHVKdGRlR29tV2ZwYkdsTmwxY0ttaWpzWTdPU25ZUFk0?=
 =?utf-8?B?Y0pGY002OVY2OUw4MUt2VUpXNlVORThpNzhVOHRDTUZsSVJQSGxJSzJFeU1j?=
 =?utf-8?B?M0d0Q2dEYnRsRllVRkdYV0pjZVhJVUFEZGpVZm9qcGttMmRkVlpGZjRFQkk1?=
 =?utf-8?B?Z2pleDJTeHdwRnJOczM2bW93cSs0Q2lsM29oZlFLUmdwUmEwaGMvdTZnQ3N0?=
 =?utf-8?B?UWNVTEFyakUxazdNYWgwSm5UYXBwVlliUUJwcXhOTnlVQlp1c3JkMkQxVkVY?=
 =?utf-8?B?ZktqazFQZEtmcUcxS2ZEdWJRVmhVaTRDSnhsZm1rTjJzYWxDTzhaZ2JsTm1u?=
 =?utf-8?B?MWhmVkg5OWwyMjRmWnFnZWVHRFV1M1BXdEtMeW9MKzJST3JsbnU0QXFKQWhP?=
 =?utf-8?B?b0xLTGs0Q1JzK1AwTG5DNjhIa29QMXkreW1KdlBMSEt6MFNQR1c5YS9TWVlu?=
 =?utf-8?B?c29VUUtyL3RQa2ZHVm9Ua2NJM0FHNjhUK1N1bFEzVy9JdGl2dE9wWUIzdmVQ?=
 =?utf-8?B?NzhOdjMzaVVxU1ZNK0U3Z0ozcEY5UlFoYlJscDhJbnBqcE9jUDd1YkdTWDdI?=
 =?utf-8?B?TlFIdHNsQkxOVFcvdFRRbDVOckZDSU9aZjVwS2dMVHNFb3RjenpUU3lScmRN?=
 =?utf-8?B?ZHRYUUdyd29NYnNZTmFIcVgzdGRmRnZNdHY5b09CODhkbjl0R1JZYTJEeW16?=
 =?utf-8?B?dWY0MEptdlI0blg5MTFnOWpmWUp4SHVYbmV0ejVuY29najAyTThGTWw2ZTFv?=
 =?utf-8?B?dXRKTGU4K2ZrM0F2UTlvalJqcEdIbC9hQjQrSWJMUzRUSWtUQVpKWEE0N2R3?=
 =?utf-8?B?aE5BZ2VySFJqRE0rNUlpRkZreHZXMC9qV0FRVHBaaFlhdy9TRDYvY01wWGN4?=
 =?utf-8?B?aGhDSTQ5dmdmQ3ZkeGhVenI1eTNjVzVGY3psOUYzKyt2K0QxdEVWeEtPdThG?=
 =?utf-8?B?emNmT1M3SURxdDc0Q1ZQMFgwQjJ3U1BacDVTNEExQ3V0SjhPZDBhTUpWWFh5?=
 =?utf-8?B?dCsyVVcyYVE5aFo3NlV4WVBOc2VNQ2JkNmpxUlBOOWpGZDNQNTBYZndsMnkv?=
 =?utf-8?B?OXBFZmJ6TlZweWR5L21EcDN2SHgvSHcrNkV6OFk1K1NCT0FiSG1MWTRhYktE?=
 =?utf-8?B?M01od0x5Znp5VklCdnA1VFZJbVZpclUwK2dDak5uYXU2Qkppc1pVWHRUNnha?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81449d3d-9351-4f3d-0538-08dab75183af
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 12:56:35.5241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K+rjIN4eaJ4SfCWEOY3mCwkvnZNvifmn26OXXq1AobBUn2R+8NLCbZQ4JRxIuc46kymtTRb4DzdgAhyb4j+3UkAf5y0KK3AqnNKVgpm8rRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9646
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MiAyLzNdIGNhbjogcmNhcl9jYW5mZDogRml4IGNoYW5uZWwgc3BlY2lmaWMgSVJRDQo+
IGhhbmRsaW5nIGZvciBSWi9HMkwNCj4gDQo+IE9uIDI2LjEwLjIwMjIgMDk6MzQ6NDEsIEJpanUg
RGFzIHdyb3RlOg0KPiA+ID4gSW4gYSBzZXBhcmF0ZSBwYXRjaCwgcGxlYXNlIGNsZWFuIHVwIHRo
ZXNlLCB0b286DQo+ID4gPg0KPiA+ID4gfCBzdGF0aWMgdm9pZCByY2FyX2NhbmZkX2hhbmRsZV9n
bG9iYWxfZXJyKHN0cnVjdA0KPiByY2FyX2NhbmZkX2dsb2JhbA0KPiA+ID4gfCAqZ3ByaXYsIHUz
MiBjaCkgc3RhdGljIHZvaWQNCj4gPiA+IHwgcmNhcl9jYW5mZF9oYW5kbGVfZ2xvYmFsX3JlY2Vp
dmUoc3RydWN0DQo+ID4gPiB8IHJjYXJfY2FuZmRfZ2xvYmFsICpncHJpdiwgdTMyIGNoKSBzdGF0
aWMgdm9pZA0KPiA+ID4gfCByY2FyX2NhbmZkX2NoYW5uZWxfcmVtb3ZlKHN0cnVjdCByY2FyX2Nh
bmZkX2dsb2JhbCAqZ3ByaXYsIHUzMg0KPiBjaCkNCj4gPiA+DQo+ID4gPiBXaHkgYXJlIDIgb2Yg
dGhlIGFib3ZlIGZ1bmN0aW9ucyBjYWxsZWQgImdsb2JhbCIgYXMgdGhleSB3b3JrIG9uIGENCj4g
PiA+IHNwZWNpZmljIGNoYW5uZWw/IFRoYXQgY2FuIGJlIHN0cmVhbWxpbmVkLCB0b28uDQo+ID4g
Pg0KPiA+DQo+ID4gVGhlIGZ1bmN0aW9uIG5hbWUgaXMgYXMgcGVyIHRoZSBoYXJkd2FyZSBtYW51
YWwsIEludGVycnVwdCBzb3VyY2VzDQo+IGFyZQ0KPiA+IGNsYXNzaWZpZWQgaW50byBnbG9iYWwg
YW5kIGNoYW5uZWwgaW50ZXJydXB0cy4NCj4gPg0KPiA+IOKAoiBHbG9iYWwgaW50ZXJydXB0cyAo
MiBzb3VyY2VzKToNCj4gPiDigJQgUmVjZWl2ZSBGSUZPIGludGVycnVwdA0KPiA+IOKAlCBHbG9i
YWwgZXJyb3IgaW50ZXJydXB0DQo+ID4g4oCiIENoYW5uZWwgaW50ZXJydXB0cyAoMyBzb3VyY2Vz
L2NoYW5uZWwpOg0KPiANCj4gSSBzZWUuIEtlZXAgdGhlIGZ1bmN0aW9ucyBhcyBpcy4NCj4gDQo+
ID4gTWF5YmUgd2UgY291bGQgY2hhbmdlDQo+ID4gInJjYXJfY2FuZmRfaGFuZGxlX2dsb2JhbF9y
ZWNlaXZlIi0NCj4gPiJyY2FyX2NhbmZkX2hhbmRsZV9jaGFubmVsX3JlY2VpdmUNCj4gPiAiLCBh
cyBmcm9tIGRyaXZlciBwb2ludCBJdCBpcyBub3QgZ2xvYmFsIGFueW1vcmU/PyBQbGVhc2UgbGV0
IG1lDQo+IGtub3cuDQo+IA0KPiBOZXZlciBtaW5kIC0gdGhlIGdwcml2IGFuZCBjaGFubmVsIG51
bWJlcnMgYXJlIG5lZWRlZCBzb21ldGltZXMgZXZlbg0KPiBpbiB0aGUgZnVuY3Rpb25zIHdvcmtp
bmcgb24gYSBzaW5nbGUgY2hhbm5lbC4gTmV2ZXIgbWluZC4gSSdsbCB0YWtlDQo+IHBhdGNoZXMN
Cj4gMSBhbmQgMiBhcyB0aGV5IGFyZS4NCg0KT0ssIFRoYW5rcy4NCg0KQ2hlZXJzLA0KQmlqdQ0K
DQoNCg0KDQoNCg==
