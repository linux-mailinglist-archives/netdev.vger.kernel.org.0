Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4501E68AB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 19:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405571AbgE1R35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 13:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405041AbgE1R34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 13:29:56 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D9742073B;
        Thu, 28 May 2020 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590686995;
        bh=CXGpNEW5zE3Al8xsCyEhdbNGUXVwRX8C/yXsqP0L2Bc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SaZYjijDoEclJCwQoa/5q8y2wGxmT0QO2rPFS7RkM0qNyZfYHwz0/t+p3JgljoJHQ
         xT6fHpRkslJLEWNtOwKEz/o7+dbos3MEurF8gmBSNq4yZWKI5bhvP8udiXrpDO63Lu
         LyITDeTBxvYlr5JHhWPmPmJOKWwY4Y/RcQgKwEhk=
Date:   Thu, 28 May 2020 10:29:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net] net/tls: Fix driver request resync
Message-ID: <20200528102953.4bfc424f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6d488bcb-48ac-f084-069e-1b29d0088c07@mellanox.com>
References: <20200520151408.8080-1-tariqt@mellanox.com>
        <20200520133428.786bd4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6d488bcb-48ac-f084-069e-1b29d0088c07@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 09:03:07 +0300 Boris Pismenny wrote:
> On 20/05/2020 23:34, Jakub Kicinski wrote:
> > On Wed, 20 May 2020 18:14:08 +0300 Tariq Toukan wrote:  
> >> From: Boris Pismenny <borisp@mellanox.com>
> >>
> >> In driver request resync, the hardware requests a resynchronization
> >> request at some TCP sequence number. If that TCP sequence number does
> >> not point to a TLS record header, then the resync attempt has failed.
> >>
> >> Failed resync should reset the resync request to avoid spurious resyncs
> >> after the TCP sequence number has wrapped around.
> >>
> >> Fix this by resetting the resync request when the TLS record header
> >> sequence number is not before the requested sequence number.
> >> As a result, drivers may be called with a sequence number that is not
> >> equal to the requested sequence number.
> >>
> >> Fixes: f953d33ba122 ("net/tls: add kernel-driven TLS RX resync")
> >> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> >> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> >> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> >> ---
> >>  net/tls/tls_device.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> >> index a562ebaaa33c..cbb13001b4a9 100644
> >> --- a/net/tls/tls_device.c
> >> +++ b/net/tls/tls_device.c
> >> @@ -714,7 +714,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
> >>  		seq += TLS_HEADER_SIZE - 1;
> >>  		is_req_pending = resync_req;
> >>  
> >> -		if (likely(!is_req_pending) || req_seq != seq ||
> >> +		if (likely(!is_req_pending) || before(seq, req_seq) ||  
> > So the kernel is going to send the sync message to the device with at
> > sequence number the device never asked about?   
> 
> Yes, although I would phrase it differently: the kernel would indicate to the driver,
> that the resync request is wrong, and that it can go back to searching for a header.
> If there are any drivers that need an extra check, then we can add it in the driver itself.

I'd rather make the API clear and use a different op to indicate this is
a reset rather than a valid sync response. sync callback already has
the enum for sync type.

> > Kernel usually can't guarantee that the notification will happen,
> > (memory allocation errors, etc.) so the device needs to do the
> > restarting itself. The notification should not be necessary.
> >  
> 
> Usually, all is best effort, but in principle, reliability should be guaranteed by higher layers to simplify the design.

Since we're talking high level design perspectives here - IMO when you
talk to FW on a device - it's a distributed system. The days when you
could say driver on the host is higher layer ended when people started
putting fat firmwares on the NICs. So no, restart has to be handled by
the system making the request. In this case the NIC.

> On the one hand, resync depends on packet arrival, which may take a while, and implementing different heuristics in each driver to timeout is complex.
> On the other hand, assuming the user reads the record data eventually, ktls will be able to deliver the resync request, so implementing this in the tls layer is simple.

We definitely not want any driver logic here - the resync restart logic
has to be implemented on the device.

> In this case, I see no reason for the tls layer to fail --- did you have a specific flow in mind?
> AFAICT, there are no memory allocation/error flows that will prevent the driver to receive a resync without an error on the socket (bad tls header).
> If tls received the header, then the driver will receive the resync call, and it will take responsibility for reliably delivering it to HW.

So you're saying the request path and the response path for resync are
both 100% lossless both on the NIC and the host? There is no scenario
in which queue overflows, PCIe gets congested, etc.?
