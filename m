Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F7CAF1C
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfJCTYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:24:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfJCTYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 15:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1BrlSjv6vwSv4W1qqTm9dg1F7gAdd8/6RdqBpyNHUhc=; b=v3TsQQIN53cZYebf6yhxBhOpfj
        BN5dffGyGn7Z8CXaOjqRBkGIk6QhavBUPiyvMQZ7iSq0n2ycDPkpV5EpZTZ0oZbSHHeXnOMHrLF4j
        VG6bt6Ruj6v5DuoJfz4YlU8WQTJXs5x5I7MkeQYmy/i06HPJGoKw/3YeVIZjIgEhFRvU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iG6iT-00065Z-RN; Thu, 03 Oct 2019 21:24:45 +0200
Date:   Thu, 3 Oct 2019 21:24:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Allow port mirroring to the CPU port
Message-ID: <20191003192445.GD21875@lunn.ch>
References: <20191002233750.13566-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002233750.13566-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:37:50AM +0300, Vladimir Oltean wrote:
> On a regular netdev, putting it in promiscuous mode means receiving all
> traffic passing through it, whether or not it was destined to its MAC
> address. Then monitoring applications such as tcpdump can see all
> traffic transiting it.
> 
> On Ethernet switches, clearly all ports are in promiscuous mode by
> definition, since they accept frames destined to any MAC address.
> However tcpdump does not capture all frames transiting switch ports,
> only the ones destined to, or originating from the CPU port.
> 
> To be able to monitor frames with tcpdump on the CPU port, extend the tc
> matchall classifier and mirred action to support the DSA master port as
> a possible mirror target.
> 
> Tested with:
> tc qdisc add dev swp2 clsact
> tc filter add dev swp2 ingress matchall skip_sw \
> 	action mirred egress mirror dev eth2
> tcpdump -i swp2

Humm.

O.K, i don't like this for a few reasons.

egress mirror dev eth2

Frames are supported to egress eth2. But in fact they will ingress on
eth2. That is not intuitive.

I'm also no sure how safe this it is to ingress mirror packets on the
master interface. Will they have DSA tags? I think that will vary from
device to device. Are we going to see some packets twice? Once for the
mirror, and a second time because they are destined to the CPU? Do we
end up processing the packets twice?

For your use case of wanting to see packets in tcpdump, i think we are
back to the discussion of what promisc mode means. I would prefer that
when a DSA slave interface is put into promisc mode for tcpdump, the
switch then forwards a copy of frames to the CPU, without
duplication. That is a much more intuitive model.

	  Andrew
