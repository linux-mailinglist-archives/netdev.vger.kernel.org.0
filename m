Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2323566BF7E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjAPNQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjAPNQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:16:14 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE404ED3;
        Mon, 16 Jan 2023 05:13:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAKVQRCczmIjRpab6odxKsLNHvpO4fud6u8BCqCYcZD/IjfFyOKUxaVzdDjkzprmcAmB0oGoutwCAm6TiTFQIFG3HFFKq2oUOUTUdP2Ahtn0ctQ87btpbaexOGMJHzeTR8WxzSmuYH7/F8LNToK+GzjxuSlNVkWESpe7QOiq+k6ENElrN775VR5AspVOP/ZXcFXrf5GM+GQLlipJyqPZ9ghYgZYWAcoovf0NpM6DLz79dAdCWmKfAHR7zqEa2ZQb3WH7mgIrRFgPDQ6ff7dFlXcdbcY4nZAU8+JRIJhnKJKMuEU0WfdmxtD+LNe2rakcXTYcLCfMjbjYrlyCEOWQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7OkFxdMHvs3zupawHjUH5jeihD407X0+JI/YRemX7Q=;
 b=Ecnkbj+5sOmySjcUAm3qs5sUJOabXb/7k6CQbq2clGoqz0mDkSpBefIcXXPVohUgmozT06EgshYQS0ZTKvUUWrj4nmx9s+XVx0rIwYJACqLXrrv4KGi189YtDhEuwNt+6NOtJA7Rhr4ZwO0cxzKdn4uRjTaNhwCJT0Kk5grZOrKYzKf7MJCRavmxogk3PJKJdy8LN9+zxRcpsa8LGbEudQvHBgdi8w1jx3mwSKBlwsF/bjXbixHWOHrsiq3skiqAsx4pI+T6ULmJfqOj/EI0hA0LbogEmjvR1ou1IdIILyScWiVPFv3QoeIXauY5BS5LBJGkvNN9uUYEd6K9vvMsOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7OkFxdMHvs3zupawHjUH5jeihD407X0+JI/YRemX7Q=;
 b=fXRhx1uoxxxRQFO+VsVOIg0npgJC4dKThiY34UcegWdX8x0F3Z79pmGG90wbTMkQImdMM6vj1Own3Y2EVz9x1fwjTrrsbX8xO5WO4gehoDISRWJ73g6B2/UeXhovcwLx2Zh7gSn1ZNIhLNqUH8CPiPzPMAhsaWcpYoizz4AdzOuZ89nzvFSF3QrXMIAPhvY0hfWMPq6PgT7KKXmgtB8a0BmnDA5BYnGak1n9MgFlDcr8qs9G7kSwgQyfVggsyCr71cRrFiEFqiVO/Z795ZuWLcOfcHm0WEclbBrj2Dotv9VPT6kfXA3/3hVF+XcZtYr6MRPpU1EODupYoeFVC33Lyg==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by DB3PR08MB9033.eurprd08.prod.outlook.com (2603:10a6:10:429::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Mon, 16 Jan
 2023 13:13:50 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 13:13:49 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>,
        "pierluigi.passaro@gmail.com" <pierluigi.passaro@gmail.com>
Subject: Re: [PATCH v2] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH v2] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKSmh6qph8QozmkGz5EwYgs7b2a6g5AGAgAAfgiY=
Date:   Mon, 16 Jan 2023 13:13:49 +0000
Message-ID: <AM6PR08MB43764E8EB99B48897327CFCCFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115213746.26601-1-pierluigi.p@variscite.com>
 <Y8UwrzenvgGw8dns@corigine.com>
