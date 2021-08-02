Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF443DDD4F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbhHBQLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232524AbhHBQLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AE5F60F58;
        Mon,  2 Aug 2021 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627920663;
        bh=yfVAU2+U7wpt2YMmE79sPe/T4DFxPBTA0ytzHgKV31I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ChHMkaLCqCFmaMpkB4M3EkQVg2+PuSyzXDhNMsUXXGS9o9xFGeI37VI3l1kyMiVpH
         AMJ/NSWwXeZezwnPngPbRbfmxYs1mXbr7hXLtCWLBKFvvvZur+p2VIc9e7KKwRvwnn
         aNP5AZIgurwFlGW1qu3JWx7JslJkWZhVL7cWbf+seW3uGYF9woQlynxNrQer9vP7C/
         5bSRRmhs05hXftoyeD2+jI5lFDy7vzH1K7sm/gzwI8O1cq/qJyO2daGFvPYZ7Od1sr
         SyzmnJKAyx8X5Db5jcs2W5zsZHHyOKW3im6Xh3QX053ND3GpYW0SXuDuRWjfEGiJB0
         40EiGnozfhP8Q==
Date:   Mon, 2 Aug 2021 09:11:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2] sock: allow reading and changing sk_userlocks with
 setsockopt
Message-ID: <20210802091102.314fa0f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9ead0d04-f243-b637-355c-af11af45fb5a@virtuozzo.com>
References: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
        <20210730094631.106b8bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9ead0d04-f243-b637-355c-af11af45fb5a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Aug 2021 11:26:09 +0300 Pavel Tikhomirov wrote:
> On 30.07.2021 19:46, Jakub Kicinski wrote:
> > On Fri, 30 Jul 2021 19:07:08 +0300 Pavel Tikhomirov wrote:  
> >> SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
> >> buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
> >> tcp_sndbuf_expand()). If we've just created a new socket this adjustment
> >> is enabled on it, but if one changes the socket buffer size by
> >> setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.
> >>
> >> CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
> >> restore as it first needs to increase buffer sizes for packet queues
> >> restore and second it needs to restore back original buffer sizes. So
> >> after CRIU restore all sockets become non-auto-adjustable, which can
> >> decrease network performance of restored applications significantly.
> >>
> >> CRIU need to be able to restore sockets with enabled/disabled adjustment
> >> to the same state it was before dump, so let's add special setsockopt
> >> for it.
> >>
> >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>  
> > 
> > The patchwork bot is struggling to ingest this, please double check it
> > applies cleanly to net-next.  
> 
> I checked that it applies cleanly to net-next:
> 
> [snorch@fedora linux]$ git am 
> ~/Downloads/patches/ptikhomirov/setsockopt-sk_userlocks/\[PATCH\ v2\]\ 
> sock\:\ allow\ reading\ and\ changing\ sk_userlocks\ with\ setsockopt.eml
> 
> [snorch@fedora linux]$ git log --oneline
> c339520aadd5 (HEAD -> net-next) sock: allow reading and changing 
> sk_userlocks with setsockopt
> 
> d39e8b92c341 (net-next/master) Merge 
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
> 
> Probably it was some temporary problem and now it's OK? 
> https://patchwork.kernel.org/project/netdevbpf/patch/20210730160708.6544-1-ptikhomirov@virtuozzo.com/

Indeed, must have been resolved by the merge of net into net-next which
happened on Saturday? Regardless, would you mind reposting? There is no
way for me to retry the patchwork checks.

And one more thing..

> +	case SO_BUF_LOCK:
> +		sk->sk_userlocks = (sk->sk_userlocks & ~SOCK_BUF_LOCK_MASK) |
> +				   (val & SOCK_BUF_LOCK_MASK);

What's the thinking on silently ignoring unsupported flags on set
rather than rejecting? I feel like these days we lean towards explicit
rejects.

> +	case SO_BUF_LOCK:
> +		v.val = sk->sk_userlocks & (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK);
> +		break;

The mask could you be used here.

Just to double check - is the expectation that the value returned is
completely opaque to the user space? The defines in question are not
part of uAPI.
