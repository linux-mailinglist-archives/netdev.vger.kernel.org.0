Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBCB63418C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiKVQad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiKVQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:30:23 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2061.outbound.protection.outlook.com [40.107.22.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2669959845
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 08:30:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJRKaAvnCSwPDpkhgBUkDFFuYZAAWTdDi5cMQpu2ex3e+BfyBi9/Ee//AbWEKi1SWstZxXzlNug2L6xAupxzhYoP7OnlRqC70fbMz01kfU5eDHF79uNle16mv2cL8aN9Ns0pvo4a5JSYAFmLcvNoGul+6I0cdznniez41adMkouZBqJY20KN8j+/eOa6Qt4YlGuyfwi/ggSSCoakdzU0qEhOv2L8EGug3jVLqrpSCizHCGtCxuzyvemtoCYgjQE0K8A1e15cY9++zyZjRmexzbOxLIq8GjCxdAW+lhiZVDsnYbeh1o8txOLOj70nnOj6HN0f6Y4bqxl9Nr3KeULG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZ9pRPZToM/rs1NZS4iMH6GMBVBuSIn/DJNzCfs3orM=;
 b=K5Xs5XQfd+CBXvWA5AetBbko00W7XtbDgtrC8N4YUMBByxqBZPC2ji/jiksl8Wzm1ToV5bD84y/WCd0vJpSm0mZER9n4tmBhBbCfBuBgyLUH/xl2uId5GycNUDslqsLIE+j6KpptBb90532tzy0YAHTiUNIuBLslozS9U9sbK0KIeBIKAc03puVdykYeQJ7Cf+wVEnfgHPDfQqsynJCUHrAojecXCmjPwB4FlZzBFmN3sCK2zfL/M+MZJAL0x+f/fH+fTl+/bYJBcC2PvvFMoeaXpyH7b2akku+jjy2tXuGVJPnBZuHdfElWRZZPQLCRhTDEEFjygqKH6sATK6z+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZ9pRPZToM/rs1NZS4iMH6GMBVBuSIn/DJNzCfs3orM=;
 b=Eh5ZrlVirg+NWT57gdSYA5Nnd3YU9fh2ZHTrjokBDuJCoiaTaO5nLPcGjjX0FlpfH16XdHckDAIbI0IMhNtX0hKdtz6jhA3q47DIUns+XD9x3PunIn3AECMyKdKpd1Jb+lMM7TBZnZ5p638FuMBLHNXcztjvbYAuJEYCNI315rM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8255.eurprd04.prod.outlook.com (2603:10a6:102:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 16:30:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 16:30:16 +0000
Date:   Tue, 22 Nov 2022 18:30:12 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 0/8] Let phylink manage in-band AN for the PHY
Message-ID: <20221122163012.w5gsoawp22lc3nyl@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
 <20221121194444.ran2bec6fhfk72lt@skbuf>
 <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
 <20221122001700.hilrumuzc5ulkafi@skbuf>
 <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522f823f-70d2-d595-1f2b-1ca447c6f288@seco.com>
X-ClientProxiedBy: AM9P193CA0026.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f6768b-3ae5-4510-6c11-08dacca6d667
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /OX/KDLcaeDmOrG9t6QyUIrIf96iLZNLTo8A0ywk0zfs66nslSQQJP2e1RuFCGnBZehqbTr+hwJvfhdDFinXicvLnmT3FM7PBNbIkweRgy92rgaTZkRQg9Vz78lyRUU9bUjLPAwUMzlDs02SlWiFB0hUJsFkUli2FJTpR2pXm6QZz++w3zr353uBH/cyjxr4tyKlnS2clazuT9p4WUcxf3shoRWune9jqaOheAiNiBy4rsOxYP4uTSMjeaZsG2IeK1bzV2P1exNiBeWu4eiIkayiHonyLuM1ag888cMSwEBLLmyfyJUjft7gUGS0kkuTviabFjyQ4x78phLjfFCa0ZesiG1NfTnHZXtW5ra6dUCxaFjUclE89FC1uC6ldgq4jYgRrm4h1FaJH7GyRdqgBeb7qBKYdUwG7gE19xO/rN83Rtae1KjDAEIDkaC8wEOUd6TBRH1swhpaS9kNhplgg0yR7wUsS9IkxV8Ow4OL/1aUFl9aqdnUxmWKw4QxhCsT+5+DQVw/nCeOWiFHeMS7sZCCG+xwHNPyXectQuFasT0NX8cypkRxi0ONp2WDU/+betU+EtJBbNvX4pBu927Mi3uR7/MbL9Khp4Hc4USgxIThGbQ4tUd1p+G22Rgcz2+IWJ4yREbb6kc5Bb7MZSuYfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199015)(54906003)(8936002)(66946007)(66556008)(6916009)(8676002)(66476007)(316002)(4326008)(41300700001)(478600001)(6486002)(6666004)(53546011)(9686003)(26005)(6506007)(33716001)(5660300002)(83380400001)(6512007)(38100700002)(7416002)(86362001)(44832011)(1076003)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JF8tDq2vwn5efTU1CY0aWRSr8kmQFBG70LgmBH3SxMEFaDlbr4tE5vXAUDpL?=
 =?us-ascii?Q?xKGQKlkl5/hZyd/KQ/eQRaZVHwFj0TH9YHNJDpay6VzA71oEQ4Wp/cit4CW5?=
 =?us-ascii?Q?WBT/ZnojSxqgHK9CuwGa1HHf3DxfwGjuETJuaJycPERQmvBMuHpQTd+1DnKX?=
 =?us-ascii?Q?P1FStWGH6pxKmXCE/MwbHR/gVU1EfHIdXw/4i4jMsIWhxc9D/JNKhtTtRYJ6?=
 =?us-ascii?Q?YrwL5Zp8/j7zjtsZiV2N7Rr8+0TyrgN8CZn0HMv+XikA+7Ze9r0/Xr9nFeq1?=
 =?us-ascii?Q?s/5lqv8W2y6OFiLc/S1BGgZRDm4+iUT9gqBfEmpWT13YRkoFPkXCIZ+yUEHu?=
 =?us-ascii?Q?QaJMkC+Q2Iz/eBzECO5bHg/vCsuBM4+2b/2pFHkM3hsKYoILlzENN7TcGrnC?=
 =?us-ascii?Q?QObWbKGS5uziSnEtS0SKfPn1nhh6QE3gyhgkL6TvFzgp4i1ZcNo37rZpx+yh?=
 =?us-ascii?Q?i04OvglVQsEBMERIq4QyMjnuj1S8EXRUjkCtgTNfTr8LOgENr7KtFKTOF8Kw?=
 =?us-ascii?Q?MjbbX1ZlSlOeekx649gnoisaxQs/fmakpmvGHRq7lOtzn3tRlOK6/6R6mTaA?=
 =?us-ascii?Q?DffSBhds8rhPobtTH05F5ERWk+8Ae6GdMnHYpWS9/tPHNgpAaQQcoN2k4/Dq?=
 =?us-ascii?Q?lEp0sAd1sR+KApq1SV/TbKg2VJnfPzIqCdTDhIfyVO8O6zzBVBMIWit/x75p?=
 =?us-ascii?Q?o9A34KIQjaUu99TnScTOKNkelZ9E3CX/Ut0hi+IiZleioVBpQKiZBnM+XUIz?=
 =?us-ascii?Q?+foTZlg/A+fqdceuQ80ZtrvkbtS/nO3D0wGQc/8MlveRvGm4UCLdmf4nPabq?=
 =?us-ascii?Q?wXXq9KA9QLjtnbKaf7N3oH3zj28Ay0XLD1Lns65SwAoAS4nlHyEY7kpLQXDW?=
 =?us-ascii?Q?6dEYnifXPSjXZiW55YTkzl+8FcR1aR1tAhL7WxfOhzSGH7eBEQEgiYGIjmh4?=
 =?us-ascii?Q?XjKZdIiwufrp1mdfBlgvBnWi3sCXYS6v2mkR+bQQOuf3xBkM8A3I+RXwADgx?=
 =?us-ascii?Q?bZdP1uhGILsOFFbS+QxdwaNljdtuqairE0D/bYBp4LYqzkt8cWrpDhzSUvKb?=
 =?us-ascii?Q?QAilrd+hpc9dEUuRH2NVqbWveg4q5QvUWxuMeAz02q3NBI7Y6vwsq6/BTNql?=
 =?us-ascii?Q?uDr7fpHQMHLHY6rZ+wxMMvWXJ19yGY0L39DTHwTv/6UM1xZZrlBbKG39dKZ1?=
 =?us-ascii?Q?DVS964WWyhV8jwWwcl8wDOcIFr90UDXGYhu2SDjk/MwLnPg+ZjbTkFhy6xIG?=
 =?us-ascii?Q?fPqpodckGbRgituQDdoqPP2fSxJgAbLrWFXA41wIdCIvgZy24WrWN0/7fs0v?=
 =?us-ascii?Q?n+pPOfYEGFMLgXRrxyEJ54djEjw/8ErWUV+0eeiiS2zhRzzXoZPPlA9UnAlU?=
 =?us-ascii?Q?59da1rwhCCgaokd1NtiS3PHmsOGLFJmpuMEJpwMNEoNvW7mmKsSSEiE8Dv4W?=
 =?us-ascii?Q?QMm4qleG6XYSO5jOQA0JaE4zLzYoL6NJW8zPzGqZEaSjNFqGVkODPGrMXgEd?=
 =?us-ascii?Q?66opqDH6RA+VxfTIzH1U+nLKIoLZykJvwej7JjRx6ScYNR0/nEF6KY9jxz2h?=
 =?us-ascii?Q?mSj6b5lvDa832QO6Vfajm5s6QT9UfvO3G81B6x2sYT0ZB0ziqam2dwkTe7qZ?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f6768b-3ae5-4510-6c11-08dacca6d667
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 16:30:16.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sWguK76Nl90WyztugjF8Pxnmuu8Vqt15d6/B4cBjztWYu/2dJe5Bc13iaYe9Vt9ewy924T9tCcRqUMZuQBCxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8255
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:10:03AM -0500, Sean Anderson wrote:
> On 11/21/22 19:17, Vladimir Oltean wrote:
> > On Mon, Nov 21, 2022 at 05:42:44PM -0500, Sean Anderson wrote:
> >> Are you certain this is the cause of the issue? It's also possible that
> >> there is some errata for the PCS which is causing the issue. I have
> >> gotten no review/feedback from NXP regarding the phylink conversion
> >> (aside from acks for the cleanups).
> > 
> > Erratum which does what out of the ordinary? Your description of the
> > hardware failure seems consistent with the most plausible explanation
> > that doesn't involve any bugs.
> 
> Well, I don't have a setup which doesn't require in-band AN, so I can't
> say one way or the other where the problem lies. To me, the Lynx PCS is
> just as opaque as the phy.

