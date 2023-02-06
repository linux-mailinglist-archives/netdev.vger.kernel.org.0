Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1112168C381
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjBFQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjBFQmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:42:02 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E70C40D6;
        Mon,  6 Feb 2023 08:41:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675701674; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=BRQxvBqXJ6rboSEMO+qVLoiYEtRGfcwbK77XhOYW1hKMCKrP6JlDqFyO+YOslF695z6e6djrVeuyXie3tD7A0994FPWOoMzHy1LQD40+gvM5i0+/bxFDwPtYAiIam4V/lkS2bPT/De3zTcXSMwMm68XkVrduxXleJBsz2oreMDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675701674; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=1Bx6z8a5GlMSyvhwKyXKfy2NsZNdGcoGktJ5INy5Ssk=; 
        b=IKVXKzkSpjIBXyVx9jNJ2WxvIli+K04h8CnAc6CASymNVCYA4vias6cVafhUCvojUtUbNS0pkXAJIdH6Uj2VvH1dIO8Vuv/ydp6rLMYPAwLiGNDR1Waypfp2ODyFTrcC5s/W8L2lA/aUAFUiVH3JO4ba+Xs4Ox9rAh7rq763Yvg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675701674;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=1Bx6z8a5GlMSyvhwKyXKfy2NsZNdGcoGktJ5INy5Ssk=;
        b=hn30PspN8kX8+0hdOQHBgYsokI9slMe/WAHYauEpQeVCiiSwVKPkrEUZ+YrdLYCV
        /LJ/eezwVhhI8yV1hePBN1SmeGAWWqqP0miiXNn8dA9vVGNQSn2kvjg7aOpGDM8eYzE
        OX17UqgZ9VTOye63w/2cqtgbbGow8ial8wCqstdM=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1675701672615220.2851799604772; Mon, 6 Feb 2023 08:41:12 -0800 (PST)
Message-ID: <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
Date:   Mon, 6 Feb 2023 19:41:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
 <3649b6f9-a028-8eaf-ac89-c4d0fce412da@arinc9.com>
 <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230205235053.g5cttegcdsvh7uk3@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finally I got time. It's been a seismically active day where I'm from.

