Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C449C143DFB
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgAUN0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:26:25 -0500
Received: from correo.us.es ([193.147.175.20]:57608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgAUN0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 08:26:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39D4BC5154
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 14:26:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25F35DA7A2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 14:26:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A814DA79E; Tue, 21 Jan 2020 14:26:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 128D7DA718;
        Tue, 21 Jan 2020 14:26:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Jan 2020 14:26:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E95B042EE38E;
        Tue, 21 Jan 2020 14:26:18 +0100 (CET)
Date:   Tue, 21 Jan 2020 14:26:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: check for valid chain type
 pointer before dereference
Message-ID: <20200121132618.aykyybudttbxiusx@salvia>
References: <00000000000074ed27059c33dedc@google.com>
 <20200116211109.9119-1-fw@strlen.de>
 <20200118203057.6stoe6axtyoxfcxz@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eyqpjkw3v7d3ikxx"
Content-Disposition: inline
In-Reply-To: <20200118203057.6stoe6axtyoxfcxz@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eyqpjkw3v7d3ikxx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 18, 2020 at 09:30:57PM +0100, Pablo Neira Ayuso wrote:
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
> 
> Otherwise, if a helper function to check for the families that are
> really supported could be another alternative. But not sure it is
> worth?

Not worth.

Probably this patch instead? Just make sure that access to the chain
type array is safe, no direct access to chain_type[][] anymore.

This includes the check for the default type too, since it cannot be
assume to always have a filter chain for unsupported families.

Thanks for explaining.

--eyqpjkw3v7d3ikxx
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65f51a2e9c2a..4aa01c1253b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -553,14 +553,27 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 static const struct nft_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nft_chain_type *
+__nft_chain_type_get(u8 family, enum nft_chain_types type)
+{
+	if (family >= NFPROTO_NUMPROTO ||
+	    type >= NFT_CHAIN_T_MAX)
+		return NULL;
+
+	return chain_type[family][type];
+}
+
+static const struct nft_chain_type *
 __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 {
+	const struct nft_chain_type *type;
 	int i;
 
 	for (i = 0; i < NFT_CHAIN_T_MAX; i++) {
-		if (chain_type[family][i] != NULL &&
-		    !nla_strcmp(nla, chain_type[family][i]->name))
-			return chain_type[family][i];
+		type = __nft_chain_type_get(family, i);
+		if (!type)
+			continue;
+		if (!nla_strcmp(nla, type->name))
+			return type;
 	}
 	return NULL;
 }
@@ -1162,11 +1175,8 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 
 void nft_register_chain_type(const struct nft_chain_type *ctype)
 {
-	if (WARN_ON(ctype->family >= NFPROTO_NUMPROTO))
-		return;
-
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	if (WARN_ON(chain_type[ctype->family][ctype->type] != NULL)) {
+	if (WARN_ON(__nft_chain_type_get(ctype->family, ctype->type))) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		return;
 	}
@@ -1768,7 +1778,10 @@ static int nft_chain_parse_hook(struct net *net,
 	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-	type = chain_type[family][NFT_CHAIN_T_DEFAULT];
+	type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
+	if (!type)
+		return -EOPNOTSUPP;
+
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
 						   family, autoload);

--eyqpjkw3v7d3ikxx--
