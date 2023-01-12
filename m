Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65086667EC0
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjALTJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbjALTJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:09:07 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98BB3C0E0
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 10:54:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDAEBLfh50cg4U/ogmiy8onTd1IPlllZpLJz8ZFMaqz3iyRiB/8I9Dyk3+pZIkxgLKctBw/X65WSNbA/IarM3rFHVeEbILu+sKOrcYCnRdJKYjj+BW4b1uJ36ynoHc37alvwmuPifgXr8VKpoNoOR34Nn3t7Rfn47viGuTcTONLp6ArDp+Q0UuplqQTJcJONesYOJH/4bNk3SBOgvlVC3MORtILyOLKXxURdnWWNmPIuEPC4KcW4zGWgeo0ROpDpGq5pzoJ284o7c0xBjQnyPSmz/BqY4at0jcD0dEJoCq/KbYjmR+QwjitcUNwQ46e6amNnhOOhJQDORctxK7nXxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VClmrLLj+uVqlJVvmfJgwUq93ZyZ+DlA2ut01ExxM58=;
 b=DYq3D6FCd6kKdk79OF3hxmkMw8SDu/ch4lpZXcFTy2/2KhIjW3YOKpMPlCC1JykEE3adKmIV9tMOO4WW2rVq31sIdg8tgNGfxOKCPd+zbPcrcRMUbG0G6ZndV7565Fi24IAqWfQwDiEQ8mKqTfM5GKI5V+/J7pHCKIcpA4rZlFOx8cSQ0VOI4rRnaNjrchqKZ+LtMpjFBwMiPbnWIzJTlHt+QZa568xHDOPVPT8WP4A2C99CnDK7PRqn7eSaeeYDutklDnEkN7+CW+P2qIHvDVMONncj8B/ANEz2Co0VNtDQd+TPcpG/AQydqFqogJv/o1mg5IVcz44HrMNw95H4gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VClmrLLj+uVqlJVvmfJgwUq93ZyZ+DlA2ut01ExxM58=;
 b=btXM0Whk011uJXV5tD3k8iu6O/riXcI2OlaZm6nJYFtWxvMklkbwmicBcDyGwZt/VcY5UJaabho21ZiN46z0ZZP3RBwh5FOSd8ecapfKhU8OXjJOG4VnyKp4Q4KJf9SfQaq+z9We2Itqg/bR9AvEA8+LJ1DXvMJsQn8BdxSPwRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8220.eurprd04.prod.outlook.com (2603:10a6:10:242::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 18:53:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 18:53:59 +0000
Date:   Thu, 12 Jan 2023 20:53:55 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>
Subject: Re: [PATCH net] net: enetc: avoid deadlock in
 enetc_tx_onestep_tstamp()
Message-ID: <20230112185355.yltldjsbxe66q54w@skbuf>
References: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
 <0031e545f7f26a36a213712480ed6d157d0fc47a.camel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0031e545f7f26a36a213712480ed6d157d0fc47a.camel@gmail.com>
X-ClientProxiedBy: AS4P189CA0006.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8220:EE_
X-MS-Office365-Filtering-Correlation-Id: dca8fed1-83b2-4fe2-fb2b-08daf4ce5d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzcgZULZu5vZqvSzfovHLXPQJYms/+XhVGUOp6cM2KPRkwf7/FQtDOfAahsc0OyTIlI36jnLvnoDgp58lAB/nydCE0o1oViDVLUNX2AZZXksvmw8giq9iSIKKsFQ4YgxTtnRvCjSnobTf42RaNhonskK+/l52SaVKMK3cXHThFlHGfntKsa+G5k4NPzS1hw8tIp/plGWk1bw70Js3aYnoKpTpA4kStAyhECE0uWWsjX1j4fia+nR2jZWf478t3M/W7M8RbmeBZbAtUZkJwtJzppVMUim9dX0Xgywp/uuqWT0WTzXiEuxczKfTJHnbt3PXZfjNU9g2aBlDGJo/jfLT7px4ygMn53rHpThvmqnVVneglnlur8PMBaZ2XdeQZKhU/g3M985oi7yClsJEAIuAfSBH7wkrS99dhbsIaC7ioxgabX0NAPXoalntg6UBIABht7316iN5yrMumExx1TnBc3gE5j5fOAwcUgMvrHNU90+s3dAgeow9+WJOZT95HdufVvADTzaTETAaoBEx4g1eYnn6fXhOzKkiVWoeBO9CGepOX1hq+p0AVk0TTJraHsRZNk2Vc8DjAZMFWIOmdsNk4hs8qiJ54+2djGBWr27zcHfrIQlPslWSt7MS8e5guYiPxbrhu7WssWXW1VPoxJzsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199015)(66946007)(8676002)(41300700001)(2906002)(44832011)(8936002)(5660300002)(1076003)(66476007)(6916009)(66556008)(6512007)(316002)(54906003)(478600001)(26005)(6666004)(6486002)(6506007)(186003)(9686003)(4326008)(83380400001)(86362001)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RsQYfkjiyek1SID5Q83xRahbKRx97y8vIOBaLkmjZU0ZMkgojllYFEVXULR8?=
 =?us-ascii?Q?ZcdvGfVvQk+jJqmwfFQtVBcy/LgyJBwenuwbbOJuAaN3FppWbs2Qk8+wm5sX?=
 =?us-ascii?Q?BPPS8WScmVKHF5QhOn1s/RuYVp7JkTlaydRvFeaKKmcH66InC1XYjruT8+1r?=
 =?us-ascii?Q?ZBZ30/QfkwsrXAaIegR1XQ2lMsykB/eCLc2GeYlokM+BTKkpJ9H2BLE4TLmZ?=
 =?us-ascii?Q?ZFHWJaKt8Rlxwgg1hquY6b31KplFOXb7lPSOy88P7c0H9c1bfEM4wrJ/ckHq?=
 =?us-ascii?Q?TW7vg6DWyNnEkPoN9lK9UAzg5kajbYL+XqYVaU2/RjPtsJH7s/Wq3hMS5D7x?=
 =?us-ascii?Q?2BvhqlXt/QCrGeOC0N2gx56yOuNynA7hc9n4abNvioxsWxpqDkxyJY+SxgqA?=
 =?us-ascii?Q?lkcl4ajIhljvn3M94EE3JiJexdcnTNpmtHm7nQNNioU1a8plhNMWxXIvTgv8?=
 =?us-ascii?Q?p40wEc4TDbmOTSKC5lLh4TjxP4ZWsqVfl7JXQBghm+FlgOFL/lT0RuXR0BJu?=
 =?us-ascii?Q?/pe3PUH4d/paOc3lAr3PyidVPoTWOskX8a6ZwWm5QjtC+Paosci0e4D+pnXC?=
 =?us-ascii?Q?P9rm7//JZEg2uJ5SjC47+fCJwoaV+pFUvAUH6SsZ8Km2CSv9I5V+95WPArBI?=
 =?us-ascii?Q?NshE9mcHGT75D8Rf+XHOjh4L0gYkCUWS+1hAaKrDP9dXJFcuS68v335iXnAo?=
 =?us-ascii?Q?hJ8Er7deyIltYcUPpQZaj6GiuXbVUJOzReUCpSk6ZtRHFnoJxp5pBplewMJs?=
 =?us-ascii?Q?IxAni/DLA1dNGewf4X2NiO2vFT91Mq7EcD39Opmuiuxqz7cdk4Uyi/N/P6AK?=
 =?us-ascii?Q?WcJNsDpShXPpvVvEUDr0p9WCXpbgY/lkKp5ujyir3H10Vi+gOzAtYZQzEF0O?=
 =?us-ascii?Q?WtU/PXYyVx0Af+/L8vvdtcYcDlwMnmWTJwHGa6Tgp86LIa8eBJwFcIjCCHp4?=
 =?us-ascii?Q?Y6ZAqTXAupW+pE3gju4IwTSg+EaeERV2BigfT3VjsH3emo6KMj1jJwzn2c5f?=
 =?us-ascii?Q?IxZ++AChgXQIspPTpTbiRGOm9k1+0QLbaB/D0vq/VrEfi7aVvPvDLdNkIlMa?=
 =?us-ascii?Q?ns0S1OP8CqCGCfcj1coD4m4xY7qSdUXvMUyuJkawML9YtjPZ1LSAHqSSBEug?=
 =?us-ascii?Q?G9DB5BVokiCQllxfzuK6ukYfwnmh2GeeTq1dxNuMZ2tFyW35iwQO2PuSf5Ou?=
 =?us-ascii?Q?jc9E+5ohMaNvaLmDSNF+DyTMWFEiPIJ+/ZRiO7/EJC/6k4b5N2TciCjmzWjs?=
 =?us-ascii?Q?oIWvB2JmHdoXwFlWbLE8w19L0dliq0dpfsaV3KHHTCQqVT7aIrl4jJHBZP84?=
 =?us-ascii?Q?LeTCmWNyJQV/WxMXLdgEL8VMwLPdIWvy0GVk+bUs1T8lfZ4YGoOwURKz7Mao?=
 =?us-ascii?Q?QMGPlStNWB/kIJnj7osKCv48dkmJabUYgFAiTpB2eHID9wvJswWyq9K3vU/9?=
 =?us-ascii?Q?dTOWgGKf4ITe92e4P81lyXKBR72iUgREYsOiDHfq3UeY2SyGjEQWNLb9DoY9?=
 =?us-ascii?Q?ypyoRiHtrXnBtd5xeG1tx3Kcxqlqnc4wkeJInxFy5ItRr9dvFVWfm9EyRtpp?=
 =?us-ascii?Q?H9Rp/lir6lreC9eP/bj6HexC3PpmITQ03Dt45lbEWIzEZ/AHG13Asygbi2dG?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca8fed1-83b2-4fe2-fb2b-08daf4ce5d36
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 18:53:59.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LVZ50Jmolvi2UIOK6usNiKuAj7hwRp2Ou+UTlAYQGRxpugLxDOYwNPAihnXHtsdF22CIcGrUQXm7TgkaU6veA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8220
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 09:48:40AM -0800, Alexander H Duyck wrote:
> Looking at the patch this fixes I had a question. You have the tx_skbs
> in the enet_ndev_priv struct and from what I can tell it looks like you
> support multiple Tx queues. Is there a risk of corrupting the queue if
> multiple Tx queues attempt to request the onestep timestamp?

