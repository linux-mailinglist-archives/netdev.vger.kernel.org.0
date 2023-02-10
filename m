Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE646922EC
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 17:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjBJQHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 11:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjBJQHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 11:07:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 51A8C72DD4;
        Fri, 10 Feb 2023 08:07:29 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:07:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Hangyu Hua <hbh25y@gmail.com>, kadlec@netfilter.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
Message-ID: <Y+ZrvJZ2lJPhYFtq@salvia>
References: <20230210071730.21525-1-hbh25y@gmail.com>
 <20230210103250.GC17303@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230210103250.GC17303@breakpoint.cc>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, Feb 10, 2023 at 11:32:50AM +0100, Florian Westphal wrote:
> Hangyu Hua <hbh25y@gmail.com> wrote:
> > nf_ct_put() needs to be called to put the refcount got by
> > nf_conntrack_find_get() to avoid refcount leak when
> > nf_conntrack_hash_check_insert() fails.
> > 
> > Fixes: 7d367e06688d ("netfilter: ctnetlink: fix soft lockup when netlink adds new entries (v2)")
> > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> > ---
> >  net/netfilter/nf_conntrack_netlink.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 1286ae7d4609..ca4d5bb1ea52 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -2375,12 +2375,15 @@ ctnetlink_create_conntrack(struct net *net,
> >  
> >  	err = nf_conntrack_hash_check_insert(ct);
> >  	if (err < 0)
> > -		goto err2;
> > +		goto err3;
> 
> Ouch, looks like this is broken in more than one way?
> 
> nf_conntrack_hash_check_insert() can call nf_ct_kill()
> and return an error, in that case ct->master reference
> is already dropped for us.
> 
> One way would be to return 0 in that case (in
> nf_conntrack_hash_check_insert()).  What do you think?

This is misleading to the user that adds an entry via ctnetlink?

ETIMEDOUT also looks a bit confusing to report to userspace.
Rewinding: if the intention is to deal with stale conntrack extension,
for example, helper module has been removed while this entry was
added. Then, probably call EAGAIN so nfnetlink has a chance to retry
transparently?

BTW, I think we should remove:

NF_CT_STAT_INC_ATOMIC(net, drop);

that is under nf_ct_ext_valid_post(), no packet is dropped in this
path.

Thanks.
