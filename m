Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E32AC8F0
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgKIW5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgKIW5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 17:57:43 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67F7206ED;
        Mon,  9 Nov 2020 22:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604962662;
        bh=if5exp/aKQYCKy51vkQ7RSAFwt504BihFR3Zu9DiVfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EnBmwVUsqJajO3ihH0iy/5Wy7Qw73W5v0Nch8dwmpNYCXxJVDd/p5ZWuoE5W+j81G
         ZNauvjWjg3xdggsvRaQIM2VMNkUQt4XofSyjD5Kq0HlJ1v9vEGJ4c5wV8aN+2lkp+s
         kbDYB0lBu6/bFFXD6UbXZ+7XF8533E3AEhXKjbj4=
Date:   Mon, 9 Nov 2020 14:57:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Petr Malat <oss@malat.biz>, linux-sctp@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix sending when PMTU is less than
 SCTP_DEFAULT_MINSEGMENT
Message-ID: <20201109145740.5c63773e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201106102106.GB3556@localhost.localdomain>
References: <20201105103946.18771-1-oss@malat.biz>
        <20201106084634.GA3556@localhost.localdomain>
        <20201106094824.GA7570@bordel.klfree.net>
        <20201106102106.GB3556@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 07:21:06 -0300 Marcelo Ricardo Leitner wrote:
> On Fri, Nov 06, 2020 at 10:48:24AM +0100, Petr Malat wrote:
> > On Fri, Nov 06, 2020 at 05:46:34AM -0300, Marcelo Ricardo Leitner wrote:  
> > > On Thu, Nov 05, 2020 at 11:39:47AM +0100, Petr Malat wrote:  
> > > > Function sctp_dst_mtu() never returns lower MTU than
> > > > SCTP_TRUNC4(SCTP_DEFAULT_MINSEGMENT) even when the actual MTU is less,
> > > > in which case we rely on the IP fragmentation and must enable it.  
> > > 
> > > This should be being handled at sctp_packet_will_fit():  
> > 
> > sctp_packet_will_fit() does something a little bit different, it
> > allows fragmentation, if the packet must be longer than the pathmtu
> > set in SCTP structures, which is never less than 512 (see
> > sctp_dst_mtu()) even when the actual mtu is less than 512.
> > 
> > One can test it by setting mtu of an interface to e.g. 300,
> > and sending a longer packet (e.g. 400B):  
> > >           psize = packet->size;
> > >           if (packet->transport->asoc)
> > >                   pmtu = packet->transport->asoc->pathmtu;
> > >           else
> > >                   pmtu = packet->transport->pathmtu;  
> > here the returned pmtu will be 512  
> 
> Thing is, your patch is using the same vars to check for it:
> +       pmtu = tp->asoc ? tp->asoc->pathmtu : tp->pathmtu;
> 
> >   
> > > 
> > >           /* Decide if we need to fragment or resubmit later. */
> > >           if (psize + chunk_len > pmtu) {  
> > This branch will not be taken as the packet length is less then 512  
> 
> Right, ok. While then your patch will catch it because pmtu will be
> SCTP_DEFAULT_MINSEGMENT, as it is checking with '<='.
> 
> >   
> > >            }
> > >   
> > And the whole function will return SCTP_XMIT_OK without setting
> > ipfragok.
> > 
> > I think the idea of never going bellow 512 in sctp_dst_mtu() is to
> > reduce overhead of SCTP headers, which is fine, but when we do that,
> > we must be sure to allow the IP fragmentation, which is currently
> > missing.  
> 
> Hmm. ip frag is probably just worse than higher header/payload
> overhead.
> 
> > 
> > The other option would be to keep track of the real MTU in pathmtu
> > and perform max(512, pathmtu) in sctp_packet_will_fit() function.  
> 
> I need to check where this 512 came from. I don't recall it from top
> of my head and it's from before git history. Maybe we should just drop
> this limit, if it's artificial. IPV4_MIN_MTU is 68.
> 
> > 
> > Not sure when exactly this got broken, but using MTU less than 512
> > used to work in 4.9.  
> 
> Uhh, that's a bit old already. If you could narrow it down, that would
> be nice.

I'm dropping this from patchwork, if you conclude that the patch is
good as is please repost, thanks!
