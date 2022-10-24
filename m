Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F16360B68A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiJXTDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiJXTDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:03:14 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2139.outbound.protection.outlook.com [40.107.114.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1C720270C;
        Mon, 24 Oct 2022 10:42:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvFbD9j4PE1kP4/Iy9U+axfZ4tB7vFUjzNhPmAismJdgo8wETx6ESGuvo7NlvWryzL6FG9sYAiB2i5B0JaQLmOWu9oH7P3IWI2HRk3X40OewDCBGlbxDDBMUGKsdeU8XdNIUVPxSiEZABYEgEjC6jK3bia5DVrKDpTDc/FUg59f1/dqlrntWSEpwo9ud78ZTMsFvXyCDGCRvtGT612eWrV4BEEQxki/LFGGT69FNIYreLCbbpfzElaVwNpWVw4n4aVUcBARCMnSYnc71aebpxPwswyrrisZYdylzCmhRSihwCqLR8n/J0pZvDH/XkVbtNxG+LQuTGDSih3XgBABIAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw/pxZvQ7WanOgz6bE3i41hwADQ2zmx5jcSrah1U2aQ=;
 b=i4QYWin0nwtQahPazpaUO+nAVwHmK/RuZzQJwK5TfAZ4fbxc39BllmpSQV/DW/VwZEkJxBSXpNIlwOMIUlGBPjgRL3WpJnRexfeKQNGi2DGzEj/Rz+3fOvUbtgYrB5fc5lBeZKeR2aWUbzQXYxIM96+TV6jBeb9r8hUdkgTCUvivb4gcayDOj4FYJb8q5X+UThkmxoyulUsuqPS1+FWIbMqPg8WmC/vNbZ9MGxtAlYqnbNCJ2+Kh0sl5uPIuScLzBvw/dK9yZyynZWa4xG1vCe7M8WY+G7CcoeqDacPrj0mNvBsgEMpTFNk2R51ydZOYYzbdVPNfis4H1YgZdvg2ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw/pxZvQ7WanOgz6bE3i41hwADQ2zmx5jcSrah1U2aQ=;
 b=jUl9tnCsqaiKn5sFAdUwCqbH3EJTJBWG9h7TQ5/1I1iw7Y4C4nEGn4HS+g1n/5w3VJKejAF3rNZiSaMAX5LZ4JPY43pNzP66wkGZp3r8BzM2WYaJP2uQnAtKxJWurR5wCsXFvo8cEWB+0b6yNLMeHLIWCQtua5MLyzw6QcAKcmQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB5994.jpnprd01.prod.outlook.com (2603:1096:402:31::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 24 Oct
 2022 16:55:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 16:55:56 +0000
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
Thread-Index: AQHY5fEK6d4STYQGnkuaJSprEex4Pq4dsSYAgAAEjACAAA32EA==
Date:   Mon, 24 Oct 2022 16:55:56 +0000
Message-ID: <OS0PR01MB5922B66F44AEF91CDCED8374862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
 <20221024155342.bz2opygr62253646@pengutronix.de>
In-Reply-To: <20221024155342.bz2opygr62253646@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYAPR01MB5994:EE_
x-ms-office365-filtering-correlation-id: 7449304d-432f-4155-de63-08dab5e09e85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KPxkQ6HlmS2qZ5M0odGz/hgYj7ED+gIbTZbJyPpegAyjpLbCBie3LVsXWObYpR3U3onBusK02TjH+nw4DXClOM3AYkg4ad+AmBIvNsFzPBu9D6dkFUj6R7YVchpNHDjvorNM2Hz83RAIBdfxKH5WqW35AXB7gb5Jj+1WlskmCeMz9fIOqkCznliKlICaI4qbp5pXq3ogtKR4yBm4kFb8c8WwMXbVqJ4IPeJjmHFiKkHrxLn6nbTNgBWlVtfDZRNzxHMfClsmJbZOvYQQBlTd1+kiZx1tRQFOKpD7/F8dSoVkltRdVm4ZYSt2TggDDwksMOSZd5tfSQcc1dyw7egV8d2ssmKcUmejxErS5WjN5CuAABCRgJ3+PQrgvIJRa4k/RMP8MBKpacsv6SKdAth1h/ogWPgDg90hCmcuL9+pEdm8xxuZIaGIAiIrmKLkQbodBsUOb5gqQWmMjqZmvKNOzQn4bkwEbT1bCKQf0Pl/7QHUBTvUZ5Kl/nQtoUyz2J3eQBUBDrHCM66djSopmmsScv5IpfdRQmpjwzAb25ew71E+1CQd5cBoqFZWS1R+47GqtdqLdDVuHP4ybL6lhCIJy+/D0LKtx5qMNyeSAYCJzNIDIg0uTso3nbbTdhDui6+flU+9t4b2Dwa3x/MzQvpdDZibUDosjB/6PzZq7oOdBYsN7p6L/Izg44/GPrfHsu45YjPpSTJI1bJHHR31yThsHbnSJ3TtAFlM3tcQHTbwVHacOqp3bfWP9uuZ16Wi14RCCoHz8UqAMdL2Ix+uecHutw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199015)(33656002)(66556008)(66946007)(76116006)(38100700002)(86362001)(4326008)(54906003)(6916009)(316002)(8676002)(64756008)(66446008)(66476007)(122000001)(38070700005)(55016003)(478600001)(83380400001)(9686003)(6506007)(7696005)(53546011)(71200400001)(26005)(41300700001)(8936002)(2906002)(52536014)(186003)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFNJemdWa2tVVXBBdFc2OVFBdTFuZEtIV2QwQjNiRHZBaEw5V2pNTFVnNkI2?=
 =?utf-8?B?VVlERFhOZEdpMG9UcGxqY1ArdGsyYkpBYUVyQlpTMks5bUhycE5hRWNSbjZ2?=
 =?utf-8?B?aThOMHF0djdjenpKR3pRTS92WGpzV3ZRV3h4ck9nSDNRMWpRSVFlZzhPcFdr?=
 =?utf-8?B?K29kRC8vNVFYZWhKeEdhd1E5YVQ0NlNmWWQ0Y3ArV3g4d3djQzNmRWFlR014?=
 =?utf-8?B?bENjUDJtZ3pXR0Y0akE2YkliYllMWWNtU2ZIY0N3MlhIZTdZSC9OQ0RvYmF6?=
 =?utf-8?B?RmVoNGZPcW44a0FOTU13QkQ4dGJSOUpKR0lKU0tUUHUzOEkzQlVTd3kzVTYz?=
 =?utf-8?B?aEhnT25vY0VjdmZBVER6UzVUVDdLa2cxUDBRWi9kS3B4NHpaY1JpN3czU2RD?=
 =?utf-8?B?S3hxZ3UyR3lQRmR4MDFXd1NTdUZLTnFzMWwxRHJNQkpHK0dpbDFncFNyUnZl?=
 =?utf-8?B?S0FvMjhDdDc1bkE5dDJHUkh4dU1rb09IaERFTEx6Zk9uOVZLcVY3cDFucE04?=
 =?utf-8?B?aWc5Z1AzQ2ZpRkpvWlBGQ1phQWI2U0E3UU5WWm01ZHRkVm1obGd2UjFBMUNP?=
 =?utf-8?B?b1RTd3JoK3F2MytmU1pQWkYxa1F4YVBTMGtQWVF3Skd2UkZETytvazE4ZWUw?=
 =?utf-8?B?N1oveEpwT1JnL0RrM25EUkk5c1VNVk14bzdoVTNXVTRTNEFldHp5VnRMaFZW?=
 =?utf-8?B?enRzckwzWTk2MkREMlN1dXBySEp5MHgxUTMwZDVhQk1lbmpOV0hPaUU1SnpQ?=
 =?utf-8?B?eDlKRlR1MEZQc2VnL0lvQS9oL1dqamtmMW4ySm5HNjBJNmQ1d3JBaHd5djZL?=
 =?utf-8?B?QndCd0R1ZUNpTktseHBnUHk3RytGOGYzUnpsZStybnBHZVZoU2c3U0tOUGUx?=
 =?utf-8?B?U1RLdUNZTDBLRWNNemtQanpMSU1WODNnMG5JWGNRbkdoZzhOUlIwaUFnUCsy?=
 =?utf-8?B?WWdnTGQwN21FcTdlMFNIemFueUFrclg0bEFHck5tYm82MWdIaUNtZmZWQVkv?=
 =?utf-8?B?Q1RIUGhoc1ZZMVBNUXZLNTNnK0tSZUxVQWh6TGpHWEdtOXhFQ2t2aWs3TGU3?=
 =?utf-8?B?YWF2T0gveStpQnBGYjhJQzRvbEE3TUdWT1F3TWRSWVpWN21hbFUzR0YrZUFr?=
 =?utf-8?B?QnEzSXU3NWYvQlJ1MHAwOWQrMFkrc3hBN0ZqdTVBVzUxRGErUnRLQmFydlI3?=
 =?utf-8?B?QlN3bDVSL21MRE9ZNC8va2p5aFpKMXUwVnh4MkxiK3NZWTNtaEkwMlJsbTBr?=
 =?utf-8?B?dnFLK091OVcrRGxjenlFSm5RZnoxOXZMdEE3VTU3R3g2ajlaT2N4RGZKSWFD?=
 =?utf-8?B?VVVZU1U0cTh4Z2MvZU9EMnZWNVpPTU03V1dCZ2d2WnJCZUFzWkpnUW9hUUtp?=
 =?utf-8?B?SUtzOW5mbUJVWWNXc01qZjJtc3R2bnlOQ2FiczA4TVhTc3VMeCsxcmpKSU9v?=
 =?utf-8?B?eUQxQmUxVzdUaFZnMjA1c1dpVWNlZys4eE1tSmppNGVwbmhBWXpLVHZpNzJs?=
 =?utf-8?B?bTFWMVI3cHZ3VzltSk1HZ0RJdjhJYUNyOGIwNVM3dm1ZcmpEVXY0MEhNa1ZW?=
 =?utf-8?B?bmlqcFplUzRGT1poanRCRGVuZkNjRmR6eWRnei8yK1pHS1VpejN6b2gxZEtD?=
 =?utf-8?B?YUhZeDlscnBmL0tiRyt0Vzk2SkNIOU1sT1F3VExNRS85eGFYQzdjTXRpbTBa?=
 =?utf-8?B?RDVFd3Q5L2ZlemZ6THllUk9wUFkvdmM1ZXo4QnN2UnZrQThyQndtNHVNT1Ar?=
 =?utf-8?B?U2MrNmV5OGZKQ21HZjg3YmNjbVFCVUFLNXV6eURGVlB4Sm5UVyt4ZW9YUXVN?=
 =?utf-8?B?ZkJQUm1qSDJ4UmN4dkVEZFplTVJJSERKd1dZeEtDZlQ4Tm1jcG50dFo0QktT?=
 =?utf-8?B?MjlZQmhEK2ZsUmhvK2dtUkcyWnREVmJrMjlsOUpaK0NuanYrQmdmSTVrOW9V?=
 =?utf-8?B?ODY2bzlLZVRFQ0Y4NXh4U3pqanpjM0xDWC9LV1Uray9RVUYyakRIOElVelgw?=
 =?utf-8?B?OGJrVHMyUEtQMnJDNy9YMTZ6akVKbVVybVY4cTFvTElvazl3OW1ITENXWENX?=
 =?utf-8?B?K3l0YWlwdEU4MUpxWk1mZysybW14QWl4TGxJSzF6L2p0eVpnQ2l2WlJZUExJ?=
 =?utf-8?B?VU9UczFTZnpRdXV2YnlQRHE1UzVVZzVyVm9OL21mMk84T1NGTjJPTmh2RVdi?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7449304d-432f-4155-de63-08dab5e09e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 16:55:56.2596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bfQ7+P8SQs0Tgnzfg+g0+uoT/1wrORlewNqyvMHucpUaJvT+MqVF/0Zm6kZSPxikZeyaQFc94phwK/d7kVSCbtuPoIKkiDnXgyb1tQdEW5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5994
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzNdIGNhbjogcmNhcl9jYW5mZDogRml4
IElSUSBzdG9ybSBvbiBnbG9iYWwgZmlmbw0KPiByZWNlaXZlDQo+IA0KPiBPbiAyNC4xMC4yMDIy
IDE3OjM3OjM1LCBNYXJjIEtsZWluZS1CdWRkZSB3cm90ZToNCj4gPiBPbiAyMi4xMC4yMDIyIDA5
OjE1OjAxLCBCaWp1IERhcyB3cm90ZToNCj4gPiA+IFdlIGFyZSBzZWVpbmcgSVJRIHN0b3JtIG9u
IGdsb2JhbCByZWNlaXZlIElSUSBsaW5lIHVuZGVyIGhlYXZ5IENBTg0KPiA+ID4gYnVzIGxvYWQg
Y29uZGl0aW9ucyB3aXRoIGJvdGggQ0FOIGNoYW5uZWxzIGFyZSBlbmFibGVkLg0KPiA+ID4NCj4g
PiA+IENvbmRpdGlvbnM6DQo+ID4gPiAgIFRoZSBnbG9iYWwgcmVjZWl2ZSBJUlEgbGluZSBpcyBz
aGFyZWQgYmV0d2VlbiBjYW4wIGFuZCBjYW4xLA0KPiBlaXRoZXINCj4gPiA+ICAgb2YgdGhlIGNo
YW5uZWxzIGNhbiB0cmlnZ2VyIGludGVycnVwdCB3aGlsZSB0aGUgb3RoZXIgY2hhbm5lbA0KPiBp
cnENCj4gPiA+ICAgbGluZSBpcyBkaXNhYmxlZChyZmllKS4NCj4gPiA+ICAgV2hlbiBnbG9iYWwg
cmVjZWl2ZSBJUlEgaW50ZXJydXB0IG9jY3Vycywgd2UgbWFzayB0aGUgaW50ZXJydXB0DQo+IGlu
DQo+ID4gPiAgIGlycWhhbmRsZXIuIENsZWFyaW5nIGFuZCB1bm1hc2tpbmcgb2YgdGhlIGludGVy
cnVwdCBpcyBoYXBwZW5pbmcNCj4gaW4NCj4gPiA+ICAgcnhfcG9sbCgpLiBUaGVyZSBpcyBhIHJh
Y2UgY29uZGl0aW9uIHdoZXJlIHJ4X3BvbGwgdW5tYXNrIHRoZQ0KPiA+ID4gICBpbnRlcnJ1cHQs
IGJ1dCB0aGUgbmV4dCBpcnEgaGFuZGxlciBkb2VzIG5vdCBtYXNrIHRoZSBpcnEgZHVlIHRvDQo+
ID4gPiAgIE5BUElGX1NUQVRFX01JU1NFRCBmbGFnLg0KPiA+DQo+ID4gV2h5IGRvZXMgdGhpcyBo
YXBwZW4/IElzIGl0IGEgcHJvYmxlbSB0aGF0IHlvdSBjYWxsDQo+ID4gcmNhcl9jYW5mZF9oYW5k
bGVfZ2xvYmFsX3JlY2VpdmUoKSBmb3IgYSBjaGFubmVsIHRoYXQgaGFzIHRoZSBJUlFzDQo+ID4g
YWN0dWFsbHkgZGlzYWJsZWQgaW4gaGFyZHdhcmU/DQo+IA0KPiBDYW4geW91IGNoZWNrIGlmIHRo
ZSBJUlEgaXMgYWN0aXZlIF9hbmRfIGVuYWJsZWQgYmVmb3JlIGhhbmRsaW5nIHRoZQ0KPiBJUlEg
b24gYSBwYXJ0aWN1bGFyIGNoYW5uZWw/DQoNCllvdSBtZWFuIElSUSBoYW5kbGVyIG9yIHJ4X3Bv
bGwoKT8/DQoNCklSUSBoYW5kbGVyIGNoZWNrIHRoZSBzdGF0dXMgYW5kIGRpc2FibGUobWFzaykg
dGhlIElSUSBsaW5lLg0KcnhfcG9sbCgpIGNsZWFycyB0aGUgc3RhdHVzIGFuZCBlbmFibGUodW5t
YXNrKSB0aGUgSVJRIGxpbmUuDQoNClN0YXR1cyBmbGFnIGlzIHNldCBieSBIVyB3aGlsZSBsaW5l
IGlzIGluIGRpc2FibGVkL2VuYWJsZWQgc3RhdGUuDQoNCkNoYW5uZWwwIGFuZCBjaGFubmVsMSBo
YXMgMiBJUlEgbGluZXMgd2l0aGluIHRoZSBJUCB3aGljaCBpcyBvcmVkIHRvZ2V0aGVyDQp0byBw
cm92aWRlIGdsb2JhbCByZWNlaXZlIGludGVycnVwdChzaGFyZWQgbGluZSkuDQoNCg0KPiANCj4g
QSBtb3JlIGNsZWFyZXIgYXBwcm9hY2ggd291bGQgYmUgdG8gZ2V0IHJpZCBvZiB0aGUgZ2xvYmFs
IGludGVycnVwdA0KPiBoYW5kbGVycyBhdCBhbGwuIElmIHRoZSBoYXJkd2FyZSBvbmx5IGdpdmVu
IDEgSVJRIGxpbmUgZm9yIG1vcmUgdGhhbiAxDQo+IGNoYW5uZWwsIHRoZSBkcml2ZXIgd291bGQg
cmVnaXN0ZXIgYW4gSVJRIGhhbmRsZXIgZm9yIGVhY2ggY2hhbm5lbA0KPiAod2l0aCB0aGUgc2hh
cmVkIGF0dHJpYnV0ZSkuIFRoZSBJUlEgaGFuZGxlciBtdXN0IGNoZWNrLCBpZiB0aGUgSVJRIGlz
DQo+IHBlbmRpbmcgYW5kIGVuYWJsZWQuIElmIG5vdCByZXR1cm4gSVJRX05PTkUsIG90aGVyd2lz
ZSBoYW5kbGUgYW5kDQo+IHJldHVybiBJUlFfSEFORExFRC4NCg0KVGhhdCBpbnZvbHZlcyByZXN0
cnVjdHVyaW5nIHRoZSBJUlEgaGFuZGxlciBhbHRvZ2V0aGVyLg0KDQpSWi9HMkwgaGFzIHNoYXJl
ZCBsaW5lIGZvciByeCBmaWZvcyB7Y2gwIGFuZCBjaDF9IC0+IDIgSVJRIHJvdXRpbmUgd2l0aCBz
aGFyZWQgYXR0cmlidXRlcw0KUi1DYXIgU29DcyBoYXMgc2hhcmVkIGxpbmUgZm9yIHJ4IGZpZm9z
IHtjaDAgYW5kIGNoMX0gYW5kIGVycm9yIGludGVycnVwdHMtPjMgSVJRIHJvdXRpbmVzIHdpdGgg
c2hhcmVkIGF0dHJpYnV0ZXMuDQpSLUNhclYzVSBTb0NzIGhhcyBzaGFyZWQgbGluZSBmb3Igcngg
Zmlmb3Mge2NoMCB0byBjaDh9IGFuZCBlcnJvciBpbnRlcnJ1cHRzLT45IElSUSByb3V0aW5lcyB3
aXRoIHNoYXJlZCBhdHRyaWJ1dGVzLg0KDQpZZXMsIEkgY2FuIHNlbmQgZm9sbG93IHVwIHBhdGNo
ZXMgZm9yIG1pZ3JhdGluZyB0byBzaGFyZWQgaW50ZXJydXB0IGhhbmRsZXJzIGFzIGVuaGFuY2Vt
ZW50Lg0KUGxlYXNlIGxldCBtZSBrbm93Lg0KDQpDaGVlcnMsDQpCaWp1DQoNCg==
