Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C1B6DE00D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjDKPxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjDKPxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:53:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7BB5FDE;
        Tue, 11 Apr 2023 08:53:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C2C61F63;
        Tue, 11 Apr 2023 15:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA167C433EF;
        Tue, 11 Apr 2023 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681228397;
        bh=kEGv9Qpwl20xnx3B2UscGqU7o9pj7FAf2kZu43eWHHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zr6rNQU3Ih2CGRLfL2hImIWXcbX1eR5t/ji6L3M1ccKZhGWtcfosKlXJCQ6iT4h8Z
         o4/rxH4ylQdUzorXkwqtiuy2ocyFXmAxEyTRSqahnuTc2jH2O8QcXojJAjCnFNFnS9
         qyp3BaeWzPF6OjcYbj7dgKEJ+bOX9jTgfNMIiUwAcdTKPCuG/SXRG4Ei0zjFND6ski
         8Wtkkdr14nsjZ0IXr2bu7Z+fHHkgSFm4cPimV9oM7mMxRnUcg5jX/iqmPaTfjKPRga
         Y3ZvY948GTgVIZwjm2yPfdfEYZ0QSNwgXaJd7kOGhPsQtMVwqnEL3TrTjnxBVyiUcn
         jZ9KvVivi/qjg==
Date:   Tue, 11 Apr 2023 17:53:10 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net-next v3 2/4] net: socket: add sockopts blacklist for
 BPF cgroup hook
Message-ID: <20230411-nudelsalat-spreu-3038458f25c4@brauner>
References: <20230411104231.160837-1-aleksandr.mikhalitsyn@canonical.com>
 <20230411104231.160837-3-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411104231.160837-3-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:42:29PM +0200, Alexander Mikhalitsyn wrote:
> During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
> that bpf cgroup hook can cause FD leaks when used with sockopts which
> install FDs into the process fdtable.
> 
> After some offlist discussion it was proposed to add a blacklist of
> socket options those can cause troubles when BPF cgroup hook is enabled.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Suggested-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---

Just some background for kicks

A crucial point for SO_PEERPIDFD is the allocation of a pidfd and to
place it into the optval buffer for userspace to retrieve.

The way we orginally envisioned this working is by splitting this into
an fd and file allocation phase, then get past the point of failure in
sockopt processing and then call fd_install(fd, pidfd_file).

While looking at this I realized that there's a generic problem in this
code:

	if (level == SOL_SOCKET)
		err = sock_getsockopt(sock, level, optname, optval, optlen);
	else if (unlikely(!sock->ops->getsockopt))
	        err = -EOPNOTSUPP;
	else
	        err = sock->ops->getsockopt(sock, level, optname, optval, optlen);
	
	if (!in_compat_syscall())
	        err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname, optval, optlen, max_optlen, err);

That BPF_CGROUP_RUN_PROG_GETSOCKOPT hook can fail after getsockopt
itself succeeded. So anything that places an fd into optval risks
leaking an fd into the caller's fdtable if the bpf hook fails.

If we do a pidfd_create() and place the pidfd into the optval buffer the
the bpf hook could reasonably interact with the fd but if it fails the
fd would be leaked. It could clean this up calling close_fd() but it
would be ugly since the fd has already been visible in the caller's
fdtable. Someone might've snatched it already even.

If we delay installing the fd and file past the bpf hook then the fd is
meaningless for the bpf hook but we wouldn't risk leaking the fd.

It should also be noted that the hook does a copy_from_user() on the
optval right after the prior getsockopt did a copy_to_user() into that
optval. This is not just racy it's also a bit wasteful. Userspace could
try to retrieve the optval and then copy another value over it so that
the bpf hook operates on another value than getsockopt originally placed
into optval. If the bpf hook wants to care about fd resources in the
future it should probably be passed the allocated struct file.

This should be addressed separately though. The solution here works for
me,

Acked-by: Christian Brauner <brauner@kernel.org>

>  net/socket.c | 38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 73e493da4589..9c1ef11de23f 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -108,6 +108,8 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include <trace/events/sock.h>
>  
> +#include <linux/sctp.h>
> +
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  unsigned int sysctl_net_busy_read __read_mostly;
>  unsigned int sysctl_net_busy_poll __read_mostly;
> @@ -2227,6 +2229,36 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
>  	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
>  }
>  
> +#ifdef CONFIG_CGROUP_BPF
> +static bool sockopt_installs_fd(int level, int optname)
> +{
> +	/*
> +	 * These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
> +	 * hook returns an error after success of the original handler
> +	 * sctp_getsockopt(...), userspace will receive an error from getsockopt
> +	 * syscall and will be not aware that fd was successfully installed into fdtable.
> +	 *
> +	 * Let's prevent bpf cgroup hook from running on them.
> +	 */
> +	if (level == SOL_SCTP) {
> +		switch (optname) {
> +		case SCTP_SOCKOPT_PEELOFF:
> +		case SCTP_SOCKOPT_PEELOFF_FLAGS:
> +			return true;
> +		default:
> +			return false;
> +		}
> +	}
> +
> +	return false;
> +}
> +#else /* CONFIG_CGROUP_BPF */
> +static inline bool sockopt_installs_fd(int level, int optname)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_CGROUP_BPF */
> +
>  /*
>   *	Set a socket option. Because we don't know the option lengths we have
>   *	to pass the user mode parameter for the protocols to sort out.
> @@ -2250,7 +2282,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
>  	if (err)
>  		goto out_put;
>  
> -	if (!in_compat_syscall())
> +	if (!in_compat_syscall() && !sockopt_installs_fd(level, optname))
>  		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
>  						     user_optval, &optlen,
>  						     &kernel_optval);
> @@ -2304,7 +2336,7 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
>  	if (err)
>  		goto out_put;
>  
> -	if (!in_compat_syscall())
> +	if (!in_compat_syscall() && !sockopt_installs_fd(level, optname))
>  		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
>  
>  	if (level == SOL_SOCKET)
> @@ -2315,7 +2347,7 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
>  		err = sock->ops->getsockopt(sock, level, optname, optval,
>  					    optlen);
>  
> -	if (!in_compat_syscall())
> +	if (!in_compat_syscall() && !sockopt_installs_fd(level, optname))
>  		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
>  						     optval, optlen, max_optlen,
>  						     err);
> -- 
> 2.34.1
> 
