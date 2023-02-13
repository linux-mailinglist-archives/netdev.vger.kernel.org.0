Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EB269488A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjBMOsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBMOr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:47:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245CC9006;
        Mon, 13 Feb 2023 06:47:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pRa7O-0005Vu-2U; Mon, 13 Feb 2023 15:47:46 +0100
Date:   Mon, 13 Feb 2023 15:47:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
Message-ID: <20230213144746.GB14680@breakpoint.cc>
References: <20230210071730.21525-1-hbh25y@gmail.com>
 <20230210103250.GC17303@breakpoint.cc>
 <Y+ZrvJZ2lJPhYFtq@salvia>
 <20230212125320.GA780@breakpoint.cc>
 <4c1e4e28-1dea-9750-348d-cb36bd5f5286@gmail.com>
 <20230213081701.GA10665@breakpoint.cc>
 <61f38f9c-2a1f-b9a8-251b-567b7642a190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f38f9c-2a1f-b9a8-251b-567b7642a190@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua <hbh25y@gmail.com> wrote:
> On 13/2/2023 16:17, Florian Westphal wrote:
> > Hangyu Hua <hbh25y@gmail.com> wrote:
> > > On 12/2/2023 20:53, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > One way would be to return 0 in that case (in
> > > > > > nf_conntrack_hash_check_insert()).  What do you think?
> > > > > 
> > > > > This is misleading to the user that adds an entry via ctnetlink?
> > > > > 
> > > > > ETIMEDOUT also looks a bit confusing to report to userspace.
> > > > > Rewinding: if the intention is to deal with stale conntrack extension,
> > > > > for example, helper module has been removed while this entry was
> > > > > added. Then, probably call EAGAIN so nfnetlink has a chance to retry
> > > > > transparently?
> > > > 
> > > > Seems we first need to add a "bool *inserted" so we know when the ct
> > > > entry went public.
> > > > 
> > > I don't think so.
> > > 
> > > nf_conntrack_hash_check_insert(struct nf_conn *ct)
> > > {
> > > ...
> > > 	/* The caller holds a reference to this object */
> > > 	refcount_set(&ct->ct_general.use, 2);			// [1]
> > > 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
> > > 	nf_conntrack_double_unlock(hash, reply_hash);
> > > 	NF_CT_STAT_INC(net, insert);
> > > 	local_bh_enable();
> > > 
> > > 	if (!nf_ct_ext_valid_post(ct->ext)) {
> > > 		nf_ct_kill(ct);					// [2]
> > > 		NF_CT_STAT_INC_ATOMIC(net, drop);
> > > 		return -ETIMEDOUT;
> > > 	}
> > > ...
> > > }
> > > 
> > > We set ct->ct_general.use to 2 in nf_conntrack_hash_check_insert()([1]).
> > > nf_ct_kill willn't put the last refcount. So ct->master will not be freed in
> > > this way. But this means the situation not only causes ct->master's refcount
> > > leak but also releases ct whose refcount is still 1 in nf_conntrack_free()
> > > (in ctnetlink_create_conntrack() err1).
> > 
> > at [2] The refcount could be > 1, as entry became public.  Other CPU
> > might have obtained a reference.
> > 
> > > I think it may be a good idea to set ct->ct_general.use to 0 after
> > > nf_ct_kill() ([2]) to put the caller's reference. What do you think?
> > 
> > We can't, see above.  We need something similar to this (not even compile
> > tested):
> > 
> 
> I see. This patch look good to me. Do I need to make a v2 like this one? Or
> you guys can handle this.

No, I think its best if your patch is applied as-is because it fixes a
real bug.   Mixing both bug fixes in one fix makes it harder for
-stable.

