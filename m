Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FF860B69A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiJXTFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiJXTEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:04:43 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2106.outbound.protection.outlook.com [40.107.114.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA461C90F;
        Mon, 24 Oct 2022 10:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbNEvt6f42SfxUXNuFzgEgDSfh40mek0+5ADYHSgvuUZeXmL/rst7j15PgnLK0Hkhd12aqWUa8/dRYWysJq7z0q1AiEjKZgs/b91CWcN/Fr/jk0Ilkc/lf9uNNCGmZx0S73NfzcfqjFBFmBWvue3UB9G7ohqrzA+LUhsg+nSghBiCnnMdfL6Nyh32F/GaGi8TctbleMKttW7bqbxoR8n6wDfmVbZquHHnbnz8tpC5asWhT7uCmhQdCKa0yj/nr/2Gx6r167+/ZyIm+8DV8uNyjdtETU/wYeNrJEKVGbWwqJ8mzT4bYrOEy7Yf5zk3kl8uV1wt8bfb9bX+qwdqaC0DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI+EeBxDtKgB872BAfk+RWWUHypER8hbbVPpBRpDrfI=;
 b=Vy8xhVX5TY59nD6zPpa2T303UdEn5mNWp+qSjmmobw9oOlCE2wWqy8zbPUrco0WUMpeZHNUmXU+KWH+u96nZf3qtGQOJ6Cdn9EmysiLhj3dr5uYZuFwf98Z/hxowDKP4571xoOAxklfxyZbW8BZdvvIkEwgCeOlRTHej7gJY+ZIbRyH6Gv9uZre+0hQ3eVqJBNnC7zogx91Od6Iwy+y/7vYJRdepw47R3IzK2VEWqWt2e1iMEeU6GBUnqdNP77yD8/qioGb6mBBsacHbDW8KzeYUC9/Yn3zbR/eB7kB8ezxRqvf0doV6kJ1kYIb6i41T4EYILEZn8MFcV5VgCZWoWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI+EeBxDtKgB872BAfk+RWWUHypER8hbbVPpBRpDrfI=;
 b=S4DJUQs+V1pmcH2aD/rrZpaEPCMwKfKS3NdBxHYA0/pu6xNqVxaRtxn+T4mklaMyCcwx+QgrErVswjU1hdJVo7CdCJonVM6n2/TvamCXy+5VUzaaBg2FRikx8cSHT8zwJG1/alrs7Hh4/ZRgkWHzTL/AeP4XSKGLme8FXuysTnc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB8710.jpnprd01.prod.outlook.com (2603:1096:400:16a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Mon, 24 Oct
 2022 17:25:40 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Mon, 24 Oct 2022
 17:25:40 +0000
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
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 4/6] can: rcar_canfd: Add clk_postdiv to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH 4/6] can: rcar_canfd: Add clk_postdiv to struct
 rcar_canfd_hw_info
Thread-Index: AQHY5gXeHw2UScDZDU2B4Bi98tqtVa4dox2AgAArrcA=
Date:   Mon, 24 Oct 2022 17:25:39 +0000
Message-ID: <OS0PR01MB59220606B18F59EAEA7BDECA862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
 <20221022104357.1276740-5-biju.das.jz@bp.renesas.com>
 <CAMuHMdV-uG5Q6OQd+=HHTzOUuw_T4_2i6cNh5fcZCBWACcoptg@mail.gmail.com>
