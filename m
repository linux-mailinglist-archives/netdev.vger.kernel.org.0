Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CFC1DF575
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbgEWHTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 03:19:33 -0400
Received: from verein.lst.de ([213.95.11.211]:34111 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387627AbgEWHTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 03:19:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6CB6568C4E; Sat, 23 May 2020 09:19:29 +0200 (CEST)
Date:   Sat, 23 May 2020 09:19:29 +0200
From:   'Christoph Hellwig' <hch@lst.de>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        'Christoph Hellwig' <hch@lst.de>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-ID: <20200523071929.GA10466@lst.de>
References: <20200521174724.2635475-1-hch@lst.de> <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com> <20200522143623.GA386664@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522143623.GA386664@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 11:36:23AM -0300, Marcelo Ricardo Leitner wrote:
> It's subjective, yes, but we hardly have patches over 5k lines.
> In the case here, as changing the functions also requires changing
> their call later on the file, it helps to be able to check that is was
> properly updated. Ditto for chained functions.
> 
> For example, I can spot things like this easier (from
> [PATCH 26/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_key)
> 
> @@ -3646,7 +3641,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
>         }
> 
>  out:
> -       kzfree(authkey);
>         return ret;
>  }
> ...
> @@ -4771,7 +4765,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
>         }
> 
>         release_sock(sk);
> -       kfree(kopt);
> +       if (optname == SCTP_AUTH_KEY)
> +               kzfree(kopt);
> +       else
> +               kfree(kopt);
> 
>  out_nounlock:
>         return retval;
> 
> these are 1k lines apart.
> 
> Yet, your implementation around this is better:
> 
> @@ -3733,7 +3624,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
>         }
> 
>  out:
> -       kzfree(authkey);
> +       memset(authkey, 0, optlen);
>         return ret;
>  }
> 
> so that sctp_setsockopt() doesn't have to handle it specially.

Actually that implementation is wrong, if you want to move to a plain
kfree it would have to be a memzero_explicit.

> What if you two work on a joint patchset for this? The proposals are
> quite close. The differences around the setsockopt handling are
> minimal already. It is basically variable naming, indentation and one
> or another small change like:

I don't really want to waste too much time on this, as what I really
need is to get the kernel_setsockopt removal series in ASAP.  I'm happy
to respin this once or twice with clear maintainer guidance (like the
memzero_explicit), but I have no idea what you even meant with your
other example or naming.  Tell me what exact changes you want, and
I can do a quick spin, but I don't really want a huge open ended
discussion on how to paint the bikeshed..

Alternatively I'll also happily only do a partial conversion for what
I need for the kernel_setsockopt removal and let you and Dave decided
what you guys prefer for the rest.
