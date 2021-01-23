Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD7A30184A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbhAWUNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbhAWUNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 15:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E723322CF6;
        Sat, 23 Jan 2021 20:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611432748;
        bh=7hHQFIp8INU9E1r1CKHRyBOeopowHsDQ9DHiC5W5u20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R7EXO41dEhCE7UHljkd+kYXssnuzYJS1YVy13jSjA+8ZkdxQyOJItX5ZtuSS86G/s
         Wmhiu7N2SsOmW8u3KA+7EtcbOoOoBFbeTvXeTugAi8g1uMEUk4KvhrBlQ166Z3RJuj
         FJEdx3VC2jTquc88M9sao3FSAhZvg5Tjqxuo+JXMxexF9YG19jzYLhth5AFqFhKWHF
         DTfGc394zgMrYqTP9q9dh4LcjUpl+ns76dVazssOpjSJMXm67O3P/O4l5Bxcd6pN0e
         T6hxzB0NXVDoHnHbf4sYPsxpED/GEZqkBP/ku5fbcaKDi/ch+Jjfzfg1ZW66yRHMiw
         oxy3YEDK8KGIQ==
Date:   Sat, 23 Jan 2021 12:12:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210123121227.16384ff5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123132626.GA22662@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
        <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
        <20210121102753.GO1551@shell.armlinux.org.uk>
        <20210121150802.GB20321@hoboy.vegasvil.org>
        <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123132626.GA22662@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 05:26:26 -0800 Richard Cochran wrote:
> On Fri, Jan 22, 2021 at 06:14:44PM -0800, Jakub Kicinski wrote:
> 
> > (I would put it in net-next tho, given the above this at most a space
> > optimization.)  
> 
> It isn't just about space but also time.  The reason why I targeted
> net and not net-next was that NETWORK_PHY_TIMESTAMPING activates a
> function call to skb_clone_tx_timestamp() for every transmitted frame.
> 
> 	static inline void skb_tx_timestamp(struct sk_buff *skb)
> 	{
> 		skb_clone_tx_timestamp(skb);
> 		if (skb_shinfo(skb)->tx_flags & SKBTX_SW_TSTAMP)
> 			skb_tstamp_tx(skb, NULL);
> 	}
> 
> In the abscence of a PHY time stamping device, the check for its
> presence inside of skb_clone_tx_timestamp() will of course fail, but
> this still incurs the cost of the call on every transmitted skb.
> 
> Similarly netif_receive_skb() futilely calls skb_defer_rx_timestamp()
> on every received skb.
> 
> I would argue that most users don't want this option activated by
> accident.

I see. The only thing I'm worried about then is the churn in patch 3.
This would land in Linus's tree shortly before rc6, kinda late to be
taking chances in the name of minor optimizations :S
 
> (And yes, we could avoid the functions call by moving the check
> outside of the global functions and inline to the call sites.  I'll be
> sure to have that in the shiny new improved scheme under discussion.)
