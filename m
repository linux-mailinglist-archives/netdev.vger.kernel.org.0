Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C621749BF41
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiAYXBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:01:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58116 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiAYXBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:01:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A266CE1B77;
        Tue, 25 Jan 2022 23:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FF3C340E0;
        Tue, 25 Jan 2022 23:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643151693;
        bh=KqrPjnST4T/693ZtQvTVZgR8S99aEPz7KM7WLhgCZYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HXBS2spGqbJUazPgaxyit/sTd5D67dnsxLFYoPq4Z+U1fQLYtC1CdDu/U3skN2RkO
         1pSWFa+hxlS+WhtBq6RUs29a69qowzVPEO/xQW75ZCJ5ON013FgHtM7ZSyFPKd9amT
         6QCuvU85sTe1uccaqkMGfMp5DZP1qdB2fcO35RvWWrVNxdx1QE4JXz+OX0qwicfXoA
         DJxFrL4FWDHcihWmdSFzTuNZTvDN/AMEXaFg9EOQl5Plf3GuBZmZQw+Bh3BBnrejlB
         GMLxgUvg7D6ztj/rMOxMugFeZGRbZGXF9fNi2RUPDF1F+GkzLNfzWwvIbiHLFCmu4E
         WAKeniml+dXEg==
Date:   Tue, 25 Jan 2022 15:01:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v2 net-next] net-core: add InMacErrors counter
Message-ID: <20220125150132.3f4291fa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125190717.2459068-1-jeffreyji@google.com>
References: <20220125190717.2459068-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 19:07:17 +0000 Jeffrey Ji wrote:
> From: jeffreyji <jeffreyji@google.com>
> 
> Increment InMacErrors counter when packet dropped due to incorrect dest
> MAC addr.
> 
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
> 
> example output from nstat:
> \~# nstat -a | grep InMac
> Ip6InMacErrors                  0                  0.0
> IpExtInMacErrors                1                  0.0
> 
> Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> counter was incremented.

> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index 80256717868e..2903869274ca 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>  	struct inet6_dev *idev;
>  
>  	if (skb->pkt_type == PACKET_OTHERHOST) {
> +		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);

Clang points out idev is not initialized at this point, yet.
