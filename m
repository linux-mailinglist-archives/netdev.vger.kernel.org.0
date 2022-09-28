Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE035ED460
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 07:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiI1Fxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 01:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiI1Fxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 01:53:53 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2119.outbound.protection.outlook.com [40.107.113.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C1910F731;
        Tue, 27 Sep 2022 22:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APsGZq+VeRbs+Vd80HF1pFmL7dkgSCbsg9I+KHmrPB776FFWS5eTLqF0uuC0k+8waaWxv4GfTIYcqSUv4RZagY51Fv6Lkz8vbrZuArsoLiEAx2A2G8lIW/TqkdohMxVZeI1SRASJ2mWTgUzXyHxManFqjbF74sv6RXVg7jeHyCYEdllwEXk96piJZie9PMa2n4+2Q8BsQKYAdQWsAqBT1ClU6Lu+N60sKjymyYyEllHMuN2X4VPni11dpSLXxYQj6SKBRKrNhGbyeBuWlMFnKeuSwgZNgM3k/3FTJ39KiNmAjAZoIW2KWDLnpB6r6p7X82A3QA/Ik8B1jLiKJ2+bzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tBtEMs62LPnRO3/ejyJV51Nr2uGsksbAjhV48edUUs=;
 b=ROjycBLpTXM9C+RI1WbirleikaPNQyZ0VfwK8mP7Jgrwp5WnRkg8Fv7GC72reifMYUIe8uy0C9W5IAlOCqyvm2BPC1RKzws+s7RJO0yjccwxdEiv5u3OHd9GaSnOGTyrqu2ccyeQII/HQAZpwM8ULtvmI8ECfK7x1G+lKLk3ptkxcN1uENkLBfia02Vtkl/pgL4bTwjUfhbRRDxsa1LNL7M8A88bFAzBcaAGApy6ni5nrRthM0jPxpdjg+a5UFMmshs0A7cNS1EfrsZQo7U4VkmRAcHJ9ZZCAQyCtpNatNtXrn2ndsOdJdga9dQLsScP/1SZdt98IP2c6AviSfle3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tBtEMs62LPnRO3/ejyJV51Nr2uGsksbAjhV48edUUs=;
 b=YHxZfN7o/zsZqMjJunjv+eOEPu0Igfs31oFckyRDQ4GFP7TObN1CQ6RqxzRMje/hw2asszPIfYpItop0Si5+BlCJgMN3DZZCI36lnLFDGeltbiVvEtlPA2/4gtqcrjBKtr6gMa75kR+0acbi8kpVQe3z6AyAET24TOTRuTseoGY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9391.jpnprd01.prod.outlook.com
 (2603:1096:400:1a2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Wed, 28 Sep
 2022 05:53:49 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 05:53:49 +0000
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
Thread-Index: AQHYzkQbCGZNTw1MNUuaNx/SR8stKK3s/34AgARIsfCAANSngIAAruVQgAB4MACAAQobwA==
Date:   Wed, 28 Sep 2022 05:53:48 +0000
Message-ID: <TYBPR01MB53419D2076953EB3480BC301D8549@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
 <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzLybsJBIHtbQOwE@lunn.ch>
In-Reply-To: <YzLybsJBIHtbQOwE@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9391:EE_
x-ms-office365-filtering-correlation-id: 1f96523f-ccfd-496d-5a5e-08daa115d077
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: syfgYH9FnHUtYPVokGj2YoqxLU8V4gSh5gUEZY09zoYFMqBckTY71xDQyQB+ae9t6bLMFTmPNd5dQ0JXNhU4PjM20zDZfSqrkJczoIXJrmjuX5qyDAgTJ6Lk5b8LblviIb2FjP4fBcZD+NVROFUyt3xrPpJ+pC4IDAdduMU8e2B71J1xtu5hcfDYF6MsgQ9OC67AS2P1U4WQ9Yl8FP8TS53F3krhtPVgJv3hqDr4CofwLdbp6ueaJIeTPD2PC1zkXFbzSRBOuR5nA10PoGBh0BKl+bLMHj2Q+KlGI1XfRp75iK/r62gEQ8zoXU17+68rmqLXhkXv6yGUsTJFeGD0EYfpBLVSP7RFjwK4eJjWxqXhNm90LLxF3q0INCxyGlEIqVqWkGVeyoAzKnqyPxURah4Vq3VNps3GGXvz7xKULcu15Rc/jg3EJlYA3Sxj27B/STchH4kg41ZZTml+BfpyLzlasSZ03lY1oG3seL8XR0r96skicWGWE2IXJ8LBtyEgEu9yJRqnzYORHM+xaVEMoyJ2cahfvQMmhG2Fzyw0aRIb84UCK1J+uk6EtveoyQyfeVETKG96WoV/e+hnK+JytKU+cFfsSMeEnsuc5+a3mTk8jRUkQNXrajGCJDZET4L2FWE9hJhiJdThIYfn99yksSizvLFlQ0CRSI4JpQh1K3zzL9Y+Y4yGInb6AE3cuhXPDdjWzExVsDUZcM81PxHLTe10lB1AMfbPQLRTxDJjY/NcqNMCULYFN+oRjxtVJs1IT6auaNCuVck3n0JbshABYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199015)(86362001)(64756008)(66476007)(66556008)(76116006)(8936002)(52536014)(5660300002)(33656002)(2906002)(41300700001)(8676002)(66946007)(4326008)(66446008)(6916009)(54906003)(316002)(55016003)(7416002)(38070700005)(122000001)(83380400001)(38100700002)(6506007)(71200400001)(9686003)(26005)(7696005)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vv/hgaeR4knwbRRHCeD1H4GBwy2IdtSgRm6Uz+GU4fqY/JzOtNeaOQtmUtVA?=
 =?us-ascii?Q?RdTRjWg+OiZS5qHRajjsQhOYWi93RvPuGsR6iFAdkJ8kmcZS9oDb9RIxYRJ+?=
 =?us-ascii?Q?8IlMpr7rG60dO1W9P5akwWNcOqNTz8BwFg+OkHg1ccqdKHvjy2I/soy/ICB/?=
 =?us-ascii?Q?FEuCWJpbuodJR+i628Kxe1rrZ0B0RHBPo7f8GCUr1A3+aPHbGVWDgUh8z84o?=
 =?us-ascii?Q?PLKzn3UUlv/7cGDEwvG50WTTdkj77CWRyXkiVM/Y6eo8+mJ2OfPVcLsat8iD?=
 =?us-ascii?Q?iFeWeP+/Z8iGN1O599nTsBwAcKI1esoZCLmxKS3EJ2KwPl38pL99SCpxKDBL?=
 =?us-ascii?Q?ryspzfObg8Qr81IeHNXKAKquv+XB2q2KYmtS3pVWMU/MDlDLvDigc0pEaLno?=
 =?us-ascii?Q?z9uPMXsAiQbrNfGOtoi8JXL4og9qfr1gUFmiYfwqMKq69DiDyOVsQ8Rvvn6Q?=
 =?us-ascii?Q?Qc19JX8BUObKoCFcekuXUpEHRMjsxZbDxgUG1uDzfZU4fGLjoh3/vdge+LLl?=
 =?us-ascii?Q?ubCa6kxtV7Mkjp/XNJ5s0F0NZhtl61mXuJ13QzGPk/69/UkxAlO+WA44Cs2b?=
 =?us-ascii?Q?cQnGz08tztFWTQyuJA/2advF5V7zV6ljOKYb+wpTrz6ePt+yRlf86BYqZnta?=
 =?us-ascii?Q?SEhNRToHCFs4q8zqHJ22or+8vBVK/Qeck+BFaDGi9mC9uVv20gtl5EpWcbx3?=
 =?us-ascii?Q?mwIxB+6EyLjyme9RKXisPTKdJG7iHi8kZCFVdBHJ4VC3/XipqawODw/eOisZ?=
 =?us-ascii?Q?cM37M34b2KZ3divr7SGFz/EwJnCFWi819qxZZ8IBvSAUxqVNn+RKz717JOoA?=
 =?us-ascii?Q?wxnaXlVQ4vj98ZGlr6/NJsQhp2+3VxiwsCudAzJ0BGpQCa+pIAl/irpJyfLg?=
 =?us-ascii?Q?sR4KxnDmKryISA8ZzzDrVXxOqv0RvUKvbvVPDUsbBZn1Vpr32qzWTqEu2OAX?=
 =?us-ascii?Q?bw0m7cjQ5QYgwDMAAdmtwPeKFWffSBH1sR6B4KPlMYOjZZufM3WAOYJ6U4pU?=
 =?us-ascii?Q?Tni+g8II6j4pOiB8CNSsLukd3LxzxRGn+1Eicuo8zPISQBp8c3Tase0ISRMN?=
 =?us-ascii?Q?zc4ZL1mThjDDZx0xvczEfpb9atuwPJV4KN1m2n/uZsNqS/5bn3RMdYktLkRE?=
 =?us-ascii?Q?6sX/KdJKCH0iaNKXVS4kFZoZl2ZEtPAIZKB5dsGjBStZUKQmW5uuBbF4ZNRo?=
 =?us-ascii?Q?GUk6xTPyEyrAug92t8eR5/WR3xBQi1q8g2ydqO4y5/X9CXi1FqaJ6FdijIc/?=
 =?us-ascii?Q?OS4mY5Px1Ee1eInJx568KY9HjtYdN96GWSoSyDIxnFTrkxA4p6jQhPZIeKX+?=
 =?us-ascii?Q?uU5yeLlK6/i5CeGxrgo3TKs+YtimHe1reo5o+EYcAtvXnxRMe42vPvI8sM+r?=
 =?us-ascii?Q?0BZRzEBgeJ4ILUJF1eKCjgk9ms/WarSVcU3mTTrwLsk9AbYPrYn43djghFUy?=
 =?us-ascii?Q?cNAWrNrsyGGfSgb75pDQaqY+A66XGDnmikXrA84H45QBUHpqP1M9ueJIKHTv?=
 =?us-ascii?Q?UvVKb4qcIyYQKXBTf00JzxIUksXKKNjRFw29dmIB2BE2tdWg40fxJDMCnQ8e?=
 =?us-ascii?Q?ASpzKDFCZks72aKlNalj7sr7pZAwjGP4MM2NY8nsn9WsAE7MAtabLjicEr8h?=
 =?us-ascii?Q?7A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f96523f-ccfd-496d-5a5e-08daa115d077
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 05:53:49.0058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xv0+nrg258SUaolKPYWsY1qlIzoGB7/MeNtmcEYp7gofZAcp+q+FC0tJGXf7ZZbwr3XVPGaFyf5OFV0HG9oVHk2bdhg9C9ysT69T6TqZb0L1oVJ0lGDs+w9J7zw+BpdO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9391
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

> From: Andrew Lunn, Sent: Tuesday, September 27, 2022 9:54 PM
>=20
> > > How do the CPU ports differ to the other ports? When you mention CPU
> > > ports, it makes me wonder if this should be a DSA driver?
> >
> > I compared a DSA diagram [1] and this Ethernet Switch and then
> > this switch differs than the DSA diagram:
> > - This switch has a feature which accesses DRAM directly like an "ether=
net controller".
> >   I called this feature as "cpu port", but it might be incorrect.
> > - This switch has doesn't have any "control path". Instead of that, thi=
s switch
> >   is controled by registers via APB (internal bus) directly.
> >
> > So, IIUC, this should not be a DSA driver.
> >
> > [1] <snip>
> >
> > > Is there a public data sheet for this device?
> >
> > Unfortunately, we have no public data sheet for this device.
> > But, I tried to figure this switch diagram about control/data paths as =
below:
> >
> > Control path:
> > +--- R-Car S4-8 SoC -------------------------+
> > |                                            |
> > | CPU ---(APB bus)---+--- Ethernet Switch ---|---(MDIO)--------------+
> > |                    |                       |                       |
> > |                    +--- Ethernet SERDES    |              External Et=
hernet PHY --- RJ45
> > |                                            |
> > +--------------------------------------------+
> > Notes: The switch and SERDES have 3 ports of MDIO and SGMII.
> >
> > Data Path:
> > +--- R-Car S4-8 SoC ---------------------------------------------------=
------+
> > |                                                                      =
      |
> > | CPU ---(AXI bus)---+--- DRAM        +--------+                       =
      |
> > |                    +---(cpu port)---|        |---(ether port)--- SERD=
ES ---|---(SGMII)--- PHY --- RJ45
> > |                    |                | Switch |---(ether port)--- SERD=
ES ---|---(SGMII)--- PHY --- RJ45
> > |                    +---(cpu port)---|        |---(ether port)--- SERD=
ES ---|---(SGMII)--- PHY --- RJ45
> > |                                     +--------|                       =
      |
> > +----------------------------------------------------------------------=
------+
>=20
> This device is somewhere between a DSA switch and a pure switchdev
> switch. It probably could be modelled as a DSA switch.

I got it.

> For a pure switchdev switch, you have a set of DMA channels per user
> port. So with 3 user ports, i would expect there to be three sets of
> RX and TX DMA rings. Frames from the CPU would go directly to the user
> ports, bypassing the switch.

I got it.

> For this hardware, how are the rings organised? Are the rings for the
> CPU ports, or for the user ports?

The rings are for CPU ports.

> How do you direct a frame from the
> CPU out a specific user port? Via the DMA ring you place it into, or
> do you need a tag on the frame to indicate its egress port?

Via the DMA ring.

> The memory mapping of the registers is not really an issue. The
> B52/SF2 can have memory mapped registers.

I got it.

> > The current driver only supports one of MDIO, cpu port and ethernet por=
t, and it acts as an ethernet device.
> >
> > > > Perhaps, since the current driver supports 1 ethernet port and 1 CP=
U port only,
> > > > I should modify this driver for the current condition strictly.
> > >
> > > I would suggest you support all three user ports. For an initial
> > > driver you don't need to support any sort of acceleration. You don't
> > > need any hardware bridging etc. That can be added later. Just three
> > > separated ports.
> >
> > Thank you for your suggestion. However, supporting three user ports
> > is required to modify an external ethernet PHY driver.
> > (For now, a boot loader initialized the PHY, but one port only.)
> >
> > The PHY is 88E2110 on my environment, so Linux has a driver in
> > drivers/net/phy/marvell10g.c. However, I guess this is related to
> > configuration of the PHY chip on the board, it needs to change
> > the host 7interface mode, but the driver doesn't support it for now.
>=20
> Please give us more details. The marvell10g driver will change its
> host side depending on the result of the line side negotiation. It
> changes the value of phydev->interface to indicate what is it doing on
> its host side, and you have some control over what modes it will use
> on the host side. You can probably define its initial host side mode
> via phy-mode in DT.

I'm sorry, my explanation was completely wrong.
My environment needs to change default MAC speed from 2.5G/5G to 1000M.
The register of 88E2110 is 31.F000.7:6. And sets the register to "10" (1000=
 Mbps).
(Default value of the register is "11" (Speed controlled by other register)=
.)

> Also, relying on the bootloader is a bad idea. People like to change
> the bootloader, upgrade it for new features, etc. In the ARM world we
> try to avoid any dependency on the bootloader.

Indeed. So, I'll try to modify the marvell driver somehow.

> > > In the DSA world we call these user ports.
> >
> > I got it.
> > However, when I read the dsa document of Linux kernel,
> > it seems to call DSA ports. Perhaps, I could misunderstand the document=
 though...
> >
>=20
> DSA has four classes of ports:
>=20
> User ports:   connected to the outside world
> CPU ports:    connected to the SoC
> DSA ports:    connecting between switches. If you have two switches and w=
ant
>               to combine them into one cluster, you use DSA ports between
> 	      them.
> Unused ports: Physically exist, but are unused in the board design.

Thank you for the detailed. I understood it.

Best regards,
Yoshihiro Shimoda

>        Andrew
