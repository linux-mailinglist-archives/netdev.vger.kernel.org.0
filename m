Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BF068C50E
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBFRqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBFRqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:46:37 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456942364B;
        Mon,  6 Feb 2023 09:46:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lF3sZSGmGy0iaDkNy0lQuJ/n3bc45QFkc7UT4972t4AbAw+lXEyufStf6iQv7nRF3chpMIWBFSQrJ3ujH6+xMB26wXNvaDnaW6FqK4BxMRY0/iemEYFxFw3kGpgV/WmiOkSO/7oOwzDgybyzijATjTOeXPYtRinI0+beAm2yoAIWQTPn+GECJaf9KzX22/B4Pnsi4gkCf6at0gb7O+aaeh4xLb2TFQSkp2hONSiuxwYxryVIdL9IJ/Kyab2ImR0cnEZfqtNfV26rNKxHdmXjp6uCqiZM7H0OoaCFWrt26xPf82+gRPTY1y2BkkQoj0cBLA9T9Ud1Dux40lERKidmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PZXhUJzTwda+6oAfB3T7QCyL9UaGNy1lCYLLYIqBr4=;
 b=CfSGzTqfVpJIB0Hf94kt/7mEd8sEPJZkM4dpFLV2Yy1Un2hcOu9ujbtbLmHZMFtk+ozggXxyxRC4eNBrv8wqlG5NC/8/nZ0v4HMdYk4Ef75rEf7VeeOwGZF6WJyLULh/Z/bR9tevuh1p4ji0lsv0FvAy5y6ZY5daNPsTry62REh8p1simWkfJPvvUQmJUNGCoXg5TryaFtH+dUgayohfPjGybsBj/6B6foOb6O+LrfaeOo8VPhsVFD5Yb5y1EYAEN+RwqsZak6a20vVk9WgnhwJDSBRevcmLlbfAi50KlerHreKxfSb0bgl6DeSPWADhB97bOq+ar6QCTSH0WzqGGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PZXhUJzTwda+6oAfB3T7QCyL9UaGNy1lCYLLYIqBr4=;
 b=J6gEvajaH30QnPzAT6OG0Ku+ijMHXpaOz2gnq8NG1wRh8/ph7hIzjQhDbkoC6mvQNvIT/cB9R8zdizVug5sjL3uoGyT3Iqa0EIrHP1LFY7tl7YMGr5kywSpoKkdCI1JEVf5z3gjL3dOkg4wR75CjmTSmazSK2ja8muEUBI9IWJ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7896.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:46:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 17:46:32 +0000
