Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F6B141A77
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 00:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgARX2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 18:28:46 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50764 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727012AbgARX2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 18:28:45 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1isxWE-0000DE-7U; Sun, 19 Jan 2020 00:28:42 +0100
Date:   Sun, 19 Jan 2020 00:28:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: check for valid chain type
 pointer before dereference
Message-ID: <20200118232842.GZ795@breakpoint.cc>
References: <00000000000074ed27059c33dedc@google.com>
 <20200116211109.9119-1-fw@strlen.de>
 <20200118203057.6stoe6axtyoxfcxz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118203057.6stoe6axtyoxfcxz@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jan 16, 2020 at 10:11:09PM +0100, Florian Westphal wrote:
> > Its possible to create tables in a family that isn't supported/known.
> > Then, when adding a base chain, the table pointer can be NULL.
> > 
> > This gets us a NULL ptr dereference in nf_tables_addchain().
> > 
> > Fixes: baae3e62f31618 ("netfilter: nf_tables: fix chain type module reference handling")
> > Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/netfilter/nf_tables_api.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 65f51a2e9c2a..e8976128cdb1 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -953,6 +953,9 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
> >  	struct nft_ctx ctx;
> >  	int err;
> >  
> > +	if (family >= NFPROTO_NUMPROTO)
> > +		return -EAFNOSUPPORT;
> > +
> >  	lockdep_assert_held(&net->nft.commit_mutex);
> >  	attr = nla[NFTA_TABLE_NAME];
> >  	table = nft_table_lookup(net, attr, family, genmask);
> > @@ -1765,6 +1768,9 @@ static int nft_chain_parse_hook(struct net *net,
> >  	    ha[NFTA_HOOK_PRIORITY] == NULL)
> >  		return -EINVAL;
> >  
> > +	if (family >= NFPROTO_NUMPROTO)
> > +		return -EAFNOSUPPORT;
> > +
> >  	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
> >  	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
> >  
> > @@ -1774,6 +1780,8 @@ static int nft_chain_parse_hook(struct net *net,
> >  						   family, autoload);
> >  		if (IS_ERR(type))
> >  			return PTR_ERR(type);
> > +	} else if (!type) {
> > +		return -EOPNOTSUPP;
> 
> I think this check should be enough.
> 
> I mean, NFPROTO_NUMPROTO still allows for creating tables for families
> that don't exist (<= NFPROTO_NUMPROTO) and why bother on creating such
> table. As long as such table does not crash the kernel, I think it's
> fine. No changes can be attached anymore anyway.

I had a previous (not-sent) version that added a stronger validation
of nfproto during table creation but I ditched it because it got ugly
due to ifdefs.

As you alrady point out, creating "bogus" family tables is fine,
base chain registration will fail later on from netfilter core.

The NFPROTO_NUMPROTO range check is needed, we use it as index
to table[] in nft_chain_parse_hook().

> Otherwise, if a helper function to check for the families that are
> really supported could be another alternative. But not sure it is
> worth?

It did not look nice so I did not go for it in the end, but I think
doing a simple range check doesn't hurt.
