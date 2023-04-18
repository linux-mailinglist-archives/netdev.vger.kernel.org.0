Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15B56E5C5A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjDRIn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDRInZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:43:25 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2128.outbound.protection.outlook.com [40.107.14.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC1D35B5;
        Tue, 18 Apr 2023 01:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUo8D/ijltfcK2FAL0J+7e3KoOwceE9r3RD4OVTg+NFhGNl+cojFfgCxpdNPWLbBLLXT8DqySQB/KcPkenF63BGL64eQMmTQCixy+yWIxw3ctGYLpZppkIbxXWxfZOOp0tLkUVXwLwTWfHguID+4HL/5RNH4RpTey5IIPAZ3QoGGNNRPrLH6fhpY03Y+JRuFOlK29MpVLlhXVQ3HRagS9S8H9MhjwNee5nZv/yBPfSqYTzGGoRph31E20bla2OyJFsueS9KaHXVeR36TxCCy5ebFpLSoi7BGox6YoiLsCRuzB92GyPCWZf4gqAyzueBtZWpFLtiHPviG7eSuy8sIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djcgL2e8dylBe5VxjW0FDLj88lXabu3vMona/ae6H40=;
 b=BruB4nQdhAIm056lUhHNQsclsZRlUsuwZHvm9sKQEiORRGvFNu75pbQkotZn/mNL/yyhKqszuzJIgqIChWCdB1W+QAHgleGlLqHIAZrOxbGE8nwwzXSZhw+kVw6Fb4bw19A5K8dpW7KCgEa0zR/LwfVVsn7v8zqUMJo8Xgy18Aa4BlpioyQLTdtErbAbjgdFNERF68ceFo0rXMY2r9QMoOaXpnsMRukKmscpqKBy4lfYatDv/EmhA/B6aJoDLY5+6Y8o5lxKeu5G1D/UNHn+bYtzSosXhCHAGuwwhDlcasAyGkeAsgDbstWYoK9iiY8SJHTK6rYFBlLXYVN3KNumuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siklu.com; dmarc=pass action=none header.from=siklu.com;
 dkim=pass header.d=siklu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siklu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djcgL2e8dylBe5VxjW0FDLj88lXabu3vMona/ae6H40=;
 b=JUd+gXri3BqDnUdFVBUxgU8fs20yHFkj36ZcRNalK4pJmmJBfhEv/PURFfg+ykcAUGLgftg6c+yKTKuCWBfAtT1p1LTroamtndf+S8vEL3ZnU9kQUXK+cWm+fdYT5HhLUx/CtH/8bdQ6Lap/52HeCzGQbnta38FTzadS+j7csjU=
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:26::11) by AS8PR01MB10342.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:5ed::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 08:43:20 +0000
Received: from AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e]) by
 AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
 ([fe80::8941:8fd5:b4b2:9a3e%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 08:43:20 +0000
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2 0/3] net: mvpp2: tai: add extts support
Thread-Topic: [PATCH v2 0/3] net: mvpp2: tai: add extts support
Thread-Index: AQHZcU8pePq4GQoDaUyDpS2t94etM68wOSSAgACH3IA=
Date:   Tue, 18 Apr 2023 08:43:20 +0000
Message-ID: <2c52800237ff1675523b76bcb1bc3039b6589957.camel@siklu.com>
References: <20230417170741.1714310-1-shmuel.h@siklu.com>
         <115a0204-1037-4615-a250-70db8d5ae300@lunn.ch>
In-Reply-To: <115a0204-1037-4615-a250-70db8d5ae300@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siklu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR0102MB3106:EE_|AS8PR01MB10342:EE_
x-ms-office365-filtering-correlation-id: dcffe9be-9fb5-4954-69bc-08db3fe8f666
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: myWOTXI+NTiU0e4MDtFdRk+BQ0AnyyKTm80ntvrWeairKXRp5DQ8maJ3N7CpPWGo7rdjFvRisJIWkXTzMU2E7+bSPA5myF9KdyN6ECWgwjCapW85/2LmeVDEwZd9VEKpDZBJh9p8jhOqzaZ4AX0J2dIVUmJI+exkjRaXCecZJpE1hMZkDY9+GvohFq8tjqG4gwpNfGLQ+Qb2xYeDeR8xmgmWxa8sy+vzPhT1gDY+tKYSpmq3GFAl99wXJm3AONeHthoN8Dy2Red1bZ5hTX8ZP/ua1fmFb4Hm5tD8EjPceMqSjOHrqnDOWE/NtyNq64K56g0V90eUv9M98ijGmZHZKnFY3Ab6B5aSMdHYwvn8PlV1LjKpA7twye1Kjyg/zwaHHtuga76OmP7uQKyYIiJXKUN+TKKQEdMqPVp5y3LeCvtDMOMIIjcB9H2vJHBWL/UjckkQsMBTvQK31Kt3DIQ3iYaMF53bkamATdSYKRNQX4wWR+IyYOI1vu3ac9XheCiDn8hV0rIwrhgDSGM5e9it07NEW4yYMkYo22LWCeTRCpxHCqMv5ItD/oqkDp6qkdxm8/Ot/5O9VGSbmOir7Vc7CBszwEk8xnClKguci3256LE8VMJEw2VsdKm2hBY+5CW3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0102MB3106.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(136003)(346002)(366004)(376002)(451199021)(36756003)(478600001)(54906003)(6486002)(71200400001)(122000001)(38100700002)(76116006)(41300700001)(8676002)(91956017)(8936002)(4326008)(6916009)(316002)(86362001)(2616005)(83380400001)(66556008)(66946007)(66446008)(66476007)(64756008)(6512007)(186003)(6506007)(26005)(5660300002)(4744005)(2906002)(7416002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVhTTXh0QjNLN202Z0FYb1M3dStYL2pCc3JZc0R1RllhczBFa2kzWlh4SHR4?=
 =?utf-8?B?WjZjZmdKTk5rS1ZXSk91WlVNRjlkRUlZc2hPWGpFdHVxOU56VVc3Vk42dGV6?=
 =?utf-8?B?Y2lqckhBQWExbktCQVF0V1JYWjNQazlMMjBKR2Yrem9WNXM0ZktUaGZ4Q3Bo?=
 =?utf-8?B?TGIyV1crU0srd1o0WTQvZE1tTUZCWmk5c1NocENKOGM2MTBrVHdEMmd4Vk13?=
 =?utf-8?B?OTBKa21ZVGVpZE5TRk40WUM0MEVYaGl4enNndE43TWVab1dKQmRTa1B2a2Nz?=
 =?utf-8?B?dHJ2N2VycXY4VmRQNmN5WUJ3ZjJWQ3Z5QlUzdDFsbEZSYU90c01seHdYMFJX?=
 =?utf-8?B?Si9GS1VCRzBhUDcwS3NSeG1vRTBwUlE2WlZ2TUFzcHlQQ3ovVTJXVHJtS1dR?=
 =?utf-8?B?SERBWHMxOHRMRmowNDN6VXBET0x0dUMxVmZHL0d1QXRiUVdzQW50K2hoUTM3?=
 =?utf-8?B?R1FPZU1hT2N6VnlXSWl0VU5XdEZURWFtalU2ZGpjNzF6bk5yWHlrVnFlYnlN?=
 =?utf-8?B?aGxPckRQcnN1OHNGbkNwTXNMaUlVemd2eEhJRkNZTHJ1VEZFVW9DQVR4d05s?=
 =?utf-8?B?d1R4blphUHR1aFc5K0pTVEJsQzhGUzd6bVY3TDJqOXdXbk1BdzY3RisxOTF5?=
 =?utf-8?B?T3pvT3UwUzlUaWV5VU5sTjVsd0toa2x4aTZxU25XTDNYVTVsR1RhNnMvWkE1?=
 =?utf-8?B?UmV3cWw0SzFudVdVY3N0YnRlUkdWYWV4YjJlWTVJS09qbmp5blozN0NjU1VH?=
 =?utf-8?B?akJHU2dZcHF6TDFyU2ZMT2cySjBWdEh5MVdKbGdaTDJNZFQwZmhmWk51clJu?=
 =?utf-8?B?cENlSTdPRkdDS25XQmxUK3BGWVZGZ1JPZm03REtwa0hYa05HODZrWVlibnIv?=
 =?utf-8?B?VXFaeUxlcURyb1c1elJ6Y2p1bENpeS9ScjRYV3IzUmJQaE00dUJobGU5QjN1?=
 =?utf-8?B?bTBJVW1NVG5BNzJmcTlBZjVZME5EazM2b2RGREJvYlhneEdOa1h2VEdmRGhm?=
 =?utf-8?B?WE4rdVdHbjQ5WTUrVDFzLzBJTVFuQTJ0dW9waXRWTnJrcU9JcTJGTVphcU9O?=
 =?utf-8?B?UFUxclZHWG9uTytta0NqNEp4ZGtRVzNpSFJSUTZHTUM4ZmRIeGd5YitrVy95?=
 =?utf-8?B?VXpqN3Z5MEdla1JMbGZEWGxnRUx4TXdrMkEzYXBJN3ZwT25WMGp4Y2lYYnY2?=
 =?utf-8?B?NUZRTE5sa2pDNVFkeGxodGZMTGpieDRXQk95ejhKTkYyZmpjUm15b1F6V0Vy?=
 =?utf-8?B?QjZ0S3A2ODFuU09lQ2JiQ3ZBZXdBZ3VDcWIzWWk5bG12ei8vcTYyRFVMQUwy?=
 =?utf-8?B?NkpFZnRtQUYxdmxtc0JNNXdUTkFHS1dpb20ya1U2a1k0MXcwejhDelpWVG1n?=
 =?utf-8?B?QVNMUGdsemdpeEQzWmZyMGxhVGxqcjF6WGdLWDYrUnJybUZmQS9qS2JHeEJ4?=
 =?utf-8?B?Q25mRW92RXdOTXV0REVHNDZsdDU4WXo3cFhNZTV5bDcxck1PaDlLWTRTQlhY?=
 =?utf-8?B?N01UblNMdk4wQ0xiRnhpSDBUbEsvdHBLSlh3b2daSFpCdm1vbnlkN2krNG96?=
 =?utf-8?B?NVp1YStyNjBGd0t0Sjlsa2FXSVpLMGFTQTVmcTBFQUFmTVJqZUd2UktxNE9B?=
 =?utf-8?B?aHJnbUhlQ1UrOUp6YktBMmwyUHFzc0xwTkkvMmNIR2EyeUN6KzdyQmRYU2lp?=
 =?utf-8?B?N1BaaGw1NTFsVEJxdlJ1aXVlMGdObEozUlB4NWdlSzhBakp5YkQ1Z01xOG83?=
 =?utf-8?B?NStSZEdaNVNON2Q2TUdoQWk0VStSM05TV1pxQzFIenl4SURhbEEvSmNwOEVj?=
 =?utf-8?B?L0JSMmRvNHhjaE9PN054cFBFUzlCM2E1MEF2OEVadU80cU9kS1U4aldFZDlC?=
 =?utf-8?B?eDZtRDk5Vzl6MFRManJLVnZYdU5jV1czaXBHbjR4bmNqcTBXMVJtYkpLUEpw?=
 =?utf-8?B?TENFcmU0MnVndENwbWFHR3loSC9PNkUyRnk1dHBNaUZsbTBhNXk0T0lQZlU2?=
 =?utf-8?B?RDZrRGFaVE9QaGpZTFJjM2lyckVnZHNLVTNXeHNNOVhLWHRqbE1Yb0p4eVd4?=
 =?utf-8?B?WklWaW9jaG5PdFBDR2JqNmQzbVp2aERScUdSaWVKWDZVOHB5M0h0RitUbC9B?=
 =?utf-8?Q?oFfP4lojuQNaGLV+PMitrtXM/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C8BCE150D646E4DB3B40E155CA0D054@eurprd01.prod.exchangelabs.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siklu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0102MB3106.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcffe9be-9fb5-4954-69bc-08db3fe8f666
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 08:43:20.1521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5841c751-3c9b-43ec-9fa0-b99dbfc9c988
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fxM6WwZEItedDPoTYT/rEJbESgrKglfjmPpC3/CQFUfwntT3QLj0oKRI14xm7hEt6jkpMscLbKP7DVfv2jd7Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR01MB10342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTE4IGF0IDAyOjM2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
Q2F1dGlvbjogVGhpcyBpcyBhbiBleHRlcm5hbCBlbWFpbC4gUGxlYXNlIHRha2UgY2FyZSB3aGVu
IGNsaWNraW5nIGxpbmtzIG9yIG9wZW5pbmcgYXR0YWNobWVudHMuDQo+IA0KPiANCj4gT24gTW9u
LCBBcHIgMTcsIDIwMjMgYXQgMDg6MDc6MzhQTSArMDMwMCwgU2htdWVsIEhhemFuIHdyb3RlOg0K
PiA+IFRoaXMgcGF0Y2ggc2VyaWVzIGFkZHMgc3VwcG9ydCBmb3IgUFRQIGV2ZW50IGNhcHR1cmUg
b24gdGhlIEFyYW1kYQ0KPiA+IDgweDAvNzB4MC4gVGhpcyBmZWF0dXJlIGlzIG1haW5seSB1c2Vk
IGJ5IHRvb2xzIGxpbnV4IHRzMnBoYygzKSBpbiBvcmRlcg0KPiA+IHRvIHN5bmNocm9uaXplIGEg
dGltZXN0YW1waW5nIHVuaXQgKGxpa2UgdGhlIG12cHAyJ3MgVEFJKSBhbmQgYSBzeXN0ZW0NCj4g
PiBEUExMIG9uIHRoZSBzYW1lIFBDQi4NCj4gPiANCj4gPiBUaGUgcGF0Y2ggc2VyaWVzIGluY2x1
ZGVzIDMgcGF0Y2hlczogdGhlIHNlY29uZCBvbmUgaW1wbGVtZW50cyB0aGUNCj4gPiBhY3R1YWwg
ZXh0dHMgZnVuY3Rpb24uDQo+ID4gDQo+ID4gQ2hhbmdlcyBpbiB2MjoNCj4gPiAgICAgICAqIEZp
eGVkIGEgZGVhZGxvY2sgaW4gdGhlIHBvbGwgd29ya2VyLg0KPiA+ICAgICAgICogUmVtb3ZlZCB0
YWJzIGZyb20gY29tbWVudHMuDQo+IA0KPiBUaGUgb3RoZXIgdGhpbmsgdGhlIE5FVERFViBGQVEg
c2F5cyBpcyB0byB3YWl0IGF0IGxlYXN0IDI0IGhvdXJzDQo+IGJlZm9yZSBwb3N0aW5nIGEgbmV3
IHZlcnNpb24uIFRoYXQgZ2l2ZSBwZW9wbGUgdGltZSB0byBhY3R1YWxseSByZXZpZXcNCj4gdGhl
IGNvZGUsIGFuZCBsaWtlbHkgdGhlIGN1cnJlbnQgdmVyc2lvbiwgbm90IGFuIG9sZCB2ZXJzaW9u
Lg0KPiANCg0KSGkgQW5kcmV3LA0KDQpTb3JyeSBhYm91dCBpdC4gVGhhbmtzIGZvciBsZXR0aW5n
IG1lIGtub3cuIA0KDQo+ICAgICBBbmRyZXcNCg0K
