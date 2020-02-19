Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4806164E9A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBSTMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgBSTMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 14:12:30 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB8142465D;
        Wed, 19 Feb 2020 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582139550;
        bh=kR2N1xdoUxw+RxXMXGS4FbtBBxCzrowtQwH5BdvZY8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SRcoVwQP2sUVT74AEEGDw4jPrHcnnFY6hCMnZsPXZYHeNhVYd2/Ej56nstdHYqBf0
         nAawUfTy45xgvrUb/doSVq8tCxxTERMhtrDcLrRw7xJdlbiXhjWtwmIjmsJWLMU3s+
         pXm2brUWoxVANtFqeLzp6SyryIuEllGCn8k5h+m8=
Date:   Wed, 19 Feb 2020 11:12:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, dav.lebrun@gmail.com, mcr@sandelman.ca,
        stefan@datenfreihafen.org, kai.beckmann@hs-rm.de,
        martin.gergeleit@hs-rm.de, robert.kaiser@hs-rm.de,
        netdev@vger.kernel.org
Subject: Re: [PACTH net-next 5/5] net: ipv6: add rpl sr tunnel
Message-ID: <20200219111228.024ac5ae@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200219144137.omzmzgfs33fmb6yg@ryzen>
References: <20200217223541.18862-1-alex.aring@gmail.com>
        <20200217223541.18862-6-alex.aring@gmail.com>
        <20200217.214713.1884483376515699603.davem@davemloft.net>
        <20200219144137.omzmzgfs33fmb6yg@ryzen>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 09:41:37 -0500 Alexander Aring wrote:
> On Mon, Feb 17, 2020 at 09:47:13PM -0800, David Miller wrote:
> > From: Alexander Aring <alex.aring@gmail.com>
> > Date: Mon, 17 Feb 2020 17:35:41 -0500
> >   
> > > +struct rpl_iptunnel_encap {
> > > +	struct ipv6_rpl_sr_hdr srh[0];
> > > +};  
> > 
> > We're supposed to use '[]' for zero length arrays these days.  
> 
> When I do that I get with gcc 9.2.1:
> 
> linux/net/ipv6/rpl_iptunnel.c:16:25: error: flexible array member in a struct with no named members
>    16 |  struct ipv6_rpl_sr_hdr srh[];
> 
> This struct is so defined that a simple memcmp() can decide if it's the
> same tunnel or not. We don't have any "named members" _yet_ but possible
> new UAPI can introduce them.

This seems risky, does C even allow empty structures like this?
What's sizeof(struct rpl_iptunnel_encap) going to be? :S

> Can we make an exception here? I can remove it but then I need to
> introduce the same code again when we introduce new fields in UAPI for
> this tunnel.

