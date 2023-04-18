Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11B56E692C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjDRQR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjDRQRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:17:24 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2050.outbound.protection.outlook.com [40.107.105.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C1B44A;
        Tue, 18 Apr 2023 09:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITtqPOVfIwRpL82G0lOi61xYLXBCopc+Ic5jdeUix3Sa+cuVJIh50ODwD9apMoB1p9kJ3lXPLV1DLy1ubHLKoIN9MInzrfa+vcJzfLdnV+v1S9xxHMIgLISVbAe25cNAdoanuE8ZPqCJRpN+kwmlg4AiQ4DkAT/FEB4Ow8X5Rd3fBmGSwWIEX9nAO/EdmwyvgDM3iFYLfOAOlSaGxow0dGRR8RIC6M4IUx9f8wz66VyJI4aLMNs0CfWMlTgB2dy5SV+yUB6P9twxMcEGPPK89EVsQ7Ev2SKksm2ZDc3r66OlCge0U4uPyMpQEMOc4dbuOIM071TBja6Xp8Eb7dH0FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6VO2A8LjacJSMfbsVskum1GES1ae4BPeTdsxEUwqPk=;
 b=ZbMAGCLyGfdS8CoPXJNKCI39B6xCC8kZ2rWyErCHQSEwRZcPisJ0lxDO05y52b0dfh/952UFZldZErsQ8ScRmtNB6FLfMe8TBZ1gW0GZQ/OFDlsSZel8EoeyXDaj+druSOJYd+/N/xaoLWGmv4NPUR4qT76feOB4mJbGxav+zWTJuWfn7qRH2u++397bIo3lcm2YHtcFsW+8IlBf5COUgXh125bfbGgOeIU193OSLruPykY//XZpQfKoIb42t1LtURgdLToWjndL8ubRDblXYBYI7HGmF4LBgD83kFVteXUteQpOclss2kaV888pl5pH8zBCKhoDkT/dah0hjQpCrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6VO2A8LjacJSMfbsVskum1GES1ae4BPeTdsxEUwqPk=;
 b=M+XdPxWXfYoKn5aI/ozficCLQslC61oURXW9yYWqpRN1vbp7T6T6EMkNUFCg91sEXxyMVbty31eKxh/7Neai7w2KWC8nTvMP+RqKJUyQ6YpKforzC+MyqzRG/IYViAxktqWnZ4t1X5Xx67vv99HaAVvrF7ZXQAZ1Str02xLRzRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6911.eurprd04.prod.outlook.com (2603:10a6:803:12e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:17:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 16:17:19 +0000
Date:   Tue, 18 Apr 2023 19:17:15 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: remove incompatible prototypes
Message-ID: <20230418161715.3lig6wyv3baokvpe@skbuf>
References: <20230417205531.1880657-1-arnd@kernel.org>
 <20230417205531.1880657-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417205531.1880657-1-arnd@kernel.org>
 <20230417205531.1880657-1-arnd@kernel.org>
X-ClientProxiedBy: FR2P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6911:EE_
X-MS-Office365-Filtering-Correlation-Id: cb1d9fdf-f2f4-470e-fc52-08db402861ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mKopn9ZPG3WFVwEcPKx4Ejj74PM0mpHRCzql8nTbwhIhdVEifhs9N4CTVn07stI9IMHXEZmABaMh46BW/U5LGA48cxxfv90FowDANQMEd5VU3P4XEg4WYEog2rfMb/HwL2Wrc3MMrcDETNBS+hOCTqjkXWg38Klg4thVkV+f4GYAnv2CEvMc/0dYQ0mPGt5dAZ/5epnNQe7UWlf6gGCpIdV+t9K7p8Q4Dr2lWSSCT5vZ7noOkJdsfrn9TyZK71unvfFVrnX9MRkkdtY8A8wY4Y8VITUF89U9M2o8lJJf3MtLLV1AOXCT3ITX6bgcKrLwQZ/OlMmQ8WATtjNpsDnl0XogzLUbfVZc6vuCZG5xXuZ6bTuRTbvSCy6I6WNt55xn8xomlb43/kWFHLXHjO3/JcLsSqYb/pbtwCCWp7N2pQsAMmxYJS9xdJqt2Msw/RxGKPxLJrtG+cnr4fXbmL+bPKmKhsKdNbJbeWznEV9u0O+Ga2x7nM40yjoE6vWRwzuJ9lvkBAmJKo3knbRrGoQ3AFP0alkprnyvqcBTrestb07YiY+Ia+Q4nr1lPmjaZ3a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199021)(38100700002)(33716001)(86362001)(41300700001)(8936002)(7416002)(8676002)(6666004)(186003)(9686003)(6512007)(44832011)(5660300002)(1076003)(26005)(6506007)(2906002)(316002)(6486002)(6916009)(66556008)(66476007)(66946007)(4326008)(478600001)(54906003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2a/q6x9F8tlAuiRJ9/NRyK3jt+KyAFS97tf8Zah+YLsAoIrB/ur0TuFm/8Lq?=
 =?us-ascii?Q?CDB4HZbTbu8NyYrFwk9dBjWm0gMRy53HK5Rs0gzRAljmQSz3X9zgsUd6Ms1F?=
 =?us-ascii?Q?eRPKLeWcL0cGJeHZRubtt/yhKfADwfdPvteK1Sadf5m80y2NvgLfBxcOYYPv?=
 =?us-ascii?Q?4yOyZNV6Y9jxsib4MvnQC6Zzq7npfb6mXM6E5X9OIhWnWgXERTOm8zDHNfFo?=
 =?us-ascii?Q?yYpcpOjLoWNSCVda7r3j0PMOmuz2H3jZWVuOTabN22torsdwDuVgsBuM0GiV?=
 =?us-ascii?Q?zec4dV/jsFd4NCace9gFuzrOoxlbdXLIhspFKTj39D/F4yFedSyP8MyJigQc?=
 =?us-ascii?Q?uAqZ0hVwXyVqR3RqYSCBuPEL5QXG3z/4X2HdXE18J5Wzz8X3aPwlCuTPvW09?=
 =?us-ascii?Q?lgg79Jex2KNieBgnPVCBXdhKimYpJYhSO/Kn+2KHkZFfdOlPnFWd4SLl4K+q?=
 =?us-ascii?Q?bsodKSwgmM6YEqTVptDJeWhCfYPN7KflFt3Qflj1J8OdFwsATFIHfBKE2/1E?=
 =?us-ascii?Q?9gsWUVHHbMh5c9hCGGoKPE7a+UoN6BwGN+bxTnZlC8qGWIO2XfEscjXzLA1j?=
 =?us-ascii?Q?OjzJyTcgvPUl0vk5IzGrg7sBij3EAFK6fYaVLU9nL0MUu1/wYM2vPb24YryK?=
 =?us-ascii?Q?XZgUrmfYSvx+uIsFAPKxHUu0Q7h3ZOXQh720xaxSfcRes4ZN0SJRvJviuPWJ?=
 =?us-ascii?Q?l6qGayv+JLjVG/YavcVvQWNmy/8+U5a6QQ2lBAIW/bMZb9Se0pdcZmFtUTIC?=
 =?us-ascii?Q?2YYGc9ExARThp1+KIHBhu1023aRzlRWygvAf3LN2wnL00etp564S4dmZNbbu?=
 =?us-ascii?Q?rpDLWua1Xt/LoDkWYLKky/QpYHnRv7wiyczI6CehHIZ5YLbEnypWYdIvDT1A?=
 =?us-ascii?Q?vpMAcjBM3zTxqRVwupGervRe6N68+Mw7xcAYY+x8TWsAyRfcOG+LZ722fLAU?=
 =?us-ascii?Q?lOgomnffmYTOAl/vXNJNu4TnZnKWdGN3iISHRCtUplWVuJoaKSnYpvf/DqGa?=
 =?us-ascii?Q?tZo+BK0yrJs0MwXHpnC18zuKIBNX/1h1P3HX7xu9HMRg0Gfk1enOlWW3ZTEo?=
 =?us-ascii?Q?h3lJLnOSo6WU69G99WDonTb8VlOb5sgNhdJ9XjRMIwn55ZEBmGH0CL3ZIP0e?=
 =?us-ascii?Q?lMc0BEwNJ39dVYYhudMabYWkqciGMNwz0Iu7+313ic+hkPzhmtID8qsRkbY6?=
 =?us-ascii?Q?LJRC0rvBjx62c7j20NrHe3gC2Lo8jBKUwmZNQ2CqEwCLtaQgsJ0Xy58nsN+I?=
 =?us-ascii?Q?Kpdpus6jOJVeazAUB6ZyE8aDZNEfT4qqmj1Ct7uqYBa427LH8d5umiFl0wf+?=
 =?us-ascii?Q?vq6rsHIXziIOBPeIgo2bWkPzR9yEdmDkZ1/a5kRYEy5H8JQty6FYVlZfSmhZ?=
 =?us-ascii?Q?ZrWmZZPDS7Im/Wsul4sx6OMdD2TtNUQQKFqscsYy36FZsbSwA5iQ9jbJ2l0X?=
 =?us-ascii?Q?sU2CKvZXiMkDjzOtrBA01h3lr+eZWuXOKDOPBSxrvEq4OG5+89rRERtvADqd?=
 =?us-ascii?Q?Y3trDhnFs19os5P/lC1CUPrs9zymwlrDBhqWp6taJKr9Ml91oKb+FBUJrWmy?=
 =?us-ascii?Q?QNbAmQ/qd3NxLZpVrmpLv8TgKC8GEUSmnViwFw7I/xhkQXOWnKGPYKgB1V4h?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1d9fdf-f2f4-470e-fc52-08db402861ee
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:17:19.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WkTSFNyeb7sZ0oX7/hT7p/TRTacvB0NdMKGGMlwkSGA3ejr/mhLbS8ZNhAT/s9FTucbxij9xJ43eCasIyYBEhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 10:55:25PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The types for the register argument changed recently, but there are
> still incompatible prototypes that got left behind, and gcc-13 warns
> about these:
> 
> In file included from drivers/net/ethernet/mscc/ocelot.c:13:
> drivers/net/ethernet/mscc/ocelot.h:97:5: error: conflicting types for 'ocelot_port_readl' due to enum/integer mismatch; have 'u32(struct ocelot_port *, u32)' {aka 'unsigned int(struct ocelot_port *, unsigned int)'} [-Werror=enum-int-mismatch]
>    97 | u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
>       |     ^~~~~~~~~~~~~~~~~
> 
> Just remove the two prototypes, and rely on the copy in the global
> header.
> 
> Fixes: 9ecd05794b8d ("net: mscc: ocelot: strengthen type of "u32 reg" in I/O accessors")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Interesting, I didn't even realize we had these duplicated there. Thanks.
FWIW, they were duplicated in commit 5e2563650232 ("net: mscc: ocelot:
publish structure definitions to include/soc/mscc/ocelot.h") and haven't
bothered anybody since then.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
