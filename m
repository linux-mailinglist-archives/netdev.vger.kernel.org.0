Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D31522BE6
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 07:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbiEKFqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 01:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiEKFqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 01:46:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109F76C0D9;
        Tue, 10 May 2022 22:46:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nofBC-0001IU-Jy; Wed, 11 May 2022 07:46:34 +0200
Date:   Wed, 11 May 2022 07:46:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/17] netfilter: ecache: use dedicated list for
 event redelivery
Message-ID: <20220511054634.GA4873@breakpoint.cc>
References: <20220510122150.92533-1-pablo@netfilter.org>
 <20220510122150.92533-2-pablo@netfilter.org>
 <20220510192019.2f02057b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510192019.2f02057b@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 10 May 2022 14:21:34 +0200 Pablo Neira Ayuso wrote:
> > +next:
> > +	sent = 0;
> > +	spin_lock_bh(&cnet->ecache.dying_lock);
> > +
> > +	hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list, hnnode) {
> ...
> > +		if (sent++ > 16) {
> > +			spin_unlock_bh(&cnet->ecache.dying_lock);
> > +			cond_resched();
> > +			spin_lock_bh(&cnet->ecache.dying_lock);
> > +			goto next;
> 
> sparse seems right, the looking looks off in this function

Pablo, its probably best to squash this, what do you think?

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -75,7 +75,6 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 		if (sent++ > 16) {
 			spin_unlock_bh(&cnet->ecache.dying_lock);
 			cond_resched();
-			spin_lock_bh(&cnet->ecache.dying_lock);
 			goto next;
 		}
 	}
