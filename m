Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55F735A2B5
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhDIQJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDIQJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511FE600D4;
        Fri,  9 Apr 2021 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617984580;
        bh=VBHHNanbMgxuEpb5NnpM4qsCk2eS5ZrAvySBTVEVpbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JAoPUzaXSBtcNEPmYv86fLWkib1WIqDjm8AyEuBVjDW8gYKqWTvxS4Ym0pQhwxiPm
         jwYbWtFGnNSEJ6llcbLrfvIoeYZBJ6SafQMKywAQ2S/jMF7dGUHlu75AWri+Kyxr0Q
         47twCONa5g2yHEBf+rTHINBaGsVHkPLBEbihELPnbJLAqNVxX1CTKGej48LU6kSx9Y
         MmweZNcqX6k3bemQENGy+/L9Osx7VOWBFeY+0364Qe9KMZOHg+uVxnXKrxiLTMM4YV
         emCOywm5aAf1oKwsisWwkHOwNIiSSQjhBqpvs1Tg83jffxl/YvKB06/eB+6kor0oXo
         tjOPJ5sONqx8g==
Date:   Fri, 9 Apr 2021 09:09:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Message-ID: <20210409090939.0a2c0325@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM0PR04MB6754A7B847379CC8DC3D855196739@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
        <20210408111350.3817-3-yangbo.lu@nxp.com>
        <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR04MB6754A7B847379CC8DC3D855196739@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 06:37:53 +0000 Claudiu Manoil wrote:
> >On Thu, 8 Apr 2021 09:02:50 -0700 Jakub Kicinski wrote:  
> >> 		if (priv->flags & ONESTEP_BUSY) {
> >> 			skb_queue_tail(&priv->tx_skbs, skb);
> >> 			return ...;
> >> 		}
> >> 		priv->flags |= ONESTEP_BUSY;  
> >
> >Ah, if you have multiple queues this needs to be under a separate
> >spinlock, 'cause netif_tx_lock() won't be enough.  
> 
> Please try test_and_set_bit_lock()/ clear_bit_unlock() based on Jakub's
> suggestion, and see if it works for you / whether it can replace the mutex.

I was thinking that with multiple queues just a bit won't be sufficient
because:

xmit:				work:
test_bit... // already set
				dequeue // empty
enqueue
				clear_bit()

That frame will never get sent, no?

Note that skb_queue already has a lock so you'd just need to make that
lock protect the flag/bit as well, overall the number of locks remains
the same. Take the queue's lock, check the flag, use
__skb_queue_tail(), release etc.
