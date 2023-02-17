Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F82B69A368
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 02:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBQBbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 20:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQBba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 20:31:30 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE142A14E;
        Thu, 16 Feb 2023 17:31:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnRyuLykRRN2JFHSCqZVdDpCfq9I0Blsex1g//mLuFd3PIaTNGl4QGTG2aJ4mwYN24hwLnN/zmhKbYmSJExy4SJgSlPoFfSnDT4SsYikVMtmTA2S+j0eBKUgUV/0r6D8jt6IepATg9DySxvtvCwX7KfeAqmP+5lDWhCaZfP5Qk/vnkbvnbSFQ3mjx+zrW2ag71Z9EorNuGeWGO4RtPXJcMmY2KrLHbAak0yaDQ02caNgaxvY/R7lQ8xzuqrsUtLsoOFe/mhfstSj+fv2jm0rsGsyZmQsRqDpguJomnqCLmIhG31zFzPaH36sJ1aiuUxMiYCk4QVsznh30zBQMdOuyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAklMvPAGipU84IKn0S3QZqsERClNKEOhPtalJk+Irk=;
 b=hZ0CUfA3GvrUl2vDmASF6VoLjfTi8M+788kkg4gM3mre0+uCA0yeKc3xVhsbVtRhpLUJjRvnvnmSPGfuY425GKSWNUGg5iLBSjEyz6oIG4o3N9ZtUvP7TtfgnTmQNfECZ222/7iK3b1H84lobJ7H31iMtigVa+yIGJUli3GWtfiTbLTNdLUxDJfecOAQnDSR0Bne53BANAgwSgK0Kx+g0IKde1OjbgFQMEVLFM9qgdJQmSQxHvLIGkDWfgSg2QY0y+uzDU+Q5+VSVSwIC23Qoa+CtPoPmB9E+X0oslW8nLv3in8y9su9kXo36LR+sgLHXZTDInqjDLi553juAZPkpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAklMvPAGipU84IKn0S3QZqsERClNKEOhPtalJk+Irk=;
 b=ZdOUXV265yOO23DNUOon/7gi/htZVgGc5xIvnATa7sNm9ck/L5DdrrXU127ZBMmRpI2h7gnrdXajLqcAw6s/pY2Qel7ONuV6H1K5VR6j5AGbo0zebks7yv9s/JCRPP1NaC+r3J1icmOqirKgOvSBj8gZuh86QJp8ovSkQyXlnLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB5949.namprd10.prod.outlook.com
 (2603:10b6:8:86::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Fri, 17 Feb
 2023 01:31:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Fri, 17 Feb 2023
 01:31:27 +0000
Date:   Thu, 16 Feb 2023 17:31:24 -0800
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
Subject: Re: [RFC v1 net-next 7/7] net: dsa: ocelot_ext: add support for
 external phys
Message-ID: <Y+7Y7Ei7PXYXipLP@colin-ia-desktop>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <20230216075321.2898003-8-colin.foster@in-advantage.com>
 <Y+4Q3PDlj+lVQAPx@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+4Q3PDlj+lVQAPx@shell.armlinux.org.uk>
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 987e2578-bc28-4df2-d1b4-08db1086b053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e+cl+XYsX8VTGKpasaqOnm0Hdh5h4AEZRcD+lZ9wS/aJUhLEbh5P14u43J+uGFVP686Cd/fe8HT6hjF25WbmymVefGgPAZ2MhOWWoFTxVEpm0kdR96K5Fn5jQ81IMFE7nGxNZCKbtxjQVWIUdmmUIUH7hU3MJ6LzVNazDrNT9pO+eUV6j+AHdPjH1fYGiqP4TF3VAQmWXHIlXgb8TAeoaY1JtudOcZ0ux/+6yYxU7M7bSi+E29omsgrhxtXlSqB7qiqOUijmZvjBGROcuqLxGjotyLnLvoe1wU7cMpd3zq6oKG9WQZQzcxTon3+7zmvWN++NeDixpAig+eyZQPH4DCkZBM5tA34EaSzY2var0sohPNn3irZ2eWK/GcWvdKJjqM9MCzTZKQH7miPi+pgEmsPLS+zPCi7Ihgdks86pvP/zIzjCuDEVEfjX/P4H6UCcEXOxYa0/32HB45XNUXgd6BWukyoOo2WL2oVHFdDBQeDKS+KpXOk01BVnFEHYO5rYzzl1cY7r2+iBP4Jebr+5qNgodKn6YCOSSG0ZWe4MiLLdfIh+DM37ke3/YhZs/akpwO2iVrGD6JIiAgEBPAuLql8Vcnr6xYXgQ0y3LhhsOdZLpQYS2gj1tyiMVN+h4sbmg6G7dpOCTRZnUbVcaL7Bl5RzZgPplVgoeYyqGZCV0vOzLHq4BgcOa5z3CSGix2Do
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(346002)(39840400004)(366004)(396003)(451199018)(5660300002)(7416002)(41300700001)(8936002)(54906003)(44832011)(2906002)(8676002)(66476007)(316002)(66556008)(66946007)(6916009)(4326008)(966005)(6486002)(478600001)(9686003)(6506007)(6512007)(26005)(186003)(6666004)(83380400001)(38100700002)(33716001)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DCBKdnuAt6RGH/T89NSDmQi4OEyBwl+Q5qxTZDBFT0SxKVy1PKRUke2GfcCZ?=
 =?us-ascii?Q?htWBcVfz4OFrbdamTp6y8hz2tHwOzACiHUQ/l0aeDHbJA9giRXqz1rUQIRO6?=
 =?us-ascii?Q?6oiRjPtgCRcJLFaWy25FkrlXUIdcpjlpI5DFn03uowmUyUiR4Jzfc0uuICzi?=
 =?us-ascii?Q?HlJuQiRNXyU8BYlgCbS9KOBl51nk5GEIig+83+uW8FyiJc6FmZTF/ulQN3sq?=
 =?us-ascii?Q?nCSy3t63Oc6UqDLIKanJEPRzNzcftyWEeJ0DOJh180KE3ke9EbjFBNRU8E0h?=
 =?us-ascii?Q?zMkJDcqwQmA7/3kX9Gd/kQqj2W2RtrsZhd7/iQ3/iMwddxbHNszW132YSa69?=
 =?us-ascii?Q?rd+t/sf5nICVTxPqU63z//pwyADWlrFPwiXr1tSRBIwtWwl4Ys51WbU1em1Z?=
 =?us-ascii?Q?9KzHzf/F94YugKguUJySEe5GiegWkwocUB6xJU6OKLuelY/2/AYI9Va8l2MK?=
 =?us-ascii?Q?6LI7ZImjhn6H10kEk0zzAXqOp2YZX7mgLOZxnbWNwFDWiZO7yy/dnQSqMcQG?=
 =?us-ascii?Q?FmVBC9JA/JZEi7wNmdlXoO6TNU1il5FjtJQlcCZ6wub5eKPYLj7OlRTC9hxz?=
 =?us-ascii?Q?JiHK4zVjctxkGJ846urTczexMqbnnu1t0CAMmm7tu6Osr9bNAbm1Ko8pMS8O?=
 =?us-ascii?Q?bZ2JoK0FZO1qFGDyf3ePOv99UuKsC0uukV2wR5NNe+kMT8Hxs/RdB9yNg7Aj?=
 =?us-ascii?Q?p1RDycZ59FmPmKpIaUR6K3sq53O3rNtCagcpNId4TN44anBMSqC43GhBNazK?=
 =?us-ascii?Q?RRPU9AWSbZS5amqx/IATPK71wxCD56MbE6DFhFo3Px9PNUxtjc8TubI0Zh/D?=
 =?us-ascii?Q?No4+0mEuDx/Lf21WKCJpNxO9kTv+seH+tVa3tEvBPYg/wmzwpWlPuBbphig1?=
 =?us-ascii?Q?TL31sxcSR2rlB5z6v8TAG71yd8NDc6/JyQh7aOzOVGg0rvGGbwnmg2L66r0c?=
 =?us-ascii?Q?1ydvVhSyO+/sDIyb/n9GTkCh0gBNVpzpL4oZwVvwC5VX3IEWni1pr+2Cu5UH?=
 =?us-ascii?Q?s2how/KqXN3l60LbaIKungDmGF0w4bF0Zt3DPlnqrny1sizP6e+P4Pm/BcVN?=
 =?us-ascii?Q?8/AEM8cDuWNAhBzaBJW9HhFE1uxMORZhi701G1OZ/9RHTc5Q0G5wV3OWq1DU?=
 =?us-ascii?Q?5QbQIFKTsO5RRAjufWkDNqvDo8I8x65M9o2cDb2U+WsNgB0n8KnQl9BFcZYX?=
 =?us-ascii?Q?Z1jx6r5DHcEPyJWDwjEYHeMP76Ily654+UxE9yeEcA/KBK2iDBlnj00vxFze?=
 =?us-ascii?Q?vzPXWhmNbA1o0TPMD6iYPwWzIADEonR4WKx6ddRicJukvnNeVgXOdKGLuA/j?=
 =?us-ascii?Q?6K79+Ff3mqGKlsgtjPwo1tjukJhPJx/Op1Ce0RySv4KA56n2O+NwXkUr0kLW?=
 =?us-ascii?Q?7fgYVkWThCO1LAZ/eJI3xEsNlyBUUim3ffW0ZlN7WS7WSM7S4dnafZyIw+i9?=
 =?us-ascii?Q?u2B9+4nr2EBq7qQkv4n9rQQf2zjMbFYDiLrbjBqRHBqcgjPFlvejG3ehORkz?=
 =?us-ascii?Q?v0OKwaD+JMdZwhU31vQUBfdnFoAq5dJae/SsxmoKa/8ZIm/MbCxmFCU3OGNi?=
 =?us-ascii?Q?gPzkhjRXKr+J7bHq6wW264RbR0dhyzaIpWkr47s1i7hjcYrV4qiIknqUiYV1?=
 =?us-ascii?Q?DcTLtBXiQEl5KKPpt9FZioM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987e2578-bc28-4df2-d1b4-08db1086b053
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 01:31:27.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekpfUoZLPoR2VRAwGkRlQK9hW+1LDCiqh09Du4gJDFvZQRJeeYVadRUpx1vUCGpOP7IHHlKpOF5c3Lmo0uhQP/CNtdlgpxuUzVajZ9J2WZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5949
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 11:17:48AM +0000, Russell King (Oracle) wrote:
> Hi Colin,
> 
> On Wed, Feb 15, 2023 at 11:53:21PM -0800, Colin Foster wrote:
> > +static const struct phylink_mac_ops ocelot_ext_phylink_ops = {
> > +	.validate		= phylink_generic_validate,
> 
> There is no need to set this anymore.

I'll remove. Thanks.

> > +static int ocelot_ext_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> > +				 phy_interface_t interface,
> > +				 const unsigned long *advertising,
> > +				 bool permit_pause_to_mac)
> > +{
> > +	struct ocelot_ext_port_priv *port_priv =
> > +		phylink_pcs_to_ocelot_port(pcs);
> > +
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +		ocelot_ext_phylink_mac_config(&port_priv->phylink_config, mode,
> > +					      NULL);
> 
> Why are you calling a "mac" operation from a "pcs" operation? If this
> PCS is attached to the same phylink instance as the MAC, you'll get
> the .mac_config method called along with the .pcs_config, so calling
> one from the other really isn't necessary.

Per the other email, it was my misunderstanding - probably from the
unnecessary phylink_create(). V2 will be cleaned up.

...

> > +
> > +	phylink = phylink_create(&ocelot_ext_port_priv->phylink_config,
> > +				 of_fwnode_handle(portnp),
> > +				 phy_mode, &ocelot_ext_phylink_ops);
> 
> I'm confused. DSA already sets up a phylink instance per port, so why
> do you need another one?

Also in the other email, it is definitely my confusion. I'll get things
straighened out for V2, as these patches seem more complicated than they
need to be.


Thanks again!

> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
