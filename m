Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A77C60B738
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiJXTVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiJXTUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:20:53 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2131.outbound.protection.outlook.com [40.107.114.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB175BC2C;
        Mon, 24 Oct 2022 10:56:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4Gh/crCecMJUJhBoD9/uU92AXmiklrzg+f+8VquPhqnQqtouAV8fJ00bGT4s2IISc1tHJ5AHcR8a0OUUYqHDsbsQrKHRghuVDF8bx2hUMvXt99QZD2GRil/2vlqd/viXQOxmHrF46QnAA543e0KNGRW9xoQ6H338+uYNCyShKnabD/ZhsJwVN/jX/i9rx+v9d2Yn5EOaQaTMUzAcgi5z5nGcv7EPXrHVcPNsBTuB7BxZG8vAdb12HOFJnCZnKVKz2Bg2MbR0CWZb0ry7u7zt59UIyI2WVD8l+hnMgD9ggnrOHYXQTCwyTzT2lAIcMnGIIcqaZjx3vCnF5upm7Pswg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wugaQtn3+urqxU/NdQhENIpClPwk4PhGYfxNMndjKE=;
 b=Y6YBeaDsKxdyAEsxewM+TpgpF6AuKrMtRM3V5Lt5km+PyHDPXIhRCM3ZS06L7TbHomFNv3X0suOGpUL19SLSjWu+YfQxUHOAqmuhGiQZIoXWznkHmKLBdLCHWxE2/XJ6eePQ+d94Pois8fZzeTp6G3nVHEXroM8/zTXq/hCdPXegzl+hz8L0fGsZp82XM7uX3h2XJG/9QkmL8/+2OEEGmLwXiYzyo4v3f0l7plDMwvxkEi81T2iXf3egzQnVN7ZT+r3SFdaZbVQwJGggeKvXrA2lgQUqtlMp7Gw8/2J15XOsdFnkvHTctjzCZKZMYTUBrLL+nYOXcANnib9W0zVZAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wugaQtn3+urqxU/NdQhENIpClPwk4PhGYfxNMndjKE=;
 b=gvRPh4rdZ3u4HZsvCNXJJZphMkA52LyMOPaRwMyarDPtHDS1OySL4bexGOGDG8i7gnknDhfOScmb0+hLMwH1eJAZdjXtaA6z4tVveEiMnVbNqs5x6cydulv0w/CYXInUJ+LWO5fg2ujfMyawBtKo3Bvj9iCr+zOjndy+2textkQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB9940.jpnprd01.prod.outlook.com (2603:1096:400:1d6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 24 Oct
 2022 17:23:52 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 17:23:52 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 1/6] can: rcar_canfd: rcar_canfd_probe: Add struct
 rcar_canfd_hw_info to driver data
Thread-Topic: [PATCH 1/6] can: rcar_canfd: rcar_canfd_probe: Add struct
 rcar_canfd_hw_info to driver data
Thread-Index: AQHY5gXTstw6Pm+XbUmJxdiaeJ1fF64doQ0AgAAsjKA=
Date:   Mon, 24 Oct 2022 17:23:52 +0000
Message-ID: <OS0PR01MB592210A750AB6988560C7D78862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
 <20221022104357.1276740-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdUThOzOKoQGbK4cRNrfPeHvv5RsRFQnAhudR0U8eD_zBw@mail.gmail.com>
In-Reply-To: <CAMuHMdUThOzOKoQGbK4cRNrfPeHvv5RsRFQnAhudR0U8eD_zBw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYCPR01MB9940:EE_
x-ms-office365-filtering-correlation-id: 02e8f162-1ba6-42b1-a788-08dab5e485b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aVwjYxLm5WTCAAIQmBf/eUiRiXmvNGLkVe8YETZ0KLIf/0NyQnvpPgKYhDo+4KJiSbt5vjc4jNpogE3qpuDVpWT+JtlORRGTBubx7czMFvyU6/hvz26yRCy6DXmkwmJfbir8q+N5OIy0PMTwKmHnaS4a64DwGd3PzTaCzFRm36xlBthIlE5WYavC/kLkcoJoY54BaxHapw5QbvlYBr88dDyWvS2uiFkBBGMmiiDvHNSkPGe+JfVLPzaHNVAJZSyqEUzfMtwsmupVh/tVfSUYm8nDKJU6JIUiR2acdFxBhNarw7MU/vtGVjJEU9GgsDdPIPFxKe+QLnOCH+zRyHwGtJBxcSOeYoPE2Ho0OsWChZVQC23LEueLpgKFb+AO1NdmLppOnDmYRZ2ujEcNOOR8uCwJG/EyhrOOewNzEwKPQuft8z0lilw46ce8R68tA8rfl3Nsd7eVVc0kdXZjFQ9MjYc9g6E8HgBGvT2aRrkeCyVrejauoR1zw97sIFCA9104Ol0zPwVi9RL0x1bH2M9lmVeoD3GcGfu0kdHCxBXjrtVZ2ERmyvErQAYXCdBT/erLM6sqikqtxQt2lF1+yisIpW/kL04cnNks+meUlzQxBEbKtFPGwISoVOj15V2lJc2cDK80ghgI1tk+qs42BWiAIx0Uyr6t5mgld21gPilIP8B51kXXhzetJDHMQzSiRoLWlMe6NIh/iLtRzv+LgToyKIKumiKPAZeAYqalj4/VSv+JoJebd8AI/bW+xAMCe4JhXh6ClXNRT2MOCYyVoVnf7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(38070700005)(33656002)(86362001)(38100700002)(122000001)(8936002)(52536014)(5660300002)(7416002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(41300700001)(8676002)(4326008)(2906002)(53546011)(7696005)(6506007)(26005)(186003)(9686003)(54906003)(6916009)(316002)(478600001)(55016003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmZUdG03dXdmRm9CdFZWUEFjTHkwbi94MUt0WU1nVnlsQllwNWRqQ1kzZG1N?=
 =?utf-8?B?S05kNXlYek9Xa3NIWWp6SXlMRThlV2tmeGlMMmR4MTdNa0FBS1BNOUZWTHRX?=
 =?utf-8?B?YnVKMGdRQ1lhYXJ4Rm55bkRTTTQvMVdoVU5sMGlSNXZPNVFDWkx5WWNYSG9l?=
 =?utf-8?B?Z2ZqbDBkZjlNWnkwUjBqV0dKUlhDTjkyL1FHYkQyQ3V1WHo1Mm5nMlNoRmhm?=
 =?utf-8?B?NUpZNzEyYlJnV0N6R2sxTkxnYUtJaTRiMlNSN0IwTXpJckdFYU1MQUx6dmpU?=
 =?utf-8?B?bGVaZDJ4S1lkSzdpM0FKMDVQd3cydlFCRVpXekJ5VzE5NHplYWpIdUtSRkZE?=
 =?utf-8?B?R1Vvb3g4VkZoS2V2Y2tJZ0creEhtd1lRYTlIdlh1UktGY1Q0V2w2c3NBUU9X?=
 =?utf-8?B?UzZoaExvc2MyS2FpSXVMa1FyRThVaUlZdGhwSTFjMkZNR2gzK0pvbmZ3OHl6?=
 =?utf-8?B?aHJWTDcvenF0akhZc2k1bjRYTEp1dTRCNElHSkJFOE1mS09qNnBiV1J1SWZH?=
 =?utf-8?B?aHprV1dBQ3FxdFJuTUVOUUR4ZkZEQUMvNjUwZ3RWTmJ4VE9tVEZHOUZYZmtj?=
 =?utf-8?B?Q2loWWRTdVBzWU13VkZHdkVibC85QTh4bkw2K3I5azdYZW85VFhTQkErUzE5?=
 =?utf-8?B?V01RT1l5cFNlV2pxOGlxTUh2ZUhXVFViMUxBT2RLRmFNOFVHb2dsWDdXMlMw?=
 =?utf-8?B?SThwcmNBeVFJaCsyb1ZEQWdBUFJYR2JvZEdXeDlYdTZHTHcwUGt0RkFDNjhm?=
 =?utf-8?B?d1NKa3V6TmsvWlhhVlJ5a0VQamVsM0NWUTNseDZWSndpak9td0FpMXh5Q2pm?=
 =?utf-8?B?QXVqSlltZFRqRE5NajFoazV5TFl3OUptcXVoWm9KOG95MURueVR4T2xndEl6?=
 =?utf-8?B?QUlHUVAybWlQWTJ0L0JkeFE3S1VDUlNaVE9JNGQ4WDB4VEdqQ2VKK2xmVW5N?=
 =?utf-8?B?UlRCNWZldG4rTHRMbURIbnB5K2JCSkEvcHBZdUlxc3dTaTBTQjErYzJzQmtY?=
 =?utf-8?B?WEZIelJiMUdVK2hRWlhXUVpRbEMyVGxSWnFpbnc5QW0vcHZMdkZub1pyOXpu?=
 =?utf-8?B?VURHM1d3R1V1cHhzNE5kSjZTVHZaQkdTSlpjMVFTTTZQbHdHVURrNkptMWZR?=
 =?utf-8?B?MlhiL1RLNGlYZ3Ayb0kyRHJzbytyZW5nWStmbS9RSFcxWlQvaWZ2SDN4WWpW?=
 =?utf-8?B?UHd0TzV2QVZFcFAxVk1DMjdzcmJLYk9NVTErUDZOQVp6YlRNaWxhZTZIbzJP?=
 =?utf-8?B?TXhKcnU1NzFObUxjbjZGZGc2d0R1L3V5ZSttMzNUWFVKenVkTmJST05XT3h4?=
 =?utf-8?B?anpuTG5JMzc1TFd1Q2pEaTRQZUpkQU5LZ0RzclhaaTRpbVVIZjhRcmhQQ3Av?=
 =?utf-8?B?M0p6ZEVjVmw4UXhtUGdSYzRVZGh5cGZ0Uzk2RkdBL1JyM1h6OWJBUHVkQ2VX?=
 =?utf-8?B?bTM0Y3hZbUJLdk41QTdERWx0ZVBIdUZpbllQdUJLdTl3Uyt2YURKQnZoNUNr?=
 =?utf-8?B?VW1OdWYzVkFwWGVscVZIQWhOV3VUeWIrYXZqdTMyc1dieHhsNjk3WUpNaXBH?=
 =?utf-8?B?eWtSeUcrRFFSaHFtZEpkV2RNWm1wK3hQaVZsL0RIZzUzdGIvNEw0ZDZxbklV?=
 =?utf-8?B?eFQ0VjBubExkUGJydzBuaGFTZGlFNGxVWktMK3ZiOVJSTE0va1dLWG5PYzlS?=
 =?utf-8?B?SXZZT3RTUTQ3MG5zeWhuSWRwaDdHb0tWL0wwSEdvOFBMN3pyTjMvLzl1a0Rz?=
 =?utf-8?B?MUtXWVlYdTFibUdQMTdCaXlRZUNWc3BVUVZFckxTWkorZXdpZ1cyalVWTzd4?=
 =?utf-8?B?NEV4TjVRN3dPcUtHd2JLY2tWOExYR2p0T1hYckRrQW1LVUR2TmxHR1hNbnVH?=
 =?utf-8?B?Mnc3R2tpMi8vMjZDWFRwVG1ZN1RhUWhJQURGOEVrMnYwemRFMjZ6cFdOTVA3?=
 =?utf-8?B?eFk1dUlib0xFM3BxTjJKQkQ2L1Z3b0M1VFVTU2xheTF5QWdGeHhiUmxVQkgv?=
 =?utf-8?B?clNaYTJidVNzMDZ6cFVkVXNycUhEdVV2dGEwWFArVk44eUw3VDlORzdyRUlV?=
 =?utf-8?B?enFCbkUxd2RybCtCN0lRcFNVMENDTGxYOVpPdDNiSDdlTmFkZGRIeThHalJD?=
 =?utf-8?B?dmtQaDZIK3AvNS80YUVPMU9NMnFralU3T3AvV1hDd2R2TldVcy9YbytLcWhz?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e8f162-1ba6-42b1-a788-08dab5e485b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 17:23:52.6126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VSPfTxOkw/R9LotBNM41G7atI01sxa5UhavYK5kFydftrfp3OS8B5L5hkY5nbI0LG6O/J+GXpFSoVOXhcrPE4862lOnG0uZphTBEhXkRtrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9940
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggMS82XSBjYW46IHJjYXJfY2FuZmQ6IHJjYXJfY2FuZmRfcHJvYmU6IEFkZCBzdHJ1Y3QN
Cj4gcmNhcl9jYW5mZF9od19pbmZvIHRvIGRyaXZlciBkYXRhDQo+IA0KPiBIaSBCaWp1LA0KPiAN
Cj4gT24gU2F0LCBPY3QgMjIsIDIwMjIgYXQgMTowMiBQTSBCaWp1IERhcyA8YmlqdS5kYXMuanpA
YnAucmVuZXNhcy5jb20+DQo+IHdyb3RlOg0KPiA+IFRoZSBDQU4gRkQgSVAgZm91bmQgb24gUlov
RzJMIFNvQyBoYXMgc29tZSBIVyBmZWF0dXJlcyBkaWZmZXJlbnQgdG8NCj4gPiB0aGF0IG9mIFIt
Q2FyLiBGb3IgZXhhbXBsZSwgaXQgaGFzIG11bHRpcGxlIHJlc2V0cyBhbmQgbXVsdGlwbGUgSVJR
cw0KPiA+IGZvciBnbG9iYWwgYW5kIGNoYW5uZWwgaW50ZXJydXB0cy4gQWxzbywgaXQgZG9lcyBu
b3QgaGF2ZSBFQ0MgZXJyb3INCj4gPiBmbGFnIHJlZ2lzdGVycyBhbmQgY2xrIHBvc3QgZGl2aWRl
ciBwcmVzZW50IG9uIFItQ2FyLiBTaW1pbGFybHksIFItDQo+IENhcg0KPiA+IFYzVSBoYXMgOCBj
aGFubmVscyB3aGVyZWFzIG90aGVyIFNvQ3MgaGFzIG9ubHkgMiBjaGFubmVscy4NCj4gPg0KPiA+
IFRoaXMgcGF0Y2ggYWRkcyB0aGUgc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbyB0byB0YWtlIGNh
cmUgb2YgdGhlIEhXDQo+ID4gZmVhdHVyZSBkaWZmZXJlbmNlcyBhbmQgZHJpdmVyIGRhdGEgcHJl
c2VudCBvbiBib3RoIElQcy4gSXQgYWxzbw0KPiA+IHJlcGxhY2VzIHRoZSBkcml2ZXIgZGF0YSBj
aGlwIHR5cGUgd2l0aCBzdHJ1Y3QgcmNhcl9jYW5mZF9od19pbmZvIGJ5DQo+ID4gbW92aW5nIGNo
aXAgdHlwZSB0byBpdC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRh
cy5qekBicC5yZW5lc2FzLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRjaCENCj4gDQo+
ID4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL3JjYXIvcmNhcl9jYW5mZC5jDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvY2FuL3JjYXIvcmNhcl9jYW5mZC5jDQo+IA0KPiA+IEBAIC01OTEsMTAgKzU5NSwy
MiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGNhbl9iaXR0aW1pbmdfY29uc3QNCj4gcmNhcl9jYW5m
ZF9iaXR0aW1pbmdfY29uc3QgPSB7DQo+ID4gICAgICAgICAuYnJwX2luYyA9IDEsDQo+ID4gIH07
DQo+ID4NCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCByY2FyX2NhbmZkX2h3X2luZm8gcmNhcl9n
ZW4zX2h3X2luZm8gPSB7DQo+ID4gKyAgICAgICAuY2hpcF9pZCA9IFJFTkVTQVNfUkNBUl9HRU4z
LA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCByY2FyX2NhbmZkX2h3
X2luZm8gcnpnMmxfaHdfaW5mbyA9IHsNCj4gPiArICAgICAgIC5jaGlwX2lkID0gUkVORVNBU19S
WkcyTCwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgcmNhcl9jYW5m
ZF9od19pbmZvIHI4YTc3OWEwX2h3X2luZm8gPSB7DQo+ID4gKyAgICAgICAuY2hpcF9pZCA9IFJF
TkVTQVNfUjhBNzc5QTAsDQo+ID4gK307DQo+ID4gKw0KPiA+ICAvKiBIZWxwZXIgZnVuY3Rpb25z
ICovDQo+ID4gIHN0YXRpYyBpbmxpbmUgYm9vbCBpc192M3Uoc3RydWN0IHJjYXJfY2FuZmRfZ2xv
YmFsICpncHJpdikgIHsNCj4gPiAtICAgICAgIHJldHVybiBncHJpdi0+Y2hpcF9pZCA9PSBSRU5F
U0FTX1I4QTc3OUEwOw0KPiA+ICsgICAgICAgcmV0dXJuIGdwcml2LT5pbmZvID09ICZyOGE3Nzlh
MF9od19pbmZvOw0KPiANCj4gInJldHVybiBncHJpdi0+aW5mby0+Y2hpcF9pZCA9PSBSRU5FU0FT
X1I4QTc3OUEwOyIgd291bGQgbWF0Y2ggYWxsIHRoZQ0KPiBvdGhlciBjaGFuZ2VzIHlvdSBtYWtl
LiBCdXQgSSBzZWUgd2h5IHlvdSBkaWQgaXQgdGhpcyB3YXkuLi4NCj4gKChtb3N0KSB1c2VycyBv
ZiBpc192M3UoKSBhcmUgbm90IGNvbnZlcnRlZCB0byBmZWF0dXJlIGZsYWdzICh5ZXQpIDstKQ0K
DQpZZXAsIHRoYXQgaXMgY29ycmVjdC4gQ2hpcF9pZCgpIGlzIGJlaW5nIHJlbW92ZWQgaW4gc3Vi
c2VxdWVudCBwYXRjaGVzDQpPdGhlcndpc2UgSSBuZWVkIHRvIGNyZWF0ZSBzZXBhcmF0ZSBwYXRj
aCBmb3IgdGhpcyBjaGFuZ2UgYWxvbmUuDQoNCkNoZWVycywNCkJpanUNCg0KPiANCj4gUmV2aWV3
ZWQtYnk6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+DQo+IA0K
PiBHcntvZXRqZSxlZXRpbmd9cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIEdlZXJ0
DQo+IA0KPiAtLQ0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4
IGJleW9uZCBpYTMyIC0tDQo+IGdlZXJ0QGxpbnV4LW02OGsub3JnDQo+IA0KPiBJbiBwZXJzb25h
bCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhDQo+
IGhhY2tlci4gQnV0IHdoZW4gSSdtIHRhbGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAi
cHJvZ3JhbW1lciIgb3INCj4gc29tZXRoaW5nIGxpa2UgdGhhdC4NCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2YWxkcw0K
