Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5F693779
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 13:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBLMxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 07:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLMxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 07:53:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65AD1207B;
        Sun, 12 Feb 2023 04:53:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pRBr6-0005v4-0v; Sun, 12 Feb 2023 13:53:20 +0100
Date:   Sun, 12 Feb 2023 13:53:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Hangyu Hua <hbh25y@gmail.com>,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
Message-ID: <20230212125320.GA780@breakpoint.cc>
References: <20230210071730.21525-1-hbh25y@gmail.com>
 <20230210103250.GC17303@breakpoint.cc>
 <Y+ZrvJZ2lJPhYFtq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+ZrvJZ2lJPhYFtq@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > One way would be to return 0 in that case (in
> > nf_conntrack_hash_check_insert()).  What do you think?
> 
> This is misleading to the user that adds an entry via ctnetlink?
> 
> ETIMEDOUT also looks a bit confusing to report to userspace.
> Rewinding: if the intention is to deal with stale conntrack extension,
> for example, helper module has been removed while this entry was
> added. Then, probably call EAGAIN so nfnetlink has a chance to retry
> transparently?

Seems we first need to add a "bool *inserted" so we know when the ct
entry went public.

I'll also have a look at switching to a refcount based model for
all extensions that reference external objects, this would avoid
the entire problem, but thats likely more intrusive.