ok.

> > If you enable C37/SGMII AN in the PCS (of the PHY or of the MAC) and AN
> > does not complete (because it's not enabled on the other end), that
> > system side of the link remains down. Which you don't see when you
> > operate in MLO_AN_PHY mode, because phylink only considers the PCS link
> > state in MLO_AN_INBAND mode. So this is why you see the link as up but
> > it doesn't work.
> 
> Actually, I checked the PCS manually in phy mode, and the link was up.
> I expected it to be down, so this was a bit surprising to me.

Well, if autoneg is disabled in the Lynx PCS (which it is in MLO_AN_PHY),
then the link should come up right away, as long as it can lock on some
symbols IIRC. It's a different story for the PHY PCS if autoneg is
enabled there. Still nothing surprising here, really.

> > To confirm whether I'm right or wrong, there's a separate SERDES
> > Interrupt Status Register at page 0xde1 offset 0x12, whose bit 4 is
> > "SERDES link status change" and bit 0 is "SERDES auto-negotiation error".
> > These bits should both be set when you double-read them (regardless of
> > IRQ enable I think) when your link is down with MLO_AN_PHY, but should
> > be cleared with MLO_AN_INBAND.
> 
> This register is always 0s for me...
> 
> >> This is used for SGMII to RGMII bridge mode (figure 4). It doesn't seem
> >> to contain useful information for UTP mode (figure 1).
> > 
> > So it would seem. It was a hasty read last time, sorry. Re-reading, the
> > field says that when it's set, the SGMII code word being transmitted is
> > "selected by the register" SGMII ANAR. And in the SGMII ANLPAR, you can
> > see what the MAC said.
> 
> ... possibly because of this.
> 
> That said, ANLPAR is 0x4001 (all reserved bits) when we use in-band:
> 
> [    8.191146] RTL8211F Gigabit Ethernet 0x0000000001afc000:04: INER=0000 INSR=0000 ANARSEL=0000 ANAR=0050 ANLPAR=4001
> 
> but all zeros without:
> 
> [   11.263245] RTL8211F Gigabit Ethernet 0x0000000001afc000:04: INER=0000 INSR=0000 ANARSEL=0000 ANAR=0050 ANLPAR=0000

So enabling in-band autoneg in the Lynx PCS does what you'd expect it to do.
I don't know why you don't get a "SERDES auto-negotiation error" bit in
the interrupt status register. Maybe you need to first enable it in the
interrupt enable register?! Who knows. Not sure how far it's worth
diving into this.

> It's all 1s when using RGMII. These bits are reserved, so it's not that
> interesting, but maybe these registers are not as useless as they seem.

Yeah, with RGMII I don't know if the PHY responds to the SERDES registers
over MDIO. All ones may mean the MDIO bus pull-ups.

> > Of course, it doesn't say what happens when the bit for software-driven
> > SGMII autoneg is *not* set, if the process can be at all bypassed.
> > I suppose now that it can't, otherwise the ANLPAR register could also be
> > writable over MDIO, they would have likely reused at least partly the
> > same mechanisms.
> > 
> >> > +	ret = phy_read_paged(phydev, 0xd08, RTL8211FS_SGMII_ANARSEL);
> >> 
> >> That said, you have to use the "Indirect access method" to access this
> >> register (per section 8.5). This is something like
> >> 
> >> #define RTL8211F_IAAR				0x1b
> >> #define RTL8211F_IADR				0x1c
> >> 
> >> #define RTL8211F_IAAR_PAGE			GENMASK(15, 4)
> >> #define RTL8211F_IAAR_REG			GENMASK(3, 1)
> >> #define INDIRECT_ADDRESS(page, reg) \
> >> 	(FIELD_PREP(RTL8211F_IAAR_PAGE, page) | \
> >> 	 FIELD_PREP(RTL8211F_IAAR_REG, reg - 16))
> >> 
> >> 	ret = phy_write_paged(phydev, 0xa43, RTL8211F_IAAR,
> >> 			      INDIRECT_ADDRESS(0xd08, RTL8211FS_SGMII_ANARSEL));
> >> 	if (ret < 0)
> >> 		return ret;
> >> 
> >> 	ret = phy_read_paged(phydev, 0xa43, RTL8211F_IADR);
> >> 	if (ret < 0)
> >> 		return ret;
> >> 
> >> I dumped the rest of the serdes registers using this method, but I
> >> didn't see anything interesting (all defaults).
> > 
> > I'm _really_ not sure where you got the "Indirect access method" via
> > registers 0x1b/0x1c from.
> 
> Huh. Looks like this is a second case of differing datasheets. Mine is
> revision 1.8 dated 2021-04-21. The documentation for indirect access was
> added in revision 1.7 dated 2020-07-08. Although it seems like the
> SERDES registers were also added in this revision, so maybe you just
> missed this section?

I have Rev. 1.2. dated July 2014. Either that, or I'm holding the book
upside down...

> > My datasheet for RTL8211FS doesn't show
> > offsets 0x1b and 0x1c in page 0xa43.
> 
> Neither does mine. These registers are only documented by reference from
> section 8.5. They also aren't named, so the above defines are my own
> coinage.
> 
> > Additionally, I cross-checked with
> > other registers that are accessed by the driver (like the Interrupt
> > Enable Register), and the driver access procedure -
> > phy_write_paged(phydev, 0xa42, RTL821x_INER, val) - seems to be pretty
> > much in line with what my datasheet shows.
> 
> | The SERDES related registers should be read and written through indirect
> | access method. The registers include Page 0xdc0 to Page 0xdcf and Page
> | 0xde0 to Page 0xdf0.
> 
> Each register accessed this way also has
> 
> | Note: This register requires indirect access.
> 
> below the register table.

Ok, possible. And none of the registers accessed by Linux using
phy_read_paged() / phy_write_paged() have the "indirect access" note?
Maybe it was a documentation update as you say, which I don't have.

> >> I think it would be better to just return PHY_AN_INBAND_ON when using
> >> SGMII.
> > 
> > Well, of course hardcoding PHY_AN_INBAND_ON in the driver is on the
> > table, if it isn't possible to alter this setting to the best of our
> > knowledge (or if it's implausible that someone modified it). And this
> > seems more and more like the case.
> 
> I meant something like
> 
> 	if (interface == PHY_INTERFACE_MODE_SGMII)
> 		return PHY_AN_INBAND_ON;
> 
> 	return PHY_AN_INBAND_UNKNOWN;

Absolutely, I understood the first time. So you confirm that such a
change makes your Lynx PCS promote to MLO_AN_INBAND, which makes the
RTL8211FS work, right?

> Although for RGMII, in-band status is (per MIICR2):
> 
> - Enabled by default
> - Disablable
> - Optional
> 
> So maybe we should do (PHY_AN_INBAND_ON | PHY_AN_INBAND_OFF) in that
> case. That said, RGMII in-band is not supported by phylink (yet).

Well, it kinda is. I even said this in one of the commit messages

|    net: phy: at803x: validate in-band autoneg for AT8031/AT8033
|
|    These PHYs also support RGMII, and for that mode, we report that in-band
|    AN is unknown, which means that phylink will not change the mode from
|    the device tree. Since commit d73ffc08824d ("net: phylink: allow
|    RGMII/RTBI in-band status"), RGMII in-band status is a thing, and I
|    don't want to meddle with that unless I have a reason for it.

Although I'd be much more comfortable for now if we could concentrate on
SERDES protocols. I'm not exactly sure what are the hardware state machines
and responsible standards for RGMII in-band status, what will happen on
settings mismatch (I know that NXP MACs fail to link up if we enable the
feature but we attach a switch and not a PHY to RGMII - see c76a97218dcb
("net: enetc: force the RGMII speed and duplex instead of operating in
inband mode") - but not much more). Essentially I don't know enough
right now to even attempt to make any generalizations. Although I suppose
a discussion could be started about it.
