Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1861EB187
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgFAWMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgFAWMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 18:12:08 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D8A2065C;
        Mon,  1 Jun 2020 22:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591049528;
        bh=9k29tScu4HJYxGvKLAMtyG6QvmMUtgz5dIn7KCbbHLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z9zrKaCwIxIG5th41cpddClQaRrXE9IJKHQv9HKmay+5y2RN1M9tW/OTlRItEE9Qq
         ZwVY5ey2/j6hwdvfX/qumoiT+i9gsGA/uH2jEQWdt15FpNV23tFwvukFaG78a/eAtx
         +U0etY0KUpdrRGxKOKhoTmKtmz129c/jqPYSMpI0=
Date:   Mon, 1 Jun 2020 15:12:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Message-ID: <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-11-saeedm@mellanox.com>
        <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
        <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 May 2020 15:06:28 +0300 Boris Pismenny wrote:
> On 30/05/2020 0:50, Jakub Kicinski wrote:
> > On Fri, 29 May 2020 20:44:29 +0000 Saeed Mahameed wrote:  
> >>> I thought you said that resync requests are guaranteed to never fail?  
> >>
> >> I didn't say that :),  maybe tariq did say this before my review,  
> > 
> > Boris ;)
> >   
> 
> I didn't say we are perfect, just that we can make a trade-off here,
> and currently this is the simplest version that our team came up with
> for this series. As a first step, I think it is reasonable. But, I
> expect that we will improve it in the future.
> 
> >> but basically with the current mlx5 arch, it is impossible to
> >> guarantee this unless we open 1 service queue per ktls offloads
> >> and that is going to be an overkill!  
> 
> I disagree, there are many ways to guarantee reliability here. For
> example, we can sleep/spin until there is space in the queue or rely
> on work stealing to let a later operation execute this one.
> 
> > IIUC every ooo packet causes a resync request in your
> > implementation - is that true?
> >   
> 
> No, only header loss. We never required a resync per OOO packet. I'm
> not sure why would you think that.

I mean until device is back in sync every frame kicks off
resync_update_sn() and tries to queue the work, right?

> > It'd be great to have more information about the operation of the
> > device in the commit message..
> >   
> 
> I'll try to clarify the resync flow here.
> As always, the packet that requires resync is marked as such in the
> CQE. However, unlike previous devices, the TCP sequence (tcpsn) where
> the HW found a header is not provided in the CQE. Instead, tcpsn is
> queried from HW asynchronously by the driver. We employ the force
> resync approach to guarantee that we can log all resync locations
> between the received packet and the HW query response. We check the
> asynchronous HW query response against all resync values between the
> packet that triggered the resync and now. If one of them matches,
> then resync can be completed immediately. Otherwise, the driver keeps
> waiting for the correct resync.

Thanks, makes sense.

> >> This is a rare corner case anyway, where more than 1k tcp
> >> connections sharing the same RX ring will request resync at the
> >> same exact moment.   
> > 
> > IDK about that. Certain applications are architected for max
> > capacity, not efficiency under steady load. So it matters a lot how
> > the system behaves under stress. What if this is the chain of
> > events:
> > 
> > overload -> drops -> TLS steams go out of sync -> all try to resync
> >  
> 
> I agree that this is not that rare, and it may be improved both in
> future patches and hardware. Do you think it is critical to improve
> it now, and not in a follow-up series?

It's not a blocker for me, although if this makes it into 5.8 there
will not be a chance to improve before net-next closes, so depends if
you want to risk it and support the code as is...

> > We don't want to add extra load on every record if HW offload is
> > enabled. That's why the next record hint backs off, checks socket 
> > state etc.
> > 
> > BTW I also don't understand why mlx5e_ktls_rx_resync() has a
> > tls_offload_rx_force_resync_request(sk) at the end. If the update 
> > from the NIC comes with a later seq than current, request the sync 
> > for _that_ seq. I don't understand the need to force a call back on
> > every record here. 
> >   
> 
> The extra load here is minimal, i.e. a single call from TLS to the
> driver, which usually just logs the information.

Oh yes, this one is not about extra load, I just don't know what that
code is trying to achieve.

> > Also if the sync failed because queue was full, I don't see how
> > forcing another sync attempt for the next record is going to match?
> >   
> 
> It doesn't, and if sync failed then we should stop trying to force
> resync.

