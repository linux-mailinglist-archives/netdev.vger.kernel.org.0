Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4030869A30A
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjBQAm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjBQAmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:42:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2114.outbound.protection.outlook.com [40.107.92.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACA654D5F;
        Thu, 16 Feb 2023 16:42:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpXiWU7uOPY43oDVchSiiIiBeDMxMVJp1ZDKBsjRcCzFYUUQdBZ3MdpVvOsPjd6GNvl9MT91uzd9E5DB7pClhNK4g6pb5Q0pEFKz2apuaWu3ADwxZ3s1fKaAS1c7UxCaoA3tVI/Umr2TnzaHzP63CKujbdXm2aqmDwGzd2gdm79l+9zywoDxKzHnL7MDo5klyD82ErAriMpFQSdLHhtIWcRAjmo1jVJllO7bOibZ5ZAMQK7l69AtEfJzpukH4mlIH43lrKdcclfUFFefVA1+Fjz9YdEwHFswZA2OSwbp4YQhu3KNLTDzR+Zl3spUHOcKg/tV4QZAhDD2802IWZrYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nt56ySHkiXdPFlwQqfnD4AQmdPCaz+9Q+sDsqFXeKiA=;
 b=kt3YJs2v7HdaCMgZhy0XXhKXzfgywdXP0wULzatWrNVWj+g+knk2tO9AS3ll52bzt1u8iuD2CU3NcwiJIyKbFXKiO7mNJxEZE4QLM+Fl/bHgCtl8Zk3PGyffoOzUF5B94pbSiL77IR03YpNvxah3YyCzcSbL4FyFG/b7U1MF9XXvz9r4nDTpmv9x+TUa6ill0hI68L/44vIcKJFRj15jp8mRoIoO71s7/zhlLW+fkbXupYOIOZBbQjW9IMp5mnnp6VM2bX4qgnU+7r/vPMHZ9UoIvYKzkbgz+h2XyzKQ9OjZzrJCvo0CciAusJT+SYg5W/06cgrDM1gvZSYM52WuTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nt56ySHkiXdPFlwQqfnD4AQmdPCaz+9Q+sDsqFXeKiA=;
 b=qGmq7HrrD1wY42EPdTxRBzCaN0FHW0wzHdLwqSr02EHkdni2VW4voyfbcJgs2vnvzT15yw6LYNgSy7Ny7l65a+icCSOym4pK3UyrC6NTWE1hh3hoAePz5Yn/jKzkEYPDkRKTVIIgrFp7EG9D1TPVuIvQ87tbdDM16YB4UuAzcK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4796.namprd10.prod.outlook.com
 (2603:10b6:806:115::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Fri, 17 Feb
 2023 00:42:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Fri, 17 Feb 2023
 00:42:11 +0000
Date:   Thu, 16 Feb 2023 16:42:06 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 0/7] add support for ocelot external ports
Message-ID: <Y+7NXoFTBYVG3/+b@colin-ia-desktop>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <Y+4eLmpX9oX3JBVJ@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+4eLmpX9oX3JBVJ@shell.armlinux.org.uk>
X-ClientProxiedBy: BY3PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:217::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: ed64e078-d037-4c36-d105-08db107fcdf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tp8IuJ/5Ej9iBK1Z68ym5DxRjA2x+Cubl/gOOOiyFhR7UgfpRm9EjT/DYRd+Ap2dhOGETuGqqiEfxD22pvphRAJI0ePKdDZH/91FcvwagjjEMcS0wjc8X/hlzskqo91GC1v1nEO/2qLtNluSFdIg/0jKaXc84T28kK3+pAnmLKluXJHPDC6Ec2yQPmL1u2muAd6ZzkpwgKVHpTppTRiQOP8xLmxTA55MtfzeNIDLgqQzahJ/nCQLcPzIb71w8MD0afBRyG/MaaiqmNMPnspvmZPJcqB3V5ce+7Nkk6VvNS/9N/ytABMRqievLGp5lykoHzj2eLllQh6NVeiSEw0VYFO2Qx470c8ridHIllqo10lhDhM/wRJmRZw/oZsyiDk07N1IbX5Nd/+NKgg8A1We9hhiy8DW6fA7GPmvxRADZ+oZSgW7fYZXnR+P8XmlgfqCIeXThLmfra4j/mJOtDGLgNDUCNqGrIJdww+AUw7rxmCMfJd/oKBYzyDuo0r6YEjI1utoJT0W/HimKsI4c+Y81e5ghDEE9Pz+7aQKvzWzlxdEBw2qZ54oyeG6pdpxeZ+xa1FvTA8Z4O8YyfBrHB/xGkyXXz9bxRi2SJwkxZpkT1wyu7znKr8rjPiO440iHwac
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(366004)(376002)(39830400003)(396003)(346002)(451199018)(5660300002)(6666004)(9686003)(44832011)(26005)(6512007)(186003)(6506007)(316002)(54906003)(6486002)(966005)(83380400001)(8676002)(6916009)(4326008)(478600001)(41300700001)(7416002)(8936002)(66946007)(2906002)(66476007)(38100700002)(66556008)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RyUgqs6Gg/n1cX8uXgBIGLUyhZ/jZTvz6f67ryRWuQ22buN8RaAAOqlCctnm?=
 =?us-ascii?Q?lo0oQaoU+M0Guv+I4IVDHSVX7eDNWIDEO8NGgPLSjjSipqFJnaRvBcUpmCnk?=
 =?us-ascii?Q?1arHJHGxNxta4yEdbn/00fbq2RN7JV2H4VqmhEpNq8897lcOvjgHfQNF+ChE?=
 =?us-ascii?Q?74dVbJPJRQ48RhopIsF69NKIT9GvZw6Ut4tLpd/Qrwnq/yjIqzYNbTHkJ6XU?=
 =?us-ascii?Q?FALSJj6Q8vYK45adAFz/PTvH1l3acXTGIsgY1+67DtWNQcN0y9B+oMJAYvye?=
 =?us-ascii?Q?72kAnD3W3TdtTk0azE2e6Z3qUyVGjjG867FC3I6nTEfZeEUQZKdN/fwWY63o?=
 =?us-ascii?Q?4tFdpP1zzOEx7+8kJ9lCCXKDDG4SfbvG/bfXOAqwCxBDJzOcA3DDqQUnhglg?=
 =?us-ascii?Q?3HdNM1nHKIxvkL7S16awarcEiv8XHXfFMmWpeLd9KQrJG8eZN6OTOv/MJu7x?=
 =?us-ascii?Q?Q0lDkIhXxqftqgB9T7pBBERBpTFPU9dLFY7hzthX27nK0oV6L/6vXRXZLgvf?=
 =?us-ascii?Q?/RVMAszO93m4shog/HZ+xydo9Z8dIDl2sqgHtgHZdjqtQjfIMilPA6u5pWLi?=
 =?us-ascii?Q?UZuk8Di/HZx0FG6CK3HQ6ifUtUnmOl2y523oLMOsvk7DeHzBH/wG6pXMZiou?=
 =?us-ascii?Q?UNJiq6v08cwdCfRJ55iHSFvy5VxjCFVSzDxQz82ePQw8P4taDXSvdMshNb7K?=
 =?us-ascii?Q?Egr6Hg62uuH9tHpUgPJx48ImF1bF3aY0Xh9u+OOP0pfxhivJs81oPOwqEMYK?=
 =?us-ascii?Q?wvJRzWcyq1lENYX+78gDA4RnU7b9+tRlp8IUcbjKV9h/UPTmfqKtNvFu5lUZ?=
 =?us-ascii?Q?EGzFn1Fepqo0oqy9PjrRLOiIuYg+GJeQqsQyD2LLuJVpesh1RDjvkb3Vi5z9?=
 =?us-ascii?Q?JDKchT/15XMsuD09CCbyPmyhKDUdAoXECs6rvhC7fFmNpvz+Db+B1cqCEErG?=
 =?us-ascii?Q?IzIweQPB/cdO3iOZS5IeyF/zk/f0pEtVTPZjDkz+z+LrROIdsVnXOK8tDtwk?=
 =?us-ascii?Q?rfcrT2Pzq/gvfpQdH36jHyX/QuhKQRiSb4HFkt0ycEMIV/WdG82iveyeZKf3?=
 =?us-ascii?Q?3CHnxEoyxSPvxWGOyJz71gouM1wQJ77lMSo62QQnsT7EJGidX2T5t/4RHlUN?=
 =?us-ascii?Q?0vXGY07SCKKNhsYMqWNM2f4mOPI8aBqB/Xh5aaVJTN/us3rkUlHl3xnVlHjc?=
 =?us-ascii?Q?pB4iHnCUJ3jCsg3h6WSA8F1Hfn7rHp7gg3cd+W6Nkh7WplpOgWWGOFc3IJYK?=
 =?us-ascii?Q?A4wJGBCs/ikdnRXCfUxvEy/21mjusdyIkVvTSe5j8ml+8m9u5rasRe9PV2Lo?=
 =?us-ascii?Q?J3tbR0Aag6vW3qMi1/CNBIoQ9HnrmoHxmWa5ySSja0OYVqj3US8rLhR8cw3E?=
 =?us-ascii?Q?/bIFADPTMMf4N8SDY8wD0KQGFYU2smDxCbz5Xnp6jQ5Jip53J6/V5GCrwiQS?=
 =?us-ascii?Q?U6ketAC5thIRs8L4mrtKJ069BVlardvyHIanDxYtrpyKnNxHeAu8Qanq6bzQ?=
 =?us-ascii?Q?2EM8Moh7+EdKrXxdgkkP13hzx9ss+93jQFUkZXq0LdXFQclpilMYxFW/Frc1?=
 =?us-ascii?Q?LU69Lyg2GKCWaKW6gCVILbUoZCazq3HP8hFVQYoPXtRd+Ds7s6JFhpb2Wdiu?=
 =?us-ascii?Q?GcU0KClJiEObQD3OQCTT32Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed64e078-d037-4c36-d105-08db107fcdf0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 00:42:11.0996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Ln1qlzW7v74DIIsqpe8HTN8wm/2nvgn8BvLAwPnm3Cvln188jO6HcyRJm5y25JNcyrVnOtk2anfStUAG/30Z/a+eZpilg5o7Qxelo0Jfhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, Feb 16, 2023 at 12:14:38PM +0000, Russell King (Oracle) wrote:
> On Wed, Feb 15, 2023 at 11:53:14PM -0800, Colin Foster wrote:
> > Part 3 will, at a minimum, add support for ports 4-7, which are
> > configured to use QSGMII to an external phy (Return Of The QSGMII). With
> > any luck, and some guidance, support for SGMII, SFPs, etc. will also be
> > part of this series.
> > 
> > 
> > This patch series is absolutely an RFC at this point. While all 8 copper
> > ports on the VSC7512 are currently functional, I recognize there are a
> > couple empty function callbacks in the last patch that likely need to be
> > implemented.
> > 
> ...
> > 
> > Also, with patch 7 ("net: dsa: ocelot_ext: add support for external phys")
> > my basis was the function mscc_ocelot_init_ports(), but there were several
> > changes I had to make for DSA / Phylink. Are my implementations of
> > ocelot_ext_parse_port_node() and ocelot_ext_phylink_create() barking up
> > the right tree?
> 
> DSA already creates phylink instances per DSA port, and provides many
> of the phylink MAC operations to the DSA driver via the .phylink_*
> operations in the dsa_switch_ops structure, and this phylink instance
> should be used for managing the status and configuring the port
> according to phylink's callbacks. The core felix code already makes
> use of this, implementing the mac_link_down() and mac_link_up()
> operations to handle when the link comes up or goes down.
> 
> I don't see why one would need to create a separate phylink instance
> to support external PHYs, SFPs, etc on a DSA switch. The phylink
> instance created by DSA is there for the DSA driver to make use of
> for the port, and should be sufficient for this.

This is essentially the feedback I was looking for. "This looks wrong"
which means I'll take a step back.

> 
> I think if you use the DSA-created phylink instance, then you don't
> need any of patch 6. I'm not yet convinced that you need anything
> from patch 7, but maybe you could explain what patch 7 provides that
> the existing felix phylink implementation doesn't already provide.

I'll have to go through it again to remember exactly what I was up
against - it was a while ago now. All of the logic was based on the
logic in ocelot_port_phylink_create() - which is part of the vsc7514
switchdev implementation (a chip that is essentially identical, except
for an internal MIPS instead of external SPI control)

I believe the main gotcha was that control over the phy itself, by way
of phy_set_mode_ext(). That needed the 'struct device_node *portnp'


.... Keeps looking ....

Ahh, yes. Regmaps and regfields aren't initialized at the time of
dt parsing in felix. And the MDIO bus isn't allocated until after that.
That's the reason for patch 6 parse_port_node() - I need the tree node
to get MDIO access to the phy, which I don't have until I'm done parsing
the tree...

There might be a cleaner way for me to do that. I'm tiptoeing a little
bit to avoid any regressions with the felix_vsc9959 or seville_vsc9953.

> I do get the impression that the use of the PCS instance in patch 7
> is an attempt to work around the use of a private instance,
> redirecting the pcs_config and pcs_link_up methods to the
> corresponding MAC operations as a workaround for having the private
> instance.

I'm not convinced I don't need PCS here, and just have things working
wrong.

The configuration looks like this:


		|------------------------------------------------|
		| CPU                                            |
		|------------------------------------------------|
            |
           SPI
            |
		|------------------------------------------------|
		| VSC7512                                        |
		|------------------------------------------------|
            ||        ||         ||         ||      |
		|-------|  |-------|  |-------|  |-------|  |
		| port4 |  | port5 |  | port6 |  | port7 |  |
		|-------|  |-------|  |-------|  |-------|  |
                      ||                            |
                    QSGMII                         MDIO
                      ||                            |
		|------------------------------------------------|
		| VSC8512                                        |
		|------------------------------------------------|
            ||        ||         ||         ||
		|-------|  |-------|  |-------|  |-------|
		| sw0p4 |  | sw0p5 |  | sw0p6 |  | sw0p7 |
		|-------|  |-------|  |-------|  |-------|


Would phylink_pcs need to get involved in the QSGMII link at all, or
should the phylnk from dsa_port_phylink_create() be all that's needed?


> 
> It looks like you need to hook into the mac_config(), mac_link_up()
> and mac_link_down() methods at the core felix layer, so I would
> suggest looking at the felix_info structure, adding methods there for
> each of these, and arranging for the core felix code to forward these
> calls down to the implementation as required.

Yes, I'll look at how I can clean things up.

I greatly appreciate your feedback!

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
