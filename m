Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994A6671CE6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjARNFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjARNFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:05:03 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2075.outbound.protection.outlook.com [40.107.6.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0F4CD237;
        Wed, 18 Jan 2023 04:25:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8lY7LtctehbIeWxtmOs95wjq2xQN0uhbTHessPNuAzn+2eq5pXtOldZo/HQb/iaSF8f/z7Ovn558KWYjmxMKCE+4e+bxnOc7QiTr4dOtQENqQhx4aKr1EjEDt/j7037v9L1se7sHB9YIsSOJNKqF2KuqV8Hkaa38MUuFJihszRUaDf7Jnbis/zWPQFvFGMq90OU+bnbibgYA3lPZH/lIpEuhi2ZhabJ92WR9XRENZVIIojBgJrMWorCOCssKy6CoB8Ed0l8Dr2eSILBdRRqayMQxXGFrVnsXtSEjZX6xdyj+CN+GD6M3eE4uBht2QZuRQh7Em2JYSSfTYJFDwEi3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3RDDq8hhE+4O+R+9ZRl/sa+keKwvSzGzIwORw/ruN8=;
 b=Hr4zi6EKhkRUL3azcTAMSdJfFO79HVfkAvTqILTmR2DkkG1aotDPUl6u+Kt8dtTUVLHMxlk1i9s2ek1E/qPfeL/Ht9E4tqAYKr7BZRV+dOJpMIIH14MtfYuyph6UPE9WYGPREVi5CFo18AlANbwkoPuZBqmFh2VmDqgLS/VWhOt8VhmafaMoiMQyUDtI7rB/NxwRUrkj6YYtzsbjMGHsMA7+gEWeK22wxrq05Ewk7U2c9E8RHpD5y8UQMgOG358Knzje4KYjOxN8DXtqZaxbLoWcv6/4Bg4ujdiTq6gtflyHGIE438wjnEZF4OpU4+Kk3NBYpxLhMoirhgJ++mvveQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3RDDq8hhE+4O+R+9ZRl/sa+keKwvSzGzIwORw/ruN8=;
 b=igwQPLgKFH3BmajDp3Vg8T6Kbx5klve8w+hgTAjJd88NCG3OAgki+CN86PNxRO/5GgchWcTSwngQcEkTJBSmn6HOnVTC4bUWxAerD3cC0XTPIOYZwyzQAJtXcfp3wIclbUYAnpZOM+N+4XsOS23gtobHWd7jMUdzu92hZqaWPeY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7007.eurprd04.prod.outlook.com (2603:10a6:803:13e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 12:25:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 12:25:51 +0000
Date:   Wed, 18 Jan 2023 14:25:45 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 net-next 12/12] net: mscc: ocelot: add MAC Merge layer
 support for VSC9959
Message-ID: <20230118122545.n7z42rvk7qmg3beq@skbuf>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
 <20230117085947.2176464-13-vladimir.oltean@nxp.com>
 <20230117195221.3e216f90@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117195221.3e216f90@kernel.org>
X-ClientProxiedBy: AM0PR02CA0190.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ee2155-8a54-4b91-c399-08daf94f227b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UfTU98vYJmYarSL2Zu7r0Tz/1Qcjj8kzM/kjwqybk8V4cJeellq77p8Naq0QiesoJdtqdoR2c/Kbk4VdApGNbQh8ZfX67TppVrw8wtjqq84fV6i8glBHuOK+xs+a4lAaf2W1J2kqP6NCnD5XZO+ekKpM+xQb7b6JjyPadG7Z+h6gJjscrFSGDvRPigKBsYyfKosYVlFGUVXlfmadUGaKq5Dp9nEWUY+PfrYkzf99ItYBoxIIWIw9GA5uCVy7Kczobq9daaCBfkqV9z47mzeTW2x9sVhJ7siA6ZTq3l3DzdTMi1KT1fMSvi/JObGB+/PdIjXzWjBgtdD77y986FMG+UhfhFWxQydKwDVK9EIGR370fmFjpLbyKztkehVUoh2JOjOxYDYZT1gjXbHbmu9wTV28tBTrnHv4rkDttJKvRIEhfCYD8qasMYlx93I7fi5HgRVehuCCJ6bcDvabO7vV7QwnA0nyC/7jK15ozIi3/6WVeqgJ76IfoWKQuW7x2xYN0x5I+y7WwExPnZYMfNvxl3VjZ8OktpYWBtAj4Gpoq9CCqQ2RVjv7jJ4DwzCVQKTtuZ+PMNEkX7r6Se2wNFol+kZtkCpPxjJAivknX3MmfH9bA2MjyDnBBXtiDI9OfT0u0Uf6cWmH9cE90et7ynlFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199015)(186003)(9686003)(26005)(6512007)(86362001)(66556008)(66946007)(44832011)(66476007)(6916009)(6666004)(7416002)(8676002)(5660300002)(6486002)(1076003)(478600001)(4326008)(8936002)(38100700002)(54906003)(316002)(41300700001)(2906002)(33716001)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZVF1VchnzFoCDoFmoVo1viecijywgYkyAUTG5H4brm/sgaFvWbo2JyFwkN/m?=
 =?us-ascii?Q?TYotbjRlZ62/QphD2HnYQvBJ/W7U1LoqOG8Ip9YTTSNsl/STGvFD0JHSNKRi?=
 =?us-ascii?Q?fjuz+179upNJzTzQbkTDs62Lv63wocf4Q7XDzgGuOkkzLEU2tKoM2H/wu5t5?=
 =?us-ascii?Q?nncL4c6KOqUUfhFYBcnaITT2a3DJhdNxrKFY/lARFpLs0vqejbbhIrrPqJ1n?=
 =?us-ascii?Q?983aim7/XD9xuxJNXZ9q87GDIBQinZ+67QhUQBoWElV3lzA6B4G2kKFZOceB?=
 =?us-ascii?Q?rJs5HDnsWJ5801kfZoSs303WYrRSkHYudNl/ymF5ilaFFeuePAx3wpydXV2w?=
 =?us-ascii?Q?E0nk8OjEXe6DYg68lNtJQ6eL5Bx4QXr48uGkbzXDx+N0aL5oOJhYYMHv7qyY?=
 =?us-ascii?Q?vgc8wLjsmRjLV1snixU/c5JOtKo3/HRZ90N5+QMD9mTuUoEELh9l5DeZrbJU?=
 =?us-ascii?Q?kWhwc4sezLJMBSGJHIRh6gxrNSh4r4H872VP5/Jr9BWiWiiz0s29AVREfG8n?=
 =?us-ascii?Q?mh69FP8DVxS+uJMK9j+n2H+5BCFUx7lwxG/BjgFigyu/N1nWhHzU9ZI4HoBR?=
 =?us-ascii?Q?R+O0DfsIVHyFgcbn6pAweSdxaqkltWxjKFT8XWDsPqvhr563KMRmnFT3/Hmw?=
 =?us-ascii?Q?DlmRY/z1dz6H6YbUKiNLjnEO04z8spU0lbAOj9t9yrbQ/zUQk+GmGbfT0Xvj?=
 =?us-ascii?Q?PD13cAbypyLZBvsXqpZUTitXDcYXeDukyLWLPUKox4xPpUED/GRnRBDUcbkd?=
 =?us-ascii?Q?rekugmRPQY2JL2RvnC0PHE87T8LiQdhXnvhU52vJ/RXLEkkEO2k6q2pEfpKy?=
 =?us-ascii?Q?n1wKsGMqO2Nb5QYxO9yDrIlNGl25HHDRn1PSGbH+AesmUKjmyWS9TP0fMO90?=
 =?us-ascii?Q?szUG0j98Q6wi/f0k34xbES8kgynJEO2XREZ98nOrFoum5IaSLZATen4IgT3t?=
 =?us-ascii?Q?PUO/cXNTnDU30myQgvvwIAUNIAPe7fPlzSFkJah4Qy8PE9g6e+35VADBqjf+?=
 =?us-ascii?Q?ahmOVynp8iWzzM6PM3QndKEvwFLYlkg3cNyE9QTi1ie3HjmxSpHsWhmlAEnE?=
 =?us-ascii?Q?TWH1ZZNI6lFesIWJ+jTsnekzDqK6q/RVjDnM5Xzo/PDMBiWU357/g2lKaBiC?=
 =?us-ascii?Q?JFizBLH9symstTNxgCXb6WNaFBMsMSdMuURHK2tn2ViEsjoF0NiPB0s9ZDeV?=
 =?us-ascii?Q?fva2wpTCWWRazuy9d32BpO9bIAatc2Y8ju7EeZxzVKS+kibbEfmwvf4fp7kU?=
 =?us-ascii?Q?Kjgj2iiK69ldL2VMzEUryoDCOHiKwy9bC8nX7HSBbeC4Uw7dHHUft724xJ5b?=
 =?us-ascii?Q?Dz/TX6Ec+OgQQjHvlBIo5KzPi/hb/g9A8Jg5gm9FikD67giE3G8CJJ4MkPLy?=
 =?us-ascii?Q?eCBykwE+CwfrToO7M5FYWNsjQFe9ZG0wmjpPQFbXdVLedPa4xA33lf5nXb9A?=
 =?us-ascii?Q?CoNKczky+3eVcQALhSj39PZjx8GCdJ/VuMKPfzKAiQipUQWNUM9QOLT+3dM8?=
 =?us-ascii?Q?1afBVt6G7WtFqdd7OVnQjSB8lYA7t3moF6GZ6dn+vcIMMwMF71e457Q4JWH/?=
 =?us-ascii?Q?LdnlR+Iq3DId5k93b/9eS9uDIdO1QWIvhEP4FzR71ZTueL7+z59rISrPFxqc?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ee2155-8a54-4b91-c399-08daf94f227b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 12:25:50.8708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0DFhotgIosy6wjtytAjsX+wVXuDqlWmK6UdFfmUux1OVFL4ViazQmyKQNfQNCtXEVkxZTT1IgxtAKxU7hP4+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7007
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:52:21PM -0800, Jakub Kicinski wrote:
> On Tue, 17 Jan 2023 10:59:47 +0200 Vladimir Oltean wrote:
> > Felix (VSC9959) has a DEV_GMII:MM_CONFIG block composed of 2 registers
> > (ENABLE_CONFIG and VERIF_CONFIG). Because the MAC Merge statistics and
> > pMAC statistics are already in the Ocelot switch lib even if just Felix
> > supports them, I'm adding support for the whole MAC Merge layer in the
> > common Ocelot library too.
> > 
> > There is an interrupt (shared with the PTP interrupt) which signals
> > changes to the MM verification state. This is done because the
> > preemptible traffic classes should be committed to hardware only once
> > the verification procedure has declared the link partner of being
> > capable of receiving preemptible frames.
> > 
> > We implement ethtool getters and setters for the MAC Merge layer state.
> > The "TX enabled" and "verify status" are taken from the IRQ handler,
> > using a mutex to ensure serialized access.
> 
> Doesn't build now.

Right. In an incredibly stupid last-minute move, I turned the dev_info()
into a dev_dbg() here, but I apparently deleted the opening bracket too:

	verify_status = ocelot_mm_verify_status(val);
	if (mm->verify_status != verify_status)
		dev_dbg(ocelot->dev,
			"Port %d MAC Merge verification state %s\n",
			port, mm_verify_state_to_string(verify_status));
		mm->verify_status = verify_status;
	}

I'll wait for some more comments from the TSN-inclined people (if the
netlink parts are okay with you) regarding the UAPI before reposting.
