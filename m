Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A475E522D46
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiEKH1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbiEKH1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:27:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C256B3BBEB;
        Wed, 11 May 2022 00:27:01 -0700 (PDT)
Date:   Wed, 11 May 2022 09:26:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/17] netfilter: ecache: use dedicated list for
 event redelivery
Message-ID: <YntlQs6xcAJeBwue@salvia>
References: <20220510122150.92533-1-pablo@netfilter.org>
 <20220510122150.92533-2-pablo@netfilter.org>
 <20220510192019.2f02057b@kernel.org>
 <20220511054634.GA4873@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220511054634.GA4873@breakpoint.cc>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 07:46:34AM +0200, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 10 May 2022 14:21:34 +0200 Pablo Neira Ayuso wrote:
> > > +next:
> > > +	sent = 0;
> > > +	spin_lock_bh(&cnet->ecache.dying_lock);
> > > +
> > > +	hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list, hnnode) {
> > ...
> > > +		if (sent++ > 16) {
> > > +			spin_unlock_bh(&cnet->ecache.dying_lock);
> > > +			cond_resched();
> > > +			spin_lock_bh(&cnet->ecache.dying_lock);
> > > +			goto next;
> > 
> > sparse seems right, the looking looks off in this function
> 
> Pablo, its probably best to squash this, what do you think?

yes florian, i'll squash it

> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -75,7 +75,6 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
>  		if (sent++ > 16) {
>  			spin_unlock_bh(&cnet->ecache.dying_lock);
>  			cond_resched();
> -			spin_lock_bh(&cnet->ecache.dying_lock);
>  			goto next;
>  		}
>  	}
