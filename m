Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FBA35A747
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhDIToa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234142AbhDITo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7284261001;
        Fri,  9 Apr 2021 19:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617997453;
        bh=1ySM7fCna3+y1Vh5Mtfl1tYpONqqGVYQCsZBxFfzPNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g67OOCl+5LcoNcqXpnJGjRiL5Ipn43km3YaPRLhUmTe7YfbRMfJwqPTyZtAKfFL/K
         ABCtT1tCTAVllcMo9qs2eyW3XjIITHIzN11swuXC2l0P3IfW1VnOnMhfU+bYJuhTFy
         YcJBerZuaYXTN0uDEozxkVGKShlYpqcqo81mossSYtiAybxp7VIoXvFOIftG14TGRi
         C0I8QfUPAwwmKNRoZQ2MGo7szeJz3TCrkUcdQQN/qSJUnNArhmWF4gdWfF7YRbDzHz
         GEAq2BNw4z+DwO2m1fO46jQhhXHD2y6fIHxgDjAUCN+fbqjfcfwTgE30TUa5eoSfEP
         uNyRyQAW2nHCQ==
Date:   Fri, 9 Apr 2021 12:44:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Message-ID: <20210409124412.3728a224@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a9a755f3-9a44-83d5-4426-1238c96c8e15@gmail.com>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
        <20210408111350.3817-3-yangbo.lu@nxp.com>
        <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR04MB6754A7B847379CC8DC3D855196739@AM0PR04MB6754.eurprd04.prod.outlook.com>
        <20210409090939.0a2c0325@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a9a755f3-9a44-83d5-4426-1238c96c8e15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 22:32:49 +0300 Claudiu Manoil wrote:
> On 09.04.2021 19:09, Jakub Kicinski wrote:
> > On Fri, 9 Apr 2021 06:37:53 +0000 Claudiu Manoil wrote:  
> >> Please try test_and_set_bit_lock()/ clear_bit_unlock() based on Jakub's
> >> suggestion, and see if it works for you / whether it can replace the mutex.  
> > 
> > I was thinking that with multiple queues just a bit won't be sufficient
> > because:
> > 
> > xmit:				work:
> > test_bit... // already set
> > 				dequeue // empty
> > enqueue
> > 				clear_bit()
> > 
> > That frame will never get sent, no?  
> 
> I don't see any issue with Yangbo's initial design actually, I was just
> suggesting him to replace the mutex with a bit lock, based on your comments.
> That means:
> xmit:		work:				clean_tx_ring: //Tx conf
> skb_queue_tail()		
> 		skb_dequeue()
> 		test_and_set_bit_lock()
> 						clear_bit_unlock()
> 
> The skb queue is one per device, as it needs to serialize ptp skbs
> for that device (due to the restriction that a ptp packet cannot be 
> enqueued for transmission if there's another ptp packet waiting
> for transmission in a h/w descriptor ring).
> 
> If multiple ptp skbs are coming in from different xmit queues at the 
> same time (same device), they are enqueued in the common priv->tx_skbs 
> queue (skb_queue_tail() is protected by locks), and the worker thread is 
> started.
> The worker dequeues the first ptp skb, and places the packet in the h/w 
> descriptor ring for transmission. Then dequeues the second skb and waits 
> at the lock (or mutex or whatever lock is preferred).
> Upon transmission of the ptp packet the lock is released by the Tx 
> confirmation napi thread (clean_tx_ring()) and the next PTP skb can be 
> placed in the corresponding descriptor ring for transmission by the 
> worker thread.

I see. I thought you were commenting on my scheme. Yes, if only the
worker is allowed to send there is no race, that should work well.

In my suggestion I was trying to allow the first frame to be sent
directly without going via the queue and requiring the worker to be
scheduled in.

> So the way I understood your comments is that you'd rather use a spin 
> lock in the worker thread instead of a mutex.

Not exactly, my main objection was that the mutex was used for wake up.
Worker locks it, completion path unlocks it.

Your suggestion of using a bit works well. Just Instead of a loop the
worker needs to send a single skb, and completion needs to schedule it
again.

> > Note that skb_queue already has a lock so you'd just need to make that
> > lock protect the flag/bit as well, overall the number of locks remains
> > the same. Take the queue's lock, check the flag, use
> > __skb_queue_tail(), release etc.
> 
> This is a good optimization idea indeed, to use the priv->tx_skb skb 
> list's spin lock, instead of adding another lock.

