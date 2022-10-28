Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C3B610F09
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJ1KxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJ1KxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:53:06 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2125.outbound.protection.outlook.com [40.107.113.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3104396395;
        Fri, 28 Oct 2022 03:53:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMsykyLz7kNIDjyxviBJ9+Of3I7bsMzTdnsMWABxa7OB2w/kOuT8d75HGLZeDIJDhdgBmpm1L7fhRmCDKgsKYnMU76jwP0LFCbl3+/UsypaXtBP0BS4RPj4XgjjIyS+wfBfkFDTW6n77AXE5wuhrdWG1Vb6PAb0pTVb3ys2fMFQ6aGvfk8E1HTBnzaxHsZ2J1+xwGvFTC+hEt8Khj+c0hbl/Ovk+V3oQYytmk3l4qrmJEw0VRXHLbd+SNOPwF4qRjTwCNEKjE1Yn0Wtl8G1zgug4w3+p45a0h8boLgbaANNxqA5sfeTpvs+yK2N680XECE/TO44aaspzN0sqjCeSQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDiENMNaTDevPy+yAo/eCzOaoUNH/k4bcTXT9+qBU6k=;
 b=DUWlPA3c5ROdTJ4K0Kqjsy2RaXgtX9ZgSyM5jR26Ob9vS4Kwr9cbkyfhKBlsUaYkBI9zMgloQ6O9D07a4Qqos2tR9ghmtcC5CXiNlUddmn3f5+9JyWvgfoCTjd2xt+C7tkxkRBhrDr2SzTwl5CXC3tMz4uDLmOWXspfY0cbCMMz5TZTwFTwAPb5RY+KFEAiaCHLIf8pbKYp0Kke62ovncq5ERUwWlGPI1VprWEYAmAnOvBLcenghmsqoQ4daVFvssQ/qHc9J/GCjGH3tYBB+PX7Fu8wz4ah2rAog1CGz5TxoY/ZTHwqjnjEDqnW6OHsjYS/XVT9B+8W7FHRPjO0jRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDiENMNaTDevPy+yAo/eCzOaoUNH/k4bcTXT9+qBU6k=;
 b=vPjqAicg3ktVie+UPXqVEuTYZyTowgr61Z68zC12tewsBGatdeNw/FajWIcDvleGBEamJpdgbrEy8M3RMNSzqGEs1NOoLx+z9xmSDLCt58upor6YXezG86QgIyB3ReMcIA7DE6801HI/R7GGmFOrWJCWzJcvyJWyC5xA6feNuug=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6037.jpnprd01.prod.outlook.com (2603:1096:604:d1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 10:53:00 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 10:53:00 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
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
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Thread-Index: AQHY6d1KzPu6u6sBIkGlqmouWtJppq4jl88AgAADhQCAAAeb4A==
Date:   Fri, 28 Oct 2022 10:53:00 +0000
Message-ID: <OS0PR01MB5922A029B93F82F47AE1DD7C86329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
 <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
 <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
 <20221028102458.6qcuojc5xk46jbuo@pengutronix.de>
In-Reply-To: <20221028102458.6qcuojc5xk46jbuo@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB6037:EE_
x-ms-office365-filtering-correlation-id: 4c4e461f-1a01-463e-095f-08dab8d294fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2RoDcl0hfwtVmeoQZi5q+jSXk3D7LJ+tM6zCJgViF0tQmbRqf+itOSAztoxeuH5z70usE9JObniLuQ2YK6adiYIZvMVD1Jq0zwA4i8kBUlMi2My/3tHMFZy+WYbBfWgsmeR+5CPNmVlp6MHXPBP2kTwRfTjsdGxP+08JoBJwgfxQHL1IbFmNp9rYquKwlDmsOz24qMxV7oms7yAnwM5gKgcMkyQrwGZt9w8iyez4hoWARHwO5RceyyzkY8kiKiMmubwI0kGch01S5/H+oS/rpyiw4KgZF15eDWYB+MuGM65S+ABn0e4SpHZSg2TGmCsPT/JC+Tc3QpOo8StoF8cGVAD+wdJZKdO1Qvp6/NUaN6kHKX96sh2ZirdpYiw7VmMZB3NoJyKqUm/W6jLL4WV9EV95ejK63IGnJCgaFE0VUlnuKtysuB5N3ndBA71ryEyovGZ+B9WDZDsadFFJhEc0fVzKSHRasK/Oa2oTvq/r3YwIavL9KGkROJd3Bbc0ni/4W+UZwNupzdjiWM9+jA470hNaiDYAhZqxj4gFtLKqoRVjPM+KfKUNttj6VfrkThBqn07+rdMVCtj6lCxvzKNbKHgcMafoab3AwlM5gyBEQmENOCsU0s3fqVG5E/9diOS2d/8yo13LUenz7wNo0eVxJiBrDMPf+jV8wwBvzdgTQudP9zrqog/Yx3RtpZp6AJBKiBTa4fXYPtxfaT+yLmhyR13pKLyWRwHTiQ8/gLfCzZ8sZZOlVCXDj0Sy/lIFKmzQZfVkXAyO2wk0FOBqUt9IKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199015)(38100700002)(122000001)(2906002)(86362001)(33656002)(38070700005)(8676002)(4326008)(6506007)(7696005)(64756008)(66446008)(66476007)(66556008)(54906003)(53546011)(26005)(9686003)(110136005)(316002)(66946007)(76116006)(478600001)(71200400001)(5660300002)(7416002)(8936002)(55016003)(52536014)(186003)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHhjdjh5WVRqY0JIMjRGZ3FSQStrU1o2c3dJeXBPRVQ2M1NndzZ4am5TdkUw?=
 =?utf-8?B?dHIyVzNYQ2xrM0tremFlcnpwQm4vYjQySks0SXZjM0xGVWtzMnlHeE9YMzBD?=
 =?utf-8?B?YVBkeXFFWDVWajFSTXdXNitHY1ZSY0tvY2J2OHBmWDZ1MXh2ellzc0hFc0JJ?=
 =?utf-8?B?V1draitBRUt0NXpHZUY0eFozckF1clBXUUM5RGF6MFF1VDJVMkFISzZBaFRJ?=
 =?utf-8?B?YkJMM2lCWk52N2RucHR2SHZzbHNQbFpJaysrU2ZMZ0FLTytTbjlmWkU5bU1x?=
 =?utf-8?B?ZGptNWhVZWRDVDNhYUNZTy9IdnJWeDB2VXk4RlVIL1JnWi9Bc2sxMDAxN01X?=
 =?utf-8?B?UUVvMytrNDZiUjA2em9tZUNGd0o0QnZoT2xkN3cxVWdNaHFhVlFwOGRUWWNz?=
 =?utf-8?B?d2VlQlZaYVVuSTMzZnJkZ3ZNdEpTUTdhWFZnV0ZvTTdpRFNUWWtiT29BNjlW?=
 =?utf-8?B?SVowa0tlUlRhWEcvOC83TUFlN2E4dXVwMHVzcEljVEJPdjhmUktDMEg2Nzhw?=
 =?utf-8?B?VHl4L2RZY3hYS01PYi9WZ1B2d2FDeldUa0g5WHh3TVdhRUJaWnZmSXoyd0Q1?=
 =?utf-8?B?TXVjQmZtTU15RHl3WEUraXV1U3NPc1o0TUZITmcrbkphQm1jV0loUWZtRWpU?=
 =?utf-8?B?MGdDN2FPN3VQTUl3bFg5NzdacmhoYzFJbzdQeUhiRHVTMW9aazVkNEtFOEtM?=
 =?utf-8?B?QXdEWWFNSk5PM0VpK2NQVElRZlQ1cm9SMkpnV1NVZUFTNWwvSkZSUHVpN0JH?=
 =?utf-8?B?dnB5SDRqZ3RYYm5RaGZKS2JMWjRnMk42ZHorODZyKzdGNVZrbEhQaUpVSU82?=
 =?utf-8?B?L3dqNjNzOHhnNER6cVRZNUw2TXFtZ3M5V1N2dURqV2Uvelk2MGIrUXdZTGwv?=
 =?utf-8?B?YWhwUjVFb00yQXhWMkVXTVRNQVVDOE41bit1SjlmMlhvRHpnV3FhRDBVUEpF?=
 =?utf-8?B?NjdtWTNyVG1XbkpwQ1F3N3ZJYzc0MnN0ZThZZ2szdUpuSGQ1UnlxTy9JOXli?=
 =?utf-8?B?cGhyQkxjSW5XWStPSDFobFBVVVM1b2NXeC9EOE55bktHOFNxUWZDelgxRm04?=
 =?utf-8?B?aFJZQm1SRk93T09Ib2xjTHFBdWlLSWFiTWF1OFFCN2lVaWlEWVRIcmkvcW1C?=
 =?utf-8?B?c1ZYdlhjWktiTlFTVFQ2UXpQWWUzT0ljU2RTV0s4TFhPR1paaXVac0o0QWxV?=
 =?utf-8?B?eVR2dmkrZFk2S2JyM1RmWEYzaWkrU05PQ0I2N3ZZaVllbFlQeENHbWZtNWk0?=
 =?utf-8?B?U0ExdUlYczUwdTB4OUxkWFQ3bGVOWHBCOUlLQU5kcUpqQ3lPN25qSXU2b0dm?=
 =?utf-8?B?WGZUT1pWelNzTzZmNTNMR3hoclNXSW02Y2daWFdGWTEyK0hqb0tVWnBCRDQx?=
 =?utf-8?B?c2srSGNXTGVSeVo0bUYrVEZMV0NNVms3YnY3eURRL2p6MGxab2ZYMUd1VGRL?=
 =?utf-8?B?aDVHU1NpM2FoYVBLYklPbFNITnBIcS9sQ0MwU2VDanpJK3E2SE5FNEt3aGh4?=
 =?utf-8?B?ZWpRdkZGTUFHR044UDVXdHk4czlHaFZQT1laMWlFMFBEajBSOTY1WHVqLzZx?=
 =?utf-8?B?U3gycHNKdklRY0tRUmRiV0tpVEYrRGhkam5va0RRL0ZQdVVUUkNWN3FvMXN2?=
 =?utf-8?B?eFFUTTlxRm01c0pmSUYzU0JSZGhIdzNaUm9hMHZtejR4R1krL2MrWUtKNlBS?=
 =?utf-8?B?WWdKais4My92WTNyVjRjNFVlaC90dnBsTENQcEljZFNkTDlvd0FETWh5WUp1?=
 =?utf-8?B?VEVEWXRMeGN0T0RtdUlWUit5OFBtS3A2N0JvUGZ3TjdqMkJ2STN0VnNDZ3FB?=
 =?utf-8?B?V1hVdzN3V2RTNVZETG80dWFnTzRZd01rK1NFYTVTbG5KUkYzL2FHYlFRSkNK?=
 =?utf-8?B?aUh6TVhlZHBjcWJaRE85YVVOOEFaemtrSmFkaUVnK1VLaEZ0UWhjL0JaUTN3?=
 =?utf-8?B?NmJpaHlrc2RPbTJ5OUl5QzZpenhNdytqUi9SZGZXRlpneEtFdUNoSVlvdzI0?=
 =?utf-8?B?TGFkWVBXQXpBdENyL2RzM0tvTi9hWUpRL0pDdXhSa1ZuZkVHTEtrZHBqN3My?=
 =?utf-8?B?Q0tDTEdnNE1vdGlZQVJ1SitIVzJEZkNpZFlpdHVKcWh6UmlEcG82YTJ4WVJO?=
 =?utf-8?B?bG9velBvVW0xZEJnQXJLa1UxU1JqVU1jWXg2VDVWRHQyTllxSTIzdS84SmNH?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4e461f-1a01-463e-095f-08dab8d294fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 10:53:00.8000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xb5uZXPzMk0UokjUF1vr6VevWhlww7RezrVW9Dwxj5DrnH0ryIEDsEWUJwWidXYh8j2NOL6eaB83Y5Hi8Jr22zYRzVKCGJOw8NLpDgTP9v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MyA2LzZdIGNhbjogcmNhcl9jYW5mZDogQWRkIGhhc19nZXJmbF9lZWYgdG8NCj4gc3Ry
dWN0IHJjYXJfY2FuZmRfaHdfaW5mbw0KPiANCj4gT24gMjguMTAuMjAyMiAxMjoxMjoyMiwgR2Vl
cnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KPiA+IEhpIEJpanUsDQo+ID4NCj4gPiBPbiBUaHUsIE9j
dCAyNywgMjAyMiBhdCAxMDoyMiBBTSBCaWp1IERhcw0KPiA8YmlqdS5kYXMuanpAYnAucmVuZXNh
cy5jb20+IHdyb3RlOg0KPiA+ID4gUi1DYXIgaGFzIEVDQyBlcnJvciBmbGFncyBpbiBnbG9iYWwg
ZXJyb3IgaW50ZXJydXB0cyB3aGVyZWFzIGl0IGlzDQo+ID4gPiBub3QgYXZhaWxhYmxlIG9uIFJa
L0cyTC4NCj4gPiA+DQo+ID4gPiBBZGQgaGFzX2dlcmZsX2VlZiB0byBzdHJ1Y3QgcmNhcl9jYW5m
ZF9od19pbmZvIHNvIHRoYXQgcmNhcl9jYW5mZF8NCj4gPiA+IGdsb2JhbF9lcnJvcigpIHdpbGwg
cHJvY2VzcyBFQ0MgZXJyb3JzIG9ubHkgZm9yIFItQ2FyLg0KPiA+ID4NCj4gPiA+IHdoaWxzdCwg
dGhpcyBwYXRjaCBmaXhlcyB0aGUgYmVsb3cgY2hlY2twYXRjaCB3YXJuaW5ncw0KPiA+ID4gICBD
SEVDSzogVW5uZWNlc3NhcnkgcGFyZW50aGVzZXMgYXJvdW5kICdjaCA9PSAwJw0KPiA+ID4gICBD
SEVDSzogVW5uZWNlc3NhcnkgcGFyZW50aGVzZXMgYXJvdW5kICdjaCA9PSAxJw0KPiA+ID4NCj4g
PiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4N
Cj4gPg0KPiA+IFJldmlld2VkLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNA
Z2xpZGVyLmJlPg0KPiA+DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2Nh
bmZkLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+
ID4gQEAgLTk1NSwxMyArOTU4LDE1IEBAIHN0YXRpYyB2b2lkIHJjYXJfY2FuZmRfZ2xvYmFsX2Vy
cm9yKHN0cnVjdA0KPiBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+ID4gICAgICAgICB1MzIgcmlkeCA9
IGNoICsgUkNBTkZEX1JGRklGT19JRFg7DQo+ID4gPg0KPiA+ID4gICAgICAgICBnZXJmbCA9IHJj
YXJfY2FuZmRfcmVhZChwcml2LT5iYXNlLCBSQ0FORkRfR0VSRkwpOw0KPiA+ID4gLSAgICAgICBp
ZiAoKGdlcmZsICYgUkNBTkZEX0dFUkZMX0VFRjApICYmIChjaCA9PSAwKSkgew0KPiA+ID4gLSAg
ICAgICAgICAgICAgIG5ldGRldl9kYmcobmRldiwgIkNoMDogRUNDIEVycm9yIGZsYWdcbiIpOw0K
PiA+ID4gLSAgICAgICAgICAgICAgIHN0YXRzLT50eF9kcm9wcGVkKys7DQo+ID4gPiAtICAgICAg
IH0NCj4gPiA+IC0gICAgICAgaWYgKChnZXJmbCAmIFJDQU5GRF9HRVJGTF9FRUYxKSAmJiAoY2gg
PT0gMSkpIHsNCj4gPiA+IC0gICAgICAgICAgICAgICBuZXRkZXZfZGJnKG5kZXYsICJDaDE6IEVD
QyBFcnJvciBmbGFnXG4iKTsNCj4gPiA+IC0gICAgICAgICAgICAgICBzdGF0cy0+dHhfZHJvcHBl
ZCsrOw0KPiA+ID4gKyAgICAgICBpZiAoZ3ByaXYtPmluZm8tPmhhc19nZXJmbF9lZWYpIHsNCj4g
PiA+ICsgICAgICAgICAgICAgICBpZiAoKGdlcmZsICYgUkNBTkZEX0dFUkZMX0VFRjApICYmIGNo
ID09IDApIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG5ldGRldl9kYmcobmRldiwg
IkNoMDogRUNDIEVycm9yIGZsYWdcbiIpOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
c3RhdHMtPnR4X2Ryb3BwZWQrKzsNCj4gPiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gPiArICAg
ICAgICAgICAgICAgaWYgKChnZXJmbCAmIFJDQU5GRF9HRVJGTF9FRUYxKSAmJiBjaCA9PSAxKSB7
DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBuZXRkZXZfZGJnKG5kZXYsICJDaDE6IEVD
QyBFcnJvciBmbGFnXG4iKTsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0YXRzLT50
eF9kcm9wcGVkKys7DQo+ID4gPiArICAgICAgICAgICAgICAgfQ0KPiA+DQo+ID4gQlRXLCB0aGlz
IGZhaWxzIHRvIGNoZWNrIHRoZSBFQ0MgZXJyb3IgZmxhZ3MgZm9yIGNoYW5uZWxzIDItNyBvbiBS
LQ0KPiBDYXINCj4gPiBWM1UsIHdoaWNoIGlzIGEgcHJlLWV4aXN0aW5nIHByb2JsZW0uICBBcyB0
aGF0IGlzIGEgYnVnLCBJIGhhdmUgc2VudA0KPiBhDQo+ID4gZml4WzFdLCB3aGljaCB1bmZvcnR1
bmF0ZWx5IGNvbmZsaWN0cyB3aXRoIHlvdXIgcGF0Y2guIFNvcnJ5IGZvcg0KPiB0aGF0Lg0KPiAN
Cj4gSSdsbCBhZGQgR2VlcnQncyBmaXggdG8gY2FuL21haW4gYW5kIHVwc3RyZWFtIHZpYSBuZXQv
bWFpbi4gUGxlYXNlIHJlLQ0KPiBzcGluIHRoaXMgc2VyaWVzIGFmdGVyIG5ldC9tYWluIGhhcyBi
ZWVuIG1lcmdlZCB0byBuZXQtbmV4dC9tYWluLg0KPiANCj4gVGhpcyB3YXkgd2UnbGwgYXZvaWQg
YSBtZXJnZSBjb25mbGljdC4NCg0KQWdyZWVkLg0KDQpDaGVlcnMsDQpCaWp1DQo=
