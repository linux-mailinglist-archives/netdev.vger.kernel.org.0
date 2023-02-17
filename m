Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF16069AC08
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBQNAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQNAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:00:44 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D876B10C8;
        Fri, 17 Feb 2023 05:00:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsgN5Sbjj4l7PXgxBSQep/Zp1pHnZD7WLpbv+KPWuRTJb2iBwzdJOJwv/oTAuRd0lXJ9svAH+d4Uih3ZZk5suxiY4LeDirdTio/EPbh7cuf+Sr6xZSwFDpcgLasJx7i4uWiQs4GFudSP12KBOD7kOguuI3+jAgtZZzq87lcGjOGJqeDgjHZZ8x/6JbcMxiZX5qcuasECtCPdOR0acOLhWHR1d3sEfQI6Ea9nVFmEBIxbjOVEvhuEw38H17d3C5aR7a+l+AIY1Dxf981f5AZZzfEuWrfaR8E3Jz+mWlzHcI7ihIIpl8vikOViH74R5hLFo4Eymp1G8oodX0lr7fu40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+2R9wXyEsZfgXIX+s6X1qWNXUFYRKiVuB1YHEXpaz8=;
 b=YimuN09rrj1kwicRM0VVIr+shzMFN3gk2A1383V73Tq9Tljj9JtTT79htEO5TBofwaLgRgJHNhXA+y0rMy6D1FxyvuCd6Sh3pmaYNHnc4KbDtPsy//hh8LMoQZS9P+GYD0ghqCGoGS4/hJrwrea1isU8kXWrBQnBh5y90+9T2rXUpipcHjulZloPo83v0KS/8mWnmd35GwluhcWSbU1DGoFsqmzZTbxzaCx8NxXeDUwXy8nU/mUvzjutRanAHZA73QHukH0dw38RPyKWhdhOf3io6S1pNbWKe9v/CgXLcbv14KXQGmzUt+R/zGKy3f838ztjgeAgq91XCVD7KpISbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+2R9wXyEsZfgXIX+s6X1qWNXUFYRKiVuB1YHEXpaz8=;
 b=Ohm+FAsJ7aVdjwKJVqM+1PL5R5K9M0/GofD+z1X4zz78/gCIHQokTowOtYT8ywPsAACMpn0fosxevb6jDcPip/L/HVP8Wlwi7MCxGKX6qi/1ILYBKBnZheDcJ3XbJi/N+zN2KgBJ0ditTb5eUzqXlwFCA4PwII0KOvrUr8EH9p4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8649.eurprd04.prod.outlook.com (2603:10a6:20b:43c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Fri, 17 Feb
 2023 13:00:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 13:00:38 +0000
Date:   Fri, 17 Feb 2023 15:00:34 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 05/12] net: ethtool: create and export
 ethtool_dev_mm_supported()
