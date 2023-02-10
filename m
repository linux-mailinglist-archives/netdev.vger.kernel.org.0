Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3197691CC6
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjBJKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjBJKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:33:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3F86D609;
        Fri, 10 Feb 2023 02:33:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pQQi2-0005P7-M8; Fri, 10 Feb 2023 11:32:50 +0100
Date:   Fri, 10 Feb 2023 11:32:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
Message-ID: <20230210103250.GC17303@breakpoint.cc>
References: <20230210071730.21525-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210071730.21525-1-hbh25y@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua <hbh25y@gmail.com> wrote:
> nf_ct_put() needs to be called to put the refcount got by
> nf_conntrack_find_get() to avoid refcount leak when
> nf_conntrack_hash_check_insert() fails.
> 
> Fixes: 7d367e06688d ("netfilter: ctnetlink: fix soft lockup when netlink adds new entries (v2)")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 1286ae7d4609..ca4d5bb1ea52 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2375,12 +2375,15 @@ ctnetlink_create_conntrack(struct net *net,
>  
>  	err = nf_conntrack_hash_check_insert(ct);
>  	if (err < 0)
> -		goto err2;
> +		goto err3;

Ouch, looks like this is broken in more than one way?

nf_conntrack_hash_check_insert() can call nf_ct_kill()
and return an error, in that case ct->master reference
is already dropped for us.

One way would be to return 0 in that case (in
nf_conntrack_hash_check_insert()).  What do you think?