Date:   Mon, 6 Feb 2023 19:46:27 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
Message-ID: <20230206174627.mv4ljr4gtkpr7w55@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
X-ClientProxiedBy: AM4PR0101CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d6ab11-aecc-4067-7977-08db086a1559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F7k2PY4CkyU7hM4i+w8uW/SFRFkjyZS4vOoGbw1lbDFBYHrg27o18CxfLDIdgf6NmwVguRpukrYimb19Qm8awNE2I6KTtHAuC7zYnBPXkXFgeE6APigbjBDsTGGvJEkPPdGtt1YMTlAeMzRSRITlHagOU4IiGJopZLmmp+4jpVA8aXHjewQjrpT6zkS96jAgcXYUbuI3SyVmcX71EpqTXN0MwIe30tGaOl+sN7csQ6alkaEL7dBAJDCSNU57lx97WqUPQ+VHllybtn8faFeXYDRmykMSv7xxd/qGm9n7TnVOSse5LIxB2MaCibSHEfxnGCA3u4ASkIpth5dRamT8RUWB416PDGwC7cGkdUCU+UJ4bRUJDui1zaScm+p6vEMb7CUUFT6D12X+nSWCOB+81WtO9n7NqWgAl+T0z6vGSMe7gLm2RHnYw/9aFAJ69UsqIZHg+sJi1Z+FJaXXLYU9JDSD261Zu6veAZFJVI9laWGKz+sX2XAocEj45VQ1WMyhclWcgEZffWBFCRtNNDwh1Ckfj9xbZrblXnH9h9LD9x5yafIFNLeNVBOn/TC7WNKUud4uuJLcjUQdd0gRJ1Racn4FxdZNAeYGz1Oljnws6Gpgk9mHOWkPDKV1ggAESs0ToNGdkzk0zcDbsmLPPkWMwipLxKMpTNomhLDMaeXusiA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199018)(2906002)(86362001)(33716001)(8676002)(4326008)(66556008)(83380400001)(66574015)(53546011)(478600001)(6506007)(1076003)(186003)(26005)(6512007)(9686003)(6666004)(5660300002)(966005)(8936002)(6486002)(41300700001)(7416002)(38100700002)(44832011)(54906003)(6916009)(66476007)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE8wd1l6TTkxQUNjRCsyRFFsSkdxK3Z0NndZeTJ6Lys2cEZwd3FYd2JVdUZt?=
 =?utf-8?B?cjFDQXRUTUpqVmpHOTd5QUdqbTN3bXExdTFSUUdmMEFXaC95ZUpUY0d0ZHFQ?=
 =?utf-8?B?cDJIZTRjVHNJdWdXci9tYVRmZlJGSGwrTERGRzZ1b1JTUnNmZzlhZDdXQm0x?=
 =?utf-8?B?THl5RmpKajh3MXNEYmlpV3R1WjB5ZGt0azA5WWkweW40cERrbWNvTThFckhh?=
 =?utf-8?B?ZGMrcEdNdWJlUWZ2Q29MdnBBVEFmeU9QVUlCKzRLZ2MxcHJiQ1pkdnEyZjBJ?=
 =?utf-8?B?NEZtZVh0eHp5a3Q3c0FSRkpvVEhnUEhkUWVuU2s1WmRmZzBrQ1V0SGRTMGlP?=
 =?utf-8?B?MzdnUzM4ZnZyeWt2K245TmdWVEFOSUpTbnI4WkM5Q2ZRaXJsUXN3djU2WUhE?=
 =?utf-8?B?M2xsWFcyWFlpY3BKVHZnVDIvOXN1TEpNOHlVV2EyMFR6clJRQm9GLzM1d2Vl?=
 =?utf-8?B?Q0xVbVlSeEtoZ2RJOU1hUmpmNVRWUXhCaGd2RzlhcXlndDREMk5hZ1Roci8v?=
 =?utf-8?B?ZU5aQU1oeC9HUk9UU0Z6QjV6aU1CY1ZQaUN4cVFMM1kvQVc2VmpqbEdZd2Z5?=
 =?utf-8?B?ZzFnZ0N6Um8rSjBYQ1pwS1g5dllPVW1YVExlUkY1am5EOTBadWlmOWx3dHkw?=
 =?utf-8?B?YjdROERuc25lUExLUWovdzRMVHNDS0VtNytYTHM1cjNjRXl2a01pdFF4alY3?=
 =?utf-8?B?aGhqRlVNZGk3K1FCRVBseG5MUnllcmdBQWtkcmJMeklremJ1bEphaTJRTUxy?=
 =?utf-8?B?WEFGZWpuVTRWU0krbFl2ZksyUW1ZSFBqakFxTXRsSjF0SjYrK3ljMFA2em1a?=
 =?utf-8?B?LzlJZ1ZRcGhCU0xtS291bHA3NzhNc2dzekFjWWIxYnN1blhaamdLUnMzcUVC?=
 =?utf-8?B?bE5wS3hhbWNQa3Y3QWhza0tqUjBwNEhQUnhjWFBHYUczRFpVb0pQK3V1bFFO?=
 =?utf-8?B?Wk5MTXd3Qy9DOFpkbzFzcklEa2FuNVY3NEFsY0JpSnV2N0t2aVRzckhIUmVW?=
 =?utf-8?B?Q29zQ1BkWFovdDg2SWxTdnJVTUFWYXFQdG83bHZ1cnhtSkdCeXBpMjU3eFVN?=
 =?utf-8?B?S0JaYlQzb3pNbUtkeldMcDVjTW5pVkpZZ1lIYVVEMGJwSUI0OWhTT2h5V25T?=
 =?utf-8?B?bzEwN2QybmNYakJUbTFxK1pPOUtsQS94a1ZyYnF6eE0wcHFMOTNRVW5SR2g1?=
 =?utf-8?B?YnZLaGRxMHFpNmVjQVJEYWFhbFovS0E2STJ0V1pHdS91UnBqWlZnbUhlb01p?=
 =?utf-8?B?UU9zU0lTT0ZqN0FyU3RBNjhiMVV0NXNGcVBPK0hXUjh5N3p3Z3owUkFrNzF2?=
 =?utf-8?B?bWRLajhTdGFuTGE4V2R5U2RaMXErd3JFdHE1M0VsaTlZMUNlNWlYQm4rVno5?=
 =?utf-8?B?bnFZdHVxR1h2SkNuMFRKWHY1emdyVEx4RFZvOXB4NW9kSjhFcm9ycUVJUHRK?=
 =?utf-8?B?RGJGc2NZWWJjU2tKS1JhZDhPTy9YaWhwNmNSNVE1SS81NW5xaFpQVk1vTHZ3?=
 =?utf-8?B?ek9EbEpGNHN6ZnZsU2xIL0RKZG1PSEFRQ01PNG12MXplL2VyZTI5cEQzcnFs?=
 =?utf-8?B?M2ozZjZZRzdObmVNcE9TaFgyeGx3d01mWGhBN00vVEpreDlnQzZVZEI3YjNq?=
 =?utf-8?B?bUZKOU9ieityZFhyWittbkZxbTdhRDdYeldvbDNyaCswK3NCNE5oL0I1SjVx?=
 =?utf-8?B?ZmQyNXJxdko1UjlGMXljdDRqTk5JWmdqeFcrMzNWS0V2Ri85MHExTFBDaUVo?=
 =?utf-8?B?TDF6djQ2NDExNjZNTlZHUnU2K0hWR25DSUtGMjNlOTIxS0lwdFpLVEdHN1pJ?=
 =?utf-8?B?YW8zSTZpbjZEbVpWd3MwYTBSZC9INC9yR3EySGVyRzk5Tmw1NysrTlZETmNh?=
 =?utf-8?B?M2EwRjdVSC9QOU1ucG5JN256eDFOck5SUTk1MWRiUnk4UVJhWE91OVJUSjY3?=
 =?utf-8?B?a05OWnZuYy90dmExNG4wK29oNUl6d2lZNWp0NGVVNExCVWNSNjVFNHZyeW51?=
 =?utf-8?B?VFlRK3ZyUDZZNGFma21zd1RocEhxWVVKWGNvdnJSN0h3V0hwNW8yclNoL2NP?=
 =?utf-8?B?MkY4QUd4dmdZTlhmQXBhbWlFbjhjVnlSZVJDRmg2TVd1dmFuQXNMdmdPdDkw?=
 =?utf-8?B?QjBucS9tT0RXMDJvSGgwb1FvRTJ1eHN3bjArbGVPeno5bUFuWFZUQ0J1dUVH?=
 =?utf-8?B?M0E9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d6ab11-aecc-4067-7977-08db086a1559
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:46:32.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGqDaZ85Mc2zj8ZYjBCPUTCJRz5gkl0W+tDQWuAhC4ShlByWIh4+p70dtvneqpY5mepyog+5ug3OiDts2zHcCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7896
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arınç,

