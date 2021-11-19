Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D441A4571D5
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhKSPoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235061AbhKSPoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 10:44:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF9B461051;
        Fri, 19 Nov 2021 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637336481;
        bh=7jCp09OZFsyHpxgyTMfHgzG11MQA/s7GOB1RPk5axQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsmyiXdPc0iJG5KfbJ4xEglmDogxrUDHt0YfQhNWC1yiN+0Zt6rk16rAYIZ/zHp3Y
         25cvxEc3Dfusrxu0v78+7FBZnTZr9ckCTjU4XOL/IOLUi+IO85WDcSML1kjzRyLYYD
         z8PnWmPFH/f7rfvwfyVdhxLZe1cJYSZ/jcdaPONconitlU2uRLyXVI9TV6j7SmEePq
         FED2BpaYozPcp1Z31BOkraUp3tP3nQfxY2x0KBsgYcXE/U4iiesRwnuzzmCjvQ9fZh
         f66YLxd1RBycqhCYLFtHBrD+mjAjF3/GHBwXLY9WM7zm2mvONjbvWw8ZKEMm+Y5vyV
         p9o/jwjYMOqmw==
Date:   Fri, 19 Nov 2021 17:41:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        antony.antony@secunet.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] xfrm: rework default policy structure
Message-ID: <YZfFnZIUsZnX1bu+@unreal>
References: <20211118142937.5425-1-nicolas.dichtel@6wind.com>
 <YZak297hPRh3Etun@unreal>
 <e724c80c-8b4f-4399-e716-1866d992a4f2@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e724c80c-8b4f-4399-e716-1866d992a4f2@6wind.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 09:06:01AM +0100, Nicolas Dichtel wrote:
> Le 18/11/2021 à 20:09, Leon Romanovsky a écrit :
> > On Thu, Nov 18, 2021 at 03:29:37PM +0100, Nicolas Dichtel wrote:
> >> This is a follow up of commit f8d858e607b2 ("xfrm: make user policy API
> >> complete"). The goal is to align userland API to the internal structures.
> >>
> >> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >> ---
> >>
> >> This patch targets ipsec-next, but because ipsec-next has not yet been
> >> rebased on top of net-next, I based the patch on top of net-next.
> >>
> >>  include/net/netns/xfrm.h |  6 +-----
> >>  include/net/xfrm.h       | 38 ++++++++---------------------------
> >>  net/xfrm/xfrm_policy.c   | 10 +++++++---
> >>  net/xfrm/xfrm_user.c     | 43 +++++++++++++++++-----------------------
> >>  4 files changed, 34 insertions(+), 63 deletions(-)
> >>
> >> diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
> >> index 947733a639a6..bd7c3be4af5d 100644
> >> --- a/include/net/netns/xfrm.h
> >> +++ b/include/net/netns/xfrm.h
> >> @@ -66,11 +66,7 @@ struct netns_xfrm {
> >>  	int			sysctl_larval_drop;
> >>  	u32			sysctl_acq_expires;
> >>  
> >> -	u8			policy_default;
> >> -#define XFRM_POL_DEFAULT_IN	1
> >> -#define XFRM_POL_DEFAULT_OUT	2
> >> -#define XFRM_POL_DEFAULT_FWD	4
> >> -#define XFRM_POL_DEFAULT_MASK	7
> >> +	u8			policy_default[XFRM_POLICY_MAX];
> >>  
> >>  #ifdef CONFIG_SYSCTL
> >>  	struct ctl_table_header	*sysctl_hdr;
> >> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> >> index 2308210793a0..3fd1e052927e 100644
> >> --- a/include/net/xfrm.h
> >> +++ b/include/net/xfrm.h
> >> @@ -1075,22 +1075,6 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
> >>  }
> >>  
> >>  #ifdef CONFIG_XFRM
> >> -static inline bool
> >> -xfrm_default_allow(struct net *net, int dir)
> >> -{
> >> -	u8 def = net->xfrm.policy_default;
> >> -
> >> -	switch (dir) {
> >> -	case XFRM_POLICY_IN:
> >> -		return def & XFRM_POL_DEFAULT_IN ? false : true;
> >> -	case XFRM_POLICY_OUT:
> >> -		return def & XFRM_POL_DEFAULT_OUT ? false : true;
> >> -	case XFRM_POLICY_FWD:
> >> -		return def & XFRM_POL_DEFAULT_FWD ? false : true;
> >> -	}
> >> -	return false;
> >> -}
> >> -
> >>  int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
> >>  			unsigned short family);
> >>  
> >> @@ -1104,13 +1088,10 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
> >>  	if (sk && sk->sk_policy[XFRM_POLICY_IN])
> >>  		return __xfrm_policy_check(sk, ndir, skb, family);
> >>  
> >> -	if (xfrm_default_allow(net, dir))
> >> -		return (!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
> >> -		       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
> >> -		       __xfrm_policy_check(sk, ndir, skb, family);
> >> -	else
> >> -		return (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
> >> -		       __xfrm_policy_check(sk, ndir, skb, family);
> >> +	return (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT &&
> >> +		(!net->xfrm.policy_count[dir] && !secpath_exists(skb))) ||
> >> +	       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
> >> +	       __xfrm_policy_check(sk, ndir, skb, family);
> >>  }
> > 
> > This is completely unreadable. What is the advantage of writing like this?
> Yeah, I was hesitating. I was hoping that indentation could help.
> At the opposite, I could also arg that having two times the "nearly" same test
> is also unreadable.
> I choose to drop xfrm_default_allow() to remove the negation in
> xfrm_lookup_with_ifid():
> 
> -           !xfrm_default_allow(net, dir)) {
> +           net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
> 
> 
> What about:
> 
> static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
>                                          int dir)
> {
>         if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
>                 return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;
> 
>         return false;
> }

It is much better, just extra "!" is not in place.
if (!net->xfrm.policy_count[dir] ... -> if (net->xfrm.policy_count[dir] ...

Thanks
