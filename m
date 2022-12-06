Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305B8644339
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiLFMgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiLFMgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:36:01 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2054.outbound.protection.outlook.com [40.107.13.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743C55FC5
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:35:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvrWQPT5Cm8qI5q+YG5q1qfpj9xYwVQN0jLRZcvWMyqDviz9OJT97MafLAzU7Ip6yg+a7z/fWk0rsnqI8xPY8IkhBJp8aHF2QBL22zPrpAgf/T4ZjSKPikRMSA+RkWxXqQII+f0mDZnhhXvOaJyidJWLS0e4+Hle+YK7kRq+izZKD4qSsEoK43h4mzwZrgzd8bH1G/MBeUUXqtTUCymAYY2EJWXHRnU2Q/88K4+76JTVSaP9VMzd6hxLleHJ7Z3CqMdfJy6mTBvx9UBxxFNRymUNSf/Wdjk0vqgk6g9xFk8HtBt4Mjh3E85v9Pl4QoBpPZQiqbW+cfdAXQ1v9DQo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=inolUW4wKYug5H0NPKzIshdMG9OoV+IH0xSd02bN8MQ=;
 b=lxwL1HaEYZio8cA7NRjIKs/w5Gfnf17tPVmqeyqOU2SUN86NVi2CvrUFyQvVxefotgL0CsqiDzEadLIqBc2D7zcfJxoMuEGEze50zTmGDtoGsrOzzXk6ZcffF5HBXbfAGNAFUFSDkTndm8cwLgNvfTEPObPGAGX6eht+HhJm9eBNUARSWJhDtFoszTUlM0aWQputokWYXx/W4q2AKLM41pySyemJz5AdZPiPYkEEBDTQTgws0aUCXMUd/Q6+XHWQY1xJrS/xJYguOEb8yclG2QZSulSklQgLj2abN9G6ygq3oCnq2NFZxwNEuOOKfTINgzocAwuTKe3UYEs12sAUfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inolUW4wKYug5H0NPKzIshdMG9OoV+IH0xSd02bN8MQ=;
 b=PJVeDoDi1XJGjTdG1BfVu0P3megVlWWLfA/y1SJR9Q6GCsDVobUhuX/+BUDWxfnXPGAPfd11bBrbD4hUPzuCcNQ9sTD9MvDy+dqycm9tYYai6Aq5a/lNnFNn+QN0/p0pGKb1IDaCRDq9Qt2Rxn4AO0JTI95SNa7BGPJCnq+8/bg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6951.eurprd04.prod.outlook.com (2603:10a6:20b:10f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Tue, 6 Dec
 2022 12:35:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 6 Dec 2022
 12:35:55 +0000
Date:   Tue, 6 Dec 2022 14:35:52 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: enetc: set frag flag for
 non-linear xdp buffers
Message-ID: <20221206123552.6yqwxg3tlakgnkmf@skbuf>
References: <df882eddcf76b5d0ae53c19f368a617713462fd3.1670193080.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df882eddcf76b5d0ae53c19f368a617713462fd3.1670193080.git.lorenzo@kernel.org>
X-ClientProxiedBy: VI1PR10CA0106.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: cd92d3fd-7099-4197-db6a-08dad7866b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rsnv33IRiWVIQIi/caHFOwD1LcUaQdYSnXC8/h+uvzHtaJSWCIq/hEdmJYxKyLA+KoXFi6KhGgjMCS3AkSjRjzkMBWnB4mHSJPvCzvpwq9LQpFYrYbr/Hm2G0q/b29PndH3EjLXM3bRGJHDIdEkscMn3CYPqRhMGZRv/4W7qmDNTueA58KOz75y1+RcIPro1al9J9jHz9EJ+MO7zjlehNRa7D78WHoEwIOIOrB8LDDWuBUyeX41b4JIiT8wSrSdOzV+Ys0oMGqaXs7pFdok08f6yDDSw/WGWsHNtrdGN2kafDu0pU3gUTq2DTvMP2HRYD87j9JXUj2z5q53Ref2hqZph2V9FTjqDOJrHDAjzgucd6xSARzyo6HSo7dxAoIQn8EwwafRmFz7/X1SdDxsAOU+GjSP+DMKZooGM1FUYKDZmsOGd12nxLwxonmf4eAYnX+71yJ8IVLD8lgH5gr0+fqdLuNhOSh5W5YQ3g0kYPztMRd/27YNbecHL/3K/DUUHpkLqQ2ixepnHgg98vM3Eg7cmmxbAsJa6crcRxRU3GF+GcVmEGSf5UJ1xvzQCqIp1gwngxDnQ+uLu878jnYrRc+SJAbsC1w1/Q8WIryBcG43zpu2q73hnC/5jMlx2HGylvLRBIhzO3GKn8odETUfd9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199015)(83380400001)(86362001)(41300700001)(5660300002)(4326008)(44832011)(8936002)(2906002)(8676002)(33716001)(6506007)(26005)(186003)(6512007)(9686003)(1076003)(6666004)(316002)(66946007)(66476007)(6486002)(478600001)(66556008)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cs81p3sFYA6L/SdPTqNz8dUDn2v0Wk7mVhhnhjGTdxmYZ8MlIqsDjQbTrF22?=
 =?us-ascii?Q?znahn/BLOxyEZoR/JxP3vi5F9aQH8NTXlBN2pulWfff6WgGV/FFq/9UZrhze?=
 =?us-ascii?Q?2ob1gN0e6WIr79vGOcH/bpaVBrH8h+Pit+WuOMBMiGJjqYLE8R34Fb1JPgVa?=
 =?us-ascii?Q?pLJupw0o2y+GUvFpb1LzeSpMkuC7BdWJfMN93sICEV7kZH8wTV/kCq3XxuLe?=
 =?us-ascii?Q?GWFYv9gePOAqC6V4U77lB2mKxH4AwPotm98IsXvC5jSkzlzvHWep6h4wrXmh?=
 =?us-ascii?Q?wipnS0nYyIJQbX5zb88rgeuezD5ZLMSGLoFIpFBZ+ftua4tL1VsEe34EH7+2?=
 =?us-ascii?Q?5u8EBMQQ52Sx+23bRloxOcKfbSd31Muvb4TLoCXCGGArKT63JXSbNZvUNy6J?=
 =?us-ascii?Q?9hgJkVjg1ccurTunqqILWvUUtBj8Qi9hTkt/AEStQftganYJ7ZxZVlQUa20J?=
 =?us-ascii?Q?Hpe/31afjf8zcNzJHPgIw6WXnFnTry61AXWmBgcao9s/DwaNQ7unlMHBFbqI?=
 =?us-ascii?Q?vm0OXZ3Cd4PO1g2ow6FLNxb71ApJuNWrULWZK0EMXQUkb4GG7K9RuYnr+hdN?=
 =?us-ascii?Q?GrzQ/Npsj3KtBuHqd7VKPDwvfKb+QZ7vH+bQt8NEDqPZt1xOf1UUmCXGy6I8?=
 =?us-ascii?Q?BJL+tfu/NQBp0wMpiZKuEG/VNOxHo03Ya3B0gjUtAcXb3eDW3sNFbilFpxv2?=
 =?us-ascii?Q?6oe/965WFoz3fwgu6lTbYmodz6NwMPB559reZewG3dy0cnAgrb14S1/u7TSc?=
 =?us-ascii?Q?wa5P8Rw11ocSTm4YkPpyGXEGnPrRAquWXf9a1ADJLe4zuLb2jwAMVD2wHEK9?=
 =?us-ascii?Q?iiqsDEUvruVMJnwCBq9lGLPopGP9FBhD0DjivYlYGymi+vG0l0VtxTsbGSfx?=
 =?us-ascii?Q?2esVil9rYg1/AIaGr6aD8noeheJSQT8ecbHlBuY2HvLJyjZFOGGX5prjD+RX?=
 =?us-ascii?Q?ieOf7+yqqGrsSNmYIAhFUHGeechb1o5A8fHEGHvcuGtdhPHn0WF3svnHT+67?=
 =?us-ascii?Q?pJIN6urFFz9+cf9Lz5sri9wuoB98+Jp+Vv6PPBj2uRNlEgd840OK/lC6Opom?=
 =?us-ascii?Q?zc1uQFhbZMMj1bWhM3zejRtLvkdeTMF3AcxWQeZcsEvaETVVXJKCfbviu/tT?=
 =?us-ascii?Q?Rxu67hEDKOKzZrGF4NrX6LLtznZsPSVJ3JcGtqGwfRXiYZWnf31SBwbsnBSO?=
 =?us-ascii?Q?FKdEoI2gKqlomUAc9WF0JDdYuT2M2P7mAOv4GExpXLcXpKOetkOy0hjjLd2w?=
 =?us-ascii?Q?WFg0xLs2dT4Ucsw1FBl+97uUGZCz0e9k9SHL538pcXlNXDmlYI5YVOrWMMJC?=
 =?us-ascii?Q?bN0EMGpq8hFIjT1ET5FvjQWy5RDG3ePeMV3DSVcBUlRzyz3A8ItM6UVj9L2r?=
 =?us-ascii?Q?Tofiik31plXQuvMxUBtZrPnf5tNVe56RKj2y/5uLQ9wixrW0hHvzNc0Tfuil?=
 =?us-ascii?Q?3V769EPNO7dvqfXuXtN/7knYI2dLACga3dW12kK9nvBfRXEQgEaFNYxzT2Vt?=
 =?us-ascii?Q?qqqObuPYykbalnzfWIxbDAl+3k8hgtV1pQRfHGO0vRnsrPKxjbz9vVxmamng?=
 =?us-ascii?Q?9lDBtcuJWpISbkww2t8gqXA3zjA24gHIsJx2lPv4xrJ7SlWEvHzdoy9kijdV?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd92d3fd-7099-4197-db6a-08dad7866b51
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 12:35:55.5899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLULwjEntid4ImFFfa8v4WI/ElcleGSMSmkdBrxV/bit2ehP9vYPw5c6R9dxBdrb7CNDT1/AfXvWS1E3LsV7QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6951
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Sun, Dec 04, 2022 at 11:33:23PM +0100, Lorenzo Bianconi wrote:
> Set missing XDP_FLAGS_HAS_FRAGS bit in enetc_add_rx_buff_to_xdp for
> non-linear xdp buffers.
> 
> Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS")

This can't be the Fixes: tag, struct xdp_buff didn't even have a "flags"
field when that commit was introduced.

Also, what does this change aim to achieve? It has a Fixes: tag but it's
aimed for net-next. Is it to enable multi-buff XDP support? But we also
have this in place, shouldn't that be deleted too?

		case XDP_REDIRECT:
			/* xdp_return_frame does not support S/G in the sense
			 * that it leaks the fragments (__xdp_return should not
			 * call page_frag_free only for the initial buffer).
			 * Until XDP_REDIRECT gains support for S/G let's keep
			 * the code structure in place, but dead. We drop the
			 * S/G frames ourselves to avoid memory leaks which
			 * would otherwise leave the kernel OOM.
			 */
			if (unlikely(cleaned_cnt - orig_cleaned_cnt != 1)) {
				enetc_xdp_drop(rx_ring, orig_i, i);
				rx_ring->stats.xdp_redirect_sg++;
				break;
			}
