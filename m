Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F37738E3A0
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhEXKDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 06:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhEXKDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 06:03:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE0DC061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 03:02:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ll7Oz-00042T-HV; Mon, 24 May 2021 12:01:37 +0200
Date:   Mon, 24 May 2021 12:01:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        saeedm@mellanox.com, fw@strlen.de, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: zero-initialize skb extensions on allocation
Message-ID: <20210524100137.GA3194@breakpoint.cc>
References: <20210524061959.2349342-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524061959.2349342-1-vladbu@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlad Buslov <vladbu@nvidia.com> wrote:
> Function skb_ext_add() doesn't initialize created skb extension with any
> value and leaves it up to the user.

That was intentional.

Its unlikely that all extensions are active at the same time on same skb.

This is also the reason why the extension struct uses offset addressing
to get the extension data rather than the simpler

skb_ext {
	struct sec_path sp;
	struct nf_bridge_info nfbr;
	...
}

So adding e.g. mptcp extension will only touch 1 cacheline instead of 3
(or more if more extensions get added in the future).

IOW, i would prefer if tc would add tc_skb_add_ext() or similar and
zero whats needed there.

> Fix the issue by changing __skb_ext_alloc() function to request
> zero-initialized memory from kmem cache. Note that skb extension allocation
> in skb_ext_maybe_cow() is not changed because newly allocated memory is
> immediately overwritten with content of old skb extension so there is no
> need to pre-initialize it.
>
> Multiple users of skb extension API have already been manually setting
> newly allocated skb extension memory to zero. Remove such code and rely on
> skb extension API instead.

Are you sure its safe?

>  static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
>  {
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> -	struct nf_bridge_info *b = skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
> -
> -	if (b)
> -		memset(b, 0, sizeof(*b));
> -
> -	return b;
> +	return skb_ext_add(skb, SKB_EXT_BRIDGE_NF);

So in the (unlikely) case where skb_ext_add did not allocate a new
extension, the memory is no longer cleared.

If the skb had an nf_bridge_info extension previously that got
discarded earlier via skb_ext_del() this now leaks the old content.
