Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9865EBA46
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 07:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiI0F7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 01:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiI0F72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 01:59:28 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2121.outbound.protection.outlook.com [40.107.114.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6FA6AC9;
        Mon, 26 Sep 2022 22:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsgatCN+5nU9JZXR70bpdfZzxJL/6cgR3t9AO7VZb9maD4cOqQTD3y67wEbQ+cYwN8DbDQtJ4idhwkK22afEX9kuxrxfMVk74wqC39R1GCsuay7z3/2sXaZnz0eijdWHgHfLztVNK7A18fey5Iy/E9UR4D/x00xIDbxf09uK5AAHnzjZ9lvNa6G9rHPCMryf/xsZG2CYy8gRPBEIGZr4Yim8hHSGUsqY2ELvaPknvuZY3CkikBqPbl0yZItiV+uxZpUwDzI7n9UYZ3OE4DQ46duHMGdpCpslbJpfenGN3SUUwuxi6qCLrZkyqZXdD+X9PJ+BIBKJx0njdrGDj6RNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/DjLI6zIkFneMfgVpirxpvKxDzJxw58UwT4LpW3A50=;
 b=LJX9oMl6VxW5jbgGa5p1AJIFNko+sXbkAv64ANeVfcaWCu8yXiQcqHHJ7Q+usj7COF4upxjNU+TNHHoaDlKyG08WCyrJ5ZtTRN1VM1so0xYUnw+p1R1Yd57jAirWGB6aE+1Iwv8Dt6Q0Nk8UTZ5drk7h6g4SxScr4w5gtc3HvR0FF7/zoicRlEMHiMyrX5+O8fXadccWuTSYLIbh8myFQXFycUkThm3uX05Yjvk6S775kPaS6h/oof74V/+S1YSrJsCDxOzZOKcMyILlgTl6l1x+UVAVRtUJ3AetCHJW7+Qz6jjOB+nXZChw3YcKCnxpP1nQKAFlrBTnXsQ7SQtSVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/DjLI6zIkFneMfgVpirxpvKxDzJxw58UwT4LpW3A50=;
 b=FXp5IGf7/DmX21HjFLGUKznTSGOo3znS2wcGI097MxHRMgBCuNyCUTqWvEm8eq32TEG33XRh6KOU/qq8p+8d9Pm+zje5aVrtBkaFpJw7i+SRMf2rvKbeZmXeoYgptHiU3oSUDyhiDlrJJZG0GPZxhIEdA7tdf8gZ8n9axHyujKw=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB9591.jpnprd01.prod.outlook.com
 (2603:1096:604:1c8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Tue, 27 Sep
 2022 05:59:25 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 05:59:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHYzkQbCGZNTw1MNUuaNx/SR8stKK3s/34AgARIsfCAANSngIAAruVQ
Date:   Tue, 27 Sep 2022 05:59:25 +0000
Message-ID: <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
In-Reply-To: <YzH65W3r1IV+rHFW@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB9591:EE_
x-ms-office365-filtering-correlation-id: f3bbfd1f-ab3a-4437-c073-08daa04d6e90
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQrpQkorUh+8y3g7fx9ALPDlEeVN1qialkU6+zjWdho/4sqr/0/27cvBdUv8JKb1dpuk0/tBx+EFod33VkLpRtLOI8pqx5tPnaUrbxOm8uKGxm6UP3naaLGxXwbXdWDYofUDD0Hfbq9/D2bwImFCd8KqitbWs3wSkro1+Pu4FIM4wwxn7W3/9a42PJxNChZ9qbppfb15yp98DxFv0OKh+lkSeC9ZkzFg1NW3EwokPmWGr7K4lCf+FSlEbEowewZSvrq77DLzv++EGtRf88HcaSZ/o7XCgNQyWhBEOQTAgjlQ1G/qlqqKVreDvdjy7oVtzPt3shlp7HcEMH3/7p/Nhvxia1g0GnO5X6cFrNoKBSEKerNR4duSpVQe4XduAuNevkzssoaa4UDoBcDkqp7Vu1QT368hzQ7ZEeJ7KuyOoX2qd/o6m/RIkDbL401X5vkEdPcHgHo7xFk2l1YDyylonJARIoeVVg5eqKqU2csLOExXrInGORFCZYDGrm/TyWznAXbB3qepnis2oEhpF99iOi/wwaCainJqQaNilCYRDPV+611WJlp+JdJLMvxViSD4X/fXEMHD7fU/caX0P2OyfwH/XJsbX5/5ZmoOutlRqdv14OUidY2r3wvBeQHRDfpSJGar1VftxknSaY5LCj0xmcdWbXeX58DNDZsl6aoRvxf+s4nvndk1kv/5x1UPblcbPm46HX8UeDXnyL7hIqJzk3RVHW/OELMT841hYefMZSRGXqoXkVihrhvGOxYFWd0Quu/8EXkXjpdSULp/gbzowrmYtHJRYgVotaMVFFPXhvxEamyQB9M1qaXL8W9SjVehXsVz75lgSar/j+6LtAK0JQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199015)(122000001)(4326008)(5660300002)(33656002)(2906002)(186003)(8936002)(52536014)(7416002)(38070700005)(64756008)(66446008)(66476007)(66556008)(41300700001)(86362001)(66946007)(9686003)(8676002)(76116006)(83380400001)(316002)(7696005)(6916009)(6506007)(54906003)(478600001)(55016003)(38100700002)(966005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jdzr2toLoLRkSYT3uY55S454PZxxWmJmqZNIbvoIrjyp6jWXMe91m9R6JEif?=
 =?us-ascii?Q?WzvoT3FnqgQgOZk/Xj5+uWiTAqxk50x7+OSij+iR1W8GshAUeDzTndK6hm9T?=
 =?us-ascii?Q?Dhz/sCn1+T7OH+yPEw1sU/0oCTP10/u2Us21+xD0Yb+DzFjMtcERsrvzjdYn?=
 =?us-ascii?Q?ZUo9xrVwuXoaHF9mrhK9PYpkq2fp9H60kiRPeXFw6L+iKFDwGXn8IDaPcE+e?=
 =?us-ascii?Q?25lx0eLTKeIOyekHnX9A1de5GHzfqkxp7X/vC+GRu+KKYDw9MYauqCf01cmd?=
 =?us-ascii?Q?S2mHL2zdCkb1Y11a0NwV665avjkaHbTHWG6KnlLR1+F/nP5BfNHk5QYcfCez?=
 =?us-ascii?Q?vGSHifv64NZMZi36/GE804Wg0xmkWO17UfsqqT5uO6iV2Natn0llzjamTfUr?=
 =?us-ascii?Q?1eCgGqH5Cgnlqd87Hd/UoznfLuAUMQLafgBlrHAGyFJ39V8UqBnf9/Qf5HJ1?=
 =?us-ascii?Q?gn41G/MOIbIeiNHj35cLL9ceIbYMYdCfZHkhKi2XNW30HTcMJOeIFHY9PPF/?=
 =?us-ascii?Q?wmfuE4HlI9b5xPCM8c6KkHnGF9eSSqj7CbAsJd5u4XCgmMKyc6e3gUNam2jL?=
 =?us-ascii?Q?fnIiyPfpRm3LxjAPSpxeU1TLUkq/XapLOX2SoAI1Hzhn72gEi1gFYFoSUpPQ?=
 =?us-ascii?Q?bt7czLpy6+ePsbnB4iTCvAoift3IXRum17jIl5I9qPzvtaLrbX5bcycx15TB?=
 =?us-ascii?Q?Fd1nMstokmO3mo5EQzvOZWbLow8D/bzmD2vN3k81j2wPME2EE3hrSbgfP9rV?=
 =?us-ascii?Q?rObURvEP8iVQrUbbC5Hyda9S0bPiDnq1mC7MpdWDCC4omugVU1q32W3Y8fy0?=
 =?us-ascii?Q?VYR/GLla15t3faAJM/NYfQk41I9OwJf9UiFlEXLoWYfCZc4S498lx8T5sr0s?=
 =?us-ascii?Q?MVgYaeFvKc464/Rtekf1993TPOzARgA8SXEn8eGBsdAnQ0ymINSKzUI6GWxv?=
 =?us-ascii?Q?XQmlTcEgzBpwA43PfU8MvkK5WlzjMmflKM80hs1GdCfbKmbXK1W1CWAJ+zGr?=
 =?us-ascii?Q?435OsO5/FNbICGLjWXxZjGNDxLH6u4OdAHByCqQxrqwPUIkdez677+aKAqi4?=
 =?us-ascii?Q?Etr7STPOpIPhiNoFVjQWbUwAwqDr1jEzIFwRoU1QpsZr3Qv2reoxfwcUvz0D?=
 =?us-ascii?Q?Ca5bhh99I02Ecox1PlC0FaesjHL+ElBPYLyf+1zSY0BUL8cSVMvzkUj/e2Fg?=
 =?us-ascii?Q?mnQwcbtsuxyyV/dbYBqsQ7bN/6++KRWrstSMeY8PQRuER2HvYntIupUxmNpQ?=
 =?us-ascii?Q?1PXCEF2MGOmwMQXPgOkejpdp/kV3brgyZY+jbVRSxk7to26aM5vs344f7qHw?=
 =?us-ascii?Q?ByJOgJb2kjEdH8D2vtJOcSkloV9pl4iFSHN9mNVCdGU8xMQ4A8i6Thc2yPdx?=
 =?us-ascii?Q?qfYRTxbOV03oPppFIyvDJeOHGqm90pOmgiUZvEXw44BxoY3Kd4KflLrxbH7s?=
 =?us-ascii?Q?+RETbyDPo6QQ7+0zPi68qVoJimzOkqMoax8115CSUtL9eJuIZetGFMMye/1I?=
 =?us-ascii?Q?9QGmQgHEZit/uv2D3Uq8xAiHM4uM+vfcfn5bYLpNYtEQ1mwiUrMWV6iLTOjF?=
 =?us-ascii?Q?s4sioWD8rS3YISePvVsejWFsXW1nGig+DqLrgUX7NTASj0+uufM74HQDWWcj?=
 =?us-ascii?Q?quitTnPe0uL9Gq/R1Ye/J5GG8zoYotghVS93y+jG1aj6/fOchcjPo2XU15Cz?=
 =?us-ascii?Q?3IpMUQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bbfd1f-ab3a-4437-c073-08daa04d6e90
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 05:59:25.3627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4j3OO3eytUh+uyKv6P216bgzArzGT4xItuyqQyKO5EPt9/Zuy2qizC+NrayfdsfAu5hY9X57nyJNDbGnniYJzVcwvrTODmcQ2xKB9PkwCU6qcaELCeG0k9fkcgitOEP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9591
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Tuesday, September 27, 2022 4:18 AM
>=20
> On Mon, Sep 26, 2022 at 08:12:14AM +0000, Yoshihiro Shimoda wrote:
> > Hi Andrew,
> >
> > > From: Andrew Lunn, Sent: Friday, September 23, 2022 10:12 PM
> > >
> > > > +/* Forwarding engine block (MFWD) */
> > > > +static void rswitch_fwd_init(struct rswitch_private *priv)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	for (i =3D 0; i < RSWITCH_NUM_HW; i++) {
> > > > +		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
> > > > +		iowrite32(0, priv->addr + FWPBFC(i));
> > > > +	}
> > >
> > > What is RSWITCH_NUM_HW?
> >
> > I think the name is unclear...
> > Anyway, this hardware has 3 ethernet ports and 2 CPU ports.
> > So that the RSWITCH_NUM_HW is 5. Perhaps, RSWITCH_NUM_ALL_PORTS
> > is better name.
>=20
> How do the CPU ports differ to the other ports? When you mention CPU
> ports, it makes me wonder if this should be a DSA driver?

I compared a DSA diagram [1] and this Ethernet Switch and then
this switch differs than the DSA diagram:
- This switch has a feature which accesses DRAM directly like an "ethernet =
controller".
  I called this feature as "cpu port", but it might be incorrect.
- This switch has doesn't have any "control path". Instead of that, this sw=
itch
  is controled by registers via APB (internal bus) directly.

So, IIUC, this should not be a DSA driver.

[1] https://bootlin.com/blog/tag/dsa/

> Is there a public data sheet for this device?

Unfortunately, we have no public data sheet for this device.
But, I tried to figure this switch diagram about control/data paths as belo=
w:

Control path:
+--- R-Car S4-8 SoC -------------------------+
|                                            |
| CPU ---(APB bus)---+--- Ethernet Switch ---|---(MDIO)--------------+
|                    |                       |                       |
|                    +--- Ethernet SERDES    |              External Ethern=
et PHY --- RJ45
|                                            |
+--------------------------------------------+
Notes: The switch and SERDES have 3 ports of MDIO and SGMII.

Data Path:
+--- R-Car S4-8 SoC -------------------------------------------------------=
--+
|                                                                          =
  |
| CPU ---(AXI bus)---+--- DRAM        +--------+                           =
  |
|                    +---(cpu port)---|        |---(ether port)--- SERDES -=
--|---(SGMII)--- PHY --- RJ45
|                    |                | Switch |---(ether port)--- SERDES -=
--|---(SGMII)--- PHY --- RJ45
|                    +---(cpu port)---|        |---(ether port)--- SERDES -=
--|---(SGMII)--- PHY --- RJ45
|                                     +--------|                           =
  |
+--------------------------------------------------------------------------=
--+

The current driver only supports one of MDIO, cpu port and ethernet port, a=
nd it acts as an ethernet device.

> > Perhaps, since the current driver supports 1 ethernet port and 1 CPU po=
rt only,
> > I should modify this driver for the current condition strictly.
>=20
> I would suggest you support all three user ports. For an initial
> driver you don't need to support any sort of acceleration. You don't
> need any hardware bridging etc. That can be added later. Just three
> separated ports.

Thank you for your suggestion. However, supporting three user ports
is required to modify an external ethernet PHY driver.
(For now, a boot loader initialized the PHY, but one port only.)

The PHY is 88E2110 on my environment, so Linux has a driver in
drivers/net/phy/marvell10g.c. However, I guess this is related to
configuration of the PHY chip on the board, it needs to change
the host 7interface mode, but the driver doesn't support it for now.

So, I'd like to support three user ports later if possible...

> > > > +
> > > > +	for (i =3D 0; i < RSWITCH_NUM_ETHA; i++) {
> > >
> > > RSWITCH_NUM_ETHA appears to be the number of ports?
> >
> > Yes, this is number of ethernet ports.
>=20
> In the DSA world we call these user ports.

I got it.
However, when I read the dsa document of Linux kernel,
it seems to call DSA ports. Perhaps, I could misunderstand the document tho=
ugh...
https://docs.kernel.org/networking/dsa/dsa.html

> > > > +	kfree(c->skb);
> > > > +	c->skb =3D NULL;
> > >
> > > When i see code like this, i wonder why an API call like
> > > dev_kfree_skb() is not being used. I would suggest reaming this to
> > > something other than skb, which has a very well understood meaning.
> >
> > Perhaps, c->skbs is better name than just c->skb.
>=20
> Yes, that is O.K.

I got it. Thanks!

Best regards,
Yoshihiro Shimoda

>      Andrew
