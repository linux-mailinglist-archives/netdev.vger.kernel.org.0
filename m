Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D61E177C06
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgCCQhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:37:35 -0500
Received: from fieldses.org ([173.255.197.46]:37298 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgCCQhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 11:37:34 -0500
Received: by fieldses.org (Postfix, from userid 2815)
        id 8913F378; Tue,  3 Mar 2020 11:37:34 -0500 (EST)
Date:   Tue, 3 Mar 2020 11:37:34 -0500
From:   "J . Bruce Fields" <bfields@fieldses.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sunrpc: Pass lockdep expression to RCU lists
Message-ID: <20200303163734.GA19140@fieldses.org>
References: <20200219093504.16290-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219093504.16290-1-frextrite@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 03:05:05PM +0530, Amol Grover wrote:
> detail->hash_table[] is traversed using hlist_for_each_entry_rcu
> outside an RCU read-side critical section but under the protection
> of detail->hash_lock.
> 
> Hence, add corresponding lockdep expression to silence false-positive
> warnings, and harden RCU lists.

Thanks, applying for 5.7.--b.

> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---
>  net/sunrpc/cache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
> index f740cb51802a..5db5f5b94726 100644
> --- a/net/sunrpc/cache.c
> +++ b/net/sunrpc/cache.c
> @@ -97,7 +97,8 @@ static struct cache_head *sunrpc_cache_add_entry(struct cache_detail *detail,
>  	spin_lock(&detail->hash_lock);
>  
>  	/* check if entry appeared while we slept */
> -	hlist_for_each_entry_rcu(tmp, head, cache_list) {
> +	hlist_for_each_entry_rcu(tmp, head, cache_list,
> +				 lockdep_is_held(&detail->hash_lock)) {
>  		if (detail->match(tmp, key)) {
>  			if (cache_is_expired(detail, tmp)) {
>  				hlist_del_init_rcu(&tmp->cache_list);
> -- 
> 2.24.1
