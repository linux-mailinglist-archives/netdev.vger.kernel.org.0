Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E886A6BE4F8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjCQJJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjCQJJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41BCC88A4;
        Fri, 17 Mar 2023 02:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35911B824F2;
        Fri, 17 Mar 2023 09:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF6FC433D2;
        Fri, 17 Mar 2023 09:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679044122;
        bh=WnAsQkCuk6vwlo0YFVkG/FlxPdhE6fKSFwri8e00zNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1BNDZFRcfFhr5T8h484xu0dWsZYLVvEg22vCqfSvoD6yEOL5hAycMYzL6pjW0O3i
         KO5vQkynRzv0PS5BB2JrHYMUlsMxQHuQePnpSqkjI7vMC7bjmSOzvjeoWDVVPRNKgU
         I/Uuo/Ewj8wm+aI3kwrpg6EfMEuCgqwcJ+LBuCfcjcdYHQPkVIwg26jlnYiAORQP7s
         dSfTKhIcd5RLsnSUNGQZgflWahr1cDkfe3+9Ojh2bbrokxqCnQw9jS2peKYjvEN+Tx
         MPHAAwVeI5oqavjFenUp99zsLFUNJogvj7nkCt8OOIKtFnWjb8Hpcv2mYjUG+RSTuv
         z8mMqk2UGliCQ==
Date:   Fri, 17 Mar 2023 10:08:35 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: core: add getsockopt SO_PEERPIDFD
Message-ID: <20230317090835.hz4lbm3pmvvmt2fs@wittgenstein>
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
 <20230316131526.283569-3-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316131526.283569-3-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 02:15:25PM +0100, Alexander Mikhalitsyn wrote:
> Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
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
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  arch/alpha/include/uapi/asm/socket.h    |  1 +
>  arch/mips/include/uapi/asm/socket.h     |  1 +
>  arch/parisc/include/uapi/asm/socket.h   |  1 +
>  arch/sparc/include/uapi/asm/socket.h    |  1 +
>  include/uapi/asm-generic/socket.h       |  1 +
>  net/core/sock.c                         | 24 ++++++++++++++++++++++++
>  tools/include/uapi/asm-generic/socket.h |  1 +
>  7 files changed, 30 insertions(+)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index ff310613ae64..e94f621903fe 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -138,6 +138,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 762dcb80e4ec..60ebaed28a4c 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -149,6 +149,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index df16a3e16d64..be264c2b1a11 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -130,6 +130,7 @@
>  #define SO_RCVMARK		0x4049
>  
>  #define SO_PASSPIDFD		0x404A
> +#define SO_PEERPIDFD		0x404B
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 6e2847804fea..682da3714686 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -131,6 +131,7 @@
>  #define SO_RCVMARK               0x0054
>  
>  #define SO_PASSPIDFD             0x0055
> +#define SO_PEERPIDFD             0x0056
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index b76169fdb80b..8ce8a39a1e5f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -133,6 +133,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 3f974246ba3e..3aa1ccd4bcf3 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1763,6 +1763,30 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		goto lenout;
>  	}
>  
> +	case SO_PEERPIDFD:
> +	{
> +		struct pid *peer_pid;
> +		int pidfd;
> +		if (len > sizeof(pidfd))
> +			len = sizeof(pidfd);
> +
> +		spin_lock(&sk->sk_peer_lock);
> +		peer_pid = get_pid(sk->sk_peer_pid);
> +		spin_unlock(&sk->sk_peer_lock);
> +
> +		if (!peer_pid ||
> +		    !pid_has_task(peer_pid, PIDTYPE_TGID))
> +			pidfd = -ESRCH;

Any specific reason you want -ESRCH here?
pidfd_create() returns -EINVAL for exactly this check it performs mainly
because the non-existence of PIDTYPE_TGID could either indicate that
this struct pid isn't used as a thread-group leader or - indeed - that
the process has already been reaped. IOW, if there's no specific reason
I would not deviate from pidfd_create()'s return value.