On Mon, Feb 06, 2023 at 07:41:06PM +0300, Arınç ÜNAL wrote:
> Finally I got time. It's been a seismically active day where I'm from.

My deepest condolences to those who experienced tragedies after today's
earthquakes. A lot of people in neighboring countries are horrified
thinking when this will happen to them. Hopefully you aren't living in
Gaziantep or nearby cities.

> # ping 192.168.2.2
> PING 192.168.2.2
> [   39.508013] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there is no metadata dst attached to skb 0xc2dfecc0
> 
> # ping 192.168.2.2
> PING 192.168.2.2
> [   22.674182] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received skb 0xc2d67840 without VLAN/DSA tag present

Thank you so much for testing. Would you mind cleaning everything up and
testing with this patch instead (formatted on top of net-next)?
Even if you need to adapt to your tree, hopefully you get the idea from
the commit message.

From 218025fd0c33a06865e4202c5170bfc17e26cc75 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 6 Feb 2023 19:03:53 +0200
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch
 port 0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Arınç reports that on his MT7621AT Unielec U7621-06 board and MT7623NI
Bananapi BPI-R2, packets received by the CPU over mt7530 switch port 0
(of which this driver acts as the DSA master) are not processed
correctly by software. More precisely, they arrive without a DSA tag
(in packet or in the hwaccel area - skb_metadata_dst()), so DSA cannot
demux them towards the switch's interface for port 0. Traffic from other
ports receives a skb_metadata_dst() with the correct port and is demuxed
properly.

