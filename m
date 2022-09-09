Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B055B3FA3
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 21:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiIITax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 15:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiIITac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 15:30:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2116.outbound.protection.outlook.com [40.107.244.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A825B2DAC
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 12:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xo1AeCn6sjUz8HAWoDYsmp3PvXtkw5tj1cJqtQBqzpDB7wu6ccTf3QYpEKJCAXjk/8UgqRohwdwPzpBc8dH3WSNOZHuphguBH163GxInV5Vk3ZKO5RfNDDM7FjW0pnN3kAj+9NpB+D82QwODmWvMiJxv7XVjSw8SYa8ecahNKCMWOstUfI9y54sZodfDxgctl+Z2fnbZvDp7IRAz0jq2+takJIPYGpQJ9pBpx68kYCUD+AqpB4KgIEqZ1pXDYMjcEzrbcccliZaT2b9xJE/KYl4kdJTqAv2u9CyuUR8Ov9LxvN2zPTNy5X6EvOhyUG/o5jYn1CB7G+n4DAoZgACENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAVszqNv0OophhWK7Zc4okvk7Kn4G/D+jzoqXI1SOMg=;
 b=bHzqd/ojgFLl7xlFx1pHxfZfkMWwXoy7fmuOtZ1gxlvX1UlfEEaQuTUE46OQWzE5QP1ip8tTvfLpK7QNdB0kb1AUjvHWc6NBUHrZe/eL7nFk0k+mKsheCby30XGaXSQUgMXMbOrZjMP/79dl3WB1XwdkDcs6l2FU3pQAxGuDS8L6MXnoKTfPkdwqZpwJlUhh3/cP+I+UBEC2Z4SDXMr/BCRpP8WIxo7CNyJnhe2oGWfMQdrY+dkXZIwD02Ou142Rvianamki7P8XDVwHG994FifGuOxP9Uh3cBYEXExD3OEw7EhVbVkb73A0Akj1uieiM3UKQSB6Npn1nJiME29BdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAVszqNv0OophhWK7Zc4okvk7Kn4G/D+jzoqXI1SOMg=;
 b=c72Dsk1dVYYLuHp2VeycGrKhewOrvUChqhyezs2dotZQSIS2IPIuuEbcHuAt7RhdgenA//tzFsvHkL6F6LLFno7Bcz0Rwg+ivejyaNyzopsl6BcRIkiHpOrpyFQg3T7/8PkwGSH7Z4nhIZ4oFurOm+MRmw7jtqR0oJ/3tt4HmW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB4688.namprd10.prod.outlook.com
 (2603:10b6:a03:2db::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Fri, 9 Sep
 2022 19:30:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Fri, 9 Sep 2022
 19:30:24 +0000
Date:   Fri, 9 Sep 2022 12:30:21 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Message-ID: <YxuUTWhKv9+VhM7z@euler>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
 <20220509173029.xkwajrngvejkyjzs@skbuf>
 <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
 <20220509175806.osytlqnrri6t3g6r@skbuf>
 <YxuHF4UrUEJBKmcu@euler>
 <YxuR41mjy7c9weXO@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxuR41mjy7c9weXO@shell.armlinux.org.uk>
X-ClientProxiedBy: MW4PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:303:86::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b62c905f-747f-4bac-7727-08da9299be0c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4688:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OK+dnNCXZXPTzdZtecsB+NjGq7tgLv0Nti1ABrdaQNDWMS5XEQmklrmg+BocT1oVTrh2DsJhT8syjkTON/8llv1nIqeJ/UadS4kFKELPwfd3sHyQJBQkUYft8tlNG4ZMr6PtNz2sxMPtxgJFbz81LOJrrptp11YMiRGNA8L/dkWRsbinLwefo2DJBlX+tmJUNyc01UYjFjX2XPkIY2HczEfy0ffAyx4U+TQFKkVBW4wlTZ7JyeVyQX5ReZ6vY8kbM9UbHQqFJVIlaniMQ71wI3b9++u4VwxpzMMJUiFLW8FnfvrOcf2SQIcdWy1MjNec0tJzOhiE/CuQtWids8NfNbzD3gOWK628p35GmpO11FqkmUDKjgHr9gQAqC6L/a9Fg20I7q33zOUfD2US1Xus6O3x6ZLi4z9hE7cPGgZe0QM5yJQExr4QQ2jLnIlIhoywpNK9M2gp/r+tb06nI0KiUQvFXUSDwcpfaHHzETVBQRhP1QJENH2ZJUZ1/3Ev4SfQPNtLk1NA3hI3f23f+CT9GGieMD8qzU+6nELOokm4v71UrFtVc6XFg/fJncRch8Y9nydesxJ1FAEjk3ZbhXx9x2A6v90Ceix4PiSZKQ+8ecMRSNHkGbraI1OpDi4fSWcjvtY0g2ywysUQSDjM9Nv9ubSqWuQhI0GepJQwpjdLCMcc7AirepQJjIGznhLhwrPhKIzx6Z5xT8+CV7SLSdQTfJpT4L66ywpgtovdd1cMM/6b0IkuWjaBMNdKudJLgv3Lv/gLoYhd3sSRRQtffEAVq9pgH6KBdUWOtoEwWvHueyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(376002)(396003)(366004)(346002)(39830400003)(83380400001)(186003)(33716001)(38100700002)(4326008)(5660300002)(966005)(6486002)(66946007)(8676002)(66476007)(66556008)(54906003)(316002)(6916009)(6506007)(26005)(41300700001)(6666004)(9686003)(44832011)(478600001)(2906002)(7416002)(8936002)(6512007)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njh/nwgig/5KyRB4i1yy+YbZaLtFc83sFJwpfT+bTdTNwi6iQyYW8jqojXPc?=
 =?us-ascii?Q?FOIHswrRIE906zdu/dLU/N41jOTowx0DoXIq+Ox2TaaJ8kQ2/xHXT0yYo6HA?=
 =?us-ascii?Q?NagsjpjX1/OBva2/WrGoCgzKGsUWi6LG61M1mRzpgzN85EPt2/R4K/OozP5U?=
 =?us-ascii?Q?tlOFrYuR+JCAHiNYHOs5eep+rTPYwVhUUs84ZdhdkEHHt7Gruq43Fz6BKOv9?=
 =?us-ascii?Q?YSkT8kVWaHWBIENbgbYtZ0qziUHKOSrYcSwYFPPB1xGYBaZeEameDQq5fhkv?=
 =?us-ascii?Q?EPTBrCq07wBSgMUhz+uB6vfMZuxNgGq4qayYx3UqqiKWkYj35F71sYhE/Hnh?=
 =?us-ascii?Q?nKXmpeXFGztQMWRWn261Z5NWgyx7S3wosC3orCXQTP8AGyz59CzLA3V+tAzo?=
 =?us-ascii?Q?Wr9U50Eq8s7k+VAmZWNx4YN8tX3Bu5/WPbLNq+6r0pzZqFmCyp8eK/Tk10G5?=
 =?us-ascii?Q?YdjsP+fjWQNCMMkclLWXzaCxqxvXvA67Sl1GbJMugsybuq0IyKu8NmCu19qb?=
 =?us-ascii?Q?9xK00XUA6J0WDUaYjpqqYu8bo5U3Uq8IQD2bAkz4rv+odJmpPW+86EH0lxtK?=
 =?us-ascii?Q?EIIfewDK/poGbaEaOU/4e/mPnJYbHP2HSk0XBEUU5w88x7gE/1R6h/lBPRbq?=
 =?us-ascii?Q?GOzIJBqfknnyIvtrLrdDyDlF9A2IqO0/V9mRVojqyGtvxEcGl4ZeWyaPhTMu?=
 =?us-ascii?Q?z4QIZauV9djVIf0U6PEC/B9uTG0EWgEsnyFovlhlDsVgM3xsDwB8Sb8YYR9I?=
 =?us-ascii?Q?NOe5ctpMiXfFtYFWq6porX7qcGJhmCB0SPqqLuwv1vG0aEPNq0MCtWcrYDtP?=
 =?us-ascii?Q?TWL6xsrFclolA+oxywKJ4hetXhiAk73rSv6t+5kTFyROrgEXa2ci2di1m236?=
 =?us-ascii?Q?EzDmD0gPGU24+dSVLzgscXxy9BnKcKUzWyBPinq32qaYerZdyV/CChc2Eaik?=
 =?us-ascii?Q?0scuJTB3qDh7VwSRF0hjkhn+GuK+rZogucAP5fAbQhHPMa1N8BMeHqWD/3er?=
 =?us-ascii?Q?HtAcAnmxh438nPfHaSB6ZVYsNdkkoMYHc6FEDOzs8DmeHk4h3M7qtTTz3lhG?=
 =?us-ascii?Q?/VA9LE6ERGGwl5eMCJMAaq9im3XisIwT0aSon7LbOdalMt2vBBAVn/M4VN+w?=
 =?us-ascii?Q?9LfJ8YesyiWEx3M2l1/ksioxpOc7kTB1JVm7vPuIyw4ixoFs2knkLAjOqFOt?=
 =?us-ascii?Q?2kvrp4bXDOQJKcc2WHWT4nCq8jr3BhePyQq+aa4luEf3mFIUqIpAS0sN9uEW?=
 =?us-ascii?Q?apQHpz+HmZ8TNjzT4FbH4Jxk1LpGzCB5Gnx5wYwQdxyrCevFlvEN0ySG3H7W?=
 =?us-ascii?Q?c9hjiEYFTGwJAivZ8mCx9K4ooQqp5qmfb7ghNtNNgq7OjCRMEDND04KyIU1y?=
 =?us-ascii?Q?h4sm3I8MuJhU3AVTLlcnWp6f49NUAHLs+/yPYDUL7ks8P0/n2U4EdrEba9B1?=
 =?us-ascii?Q?tIH/NdZZtShh/9aW7IN4zYscKefmWRWrR9YJYzeiIRnK22b6QI5hCnqbu6Qy?=
 =?us-ascii?Q?fVN9jEoHhikS1j8P6F4bGaWDOIVSAAFZXdQk7mvQ/xsA8FO40UdLxr/9j74G?=
 =?us-ascii?Q?/tQOEOzbGsbAlTkQAO7qvEMWgK94/2sfVnOaNY40Qxp9KYCJ0Nk0ozKZ6Ryi?=
 =?us-ascii?Q?xN0ChRBG/v5ILH4n1ZZK9Uk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b62c905f-747f-4bac-7727-08da9299be0c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 19:30:24.5142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgsGzY2s56EG07eKlfWhnUq8UYiUIIFn9utuTXy9H/F9UrDXfrG5lX2wDDAIX1jhzGeqZ14pxU7x+AeKepIUutGmUVnudQMSZODLINKEeUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4688
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 08:20:03PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 09, 2022 at 11:33:59AM -0700, Colin Foster wrote:
> > Seemingly because net/dsa/port.c checks for phylink_validate before it
> > checks for mac_capabilties, it won't make a difference there, but this
> > seems ... wrong? Or maybe it isn't wrong until I implement the QSGMII
> > port that supports 2500FD (as in drivers/net/ethernet/mscc/ocelot_net.c
> > ocelot_port_phylink_create())
> 
> No, the code in dsa_port_phylink_validate() is exactly what I intend.

My apologies... I meant "it seems wrong for me to blindly assign values to
mac_capabilities" not that there are any issues in the logic of
dsa_port_phylink_validate(). My phrasing was misleading.

> 
> If there's a phylink_validate() function, then that gets used to cater
> for Ocelot's rate adaption in the PCS (where the link modes are not
> limited by the interface mode.)
> 
> If there isn't a phylink_validate() function, then we require that
> mac_capabilities() is filled in, and if it is, we use the generic
> validator - essentially I want to see everyone filling in both the
> supported interface masks and the MAC capabilities no matter what.
> 
> The Ocelot rate adaption is something that needs to be tidied up, but
> until that has been done, Ocelot needs to have the phylink_validate()
> hook. Ocelot is currently the sole user of this hook.
> 
> I have some experimental patches to address this, but nothing that I
> felt happy to send out yet.

I think we're on the same page. My version of Ocelot phylink_validate
utilizes phylink_generic_validate while other Felix devices don't, as
intended. Hopefully I'll be able to tidy up this patch set and send it
out for full review soon.

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
