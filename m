Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6668A3122B8
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBGIaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhBGI1j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 03:27:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C4564E30;
        Sun,  7 Feb 2021 08:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612686418;
        bh=iZLaC3K6FGWfQE8Z7GFLrLVt5OWKG6Rvey5Ve5cjNH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zs2NrYB/TuowYUapVOvW+Wf1wcukDT1WFaKInV+BguiJO3b1pATom0R+idEd9IR+n
         H1Z03Y/Cqn5muO4+SCYOnDMkHtUMXI1xnNxcaKnwaUeAWMnbOVcuXKZZ+eX/xWXdto
         ZzqC+DX6WKFny/t58M1kPHPC4O+t+bKyTYuXne6D1ohjqPVE16pAdIJ5Wh2f1jwob2
         WH8CQPJ3hrxWwJtwmSkOO5dJkh/srg50le7DNO3Q2luOyQZp2Ro2mifGbzFRgfNbKP
         so9nglPQLIkCxxBXf2/Nwu5jvtDMySGfdEGXE+/EwwFjvc6yvm1xfRH37HKIpMNnLE
         LrxzYaA/11XxQ==
Date:   Sun, 7 Feb 2021 10:26:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210207082654.GC4656@unreal>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 03:28:28PM -0800, Jakub Kicinski wrote:
> On Sat,  6 Feb 2021 12:36:48 -0800 Arjun Roy wrote:
> > From: Arjun Roy <arjunroy@google.com>
> >
> > Explicitly define reserved field and require it to be 0-valued.
>
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index e1a17c6b473c..c8469c579ed8 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
> >  		}
> >  		if (copy_from_user(&zc, optval, len))
> >  			return -EFAULT;
> > +		if (zc.reserved)
> > +			return -EINVAL;
> >  		lock_sock(sk);
> >  		err = tcp_zerocopy_receive(sk, &zc, &tss);
> >  		release_sock(sk);
>
> I was expecting we'd also throw in a check_zeroed_user().
> Either we can check if the buffer is zeroed all the way,
> or we can't and we shouldn't validate reserved either
>
> 	check_zeroed_user(optval + offsetof(reserved),
> 			  len - offsetof(reserved))
> ?

There is a check that len is not larger than zs and users can't give
large buffer.

I would say that is pretty safe to write "if (zc.reserved)".

Thanks