In-Reply-To: <CAMuHMdV-uG5Q6OQd+=HHTzOUuw_T4_2i6cNh5fcZCBWACcoptg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB8710:EE_
x-ms-office365-filtering-correlation-id: 48789b8b-1ad7-4a1b-87cb-08dab5e4c5b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7khk+x0bqfWIsUb6TWUKs7XyxNNmx2TSuHpNz8AKFsUzlLsmFXfcPSoJvFjjSaKal+VVbEpBc9T7lS6tbKUZ8+98hxEuQqJgd9NHwilI5ay2QnQ6kgzwHNbRWiib9+OIOUjpv+ZUz5+T9uHiQ90huc/e33tylJw2F5d5cdIQ+0ILyXSa/drfo8Dwn4KQuXuXOgvZTOmHraWt7AR0cQ82z+45HqaOqcZVj4Blm+Vu/YGcXhGbXwKC/dtKKxlw9UEV2YG5V1Uh5qffgOfOeQtbr6yg0GvF2FoNx0cR3OS8vz4YOufTzc52MptEHvLJD0HRw4eN60mLLyvkNL1rz+C3wIooSvVgG8FqF1GCrp5DYw3UQaiXzIxT1M9EVNAxbyDeTLyDaUcA+fUs98c0Idk04lqhwDB6NCiulJaajOnoMVbiLz6Fw5p+s7T0QUQTwXZAnTe2aS8WmcQBv7tT/2jwZKf5bK79wPuTchOuZUmgk5fy+Z5p0ZkeGptk1FuxG4smogZ6BW3iqm2b44iOf4dKTbcsYu/rKnD1OffhGgN0FLjFV/zwLlsXKzFkWY3y7i176FCfPXCAUcM2Y9H2JPl5/Zl3iYULaovO73hiQQmFqK9mksxbJZfh6uj8o4xCjnPfRMuuLfoap+j6p3Dr7NGIIlAlbTCPgnd6w3zEjWVnW3NUXeBxnfZUQkQhO592aAX8jlRnmg9uTrQTwEYpOWJEhY8goc+F/h/TyhEF4caUATa7pQgdzQj/T51YnmPC3Na0vBMvf9+ghvyPjczZxTY6jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199015)(8676002)(71200400001)(122000001)(38100700002)(6916009)(54906003)(4326008)(55016003)(33656002)(52536014)(41300700001)(8936002)(66476007)(66556008)(66446008)(5660300002)(76116006)(66946007)(7416002)(7696005)(64756008)(186003)(9686003)(26005)(53546011)(6506007)(83380400001)(38070700005)(86362001)(478600001)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aERNZEF3WUJ6SVVUK1lJenF1WkJ6dE9BdUVtSGgrZ0s1UDBwVU5tYUU2NUZO?=
 =?utf-8?B?NEFMb2I4ZzB1aWFMTVFOT3p1QVhDRXpYQk1IMWliNHk0dmEvUjBIbjZkRjRS?=
 =?utf-8?B?K2NRT3dxTjdhVUN1cCtPK0QvTXl0aHpZM09pMHh2VWIzT2hxNEhQK0N5ZUxv?=
 =?utf-8?B?d0paVk5RSlNlZEd3Kzlvays1WVdjUWNQK3FUQjU4ZllnR245MjIxY2pDWmow?=
 =?utf-8?B?dm80QlVSZlBNZU9ONHBzb0ZXTk9md1RJallTaEV4aXVZcTdzbGNkVWhRdlBp?=
 =?utf-8?B?V1BwL0pTTkhJTWIxSEdBbjlNMnhPSFlKSmwwa1pXZDM5cGxYQkpwcDdZR1B3?=
 =?utf-8?B?VHNjaUlvaHVrUDFvWTdub3FyU3pVT1dtUDYwWEgwc1hEQXZIekhTWWNEeDJO?=
 =?utf-8?B?Z1J0blo1aGtvNkY5ZWt0ZSttN0lGV1dOKzFvd1JZQXhtUmlBNVBhZ2dpTFJr?=
 =?utf-8?B?MnEvS05JRUVsWjl0TjlBOHBtSDdJQlFkb0ZpT3d5aFBjeW1zUmJLUGdDRUJF?=
 =?utf-8?B?L1lqUjRXT1AyRXpUcWlpMWdQaFQwaWRDdDRTQW8wRVFqaEtFbVFrVnlCK09j?=
 =?utf-8?B?cjIwVFpwUjU5S3NRb3ZuakJrZXpCU29jUUNVNjZPYS9qS01abGtZQ2xTV2xt?=
 =?utf-8?B?RXR5TXQzU3hwc2p6K05pa2pFNlNzVGNmaklnb2Z0UEZhVVFhVDNMaWlzWTNr?=
 =?utf-8?B?L2g3alAxb1BDdzdaUjNJV1lEZVB1aWtyVDdJNmpqRGlBVDhvdTh2SVRjbGkr?=
 =?utf-8?B?bWpuQWtRRE44QktmVG8reXMvc2Vnb1pxZ3NVem5FeHk2Z0pGb0JBUUJoZEFE?=
 =?utf-8?B?SjRTOFFrS1hwUnR0OXduclYwRFd1K3RkT01hc2dUVmRVcFRCRW5tVG9Ga0VJ?=
 =?utf-8?B?Q25zVENySDZnOGdQaTgraTFmSHRnV0EvREYyS1ltT2Y3NFV6dk5CekplbldH?=
 =?utf-8?B?Z0ZNUGtVV0pRcDFFT1ByMy9JTldLTEhCSk5HTk5rSUJ6OU9VdEdUeFdXM3ht?=
 =?utf-8?B?WkphR2V0d3hSbWZ1QTNvK1BnZ3d0WDZuN3MwdFhhODd4RS9hdEkrTWY5cm1o?=
 =?utf-8?B?eSs2U2E5TUNzM1lqSzBtRWEydlNYTXJNeVN3OVI5RXRlTHlydkZ3MXQva3lr?=
 =?utf-8?B?N3RKTU1qTzdRUmVhcWo0K0dCWmxmL21SbTZZZVk0Tm5aRzF3dUJhZys2TGFN?=
 =?utf-8?B?ZXlsTlBlZ0JMSHZJNm5iK2Y0NmJRa3JKNGswQUNsSUhPYzVkb1dWSWc5MjU3?=
 =?utf-8?B?MkNvejR6TU1SM2tKa3pWQ216QlRGM0Mzd24zZmYrR0IyY2ZwRGwwclh5anRM?=
 =?utf-8?B?Q3JZeExGWHg4bnVKbXRwV2FDalNMYTMxN0FZdGQxZFhOekU4MnpBN2lja3M2?=
 =?utf-8?B?WnZQb2FVbkxZV3NQV1ZGL092a0RtcjdxYW9zVzA4V01YMXFXTVpTZ25PSGtM?=
 =?utf-8?B?MnVYVEVmbkQ1Ry9sMnZIUWVvc2hCRXV4NlEzTUliS25SV0l0ZmVaTkZ2YXg5?=
 =?utf-8?B?VjdMMCtreEJTSkloMXlFYmtmaXAzQTJEY3ZySkltSGM2OEt3blFSaVFzblFp?=
 =?utf-8?B?Z05yTzh0N2hrRlBVZE56cGd6eHMzMVozM2xNTFBZa2RhMkQwMFBIN0lJUWkx?=
 =?utf-8?B?aTBrc2lVaFNGQXFqdzErVWovODlHanFZUExNejZoZ1l2RHJ6djBHbGxLZnFy?=
 =?utf-8?B?V2lUYVA4ZEpnYTdkc2paank3SVVQbVlqQ3RUMUE2SkE4TUIxdnRGZlRoVkVB?=
 =?utf-8?B?N3dGWkoyc1RtK2pRRGFBRnIzU1I1SmdUR0FnejlCSzFGYTd2UTlqeDFPOStE?=
 =?utf-8?B?b05EdlZYeDM5S1BReDN4em9kTVFsTEpwUHJRNlVnQWM5ZE1wWFN3UnlLK2wy?=
 =?utf-8?B?NW1tR0ZzZ29EQW8rUW9HbG5FbVRVdVhHaktJeGdYU1crVWNabVhlQmZ4MGFV?=
 =?utf-8?B?MGZuTTBxM3NZVENJNVJIRHlLcXJzVndFSW1GUWRLZE8rWUk1RnVHVGQwZjE5?=
 =?utf-8?B?QWdCNnFhRitiTXNqay8vNjFvdXhXWGQ2VHVWbUFYWGpVb254Tit0MTZVcHlk?=
 =?utf-8?B?NEdqV0JPYU5JOGtnZEx3Vk9maEFUQXRLRjJ5QTdDNHdSb20xK2VNMEcwNU9Z?=
 =?utf-8?B?RE5YdGh5bzN4VHMxQlYwOCtNKzMzbmFHYldQVUpWQUxFTFJQZWY3SExEdDZF?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48789b8b-1ad7-4a1b-87cb-08dab5e4c5b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 17:25:39.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +b7jldiUu7bPmBZbyf1OXTOiAIM6xbEJiK/QM+mhd9SdNP8Y9qNA/tR5NbT5zGotioRj+I7dB+EMZo7BDcbP+KOKxXHspAtNIXKxtWBqET8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8710
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggNC82XSBjYW46IHJjYXJfY2FuZmQ6IEFkZCBjbGtfcG9zdGRpdiB0byBzdHJ1Y3QNCj4g
cmNhcl9jYW5mZF9od19pbmZvDQo+IA0KPiBIaSBCaWp1LA0KPiANCj4gT24gU2F0LCBPY3QgMjIs
IDIwMjIgYXQgMTowMyBQTSBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+
IHdyb3RlOg0KPiA+IFItQ2FyIGhhcyBhIGNsb2NrIGRpdmlkZXIgZm9yIENBTiBGRCBjbG9jayB3
aXRoaW4gdGhlIElQLCB3aGVyZWFzIGl0DQo+ID4gaXMgbm90IGF2YWlsYWJsZSBvbiBSWi9HMkwu
DQo+ID4NCj4gPiBBZGQgY2xrX3Bvc3RkaXYgdG8gc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbyB0
byB0YWtlIGNhcmUgb2YgdGhpcw0KPiA+IGRpZmZlcmVuY2UuDQo+ID4NCj4gPiBTaWduZWQtb2Zm
LWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+IA0KPiBUaGFua3Mg
Zm9yIHlvdXIgcGF0Y2ghDQo+IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJf
Y2FuZmQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9yY2FyL3JjYXJfY2FuZmQuYw0KPiA+
IEBAIC01MjgsNiArNTI4LDcgQEAgc3RydWN0IHJjYXJfY2FuZmRfaHdfaW5mbyB7DQo+ID4gICAg
ICAgICB1MzIgbWF4X2NoYW5uZWxzOw0KPiA+ICAgICAgICAgLyogaGFyZHdhcmUgZmVhdHVyZXMg
Ki8NCj4gPiAgICAgICAgIHVuc2lnbmVkIG11bHRpX2dsb2JhbF9pcnFzOjE7ICAgLyogSGFzIG11
bHRpcGxlIGdsb2JhbCBpcnFzDQo+ICovDQo+ID4gKyAgICAgICB1bnNpZ25lZCBjbGtfcG9zdGRp
djoxOyAgICAgICAgIC8qIEhhcyBDQU4gY2xrIHBvc3QgZGl2aWRlcg0KPiAqLw0KPiANCj4gQXMg
dGhpcyBpcyBub3QgdGhlIGFjdHVhbCBwb3N0IGRpdmlkZXIsIEkgdGhpbmsgdGhpcyBzaG91bGQg
YmUgY2FsbGVkDQo+IGhhc19jbGtfcG9zdGRpdi4gQnV0IHNlZSBiZWxvdy4uLg0KDQpPSyB3aWxs
IHVzZSBkcml2ZXIgZGF0YSAiIHBvc3RkaXYiIGluc3RlYWQgYXMgbWVudGlvbmVkIGJlbG93Lg0K
DQo+IA0KPiA+ICB9Ow0KPiA+DQo+ID4gIC8qIENoYW5uZWwgcHJpdiBkYXRhICovDQo+IA0KPiA+
IEBAIC0xOTQ4LDcgKzE5NTEsNyBAQCBzdGF0aWMgaW50IHJjYXJfY2FuZmRfcHJvYmUoc3RydWN0
DQo+IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPiAgICAgICAgIH0NCj4gPiAgICAgICAgIGZj
YW5fZnJlcSA9IGNsa19nZXRfcmF0ZShncHJpdi0+Y2FuX2Nsayk7DQo+ID4NCj4gPiAtICAgICAg
IGlmIChncHJpdi0+ZmNhbiA9PSBSQ0FORkRfQ0FORkRDTEsgJiYgaW5mby0+Y2hpcF9pZCAhPQ0K
PiBSRU5FU0FTX1JaRzJMKQ0KPiA+ICsgICAgICAgaWYgKGdwcml2LT5mY2FuID09IFJDQU5GRF9D
QU5GRENMSyAmJiBpbmZvLT5jbGtfcG9zdGRpdikNCj4gPiAgICAgICAgICAgICAgICAgLyogQ0FO
RkQgY2xvY2sgaXMgZnVydGhlciBkaXZpZGVkIGJ5ICgxLzIpIHdpdGhpbg0KPiB0aGUgSVAgKi8N
Cj4gPiAgICAgICAgICAgICAgICAgZmNhbl9mcmVxIC89IDI7DQo+IA0KPiBJZiBpbmZvLT5jbGtf
cG9zdGRpdiB3b3VsZCBiZSB0aGUgYWN0dWFsIHBvc3QgZGl2aWRlciwgeW91IGNvdWxkDQo+IHNp
bXBsaWZ5IHRvOg0KPiANCj4gICAgIGlmIChncHJpdi0+ZmNhbiA9PSBSQ0FORkRfQ0FORkRDTEsp
DQo+ICAgICAgICAgICAgIGZjYW5fZnJlcSAvPSBpbmZvLT5wb3N0ZGl2Ow0KDQoNCkFncmVlZC4N
Cg0KVGhhbmtzIGFuZCByZWdhcmRzLA0KQmlqdQ0KDQo=
