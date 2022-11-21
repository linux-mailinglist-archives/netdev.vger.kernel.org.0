Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB68632A0A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKUQvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiKUQvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:51:53 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140071.outbound.protection.outlook.com [40.107.14.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3520F3C6EE;
        Mon, 21 Nov 2022 08:51:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+MGXLXCnUav4NkCt1JScMOqnd/BtnmSN8G19kk1K6KiQ0/Db4BFqUrQlS7G5F42+6Ne9KHy1B2FA1pRuE9i0JzpQvgYAnmsO+SiejKM7gRqW0TZFdGZIje5wi5HKv226uy6YXIh6emqFiCLWjOBRqARv7FMM9LTt6jLMCf8VB6/4k2N6IiiPoR+7lJAv213g8n6Rj1fnNP9pc7vErU26kTEQXx8uUj2MIVPwntifAipkF0PUsNR5/6RY/1U/RnIY2of9ksAU3fKGt4oWxIq9I9qZECS1vNR+nAEg0+LNF60bQCOvPaR5qcUcUwb3OwQo9TXz/mzt2Iq3SLXe1eDJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24AG9APXAQx481NlsmUxBYtRYp4ugjmW0kNffZzK4l4=;
 b=fC59uALgCfi+Vs6WM/bGLztItSIvQyhOjOqz4PlI/FP/tsbJbPeRLpiHv2qUoEYsSJF6k7R327STB8ouOm+9shqw+JdDEyvqFNgVmcNxrHMgkKpfv+hgHtA+oh2ZSQfR2GfsE9MmCd6DqAHco2La7i/XEHNi/daujKmv3fUHzRz1T3hfjucyEUvzNFpOXpjuQYUISL1nlWD1GU67ZW5/UDUzveckAwTEytcjrzgctEdKgMyRJKVms7s8/Y1Cu41fJZfS9d5Q8+BAbBQvP+i3gZmtziSdIgZSv+GJQqG8fYb8njz8ZM+tCDBu6n55+Vf7J+GTzVZblK7Gsef4MTcoCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24AG9APXAQx481NlsmUxBYtRYp4ugjmW0kNffZzK4l4=;
 b=IPMZ7oPn1infQIpN+ESIAXIGlFBeqRISGpLh449wZ4FP+l4A6c33/PKeoOKFOdpnvKNzd81VnGjyVtVdd6P3PZXZz1s+UkF2iNSqGuhayjx8ebgBRTmkjHqyh7pX/W/G9cHZ4rBra42Cq5hWD3RE0FH76lY7jbiEyof7qr2bVXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7356.eurprd04.prod.outlook.com (2603:10a6:102:8d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 16:51:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:51:47 +0000
Date:   Mon, 21 Nov 2022 18:51:44 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v2 net-next 3/3] net: mscc: ocelot: issue a warning if
 stats are incorrectly ordered
Message-ID: <20221121165144.yuwmdqkhtxyv5mia@skbuf>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
 <20221119231406.3167852-1-colin.foster@in-advantage.com>
 <20221119231406.3167852-4-colin.foster@in-advantage.com>
 <20221119231406.3167852-4-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119231406.3167852-4-colin.foster@in-advantage.com>
 <20221119231406.3167852-4-colin.foster@in-advantage.com>
X-ClientProxiedBy: AM3PR03CA0058.eurprd03.prod.outlook.com
 (2603:10a6:207:5::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 718f0e9b-3512-435d-d671-08dacbe0adb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qG8PDgoZapgPGPmy0apVvdOjylim8/qgqn9RxaDyFLXkHy+4AUVbyV0KG6eD/FsJUNsluK1a/IJ9KU91Kbu2hy+rhN3uVShBFK7wCtqyUg8GT9VPnYGoFUAogUZQc975XhIYV4L3mfr7XKsjJfVr7JkvBOLWLauKalarNxGDH+NlLVmgY75nrMHiDrTAg23QO0Iash+a9G1/QFG5s+9TKgOB40BeLERJ9gzQ+sW34/W3wlscBeoak3ui+1eIXFPXIrAkKnfJcwu3jvtBwmiytiXCFhZ4SpIwWUALH3VzQrpN0UgTO75oiiBM7ELwzeXGXB/CY6Ph78fcTbz+GJiMx/LfAFqfI9U8MXc+dYGMXO17azbJY72K+DaRJmM0YbrLTfUT6mPr5+0TfL0WQmMl/Lxsa794bAotQ9bE8Np/KP/rYfLvMO0YXfeZiSh+x1M5RVknH4fA6sp0ddpAvw5ZGId+mAubu9FktlbzqaaT7g04WH3lDIhJBlj96ydVckhRNLCwBy+XP3n29h5ImnqVYIxzbHrUwEkQy2WtdztdfXYe0p2YDIVsy3XBCRt0LDvJD2y7LwfSvyQ84sFYJorWcgKpapBOQbVUgzTYj2QzUe6hp6aWwtKpdsoAKNRtBfL/9NrGCA55WDvlvn0E0sXSrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199015)(86362001)(38100700002)(26005)(33716001)(4744005)(186003)(1076003)(6512007)(6916009)(44832011)(9686003)(83380400001)(2906002)(54906003)(8936002)(7416002)(6666004)(5660300002)(6506007)(478600001)(6486002)(66476007)(41300700001)(316002)(4326008)(66556008)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o6f+g+hQ//ti8MuAs2ue6PCaSf33h8Dhd265mtgJlGqbD+yh2xMPcC2Bpdmo?=
 =?us-ascii?Q?TKc9RW4n7R3evJ6+/hoOYgV4PvVeYtZ0vBGXv46c2GNLFsO0pTX//uYpULQX?=
 =?us-ascii?Q?0B17HiSCfvfXNtYA1A06ax1RuEi/J/Ywol+RmwgP4cDFBLcJqYc5P2QuKP9U?=
 =?us-ascii?Q?F0bu1k2UV21feUyKoeFaKFTBA4Q0QpH4hhp5lIHGRenTaOVs1BhiX4qLmacf?=
 =?us-ascii?Q?KQmQC96TRCRi8jKbwqZI3jDdCaCiKZ3mrRzwdIucUY2QSOg6BYWXak9I/1Pd?=
 =?us-ascii?Q?TGkazlN1qgen8EzpqfN7rZ1gNQNr1Ld5wAirQ3EzJozBqE1wsl7UJOzN7ANR?=
 =?us-ascii?Q?TpAsechsoYTAX0DMywUVWrNWz8PGNP/KYT/HXiWy4236a5FjOdYHd8N+QiWv?=
 =?us-ascii?Q?rZLSlAVdBT9hFzS1fnlrg06OZxyja18xiQIKUoPHMal5u0H0nALR3r2trP+0?=
 =?us-ascii?Q?bnsJnDMzFEzUUluHOlevANmzGQblCjocDJfmaqpzi2g8QA8vQFZPAb+DfsEG?=
 =?us-ascii?Q?xJJ9n6efElwTl5wxeDVCy/38qYaAMyzu69mFI0rmrSRFLaBf9CHVjw+hb1O5?=
 =?us-ascii?Q?bqtd8njMh6UN3ahQhIeHd6B7IVu/QjCAiDD3/7ZmQ0AznwSbxwIt6jepUigr?=
 =?us-ascii?Q?rhii3v7yBQs6Nc4uOtrVljy24R90+oxqmiCTUi7NnU56Xr7EINwlnMH7IM8x?=
 =?us-ascii?Q?eUTdWUGPFtddKp0G2/8L0V11g/4mnnHLdpWlDhOc0n73nPMfc5uzQqvOT+Q9?=
 =?us-ascii?Q?gEt6+1PD055Lvp2vQtJubobA5EGC1OnkBNB38lswCtwkAAo77K6aMsMFSyLw?=
 =?us-ascii?Q?FBci7mj9CqixWvcDX948cSBxf+U9y0DepHO8gPvDQTQuWsBCS72jB1K1BEpp?=
 =?us-ascii?Q?DxBkMhAF12WT+UtoNecTiO2PPeMFy7EGDT9LDiIovjFJdTzbpvlnH0Rq+8fY?=
 =?us-ascii?Q?TvxH5gVqVDdqD6G3nqiZjPKcbmsAY3Qevv1G0UmBay5uwxazq9Krdj5655if?=
 =?us-ascii?Q?JHDHPEY20dklume2XUaRoX2kHK2WBlU3F5oDNnPaefAVBwKwTjUYnwx2Nobz?=
 =?us-ascii?Q?o1KiVHhgROOMN4t7Z2QW6K/sQGPLkGn1WB21NbhrUqXYL5mNHqaRbry8CF/Q?=
 =?us-ascii?Q?DMzQDZNK2rjEIe/orRHPXlrrhbC+bzHq0kZXSbazDffSBASfMqPVeywS1VQn?=
 =?us-ascii?Q?DtgyT9Vpnn4eMSNOBC5mBRvW4J2rU+EeRvXuVpyG4wgR8sjQzFOazgspfVOe?=
 =?us-ascii?Q?nR+2g1yds0EyCelRVbfumEQAo9tuE/steDoYXVaASjzk/I4zu+eqnVC2Xwj1?=
 =?us-ascii?Q?2gNgJV7AWixBmt68Vj25nxfnRalujgXtQJZVCPbigjE4fNZJ9vyP6TuwiakR?=
 =?us-ascii?Q?zphogAGNNGn2bgQ/jHFB2hQDE8ZAua6jGtAZ2Bx8hHnNCg1iKAx0oyRIGeSk?=
 =?us-ascii?Q?khEJKUNEDtQuOW5/9F/HluRBZRG0gnATZ/wJiyqc8hzzmy9gZLwhABK5RMRd?=
 =?us-ascii?Q?pmRzeMxCfwffhMf7J2Nns6ZdUkgC7JmABMivTdZxAoQH6xomr6erLwpCnj4t?=
 =?us-ascii?Q?0eatNhMLaLqxOI702UoiMD2P/2sdSwYH820AwvOFuU68ifRnxUyWq54H66+L?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718f0e9b-3512-435d-d671-08dacbe0adb9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:51:47.5815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJT1PSlsk09Zx5ILZhgQt8WRBr7ETBQm9ieDPUy+2LSIelmxhE7jSUjvRO25vrThLKeIsODlN44QbhlqsLg58g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 03:14:06PM -0800, Colin Foster wrote:
> Ocelot uses regmap_bulk_read() operations to efficiently read stats
> registers. Currently the implementation relies on the stats layout to be
> ordered to be most efficient.
> 
> Issue a warning if any future implementations happen to break this pattern.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Assertion holds even with my MAC Merge patch set that's in preparation,
so things are good.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
