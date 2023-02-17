Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149E569A5DF
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBQHCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBQHCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:02:38 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2107.outbound.protection.outlook.com [40.107.101.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864DE15CB0;
        Thu, 16 Feb 2023 23:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ9BMruhsKDHCPudKEKl1fMjz2+pJHp+LSrj1EymtQlmRHm+9vOOwtWAJwE93E7RdyT6XfGpv8ZhwMrDSIL1BtwojLDIABFyXtu+7YRwmbpRTIU2v2J693zNTuXJAgbWv9UhBb6xs4nSpZL13tN6T3L/DTFG5NtPfZUojLvH5PNNPode3ZKzxZkZo75IBlt/L+U3YmS5Th5Ag9C171qIiZCnyqdkSv1X91g2bfyWtFfTrKAIDGhfhVfhImrfmWeVzeUGdheH8aEPQV5PHGBaDfyVQtAr7I6kZsI5JxY1/Dto1HkKWaF8nkHqIy3DmHBp0+/Je36kFejFK7jCI5p0+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tun5/1qkbTb/T9UkVthz73ADZkuJXXbidLPvjnTe2Qs=;
 b=ePKXBm5cypQbxdzlYg87xXvu1Yzdj9FDR9oqatRutViCzKU6fxXSmB6TPyAFW/kKNjK7+HHVG6CRCJ1gGvnJO5RjLyW6284r15ZAd9Be1PreUiyLtx8rFGcpcuw2W7kf4c8zyqBsG8dpwWBfOHwqBpkWoM+8UfbB5ueTgkpcwE7lwU22pNL4KsPfjZqvbg/lXMhDRcTKzU4j8gzEDZKZyH/vEyWODhvMp4ODPpXrT0WoQ9M3cDrdAIXCuis4kENf2KuN8Nx9sVyqII23Gzenh9Y30vXyn1DZywCI3SnuD4xWpovSZipTZHuRGfyvAXWgxhqbEisq7bpVM4kTF+QXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tun5/1qkbTb/T9UkVthz73ADZkuJXXbidLPvjnTe2Qs=;
 b=Qd+1oa7MxEVGp0DudMcRGGZeNnGeC/FeZI5JGY5uQ1e1i7GeuHNauykdz+sp9dE0Y4kjRBkCSpdmNE8VHI7l+CXj2W8UtXR03nHslYksnWQAHF8enUtkfZluhh32qBHgxo0uwc4py6pAgOLngsl0yovFM29vOcBunVoeK2H1xuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB6448.namprd10.prod.outlook.com
 (2603:10b6:806:29e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Fri, 17 Feb
 2023 07:02:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Fri, 17 Feb 2023
 07:02:33 +0000
Date:   Thu, 16 Feb 2023 23:02:28 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
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
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 0/7] add support for ocelot external ports
Message-ID: <Y+8mhEnRz40i59ZQ@euler>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <Y+4eLmpX9oX3JBVJ@shell.armlinux.org.uk>
 <Y+7NXoFTBYVG3/+b@colin-ia-desktop>
 <20230217011155.4ztjsiqnzhvxvf3b@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217011155.4ztjsiqnzhvxvf3b@skbuf>
X-ClientProxiedBy: BYAPR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::48) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b520173-9744-4ffe-e054-08db10b4f0ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sq3Ns95uV8gq3PkCKcgxGk7MalStRpqaLzct+yRRTnp9XoUOwh3GwAreeky9Cn4dXdfJmR7bDT98USpv6i0TNNWyqYH6DXB/pAewbnGuVFbYuyRTLPCvM7mou0Ceq1atB3pMygs6MMXd7UlItVhXs655qjlSxIFbR8cfSNfzJlzkOG+7XuUTpYlpBJLpzdUlrZ+zgaoTTkSFDoamsRGWXzrhzxUvlnoTyqCZ0VMjpYKMIlG4FO55/+2E0hF6jsoDyt99pbl1s/LJqQlNGeinbYm/nPJBicGdmKDlHp1z2oS62MeujXI73fwTv4p+PYyPmdbd41vW2i8QbWC3qasZWB3GBxWoLTv7a2UpsSWSaKtdNR7SXlpa8JWc8D0KBSbozGfF5wUSDIQSCAPquuGoaTdxypUywxMGNve59teffToMVPphBnPjqoOXsYmXpHMeUcHTPbPx5SU24OpnkC5l6M79OOdJsRuKUx0HjbRxAVdpIee2+G9ceAa72gGNYOSAz+NX8WYYnzS6QTrfIz2Kf5rhFiol2a050EJsGSQUfklD/8En9x/XOCIHXllODEN7kRCrsnHsQY3MvDXMfTCAA5vdlSKcGA1TM1FfudEe7pe5sCXllGpPKlWSPZPeWTRgM3wahWIrHhbCHxJvUPqCfOfyGQIID8cOPNa/E8elxkt1oaKd4ULima9Oc6CX/ii3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(136003)(376002)(366004)(346002)(39840400004)(451199018)(6916009)(8676002)(186003)(86362001)(66556008)(54906003)(478600001)(66476007)(8936002)(6666004)(33716001)(66946007)(316002)(41300700001)(4326008)(7416002)(6506007)(44832011)(5660300002)(83380400001)(2906002)(38100700002)(9686003)(6486002)(6512007)(26005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fKL4wgibhjtdzYgSz1m1+rPfAcDRlBDMTPAf47cbEvwUJcWSvkvzlFtekv0S?=
 =?us-ascii?Q?GmcapGoQhHVQRzy1M5GlnZ59waAsye2eUHtEZLJjkJiAJcWaPLmavvoWvCqq?=
 =?us-ascii?Q?CCyf0oBpeF2vlUKp1D0ezxaqpg7GGS7qVLP7iUCRHXr2njCXDGFA5s6f+dAW?=
 =?us-ascii?Q?it3dkkGPoXurkLWeuEwC7G2ht5zsMHo/JeHgMdkSKO2ir7TLEMy3f+3PYWs9?=
 =?us-ascii?Q?MGwq5OPaBe7tkIAZ0XUPXQnyKRPfkzKD+8QuNPR4roo3X98BHYuSI2G1OpWY?=
 =?us-ascii?Q?1clbxxnXF0oP7Q/atV35IG8kaXCDpbA07XFOpjaYvPig4pXE2wC5H3qWJtSr?=
 =?us-ascii?Q?6m/XP7MK8ylto4XWOaPcAlI1LP65G0ECD9xz74N0W10BCy9+m8Vyu3Ue+dEC?=
 =?us-ascii?Q?EDOYhPqcEBLpK4bczHN19dVVi0swFf6JkuAaFqOoWmtpKNs1ggzDmQj7lgn6?=
 =?us-ascii?Q?dqaXIXCgO/bcBtT5X07+6jxoc+NseVjnos00X6y4PP7xKffCpbUUk9F5T7yA?=
 =?us-ascii?Q?gT7LzCSDM2XT+AOFKmC9b/AUJH6VVTjVU+Nz6uzpmw7lcRzHFQvYPwr6Ph39?=
 =?us-ascii?Q?M1LKP2tMIAgUUpfOiabk095/7glATH74T6lIovhkWhVhbcjF2kGWYp48F39o?=
 =?us-ascii?Q?FQs66reUGlZaeXnXeqMeE+GlffZ4qybiBx8PbQPqkRcCiMucso8YxZqn3lX3?=
 =?us-ascii?Q?Oblhyk7eY+F5HfLfz44u8vCXe+ziQ0XGjLv172TNvfF85Ie5zfZH8xNLkMaP?=
 =?us-ascii?Q?RRO27cXT20jLCix7eW7nS2o6l1VlLXXbwhIHD12zYTwgfEOhftVTC2mrnDRL?=
 =?us-ascii?Q?89f3bd/0tsYPf39aZC1F5Pb/lVzGlvCCIvWaLXIE2GSx35HwyycEispu89DT?=
 =?us-ascii?Q?9aZV5abiG+kDSLkhWgUElLrQx/o23IKeKsd8/YCILj1m06KWFLQrsS7Hm6EF?=
 =?us-ascii?Q?arbR7RfjnRzZg+iKsiZZq+Wo4MlMySNWe9UUk3eNE93np0wb4IP2MzjDYA6o?=
 =?us-ascii?Q?2DY5e73XiiX93Nsaj9rbmnlR/ieI/ciLMhZfmBAdJXO/REO0FOYpbjZ5phEN?=
 =?us-ascii?Q?xO3aEmLuj4PMlYwEXOJXnOFWeZXuhSSHw7feJCnWdevvZoG7GrKu0Tix0fg0?=
 =?us-ascii?Q?pwtaXAokdPwv3SYXx5BwGyEHXYvaWT0QgwUKTBckSucXeFCnQmRC63Wc31to?=
 =?us-ascii?Q?UaJ0SqpufBO6mpz+DGPmEywAnbp6B/gn0Ef8O3DOhofj+eAMHOQscRdjuEHB?=
 =?us-ascii?Q?qD9UcMdK6z1hiud5qgXyDTpje6mpRmQ9ZbWHh9+C9OhmNRn2D75YkP5nzaNp?=
 =?us-ascii?Q?xxdQBzZPoF6Wy8ZLYXiNNUWvT/KUmgw9+Wq3yJKx6ynvSsFhNIbNDcgzYSX+?=
 =?us-ascii?Q?M3Pi5jRZDa9Qx/zSJliRnUfGwl0LmKr3FG2RJzXoS0nQzo8tLRXh6x/UyZHw?=
 =?us-ascii?Q?9mvUgcmyZGzwH0IfZZiqJrUu95bJ9645hx8W1hjegtRLQRfPe8HgXXlhIcYa?=
 =?us-ascii?Q?2DTR7L51XkxafSE0oHgNXI363V5KQWGFDHP9V7//p82iseu8YuRA4MZUDULe?=
 =?us-ascii?Q?7Dj+aTmzqN5/5gUuehK9NQpnZ1PqYxZ7y6tJnB+m+UVdCa4enpqjVkLlWXZG?=
 =?us-ascii?Q?6e0Bn8SjkOlbLCBTH0CskjA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b520173-9744-4ffe-e054-08db10b4f0ba
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 07:02:32.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QF7rl5zNDNZV+qemHrowp2XiojzqO84UBA2bZwZvFrpdobKkOrjLJRmTfnlCBy/51UsFqyWqp4d6dzaEUImdF8USfOTAEW5oYQ39sL8kj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 03:11:55AM +0200, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 04:42:06PM -0800, Colin Foster wrote:
> > I believe the main gotcha was that control over the phy itself, by way
> > of phy_set_mode_ext(). That needed the 'struct device_node *portnp'
> 
> DT parsing in felix_parse_dt() is not the only DT parsing that is done,
> and certainly nothing depends on it in the way you describe.
> 
> dsa_switch_parse_of() also parses the device tree. felix_parse_dt() only
> exists because the SERDES/PCS drivers from NXP LS1028A do not support
> dynamic reconfiguration of the SERDES protocol. So we parse the device
> tree to set the initial ocelot_port->phy_mode, and then (with the
> current phylink API) we populate phylink's config->supported_interfaces
> with just that one bit set, to prevent SERDES protocol changes.
> 
> Do not get too hung up on this parsing (unless you believe you could
> simplify the code by removing it; case in which I'd be interested if you
> had patches in this area). Each port's device_node is also available in
> struct dsa_port :: dn.
> 
> > 
> > .... Keeps looking ....
> > 
> > Ahh, yes. Regmaps and regfields aren't initialized at the time of
> > dt parsing in felix. And the MDIO bus isn't allocated until after that.
> > That's the reason for patch 6 parse_port_node() - I need the tree node
> > to get MDIO access to the phy, which I don't have until I'm done parsing
> > the tree...
> 
> Nope. Device tree parsing in DSA is done from dsa_register_switch(), and
> dsa_switch_ops :: setup() (aka felix_setup()) is the first callback in
> which the information is reliably available.
> 
> You can *easily* call phy_set_mode_ext() from the "setup()" callback.
> In fact, you're already doing that. Not sure what the problem seems to be.
> It doesn't seem to be an ordering problem between phy_set_mode_ext() and
> phylink_create() either, because DSA calls phylink_create() after both
> the dsa_switch_ops :: setup() as well as port_setup() callbacks.
> So there should be plenty of opportunity for you to prepare.

Thank you Vladimir and Russel for the nudge in the right direction! I
made this a lot harder on myself than it needed to be.

Yes, I can drop patches 6 and 7 (they felt pretty wrong as I was writing
them), implement phylink_mac_config() in felix_switch_ops, and do the
phy configuration using the dsa port's dp->dn node.

I'll probably send out another RFC in the next couple weeks with the
much better implementation. Then hopefully it'll be ready to be upgraded
to patch status after the merge window. (I hope I don't regret saying
that)

