Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0552D771
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiESPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbiESPZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:25:34 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00080.outbound.protection.outlook.com [40.107.0.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDBBEC331;
        Thu, 19 May 2022 08:25:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSuql/UE8MP2w/9TmaDW/CzZq3lbm8ICJePZmU7o5deVrLUraZAPOS5TXehUhDLO+u1GlQLNn6vANUs/2FH8S7ejBxml8fE/zJ+JnJKEqMk/NfAr6iMnefwutR81zub3YV6jvPlz7Zns6MHLcLbdtEewW9HRFG42OnRsnSwWl1UcRXHAHhfL3Z7IBJyMj4jguPhANkI3JXs1ONChSz2vk4ypdq95Vk26xSVGIVhA18s6MvUpTa32ww+DtzG2e+eU3ijslpzdV5M9g0Fk9oLL+ib8cP5FksfIDcmxRZ6KlBKx2IefpWlzbA7kcB1pagdT3p+/DlSFtseH2bQkmIaagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3K9mzU48jgAv6dmZ1+sF+k1jtOo94W1l0ZXCQVjlWyI=;
 b=EinDZZ+7aFphvgiqkLtxxTpRDiWpsAMUbprmmwfsaqejfJWPFZr0v+EMfsR2S+BOa4qGnl4yY4pqcjFmQIDnRVgb0vQYkG5ZrL6xgbEX3Mr3TaQ1Zq6Mvhcd5dnDVDYuP0JxOjilxoD8wirzfecpzeICM6ua/6ZKJk6jKxF5ct14WOE2z786gyG1rIDbI5tQCYB9/55P+GIpBKO5+gGo7j54pzJKBck+X87zK/EGitcwUxK0rVT6nKT1YPZ8tqZgBFwc02n/y/mRD1dXs2XJDswi2swJUgsUCxqIW5VEjcUsA6SqzkjFK5Xoyeu9aRUob0MAMbpN1WyDU+pPK7gTXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3K9mzU48jgAv6dmZ1+sF+k1jtOo94W1l0ZXCQVjlWyI=;
 b=eXgDi4Gt1Cbfu25KQFjVncoyOmt2BWexkTMsFyHmL0WvaqAf68cBQ+n9LkZ2VtgBzEIJG/iQC1nDPYVlhh1BhbH7Qbhf/tQVpDNfldYB1JiJm62321czQ5PZhcv9VlBWtfG2oWiHWj8mE6u8JhKf9A3fhAW62Jo0kC822gumNuk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2783.eurprd04.prod.outlook.com (2603:10a6:800:ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 15:25:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 15:25:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver that
 defers probe
Thread-Topic: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver
 that defers probe
Thread-Index: AQHYZyJUAF3LqZezX0WvBgnHz+VvNa0dg4GAgAjQVgCAAAR0AIAAAsiA
Date:   Thu, 19 May 2022 15:25:30 +0000
Message-ID: <20220519152529.s2amgob3enfxc6w6@skbuf>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
 <Yn72l3O6yI7YstMf@lunn.ch> <20220519145936.3ofmmnrehydba7t6@skbuf>
 <YoZfFDdSDLUtn42S@shell.armlinux.org.uk>
In-Reply-To: <YoZfFDdSDLUtn42S@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef0f9f48-ac5a-42d0-a2c0-08da39abcf36
x-ms-traffictypediagnostic: VI1PR0402MB2783:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB2783BD95F6C51F8D682A4E37E0D09@VI1PR0402MB2783.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r69X2FcRfR56vEv2PeT660KZx2CuvKVjlEXGVlNLeIKHjC0B95sJefs4iafiVEFd7ak1mfLh0yKPsJArRuxzREJwV6hzhc5vvb7vgL00/x2I9jwwB3NS6yCeUlVOkT8ZXa7Q7nrZdunAziyYqkVF3Ur1tHXpeybqau7JluwlCqIwS802J97c4fKbuiVgjOywIpx2ufW13qoefsn7ga3um6OT9bcHVqxmw1dxiuNsEbhQoKMMH/INvqtGjr8IUcJjeJBow1hDoybckZRUKAcdl4VGrc8QNEwxMgD2w8uVHRE8Ly/LszV2FG64uomSfmy76UaxxgUqQhcKTLy1B8Nuuta0/HkeVJTzJEeekz4klSvxGJqUb61oEdoaF9Cwp0aULiVE7sRu9qf2p45t3LvxjvSeqQHlq8kZsQGaHMhX38DV/6PeKsUGiZqQirhGprMe3aRLxeTyq4+8hDaCCzpRj75f2183uCGmhvsI+/ksO+YcaDSzfl4ZRLBJhnF2OkuWobsPOERECHQ7wP3iT1MhXm1d8uE/G6w+3P5yYj77BNNuhDW5sAZ1wCB/VhtrwlPfatfLkJlqIMBM6yJCdk//p4HraqIpVAj3pAhXbzMKwv4jba02vK9SBBAto/JvJ72swFOLHVenXVcfMLJM7IV+Dt5p72i+003S83Ee0YNFNRbo35ai0zfBCgx6hXc0wYMIoh04eCZiPqyepXnObdo1xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(83380400001)(186003)(8676002)(316002)(6506007)(4326008)(91956017)(8936002)(33716001)(9686003)(6512007)(26005)(66476007)(66446008)(64756008)(1076003)(6916009)(54906003)(6486002)(5660300002)(508600001)(7416002)(44832011)(38070700005)(38100700002)(66946007)(76116006)(66556008)(122000001)(86362001)(2906002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?cGZEcDJmOFJ3YURSUVZqQ1RGZVRUTVpjb09XTVNQMGIwQnpEdnE3dG8vS0F0?=
 =?gb2312?B?S1VweEorRHcwWForNzlCcXZISENUZ1JiMWJkeGNXVXlueVhyTEFkTlcwY2Fl?=
 =?gb2312?B?Wm8rekZCRC8xY2diQkl4bC9tdFFaU3BlSktjWCtkNHVaT3l6VTdqMG5VcGla?=
 =?gb2312?B?Zm1SZ3Rxa2VhOWxKODF3dnRlUFVxL2pxMUlaU2x1YU9ORGpncTFYSW54blBh?=
 =?gb2312?B?UC9mNFJzQjRrYnJjbkhvKzBPbnprUTRQR21OYXluNGU3bDBFOWdMQ1R3ZDZa?=
 =?gb2312?B?aEZLQ09QN3dIWDJYOXVPanZ2ZXpvRkFpQ2laMll2OHBRMzJaWjZDUFd5bmdm?=
 =?gb2312?B?VmFXb3JsRTZtN0ZDV0xSK21uU1ZaZ2xkcmIyWkJQVWZYV2tWcnhjZzl2cElL?=
 =?gb2312?B?bWxRbmp3TWdvUDBDQWluQzAxd1doS1kyK0pmeXhYeVRQVTBRVGpjOUJ4VGVG?=
 =?gb2312?B?RkxFa3d1dzBZZmJHYi9oMzFrV1JnMTN5WG1ENVFMeUV5S0VVakptbkVHbHVq?=
 =?gb2312?B?dDB5ZDdxYmhaa1FLTnRneC9WSm9ZVlhVN09JZ0lXUlNVVEtKUzdNaWxRMFdI?=
 =?gb2312?B?RlRpY2ZkWENES1h1bzlnY3pKc2E1ZE13cTVoUzBnelRpMEtXZlU1Z0UvRFVU?=
 =?gb2312?B?Vm9Nd2NURVRvZXd1VStaSFJnbzhTbHFoQTlPZkJ4UTRwaWxuSmxBa29pNHEr?=
 =?gb2312?B?N1AveDlMMS9BakdOeVlxeEN6ejd2NmYwR05tSkc4SmhZeEZvRTV5SldQb1JE?=
 =?gb2312?B?YzJaaUlRb3BvV29xUTBaZFV1SE1QMjVYZWZkRTkwU09pRXMzZlZnRkpWUmkr?=
 =?gb2312?B?SFN2TzdrTzZxRGJoVVBaQWY5UFdldElDVk1DWDhXSEVNcHZnL0Q3R0V0WnFY?=
 =?gb2312?B?Z1VHYWpGVy9mSk9KZWVhZ2lBTVFRUXJpUkJURUJxeDJJQXpBb2hhdVBBNlA4?=
 =?gb2312?B?NmFVQmY3cW1vTzBUUklGbk5MV3dxWnFWTUVUc0NPQUlEWEFXWVBKQ3NEVzU5?=
 =?gb2312?B?ZnJmSWhhOGtNL3N2bGp2K2owU096YVZkVnVqb0o5bnRyS3ZXZXVlcnQ3UVBp?=
 =?gb2312?B?TWkwa3JJSndPeStzMUJXVDlWTXBPeFk0N09VRzBkMG40M1dHc2tDUUdTTVZM?=
 =?gb2312?B?THpFNnoxcld6dTFCRmQxUUZzaEw2ekRoY3NvWnExZnlCdDFYRmVubkpDQ1dh?=
 =?gb2312?B?a3pWYmJEK1dDOWlTRmdQT1lDd3E0bDdVZU5ZSVEvdnRWWFR0ZXpPN05xZjFw?=
 =?gb2312?B?RGR2NFJmZ3JFSXVjQXNtYXBnRXJkVVBFL2I3ODZ0eDFYdlplMjVFUUJqLzRt?=
 =?gb2312?B?OTFpeE53b3RsUlNNVkVLNmZFY2dWL2EyQmNjbHVlTFA5Z0ZLMXpPeWNlK1hP?=
 =?gb2312?B?dUdIclNjTTdRa1pQM01lc1JNeC8xU3BYUFE1eStFL2NsbUtlcktlTUtmTU82?=
 =?gb2312?B?RzFWY2JORkl1MkFtZG1FTm9RWVBSNEFJdEFxQ254aXdjNFg5OGo2SzBsRWRl?=
 =?gb2312?B?Z0tZYzRtdE1IV1cxTk9tRW51WWorZVhaV2ZRNy9STVduRkNEMnp4aitXd3hL?=
 =?gb2312?B?UzdqbXIzSlR1b2JGWnhwd0ozMFoxT0RvOG4zMlR5UmxJVlF1dkRyNHA0RCsy?=
 =?gb2312?B?YndWY1FCOE9CdUFPK1F5bDNYSU9tcWhsM3NGTWQ1VG9xRjBycjBIcDRyS3VF?=
 =?gb2312?B?L2g0d1JJc1JjcUhtSS9HaE5oOURXcldJMG91L3N6WVZaK2M3ZUk0VndRZXZI?=
 =?gb2312?B?c0RmLzRzR3V2TTRVeE5JcnBvSXlNU2RYdmJjd0dUMnBIRUdDVThwYkU0bFVF?=
 =?gb2312?B?TG9SQ1lWL0ZhTFAwUXZZODJvaTI4eXBzekFyT0wyVjJZdDNaQjNGRThKUkpr?=
 =?gb2312?B?Wk55Yms1T2ZhWjJTSFlCQStXOUZnTVIvVXBTbGNwU3ArM05vOVUvWXR3MDBY?=
 =?gb2312?B?QkROYmJQVWx6cnhON0tBZk9wSXZxa09LUzgwTUZSUG9JK0Z4dTc1bW9OWEJD?=
 =?gb2312?B?S0VqeDJiY2tZWDlraENqdzZMU3o5QkYxZmR4NzNUZjc4bGNEUW9LK3hDNmpF?=
 =?gb2312?B?cys3eUtTOWVnRjVKUmE5VTdEYWo4NDNxYW1xVTRSdDhQazE5bGxlUUcxRTZB?=
 =?gb2312?B?d0o0aTdRejFuYjdpSUhYTHlNTnlwK3A2VGh6d1k0dld5dE83aEtFSG1SaWcr?=
 =?gb2312?B?b001YnpYWldubm5jYy84ZXhNcDl6d21sZkJIaGQwN05VdVNJYm94VXZ6SFlD?=
 =?gb2312?B?eWdZRHJiM2NXTzFTVkZaUHBBY3QzWTBOeit6M1ZBRlVhV0RiOHk1a0NOeTFn?=
 =?gb2312?B?K0ZwaXU3YUNUalFBYWp0Ylp6MUtBM3k5V0x6SUFPdS9IaThFckl2ZmVHTzQr?=
 =?gb2312?Q?833GGf/9I203AFK4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <22A691AA34D6034F9EA8C5BA30E85D30@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0f9f48-ac5a-42d0-a2c0-08da39abcf36
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 15:25:30.4532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GkBwGztJnTOKeRG2Fu8P1wMTOd+yEUjOVV3aZstyvALpXj+8ExNTU7vg0WIAOPwGgjtTQyarAbe2aYJkjOf4Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBNYXkgMTksIDIwMjIgYXQgMDQ6MTU6MzJQTSArMDEwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBPbiBUaHUsIE1heSAxOSwgMjAyMiBhdCAwMjo1OTozNlBNICswMDAw
LCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+ID4gSGkgQW5kcmV3LA0KPiA+IA0KPiA+IE9uIFNh
dCwgTWF5IDE0LCAyMDIyIGF0IDAyOjIzOjUxQU0gKzAyMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0K
PiA+ID4gVGhlcmUgaXMgYSB2ZXJ5IGRpZmZlcmVudCBhcHByb2FjaCwgd2hpY2ggbWlnaHQgYmUg
c2ltcGxlci4NCj4gPiA+IA0KPiA+ID4gV2Uga25vdyBwb2xsaW5nIHdpbGwgYWx3YXlzIHdvcmsu
IEFuZCBpdCBzaG91bGQgYmUgcG9zc2libGUgdG8NCj4gPiA+IHRyYW5zaXRpb24gYmV0d2VlbiBw
b2xsaW5nIGFuZCBpbnRlcnJ1cHQgYXQgYW55IHBvaW50LCBzbyBsb25nIGFzIHRoZQ0KPiA+ID4g
cGh5bG9jayBpcyBoZWxkLiBTbyBpZiB5b3UgZ2V0IC1FUFJPQkVfREVGRkVSIGR1cmluZyBwcm9i
ZSwgbWFyayBzb21lDQo+ID4gPiBzdGF0ZSBpbiBwaHlkZXYgdGhhdCB0aGVyZSBzaG91bGQgYmUg
YW4gaXJxLCBidXQgaXQgaXMgbm90IGFyb3VuZCB5ZXQuDQo+ID4gPiBXaGVuIHRoZSBwaHkgaXMg
c3RhcnRlZCwgYW5kIHBoeWxpYiBzdGFydHMgcG9sbGluZywgbG9vayBmb3IgdGhlIHN0YXRlDQo+
ID4gPiBhbmQgdHJ5IGdldHRpbmcgdGhlIElSUSBhZ2Fpbi4gSWYgc3VjY2Vzc2Z1bCwgc3dhcCB0
byBpbnRlcnJ1cHRzLCBpZg0KPiA+ID4gbm90LCBrZWVwIHBvbGxpbmcuIE1heWJlIGFmdGVyIDYw
IHNlY29uZHMgb2YgcG9sbGluZyBhbmQgdHJ5aW5nLCBnaXZlDQo+ID4gPiB1cCB0cnlpbmcgdG8g
ZmluZCB0aGUgaXJxIGFuZCBzdGljayB3aXRoIHBvbGxpbmcuDQo+ID4gDQo+ID4gVGhhdCBkb2Vz
bid0IHNvdW5kIGxpa2Ugc29tZXRoaW5nIHRoYXQgSSdkIGJhY2twb3J0IHRvIHN0YWJsZSBrZXJu
ZWxzLg0KPiA+IExldHRpbmcgdGhlIFBIWSBkcml2ZXIgZHluYW1pY2FsbHkgc3dpdGNoIGZyb20g
cG9sbCB0byBJUlEgbW9kZSByaXNrcw0KPiA+IHJhY2luZyB3aXRoIHBoeWxpbmsncyB3b3JrcXVl
dWUsIGFuZCBnZW5lcmFsbHkgc3BlYWtpbmcsIHBoeWxpbmsgZG9lc24ndA0KPiA+IHNlZW0gdG8g
YmUgYnVpbHQgYXJvdW5kIHRoZSBpZGVhIHRoYXQgImJvb2wgcG9sbCIgY2FuIGNoYW5nZSBhZnRl
cg0KPiA+IHBoeWxpbmtfc3RhcnQoKS4NCj4gDQo+IEkgdGhpbmsgeW91J3JlIGNvbmZ1c2VkLiBB
bmRyZXcgaXMgbWVyZWx5IHRhbGtpbmcgYWJvdXQgcGh5bGliJ3MNCj4gcG9sbGluZywgbm90IHBo
eWxpbmsncy4NCj4gDQo+IFBoeWxpbmsncyBwb2xsaW5nIGlzIG9ubHkgZXZlciB1c2VkIGluIHR3
byBjaXJjdW1zdGFuY2VzOg0KPiANCj4gMS4gSW4gZml4ZWQtbGluayBtb2RlIHdoZXJlIHdlIGhh
dmUgYW4gaW50ZXJydXB0bGVzcyBHUElPLg0KPiAyLiBJbiBpbi1iYW5kIG1vZGUgd2hlbiB0aGUg
UENTIHNwZWNpZmllcyBpdCBuZWVkcyB0byBiZSBwb2xsZWQuDQo+IA0KPiBUaGlzIGlzIG5vdCB1
c2VkIHRvIHBvbGwgZXRoZXJuZXQgUEhZcyAtIGV0aGVybmV0IFBIWSBwb2xsaW5nIGlzDQo+IGhh
bmRsZWQgZW50aXJlbHkgYnkgcGh5bGliIGl0c2VsZi4NCg0KWW91J3JlIHJpZ2h0LCBJIHdvdWxk
IGhhdmUgcHJvYmFibHkgZmlndXJlZCB0aGF0IG91dCBpZiBJIGFjdHVhbGx5IHRyaWVkDQp0byBp
bXBsZW1lbnQgd2hhdCBBbmRyZXcgaXMgcHJvcG9zaW5nIGFuZCBub3QganVzdCBzdXBlcmZpY2lh
bGx5IGxvb2tpbmcNCmF0IHRoZSBjb2RlLiBJIGd1ZXNzIEknbGwgdHJ5IHRoYXQgbm93IGFuZCBz
ZWUgd2hlcmUgdGhhdCBsZWFkcyBtZSB0by4NClRoZSBvbmx5IHRoaW5nIHRoYXQgcmVtYWlucyBp
biB0aGF0IGNhc2UgaXMgZndfZGV2bGluayBibG9ja2luZyBQSFkNCnByb2JpbmcgZm9yIGxhY2sg
b2YgYSBzdXBwbGllci4=
