Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E775230E64
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgG1Pvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:51:43 -0400
Received: from verein.lst.de ([213.95.11.211]:48914 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbgG1Pvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:51:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 47F4868B05; Tue, 28 Jul 2020 17:51:40 +0200 (CEST)
Date:   Tue, 28 Jul 2020 17:51:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Engelhardt <jengelh@inai.de>,
        Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Message-ID: <20200728155140.GA17714@lst.de>
References: <20200728063643.396100-1-hch@lst.de> <20200728063643.396100-5-hch@lst.de> <20200728084746.06f52878@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728084746.06f52878@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 08:47:46AM -0700, Jakub Kicinski wrote:
> On Tue, 28 Jul 2020 08:36:43 +0200 Christoph Hellwig wrote:
> > Make sure not just the pointer itself but the whole range lies in
> > the user address space.  For that pass the length and then use
> > the access_ok helper to do the check.
> > 
> > Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
> > Reported-by: David Laight <David.Laight@ACULAB.COM>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> > diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
> > index 94f18d2352d007..8b132c52045973 100644
> > --- a/net/ipv4/bpfilter/sockopt.c
> > +++ b/net/ipv4/bpfilter/sockopt.c
> > @@ -65,7 +65,7 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
> >  
> >  	if (get_user(len, optlen))
> >  		return -EFAULT;
> > -	err = init_user_sockptr(&optval, user_optval);
> > +	err = init_user_sockptr(&optval, user_optval, *optlen);
> >  	if (err)
> >  		return err;
> >  	return bpfilter_mbox_request(sk, optname, optval, len, false);
> 
> Appears to cause these two new warnings, sadly:
> 
> net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression
> net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression

Shouldn't this just be one?  That one is justified, though as *optlen
should be len.
