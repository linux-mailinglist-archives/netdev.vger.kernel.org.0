Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A603313DD8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbhBHSmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhBHSmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 13:42:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D2E64E75;
        Mon,  8 Feb 2021 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612809705;
        bh=sU2YOnNo6hradE0lobTPuHyy1rhGg0Vk1omQMUW5WW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JPhTov60nR0Ezivpp8/uUgS1VwS+7DEaM6Bt3ZovBOEQibaznCkavXM2vCz0EoqiE
         e0bHIsNxIytnPn2ridOuSHKD3McO6Wn5UQGtN1VY83z+bjQTTwzrPxfWWTzaZDeseN
         ISRpPAauQnW5nOuGXVyzQZeAhr/m/ZTTYB3KvIj313NLhA4oAWGip6X/+5LsUn009T
         fFwAbUzSHrRAeJ6l4hCVrw+67qHG3sq/XWsd3a/R+H/mnABCMWIpkSVVF5vfaP6ju5
         bFanpxIuQkMJL8dyZ4xLAIRBKotjwt2ZQUcXNTh02GOjsGk54TVfNqo1m74SVLcGIx
         g1XmPiTOyrMeg==
Date:   Mon, 8 Feb 2021 10:41:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210207082654.GC4656@unreal>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
        <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210207082654.GC4656@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Feb 2021 10:26:54 +0200 Leon Romanovsky wrote:
> On Sat, Feb 06, 2021 at 03:28:28PM -0800, Jakub Kicinski wrote:
> > On Sat,  6 Feb 2021 12:36:48 -0800 Arjun Roy wrote:  
> > > From: Arjun Roy <arjunroy@google.com>
> > >
> > > Explicitly define reserved field and require it to be 0-valued.  
> >  
> > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > index e1a17c6b473c..c8469c579ed8 100644
> > > --- a/net/ipv4/tcp.c
> > > +++ b/net/ipv4/tcp.c
> > > @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
> > >  		}
> > >  		if (copy_from_user(&zc, optval, len))
> > >  			return -EFAULT;
> > > +		if (zc.reserved)
> > > +			return -EINVAL;
> > >  		lock_sock(sk);
> > >  		err = tcp_zerocopy_receive(sk, &zc, &tss);
> > >  		release_sock(sk);  
> >
> > I was expecting we'd also throw in a check_zeroed_user().
> > Either we can check if the buffer is zeroed all the way,
> > or we can't and we shouldn't validate reserved either
> >
> > 	check_zeroed_user(optval + offsetof(reserved),
> > 			  len - offsetof(reserved))
> > ?  
> 
> There is a check that len is not larger than zs and users can't give
> large buffer.
> 
> I would say that is pretty safe to write "if (zc.reserved)".

Which check? There's a check which truncates (writes back to user space
len = min(len, sizeof(zc)). Application can still pass garbage beyond
sizeof(zc) and syscall may start failing in the future if sizeof(zc)
changes.
