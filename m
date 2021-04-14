Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3116435F90E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhDNQgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351853AbhDNQgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:36:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA2F6113B;
        Wed, 14 Apr 2021 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618418142;
        bh=O7aJLYOwfury36Lsg2eL0ZZXdtaYRMwQZFoI4Z5g5BU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p5x9cb/ZghAjwWa244hd1Taf0WaCPGpSzhOJbWZfYYHSiLiqA5Xyxjn64KugheZvE
         naznlxzfTAz42KRX90rRtR6ylH12uRferNSG7ekrekYDjWqYWyBEx5qihpYKjNVJbj
         rnm4AWQFmbJqNegrqQqmpv4SSXd2SKM5Ue9mwNuUzUf9kck6LfPik7hjFF6Gb4KipI
         PTPzm4r4pp2F82a+2SmcAB9CZl1RSC0n4kk6hb2yfvYgv9L20oLZz6Vf34r4aoUKBh
         lfdyU4Kw88bmZ+0j0XyA7HnUJNEAOMo0avTK0mvA+CZvbrGJ78ag06+lReaYqkkeJI
         HoTuMfOYQHN2w==
Date:   Wed, 14 Apr 2021 09:35:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Message-ID: <20210414093541.39706863@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM7PR04MB6885805B7D5D11DD8DC1CA28F84E9@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210413034817.8924-1-yangbo.lu@nxp.com>
        <20210413101055.647cc156@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM7PR04MB6885805B7D5D11DD8DC1CA28F84E9@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 06:18:57 +0000 Y.b. Lu wrote:
> > On Tue, 13 Apr 2021 11:48:17 +0800 Yangbo Lu wrote:  
> > > +	/* Queue one-step Sync packet if already locked */
> > > +	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
> > > +		if  
> > (test_and_set_bit_lock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS,  
> > > +					  &priv->flags)) {
> > > +			skb_queue_tail(&priv->tx_skbs, skb);
> > > +			return NETDEV_TX_OK;
> > > +		}
> > > +	}  
> > 
> > Isn't this missing queue_work() as well?
> > 
> > Also as I mentioned I don't understand why you created a separate workqueue
> > instead of using the system workqueue via schedule_work().  
> 
> queue_work(system_wq, ) was put in clean_tx. I finally followed the
> logic you suggested :)

Ah, I didn't look close enough. I was expecting to see schedule_work(),
please consider sending a follow up, queue_work(system_wq, $work) is a
rare construct.
