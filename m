Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD09640D54
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiLBSeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiLBSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:34:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A111ED8275
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:34:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54564B82242
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC232C433D6;
        Fri,  2 Dec 2022 18:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006050;
        bh=Y1i3LeDos0iOhkxvGH4/7J9tWu7jXhFCJiKKcqJJfc4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=XjrtW0JAIgrRkR53yuWrN1oRQ7iwEv/c9mTtH5W9y6xK1JljecO9efda9SGnCoPef
         MWsq8EXwBzlrdLSBbQvpkbZlIFAumgwe/FEuaaT6EvK61g9FrIUn9r8f7VeQSfUAvz
         Tm51ZQ+g8LjfMBb5EleWAhMzk8rYuIvlUG5hYu/AbbZFdoFzvAAEvggU/iMzTM1zgh
         lfj5S18NOB34vf9/hh8XXeREFy8WCuNyRT5jr61jOUFBJ/Nu/Ny7Hh57vvuMen5jNZ
         bMCRbLWADBu+TLCx7gUCX5lBg3uq2yc8JF+fcErSUQyv4S8aKUfaDLyx3RB/Itsezm
         XBPKjcHX1MAmg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8EB455C095D; Fri,  2 Dec 2022 10:34:09 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:34:09 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Message-ID: <20221202183409.GR4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221202052847.2623997-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202052847.2623997-1-edumazet@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 05:28:47AM +0000, Eric Dumazet wrote:
> kfree_rcu(1-arg) should be avoided as much as possible,
> since this is only possible from sleepable contexts,
> and incurr extra rcu barriers.
> 
> I wish the 1-arg variant of kfree_rcu() would
> get a distinct name, like kfree_rcu_slow()
> to avoid it being abused.

Fair point, the bug of forgetting the second argument goes unflagged,
at least from contexts where blocking is OK.

Let the bikeshedding commence!  ;-)

							Thanx, Paul

> Fixes: 459837b522f7 ("net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> ---
>  net/ipv4/tcp_ipv4.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7fae586405cfb10011a0674289280bf400dfa8d8..8320d0ecb13ae1e3e259f3c13a4c2797fbd984a5 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1245,7 +1245,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>  
>  			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
>  			rcu_assign_pointer(tp->md5sig_info, NULL);
> -			kfree_rcu(md5sig);
> +			kfree_rcu(md5sig, rcu);
>  			return -EUSERS;
>  		}
>  	}
> @@ -1271,7 +1271,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
>  			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
>  			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
>  			rcu_assign_pointer(tp->md5sig_info, NULL);
> -			kfree_rcu(md5sig);
> +			kfree_rcu(md5sig, rcu);
>  			return -EUSERS;
>  		}
>  	}
> -- 
> 2.39.0.rc0.267.gcb52ba06e7-goog
> 
