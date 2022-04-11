Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808044FBCB1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346315AbiDKNDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346330AbiDKNDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:03:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374761C93F;
        Mon, 11 Apr 2022 06:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FZ1SJt0bIUnbaLywzWZdreS+P2JGanz13+UniX5OIOE=; b=N3yw4Kr9TJ3sZ4aBqz1MVCimD8
        jh1YJu/ectAs75UyqK/7fKTHWsI8U3OIwIIE88XuUzKcnTxma6QDyn/EzXV0hUrsAYU512gHw8MI5
        nYlxocp5Tc4jr6aCUC3kBxG7iUgGtnB8HD72TCdiSxjONCcngtK5Nf2Z96fgRH0RfexI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ndtex-00FGAY-4p; Mon, 11 Apr 2022 15:00:47 +0200
Date:   Mon, 11 Apr 2022 15:00:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/14] net: ethernet: mtk_eth_soc: support creating
 mac address based offload entries
Message-ID: <YlQmf7qGAnq/3nW0@lunn.ch>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-15-nbd@nbd.name>
 <Yk8pJRxnVCfdk8xi@lunn.ch>
 <f25a6278-1baf-cc27-702a-5d93eedda438@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f25a6278-1baf-cc27-702a-5d93eedda438@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 08:21:43PM +0200, Felix Fietkau wrote:
> 
> On 07.04.22 20:10, Andrew Lunn wrote:
> > On Tue, Apr 05, 2022 at 09:57:55PM +0200, Felix Fietkau wrote:
> > > This will be used to implement a limited form of bridge offloading.
> > > Since the hardware does not support flow table entries with just source
> > > and destination MAC address, the driver has to emulate it.
> > > 
> > > The hardware automatically creates entries entries for incoming flows, even
> > > when they are bridged instead of routed, and reports when packets for these
> > > flows have reached the minimum PPS rate for offloading.
> > > 
> > > After this happens, we look up the L2 flow offload entry based on the MAC
> > > header and fill in the output routing information in the flow table.
> > > The dynamically created per-flow entries are automatically removed when
> > > either the hardware flowtable entry expires, is replaced, or if the offload
> > > rule they belong to is removed
> > 
> > > +
> > > +	if (found)
> > > +		goto out;
> > > +
> > > +	eh = eth_hdr(skb);
> > > +	ether_addr_copy(key.dest_mac, eh->h_dest);
> > > +	ether_addr_copy(key.src_mac, eh->h_source);
> > > +	tag = skb->data - 2;
> > > +	key.vlan = 0;
> > > +	switch (skb->protocol) {
> > > +#if IS_ENABLED(CONFIG_NET_DSA)
> > > +	case htons(ETH_P_XDSA):
> > > +		if (!netdev_uses_dsa(skb->dev) ||
> > > +		    skb->dev->dsa_ptr->tag_ops->proto != DSA_TAG_PROTO_MTK)
> > > +			goto out;
> > > +
> > > +		tag += 4;
> > > +		if (get_unaligned_be16(tag) != ETH_P_8021Q)
> > > +			break;
> > > +
> > > +		fallthrough;
> > > +#endif
> > > +	case htons(ETH_P_8021Q):
> > > +		key.vlan = get_unaligned_be16(tag + 2) & VLAN_VID_MASK;
> > > +		break;
> > > +	default:
> > > +		break;
> > > +	}
> > 
> > I'm trying to understand the architecture here.
> > 
> > We have an Ethernet interface and a Wireless interface. The slow path
> > is that frames ingress from one of these interfaces, Linux decides
> > what to do with them, either L2 or L3, and they then egress probably
> > out the other interface.
> > 
> > The hardware will look at the frames and try to spot flows? It will
> > then report any it finds. You can then add an offload, telling it for
> > a flow it needs to perform L2 or L3 processing, and egress out a
> > specific port? Linux then no longer sees the frame, the hardware
> > handles it, until the flow times out?
> Yes, the hw handles it until either the flow times out, or the corresponding
> offload entry is removed.
> 
> For OpenWrt I also wrote a daemon that uses tc classifier BPF to accelerate
> the software bridge and create hardware offload entries as well via hardware
> TC flower rules: https://github.com/nbd168/bridger
> It works in combination with these changes.

What about the bridge? In Linux, it is the software bridge which
controls all this at L2, and it should be offloading the flows, via
switchdev. The egress port you derive here is from the software bridge
FDB?

> > So i'm wondering what is going on here. So is this a frame which has
> > ingressed, either from the WiFi, or another switch port, gone to the
> > software bridge, bridges to a DSA slave interface, the DSA tagger has
> > added a tag and now it is in the master interface? Can you accelerate
> > such frames? What is adding the DSA tag on the fast path? And in the
> > opposite direction, frames which egress the switch which have a DSA
> > tag and are heading to the WiFi, what is removing the tag? Does the
> > accelerator also understand the tag and know what to do with it?WiFi ->
> > Ethernet is not supported by MT7622, but will be added for newer

> SoCs like MT7986. The PPE supports both parsing and inserting MT7530
> compatible DSA tags. For Ethernet->WiFi flows, the PPE will also add
> required metadata that is parsed by the MT7915 WiFi Firmware in order to
> figure out what vif/station the packets were meant for.

O.K. What about IGMP and multicast? Does the accelerate match on IGMP
and forwards it to the CPU, rather than follow the flow rules? Can you
set multiple egress destinations for multicast so that it can go both
to the switch and the host, when the host has a local interest in the
traffic?

	Andrew
