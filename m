Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9EB6E0B29
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjDMKMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjDMKMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:12:25 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2051.outbound.protection.outlook.com [40.107.13.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E735A24C;
        Thu, 13 Apr 2023 03:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alyAemTU4OJLCYLvdzK4PC5khwdBpe3Xo+VWCcuXGPyAeJ/O3de2fSZFAPHMjzOWn0fXaDcARj61NJX3Fph4bDnhHPKn7igfMfjHqvdxezybOxDso6RCLEhBnn+ffPROBXZcL5pRU3TmaWlF/5g8LN8YdI+zOnu41zATl4GOoT3aIV6FnqQjXNMgDmqqsgtedrFWZ2M/nJflMsLWGrJK78d3mFBhhsHfjIrHWg3rjhqkQ+/A3NpN6yursRq9AF7Cy2l8rMLFsdIGFfLCAtrxF107lOY+bm95qzXrK+IuyIdDcIuSABH6oBjF7M+7t/2yf3D2ViXC+GUDnL38aH6nsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHhNz0Zkg+L4MvWVug8jnXTyFbF6qXrq+25u6R8VVuc=;
 b=FtC4+nx8M3gIAlfONv9nZyDaCp0F+TX43bLZRqfg6jLHgQhoTcXYkvaUrei2bsnMr767Cjo1j84iWhUNcSMDU2UVmeC2FWnVdpFa85vOlkOnXjqTtiHjZB0AE/aeAJ5Asmv3qOp5c4bi8mBHs8Uw6qCDYKq2VluqIlhz7vlyPMnog2MzhSrA9jeVuQaLUnW1Zy3FkkY/nSjh/Ilxs3qTgP0xKx0M+0GMpgN+rW2hIdJvS9Z8uhSpbbKDGiOJiZm3Y2IkzYUpzG5l1EeV2WIzLatMyBxAc1J5GE1xwEq7Rv7cHSALnoA9USrt7WFjjeVQ5428rD7H6lmHZJXcO/vFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHhNz0Zkg+L4MvWVug8jnXTyFbF6qXrq+25u6R8VVuc=;
 b=pQWGS0yqrbKT7O9o53tfYLsHH8TL0bQDLhLjYZwRLsh76KmWnaJXlnbAgzdUraCp1O6l6ZjDAMrsvzx5AB5zqHE45T3S5Uqbp250oLTAZMzIrtPoNQ8i31osh+A43AJv3kX0cwoZi8ZRj0aNmueNsvBRSSHE4op5l0PeA7jf6TQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8831.eurprd04.prod.outlook.com (2603:10a6:102:20e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:11:33 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Thu, 13 Apr 2023
 10:11:33 +0000
Date:   Thu, 13 Apr 2023 13:11:29 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: workaround for unresponsive pMAC after
 receiving express traffic
Message-ID: <20230413101129.5zn4kv5h5mvmktov@skbuf>
References: <20230411192645.1896048-1-vladimir.oltean@nxp.com>
 <52b8b6e5-3ef0-6143-1373-e41caef19234@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b8b6e5-3ef0-6143-1373-e41caef19234@intel.com>
X-ClientProxiedBy: FR2P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8831:EE_
X-MS-Office365-Filtering-Correlation-Id: 9add0bf5-bee4-4694-7460-08db3c077567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jcDmUNdSWnpluWXFUhy2gcivGfdsXOzOYLfrDUKf6Y4vwmgFxhjbWFNTlANJHT5NIWa2gmOL3MuUky0pGk3gBnZIXWeM98ftRm3VTxnsoS1mL6x4IK9pJSc2RREMk1gxxyay8U6vTODH/ErtITitlVVu1dfMFMzkc1mEiH6KKDqGpo4PwX6X3liwzNmq/qW1B5q3d2pkPtGqJtgpbZnlI5Lf+Yjr06+wHIB+lu7paVMu5f4yh6WO+zDJrXacNcwzw/yK361KvA9JrsOSoIZpto8gXcHHuRV58hUTxxOI4NsVUh0bHxMisQ21rn4YRaUk3EBOGqUhE+5o1NzCSWM+HCvxWdAhJv3munDVSyZoR/S1WPvl42bDVF4roJL2/kObJ7gz/mL3XvE29gV8TPtcOg4Jw7q5u1OCc60iwMhaH9O/oSDA5sUQySqSTdaoRX+9xn2KiSgnTf8dOB09jPq7QZRnFWW6ssV8i4/jT78nFDjywW2hlt6YcVPhYGDlA3ebBxMFZ/8XE5x/8UVTBJzYkoW36lMyK2wI6zpKjEZaqqQTzS+DN3DS2i+yZuGwwlya
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199021)(86362001)(54906003)(44832011)(33716001)(478600001)(316002)(41300700001)(38100700002)(8676002)(8936002)(5660300002)(6916009)(66476007)(66556008)(9686003)(6512007)(6506007)(1076003)(26005)(186003)(4326008)(66946007)(6666004)(2906002)(4744005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vN1Ubzl4RXbReMIzGFrto6Dqz3/NlwyPNTmMuxAhJfmEvT3fq4U3iWQ0g3tu?=
 =?us-ascii?Q?1wdL8RxS3nZjIYJkThNjaD4X5E9wndOW07ZAxW89jFgn9zkkHBauyQ1YEY50?=
 =?us-ascii?Q?dCQxeyHk9lvk6rOzVMdq1UhKdpXcKHgEKIMoTUmksognqRy3zlMd7t4JsMPs?=
 =?us-ascii?Q?wyFsbtYymJebAJ0EXOqm2ECs+x5mXPzIaKEItubhuj+fF8rSwpDnqfrSZwuw?=
 =?us-ascii?Q?1mwGsAuDh6zseX6b5GWgpqDtka2qXGNRs71VBMjOCQ+jMYnywKYBZp5m6oNZ?=
 =?us-ascii?Q?Xce9Zqtoqu8OUOmCY2ATEcfYKd5pKhw7RBf6xVFzqjTkjcf7LnQHuapfYrxY?=
 =?us-ascii?Q?edrjGj5kt9bYKmhLNGs4IGfpTBIB/+DBPrdnR7TsPe6m7I7C228/H1W6+DyD?=
 =?us-ascii?Q?sFSa9QwQjawkKrSGrfx9k3Wdp7g61vATBpkEBeRceZGYjAGB1q+i6Qqel4fg?=
 =?us-ascii?Q?rHLx2WLnk6+/4cn9+FX2W9fftexKzhM6fEL/fXO+wxGLm7HUQDSImdrDEch1?=
 =?us-ascii?Q?MKRY+JV9yMJ0jZPYq9QKf+KELur7VwBCBksmS3qIenc9P7V+YBQmuUZhdC5V?=
 =?us-ascii?Q?2H3dB7Db0nJs7XuhFCI6xn0VXZ+X7I5LknwLRBte6GqWsmYApENLBYd/21+Z?=
 =?us-ascii?Q?GI55z+68etU39SVShL5kCDPO69aO/RLyJ3svgh7gV6Co6tDEDZOrCdjSpHQc?=
 =?us-ascii?Q?ZNGbpPRXTZCf+8eni7xLrc3D0BgTwGaZe7O+D5vgqI/Ve2KBTK7wo55Sq9iX?=
 =?us-ascii?Q?8mXF6aL5DLx7l3BsdBOlKbhsQsOlVIBNYjJFEoJv4cLZhm0ds0+2qe4sGBB+?=
 =?us-ascii?Q?6NBnJ/5i4lI1NPL1RcQIaQZb9UB4jbu3+XJf/q1GoykVzX0TNDiNGi1d64ey?=
 =?us-ascii?Q?JT/88EIq08aG5j/UCWndt1LhdQB/s1pQ4EFhidx9MOybvKifwCMcmszlkumA?=
 =?us-ascii?Q?8gA9ekm6WUaSEa7ZFjgaHIqzoQ1VHblTnvj1+4G1eVmwXoBfJgopt9K/6dSm?=
 =?us-ascii?Q?3s8O2dW0Nv7xE/S7ElNJukJtj3eS8+kb+289CvgcdheMA+eUYyHR2E7DH86J?=
 =?us-ascii?Q?oglt0R+WhMwMssAVhl/al3XZvwJuKFyhJqJYEHUX8AmdgMbPZO2/Sfy3E0eB?=
 =?us-ascii?Q?FycHKfQfqSHfSPC+hvigMSe3vN+j9keDFWGcMsS40VoXnpVvVrTNOfuXhhe5?=
 =?us-ascii?Q?Vppnkf+s92t+bLwN/IG0VmV+zQxslK+WcHRzCdHYcZlmbsj46TPEI1a5QrF0?=
 =?us-ascii?Q?MxKMP8IkjcWOnkx9gt3xeBgrb1X7oXjCTspmR15ENPqyAio8JHpkKeKOL7o9?=
 =?us-ascii?Q?LfaSvyEEhthVlw4LKZSokyXfWKTX+Wkb8TSCbrMPXkJ6lnKR23rFrY2Lg5fx?=
 =?us-ascii?Q?eLyLqvFxYXSj4Yb+XRMOWndLN+KOqy72QPbjmhoOfo/h2u+Z4VoRjiO9QoaN?=
 =?us-ascii?Q?Xev1hIuC/mwGh7C97ZF0fqsuJGZ+ClKpFmQmckJ4xJ972p2SgH4jgUI/FAj9?=
 =?us-ascii?Q?3ireSSg8t38imPLYi2vbV1gAygZ9iYACgRdKJmRXU/WJzGgsHoVDwg/Qfbot?=
 =?us-ascii?Q?oP4IjB/tLleYa60Ep6ZBZJ1Fam4ZOCfFkcezuiGoRFPMArvZzMYXyWYprgOg?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9add0bf5-bee4-4694-7460-08db3c077567
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:11:33.6754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mOIIWatVweze7nIDzJnkeRmrdCj/PlX5qH+Y0cxeSgcPVl8/d4xwcHSsuAExxMnNHsr2p5CSEbm1mgRnzwitg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8831
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 03:38:54PM -0700, Jacob Keller wrote:
> Frustrating that we don't know why this is required, but your outline
> here is convincing enough. Thanks for a thorough explanation.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Yes, uncomfortable situation. Thanks for the review.