Looking at mtk_poll_rx(), it becomes apparent that this driver uses the
skb vlan hwaccel area:

	union {
		u32		vlan_all;
		struct {
			__be16	vlan_proto;
			__u16	vlan_tci;
		};
	};

as a temporary storage for the VLAN hwaccel tag, or the DSA hwaccel tag.
If this is a DSA master it's a DSA hwaccel tag, and finally clears up
the skb VLAN hwaccel header.

I'm guessing that the problem is the (mis)use of API.
skb_vlan_tag_present() looks like this:

 #define skb_vlan_tag_present(__skb)	(!!(__skb)->vlan_all)

So if both vlan_proto and vlan_tci are zeroes, skb_vlan_tag_present()
returns precisely false. I don't know for sure what is the format of the
DSA hwaccel tag, but I surely know that lowermost 3 bits of vlan_proto
are 0 when receiving from port 0:

	unsigned int port = vlan_proto & GENMASK(2, 0);

If the RX descriptor has no other bits set to non-zero values in
RX_DMA_VTAG, then the call to __vlan_hwaccel_put_tag() will not, in
fact, make the subsequent skb_vlan_tag_present() return true, because
it's implemented like this:

static inline void __vlan_hwaccel_put_tag(struct sk_buff *skb,
					  __be16 vlan_proto, u16 vlan_tci)
{
	skb->vlan_proto = vlan_proto;
	skb->vlan_tci = vlan_tci;
}

What we need to do to fix this problem (assuming this is the problem) is
to stop using skb->vlan_all as temporary storage for driver affairs, and
just create some local variables that serve the same purpose, but
hopefully better. Instead of calling skb_vlan_tag_present(), let's look
at a boolean has_hwaccel_tag which we set to true when the RX DMA
descriptors have something. Disambiguate based on netdev_uses_dsa()
whether this is a VLAN or DSA hwaccel tag, and only call
__vlan_hwaccel_put_tag() if we're certain it's a VLAN tag.

Link: https://lore.kernel.org/netdev/704f3a72-fc9e-714a-db54-272e17612637@arinc9.com/
Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 24 ++++++++++++---------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f1cb1efc94cf..64b575fbe317 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1921,7 +1921,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 	while (done < budget) {
 		unsigned int pktlen, *rxdcsum;
+		bool has_hwaccel_tag = false;
 		struct net_device *netdev;
+		u16 vlan_proto, vlan_tci;
 		dma_addr_t dma_addr;
 		u32 hash, reason;
 		int mac = 0;
@@ -2061,27 +2063,29 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-				if (trxd.rxd3 & RX_DMA_VTAG_V2)
-					__vlan_hwaccel_put_tag(skb,
-						htons(RX_DMA_VPID(trxd.rxd4)),
-						RX_DMA_VID(trxd.rxd4));
+				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
+					vlan_proto = RX_DMA_VPID(trxd.rxd4);
+					vlan_tci = RX_DMA_VID(trxd.rxd4);
+					has_hwaccel_tag = true;
+				}
 			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
-						       RX_DMA_VID(trxd.rxd3));
+				vlan_proto = RX_DMA_VPID(trxd.rxd3);
+				vlan_tci = RX_DMA_VID(trxd.rxd3);
+				has_hwaccel_tag = true;
 			}
 		}
 
 		/* When using VLAN untagging in combination with DSA, the
 		 * hardware treats the MTK special tag as a VLAN and untags it.
 		 */
-		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
-			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
+		if (has_hwaccel_tag && netdev_uses_dsa(netdev)) {
+			unsigned int port = vlan_proto & GENMASK(2, 0);
 
 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
 			    eth->dsa_meta[port])
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
-
-			__vlan_hwaccel_clear_tag(skb);
+		} else if (has_hwaccel_tag) {
+			__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci);
 		}
 
 		skb_record_rx_queue(skb, 0);
-- 
2.34.1

