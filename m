Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FB36A5758
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjB1K7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjB1K7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:59:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56852D9
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:59:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pWxhh-0002Kr-BL; Tue, 28 Feb 2023 11:59:29 +0100
Date:   Tue, 28 Feb 2023 11:59:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] netfilter: nf_tables: always synchronize with readers
 before releasing tables
Message-ID: <20230228105929.GB6107@breakpoint.cc>
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
 <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
 <20230227124402.GA30043@breakpoint.cc>
 <266de015-7712-8672-9ca0-67199817d587@virtuozzo.com>
 <20230227161140.GA31439@breakpoint.cc>
 <28a88519-d0e2-7629-9ed9-3f9c12ca024b@virtuozzo.com>
 <20230227233155.GA6107@breakpoint.cc>
 <ee004a9d-7d49-448f-16d7-807afc755dd0@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee004a9d-7d49-448f-16d7-807afc755dd0@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
> On 28.02.23 1:31, Florian Westphal wrote:
> > Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
> > > As i said i am still trying to figure out the basechain place,
> > > where is that synchronize_rcu() call done?
> > 
> > cleanup_net() in net/core/net_namespace.c.
> > 
> > pre_exit handlers run, then synchronize_rcu, then the
> > normal exit handlers, then exit_batch.
> 
> It prevents anyone new to find the namespace but it does not guard against
> the ones that have already found it.

The netns is being dismantled, how can there be any process left?

> What stops them to enter a rcu_read_lock() section after the synchronize
> call in cleanup_net() is done and race with the exit handler?

There should be no task in the first place.

> synchronize_rcu() must be called with the commit_mutex held to be safe
> against lock less readers using data protected with commit_mutext.

Sorry, I do not understand this bug nor the fix.
