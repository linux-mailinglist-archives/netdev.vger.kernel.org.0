Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F0368D4A2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjBGKm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjBGKmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:42:55 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0453410E7;
        Tue,  7 Feb 2023 02:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZPYG/zvRTVen44RSGuz7Fz8RexNUnqk9Tz3jaq6V3LQ=; b=kMTMZX3j7GPqGpI8ybON0E5M4y
        FNDv0nmaEMUpCHKXGZ6BCidO2MxqelVkXd50X8yAceTl7B8fyYh1B8neNO7W1UMjv8sFMMyx6/ngC
        NNcKw06np0c6UWqHkvhC2i5G9PIpjI/zsEFXPKEEyGS2gdFgytK3cypQp9fh7hi66kEQ=;
Received: from p200300daa717ad04d0827e150ac3376f.dip0.t-ipconnect.de ([2003:da:a717:ad04:d082:7e15:ac3:376f] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pPLQM-005hBy-Kr; Tue, 07 Feb 2023 11:42:06 +0100
Message-ID: <b1d812ea-57a0-fd68-d398-69e0b17c2f34@nbd.name>
Date:   Tue, 7 Feb 2023 11:42:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel
 for switch port 0
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
References: <20230207103027.1203344-1-vladimir.oltean@nxp.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230207103027.1203344-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.02.23 11:30, Vladimir Oltean wrote:
> Arınç reports that on his MT7621AT Unielec U7621-06 board and MT7623NI
> Bananapi BPI-R2, packets received by the CPU over mt7530 switch port 0
> (of which this driver acts as the DSA master) are not processed
> correctly by software. More precisely, they arrive without a DSA tag
> (in packet or in the hwaccel area - skb_metadata_dst()), so DSA cannot
> demux them towards the switch's interface for port 0. Traffic from other
> ports receives a skb_metadata_dst() with the correct port and is demuxed
> properly.
> 
> Looking at mtk_poll_rx(), it becomes apparent that this driver uses the
> skb vlan hwaccel area:
> 
> 	union {
> 		u32		vlan_all;
> 		struct {
> 			__be16	vlan_proto;
> 			__u16	vlan_tci;
> 		};
> 	};
> 
> as a temporary storage for the VLAN hwaccel tag, or the DSA hwaccel tag.
> If this is a DSA master it's a DSA hwaccel tag, and finally clears up
> the skb VLAN hwaccel header.
> 
> I'm guessing that the problem is the (mis)use of API.
> skb_vlan_tag_present() looks like this:
> 
>   #define skb_vlan_tag_present(__skb)	(!!(__skb)->vlan_all)
> 
> So if both vlan_proto and vlan_tci are zeroes, skb_vlan_tag_present()
> returns precisely false. I don't know for sure what is the format of the
> DSA hwaccel tag, but I surely know that lowermost 3 bits of vlan_proto
> are 0 when receiving from port 0:
> 
> 	unsigned int port = vlan_proto & GENMASK(2, 0);
> 
> If the RX descriptor has no other bits set to non-zero values in
> RX_DMA_VTAG, then the call to __vlan_hwaccel_put_tag() will not, in
> fact, make the subsequent skb_vlan_tag_present() return true, because
> it's implemented like this:
> 
> static inline void __vlan_hwaccel_put_tag(struct sk_buff *skb,
> 					  __be16 vlan_proto, u16 vlan_tci)
> {
> 	skb->vlan_proto = vlan_proto;
> 	skb->vlan_tci = vlan_tci;
> }
> 
> What we need to do to fix this problem (assuming this is the problem) is
> to stop using skb->vlan_all as temporary storage for driver affairs, and
> just create some local variables that serve the same purpose, but
> hopefully better. Instead of calling skb_vlan_tag_present(), let's look
> at a boolean has_hwaccel_tag which we set to true when the RX DMA
> descriptors have something. Disambiguate based on netdev_uses_dsa()
> whether this is a VLAN or DSA hwaccel tag, and only call
> __vlan_hwaccel_put_tag() if we're certain it's a VLAN tag.
> 
> Arınç confirms that the treatment works, so this validates the
> assumption.
> 
> Link: https://lore.kernel.org/netdev/704f3a72-fc9e-714a-db54-272e17612637@arinc9.com/
> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Felix Fietkau <nbd@nbd.name>
