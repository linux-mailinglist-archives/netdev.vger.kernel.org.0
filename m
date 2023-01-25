Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F423267C0D2
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 00:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjAYXaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 18:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjAYXap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 18:30:45 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2054.outbound.protection.outlook.com [40.107.241.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0822D7E;
        Wed, 25 Jan 2023 15:30:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbPgjSAWRcU1Fe0yUP4/cYvWlDU2Wiio4kzqw6QdSemtxSvFFgMdkpcQnlpPNpFfOnGt/1xJw+KfahPGzVbfJSsYG3y4HII2HW6C6KilP5etoEnTI+A1/WoHCV2pt7u1tOnnGKxKJ6slD/5NEqGMkuoW0M8IRUL4JNl3tQZSKDCDQqNb55sxE5F5A9SqU+czY85TBeq3MYubFIKFv1Gcqvz7zS4XNvlxYw2Kwqb3ApFr/G6mpaaPw3RdGc2Af4Yg+DgbpjXSFHwoAfXbXsUUp3pO1VrVAfuzk2JeSmAHrPJCGHwVtWZKbr5DrQsY1ndNJYKy18iTfKtD4hbPb71R7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbSRYlhXKHDWI7s7LxXP+13FIwmeCj14zSYo0OEeqbE=;
 b=SVs6TEHZ9u5XwVLLTJK/a+1h2nWMewCko+rXTG5Pq0f/1nNXWVDEXfSndaw5BEw8Xr51ELx+3Yr3yCeyVTWwh4On4oaND+B0McI0od6h/0kFT948OVKPK1AGdNqd30CxpW7zFbC1VpbeOv5VYzEZL7n5HDk0PF9SjrNn96s0EgsBsuIJ+buPuLZ2pX7BuzgQ2dNrhWxYovviy/3/Ob+L5nmAbnqr/AqBY0kmx2sQ6Y8NVFfoyCn66/ZBKLMoZDnHsqyWYNxwS4kcKHrUX8gjjbAD6wJci4zNQ6Lc08IQYn3lxTaME5nv7qkt5UoyBZdfXOADV6HXqtctwgXWtB5LCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbSRYlhXKHDWI7s7LxXP+13FIwmeCj14zSYo0OEeqbE=;
 b=lzs1huWI4XcDhrI8jZjJAPAYEGJeU54Ye7d7udxDIuR4v/AuYPaH8fe9ByI8P74P/Z8y8rjPH/gG4nsXGtiVcKkCnRejk/jG4Bjg97pyM9LfLTeg07L3+9wEOlDJ8MV1H431cpNyGPPKTmlleuxiU/4AuSIlE6esZO3hUWrP25o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7446.eurprd04.prod.outlook.com (2603:10a6:10:1aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 23:30:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 23:30:41 +0000
Date:   Thu, 26 Jan 2023 01:30:36 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH v4 net-next 00/12] ethtool support for IEEE 802.3 MAC
 Merge layer
Message-ID: <20230125233036.xg2aid5uhzuxmh67@skbuf>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: FR0P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7446:EE_
X-MS-Office365-Filtering-Correlation-Id: f7340b6f-0227-427a-d3a5-08daff2c2c30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQ8Ki+PZUguu2Tai3UVsSnb/pY1THrScJtSFfi/yGjiInHO+nwWWpZsYAKg8fpbcDiOI/2EkwUUtFP0CPTv5AX62CnsUmd36CGOeZBxVg93PNrxG8uqCi5XMMirK8/w7peFCLvSo0MuSu1M3OD2XQsCf/9F4MVAdj9b0WcPYMelkTxDBb3FXqm2AAyu9qhvn4oE74VJggWjsrtx7WvK8TWlknwVb3r5Q6JybKIjl8jZ63iQApjR7+epfMA1W9FbFDV2DPmapRzQ3VdQbPfXufauE9cBx1jeNSWMD2sblCmA6YnIVl8dfzMEkCTxnAq6ob5sT6I+ffUTO35txgfNMMhYXgy84qES6QO7XWGbhAAB6YBPMTsM6YUjjiJvdn8f7+dvOZZWoVyC3jjfIIWAQruyBbhin7711SHGMm99+vR8+14CglfweUm3u9zTOAi6bRTZkVOJxwvpUx4J4v8p8rCS7PKf7YJDvLu7ai+udhY6BBxpCQmF5vMGGOxdJbIn5LpqaVsDOh3Wfyk4dqR5iG08aAMsg3TxCrZl1hcWYFDU8iMvvYwFphxqDPjsR1OPf8V4EFQYUL1yT6cEUte1PVWP6NNRd+X5YdlbTZNty9k0CrpsTi4WPf0VfDPjN0apQW9SiWbJjExMBbHwSpu4X8o1RH89Iu6sBl/7q+uFaEPwJBgkM78KgBx7J6YRbmDV8xdSospmgAItZyTtV8/L/JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(8936002)(83380400001)(7416002)(4744005)(44832011)(5660300002)(2906002)(6666004)(66556008)(26005)(186003)(9686003)(6512007)(66476007)(66946007)(1076003)(8676002)(6916009)(4326008)(6506007)(86362001)(478600001)(966005)(6486002)(38100700002)(54906003)(41300700001)(33716001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dAe2WgCVMmIOBRRxGRsGCiuhGMcgibYLPA2QNB8v+dwt5JX8EK837YdukNNf?=
 =?us-ascii?Q?Zr+uRhgI2AMzN//vL7juQsezmMGy5Hl2sTIbGd42TlShfDztJjmuF53hOWfZ?=
 =?us-ascii?Q?LJ45XYRGJxeQUaO9GVaIPScnyQFAQd9MDWAnCCwpBkVhlhdEBRiTZd9MkB4F?=
 =?us-ascii?Q?nVcoukFLhY5SMaFm2i3gZR+8DeQPJc1kHiKVErINFyeFyNT2ItOkXyeqn4lg?=
 =?us-ascii?Q?ZjzOPptpkc2yCU+dcWKIzR1WFN9vmTv3xOkUeS+Jedqdhj+FtIWH7OYY4sp2?=
 =?us-ascii?Q?XwU6x3TQeTKeIZh3MJkJ6in+F1qy/d/nsASHGuxw8o+Gbn1s7sqyPJRrhv+E?=
 =?us-ascii?Q?MKiye+JW5FBTsNUeVIGuv5ATwRT+JkXIBCtxs2a8GGyr5gcRU+gnlyff2hae?=
 =?us-ascii?Q?Uv9fsNN8aTe3iORGu5D3fN95ddI9M3x5KObDjjHx1Gge61DckZ4DD0yQr14c?=
 =?us-ascii?Q?eP9s+bONB6u9Vsy3QZQh+LdRiEpaJoE74oPLRPITaAuXtKQqK+I0aRKScQzr?=
 =?us-ascii?Q?MKsDZMvdeY3O2mj0iDKYkbiX+x0gr6q42NqAFwqxvawlUdwSbOrh8CI6QePW?=
 =?us-ascii?Q?4Z8TGiAJUlWNyXzdUqkQBeAGa6DqyOiZmwnChbADcvMfoO4GWm7B2lMhpAyM?=
 =?us-ascii?Q?GQobr32OwSXV33RSKuagZkjmHfiz9Wm1nW9xlsaxZtNPsdw7gX5dkWlGXAXf?=
 =?us-ascii?Q?q6Kar8PMf4r3KaKQzXJb68zbET6incsUUl2yWBdm42VszQlRaqLldo9yWzaq?=
 =?us-ascii?Q?y7K2vFLKzQr80RHSW9zZOLVizLyh4YVqWZvzYSG9y0fZHHJHMTYLMi2qVRtP?=
 =?us-ascii?Q?a11Dqq63T7yXqsSuPze17UzyuQNEU17oYGC1A5jcnqWo1ybnP3IpN7bk3kU4?=
 =?us-ascii?Q?Ti0DVXNyNP7DNZrSUyvIJ6Zu2P9ZGUBxWB5c8ZnPovRe4wh7Mf6BCeFyT748?=
 =?us-ascii?Q?gYN69xHd3yCXvP4PTe0uxHv1xt85Q71MD59Wr5vxbqeQwdgiHFO1Mg2y09bv?=
 =?us-ascii?Q?pDBTpFb4xdZX1MZdaPutgBAxd6srSiB37fqxiUBIcYkzYeCzc3L0n26wiHge?=
 =?us-ascii?Q?hfkNflgSEyfvy1uj2+3nMQJTCN1mdH729L5XMJcpRvbLBDFnbkG4p2OLAat1?=
 =?us-ascii?Q?6sOybC1oOY83CLhrk1E94gJLy0NYDZ6qhCZQim5DVPr8dzfbX3WL1To9t6B4?=
 =?us-ascii?Q?07KkgQu0LoqIy3cI0bgE7/j592YbIraAfTg0xjESYoqZUWVZubiq123mUJ8g?=
 =?us-ascii?Q?+D6+8hcf1lF23qbnZyPCLlaYKa4k+ENof/0TOpX9SHYs2hClDOS+gRdA9b0E?=
 =?us-ascii?Q?IPdZvcF+n+DtxBuUWBhrGPdB6JkKzESMOCayIltJvapksl50iO0+EeHTdZHd?=
 =?us-ascii?Q?JL+x3qeo48yNNCLoA/bqZT/lzaXo+47X1+glNQoLOE4eV9o5haz1wx66xwXm?=
 =?us-ascii?Q?LfPLrzd3NLbYTSSqXLITUi0R43zJHnrF5AI6quVQhdiXjjbYcfen7IXKoWLx?=
 =?us-ascii?Q?ZAUC2mbYK6HX1HuYA9jmYk2AMyf59kMCYNdXGa9oFHfJy31YkGa6idkmz/Wz?=
 =?us-ascii?Q?bVVLx9OhAcO88knxH3F3yaJxXu84CThduRVi+NVgzMs+qh2Rh0ImjhbswO1L?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7340b6f-0227-427a-d3a5-08daff2c2c30
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 23:30:41.3575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVmDSzJ1MJU4yE9pYxlZg3dBm6uRXplxW3ZdXlPyGCkLQzy29t0f3b63rZ/Lm8ZibA4DVWqQNvYJgCKHzegYkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 02:26:52PM +0200, Vladimir Oltean wrote:
> What is submitted here is sufficient for an LLDP daemon to do its job.
> I've patched openlldp to advertise and configure frame preemption:
> https://github.com/vladimiroltean/openlldp/tree/frame-preemption-v3
> 
> In case someone wants to try it out, here are some commands I've used.

Just a heads up, I've sent a patch set for ethtool user space:
https://patchwork.kernel.org/project/netdevbpf/cover/20230124142056.3778131-1-vladimir.oltean@nxp.com/
and a pull request for openlldp:
https://github.com/intel/openlldp/pull/91

Waiting for these to get merged before I submit selftests for the kernel.
Those who would like things to progress faster can help with some review
there.