Message-ID: <20230217130034.azg4syteitf72vgl@skbuf>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
 <20230216232126.3402975-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216232126.3402975-6-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR09CA0098.eurprd09.prod.outlook.com
 (2603:10a6:803:78::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d587f6-f4ca-4eaf-cb21-08db10e6f72a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6GraHwgDT9JYRAeI9ZD6ZtoZfB/8ExDLJKcPlhiOvYX9kRp7e9WIk5e41qh8Z4AleJc8lpYQTjAng6bWFvMIXZbVNEfA2hBC5gMbwz9L87MDOoFWAlyTZUPKQM6OcQBdji43bRb4iuqm6YuXt8WCmJ3+tcnpbJC8811UCOxdA+0e2njeHv+IqAy90T75cVkAOMr5hOCMUIwXd3uYCQ3TCy6VwqedWVKuCP05Yr1sc0SDA7uko+42wl/7/G4oe9mv1rjyZAiDQOHZ/f4FOy1O3oe3h0CHcoNreZsxFGkHjk/auapFx4UZjpzOQKB9h0IoS0fVof1DNPezHDABL4hC3EPgj2o/fizkD2Rx/37s3hhP3sBElq1LEG4SKFts46kINTUO3QU1WPARbjJvkJCXaQP7mWYiOtocORfP+40KNIX8lrUAYO+OSucE2chrGBM7IhscLwtd+/3LMTZWotaHFrYZ8u47uz6FnO0lz7QgBfA2ZYll3ZTIsCR8bBmeHGVLJEXJZZk+Y7IqZz7CS7jJ2OJXUOq+lmK9B/Ew5+A4ELdQHh+XCa21pAjRWXx4Kk2ETDq73wDiWhWfRKjXg3wlNDwGE/tlchbbTRYhr6Htm1buvrp0lYcqYNYTUQ+wH/eVHB08cO5IxdWNHLz/36GjVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199018)(316002)(9686003)(86362001)(6486002)(6512007)(38100700002)(6666004)(1076003)(6506007)(186003)(26005)(33716001)(66946007)(4744005)(7416002)(8936002)(54906003)(5660300002)(44832011)(41300700001)(478600001)(6916009)(8676002)(66476007)(2906002)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hhPErJprI6uM46Scd+mGpRZONL+AZ2XIsPh40B/nqJMb5PLeg97BcXOxX7f+?=
 =?us-ascii?Q?zVIRyJ8DUaw9Sny5Lz4Nn6Whl9odvCcK9RELRUqDGDev/uf6zLsZOMo+XyAq?=
 =?us-ascii?Q?XHa/6lOAiXRXBkCleDJJXENmFlmGwD2G3N12n8k7TxdLfN5eA7Njr6Pil1xd?=
 =?us-ascii?Q?mmQ4zqiaSH8/Z/NYbKPvUfB1JpuPwW5tOX2cw6fQJ27L2yjz9Ww1XvYm76Um?=
 =?us-ascii?Q?SvNbWGNczQaAB4akigPRcOyPNjUQFzCExbWV4k8fB41khGUr2F8DjwwFV2hR?=
 =?us-ascii?Q?mjkTxlzxDOvtM0b3lMH7l3TxB7B1zshlFeI+MtDkUNcsJUbDhH5RplY8sEsm?=
 =?us-ascii?Q?+6wTVnuYlH+A0QgcKvZnN8EtqY/FTqphCN0MfRNV9BYoQZwgwI0FbbmdYqXF?=
 =?us-ascii?Q?4SD+DAsgImTCiXQxZaB+1SdRYXfKu2QhN8wqbON1imCvKWCDV1PLT+iDlWlS?=
 =?us-ascii?Q?jOF/Ru8CSUuVL2FjnERZvx23EZfpKqjZfUc5Hqirla5ph6VcNXTK5JQK0J2M?=
 =?us-ascii?Q?aOfZnO7C8F9wPWbLv+vN+b9++coYdK9fdqJ7tDigdublYRl1dEdJwZQcDTiP?=
 =?us-ascii?Q?HqqqN5kCEnkJknSb8e1bQtGiUEaXMWvU4z+QMvcVUQq44jrPC31jehc8Ksfy?=
 =?us-ascii?Q?pyR9hNsycwJoylsRd7w470Nst/gwfr6ZAwjdopuYzVfH5vymjkFGfjw6CIFW?=
 =?us-ascii?Q?VWrjYhrlWWGcIBBwSmi6COFj89R+SR3pMg73daFXfPeO7kF5gAmHbM0LWcr6?=
 =?us-ascii?Q?M2MQ4kzpu+YSVjPhELk1yl2B+WJMVhtt+xMGK0xJbHjbOe4OFKBT2boBMj+t?=
 =?us-ascii?Q?/Vz4c6UvzRjctjNp/doN+FO23OCoQwLTGW9Gls+/LojisKWmN+9wd+NsvCz0?=
 =?us-ascii?Q?d7fSVLqWdLUbZTU0j+EJMs5NjBJhHRyYbDBgzci3Tt4hod16xZhHyvezWiKN?=
 =?us-ascii?Q?5XwJcXSN7EDXvOBoEVEhW0I/QvL/POGWqQf0iyrwsKac3FSxNmiotLZZ2Jdp?=
 =?us-ascii?Q?r9MBWty/Uqf/X76sCO1uTvXDYbzHkORyznw9L09RiIBUOpzaJ5pHLMA9yv2u?=
 =?us-ascii?Q?S6s7luigYK+Vt2VVi/5noDZUliQINBm2BGBn9ZG5FmeeQwpImw6QP1tPWAz1?=
 =?us-ascii?Q?Z2VGnFH4+VX8VvzbKkBV75eSXdG9yiweQ01dsZeL9ojoSnxnlEw+DfcHp7f7?=
 =?us-ascii?Q?JixJvq8ZPbwZX4GBPZFYK68/FMvluijHaEveNRv0rHEqc8fsmF1N75uOujts?=
 =?us-ascii?Q?8spb97+YNtkuaRN2/A4qaLin01A7C9oDK/iCbtchB9l2HVWFNB3UQYahvQG+?=
 =?us-ascii?Q?ykSp4R1vjp1M51rGm9FDWw7CGbgc1XTdez+cbRstrbgH9e1ZlFFxjPG2t3Nr?=
 =?us-ascii?Q?kODiDvLkvEsGyCvbRr2EJnnc1w7X9ZaEIFEATe8YKpy6Oy2MgOLR8u8y4Wqw?=
 =?us-ascii?Q?A9SBG93h84LfAXJuohpdYhppLPmCAVITXKj7sYaThWL/G2bQcV2cuFf+BXoz?=
 =?us-ascii?Q?Mw5gvYOnBva/r7TU0R4I5Ab7SeNyhhyBbDgy/VPtad2twAS7oxZXjarSr33t?=
 =?us-ascii?Q?ZhVZBDkOvqNU1i76I57jS5yyk65Xx5Jl4vBV6xHf2f4K+Smzvt3W2NlkqGb0?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d587f6-f4ca-4eaf-cb21-08db10e6f72a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 13:00:38.8043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PshAqs0ZEyJzSG81flLqnW+/nNgYBSLgacc8LRrvwAQExspo8J8OLpQ12XN9hxoy4MzSPrWlhmQ9XnGV8a22ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:21:19AM +0200, Vladimir Oltean wrote:
> +bool ethtool_dev_mm_supported(struct net_device *dev)
> +{
> +	const struct ethtool_ops *ops = dev->ethtool_ops;
> +	bool supported;
> +	int ret;
> +
> +	ASSERT_RTNL();
> +
> +	if (!ops)
> +		return false;
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return false;
> +
> +	supported = __ethtool_dev_mm_supported(dev);
> +
> +	ethnl_ops_complete(dev);
> +
> +	return supported;
> +}

In the first patch that uses this:

ERROR: modpost: "ethtool_dev_mm_supported" [net/sched/sch_mqprio.ko] undefined!

due to a missing EXPORT_SYMBOL_GPL(). Sorry.
