Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1136A41E0
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjB0MoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0MoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:44:06 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6CA1E29C
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 04:44:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pWcrK-0008AA-G0; Mon, 27 Feb 2023 13:44:02 +0100
Date:   Mon, 27 Feb 2023 13:44:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: always synchronize with readers
 before releasing tables
Message-ID: <20230227124402.GA30043@breakpoint.cc>
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
 <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
> general protection fault, probably for non-canonical
> address 0xdead000000000115: 0000 [#1] PREEMPT SMP NOPTI
> RIP: 0010:__nf_tables_dump_rules+0x10d/0x170 [nf_tables]
> 
> __nf_tables_dump_rules runs under rcu_read_lock while __nft_release_table
> is called from nf_tables_exit_net. commit_mutex is held inside
> nf_tables_exit_net but this is not enough to guard against
> lockless readers. When __nft_release_table does list_del(&rule->list)
> next ptr is poisoned and it crashes while walking the list.
> 
> Before calling __nft_release_tables all lockless readers must be done -
> to ensure this a call to synchronize_rcu() is required.
> 
> nf_tables_exit_net does this in case there is something to abort
> inside __nf_tables_abort but it does not do so otherwise.
> Fix this by add the missing synchronize_rcu() call before calling
> __nft_release_table in the nothing to abort case.
> 
> Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
> Signed-off-by: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
> ---
>  net/netfilter/nf_tables_api.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d73edbd4eec4..849523ece109 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -10333,9 +10333,15 @@ static void __net_exit nf_tables_exit_net(struct
> net *net)
>  	struct nftables_pernet *nft_net = nft_pernet(net);
>   	mutex_lock(&nft_net->commit_mutex);
> +	/* Need to call synchronize_rcu() to let any active rcu lockless
> +	 * readers to finish. __nf_tables_abort does this internaly so
> +	 * only call it here if there is nothing to abort.
> +	 */
>  	if (!list_empty(&nft_net->commit_list) ||
>  	    !list_empty(&nft_net->module_list))
>  		__nf_tables_abort(net, NFNL_ABORT_NONE);
> +	else
> +		synchronize_rcu();

Wouldn't it be better to just drop those list_empty() checks?
AFAICS __nf_tables_abort will DTRT in that case.

You can still add a comment like the one you added above to make
it clear that we also need to wait for those readers to finish.

Lastly, that list_del() in __nft_release_basechain should probably
be list_del_rcu()?
