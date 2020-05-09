Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10F81CBD10
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 05:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgEIDu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 23:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgEIDu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 23:50:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 112AF20722;
        Sat,  9 May 2020 03:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588996227;
        bh=XcyjVYykYKddPdKIWQPw8Qg8eEX39q7s1fcySboBfXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v+NOZ9ihS91D0GxdpfKFJeEKdSr3cMUz5sMum2mQtJ7ZDtDW/DEN19kUpISGgJ0XS
         cuTQqwZuNX6c+To2TPjtHxABkyGArm+PA3b5EHotmBBAigvinDiYxDkiBxFLBqPJAM
         wdKOdjwEJ2U4dA8pie5kE537dnD042DOnLQnGTmM=
Date:   Fri, 8 May 2020 20:50:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Kitt <steve@sk2.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: Protect INET_ADDR_COOKIE on 32-bit
 architectures
Message-ID: <20200508205025.3207a54e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508120457.29422-1-steve@sk2.org>
References: <20200508120457.29422-1-steve@sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 14:04:57 +0200 Stephen Kitt wrote:
> Commit c7228317441f ("net: Use a more standard macro for
> INET_ADDR_COOKIE") added a __deprecated marker to the cookie name on
> 32-bit architectures, with the intent that the compiler would flag
> uses of the name. However since commit 771c035372a0 ("deprecate the
> '__deprecated' attribute warnings entirely and for good"),
> __deprecated doesn't do anything and should be avoided.
> 
> This patch changes INET_ADDR_COOKIE to declare a dummy struct so that
> any subsequent use of the cookie's name will in all likelihood break
> the build. It also removes the __deprecated marker.
> 
> Signed-off-by: Stephen Kitt <steve@sk2.org>
> ---
> Changes since v1:
>   - use a dummy struct rather than a typedef
> 
>  include/net/inet_hashtables.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index ad64ba6a057f..889d9b00c905 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -301,8 +301,9 @@ static inline struct sock *inet_lookup_listener(struct net *net,
>  	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
>  	 net_eq(sock_net(__sk), (__net)))
>  #else /* 32-bit arch */
> +/* Break the build if anything tries to use the cookie's name. */

I think the macro is supposed to cause a warning when the variable
itself is accessed. And I don't think that happens with your patch
applied.

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2bbaaf0c7176..6c4a3904ed8b 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -360,6 +360,8 @@ struct sock *__inet_lookup_established(struct net *net,
        unsigned int slot = hash & hashinfo->ehash_mask;
        struct inet_ehash_bucket *head = &hashinfo->ehash[slot];
 
+       kfree(&acookie);
 begin:
        sk_nulls_for_each_rcu(sk, node, &head->chain) {
                if (sk->sk_hash != hash)

$ make ARCH=i386
make[1]: Entering directory `/netdev/net-next/build_allmodconfig_warn_32bit'
  GEN     Makefile
  CALL    ../scripts/atomic/check-atomics.sh
  CALL    ../scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      net/ipv4/inet_hashtables.o
  CHK     kernel/kheaders_data.tar.xz
  AR      net/ipv4/built-in.a
  AR      net/built-in.a
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o
  MODPOST vmlinux.o

Builds fine.

>  #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
> -	const int __name __deprecated __attribute__((unused))
> +	struct {} __name __attribute__((unused))
>  
>  #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
>  	(((__sk)->sk_portpair == (__ports))		&&		\