On 6.02.2023 02:50, Vladimir Oltean wrote:
> On Mon, Feb 06, 2023 at 02:02:48AM +0300, Arınç ÜNAL wrote:
>> # ethtool -S eth1 | grep -v ': 0'
>> NIC statistics:
>>       tx_bytes: 6272
>>       tx_packets: 81
>>       rx_bytes: 9089
>>       rx_packets: 136
>>       p05_TxUnicast: 52
>>       p05_TxMulticast: 3
>>       p05_TxBroadcast: 81
>>       p05_TxPktSz65To127: 136
>>       p05_TxBytes: 9633
>>       p05_RxFiltering: 11
>>       p05_RxUnicast: 11
>>       p05_RxMulticast: 26
>>       p05_RxBroadcast: 44
>>       p05_RxPktSz64: 47
>>       p05_RxPktSz65To127: 34
>>       p05_RxBytes: 6272
>> # ethtool -S eth1 | grep -v ': 0'
>> NIC statistics:
>>       tx_bytes: 6784
>>       tx_packets: 89
>>       rx_bytes: 9601
>>       rx_packets: 144
>>       p05_TxUnicast: 60
>>       p05_TxMulticast: 3
>>       p05_TxBroadcast: 81
>>       p05_TxPktSz65To127: 144
>>       p05_TxBytes: 10177
>>       p05_RxFiltering: 11
>>       p05_RxUnicast: 11
>>       p05_RxMulticast: 26
>>       p05_RxBroadcast: 52
>>       p05_RxPktSz64: 55
>>       p05_RxPktSz65To127: 34
>>       p05_RxBytes: 6784
>> # ethtool -S eth1 | grep -v ': 0'
>> NIC statistics:
>>       tx_bytes: 7424
>>       tx_packets: 99
>>       rx_bytes: 10241
>>       rx_packets: 154
>>       p05_TxUnicast: 70
>>       p05_TxMulticast: 3
>>       p05_TxBroadcast: 81
>>       p05_TxPktSz65To127: 154
>>       p05_TxBytes: 10857
>>       p05_RxFiltering: 11
>>       p05_RxUnicast: 11
>>       p05_RxMulticast: 26
>>       p05_RxBroadcast: 62
>>       p05_RxPktSz64: 65
>>       p05_RxPktSz65To127: 34
>>       p05_RxBytes: 7424
> 
> I see no signs of packet loss on the DSA master or the CPU port.
> However my analysis of the packets shows:
> 
>> # tcpdump -i eth1 -e -n -Q in -XX
>> tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
>> listening on eth1, link-type NULL (BSD loopback), snapshot length 262144 bytes
>> 03:50:38.645568 AF Unknown (2459068999), length 60:
>> 	0x0000:  9292 6a47 1ac0 e0d5 5ea4 edcc 0806 0001  ..jG....^.......
>                   ^              ^              ^
>                   |              |              |
>                   |              |              ETH_P_ARP
>                   |              MAC SA:
>                   |              e0:d5:5e:a4:ed:cc
>                   MAC DA:
>                   92:92:6a:47:1a:c0
> 
>> 	0x0010:  0800 0604 0002 e0d5 5ea4 edcc c0a8 0202  ........^.......
>> 	0x0020:  9292 6a47 1ac0 c0a8 0201 0000 0000 0000  ..jG............
>> 	0x0030:  0000 0000 0000 0000 0000 0000            ............
> 
> So you have no tag_mtk header in the EtherType position where it's
> supposed to be. This means you must be making use of the hardware DSA
> untagging feature that Felix Fietkau added.
> 
> Let's do some debugging. I'd like to know 2 things, in this order.
> First, whether DSA sees the accelerated header (stripped by hardware, as
> opposed to being present in the packet):
> 
> diff --git a/net/dsa/tag.c b/net/dsa/tag.c
> index b2fba1a003ce..e64628cf7fc1 100644
> --- a/net/dsa/tag.c
> +++ b/net/dsa/tag.c
> @@ -75,12 +75,17 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>   		if (!skb_has_extensions(skb))
>   			skb->slow_gro = 0;
>   
> +		netdev_err(dev, "%s: skb %px metadata dst contains port id %d attached\n",
> +			   __func__, skb, port);
> +
>   		skb->dev = dsa_master_find_slave(dev, 0, port);
>   		if (likely(skb->dev)) {
>   			dsa_default_offload_fwd_mark(skb);
>   			nskb = skb;
>   		}
>   	} else {
> +		netdev_err(dev, "%s: there is no metadata dst attached to skb 0x%px\n",
> +			   __func__, skb);
>   		nskb = cpu_dp->rcv(skb, dev);
>   	}
>   

# ping 192.168.2.2
PING 192.168.2.2[   39.508013] mtk_soc_eth 1b100000.ethernet eth1: 
dsa_switch_rcv: there is no metadata dst attached to skb 0xc2dfecc0
  (192.168.2.2): 56 data bytes
[   40.558253] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfed80
^C
--- 192.168.2.2 ping statistics ---
2 packets transmitted, 0 packets received, 100% packet loss
# [   41.598312] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: 
there is no metadata dst attached to skb 0xc2dfee40
[   55.432363] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfef00
[   56.442233] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfef00
[   57.466253] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfef00
[   60.538211] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfef00
[   61.562191] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfec00
[   62.586190] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: there 
is no metadata dst attached to skb 0xc2dfeb40

On a working port:

