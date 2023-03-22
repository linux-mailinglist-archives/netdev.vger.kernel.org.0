Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B0A6C4FB0
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCVPs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCVPs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:48:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24B826BE;
        Wed, 22 Mar 2023 08:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17522B81D3C;
        Wed, 22 Mar 2023 15:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D12C433D2;
        Wed, 22 Mar 2023 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679500103;
        bh=eWxe6cYXL8wQ6qBpp6URW1xn9GNWfGX9xbpAGqr+GDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RPrttnDQvU4O4TmLkDHXNp4JNvXA1DrFyRdILg/Y0GJG/11nUdHkLblQy0GtWJMH5
         BBbDhVkLRqnPgeJn5orEzVaVrxfChcvsv/WEZ/DXSSBTDwQtSBSElzLlmO2244t3Se
         V/qnCViCXZMCazectOn6bY76lubEmiHZVbHBxVUjeoiDX1Og5ZXeGb9NUi2ilw7Iz5
         j45kx37NYurKKiYX+MypqJ32gaVFlmpjGEVIG9YfgtzOnECCSFjf2dAylRXaK7aPZk
         WzbYfOPczJkR2UuVrbIF4/hLh30mitokpWc1yFknBh4wBpdIjwSqKvDiTnXXB1K1H0
         mflBNs5/yzj5Q==
Date:   Wed, 22 Mar 2023 16:48:17 +0100
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
Subject: Re: [PATCH net-next v2 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230322154817.c6qasnixow452e6x@wittgenstein>
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
 <20230321183342.617114-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230321183342.617114-2-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 07:33:40PM +0100, Alexander Mikhalitsyn wrote:
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
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
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

So here we need to also make sure that we can't end up in a situation
where the receiver gets an error message and discards the message but
we've snuck an fd into their fdtable. So callers of scm_recv() should be
in a path where the message can't fail anymore and we're about to return
to userspace.
