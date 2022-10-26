Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968A560DE26
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiJZJeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiJZJep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:34:45 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2118.outbound.protection.outlook.com [40.107.113.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82273402D2;
        Wed, 26 Oct 2022 02:34:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVP/8RdaxuAzQX6XzEnd14H1lqf7RictW8ftfaITI0Vkoi71kRMUWgfruFx9BOPgu/FgM6YDnEICGbDTHq6sGT5oKL/D8JygrxDOCptqyMxzalgE+Jc819f2Af4L00DICtT6t+ptGPrxbdkAkNDc16iJabsq6XgxNy/GA38C0501OICJpHFmqrxH6xmDXm/Ot48gbF5EJ+uo867dFdCNvDwwTdamFSVf4YSSMuyIhRyO8TR+e/cN+NjKhuwNosyXm+QbusroOb7MNKcZdARYcTPduS+nCy6q2rq3uFhCQYLb1Du+3aVh4MpWCVqq1Yjaw7O4aFZN7Mo4DWr7h92JDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kso/2MLO9Gqfrs40ORAGQeab0yPgn0kjfQ5RwNYir4I=;
 b=l+3lhZcaL36E761WIqRWxfaZ9Aa7if5865Blx0lmk5hav6Uqdk6eBJAianOa8p22IglWCwwE43wEaRb6Lu6dyBdSldkUynMJXRuaQUgO+G9Y+T8kLLkjoFJkMxoHItbWop461kKL9MMJai50zmZY8e0p8/bozUa1HE/PWgJsbM0p0bASKvKmL6UrfS8P6Zd2NtRoaMf3yNlCY06qsYjokt4tCBylCqtDLeHuB4pZ+bJbd8RmRlnaTBF/Pz2p1ig2OOHggGdzP8CiHre5XOx1vZI+NWvv4Jrqn+Xn6smyPDe95Jc5ditw1c+FboAjR4IKIEgMl0GvL4owSZ0k2LqKyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kso/2MLO9Gqfrs40ORAGQeab0yPgn0kjfQ5RwNYir4I=;
 b=PX0jEq0Meh2OvkvwD2+9+XdPUGL9yX0dAosJld0bpyebmlEilzx8hqKTqGubDraZTHGG1KGaTO6xnJjo8FqaiKR3wxigPGr+jmao5NG81IyoEMTBu+FDkhuNgdejYDQUDnQiSAlNdwnc9dycNxvCUACMZ/b/QHH3AzPDNHBeSUE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TY3PR01MB10582.jpnprd01.prod.outlook.com (2603:1096:400:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 09:34:41 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::fea0:9039:b0b3:968f%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 09:34:41 +0000
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
Thread-Index: AQHY6Ip2RBA8f39PzUqILbm0/1Sk/64gSiQAgAAUPdA=
Date:   Wed, 26 Oct 2022 09:34:41 +0000
Message-ID: <OS0PR01MB5922FCC50E590DFDD041F99386309@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
 <20221025155657.1426948-3-biju.das.jz@bp.renesas.com>
 <20221026073608.7h47b2axcayakfnn@pengutronix.de>
In-Reply-To: <20221026073608.7h47b2axcayakfnn@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TY3PR01MB10582:EE_
x-ms-office365-filtering-correlation-id: 7619a715-e0e8-4855-7bbe-08dab7354ede
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K8WDN7ATnppyULRUXKjlc3j766qBjCLzoRBi/OehHnEixn+0DNkNtIre5ZIHSyT6E9oSVb9Vn7sax9I66Nq3yc2Yo+i4udIkYBkCfrKNTs0lmE+FbxljuEnCNPVQ0bEtIfcO/sla0wZlOegVM8OggDe+q8ZOfiU/xqDVeWmIRSv+qQ0mcuiru/KING3eN3V1RNOtcCVreW1Af3MbIV1kzd2nFudizFe1wlju/nfgcmqaYm1O3FHLrAWkX44/6I5PwN2JKC/UvlTqbs4Qo8rWzfLUGDhQzfwgyQsYAg/avmIpfOMn0caCv1cduQj6//ardFz38G+r4eNg8yUMp4H/9GOI/TDdviYEP9++CSZJ7DGffNYAZWBNXQhlDvXEdmErXZojQeNzKFfp1o1+BXUDlRKi8YZquJ+NUXaXWQO/7mWZYHr18hApU7BYObiJz3DPd7NYN34KwEvJFTXQGSvOEH2QQ4bK6sKAg50iv/aFPy+ElnKllentx9pp40Q8Jl6lI8KiVbHL3myujZE81eRJN946djUaY3T0426RNmHDJvebrtSEUPXVAuTWggev+1QZUV66R8raf+/uHebGLS3gfKoOrcicoqGPsPwQQ5FqIHhXzfJ6OXcSylWfrfTEBoab4nqOaj7K7Y4xD2TOOzgY3CLZjGDbF4/WwkCreDX1TZXl3YWIg3rmPPNAhpYn/oyqptDXKxOnKQqfoGoFP8z1jKLCCAreO4ruoiqRegH6EniB6m9iOw1POBB1htx3p5OwiPHyglJVBpa+OSZXuODTYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(6506007)(316002)(7696005)(53546011)(2906002)(8676002)(6916009)(9686003)(52536014)(26005)(38100700002)(122000001)(4326008)(54906003)(38070700005)(7416002)(8936002)(5660300002)(66946007)(41300700001)(66476007)(64756008)(66446008)(76116006)(66556008)(186003)(478600001)(71200400001)(55016003)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVI2b0xyME0zVTErY0c0TkxuZHBnR21FWDk0MUF2WUx1OFRjZ25xNFFxa1ZN?=
 =?utf-8?B?WFlGS1lxUXEvMFpEREVVSjFaWXlSbXRJSUYxUlcwblRIUmNrNnlpcWRzejR2?=
 =?utf-8?B?cHFyWjlwUmV5K2xMYlkyYzR3M3JQV3R6bGc3QXV1b245VTFCRjFLZVp4Um9E?=
 =?utf-8?B?LzFoT0tUMUh1dkRCMTZTLzcwQXNHVzRCL1JPNDNDRVFyb0orTEx2WVZIZzFH?=
 =?utf-8?B?Q0pQUmh6b1YvcWl4UmNTbVAzTkY3eTlwaEF2bEFmV1ZpcDdGRk0zV2VsNUlp?=
 =?utf-8?B?TlJoN0tOMVU3Z2hQSWtpNjBqdCs0cXhtQXNNR29QOFcva3E0SllpTWM5cDM3?=
 =?utf-8?B?WnNsTVFPRklIckRFWk0xRGZJOWNMcG1PNWU2dWdXeHBBa0QyN0tRS0dIUlRy?=
 =?utf-8?B?T2tpYmVrWVRuZjE2ZHZ5Z2FsdGF0UWZUWkZIcEw0Q2xFdUZSTEs4Sm9QeWd5?=
 =?utf-8?B?b2NmNGJzcUVkTHRpWk1XMXo1VklIaGpJVnhSeTNKRVl5ditKQjQyRURVdVZp?=
 =?utf-8?B?OUZ6NnRhU1pERUE3eVpZdkhHMFA4NDUwbUNXWmZ2d2RaU3ZZVXRsVnpQaHFM?=
 =?utf-8?B?UjlQM1dEQmhINmdxNGNXb3BrNEM2a2Q0RUJTOTNjbHhWNm1Cc25iZXNrWWIx?=
 =?utf-8?B?elB6UG4vNkwrRTNxTmNGUUJVSTFyVzU0enI5UEkrendOL2I0NXQ3NGlJTk9j?=
 =?utf-8?B?dHZxL1NiWU9Vck1qL1ViSDRKMFA3UVRObGdsN3Jlbm5zV05TUHhRSTh1eGdw?=
 =?utf-8?B?dHBRcjRjb3kwTWpUcXJaMGJDczVpY2pOVTF1cXBUUGQ4UFk0MjZrTmxmdllP?=
 =?utf-8?B?THhUZk5BdmtnU0tNd0dXTExnNWFEY3pYZ05DdTh5L0c2OE9DaTZLTG5BUTYy?=
 =?utf-8?B?L1lLbFNpajJ2TnlRZ3IraU1qamIwRFBCYWpmTXFESThNY1k5aGlGOUpxU25T?=
 =?utf-8?B?NE5kRzd1d1ljR1pBbllieU1DYktDK3JNZEpoYzM4aG1qMkd5NldVOE1iT2g0?=
 =?utf-8?B?VUNHcTJTMnJBUVBxemhrbXpRaVExeHFXd0VvWkQrVW9pMFhJSmtHbDR1dkxt?=
 =?utf-8?B?ZXFTVEkxbTc2QWdIaXpEWUk1OEdaUE83ZzhiZ1MyQjhGSkZlK2FvdUhWZWcv?=
 =?utf-8?B?RVd6YWpsaldiaFREb0NyaHFkRUF2bmVwZTZIb0JNcWc4MTJqN2dxdHlYQmNo?=
 =?utf-8?B?UHc4VEdJQ05sYVEvUFlnTEVJVDhFQVhMdUwyZVhOcFIyLzdjNkFZRlVnd3B2?=
 =?utf-8?B?S3VZYWNkUWZudlQwaFB0ZXR4LysyQzlCTHBiMjhJN1VrMFB4UDUzUEE2VVBI?=
 =?utf-8?B?OVBoSlhqK1JraDlFQWJ5UXdIc0xOa05aWGxpWFRFNXlrVGl1RVBkNituam1I?=
 =?utf-8?B?bk84OWpnVTJKZFY4WU9LZlMzOVZ4bVNsTTAzUytWUjlNQkxRa0J3U1BUYTh3?=
 =?utf-8?B?RGduaWdYTDlPaWxOSlo3R2tJUmxFdm1MWCt6TjJ4RU9DWmxLdnJtN1poN05U?=
 =?utf-8?B?dHNkWi9oYzU2YkVPYVlmd2sxWjdLcktwb09ubG51M1p4dnA5bHdPblR5OUNB?=
 =?utf-8?B?bG9ScVE5bGNENjdsTVVJb2dJVGFxeGVDUC9QRE8zSHZjdGFidUNoNTNucStl?=
 =?utf-8?B?OU1DajN4bmI2dDRyTVpIVDVaTmdheGgzZFM3TWtnOVRCQkYvRkZCdnRtblY3?=
 =?utf-8?B?cnFMb2c3dDV2NkFPTFJVRS9CUkFndHpTcUc0blp0cHlVV281ZVRxQ1hDdVFK?=
 =?utf-8?B?TklMaUtWN2Q2ZXM1UDQwR3I0eFpnTlJUdHpQKy9lZ2hoZ0FoVXlyelR1bXNn?=
 =?utf-8?B?YkIrZUNDOUpGTzJ1aEJuUThFQ3N0SU9qTXdJNzV4bGcyNFBnU1VBcGNBcnd3?=
 =?utf-8?B?d0ozY0NQZE81SlU1Wk1NSC9GdkI1UmI3MkZPTnVmN0NGRSs2UmVRVXBDZnRB?=
 =?utf-8?B?VDNIcFUzanFmUTBPZnZWb2hSZzhKelF4SkxaelVXQnF1N2I5dzZOem9icUdt?=
 =?utf-8?B?UVIvU0VwcUtqVU8ra3g0WVRKeTArcHdwS3NHQ09wU0FVeWc1QThPMWR0SGlF?=
 =?utf-8?B?MGdoVkRsekZFdlFYbnlYT2hnUjRjU1Y0RUcycklrcU9QVHExelpqdmlsVWw5?=
 =?utf-8?B?ZFM3SzFwdTBaMnQvS2llcW1PcjlWNlQzUEROeG1SY2ZFM0pnME12akY5eGpG?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7619a715-e0e8-4855-7bbe-08dab7354ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 09:34:41.0543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v6+iQyQbiKbTwe0+Ast31iXkvZRBSWqhbSysLr3K3vJemjycUc4eXQXCiRqZavFLs7nB7bQLhkqYYFDiO+BNU7UGnFOoNcd2O03O3GqQdp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10582
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjIgMi8zXSBjYW46IHJjYXJfY2FuZmQ6IEZpeCBjaGFubmVsIHNwZWNpZmljIElSUQ0KPiBo
YW5kbGluZyBmb3IgUlovRzJMDQo+IA0KPiBPbiAyNS4xMC4yMDIyIDE2OjU2OjU2LCBCaWp1IERh
cyB3cm90ZToNCj4gPiBSWi9HMkwgaGFzIHNlcGFyYXRlIGNoYW5uZWwgc3BlY2lmaWMgSVJRcyBm
b3IgdHJhbnNtaXQgYW5kIGVycm9yDQo+ID4gaW50ZXJydXB0LiBCdXQgdGhlIElSUSBoYW5kbGVy
LCBwcm9jZXNzIHRoZSBjb2RlIGZvciBib3RoIGNoYW5uZWxzDQo+ID4gZXZlbiBpZiB0aGVyZSBp
cyBubyBpbnRlcnJ1cHQgb2NjdXJyZWQgb24gb25lIG9mIHRoZSBjaGFubmVscy4NCj4gPg0KPiA+
IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlIGJ5IHBhc3NpbmcgY2hhbm5lbCBzcGVjaWZpYyBj
b250ZXh0DQo+ID4gcGFyYW1ldGVyIGluc3RlYWQgb2YgZ2xvYmFsIG9uZSBmb3IgaXJxIHJlZ2lz
dGVyIGFuZCBvbiBpcnEgaGFuZGxlciwNCj4gPiBpdCBqdXN0IGhhbmRsZXMgdGhlIGNoYW5uZWwg
d2hpY2ggaXMgdHJpZ2dlcmVkIHRoZSBpbnRlcnJ1cHQuDQo+IA0KPiBQbGVhc2UgY2xlYW4gdXAg
c2lnbmF0dXJlcyBvZiB0aGUgSVJRIGhhbmRsZXJzIHlvdSB0b3VjaCwgaXQncyBhDQo+IGxpdHRs
ZSBtZXNzLiBDaGFuZ2U6DQo+IA0KPiB8IHJjYXJfY2FuZmRfaGFuZGxlX2NoYW5uZWxfdHgoc3Ry
dWN0IHJjYXJfY2FuZmRfZ2xvYmFsICpncHJpdiwgdTMyDQo+IGNoKQ0KPiANCj4gdG86DQo+IA0K
PiB8IHJjYXJfY2FuZmRfaGFuZGxlX2NoYW5uZWxfdHgoc3RydWN0IHJjYXJfY2FuZmRfY2hhbm5l
bCAqcHJpdikNCj4gDQo+IFNhbWUgZm9yOg0KPiANCj4gfCBzdGF0aWMgdm9pZCByY2FyX2NhbmZk
X2hhbmRsZV9jaGFubmVsX2VycihzdHJ1Y3QgcmNhcl9jYW5mZF9nbG9iYWwNCj4gfCAqZ3ByaXYs
IHUzMiBjaCkNCj4gDQoNCk9LLg0KDQo+IA0KPiANCj4gSW4gYSBzZXBhcmF0ZSBwYXRjaCwgcGxl
YXNlIGNsZWFuIHVwIHRoZXNlLCB0b286DQo+IA0KPiB8IHN0YXRpYyB2b2lkIHJjYXJfY2FuZmRf
aGFuZGxlX2dsb2JhbF9lcnIoc3RydWN0IHJjYXJfY2FuZmRfZ2xvYmFsDQo+IHwgKmdwcml2LCB1
MzIgY2gpIHN0YXRpYyB2b2lkIHJjYXJfY2FuZmRfaGFuZGxlX2dsb2JhbF9yZWNlaXZlKHN0cnVj
dA0KPiB8IHJjYXJfY2FuZmRfZ2xvYmFsICpncHJpdiwgdTMyIGNoKSBzdGF0aWMgdm9pZA0KPiB8
IHJjYXJfY2FuZmRfY2hhbm5lbF9yZW1vdmUoc3RydWN0IHJjYXJfY2FuZmRfZ2xvYmFsICpncHJp
diwgdTMyIGNoKQ0KPiANCj4gV2h5IGFyZSAyIG9mIHRoZSBhYm92ZSBmdW5jdGlvbnMgY2FsbGVk
ICJnbG9iYWwiIGFzIHRoZXkgd29yayBvbiBhDQo+IHNwZWNpZmljIGNoYW5uZWw/IFRoYXQgY2Fu
IGJlIHN0cmVhbWxpbmVkLCB0b28uDQo+IA0KDQpUaGUgZnVuY3Rpb24gbmFtZSBpcyBhcyBwZXIg
dGhlIGhhcmR3YXJlIG1hbnVhbCwgSW50ZXJydXB0IHNvdXJjZXMgYXJlIGNsYXNzaWZpZWQgaW50
byBnbG9iYWwgYW5kIGNoYW5uZWwgaW50ZXJydXB0cy4NCg0K4oCiIEdsb2JhbCBpbnRlcnJ1cHRz
ICgyIHNvdXJjZXMpOg0K4oCUIFJlY2VpdmUgRklGTyBpbnRlcnJ1cHQNCuKAlCBHbG9iYWwgZXJy
b3IgaW50ZXJydXB0DQrigKIgQ2hhbm5lbCBpbnRlcnJ1cHRzICgzIHNvdXJjZXMvY2hhbm5lbCk6
DQoNCk1heWJlIHdlIGNvdWxkIGNoYW5nZSAicmNhcl9jYW5mZF9oYW5kbGVfZ2xvYmFsX3JlY2Vp
dmUiLT4icmNhcl9jYW5mZF9oYW5kbGVfY2hhbm5lbF9yZWNlaXZlIiwgYXMgZnJvbSBkcml2ZXIg
cG9pbnQNCkl0IGlzIG5vdCBnbG9iYWwgYW55bW9yZT8/IFBsZWFzZSBsZXQgbWUga25vdy4NCg0K
Q2hlZXJzLA0KQmlqdQ0K
