Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E679A6B4C39
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjCJQKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCJQJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:09:45 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD24E4C38;
        Fri, 10 Mar 2023 08:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gih0m/OTNKpGg9Cu/FwQBoS/ArWUGSpysKVbBTy7DKO6kV0MKLnizwIGL6id/7cGNewGjI4piXRaYcfx+lAW3RecqTrkmq7XcVE2LAM+LWD1kZ10yQSmESHgdFfx5Zuwt8Xrdb5tB2HKNdDrxysfYikXE5gjutqHh79J+Cd69ebl7giIUketzgQKXAInCcoGSLavX3pAzjljBigKbkI/vTGBnS7SFYFK5zj2t9HMsZsXN2D7nXaJY0QrDAYrlOxKcna7jZzfjiLdNiqx1DFx3jBhRXDMGwc7o8ZuluFam5hVmc2iQqpF6vwY72q1oQgPlYihnzbwyZYLyGgeFXCc1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykSoph8ns4bWbHSoV0AGspKJg/h2aL7+nQ0C9qwUIEM=;
 b=oTbWTm2anMQF+WoTm1uMOaArDmzI5a2CfWev1r3+sDhnDOOsvFjTpDlmBljg4x5VEwbJz6mo5zR916n9SaNa/OI9s/RBU6tj8ayLgAM3I0jG71OxGWjoK5sP2YDXQyb2cNal+KQCOeNSk2VirWS/aaKUsExGLolC+dI4zuqPddWz5qqzhvEqz42Bsy9QwrbFey4RE1wSdAEJp2q1dUeHC6eit1aYqaMCKMw1l1iAoCyajjvutqnmyJIbHAblrN6sU9jQq6xqlgYXF3JRBi3XVBPSIYy6gUaneY12Xzz6LIbbvTHd+ATSo0X0yS+yAni7t+AY7+i60hmizTLdmLgejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykSoph8ns4bWbHSoV0AGspKJg/h2aL7+nQ0C9qwUIEM=;
 b=U64n9Y4RuwEK2M4BNHdhig3Ta8hPXX/sIPJEEEb3HYkIk3Kbxww4g6DJw28WuGKj/OajU5GkgtxsiNYkncx1+ONg+VDmCqn2j5+A8iQUiY9fXxrUI5aBg+DHuZdQpyfGPPpQXDyD65hISVIOvxPiQiSwekhb6gk+FXh6BHli7vU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8679.eurprd04.prod.outlook.com (2603:10a6:10:2de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Fri, 10 Mar
 2023 16:06:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 16:06:54 +0000
Date:   Fri, 10 Mar 2023 18:06:48 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230310160648.vwzbyood3rectlr7@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <0d2304a9bc276a0d321629108cf8febd@walle.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d2304a9bc276a0d321629108cf8febd@walle.cc>
X-ClientProxiedBy: BE1P281CA0258.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8679:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b0ba51d-5770-47de-8414-08db21817746
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jnVtxtMMPYAlybZV5eiHNS/ufwRlKnFv1XNVJiKR0smfokfkxmb/lJgoFyF6etKzoi3FC/RuEtHYfRwEcrRM+aa6j6P8xewXw72//nkCu5+6OyFxDv5aY2WFRqcso3R+TlcnX55KLDAHakbTDy0VzPEsyA6XuBYUtgVGY38W5DjiUmVdTrz6tCNXjp5wETrekGZZUZSu6xzHqA8Ra8DphKHHyoMDwUEIgQdfVr2Qxg/NRWfherEf5WAoup+iDvFy4Bpd8kBmzT+6cQdnT7IUzFRI9P0Ck0NRukRF7oAO4Uy69QYq/fwGzJM4xbvvJOFdb+Ji/6AqowFh6pasyUzdhsOP81sWHPZD/3CQl4nDbMxPcoDTi25WlhcB23S3u/wDp/ggc4dHQCS4U9l5q5Cv+2yc0kTEA5L6y870RHacpRcEVL3xUcJmfLa1CDwGwqNkWS2fat21PCxOFIoV/DbhEUqk/7wwWC3i/GcsBqD6WW18bxo43wzRA/oLP5pDIFDFD1p+pAc6HjlrPxfvXN2Ob6Mb4IAoH7AY+wmBAKIVYQwGR31OQuiXxbBIKI+rmstej9MN6i7cpBCVnhaXgrOdjVDPYuM1YQPaEoU6X2r7l/w9ZegQQ4yiNjbHqKazDg9xmg0rYEGbx2x8yTO/d4BhSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199018)(6666004)(9686003)(54906003)(316002)(6486002)(478600001)(41300700001)(5660300002)(7416002)(7406005)(44832011)(4326008)(6916009)(2906002)(8676002)(66946007)(66556008)(66476007)(8936002)(38100700002)(86362001)(6506007)(26005)(186003)(33716001)(83380400001)(6512007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ejDZ9T+WpWzRwyeMHBBbbKvJDGdnKGtxt4dojPPjtloO9q4uMtXqGID+ZkX?=
 =?us-ascii?Q?IbaOtnOk6n4/tahFvQy5S0CbYYjcRaFHZOsHK3tTNAB/2fsFgnBtm8FtWL2a?=
 =?us-ascii?Q?ErXKp50Ot/Gnj5VRnUNGl30gZ7lt/34u91f7haLJ+o6o4/QZLDexa8ihR0uV?=
 =?us-ascii?Q?CtG5f4ZsLmwkuoe5M4a0TR6f8bSyYpom/vZF0nJdPwyaIwuaVh2+Sq+deqiD?=
 =?us-ascii?Q?6YIpdOD1KGDZ4y1Sa2ExOE/lW0I4+OCDR0iOKJ0/QoIroyKVOPaJY0V1CK1V?=
 =?us-ascii?Q?NzumPtF/TQOJE4SX477y13qE1WMKKpY8KsPuv1olNIM6yuCNB3sjby/hJelz?=
 =?us-ascii?Q?BEMLl7assR/Xoaoeg6gaetyP1mJzwZ/nsLTMAIgQThCpQUBcuJ8gG3MPqpEx?=
 =?us-ascii?Q?3mvad5bUcGTt7u2TbvIeMzzDRzDMZdzD+RB2ll3SxzXrmnwVzXUG/6CsUq1G?=
 =?us-ascii?Q?MyW1NbhKWQcQmGLlSlZsX8g/wJ8SgvUOt8LsNasV7Y2b+Y4UwppmJRqLbpNH?=
 =?us-ascii?Q?/EwFeTvWCcfEFZLeZqeaE51jF33tdyUUtfjXqT/RRD+Dqy4MrrlaeVZ0qmwC?=
 =?us-ascii?Q?nr3MBflAIXcrXeb/5GR9S+U6Cd/BvrE22Eqy7fifnjAna5QTZEE4NsaJi8d/?=
 =?us-ascii?Q?DUIgoVl6p7pwXUbu4P2W9BcjoXJg+rqWAeZdqsgAS8FIk2KioUK0d45dbCkh?=
 =?us-ascii?Q?NaQDjjZdMZFwOiu9knr88EPNnUqGyqpXsxW+O5IajxiGgauLNtNFvGuOrb76?=
 =?us-ascii?Q?t/ot6GrjAbnrEHfroZwAsu1V0jzmhdfj/9ZRJsajzGiPc7N1Jndoa8sdVEzJ?=
 =?us-ascii?Q?qLsJxBFrAaScT4ZfenCA2SIGfyxc38JgDUb8IsydPBROYM28hFbtDywXNibN?=
 =?us-ascii?Q?K/foz9p+dzhsEq49uDuJZw1xIZE+7KaEdydR8yK0KC2EQecRq08ZggbSns5R?=
 =?us-ascii?Q?06UQZxkhS5zTmDcQ3O9/JjvI+7FXCHU7sD95Tx/mAHl8cEgbpl32bqwJOxyh?=
 =?us-ascii?Q?S/7kymYhD9nfQO2qN0VC/PjaD3Sc6kA0fSEk9DG+8NIUgQ9BPj7qX3MMFSaz?=
 =?us-ascii?Q?2OnnKS35q8uUNl9pWQOL2SsiYAnXK2XyoqC4a9HhBTBlMCroA7eE+QiMNUWw?=
 =?us-ascii?Q?JR+mF2YlUsfTMMGQzqRbyOItuvRspOEZwelDrSulIoubWzsGh/2skAKFpSAk?=
 =?us-ascii?Q?g2z+bBjsjilc/NQySSDbpdu7H+dj1EitlxDnwn/itMs3pADKH2yd7aHVIFGc?=
 =?us-ascii?Q?lgPe8MILAUMJwE0zDjjqQnwmWzaVd7UesQX4eIFZSkGk6Yy4xl10xo+XK0w6?=
 =?us-ascii?Q?HJSCYSvH5EA7AKqK7luvoeIZtZTAMyTd3bniOmxIeSnBFKEOHTZ6g440IRbR?=
 =?us-ascii?Q?Ddy7AGnVqeqj06dfENA0mdt3ByAZvlZtW7WjwwpE7iPgkEjPABmxz7RecVlv?=
 =?us-ascii?Q?XGWWoVixULdYa7b2PEB4xvKic44QryLxacqBOAXy+kaprv/DxTbN8/9evEZM?=
 =?us-ascii?Q?1q+sPqc+vF/YcCVmaTG3vJIUzKWtAHiLwoNKE1TYSYubr3+Z3gvs+P4qVt8A?=
 =?us-ascii?Q?C3FWywU9JRLeH30uasdOjN4trhqQG/azKFt7PddoKQLFEqX7CoUG8AzVi/WI?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0ba51d-5770-47de-8414-08db21817746
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 16:06:54.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vYukeev3i+UtbDqWUxN5eoHwA/W1QU0PMJeHO5CF/kxtlxy9j50tuMVqwo8gZfvAVHqjxXhihuMDV6dCitqDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8679
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 02:34:07PM +0100, Michael Walle wrote:
> Yeah, but my problem right now is, that if this discussion won't find
> any good solution, the lan8814 phy timestamping will find it's way
> into an official kernel and then it is really hard to undo things.
> 
> So, I'd really prefer to *first* have a discussion how to proceed
> with the PHY timestamping and then add the lan8814 support, so
> existing boards don't show a regressions.

You don't mean LAN8814 but LAN8841, no?

For the former, PTP support was added in commit ece19502834d ("net: phy:
micrel: 1588 support for LAN8814 phy") - first present in v5.18.

For the latter, it was commit cafc3662ee3f ("net: micrel: Add PHC
support for lan8841"), and this one indeed is in the v6.3 release
candidates.

Assuming you can prove a regression, how about adding the PHY driver
whitelist *without* the lan8841 as a patch to net.git? (blaming commit
cafc3662ee3f ("net: micrel: Add PHC support for lan8841")).

Doing this will effectively deactivate lan8841 PHY timestamping without
reverting the code. Then, this PHY timestamping support could be
activated back in net-next, based on some sort of explicit UAPI call.