[  113.278462] mt7530 mdio-bus:1f wan: Link is Down
[  113.283214] br0: port 1(wan) entered disabled state
[  115.438955] mt7530 mdio-bus:1f lan0: Link is Up - 1Gbps/Full - flow 
control off
[  115.446332] br0: port 2(lan0) entered blocking state
[  115.451346] br0: port 2(lan0) entered forwarding state
[  118.007199] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: skb 
c2dfeb40 metadata dst contains port id 1 attached
[  118.018209] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: skb 
c2dfeb40 metadata dst contains port id 1 attached
[  119.009252] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: skb 
c2dfed80 metadata dst contains port id 1 attached
[  120.010470] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: skb 
c2dfed80 metadata dst contains port id 1 attached
[  123.038246] mtk_soc_eth 1b100000.ethernet eth1: dsa_switch_rcv: skb 
c2dfe900 metadata dst contains port id 1 attached

> 
> And second, which is what does the DSA master actually see, and put in
> the skb metadata dst field:
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index f1cb1efc94cf..e7ff569959b4 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2077,11 +2077,23 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
>   		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
>   			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
>   
> +			netdev_err(netdev, "%s: skb->vlan_proto 0x%x port %d\n", __func__,
> +				   ntohs(skb->vlan_proto), port);
> +
>   			if (port < ARRAY_SIZE(eth->dsa_meta) &&
> -			    eth->dsa_meta[port])
> +			    eth->dsa_meta[port]) {
> +				netdev_err(netdev, "%s: attaching metadata dst with port %d to skb 0x%px\n",
> +					   __func__, port, skb);
>   				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
> +			} else {
> +				netdev_err(netdev, "%s: not attaching any metadata dst to skb 0x%px\n",
> +					   __func__, skb);
> +			}
>   
>   			__vlan_hwaccel_clear_tag(skb);
> +		} else if (netdev_uses_dsa(netdev)) {
> +			netdev_err(netdev, "%s: received skb 0x%px without VLAN/DSA tag present\n",
> +				   __func__, skb);
>   		}
>   
>   		skb_record_rx_queue(skb, 0);
> 
> Be warned that there may be a considerable amount of output to the console,
> so it would be best if you used a single switch port with small amounts
> of traffic.

# ping 192.168.2.2
PING 192.168.2.2[   22.674182] mtk_soc_eth 1b100000.ethernet eth1: 
mtk_poll_rx: received skb 0xc2d67840 without VLAN/DSA tag present
  (192.168.2.2): 56 data bytes
[   23.678336] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received 
skb 0xc2d67840 without VLAN/DSA tag present
[   24.718355] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received 
skb 0xc2d67840 without VLAN/DSA tag present
^C
--- 192.168.2.2 ping statistics ---
4 packets transmitted, 0 packets received, 100% packet loss
# [   28.757693] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
received skb 0xc2d67840 without VLAN/DSA tag present
[   29.758347] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received 
skb 0xc2d67840 without VLAN/DSA tag present
[   30.782404] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received 
skb 0xc2d67840 without VLAN/DSA tag present
[   33.854281] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: received 
skb 0xc2d67840 without VLAN/DSA tag present

On a working port:

[   48.798419] mt7530 mdio-bus:1f wan: Link is Down
[   48.803166] br0: port 1(wan) entered disabled state
[   50.958903] mt7530 mdio-bus:1f lan0: Link is Up - 1Gbps/Full - flow 
control off
[   50.966282] br0: port 2(lan0) entered blocking state
[   50.971300] br0: port 2(lan0) entered forwarding state
[   54.261846] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
skb->vlan_proto 0x1 port 1
[   54.269905] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
attaching metadata dst with port 1 to skb 0xc2d67840
[   54.280412] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
skb->vlan_proto 0x1 port 1
[   54.288460] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
attaching metadata dst with port 1 to skb 0xc2d67840
[   55.263241] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
skb->vlan_proto 0x1 port 1
[   55.271292] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
attaching metadata dst with port 1 to skb 0xc2d67840
[   59.358317] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
skb->vlan_proto 0x1 port 1
[   59.366361] mtk_soc_eth 1b100000.ethernet eth1: mtk_poll_rx: 
attaching metadata dst with port 1 to skb 0xc2d67a80

Arınç