In-Reply-To: <Y8UwrzenvgGw8dns@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|DB3PR08MB9033:EE_
x-ms-office365-filtering-correlation-id: 94629b49-3dee-439d-0e58-08daf7c381e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9F2lb3E465FWDedKJikivlRG6zAlLVen1VFzNZtVptYEEK4P6tQD6pxr8zP6zVCZoAQnUdd5r8m1dC5YSICsm0V4zSvhmlcwT2JKi29ycF6sk5/4NZxBw9+PDk0p5eaMzGgnKPIYtt7G/JYkl79rs4IB3nCp1AIWMyKUb86GKvN9WLW31F8LYZmj8L5fVQoE/tZG92goGUsplTx55vV5OhD3QcsqfXmYdZ8IFpyey/pbfjH0Lr2h1UIj4XpbyU/qMvswWBaR5nWAswT+1Yfz9cuaeMuoT8hmfbUAN+i4cifJlARDrEo4l745MtyIXZqiMawtDFp4StXKYSTOZPIAnnUOw+he6RwB1g8i+ObMGPaTwywNEBRZcQsaKjIoq1zwar9dO+ENOt1SOZ1dh72LuIFHZfLdpl+JLgwQQmC9e1XEABzEJdjtIuGNAxwrFBSyiqiHxuQ2g88hCrNO5gZZDyc7FklF2VJ96FBFTXrPkzqDe9k0Vp6ks3ffz5z7/C4IM3seBmR4+fYrDSsL93hCajk/JyMhy9lcffs45HcL8lJbRc544hhAIAOL6r1Y9IpUe/BFtab4ZanffMuE6ugpjhS3a/3YgTL6nkvWF8BI4QESVs2pm1MpD3yzmmS0u45t/AfLsG7lzqlePuGmduEnc475c3WlsWI0zMQVWLqA20QFo/+TWy3VFz+LL4UpAen331qCvooZHeHcrV4bqWfypQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(52536014)(8936002)(71200400001)(55016003)(5660300002)(7696005)(33656002)(38100700002)(7416002)(53546011)(6506007)(38070700005)(186003)(26005)(86362001)(6916009)(316002)(9686003)(54906003)(64756008)(478600001)(66556008)(66446008)(66476007)(4326008)(8676002)(41300700001)(91956017)(76116006)(66946007)(83380400001)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?GBXxZIh+wXXMkpXN4N8BqVIMFRDSHb4tPa9a2C6rCbqRkjRU3DttvqVeP+?=
 =?iso-8859-1?Q?dgL0JgXIV5Lw62YFA7Kpj+VVnCLukCHGNO58BPTv+mr+UPf6agoNczR0Eq?=
 =?iso-8859-1?Q?HVvb2cjNpeacqzhnmxYS+2iPtC7tDlVvjZmcjezExWL0LZ8clybz9xXiNp?=
 =?iso-8859-1?Q?/s0Wuhc2iItGWadpdkB0M+nHhVarO9sT9sbpnu+/YZvb5Thp3yqcwQRJk5?=
 =?iso-8859-1?Q?zlMrlaHAcsrHT8c94qDfLUT25zkzEZ5iodZB0nx8n7e94iwoI0b6C3NllC?=
 =?iso-8859-1?Q?mf4NeBdqtuSqYFCgiZEz4q1q/BvdNPmPp+cQaPQHRniyMCLsPMTIf5Wjat?=
 =?iso-8859-1?Q?JJuZIoSf3Z5TQTsSeaHRJkOC7+ZtmWWNTqaSe1bvh4pqdvIcLETYaaLFAK?=
 =?iso-8859-1?Q?8ZNwkjAB54g3r/68aPD9TSrPIvTO5193ktpnBK88I40QOAuSvjyazJ/kPr?=
 =?iso-8859-1?Q?p3EFO4qiasewy8vexaTh/JO+vCau5ysbkq4osxOlqoBvL/VvUiYqtKggcG?=
 =?iso-8859-1?Q?305kIScRT6zhguGYg7WTUeca5fXiIbB9f6jZ+DqqsX44AWI29Orf+3PCCX?=
 =?iso-8859-1?Q?lsNPkp59O7M9nUiY7jK9Cwlo0JgUV8s4WZ2qYh7hh1nz6QLlN3a33hik5z?=
 =?iso-8859-1?Q?MmAExJ5/ZIrwj6g0L7fe1XmbfQaTW/iJ8wpWpFgsQfWtsoBLcKXfCOLxVx?=
 =?iso-8859-1?Q?wwSB8D1BFdSTRTDOVkZX3pTOEmGTSKA+gXwA7Zxi9qL4A7fa38MIVX3/w9?=
 =?iso-8859-1?Q?iEwEj1IlcAy+i1RZ2OW25n56lQy5G9g83xubPlpBNsKjJKs/O/Ik7SJwVT?=
 =?iso-8859-1?Q?5CQDxc8rKgnh9MbChdO3II4k4+UWOywV16BwfOFkj5WIHog49mbESDboJ9?=
 =?iso-8859-1?Q?2Bb40gVXasmj71avP1GO1wYgDIlI6agnJalh43468x+9hHsiHt19XZQo4h?=
 =?iso-8859-1?Q?o1+LkC+b8RIv6AR0BCbitdIUQd8J21cDuU06YKb7e+j0KMRlb55wc2q4zX?=
 =?iso-8859-1?Q?RblJ8OCdidN5ma45wMAJRYnOr8Pq5B6jQQdXwnUv/hdU4tDEGMIQogG4w9?=
 =?iso-8859-1?Q?U4dFDdmuG8eG7+oGgsFNPHdhGtPz7ItcVxVvd6/COXZjgnFdN+n86JvP+s?=
 =?iso-8859-1?Q?U1XF52X4tn8ZAESzeXlLFw306hlKZ9bGZBFXtP5xcb7Rp7JxbqWKZ20o+E?=
 =?iso-8859-1?Q?6d9QNrhenJCvdZ7hlu25Lg1x10AHCIrrNnlBi9NhXoBa8ok7NHHUm9nqik?=
 =?iso-8859-1?Q?qvJLzxeNkDzCAhbtSVvpGODZ1mh/G3ty9h0X3o6GwOObdx5DPRBSMAF99+?=
 =?iso-8859-1?Q?a+MbpeT2iKckJOluxp9UvFVEtBpu8yA8jf/zgid1VdCsGaXVbVsNxG2e5E?=
 =?iso-8859-1?Q?+1IVyKkXPtsCsNeS1aUh8XTEBy1jSkjP+MWGIhuq5f0d25Auj2dQ/0b2nD?=
 =?iso-8859-1?Q?ccJJ8coApm2xJchJq0+zV9HFWQ69Gv+brBnnqPQUmbxCe5wkR88Ps71+fV?=
 =?iso-8859-1?Q?mSozd6Y2T53DomjTqf+Tu13A2ZcUys4IjNpmasjW+w8SeCW83ub2nE+lv4?=
 =?iso-8859-1?Q?1qbkYyCtUolQLXXj0Ym4qa4oRieFWTFCfRBBf9qemcod3wg7F7jVFrRsy9?=
 =?iso-8859-1?Q?FxL+znKYhz7sCidjuaXIr6uHtT9NMHLyGv?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94629b49-3dee-439d-0e58-08daf7c381e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 13:13:49.5546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NB/f9CRTuIPccmBDA5HYwp6T4f5CpXcAccSHA1xjHZVVPEyULHRgNk4w9uc2PlszGFAbibl03e40dAosYVlPl+mWr0nOOrKaIBMEzjXK/08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9033
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 12:10 PM Simon Horman <simon.horman@corigine.com> w=
rote:=0A=
> On Sun, Jan 15, 2023 at 10:37:46PM +0100, Pierluigi Passaro wrote:=0A=
> > When the reset gpio is defined within the node of the device tree=0A=
> > describing the PHY, the reset is initialized and managed only after=0A=
> > calling the fwnode_mdiobus_phy_device_register function.=0A=
> > However, before calling it, the MDIO communication is checked by the=0A=
> > get_phy_device function.=0A=
> > When this happens and the reset GPIO was somehow previously set down,=
=0A=
> > the get_phy_device function fails, preventing the PHY detection.=0A=
> > These changes force the deassert of the MDIO reset signal before=0A=
> > checking the MDIO channel.=0A=
> > The PHY may require a minimum deassert time before being responsive:=0A=
> > use a reasonable sleep time after forcing the deassert of the MDIO=0A=
> > reset signal.=0A=
> > Once done, free the gpio descriptor to allow managing it later.=0A=
> >=0A=
> > Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>=0A=
> > Signed-off-by: FrancescoFerraro <francesco.f@variscite.com>=0A=
> > ---=0A=
> > =A0drivers/net/mdio/fwnode_mdio.c | 25 +++++++++++++++++++++++++=0A=
> > =A01 file changed, 25 insertions(+)=0A=
> >=0A=
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_m=
dio.c=0A=
> > index b782c35c4ac1..1f4b8c4c1f60 100644=0A=
> > --- a/drivers/net/mdio/fwnode_mdio.c=0A=
> > +++ b/drivers/net/mdio/fwnode_mdio.c=0A=
> > @@ -8,6 +8,8 @@=0A=
> >=0A=
> > =A0#include <linux/acpi.h>=0A=
> > =A0#include <linux/fwnode_mdio.h>=0A=
> > +#include <linux/gpio/consumer.h>=0A=
> > +#include <linux/gpio/driver.h>=0A=
> > =A0#include <linux/of.h>=0A=
> > =A0#include <linux/phy.h>=0A=
> > =A0#include <linux/pse-pd/pse.h>=0A=
> > @@ -118,6 +120,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus=
,=0A=
> > =A0 =A0 =A0 bool is_c45 =3D false;=0A=
> > =A0 =A0 =A0 u32 phy_id;=0A=
> > =A0 =A0 =A0 int rc;=0A=
> > + =A0 =A0 int reset_deassert_delay =3D 0;=0A=
>=0A=
> nit: it looks like scope of reset_deassert_delay could be reduced=0A=
> =A0 =A0 =A0to the else clause where it is used.=0A=
>=0A=
no problem.=0A=
>=0A=
> > + =A0 =A0 struct gpio_desc *reset_gpio;=0A=
>=0A=
> nit: reverse xmas tree for local variable declarations=0A=
>=0A=
I'm worried I'm asking something stupid: what do you mean by=0A=
"reverse xmas tree" ?> ...=0A=
>=0A=
> Also, if reposting, the target tree for this should be in the subject.=0A=
> Assuming net-next, that would mean "[PATCH net-next v3]"=0A=
>=0A=
no problem=
