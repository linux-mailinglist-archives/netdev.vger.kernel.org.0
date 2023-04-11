Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564966DDFCA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDKPhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDKPhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D33619A8;
        Tue, 11 Apr 2023 08:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC59162086;
        Tue, 11 Apr 2023 15:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22A8C433EF;
        Tue, 11 Apr 2023 15:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681227466;
        bh=LzNQ4sR+LJ3/3uk2+mqyCitVnuo74ey0tmvHPnc/lKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IpAAS93/lB3z4/7MRIvqLvWGfLQHohb7nhjCRstD2yCqz3SllqPkyLUT+dFLBcHik
         eSMufuZVyldqf8I6rdvX7WVw5NlpjT1GJuDsYzxvufQ6COOwztlOMZOnd83NVwCaG+
         0kreWQvdSFpgQHPPE2DaMgYdQ+Zeb/r/+riDd4mJ6VKIU7DTIjqvJ2O1106DujAC60
         8H1qsU0T4OmEdxHEViqcsb6YDl2mnPTf8sWeo7iMKoV8Z78qxVAidylq836YDiR7OU
         n6Ynxd4hlwGkAjbCm55Hb8tfNHdCFnxw0T+s2IYcbGEdFO/0VfmqbM/9zWVfKGr0x+
         KwC3A3Bewe3tQ==
Date:   Tue, 11 Apr 2023 17:37:39 +0200
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
        Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230411-umarmen-mulden-c34abb9b2511@brauner>
References: <20230411104231.160837-1-aleksandr.mikhalitsyn@canonical.com>
 <20230411104231.160837-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411104231.160837-2-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:42:28PM +0200, Alexander Mikhalitsyn wrote:
> Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.
> 
> Idea comes from UAPI kernel group:
> https://uapi-group.org/kernel-features/
> 
> Big thanks to Christian Brauner and Lennart Poettering for productive
> discussions about this.
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
> Cc: Luca Boccassi <bluca@debian.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Tested-by: Luca Boccassi <bluca@debian.org>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
> v2:
> 	According to review comments from Kuniyuki Iwashima and Christian Brauner:
> 	- use pidfd_create(..) retval as a result
> 	- whitespace change
> ---
>  arch/alpha/include/uapi/asm/socket.h    |  2 ++
>  arch/mips/include/uapi/asm/socket.h     |  2 ++
>  arch/parisc/include/uapi/asm/socket.h   |  2 ++
>  arch/sparc/include/uapi/asm/socket.h    |  2 ++
>  include/linux/net.h                     |  1 +
>  include/linux/socket.h                  |  1 +
>  include/net/scm.h                       | 14 ++++++++++++--
>  include/uapi/asm-generic/socket.h       |  2 ++
>  net/core/sock.c                         | 11 +++++++++++
>  net/mptcp/sockopt.c                     |  1 +
>  net/unix/af_unix.c                      | 18 +++++++++++++-----
>  tools/include/uapi/asm-generic/socket.h |  2 ++
>  12 files changed, 51 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 739891b94136..ff310613ae64 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -137,6 +137,8 @@
>  
>  #define SO_RCVMARK		75
>  
> +#define SO_PASSPIDFD		76
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 18f3d95ecfec..762dcb80e4ec 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -148,6 +148,8 @@
>  
>  #define SO_RCVMARK		75
>  
> +#define SO_PASSPIDFD		76
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index f486d3dfb6bb..df16a3e16d64 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -129,6 +129,8 @@
>  
>  #define SO_RCVMARK		0x4049
>  
> +#define SO_PASSPIDFD		0x404A
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 2fda57a3ea86..6e2847804fea 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -130,6 +130,8 @@
>  
>  #define SO_RCVMARK               0x0054
>  
> +#define SO_PASSPIDFD             0x0055
> +
>  #if !defined(__KERNEL__)
>  
>  
> diff --git a/include/linux/net.h b/include/linux/net.h
> index b73ad8e3c212..c234dfbe7a30 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -43,6 +43,7 @@ struct net;
>  #define SOCK_PASSSEC		4
>  #define SOCK_SUPPORT_ZC		5
>  #define SOCK_CUSTOM_SOCKOPT	6
> +#define SOCK_PASSPIDFD		7
>  
>  #ifndef ARCH_HAS_SOCKET_TYPES
>  /**
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 13c3a237b9c9..6bf90f251910 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -177,6 +177,7 @@ static inline size_t msg_data_left(struct msghdr *msg)
>  #define	SCM_RIGHTS	0x01		/* rw: access rights (array of int) */
>  #define SCM_CREDENTIALS 0x02		/* rw: struct ucred		*/
>  #define SCM_SECURITY	0x03		/* rw: security label		*/
> +#define SCM_PIDFD	0x04		/* ro: pidfd (int)		*/
>  
>  struct ucred {
>  	__u32	pid;
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 585adc1346bd..0c717ae9c8db 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -124,8 +124,9 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  				struct scm_cookie *scm, int flags)
>  {
>  	if (!msg->msg_control) {
> -		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> -		    scm_has_secdata(sock))
> +		if (test_bit(SOCK_PASSCRED, &sock->flags) ||
> +		    test_bit(SOCK_PASSPIDFD, &sock->flags) ||
> +		    scm->fp || scm_has_secdata(sock))
>  			msg->msg_flags |= MSG_CTRUNC;
>  		scm_destroy(scm);
>  		return;
> @@ -141,6 +142,15 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds), &ucreds);
>  	}
>  
> +	if (test_bit(SOCK_PASSPIDFD, &sock->flags)) {
> +		int pidfd;
> +
> +		WARN_ON_ONCE(!scm->pid);
> +		pidfd = pidfd_create(scm->pid, 0);
> +
> +		put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd);

I know you already mentioned that you accidently missed to change this
to not leak an fd. But just so we keep track of it see the comment to v2
https://lore.kernel.org/netdev/20230322154817.c6qasnixow452e6x@wittgenstein/#t
