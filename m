Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE5060D0FA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiJYPuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 11:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJYPuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 11:50:23 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2111.outbound.protection.outlook.com [40.107.114.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5A93E77A;
        Tue, 25 Oct 2022 08:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvZ2B7Zp6Yp6ZwnQMZ8mYJcSsU7v9KWnlgxJe7BQN2OS33IOyI6bm40wLUlTkFYpy0DAMJhwYHEYoH5OmUSe/+qo7GKntbYx4p9bdBoN3zbbvlSv+v2inwuW4P29il8G1kRRXpD01lRpIhfercGO0cQmLMENiYvBE6vxqqpItsiPEhDySm4mkCa9R89Z9o11+fXXSSISQ61Mrftsnwos5A9UKCpolr0f2AaJ+9eiQa0M5/zs0NXZ6vQpeMUWbjp7SWx8DzCYlM2LSWc6Y5lEcrGdOMEZPPWA9LTFyVOnsNdQlu4tSZJAkId/olHtuF9lQmJUWIzXoWLz2kQSggfXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dURGCa3bFl39SGeUtbPzYbD4B9lTiOc+dFKjS6XZaRA=;
 b=P1WhszVMyx/2zIK1lPTxeJl0daHe8lxPSZOIuOUnuTR9z6iBeg9wyqEB0U7VFvcrm6LIyJU0mciGeClOOOp8K/yVYjkI/7K42vMpM5xwrHfGAGhq/tT3GBAeRYFDINRRwUATi2jOj5N4a++mxaGI8EBJO4tsuKqwFo0pfFyhXCunsr0uqWaDtThOHwcUdzvRdv7MaCbIoprviRUE0KZDDtlYvKZnmG9YL8szJtyRsJHYezTcoBNQY7KkmCdSIhn4pZxsUQxdFuqOieDWv4rfVPAqYXFVnaVEv8kZvkkcUuD/Z6/P2zTu+T1ckM9AvqxbHAIIHYbhoafOcAmpq+nkNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dURGCa3bFl39SGeUtbPzYbD4B9lTiOc+dFKjS6XZaRA=;
 b=wzcmR8GeQzkiNaaAREsEp+uuoHfZ6EqwlKJd97q1buLs6KFmef0NZg+Xearp1vxkTV5Lwt6YBxsorKIy2ZnTeclwuFuGlqULAFlV8PjIzENprRWHxxUeVS7gx41dk8KPBzoRj/fA2MvUdd44WqZd1I+ECxSRRFb6qaqpPmoJNr8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB9671.jpnprd01.prod.outlook.com (2603:1096:400:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 15:50:19 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 15:50:18 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Thread-Topic: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo
 receive
Thread-Index: AQHY5fEK6d4STYQGnkuaJSprEex4Pq4dsSYAgAAEjACAAA32EIAAF1IAgAAF9rCAAWWCEA==
Date:   Tue, 25 Oct 2022 15:50:18 +0000
Message-ID: <OS0PR01MB59221FB0C29220B7D4794CEE86319@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
 <20221024155342.bz2opygr62253646@pengutronix.de>
 <OS0PR01MB5922B66F44AEF91CDCED8374862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20221024180708.5zfti5whtpfowk5c@pengutronix.de>
 <OS0PR01MB59224B2AE8F84B961D2A061C862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59224B2AE8F84B961D2A061C862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB9671:EE_
x-ms-office365-filtering-correlation-id: f79b9a26-ca40-4a4e-bb87-08dab6a09e16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bvnu4BXSECiB+rC+WUkExqPC4oxg6KUCPyL3hSyPPgcIzX+/TjcNOw8dqmrAETHwpogYexM63i+Hc3IUTVedN374V4IMcR28t5t1rNeNky/0SipX5K6FmkgtgldWcl4MTXHdydSzyZDmJkzYOr3rKS9hBkrQbWPfdprzufZ9ebjsXR3dCqYA/SXo9Z4W4Q3GD1vdOu/DfsVz4dbOTCGTxVFpOVpLD/dtipM7iNpKL9jb+Xekx3IDAJDz6zV/QiUrY6QH2Nd0Vavkk3EdVz8aQ7gc7AyVP9NpQJejhkm4z4B07thUdWA9Ildl6b+kkNbQvfq0l6EhxSEUp48PrKPDShwqSLd4Ax8TL2i5LeJNKQgDEyQZqspr6BJik+OAK4K+2akhyY2jZqpRTxz1HPadGABJY9WEUCyNapmc+Rqsa2DCUaqM09tPUA4VK8s5ng7KPRTH+cYdIG2UT6UJpwOEcVPnicGR/vu1tTZ22zv3IxO/lknHzWjbzx8BGjonfuf1Q3zcNOj8E+J/XYm0lAbUx08dHEi7DujMiBxPbpmW+w7oUMtO7PbT+IAnCBkStOT6GiqMq9IcH9dKNuvcCGUsNl3HqIsm4XjtEaczcap72e2akOscY8GIM4Oc9gIxfEGqNbBL00rRQlWOVJ7ecNqQerUNksmk7DyacKqSK3yWTo33NsQSN+gZEqAuDXbhAAAYFnPJynmySpTxQrdtZtqhZwpXbn5ZejR0kkuFbX77CKSi90vOWVRh8bV3RS9nDDEMy7MFFP6yPQI/qiOItunxJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199015)(2906002)(54906003)(66476007)(76116006)(41300700001)(7416002)(316002)(52536014)(8676002)(4326008)(66446008)(66556008)(66946007)(71200400001)(64756008)(5660300002)(33656002)(55016003)(478600001)(83380400001)(38070700005)(38100700002)(122000001)(6916009)(86362001)(26005)(7696005)(53546011)(6506007)(186003)(9686003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZitPbXFXc0pHb1FBaTVMS1ZIcTRLeUxVbHhjYmMrd3F1QVdKVVVVb3g3S2pJ?=
 =?utf-8?B?SktIY2sveVJiRjhQa0dLQWxRTGJGV3VDVjV4aGpWTXcyekEyWVdHREFvTEJX?=
 =?utf-8?B?NVNkUTA3MW1WUGlEd3NLMzZwbUVpakljUURBNC9OWnBKRTRJaTVUWnQxRzJl?=
 =?utf-8?B?MXFjZmxDQTQvRVhFS1hqeDBHVlZtUHZtejRqZzFmZjhROGx3R05MNjBHaGdk?=
 =?utf-8?B?Ukh3S0g1RnZZeDJrZDE1RzcxZlNzTzlkYWE1NVUwOWU3am5SVHd1LzY0Zjh2?=
 =?utf-8?B?cFdKVlprWlpLbk9IV0pMV3lhaXcxMkFUREJPQTd2SWRJQnl1b1k4cG5aanNt?=
 =?utf-8?B?ak1XT1hweGY1RXNOZ3FsZ2JRdnZsU3duc2t4NVJjbXVMN0dXNWhUVlRwb1Vk?=
 =?utf-8?B?TnlVdlhZL2FGUWdwc2s5cWNsZm81VHR0ZWY5Tnk0amRxbzY4WlZDUjExWS9F?=
 =?utf-8?B?ZGhUL3Fwd24xTmlKYk1JdlhHTDVFTnRnbnpVSElHODltWHYyTmFCVnZjbVFJ?=
 =?utf-8?B?UFBGTmMwMy80em5ldE5YWHE1QjZkRGx2Q3lzUTFpSVNWbVZ3K1ZidEVka21N?=
 =?utf-8?B?azR2TWROcWZnR0hvUWZtWUxaZlJQL3Z6UlhKSkliUzE1MnBodjRRdyszZDhr?=
 =?utf-8?B?eW5mbXh1cGFhbGZmc2ViOHdsZ3kwekZsNXRlRnE2ajc3eUYrVk1Jc3ptR2N6?=
 =?utf-8?B?TzF4aDVxQUQ5SDBDempITWVYdWw5Ny8wWE94VUZUNzdTRjVNUkxHMllrOFBZ?=
 =?utf-8?B?eGVnL3p4N294OVVRS0JqRzJWNzNLTE1DdFMxb29uOXhmRFVtakUyUkNWQlVL?=
 =?utf-8?B?L21nM2I0SC8yeGkzanN3NlVZNkVSS09NRmpuemlaZGdHMGhBc2hkcUo3OFFG?=
 =?utf-8?B?MlJkOUg3OUprR2x1Z0hLY0hLdmJIdGU5aEJmaHNxLzlVS1FRcER2Z3ZQdVEw?=
 =?utf-8?B?TkVJV0tpNmIvcmZRSnJaeWVJempYdVFmODd2QTB3dHlFOUdMUjNqSmVGWWdL?=
 =?utf-8?B?b3pwaHRscHJPNTRwRTVLWXorbjZxNVlGNE9lTHkvcXFRcUtoNkhhd3JnKzdL?=
 =?utf-8?B?OVRTV0k4TGVIYkg1MFhidG1qQzI0QkVEOC9FMTJNTHFPcHVWbUxzeE1tTXBC?=
 =?utf-8?B?V0Y1c1lycEhuU1NnamkzNXB4Rnk5RnMrNUpURHd1cFgvY29aOFpNd0hSWUt5?=
 =?utf-8?B?S1VMK3RkK3FwYUhhNU5waXB0UmdKTTYvOWlGWW1VdDcwdG5TeFVTaWNkalhq?=
 =?utf-8?B?WnlBS3dpSkdlaDBoaUxjQkRCSUxtRUZKSys1Mk1MWDVSektUR0ZVOUVkelFT?=
 =?utf-8?B?NTNXZEx5RzFPQXliNXRLNDNLd0d6bktSYm9QUVpVSDc4cmpzNHNqOERZZita?=
 =?utf-8?B?SG9FcWZ1TEdXeEF4cy9DbnhDSjA2MXpONFcvQXhLUmgyVCtlMTJFUDZRcU14?=
 =?utf-8?B?TklYK1BKYnowd0xqQUZoMGRCdm1UZzNRZ29vVjNtbzNSQ0F4Uzdzby9CM3NY?=
 =?utf-8?B?N3FTN0dMdVlCYXlUNWs4MUlWTDl3RXQ1N0tHTmFHUlRzTHJ1WmxsMWFyUXpG?=
 =?utf-8?B?bjA2QWQ4NzhmaUEyeE5QNFNwQTFJb2FlOUR6RXI3L3d3ZVVDNkVQbERyYVdU?=
 =?utf-8?B?VUsxY012elN0dE1veGZBTGY4VGZsWGxFamw4aFd1TnVlM3hoWWpLeTI0OGZP?=
 =?utf-8?B?a2UxQm5IdGpvY1B3dm9hdWhhN0tFcDZ1YW1DblU4Sm9FWDROSy96blVzZEdr?=
 =?utf-8?B?WGdQTWFRdE10RlRjVkdSM3RZT205TXNKYnU2eFFDV1E1TzNla1BxUlZ6dnl6?=
 =?utf-8?B?emNFdktpOHhMazc3VnpocEFtYUo1TjF6UHJ0b2hheHAyemI5cHZKK3lPOUto?=
 =?utf-8?B?R0lPVldGN05qbVlOU2luMUZSbWM2NThNbU1kWGxPTm9YOHVMakd1L3plc05z?=
 =?utf-8?B?QzNBQUJDcGxRYkk2dGJtQ0M1b2xKcU5VWFZETEh5VUV0VUdnSzg1SWxDMDNP?=
 =?utf-8?B?R0Z4TEhqUW1jR3VCdmRwWTA2M2tvQklVRkZvUys3V3JGdWJZazI4Z0VxSkpq?=
 =?utf-8?B?Q2x6WExnNnpuaXV2RXNKQWd5b1M4WDhFV2MxTm9pMUlRQ1JaOWI2OTlDQzEw?=
 =?utf-8?B?c1Q4dEpEaHdybFhzeDExM1VSSFRZenZyUzIxYmRCWUQ1SWpZbmY0bE4zWkR3?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79b9a26-ca40-4a4e-bb87-08dab6a09e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 15:50:18.9346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5hOmOeGSQs7T/6CHyC9CJl8iDVuU16vqNQsnmInpHBVvRr4wKm7/I7EwnGJ+M6PCR3uxfksuxgcourmuHymFX3sEh03yF/IHWUha8wz5KQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9671
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDEvM10gY2FuOiByY2FyX2NhbmZkOiBG
aXggSVJRIHN0b3JtIG9uIGdsb2JhbCBmaWZvDQo+IHJlY2VpdmUNCj4gDQo+IEhpIE1hcmMsDQo+
IA0KPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBjYW46IHJjYXJfY2FuZmQ6IEZpeCBJUlEg
c3Rvcm0gb24gZ2xvYmFsDQo+IGZpZm8NCj4gPiByZWNlaXZlDQo+ID4NCj4gPiBPbiAyNC4xMC4y
MDIyIDE2OjU1OjU2LCBCaWp1IERhcyB3cm90ZToNCj4gPiA+IEhpIE1hcmMsDQo+ID4gPiA+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBjYW46IHJjYXJfY2FuZmQ6IEZpeCBJUlEgc3Rvcm0gb24N
Cj4gZ2xvYmFsDQo+ID4gPiA+IGZpZm8gcmVjZWl2ZQ0KPiA+ID4gPg0KPiA+ID4gPiBPbiAyNC4x
MC4yMDIyIDE3OjM3OjM1LCBNYXJjIEtsZWluZS1CdWRkZSB3cm90ZToNCj4gPiA+ID4gPiBPbiAy
Mi4xMC4yMDIyIDA5OjE1OjAxLCBCaWp1IERhcyB3cm90ZToNCj4gPiA+ID4gPiA+IFdlIGFyZSBz
ZWVpbmcgSVJRIHN0b3JtIG9uIGdsb2JhbCByZWNlaXZlIElSUSBsaW5lIHVuZGVyDQo+IGhlYXZ5
DQo+ID4gPiA+ID4gPiBDQU4gYnVzIGxvYWQgY29uZGl0aW9ucyB3aXRoIGJvdGggQ0FOIGNoYW5u
ZWxzIGFyZSBlbmFibGVkLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IENvbmRpdGlvbnM6DQo+
ID4gPiA+ID4gPiAgIFRoZSBnbG9iYWwgcmVjZWl2ZSBJUlEgbGluZSBpcyBzaGFyZWQgYmV0d2Vl
biBjYW4wIGFuZA0KPiBjYW4xLA0KPiA+ID4gPiBlaXRoZXINCj4gPiA+ID4gPiA+ICAgb2YgdGhl
IGNoYW5uZWxzIGNhbiB0cmlnZ2VyIGludGVycnVwdCB3aGlsZSB0aGUgb3RoZXINCj4gPiBjaGFu
bmVsDQo+ID4gPiA+IGlycQ0KPiA+ID4gPiA+ID4gICBsaW5lIGlzIGRpc2FibGVkKHJmaWUpLg0K
PiA+ID4gPiA+ID4gICBXaGVuIGdsb2JhbCByZWNlaXZlIElSUSBpbnRlcnJ1cHQgb2NjdXJzLCB3
ZSBtYXNrIHRoZQ0KPiA+ID4gPiA+ID4gaW50ZXJydXB0DQo+ID4gPiA+IGluDQo+ID4gPiA+ID4g
PiAgIGlycWhhbmRsZXIuIENsZWFyaW5nIGFuZCB1bm1hc2tpbmcgb2YgdGhlIGludGVycnVwdCBp
cw0KPiA+ID4gPiA+ID4gaGFwcGVuaW5nDQo+ID4gPiA+IGluDQo+ID4gPiA+ID4gPiAgIHJ4X3Bv
bGwoKS4gVGhlcmUgaXMgYSByYWNlIGNvbmRpdGlvbiB3aGVyZSByeF9wb2xsIHVubWFzaw0KPiA+
IHRoZQ0KPiA+ID4gPiA+ID4gICBpbnRlcnJ1cHQsIGJ1dCB0aGUgbmV4dCBpcnEgaGFuZGxlciBk
b2VzIG5vdCBtYXNrIHRoZSBpcnENCj4gPiBkdWUgdG8NCj4gPiA+ID4gPiA+ICAgTkFQSUZfU1RB
VEVfTUlTU0VEIGZsYWcuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBXaHkgZG9lcyB0aGlzIGhhcHBl
bj8gSXMgaXQgYSBwcm9ibGVtIHRoYXQgeW91IGNhbGwNCj4gPiA+ID4gPiByY2FyX2NhbmZkX2hh
bmRsZV9nbG9iYWxfcmVjZWl2ZSgpIGZvciBhIGNoYW5uZWwgdGhhdCBoYXMgdGhlDQo+ID4gSVJR
cw0KPiA+ID4gPiA+IGFjdHVhbGx5IGRpc2FibGVkIGluIGhhcmR3YXJlPw0KPiA+ID4gPg0KPiA+
ID4gPiBDYW4geW91IGNoZWNrIGlmIHRoZSBJUlEgaXMgYWN0aXZlIF9hbmRfIGVuYWJsZWQgYmVm
b3JlIGhhbmRsaW5nDQo+ID4gdGhlDQo+ID4gPiA+IElSUSBvbiBhIHBhcnRpY3VsYXIgY2hhbm5l
bD8NCj4gPiA+DQo+ID4gPiBZb3UgbWVhbiBJUlEgaGFuZGxlciBvciByeF9wb2xsKCk/Pw0KPiA+
DQo+ID4gSSBtZWFuIHRoZSBJUlEgaGFuZGxlci4NCj4gPg0KPiA+IENvbnNpZGVyIHRoZSBJUlEg
Zm9yIGNoYW5uZWwwIGlzIGRpc2FibGVkIGJ1dCBhY3RpdmUgYW5kIHRoZSBJUlEgZm9yDQo+ID4g
Y2hhbm5lbDEgaXMgZW5hYmxlZCBhbmQgYWN0aXZlLiBUaGUNCj4gPiByY2FyX2NhbmZkX2dsb2Jh
bF9yZWNlaXZlX2ZpZm9faW50ZXJydXB0KCkgd2lsbCBpdGVyYXRlIG92ZXIgYm90aA0KPiA+IGNo
YW5uZWxzLCBhbmQgcmNhcl9jYW5mZF9oYW5kbGVfZ2xvYmFsX3JlY2VpdmUoKSB3aWxsIHNlcnZl
IHRoZQ0KPiA+IGNoYW5uZWwwIElSUSwgZXZlbiBpZiB0aGUgSVJRIGlzIF9ub3RfIGVuYWJsZWQu
IFNvIEkgc3VnZ2VzdGVkIHRvDQo+IG9ubHkNCj4gPiBoYW5kbGUgYSBjaGFubmVsJ3MgUlggSVJR
IGlmIHRoYXQgSVJRIGlzIGFjdHVhbGx5IGVuYWJsZWQuDQo+ID4NCj4gPiBBc3N1bWluZyAiY2Mg
JiBSQ0FORkRfUkZDQ19SRkkiIGNoZWNrcyBpZiBJUlEgaXMgZW5hYmxlZDoNCj4gDQo+IA0KPiA+
DQo+ID4gaW5kZXggNTY3NjIwZDIxNWY4Li5lYTgyOGMxYmQzYTEgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvY2FuL3JjYXIvcmNhcl9jYW5mZC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQv
Y2FuL3JjYXIvcmNhcl9jYW5mZC5jDQo+ID4gQEAgLTExNTcsMTEgKzExNTcsMTMgQEAgc3RhdGlj
IHZvaWQNCj4gPiByY2FyX2NhbmZkX2hhbmRsZV9nbG9iYWxfcmVjZWl2ZShzdHJ1Y3QgcmNhcl9j
YW5mZF9nbG9iYWwgKmdwcml2LCB1Mw0KPiB7DQo+ID4gICAgICAgICBzdHJ1Y3QgcmNhcl9jYW5m
ZF9jaGFubmVsICpwcml2ID0gZ3ByaXYtPmNoW2NoXTsNCj4gPiAgICAgICAgIHUzMiByaWR4ID0g
Y2ggKyBSQ0FORkRfUkZGSUZPX0lEWDsNCj4gPiAtICAgICAgIHUzMiBzdHM7DQo+ID4gKyAgICAg
ICB1MzIgc3RzLCBjYzsNCj4gPg0KPiA+ICAgICAgICAgLyogSGFuZGxlIFJ4IGludGVycnVwdHMg
Ki8NCj4gPiAgICAgICAgIHN0cyA9IHJjYXJfY2FuZmRfcmVhZChwcml2LT5iYXNlLCBSQ0FORkRf
UkZTVFMoZ3ByaXYsDQo+IHJpZHgpKTsNCj4gPiAtICAgICAgIGlmIChsaWtlbHkoc3RzICYgUkNB
TkZEX1JGU1RTX1JGSUYpKSB7DQo+ID4gKyAgICAgICBjYyA9IHJjYXJfY2FuZmRfcmVhZChwcml2
LT5iYXNlLCBSQ0FORkRfUkZDQyhncHJpdiwgcmlkeCkpOw0KPiA+ICsgICAgICAgaWYgKGxpa2Vs
eShzdHMgJiBSQ0FORkRfUkZTVFNfUkZJRiAmJg0KPiA+ICsgICAgICAgICAgICAgICAgICBjYyAm
IFJDQU5GRF9SRkNDX1JGSUUpKSB7DQo+ID4gICAgICAgICAgICAgICAgIGlmIChuYXBpX3NjaGVk
dWxlX3ByZXAoJnByaXYtPm5hcGkpKSB7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgLyog
RGlzYWJsZSBSeCBGSUZPIGludGVycnVwdHMgKi8NCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICByY2FyX2NhbmZkX2NsZWFyX2JpdChwcml2LT5iYXNlLA0KPiA+DQo+ID4gUGxlYXNlIGNoZWNr
IGlmIHRoYXQgZml4ZXMgeW91ciBpc3N1ZS4NCg0KWWVzLCBpdCBmaXhlcyB0aGUgaXNzdWUuDQoN
Cj4gDQo+ID4NCj4gPiA+IElSUSBoYW5kbGVyIGNoZWNrIHRoZSBzdGF0dXMgYW5kIGRpc2FibGUo
bWFzaykgdGhlIElSUSBsaW5lLg0KPiA+ID4gcnhfcG9sbCgpIGNsZWFycyB0aGUgc3RhdHVzIGFu
ZCBlbmFibGUodW5tYXNrKSB0aGUgSVJRIGxpbmUuDQo+ID4gPg0KPiA+ID4gU3RhdHVzIGZsYWcg
aXMgc2V0IGJ5IEhXIHdoaWxlIGxpbmUgaXMgaW4gZGlzYWJsZWQvZW5hYmxlZCBzdGF0ZS4NCj4g
PiA+DQo+ID4gPiBDaGFubmVsMCBhbmQgY2hhbm5lbDEgaGFzIDIgSVJRIGxpbmVzIHdpdGhpbiB0
aGUgSVAgd2hpY2ggaXMgb3JlZA0KPiA+ID4gdG9nZXRoZXIgdG8gcHJvdmlkZSBnbG9iYWwgcmVj
ZWl2ZSBpbnRlcnJ1cHQoc2hhcmVkIGxpbmUpLg0KPiA+DQo+ID4gPiA+IEEgbW9yZSBjbGVhcmVy
IGFwcHJvYWNoIHdvdWxkIGJlIHRvIGdldCByaWQgb2YgdGhlIGdsb2JhbA0KPiA+IGludGVycnVw
dA0KPiA+ID4gPiBoYW5kbGVycyBhdCBhbGwuIElmIHRoZSBoYXJkd2FyZSBvbmx5IGdpdmVuIDEg
SVJRIGxpbmUgZm9yIG1vcmUNCj4gPiB0aGFuDQo+ID4gPiA+IDEgY2hhbm5lbCwgdGhlIGRyaXZl
ciB3b3VsZCByZWdpc3RlciBhbiBJUlEgaGFuZGxlciBmb3IgZWFjaA0KPiA+IGNoYW5uZWwNCj4g
PiA+ID4gKHdpdGggdGhlIHNoYXJlZCBhdHRyaWJ1dGUpLiBUaGUgSVJRIGhhbmRsZXIgbXVzdCBj
aGVjaywgaWYgdGhlDQo+ID4gSVJRDQo+ID4gPiA+IGlzDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgXl5eXl5eXl5eDQo+ID4gVGhhdCBzaG91bGQgYmUgImZsYWciLg0KPiBPSy4NCj4gDQo+ID4N
Cj4gPiA+ID4gcGVuZGluZyBhbmQgZW5hYmxlZC4gSWYgbm90IHJldHVybiBJUlFfTk9ORSwgb3Ro
ZXJ3aXNlIGhhbmRsZQ0KPiBhbmQNCj4gPiA+ID4gcmV0dXJuIElSUV9IQU5ETEVELg0KPiA+ID4N
Cj4gPiA+IFRoYXQgaW52b2x2ZXMgcmVzdHJ1Y3R1cmluZyB0aGUgSVJRIGhhbmRsZXIgYWx0b2dl
dGhlci4NCj4gPg0KPiA+IEFDSw0KPiA+DQo+ID4gPiBSWi9HMkwgaGFzIHNoYXJlZCBsaW5lIGZv
ciByeCBmaWZvcyB7Y2gwIGFuZCBjaDF9IC0+IDIgSVJRIHJvdXRpbmUNCj4gPiA+IHdpdGggc2hh
cmVkIGF0dHJpYnV0ZXMuDQo+ID4NCj4gPiBJdCdzIHRoZSBzYW1lIElSUSBoYW5kbGVyIChvciBJ
UlEgcm91dGluZSksIGJ1dCBjYWxsZWQgMXggZm9yIGVhY2gNCj4gPiBjaGFubmVsLCBzbyAyeCBp
biB0b3RhbC4gVGhlIFNIQVJFRCBpcyBhY3R1YWxseSBhIElSUSBmbGFnIGluIHRoZQ0KPiA0dGgN
Cj4gPiBhcmd1bWVudCBpbiB0aGUgZGV2bV9yZXF1ZXN0X2lycSgpIGZ1bmN0aW9uLg0KPiA+DQo+
ID4gfCBkZXZtX3JlcXVlc3RfaXJxKC4uLiwgLi4uLCAuLi4sIElSUUZfU0hBUkVELCAuLi4sIC4u
Lik7DQo+ID4NCj4gPiA+IFItQ2FyIFNvQ3MgaGFzIHNoYXJlZCBsaW5lIGZvciByeCBmaWZvcyB7
Y2gwIGFuZCBjaDF9IGFuZCBlcnJvcg0KPiA+ID4gaW50ZXJydXB0cy0+MyBJUlEgcm91dGluZXMg
d2l0aCBzaGFyZWQgYXR0cmlidXRlcy4NCj4gPg0KPiA+ID4gUi1DYXJWM1UgU29DcyBoYXMgc2hh
cmVkIGxpbmUgZm9yIHJ4IGZpZm9zIHtjaDAgdG8gY2g4fSBhbmQgZXJyb3INCj4gPiA+IGludGVy
cnVwdHMtPjkgSVJRIHJvdXRpbmVzIHdpdGggc2hhcmVkIGF0dHJpYnV0ZXMuDQo+ID4NCj4gPiBJ
IHRoaW5rIHlvdSBnb3QgdGhlIHBvaW50LCBJIGp1c3Qgd2FudGVkIHRvIHBvaW50IG91dCB0aGUg
dXN1YWwgd2F5DQo+ID4gdGhleSBhcmUgY2FsbGVkLg0KPiA+DQo+ID4gPiBZZXMsIEkgY2FuIHNl
bmQgZm9sbG93IHVwIHBhdGNoZXMgZm9yIG1pZ3JhdGluZyB0byBzaGFyZWQNCj4gaW50ZXJydXB0
DQo+ID4gPiBoYW5kbGVycyBhcyBlbmhhbmNlbWVudC4gUGxlYXNlIGxldCBtZSBrbm93Lg0KPiA+
DQo+ID4gUGxlYXNlIGNoZWNrIGlmIG15IHBhdGNoIHNuaXBwZXQgZnJvbSBhYm92ZSB3b3Jrcy4g
VG8gZml4IHRoZSBJUlENCj4gPiBzdG9ybSBwcm9ibGVtIEknZCBsaWtlIHRvIGhhdmUgYSBzaW1w
bGUgYW5kIHNob3J0IHNvbHV0aW9uIHRoYXQgY2FuDQo+IGdvDQo+ID4gaW50byBzdGFibGUgYmVm
b3JlIHJlc3RydWN0dXJpbmcgdGhlIElSUSBoYW5kbGVycy4NCj4gDQo+IE9LLCBUb21vcnJvdyB3
aWxsIHByb3ZpZGUgeW91IHRoZSBmZWVkYmFjay4NCg0KSSB3aWxsIHNlbmQgVjIgd2l0aCB0aGVz
ZSBjaGFuZ2VzLg0KDQpDaGVlcnMsDQpCaWp1DQo=
