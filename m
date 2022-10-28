Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33365610D6F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJ1JhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJ1Jgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:36:52 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2136.outbound.protection.outlook.com [40.107.113.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E401C8D7C;
        Fri, 28 Oct 2022 02:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfF54QVbXjaMRiUQs6YtdjEpqvkXS2CwQ5OyPhXIkj72G6cfVsc6RFnXu7ayTBXH/vyAziBokkF85BkvvmRnqIE/UDFD9U85A5GsOZVbm/wuYydn+bTfKFoHl2UA+3m4J5vlHulGjmWAdoVn8+dwBLWvJmRFIEvNp1qMLJV+lA0Kx5kdH+tAqw9BZ6f5/t6i4w7VzRJ40EdWCCcHoZ/lHnmal/cma8OWO+ewcu/hPafYgGJXDjawAhN0/25vzCbWLcLuwvo0PWpj15M+/QKEWrIkp11lKpiSbXJiPfoy8kuxjaCXwz+rHvsZwO+PfinmbVyFvABwnQ6JxwnoYXgOJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LflwFmLvz+kYcVNqN44Gbj9hA4EWFWeSYlTY/SF/1lY=;
 b=H2bwKFLvcvGvNNzpTNPICsUVkkFo2fIuS9pnpng9QuHnO503XTag93iXcfowDSFtCAEwwG9tg4KBwthFcObd9upx9L4r5XTGG91/L9oWrdJK2YbqxWtzS4LJ9DM9qgouW8IcKuNrivM5Dln/7Ap98O+9SfbRyAKdBiM8OgAlhzQtbnbHhq3CuRemRjKXeeQk9Poq4PoXEsgyaBxYxpfhDoBcIJquH402iw2Z+JRBJgfcNLAvmgsKTw+kU5fFzGmWn8q0WxBYN8f70D4tq3KbHEBBQ4vCDus5ZWir/9t3ZZgenPcpI7ctYqobLSg7x4Q60khTtqtfo59EZYAxS0m+AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LflwFmLvz+kYcVNqN44Gbj9hA4EWFWeSYlTY/SF/1lY=;
 b=qoc3ccwjfXnAlUne69iChF4j7RmeWgcmMANuktP3vkhVUPAripxgI5cgwk2D1GRlpIjc/RTu+0ekrfqwo9SUho9S5pU8edlKgXJUx7px1K3kONiEYEeel/wzbXxClPx9gSrVzYlwzWyz58ybV0bSo256Nx5Ct6T3Q6kF7EMn7Ec=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYWPR01MB10378.jpnprd01.prod.outlook.com (2603:1096:400:24a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 09:36:02 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::5b24:f581:85bd:6ce2%3]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 09:36:00 +0000
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
Subject: RE: [PATCH v3 4/6] can: rcar_canfd: Add postdiv to struct
 rcar_canfd_hw_info
Thread-Topic: [PATCH v3 4/6] can: rcar_canfd: Add postdiv to struct
 rcar_canfd_hw_info
Thread-Index: AQHY6d1CUUrP+UFfKEavjMVxmDMMBq4jjFmAgAAAuXA=
Date:   Fri, 28 Oct 2022 09:36:00 +0000
Message-ID: <OS0PR01MB592277031A4EB6184BD463F086329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
 <20221027082158.95895-5-biju.das.jz@bp.renesas.com>
 <CAMuHMdVf8R8JHM8jay2LiGGb8gLn1W0N8Q901ADcaNWv4hmAvQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVf8R8JHM8jay2LiGGb8gLn1W0N8Q901ADcaNWv4hmAvQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|TYWPR01MB10378:EE_
x-ms-office365-filtering-correlation-id: 854e681c-4a8f-42ef-6cae-08dab8c7d341
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iW4ihAB2hU54ymQPSBexBW0nQY5AwwGf3Qin5w/gMEMHTFHfmmbphx2rop8lWCrGOVE0PGp+jY/O4ENgOOzfBG9ev5VRim/pcQwfDZQeFL9hofqCO3+4wBw7rESTaFu9D+Z+MxaZTPEC9YkhyBumvFB7xoot4UGpjRJ4j0PjHpGDT1CMRRnQUZs0vxditWFMbm6OZPWMwUvTW9KUwgKQsEYT8oV+a+WctyL4vL4e4BSoU/HhM+DnsXlKRrE4c2pbzI0idYV6twkzHVEIQFKEhAPVXYNwOH+9Wes3ANmYkM6CaL9oHR/n2eWnyAPwJbxlmRDHvw+FY3BrAmvi40TWrUAF3vPesf8oCQPKUmFljZFhQV9QHfNwWZrZbsIu8uz5hyQj/E5IezN5keBu39MeN4KUVtmKhqXYniqyV6rAvGL02q7rulVHwrqpEDUwZ2OLl4F3dCJDFBmfuaoRZymUS6O1Sehohm4WJayaAKSbfyEXGarkHW3N6ESAK6Uc+akIC2b/17MVLgNc8lTgLKRuekBvLRWqxuLUMoiWj6dTDhVfWrk5LRTER/Cmp5ZU7aZvHGGH9qp8ycTqjbZU/56bGb2ACrnfv+wselVDdhIQr6U1vix6fbCUq7uSeE7u+sl8Vz465U+69JCAeL2RFeW9R+jAl9Q2JWsvC5qKX9e472mp9Pf6JfpZHr/Di93IsCP4dEW3ThHvMuC0eeFSdo43rXbtCmL3EcnDnj9G4VjwmVJQSW/D1vB3JSX1rCUBhkcGLEeByhynu8KSdZdJUXPnMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199015)(71200400001)(66446008)(64756008)(8676002)(66476007)(76116006)(66946007)(66556008)(4326008)(7416002)(54906003)(6916009)(33656002)(55016003)(316002)(5660300002)(122000001)(8936002)(41300700001)(52536014)(2906002)(38100700002)(7696005)(6506007)(186003)(26005)(53546011)(9686003)(478600001)(83380400001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWRTdXROajlYSmg1a2Uzd0FjcCtPT1VRT05RcUFFNmoxbEYxclY1cG1RRHB0?=
 =?utf-8?B?V0NndWx2Yy9hSnBJaGRzR3hMdFdaV2pucUkxZ1hOcVJYTHpMZEUzMzNhVlIr?=
 =?utf-8?B?YUp2eXBETHFHclJEa0kwaVRhYU5sTE5aaHU4Q2FOdFRNZnFzSStPd2p3S3dp?=
 =?utf-8?B?aGRQbWZQWmxoL1dhSzA4aHBPQy9KcUNtMUNjWDBRMnpuZitLM1FKT2s4ck1Q?=
 =?utf-8?B?TmVBc0paT3RIejRxUUZKK2daZTBHTno1RC8wRUdnaEYxZW1uMG14T3dldUFh?=
 =?utf-8?B?aTJKSC9EQjUzNjR0b0s2eGRBTEd3eE10Sm1tM2FTU01zaGRHbXlyRTg2TmVz?=
 =?utf-8?B?N2pDREQxcjI0Qk1qSHRnUXRqc1hqZ3ZwWHkrZG0vQ1VxMWdienRHdFFiN0tm?=
 =?utf-8?B?dWZEbU1sclFBNlFNdks3NE1haDgwTXdhdWdKT05iaVFYcURKZi8vY3VSejVq?=
 =?utf-8?B?M01WbGZMUjk1UURDakdyVXN2cklYY2s2OTVsRCtQVUlCaWhSSllMTWd6eFp0?=
 =?utf-8?B?VW5zRjBaZjdsR0JMeTNLbnZZWFc5b0xoamRBMW9JOW84bTNaaXVFTFJENkxT?=
 =?utf-8?B?bmUwTjhpdkFsOTkyVkl5VGUrL0djdGxEK2lDci9uMk9LWEJjRlBnanVwVUV0?=
 =?utf-8?B?bHByMWhWenpUSHlTZjJjMW96eGhzaWVwV3dFUDJ5ZnhiVS9xckxkeXg1NW1i?=
 =?utf-8?B?aTluZS9yaGc1aDdPRW5OazBQVlBmYWMvZ1dUZWdqeDhzMEdpTGN3TkRybjEw?=
 =?utf-8?B?R3RrYVZ3VGt4OXBTRVBJbUR0c1R3NTRFRG43d2VuSit3RWkxRkZxL2l2MSsw?=
 =?utf-8?B?YzJXMXpPUTd1djhDK2hORDVWWTloc0Q3YnRJV1U4MWEzVHZ5ZlNhV3U0YStN?=
 =?utf-8?B?aGZ0a3h0enBpWmtHc3orWUpDZzBNUkFMT2QwdHlHcDJDMVBqVmNIUkdoYy9v?=
 =?utf-8?B?d2hLTzg3SU5iaGMrYWhFY0psektrZ3UzSiszTzdzOWNEaDNMbHA5SzJETER1?=
 =?utf-8?B?cjlkMzRCUTYxTUIvd2Vnc3Z1UVY2UlE4UlFDRW9pNXMreFZCaGNhdWpwNm4w?=
 =?utf-8?B?NUVyUEZnbEpxdzI3c05RWG5qem13dVNrdlJtVlZJdDQwY25Vci95bllHNWZN?=
 =?utf-8?B?eUlKbHV0WkdUVTdHUi9pa2FEUlBRSVEwQ1hsNW5xQ0FaNExPcUdEZytrUnNn?=
 =?utf-8?B?Q0NNOE8vOE5wNllldkJxM0QrTmxXbDVCQ0VYQWN6aUN4L0U0ZFBOK09UYk1C?=
 =?utf-8?B?VFpnWWpVMk1wcFpDMjlkcklFZUxqNnNSbTN0UHBJbjBLQ2cyTUJDZ2dKMStl?=
 =?utf-8?B?OEs1YXUxL3I4UHJPekpqQ0lLYWZCcWJlRVR5b24remZUVmVNSWNQZzloNlF5?=
 =?utf-8?B?SVgrV0RacjFwNWcwQ01yWVZyQ3pCeEV6Z1dxRWhYQ1gwSWFING5TSS8xazZo?=
 =?utf-8?B?c1NVckxTWWgzckhYakh6UHZCV1huNFRXZDBFejMraFhIRlZiek9sQTN3TzBT?=
 =?utf-8?B?OXYzWFRQdWFUa0RYbGdpWTIySGhaSEkvZnpNK0xRQlQ0b05kOHlPblIrZC9C?=
 =?utf-8?B?WXFjQ1BVY3hvVWZvUjh4WlQ2cUI3WE83K04wVXgvNGtSQ2licU0zUk5WK0Z4?=
 =?utf-8?B?OXBLcTR6M3FLcW1NWWdsdlVqYkxtMitIYmZoV2NYbzFyMnlsWThLS1RQMGc4?=
 =?utf-8?B?eHNhWll2Und5SDRhckwyR09Fd0gzcFQ5elBDUXpIRzVocDlSOEJPSnRqUHpI?=
 =?utf-8?B?YVJIdmcxdGE4VDhxQ21LOThLa3NUVGNIZ0Nob3FVdlAzaEs0anJSRWxpVGVH?=
 =?utf-8?B?ZWtmOVp5ZHovaXp1WUJXMi9UdENPclNVeVY1VkhCdWtjbHhQMmVELzFGUEIy?=
 =?utf-8?B?Z2tTU2lrejdrVXd1U0RUdnp0bUtabVdGWXJZT2hENm1XSU03dGRRUnNrQk02?=
 =?utf-8?B?WjUwM3kzRm5nUkQ3Wldxdml4bzh3UUpseFcwd3l3Y3lPT3RsQ3M1clhyY0JV?=
 =?utf-8?B?ZG5VdWZNVnNEV1dwYi9EV0R3ZEwzWGlvektmRFVBUkpDa3lsVzhSUCtzSTNZ?=
 =?utf-8?B?L1orOTRNOVNqRThPSURjMW8yNzNFMm5ESzkyc2FlYnB3eHU5N0ZONVNxVjRp?=
 =?utf-8?B?MFhWT00yRFZiQ3phdUI2NVZCdzRXbjRZWEhZdHFIZHU1Tno1aTNUTEFGcCtk?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 854e681c-4a8f-42ef-6cae-08dab8c7d341
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 09:36:00.8160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P8/s7mA0UtN0zKjrrn2UvbMglE+ARueGBxO3tP4CE9qbQI+NhQEYboWLvoBtWutfbxkh1gTQNCInyPitato8xDErg5A3WrWcVIXJdGAuEqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10378
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjMgNC82XSBjYW46IHJjYXJfY2FuZmQ6IEFkZCBwb3N0ZGl2IHRvIHN0cnVjdA0KPiBy
Y2FyX2NhbmZkX2h3X2luZm8NCj4gDQo+IEhpIEJpanUsDQo+IA0KPiBPbiBUaHUsIE9jdCAyNywg
MjAyMiBhdCAxMDoyMiBBTSBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+
IHdyb3RlOg0KPiA+IFItQ2FyIGhhcyBhIGNsb2NrIGRpdmlkZXIgZm9yIENBTiBGRCBjbG9jayB3
aXRoaW4gdGhlIElQLCB3aGVyZWFzIGl0DQo+ID4gaXMgbm90IGF2YWlsYWJsZSBvbiBSWi9HMkwu
DQo+ID4NCj4gPiBBZGQgcG9zdGRpdiB2YXJpYWJsZSB0byBzdHJ1Y3QgcmNhcl9jYW5mZF9od19p
bmZvIHRvIHRha2UgY2FyZSBvZg0KPiB0aGlzDQo+ID4gZGlmZmVyZW5jZS4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAt
LS0NCj4gPiB2Mi0+djM6DQo+ID4gICogUmVwbGFjZWQgZGF0YSB0eXBlIG9mIHBvc3RkaXYgZnJv
bSB1bnNpZ25lZCBpbnQtPnU4IHRvIHNhdmUNCj4gbWVtb3J5Lg0KPiANCj4gVGhhbmtzIGZvciB0
aGUgdXBkYXRlIQ0KPiANCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZk
LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vcmNhci9yY2FyX2NhbmZkLmMNCj4gPiBAQCAt
MTk0Myw5ICsxOTQ3LDkgQEAgc3RhdGljIGludCByY2FyX2NhbmZkX3Byb2JlKHN0cnVjdA0KPiBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4gICAgICAgICB9DQo+ID4gICAgICAgICBmY2FuX2Zy
ZXEgPSBjbGtfZ2V0X3JhdGUoZ3ByaXYtPmNhbl9jbGspOw0KPiA+DQo+ID4gLSAgICAgICBpZiAo
Z3ByaXYtPmZjYW4gPT0gUkNBTkZEX0NBTkZEQ0xLICYmIGluZm8tPmNoaXBfaWQgIT0NCj4gUkVO
RVNBU19SWkcyTCkNCj4gPiArICAgICAgIGlmIChncHJpdi0+ZmNhbiA9PSBSQ0FORkRfQ0FORkRD
TEspDQo+ID4gICAgICAgICAgICAgICAgIC8qIENBTkZEIGNsb2NrIGlzIGZ1cnRoZXIgZGl2aWRl
ZCBieSAoMS8yKSB3aXRoaW4NCj4gdGhlDQo+ID4gSVAgKi8NCj4gDQo+IG1heSBiZSBmdXJ0aGVy
IGRpdmlkZWQ/DQoNClllcywgSXQgbWFrZSBzZW5zZS4gV2lsbCBzZW5kIHY0IHdpdGggdGhpcyBj
aGFuZ2UuDQovKiBDQU5GRCBjbG9jayBtYXkgYmUgZnVydGhlciBkaXZpZGVkIGJ5ICgxLzIpIHdp
dGhpbiB0aGUgSVAgKi8NCg0KQ2hlZXJzLA0KQmlqdQ0KDQo+IA0KPiA+IC0gICAgICAgICAgICAg
ICBmY2FuX2ZyZXEgLz0gMjsNCj4gPiArICAgICAgICAgICAgICAgZmNhbl9mcmVxIC89IGluZm8t
PnBvc3RkaXY7DQo+ID4NCj4gPiAgICAgICAgIGFkZHIgPSBkZXZtX3BsYXRmb3JtX2lvcmVtYXBf
cmVzb3VyY2UocGRldiwgMCk7DQo+ID4gICAgICAgICBpZiAoSVNfRVJSKGFkZHIpKSB7DQo+IA0K
PiBSZXZpZXdlZC1ieTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5i
ZT4NCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgR2VlcnQNCj4gDQo+IC0tDQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiAtLSBUaGVyZSdzIGxvdHMg
b2YgTGludXggYmV5b25kIGlhMzIgLS0NCj4gZ2VlcnRAbGludXgtbTY4ay5vcmcNCj4gDQo+IElu
IHBlcnNvbmFsIGNvbnZlcnNhdGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJIGNhbGwgbXlz
ZWxmIGENCj4gaGFja2VyLiBCdXQgd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1
c3Qgc2F5ICJwcm9ncmFtbWVyIiBvcg0KPiBzb21ldGhpbmcgbGlrZSB0aGF0Lg0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
