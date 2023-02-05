Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB0E68B2EA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 00:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBEXvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 18:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBEXvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 18:51:05 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2053.outbound.protection.outlook.com [40.107.6.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E353113CD;
        Sun,  5 Feb 2023 15:51:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocu4LSECmL8hdcVfroR5mx3MhMDFhFymTjlFCNoDQJvfz3ab1xrqEzxCWXWCHyi5m/S6Y2yHrV6NnPEfKolYmAwwTQITZZMW/Vi5MHr2fv2hY5V9C8u3zAvxwROFcXrq+Gq5sZXElm2RG7aizr8xy9oR2OUuQb6AlpYHi0UmyVAelqKVuDmIVQer/03DpQeHuruyhO1uc6NHyJa/bomlH0BoK6StFJR5CpjJFgtg9HhE/fMDkheY6+Y/os4thi3B0hA6v0ISYikDZiL6i4oFBz+VA+6yMcaPqZq4stuc9EnC+b6BQxsfcChu9hkkidKADj2iL8Z2f8xuPmzR1lp8/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IccfzCnYd/ZJPVqerDHlgG37s/vs0zbm9w4mYUzu1s4=;
 b=Ga2rUFjYae0UU+HJ8nP8K3twrdSlEQqn/eGAt4uUUq1EmIsozK4cl57TTDOBfZHdKEHTrh2jcAiJWmr9IdJsAC086cyO71jm4DOVHUXWUgHCCMR52GdRmC9BwuRGi7eqiDaPX278OAxKlaTolhGBXoioSwk7nxSY+V9CifmKRgkSUootfnIMyaU9T/tSLan0motZEES15iMTUbBVy1ne2MrHcY9RamdCy6LU9DhsElqvXb6G+rPr29lnGcioWrEafCPndOZb80HSh2Qsg3KHk7nCXjeQfWy3bZ9lWgtGhNcnRoXbIaqbBjcn+kSTi77gsi3MYx2shTRDPUT/HuoORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IccfzCnYd/ZJPVqerDHlgG37s/vs0zbm9w4mYUzu1s4=;
 b=M86x2whY1QdFQVQXEOHJNAB/lbHzuposJS5HD/VU21UXlph6JnRVZNiuJnM4UbpPHk4253RTqcr/4hvxGNTf2hyKK+KsuhZ0DC3++WF7d+v4MKu/HJ+BpUKumPRc58LIAMI53uRMYqoYdu0yZhYTxg1hR0RsdrWs5oZrR9DsPk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7425.eurprd04.prod.outlook.com (2603:10a6:20b:1d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 23:50:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 23:50:58 +0000
Date:   Mon, 6 Feb 2023 01:50:53 +0200
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
Message-ID: <20230205235053.g5cttegcdsvh7uk3@skbuf>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
X-ClientProxiedBy: BE0P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ca68b3-5752-46a9-d2aa-08db07d3d3ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmtCsYQ7deCa8adtvLR4S+701VympSSUzkEsVErbkSTyx0MsNGzL6LwJ1qVLW+s34qpg+PYo99gcyFhJgz4dbm9LAfmSIrEXLXsTmdJ5Jld80GgxzE+p2yD8oNN+Di2wviqhcnQlBTUHu5+4V7ZJ/S8k/2NRx1n3dMetnwm3P20ZPVJRO8COWqcCFpY2oLzCLflLb96ueZJGy+EVHYiKaKfVoxDh6YY1e4U9U5SwjmCGCQjn0c5KCGVIM0pY/pyZtyXt9Zh5aGsucnblffK/tl9WK+2mwGdlwVQGExEMHuNxebIADnsjYdfrn2bSgGvjhloToNCgHpi+BUhdUhhs/KFvzDaAPFSTCdD/EoS5S973WuBbjLpKlXifumuHzFEvPwWXqryM3m9A2ygMs+7cZg5Dq4o9g/DengDR2WND+DuCYyyuscSO9v/WcCg0wQYYGYMJIISL0OMDHKiHKUs3jdz4SiQScTaUINydShibNDLIxu6NW//zFNcdxWGag7avdXMW8lXfkFn/TzipwpSSO7u6vOxOEWZgR1y1bpo1vd3GwcyhpDzx5tQtFkZXmvro2bSxB59KtHN1+8k++CnDqwv/a3cjeTLdWAUKDf6emcw2nz2jSX2X2HwCakr3hm7bpeRHpXCu75DK1a4IoIJBww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(54906003)(316002)(6666004)(1076003)(6506007)(8676002)(478600001)(6486002)(7416002)(44832011)(5660300002)(2906002)(66476007)(66556008)(6916009)(4326008)(66946007)(41300700001)(8936002)(6512007)(26005)(86362001)(38100700002)(66574015)(83380400001)(33716001)(186003)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGNRaUdzWEtTejRiWEVLUUYzQytqWG0xRlNmdE5VVmJHeXZNQ0JIQXd3dVEv?=
 =?utf-8?B?bTRwVlREUDZLR2l3bGkvWWZObU9yNVFnMXZ3dFVrdHRJeVF1dlE1S1RGaHhF?=
 =?utf-8?B?V1liNTlFQlowY2x4ZTMxYnFId1Q5L1pId05rWXpqZFBuclFpUEIwaWZlMkpK?=
 =?utf-8?B?UjRsczVQZ0pTQWFsVHo4a2N4aktEcHdxTDh0VldNL2VMOGlzYzRYdmJmU3cy?=
 =?utf-8?B?MmRxaW1rMXZTYWxBYzVBbHJJeHhaMzc2aVVoczRvQ3hpVVRrc3JtVnlyOGtj?=
 =?utf-8?B?TUJvdjZUanJHUWNRL2Yyb3UzWjZYRnhpd2ZzVkNJN2VWOXF6YXk1Y0JhcWlG?=
 =?utf-8?B?S2N6NlhsckxDL3ZydThPbFkyZFZKOGlWelpTdzRXVGVIT2tQWnFQa05FWFhF?=
 =?utf-8?B?WS84T1QvTFdBWjhGMDZEUTNQMWwrRDFVLzFMRFIvNnMzUFNvcDgvZTRRYkdI?=
 =?utf-8?B?aFcreWF0ZlFDM0l3S3gxTE9vNlVQTm9xR3h5SDdwc1J1WVdlT0hNcVFkaDdC?=
 =?utf-8?B?SkwyazlHK0VGMW13eGNnQ1l6WXluNXp5RmJVcGtlQmN4Y1BJSEhuNXJtVSt3?=
 =?utf-8?B?TWE2SDBZanBEUWZLK1VIQXplSWEyWmxKTENEUFJvaWNOWlB4L0hETVh3MlVR?=
 =?utf-8?B?blhsdzVuK1NUdFd6aGp5eXRNL2VGZ21VR0NmY0dkZ01ZbEsxazQwcHNqYjkw?=
 =?utf-8?B?Zi9vUGFlSzBadlNBbjVlc1R4a1NIRG05SUFhYW1vMnZHWm1NaGtuUG83eHF5?=
 =?utf-8?B?WTZCRnd2cS84YUZwcnZJQSt2NWliMDkxRmZHVzVwOUt4eUtYVE9VOE5UWlBU?=
 =?utf-8?B?ajlTRkx5ZUlrdzBZcVkrTmZVSk9sdXVBWHFkcFFwQ2xIZnJNOEdVbk55Wi9C?=
 =?utf-8?B?NTFZc0VHeERqS1RlVFhNNDN2SUNuUzF3M3FFcFFFaktzSVpxVy8xZ1RhQVdk?=
 =?utf-8?B?OGtVamdNOGdrc3EyQXVYb3c2WWVEbnhlZmQ2WjZlbEs1M2N3T2pjOE9xc1l1?=
 =?utf-8?B?aGQyOS9ISERvK3RySjg4cDJmeWlGTm43dHhEaGFVZ1hsdEtUK3FpMTBTcEJO?=
 =?utf-8?B?Sm9yM1h0WHI2dHl0NFh6YW83L2IxODZxNlBhTU54SXRCRk5VK3E5KzJaUUdK?=
 =?utf-8?B?Y29Ocm85M1c1YmE4clEvUTFEbklFa1E0U3oyZTlGdUJ3TE5RaC95RXJrTkVj?=
 =?utf-8?B?S2NuT3ZlUGczTWpiVmdJYTRUOElHdjlxeFVxYTZVVnpXUk9aNCs0bGoweTdY?=
 =?utf-8?B?Nko3ZGIvblhOblZRemhGdlU4NVpNZVlyY1FNbDhLc3VzTi9saW1peFh5YUp0?=
 =?utf-8?B?OXZqdUs1MTJ2RnIwSXp0cW0vRlNpb0xQNE43MmZlbnV5WEd3L2dqZ3N5a2Qv?=
 =?utf-8?B?UGs3SjhEeFJTVGozUTkyeHYzMjN1UnlBdDh5YjZPaVBSV2RYTncrd3NlWW04?=
 =?utf-8?B?UGRNMXd2bHM4NCtMUXdoWjJoV1ZraEhrYnBDSFZxUTF5aXVHbUJBcjNscjB2?=
 =?utf-8?B?WjAzQzhPVEZ4R2s1cmFIWDRIay9NSG5uY1gyYWJPV0lyWExnQXRVMGRNSk5o?=
 =?utf-8?B?TnJmVjhvbGxvb3RYUlk3Vzd3d1lSYWZpbzJHMDhjbTNxVGt0WWpjaTRadDZ5?=
 =?utf-8?B?RStDaEZFdEc0ei9uQ1o0dUUySE5iZXkySFZVVkNDb3h5TXBpRE8yam1rVjho?=
 =?utf-8?B?OTZaVXlmMVNyS2RtVXZXalNoK0FzbS9TK1E2dWQvU2tLQ1dITlZ4YmJJcnFT?=
 =?utf-8?B?L2hGRTRCd2loanVLRG1YMnN2aHBwb0l0K0lCNTZydFducEZ2YVhPUVhXYXFi?=
 =?utf-8?B?WHpYb1I5OFVkNlh6M1prSFNHc0pQWkpleVJiYjB6bkNGbWUzSXY3SHFCLzBa?=
 =?utf-8?B?dkl6ZXlGSjNydnFjVzB1c2ZJY3hxQTl6THpBTHlBcXA3NGxRbzA3REs1VmZE?=
 =?utf-8?B?bEpvQ081MGxrWjhuOVk0M2ppS2FTWmh2NkpYNlFJUW15TjRRaFZMeSt1dm5C?=
 =?utf-8?B?V2tyOG0wQWczY0VTY1BxcnFUc0RnMHkzVlhBYlRTd2laeVdnUDZzbzUvUDVV?=
 =?utf-8?B?d2NsTE96aG44emYra0JOLytVcWNqRm0rSFUwTnV2Ni9qcUw1ckU3ejk4dkFh?=
 =?utf-8?B?aHk0Q1ZONVlKNjZFQlRTazFQUUhiVDIzM0ZWSStKaXJzdUdZU3RzODR5S3p6?=
 =?utf-8?B?Y1E9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ca68b3-5752-46a9-d2aa-08db07d3d3ed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 23:50:57.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: to/h+o2/XArW6YgFp1HwKs0FrNeEBz3duY3v5MEvTO4XqoA1BOehhHmi2l9wGlREIN9sy6D+ZXQvQNvN8e4M6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7425
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 02:02:48AM +0300, Arınç ÜNAL wrote:
> # ethtool -S eth1 | grep -v ': 0'
> NIC statistics:
>      tx_bytes: 6272
>      tx_packets: 81
>      rx_bytes: 9089
>      rx_packets: 136
>      p05_TxUnicast: 52
>      p05_TxMulticast: 3
>      p05_TxBroadcast: 81
>      p05_TxPktSz65To127: 136
>      p05_TxBytes: 9633
>      p05_RxFiltering: 11
>      p05_RxUnicast: 11
>      p05_RxMulticast: 26
>      p05_RxBroadcast: 44
>      p05_RxPktSz64: 47
>      p05_RxPktSz65To127: 34
>      p05_RxBytes: 6272
> # ethtool -S eth1 | grep -v ': 0'
> NIC statistics:
>      tx_bytes: 6784
>      tx_packets: 89
>      rx_bytes: 9601
>      rx_packets: 144
>      p05_TxUnicast: 60
>      p05_TxMulticast: 3
>      p05_TxBroadcast: 81
>      p05_TxPktSz65To127: 144
>      p05_TxBytes: 10177
>      p05_RxFiltering: 11
>      p05_RxUnicast: 11
>      p05_RxMulticast: 26
>      p05_RxBroadcast: 52
>      p05_RxPktSz64: 55
>      p05_RxPktSz65To127: 34
>      p05_RxBytes: 6784
> # ethtool -S eth1 | grep -v ': 0'
> NIC statistics:
>      tx_bytes: 7424
>      tx_packets: 99
>      rx_bytes: 10241
>      rx_packets: 154
>      p05_TxUnicast: 70
>      p05_TxMulticast: 3
>      p05_TxBroadcast: 81
>      p05_TxPktSz65To127: 154
>      p05_TxBytes: 10857
>      p05_RxFiltering: 11
>      p05_RxUnicast: 11
>      p05_RxMulticast: 26
>      p05_RxBroadcast: 62
>      p05_RxPktSz64: 65
>      p05_RxPktSz65To127: 34
>      p05_RxBytes: 7424

I see no signs of packet loss on the DSA master or the CPU port.
However my analysis of the packets shows:

> # tcpdump -i eth1 -e -n -Q in -XX
> tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> listening on eth1, link-type NULL (BSD loopback), snapshot length 262144 bytes
> 03:50:38.645568 AF Unknown (2459068999), length 60: 
> 	0x0000:  9292 6a47 1ac0 e0d5 5ea4 edcc 0806 0001  ..jG....^.......
                 ^              ^              ^
                 |              |              |
                 |              |              ETH_P_ARP
                 |              MAC SA:
                 |              e0:d5:5e:a4:ed:cc
                 MAC DA:
                 92:92:6a:47:1a:c0

> 	0x0010:  0800 0604 0002 e0d5 5ea4 edcc c0a8 0202  ........^.......
> 	0x0020:  9292 6a47 1ac0 c0a8 0201 0000 0000 0000  ..jG............
> 	0x0030:  0000 0000 0000 0000 0000 0000            ............

So you have no tag_mtk header in the EtherType position where it's
supposed to be. This means you must be making use of the hardware DSA
untagging feature that Felix Fietkau added.

Let's do some debugging. I'd like to know 2 things, in this order.
First, whether DSA sees the accelerated header (stripped by hardware, as
opposed to being present in the packet):

diff --git a/net/dsa/tag.c b/net/dsa/tag.c
index b2fba1a003ce..e64628cf7fc1 100644
--- a/net/dsa/tag.c
+++ b/net/dsa/tag.c
@@ -75,12 +75,17 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 		if (!skb_has_extensions(skb))
 			skb->slow_gro = 0;
 
+		netdev_err(dev, "%s: skb %px metadata dst contains port id %d attached\n",
+			   __func__, skb, port);
+
 		skb->dev = dsa_master_find_slave(dev, 0, port);
 		if (likely(skb->dev)) {
 			dsa_default_offload_fwd_mark(skb);
 			nskb = skb;
 		}
 	} else {
+		netdev_err(dev, "%s: there is no metadata dst attached to skb 0x%px\n",
+			   __func__, skb);
 		nskb = cpu_dp->rcv(skb, dev);
 	}
 

And second, which is what does the DSA master actually see, and put in
the skb metadata dst field:

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f1cb1efc94cf..e7ff569959b4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2077,11 +2077,23 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
 			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
 
+			netdev_err(netdev, "%s: skb->vlan_proto 0x%x port %d\n", __func__,
+				   ntohs(skb->vlan_proto), port);
+
 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
-			    eth->dsa_meta[port])
+			    eth->dsa_meta[port]) {
+				netdev_err(netdev, "%s: attaching metadata dst with port %d to skb 0x%px\n",
+					   __func__, port, skb);
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
+			} else {
+				netdev_err(netdev, "%s: not attaching any metadata dst to skb 0x%px\n",
+					   __func__, skb);
+			}
 
 			__vlan_hwaccel_clear_tag(skb);
+		} else if (netdev_uses_dsa(netdev)) {
+			netdev_err(netdev, "%s: received skb 0x%px without VLAN/DSA tag present\n",
+				   __func__, skb);
 		}
 
 		skb_record_rx_queue(skb, 0);

Be warned that there may be a considerable amount of output to the console,
so it would be best if you used a single switch port with small amounts
of traffic.
