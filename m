Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0446BEAB4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCQOHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCQOHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:07:31 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2084.outbound.protection.outlook.com [40.107.105.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828E622119;
        Fri, 17 Mar 2023 07:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd6qcK2PdK9o0KeDw3NBtFhy5earKqyJevKnc+F6BB1EhCZMM939k1VEIVYJw+OS9UCUJ8DJEpBp8OKpjiHNU8TWpMEbWqw03qbLidjTcLKZ+k6YyeOYKfvQc7QZrYtfheUunCYKqyuNRyDicYLKJJnDtDJGgbQwPto+Pz80ZVP7ZGgOkoC5NBmvjCwalz7OzlhxwdW6OX52zkjNDsE68BG3MHb4ehFRP++OqW0avesoXUE0bjfQGvhShd9AH18WuzrM2Ejv+GpWCJXZvYgnujvhA87tNnP9xNfbYJgUXlOlC96EwiLqeVAC7cxaMAevBAzJtN0gk605Lj42bIz39g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hLlEFwNrtfDYjmKLqvBZk779IypPpQOfA3g/xsWCtY=;
 b=SJsEo0IIsRqTnx9RarnPFgXVEUA22MbKEEw1XNjda1N5bDcuUOtgy3sLHyTaQiED2VPuqpkGspI8Gc6Arv8IeKVKwDl6C5MgWdeVJwnAE9aXg/wAe3kqbBO3+7Q4Q9NDgTKE5nnrKobPoqm/ddzHN0DKARTGHuH3W7aaSZmBBTheCdnKtGUd0o11+nbuF2cD3v4PjzF5DoN5Ew4yfVjy57Z1V6C+1OjXtbmrRMOs431CyFQdQ9g1L0EXwlvxwlGvQesXIImsc6fvmWnab+P5KmHKwBIZXaeox/lb4CUhLtcYKR38VagHFnPnBh64Yyi9mz7/uM5uxbuh/QT/k/Jxrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hLlEFwNrtfDYjmKLqvBZk779IypPpQOfA3g/xsWCtY=;
 b=q9Qn6rYUrjjKDVfv/GOirSCWZzpfmm0TNl3Xp1aWdd+nDjqEm/uLvQUK2ZAsYlnaVn+7qk/X5fIyftj0XO1IPssHpdkc+47cHU0OKeDgZfThGa9l10De3KYkk9a3hMuvuHGoXKr27rshO/8CAcMgirlrjOBOXSbJQa7x4IgCyaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by DU2PR04MB8887.eurprd04.prod.outlook.com (2603:10a6:10:2e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 14:07:27 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 14:07:27 +0000
Date:   Fri, 17 Mar 2023 16:07:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Ben Hutchings <ben.hutchings@mind.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <20230317140722.wtobrtpgazutykaj@skbuf>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
 <20230317094629.nryf6qkuxp4nisul@skbuf>
 <20230317114646.GA15269@pengutronix.de>
 <20230317125022.ujbnwf2k5uvhyx53@skbuf>
 <20230317132140.GB15269@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317132140.GB15269@pengutronix.de>
X-ClientProxiedBy: VI1PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::40) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|DU2PR04MB8887:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dad5591-4637-47b1-d6fe-08db26f0f01b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vBVJFt0P7HgajXv88weGBBzTphhGcKA1sddRgm0SPtoe2zGYZ6ee7f4CchmpzarDp4oPBHoUlou8VkLLrF4ScsZim5rQSmL+9GoIFqWQigrlsT596A7sdFdz8te3yYJbpj2C7xgpUzIA+MZTOjK4BclU6jLsFCg5OEvGv/8DRJnvv9c5fkHiJUV1BDa3Srohu5ES2vp3GEJLTvp8bVzF6I8ZvIQt68tj6R2pzJKT9ZX5McKiSHoqlNowtSa733tMsbjNb3pXnZHjDWP+V3iGgRxpi3RFhAGUHeSK8YUO9gIr0PAqHDJSdDdt4FdWbVn20Q57HEZeLL+ndQnnfAn6RO06QVwcG73x2jyXJ9eRNEj4pR1dNQNq/rG8ocG1swmYfyZzsm2VFDaDknLSo8N8ES0Gind3NXc6ib1t4xKcDo3YmynSmC/DSju9MIekwwvxT8VauXW1cECLfetpp/JlQSwxNTtsnj7gKkqLte+Kvaq9uoKb/cBNcnmhy/USaeI6tPPy+N1DatZTMJvk29OwBDxxUNn//mif/4kpRM4mZNF/F9RRUCP/I+c8CjvpyWOrzeCvc23jRYoTa/Rq9+rxAUKkQISKx3cJW/u3JDbWnyc+lULxmFD5S4qa4c4guYKkFLPJKgHMQXW43YtGgyKsnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199018)(8936002)(44832011)(7416002)(5660300002)(4326008)(41300700001)(6916009)(558084003)(86362001)(33716001)(38100700002)(3716004)(2906002)(6486002)(6666004)(478600001)(186003)(1076003)(26005)(9686003)(6512007)(6506007)(54906003)(316002)(66946007)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GEYNtDlAbnH6zNSp/3xeOAvZY70zea5eUJ6qmbBgMkoEvseIIXG/NouGjEXZ?=
 =?us-ascii?Q?fhXPd4x1zjPAdgTRUCwKtRzF0m+OYLDwp2BFohXp4hetLugMAoJgZC+NDFFF?=
 =?us-ascii?Q?j4lXiylu1HZM5k99x8R8fu034rdmR3DNUKlsR2RrJbT7fhsRMEK4zo5ihBjR?=
 =?us-ascii?Q?6Xi9aKWD7uGaMnNKPjSNQw2fbfBm4WF6HAMuSxtaHPgnZrkQuvLZBo0yXrIH?=
 =?us-ascii?Q?6TFjnHdp6OBRmHlXfTlsNomc62+PMisenFuHdGplNjGGShLv+K/tdrpV3Hqj?=
 =?us-ascii?Q?jTSjfp0SH6QsvNtjW5IqT6YpABs7sTU8BuuwMfmRRJKgpDaeHmyOTfGDwfaQ?=
 =?us-ascii?Q?KX5+NaJxZ2q0TpVxVUvm6uZjsyNNHln7+ulxZHdVF4kkkZ3LnMSqzZV4EWFF?=
 =?us-ascii?Q?E4EOJVPo1ZY1wJnesNeYGdH34qkItcYCbJEf5CO2UpSwtFDtf3Jy5De/spqq?=
 =?us-ascii?Q?rv4hd5aWJwZ5PreTNpjLRsP2QzEPI1ZoPo1NbvXzS/EanJ+D5QAxCQZXKVqM?=
 =?us-ascii?Q?+V4LGPebTW7qXwWkNHspljliYT1jOBqACByIhUlILPm6znt3dkPoyvB502vW?=
 =?us-ascii?Q?SJ9228ZlZyBIOHmkNlsGhfZyfPFKn6WMbNBGcKsIrh8+Z6Xo+bIkgVECQb9P?=
 =?us-ascii?Q?f9luJPTKq+DEndHCCir/iAW6EDp5o9uhGO9zCeBzS+5EhMjoRyu+einlYUcN?=
 =?us-ascii?Q?gT/fXWhl/jnsz8s2Kycte9SUImN0VbKcFKotOdiQPJaAksggPcTfFAvWwRo3?=
 =?us-ascii?Q?rJLdUmIW7xbnETWvqqhTXnHbrAJDaprFTCCO5wk9IZHsOPoXUc/j+/dQHx5y?=
 =?us-ascii?Q?O+m59TZdSNIka8gfzm8l+YcCVuaMAaAmveBI+yqFADYFeRqSN1GmB3giQ8qy?=
 =?us-ascii?Q?aJBoX2IfTKIIkpX947ugiUdftyH5zNd/yEGFc20904LTGi0kyGosRM+tkqln?=
 =?us-ascii?Q?RYJXhnBAWttmF6wdE+ZAMZbPPLZNMOYICPt5lnb0eD5PacE9f0Ij2NZ8Vhzy?=
 =?us-ascii?Q?OyUWF7B+kSHKnu8Pdx2dB8qNk/craW6/awSg+k7QhW8oqodKGeFzuW2QSfsg?=
 =?us-ascii?Q?1uAFut6UkoO+EPk6ttIbhffMpr7orz14oNg3cD88BvKkep2XCOLQiBgwmAR4?=
 =?us-ascii?Q?AU+TvHN+nxQ50+aZbvmvHnYO74bXjE9bvaorI7k/mlHAs+89i6CfI/Y6ZGQq?=
 =?us-ascii?Q?oCFpERaWs1UsoaBfocSQMB+ioXePMOIPcDJ9k7fW/gKjWb/waGDxxNY9/z6q?=
 =?us-ascii?Q?Mvs9SxfkZNJpEY73sWjsbWX7lcyUQwwIlbuqoZx9/t9pxT9kyeDk2YDLrvWT?=
 =?us-ascii?Q?tsNlXXVNcAir0cq8H5Fll3cE7H08euSH+o2j6IRZWeMl6yHx8U1fyiAgvuFL?=
 =?us-ascii?Q?4z6NXT9Lb0BxMF3aCxYTZG6aQJGlsSk0c3bBwvnNH6mUSdQHrDWGSxjLsTED?=
 =?us-ascii?Q?sHVPB53MU3lKvjUH98Z/pANw0jh8bX2WtsW9sTYt8B8K8YN5BJSuHDCicldA?=
 =?us-ascii?Q?Fqs65dxzPuvWuJ3ur3ciZhlfBn/80zchZdkbi9dGbGf1u3G8xlzE0MRgzkgM?=
 =?us-ascii?Q?5eqTP+tBrQQIQhiTjegv+HdVUBhdHFX9UQL+zknr0cZVAGcN4wB1Y3uPCYjo?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dad5591-4637-47b1-d6fe-08db26f0f01b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 14:07:26.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RNTjo+4sTmleP4LSe7LWrSzAcTzHtcqHfM/pNCTLd5dMfMsyZq7vYnwMEAH9AcZkkaqQ9fkDSJFPfmIq5da2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8887
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 02:21:40PM +0100, Oleksij Rempel wrote:
> If you'll give up, may be i'll be able to take it over.

I have not given up yet, I just need someone to run a few tests on KSZ8795.
