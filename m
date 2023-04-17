Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF96E4CA6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDQPTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjDQPSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:18:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E56949CA;
        Mon, 17 Apr 2023 08:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B08262045;
        Mon, 17 Apr 2023 15:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BA1C4339B;
        Mon, 17 Apr 2023 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681744720;
        bh=Ib1Db0bF2DZCGdVUfdSnPIDbUYIU4TILyc2Qij2pfyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tvhDwSTDyQ4YYnodvUrd2ctscH03aDR5KkK6/ory+ITb9zH6ThY+aLHnm6eaPoi55
         etl7mSQIqyuwJjE+dRCkLNjolqeF+4foVR/Z+WceBHgBs0UX4V97aq8qMhpvg7G6Gh
         FNNJBH4xtD6s/kNe4pmEH8TbRQpO1KC6kDFq16r7nQo2h8sTMbI/otrHVnH9jtweaE
         3oWbHvGb6FVJ1e6QkGOCOt7p3oH8NjVsX3vVeDuoaqYYqwh6JXItOkXBnTAkJCCK0W
         cdg/uZkcxjwEnPuvj/I0ki4XzfBOllJlN+OGBxRCEWin51+swrmSIXOFgT4KAtrX7A
         I/BLHGG8jWDQg==
Date:   Mon, 17 Apr 2023 17:18:33 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230417-bahnanlagen-fixstern-bccf5afe6fa0@brauner>
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230413133355.350571-2-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:33:52PM +0200, Alexander Mikhalitsyn wrote:
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
> v4:
> 	- fixed silent fd_install if writting of CMSG to the userspace fails (pointed by Christian)
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
>  include/net/scm.h                       | 39 +++++++++++++++++++++++--
>  include/uapi/asm-generic/socket.h       |  2 ++
>  net/core/sock.c                         | 11 +++++++
>  net/mptcp/sockopt.c                     |  1 +
>  net/unix/af_unix.c                      | 18 ++++++++----
>  tools/include/uapi/asm-generic/socket.h |  2 ++
>  12 files changed, 76 insertions(+), 7 deletions(-)
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
> index 585adc1346bd..c67f765a165b 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -120,12 +120,44 @@ static inline bool scm_has_secdata(struct socket *sock)
>  }
>  #endif /* CONFIG_SECURITY_NETWORK */
>  
> +static __inline__ void scm_pidfd_recv(struct msghdr *msg, struct scm_cookie *scm)
> +{
> +	struct file *pidfd_file = NULL;
> +	int pidfd;
> +
> +	/*
> +	 * put_cmsg() doesn't return an error if CMSG is truncated,
> +	 * that's why we need to opencode these checks here.
> +	 */
> +	if ((msg->msg_controllen <= sizeof(struct cmsghdr)) ||
> +	    (msg->msg_controllen - sizeof(struct cmsghdr)) < sizeof(int)) {
> +		msg->msg_flags |= MSG_CTRUNC;
> +		return;

Hm, curious about this: We mark the message as truncated for SCM_PIDFD
but if the same conditions were to apply for SCM_PASSCRED we don't mark
the message as truncated. Am I reading this correct? And is so, you
please briefly explain this difference?

> +	}
> +
> +	WARN_ON_ONCE(!scm->pid);
> +	pidfd = pidfd_prepare(scm->pid, 0, &pidfd_file);
> +
> +	if (put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd)) {

If the put_cmsg() of the pidfd fails userspace needs to be able to
detect this. Otherwise they can't distinguish between the SCM_PIDFD
value being zero because the put_cmsg() failed or put_cmsg() succeeded
and the allocated fd nr was 0.

Looking at put_cmsg() it looks to me that userspace will receive a
SCM_PIDFD message only if the put_cmsg() is completely successful. IIUC,
then this change is fine.