void skb_queue_tail(struct sk_buff_head *list, struct sk_buff *newsk)
{
	unsigned long flags;

	spin_lock_irqsave(&list->lock, flags);
	__skb_queue_tail(list, newsk);
	spin_unlock_irqrestore(&list->lock, flags);
}

> Also I am confused. Why do you clear the TSTAMP_IN_PROGRESS flag in
> enetc_tx_onestep_timestamp before checking the state of the queue?

Because when enetc_tx_onestep_timestamp() is called, the one-step
timestamping process is no longer in progress - which is what we need to
know. The resource that needs serialized access is the MAC-wide
ENETC_PM0_SINGLE_STEP register. So from enetc_start_xmit() and until
enetc_clean_tx_ring(), there can only be one one-step Sync message in
flight at a time.

> It seems like something you should only be clearing once the queue is
> empty.

The flag tracks what it says: whether there's a one-step timestamp in
progress. If no TS is in progress and a Sync message must be
timestamped, the flag will be set but the skb will not be queued.
It will be timestamped right away.

The queue is there to ensure that Sync messages sent in a burst are
eventually all sent (and timestamped). Each TX confirmation will
schedule the work item again.

By taking netif_tx_lock[_bh](), enetc_tx_onestep_tstamp() ensures that
it has priority in sending the skbs already queued up in &priv->tx_skbs,
over those coming from ndo_start_xmit -> enetc_xmit(). Not only that,
but if enetc_tx_onestep_tstamp() doesn't clear TSTAMP_IN_PROGRESS before
calling enetc_start_xmit(), this is a PEBKAC, because the skb will end
up being queued right back into &priv->tx_skbs again, rather than ever
getting sent. Keeping the netif_tx_lock() held ensures that the
TSTAMP_IN_PROGRESS bit will remain unset enough for our own queued skb
to make forward progress in enetc_start_xmit().
