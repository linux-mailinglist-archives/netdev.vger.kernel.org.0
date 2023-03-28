Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04F26CC6FA
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjC1PqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbjC1Ppy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:45:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C5FC651;
        Tue, 28 Mar 2023 08:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0453F61866;
        Tue, 28 Mar 2023 15:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D2C4339B;
        Tue, 28 Mar 2023 15:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680018328;
        bh=YaVokJjTfZg9ew9bIb0zo1vyOb8HUUoQ6sQaU8pHly0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n1uCILJmCdk/8w7/Eaq777UV8wyFy7PlG/AQyRbXtROLN+yOM0XNPzmb7lnpLDEGT
         thcW/V9Cg5kYXmJEh1hMUZsUGpMi7g6p96ScLIXjCPJB9t04THfLDlxdkKFjk47aY9
         Wfh9ya9NNQbr4d36zBGi2FZjQh+4YU8csu9N8BBYm29BtqjFxZX5SMphQnSSoVu7/7
         G0i+pcIMrQFZyblkKQnzTkC9NWB52LLdltSYmG96Zxi8icf8c9bOCuGCbu3TBX8TRP
         s4BWaSvi3KAUUYnXVlwPsFJfSz1RaW9IIr8h43IvAuzS8a8tjPJ1yT4tu+a/qXvdKR
         O7w15C0TfCDMg==
Date:   Tue, 28 Mar 2023 17:45:16 +0200
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
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: core: add getsockopt SO_PEERPIDFD
Message-ID: <20230328154516.5qqt7uoewdzwb37m@wittgenstein>
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
 <20230321183342.617114-3-aleksandr.mikhalitsyn@canonical.com>
 <20230322153544.u7rfjijcpuheda6m@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230322153544.u7rfjijcpuheda6m@wittgenstein>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 04:35:51PM +0100, Christian Brauner wrote:
> On Tue, Mar 21, 2023 at 07:33:41PM +0100, Alexander Mikhalitsyn wrote:
> > Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> > This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> > 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> > ---
> > v2:
> > 	According to review comments from Kuniyuki Iwashima and Christian Brauner:
> > 	- use pidfd_create(..) retval as a result
> > 	- whitespace change
> > ---
> >  arch/alpha/include/uapi/asm/socket.h    |  1 +
> >  arch/mips/include/uapi/asm/socket.h     |  1 +
> >  arch/parisc/include/uapi/asm/socket.h   |  1 +
> >  arch/sparc/include/uapi/asm/socket.h    |  1 +
> >  include/uapi/asm-generic/socket.h       |  1 +
> >  net/core/sock.c                         | 21 +++++++++++++++++++++
> >  tools/include/uapi/asm-generic/socket.h |  1 +
> >  7 files changed, 27 insertions(+)
> > 
> > diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> > index ff310613ae64..e94f621903fe 100644
> > --- a/arch/alpha/include/uapi/asm/socket.h
> > +++ b/arch/alpha/include/uapi/asm/socket.h
> > @@ -138,6 +138,7 @@
> >  #define SO_RCVMARK		75
> >  
> >  #define SO_PASSPIDFD		76
> > +#define SO_PEERPIDFD		77
> >  
> >  #if !defined(__KERNEL__)
> >  
> > diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> > index 762dcb80e4ec..60ebaed28a4c 100644
> > --- a/arch/mips/include/uapi/asm/socket.h
> > +++ b/arch/mips/include/uapi/asm/socket.h
> > @@ -149,6 +149,7 @@
> >  #define SO_RCVMARK		75
> >  
> >  #define SO_PASSPIDFD		76
> > +#define SO_PEERPIDFD		77
> >  
> >  #if !defined(__KERNEL__)
> >  
> > diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> > index df16a3e16d64..be264c2b1a11 100644
> > --- a/arch/parisc/include/uapi/asm/socket.h
> > +++ b/arch/parisc/include/uapi/asm/socket.h
> > @@ -130,6 +130,7 @@
> >  #define SO_RCVMARK		0x4049
> >  
> >  #define SO_PASSPIDFD		0x404A
> > +#define SO_PEERPIDFD		0x404B
> >  
> >  #if !defined(__KERNEL__)
> >  
> > diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> > index 6e2847804fea..682da3714686 100644
> > --- a/arch/sparc/include/uapi/asm/socket.h
> > +++ b/arch/sparc/include/uapi/asm/socket.h
> > @@ -131,6 +131,7 @@
> >  #define SO_RCVMARK               0x0054
> >  
> >  #define SO_PASSPIDFD             0x0055
> > +#define SO_PEERPIDFD             0x0056
> >  
> >  #if !defined(__KERNEL__)
> >  
> > diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> > index b76169fdb80b..8ce8a39a1e5f 100644
> > --- a/include/uapi/asm-generic/socket.h
> > +++ b/include/uapi/asm-generic/socket.h
> > @@ -133,6 +133,7 @@
> >  #define SO_RCVMARK		75
> >  
> >  #define SO_PASSPIDFD		76
> > +#define SO_PEERPIDFD		77
> >  
> >  #if !defined(__KERNEL__)
> >  
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 3f974246ba3e..85c269ca9d8a 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1763,6 +1763,27 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
> >  		goto lenout;
> >  	}
> >  
> > +	case SO_PEERPIDFD:
> > +	{
> > +		struct pid *peer_pid;
> > +		int pidfd;
> > +
> > +		if (len > sizeof(pidfd))
> > +			len = sizeof(pidfd);
> > +
> > +		spin_lock(&sk->sk_peer_lock);
> > +		peer_pid = get_pid(sk->sk_peer_pid);
> > +		spin_unlock(&sk->sk_peer_lock);
> > +
> > +		pidfd = pidfd_create(peer_pid, 0);
> > +
> > +		put_pid(peer_pid);
> > +
> > +		if (copy_to_sockptr(optval, &pidfd, len))
> > +			return -EFAULT;
> 
> This leaks the pidfd. We could do:
> 
> 	if (copy_to_sockptr(optval, &pidfd, len)) {
> 		close_fd(pidfd);
> 		return -EFAULT;
> 	}
> 
> but it's a nasty anti-pattern to install the fd in the caller's fdtable
> and then close it again. So let's avoid it if we can. Since you can only
> set one socket option per setsockopt() sycall we should be able to
> reserve an fd and pidfd_file, do the stuff that might fail, and then
> call fd_install. So that would roughly be:
> 
> 	peer_pid = get_pid(sk->sk_peer_pid);
> 	pidfd_file = pidfd_file_create(peer_pid, 0, &pidfd);
> 	f (copy_to_sockptr(optval, &pidfd, len))
> 	       return -EFAULT;
> 	goto lenout:
> 	
> 	.
> 	.
> 	.
> 
> lenout:
> 	if (copy_to_sockptr(optlen, &len, sizeof(int)))
> 		return -EFAULT;
> 
> 	// Made it safely, install pidfd now.
> 	fd_install(pidfd, pidfd_file)
> 
> (See below for the associated api I'm going to publish independent of
> this as kernel/fork.c and fanotify both could use it.)

Sent out yesterday:
https://lore.kernel.org/lkml/20230328090026.b54a4jhccntfraey@quack3
