Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D094C633135
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiKVARO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKVARM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:17:12 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6921E39D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:17:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVOumdbfJ2OCpOTmw0SPy62eBz0OAgEKMP85DIyWJvuFRXvi5PzROspKs3KIkXpMkzru01iHSX+L3xXHO8P7ipdqwb5lFwJM+J4PRPuDptF3KynGS+QApTHOtCN08AtIjvEN37Jbsz6ARHYtX4lOcANXid//S249ntJe3+xbLlWh1CRtch3adwG/P8ZpXacF82Uv7rlR0W9apuktxR6fZRkVGEdj2cSMxnAEnnV8gTW4oPVl2biajscSS5wPd9XluCmQGjQ1MJhZkBulsvRfn8gJtmCy7Z3WOGAMT2d3PUEVA/xvrP11WhteTolHhiJbKdoZMmuUDLH9gdWv1FmD5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcN1gERVPP5MJdCW//IlhmmOuQZHmLOVtrz8yrTYHqQ=;
 b=SsUwRoRnqVHGtsELtsVdGEUqsm+becwm1cmCEwv7cKAHdUQPSk9FwZDcUFr8MNTEElVMKQ0Nlq1V8mWJhGWrhU/P1mkm2Yanyqo9NojxclhY5KCvyLRvvz24SQA6nIidNzV6lkR+lmu9b3q65i206jnC486af47kSX+fDLAJ6nAVrzmBqQmghycWI6zkrM714e2itBs3CCquz8ehqEQUdmHW7/Ftw419iaimGZEICD/D4Smfpt/TcWGQTVUOSJriJ5ZVsuUYEI5h3JXH2kz+kf3DyCPBpWz7C61ttQ8vgYJ/VVxABbHYn0H+wTCeeeIcqgOCFb4tGcI14zSMnwJpBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcN1gERVPP5MJdCW//IlhmmOuQZHmLOVtrz8yrTYHqQ=;
 b=FXwxt517cdwArCPQrkrhPr6/VhHzVYQn9IwyK7Z7Wb2BtdA43uMr/1ERKSYCl4xKPg62KTg9w9QB+WRUb0uK2wkh3f39N4iozIClIuS94pe+FFODjiDteCkxOWrMbZA/X/ovwHlSZuoSLOUoxakpqHmbLSrY08XySNTX0y0BcJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8858.eurprd04.prod.outlook.com (2603:10a6:20b:409::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 00:17:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 00:17:05 +0000
Date:   Tue, 22 Nov 2022 02:17:00 +0200
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
Message-ID: <20221122001700.hilrumuzc5ulkafi@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <c1b102aa-1597-0552-641b-56a811a2520e@seco.com>
 <20221121194444.ran2bec6fhfk72lt@skbuf>
 <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf812ec-f59b-6f64-b1e0-0feb54138bad@seco.com>
X-ClientProxiedBy: BE1P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8858:EE_
X-MS-Office365-Filtering-Correlation-Id: 37176249-6b5f-4157-3d6d-08dacc1ee1f3
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMi08TVBC6eWrg3rl3yYGtJad0XqVdY5jxZCfX545wKLjAWfnLZL0Fdu7Koi/ZO5mhdpHoS/E8pvt6Yojw/l2gAPZ+YrpR65L933hGH9NEu8yrgqD1IHiQ3if1uI8VM0LhRhuhjShwou17GCiiSKPmZCDJNzmccz7MEYfEFfAcI34LLVrcnqT9Yt15S3Y7RqF+qpMZrxHudQO4EGeUGBrbd2sTlh8t2JhmTKy/Gl+jAiuiQ03dLVcRriDzAO9SvdN4RFo5oW9vH7C127m6+hFROMxU+bHBRbhkBO8rJkeikxjbemaqXcy1jkZMEGDGoYZLLJG31brOiPN0WzDBuZjDfv3TRiKYl85k1zXzyoL7c+6UkdojhtvL5j4Jx6hmkscLctatrNLY68Plo2Nzv2cPPDt4QQ8joflrrt1mntJcieGM8xa7BYi+MdbEO8xa0OeYQCU8q+6icdsr1RYRHCqjmhkB6y+pLxw1FOYlmQs8UfnablFh4mrdc8gP7ztsCItMsTsnz4N+GAyc18kCPc0NdiUdABcGeSG9MHX5OVxAWE9b960r4UV2DkVKvwscf+D7pwZVV2VmEEEke/LOKXp1n8XwWtpxK81NCO0GbHCVh4xisQM6lZatzEEpU2IEY7PuWsKSXlyz00RrY7xtw/zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(2906002)(316002)(7416002)(5660300002)(8936002)(41300700001)(9686003)(6512007)(86362001)(66946007)(4326008)(66476007)(8676002)(83380400001)(54906003)(6916009)(66556008)(33716001)(44832011)(38100700002)(1076003)(186003)(26005)(6666004)(478600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oaFEyNLlSPii0HR/qpvPIDxLlrNRoov/bY2hpf7mKbyrHlMQFYDmPuWKBwO3?=
 =?us-ascii?Q?XgUn/fITwtLJgi7p2xBkPbop2d69R2zLuikWN3L8PDZa6jt7rAWW/8bTJCE+?=
 =?us-ascii?Q?dfpvShty80+omlkn2oFkGUqnxtG4mzmNTQEKLh1wGLp0lpUaNTsnd79eJK+0?=
 =?us-ascii?Q?oBR1YpuujOhz9depk//QoYln3fX+xlTdvUmgQB+WgMIrH0x/2Pv42h04+HmV?=
 =?us-ascii?Q?Dydu/SiMOJd0m8NSYaZbGOL7Ji0ToFad9IQWEg1flJuoroTm3R2RcsxXGcc9?=
 =?us-ascii?Q?pNCdFoUNwlybvB6nr9PXdf5ub3Ckhh2j2iWP7YaJccbMQmLfNJ/xQJkeKU1u?=
 =?us-ascii?Q?cm3WggtSjGETZYMumfZq8uOr0aqTJbWe2mXqvq0b0jBJDzYjJXDXa6Xb6u/q?=
 =?us-ascii?Q?HXbqFmQapvKun5H2KdPZ5I+0mvPFaAwxGh9mDc37OgxGGmJVPJVg/zrK44Dr?=
 =?us-ascii?Q?NNMRUnsB3butWJRqW4E9RaGd1ha+ul/5CAMH8d2ISkDI1R+VXctSRAoKKieu?=
 =?us-ascii?Q?Mpi/r7Qg17trBMJyw4id5rC8YrNMzvwNO899bIvSQUJohpe05BDcwSFJQjsD?=
 =?us-ascii?Q?k7LHQ147dRERmrNN3ufAnCZPjLt0u6mGhAtp1jk38gYjz+NYMFI0BSNjcytv?=
 =?us-ascii?Q?/yEPilIoUk8vHY1I+3r6eszsbVgmPA+suCOM77h4maP0qnUMawYJuF0sihOv?=
 =?us-ascii?Q?QRzwgpwG3RH2cwxZKdIIz20zs3b5xu/RL2Z1M3+c839T7SWjuZ3EM86REnG2?=
 =?us-ascii?Q?rYjOnLHJyyatahT7NkKGx0bGpWyu9xr/FgrNKYKNtg8ZCmAON7nLdilRFzrK?=
 =?us-ascii?Q?kEYJWVZswiTv9UpjMRLlIMZnjvkO27xIAIT2mSWCoL0iPuvymbTlLKU9QBi/?=
 =?us-ascii?Q?erNyP4q6OMqRGaAMExkFFkdIsNi/YpetU7wzfPWsEMgH+7ynElkwwQJK6E90?=
 =?us-ascii?Q?b29DzJn2oSTHMaHYZ9eyHCCrwA4cNyZF3vv3wCAbrJaR4hc0AfseOtb/0VWc?=
 =?us-ascii?Q?ckel8HBzCsmLys2faEVA51bD8Bo/mJ6xQqVmz6cEp3ljj0dBQ9u1irUTdI5J?=
 =?us-ascii?Q?f+ssECOCgjHU4z2UKnfzfEwrT8VAWPhMNSS5H2ll+XAV8VgROhwNNSZMKYUe?=
 =?us-ascii?Q?GpuFKeg5EeBRA8/tH95POxZZjOwPRFy8atkdVJUQSL2as6U7tn+FS60xmtw1?=
 =?us-ascii?Q?tjX/IX18E3zTGKGfipvtYA6G5jM7tQ+4xKMyUiigyfg/RpNGM53tGMiDX1np?=
 =?us-ascii?Q?0FaDugxacOkC+QloZsVw5XzIMZDfpoxrLxcgEeYabE8vAx6nsxavg+6KoKaz?=
 =?us-ascii?Q?XGSipkpFL9oauqCBjnaBVtqrMNmYr0Dz9VIB7ic3hyx+pGex5GjG3HtMp8wP?=
 =?us-ascii?Q?R+QMXqkHRYGM/24vPLmIV455FYZiAIvHHmlBj2eEse7hSCvvv6nzJB4kwfuH?=
 =?us-ascii?Q?UL6pOoXBNHAwTWeA6GN6pmOfkeUWrZd+M3FUY/7dKu9bcplMfH97uQtXH+iM?=
 =?us-ascii?Q?T3Gs5Ujm3O9Yulko0/zrN1F0wla15uyHPm7Hm0Q5ZL5TZzRIxIk5orOyPsFL?=
 =?us-ascii?Q?fzKIki/qZRXv/2A1cJfVKTFzQj3fvYNJP0B8iCdqsFobEYx4aWbAAGXyBgu+?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37176249-6b5f-4157-3d6d-08dacc1ee1f3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 00:17:04.9807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTjBmdxJqXkjN/+IyboxoPCejTMZtn3DNF8HgJMlmSg88p1Z/am/V7l5TWNW6LqMMtz/SLvUk1IR286HQ2J/jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8858
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 05:42:44PM -0500, Sean Anderson wrote:
> Are you certain this is the cause of the issue? It's also possible that
> there is some errata for the PCS which is causing the issue. I have
> gotten no review/feedback from NXP regarding the phylink conversion
> (aside from acks for the cleanups).

Erratum which does what out of the ordinary? Your description of the
hardware failure seems consistent with the most plausible explanation
that doesn't involve any bugs.

If you enable C37/SGMII AN in the PCS (of the PHY or of the MAC) and AN
does not complete (because it's not enabled on the other end), that
system side of the link remains down. Which you don't see when you
operate in MLO_AN_PHY mode, because phylink only considers the PCS link
state in MLO_AN_INBAND mode. So this is why you see the link as up but
it doesn't work.

To confirm whether I'm right or wrong, there's a separate SERDES
Interrupt Status Register at page 0xde1 offset 0x12, whose bit 4 is
"SERDES link status change" and bit 0 is "SERDES auto-negotiation error".
These bits should both be set when you double-read them (regardless of
IRQ enable I think) when your link is down with MLO_AN_PHY, but should
be cleared with MLO_AN_INBAND.

> This is used for SGMII to RGMII bridge mode (figure 4). It doesn't seem
> to contain useful information for UTP mode (figure 1).

So it would seem. It was a hasty read last time, sorry. Re-reading, the
field says that when it's set, the SGMII code word being transmitted is
"selected by the register" SGMII ANAR. And in the SGMII ANLPAR, you can
see what the MAC said.

Of course, it doesn't say what happens when the bit for software-driven
SGMII autoneg is *not* set, if the process can be at all bypassed.
I suppose now that it can't, otherwise the ANLPAR register could also be
writable over MDIO, they would have likely reused at least partly the
same mechanisms.

> > +	ret = phy_read_paged(phydev, 0xd08, RTL8211FS_SGMII_ANARSEL);
> 
> That said, you have to use the "Indirect access method" to access this
> register (per section 8.5). This is something like
> 
> #define RTL8211F_IAAR				0x1b
> #define RTL8211F_IADR				0x1c
> 
> #define RTL8211F_IAAR_PAGE			GENMASK(15, 4)
> #define RTL8211F_IAAR_REG			GENMASK(3, 1)
> #define INDIRECT_ADDRESS(page, reg) \
> 	(FIELD_PREP(RTL8211F_IAAR_PAGE, page) | \
> 	 FIELD_PREP(RTL8211F_IAAR_REG, reg - 16))
> 
> 	ret = phy_write_paged(phydev, 0xa43, RTL8211F_IAAR,
> 			      INDIRECT_ADDRESS(0xd08, RTL8211FS_SGMII_ANARSEL));
> 	if (ret < 0)
> 		return ret;
> 
> 	ret = phy_read_paged(phydev, 0xa43, RTL8211F_IADR);
> 	if (ret < 0)
> 		return ret;
> 
> I dumped the rest of the serdes registers using this method, but I
> didn't see anything interesting (all defaults).

I'm _really_ not sure where you got the "Indirect access method" via
registers 0x1b/0x1c from. My datasheet for RTL8211FS doesn't show
offsets 0x1b and 0x1c in page 0xa43. Additionally, I cross-checked with
other registers that are accessed by the driver (like the Interrupt
Enable Register), and the driver access procedure -
phy_write_paged(phydev, 0xa42, RTL821x_INER, val) - seems to be pretty
much in line with what my datasheet shows.

> I think it would be better to just return PHY_AN_INBAND_ON when using
> SGMII.

Well, of course hardcoding PHY_AN_INBAND_ON in the driver is on the
table, if it isn't possible to alter this setting to the best of our
knowledge (or if it's implausible that someone modified it). And this
seems more and more like the case.
