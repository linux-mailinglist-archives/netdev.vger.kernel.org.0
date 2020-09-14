Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8012699BD
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgINXeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgINXee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:34:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E82C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:34:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AE54128B8618;
        Mon, 14 Sep 2020 16:17:45 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:34:31 -0700 (PDT)
Message-Id: <20200914.163431.1847224607563732054.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        willemdebruijn.kernel@gmail.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] __netif_receive_skb_core: don't untag vlan
 from skb on DSA master
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911232607.2879466-1-olteanv@gmail.com>
References: <20200911232607.2879466-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:17:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 12 Sep 2020 02:26:07 +0300

> A DSA master interface has upper network devices, each representing an
> Ethernet switch port attached to it. Demultiplexing the source ports and
> setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
> packet_type handler. Catch-all because DSA vendors have various header
> implementations, which can be placed anywhere in the frame: before the
> DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
> handler acts like an rx_handler more than anything.
> 
> It is unlikely for the DSA master interface to have any other upper than
> the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
> is very likely that the DSA master will have no 8021q upper. So
> __netif_receive_skb_core() will try to untag the VLAN, despite the fact
> that the DSA switch interface might have an 8021q upper. So the skb will
> never reach that.
> 
> So far, this hasn't been a problem because most of the possible
> placements of the DSA switch header mentioned in the first paragraph
> will displace the VLAN header when the DSA master receives the frame, so
> __netif_receive_skb_core() will not actually execute any VLAN-specific
> code for it. This only becomes a problem when the DSA switch header does
> not displace the VLAN header (for example with a tail tag).
> 
> What the patch does is it bypasses the untagging of the skb when there
> is a DSA switch attached to this net device. So, DSA is the only
> packet_type handler which requires seeing the VLAN header. Once skb->dev
> will be changed, __netif_receive_skb_core() will be invoked again and
> untagging, or delivery to an 8021q upper, will happen in the RX of the
> DSA switch interface itself.
> 
> *see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
> network devices". This is actually the reason why I prefer keeping DSA
> as a packet_type handler of ETH_P_XDSA rather than converting to an
> rx_handler. Currently the rx_handler code doesn't support chaining, and
> this is a problem because a DSA master might be bridged.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks.
