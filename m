Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE66657BE
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfGKNNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 09:13:10 -0400
Received: from mail.us.es ([193.147.175.20]:44962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbfGKNNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 09:13:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A629DD2AA2A
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 15:13:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 970AADA704
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 15:13:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B209A8E3; Thu, 11 Jul 2019 15:13:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 571AEDA732;
        Thu, 11 Jul 2019 15:13:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jul 2019 15:13:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [46.6.141.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C90564265A5B;
        Thu, 11 Jul 2019 15:13:02 +0200 (CEST)
Date:   Thu, 11 Jul 2019 15:13:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 3/3] net: flow_offload: add flow_block structure
 and use it
Message-ID: <20190711131300.ojbo5hxzvv6wi44t@salvia>
References: <20190711001235.20686-1-pablo@netfilter.org>
 <20190711001235.20686-3-pablo@netfilter.org>
 <20190711080609.GF2291@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711080609.GF2291@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 10:06:09AM +0200, Jiri Pirko wrote:
> Thu, Jul 11, 2019 at 02:12:35AM CEST, pablo@netfilter.org wrote:
> >This object stores the flow block callbacks that are attached to this
> >block. This patch restores block sharing.
> >
> >Fixes: da3eeb904ff4 ("net: flow_offload: add list handling functions")
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >---
> > include/net/flow_offload.h        |  5 +++++
> > include/net/netfilter/nf_tables.h |  5 +++--
> > include/net/sch_generic.h         |  2 +-
> > net/core/flow_offload.c           |  2 +-
> > net/netfilter/nf_tables_api.c     |  2 +-
> > net/netfilter/nf_tables_offload.c |  5 +++--
> > net/sched/cls_api.c               | 10 +++++++---
> > 7 files changed, 21 insertions(+), 10 deletions(-)
> >
> >diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> >index 98bf3af5c84d..e50d94736829 100644
> >--- a/include/net/flow_offload.h
> >+++ b/include/net/flow_offload.h
> >@@ -248,6 +248,10 @@ enum flow_block_binder_type {
> > 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
> > };
> > 
> >+struct flow_block {
> >+	struct list_head cb_list;
> >+};
> >+
> > struct netlink_ext_ack;
> > 
> > struct flow_block_offload {
> >@@ -255,6 +259,7 @@ struct flow_block_offload {
> > 	enum flow_block_binder_type binder_type;
> > 	bool block_shared;
> > 	struct net *net;
> >+	struct flow_block *block;
> > 	struct list_head cb_list;
> > 	struct list_head *driver_block_list;
> > 	struct netlink_ext_ack *extack;
> >diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> >index 35dfdd9f69b3..00658462f89b 100644
> >--- a/include/net/netfilter/nf_tables.h
> >+++ b/include/net/netfilter/nf_tables.h
> >@@ -11,6 +11,7 @@
> > #include <linux/rhashtable.h>
> > #include <net/netfilter/nf_flow_table.h>
> > #include <net/netlink.h>
> >+#include <net/flow_offload.h>
> > 
> > struct module;
> > 
> >@@ -951,7 +952,7 @@ struct nft_stats {
> >  *	@stats: per-cpu chain stats
> >  *	@chain: the chain
> >  *	@dev_name: device name that this base chain is attached to (if any)
> >- *	@cb_list: list of flow block callbacks (for hardware offload)
> >+ *	@block: flow block (for hardware offload)
> >  */
> > struct nft_base_chain {
> > 	struct nf_hook_ops		ops;
> >@@ -961,7 +962,7 @@ struct nft_base_chain {
> > 	struct nft_stats __percpu	*stats;
> > 	struct nft_chain		chain;
> > 	char 				dev_name[IFNAMSIZ];
> >-	struct list_head		cb_list;
> >+	struct flow_block		block;
> > };
> > 
> > static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
> >diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> >index 9482e060483b..58041cb0ce15 100644
> >--- a/include/net/sch_generic.h
> >+++ b/include/net/sch_generic.h
> >@@ -399,7 +399,7 @@ struct tcf_block {
> > 	refcount_t refcnt;
> > 	struct net *net;
> > 	struct Qdisc *q;
> >-	struct list_head cb_list;
> >+	struct flow_block flow;
> 
> It is not a "flow", that is confusing. It should be named "flow_block".

Done.

> > 	struct list_head owner_list;
> > 	bool keep_dst;
> > 	unsigned int offloadcnt; /* Number of oddloaded filters */
> >diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> >index a800fa78d96c..935c7f81a9ef 100644
> >--- a/net/core/flow_offload.c
> >+++ b/net/core/flow_offload.c
> >@@ -198,7 +198,7 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
> > {
> > 	struct flow_block_cb *block_cb;
> > 
> >-	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
> >+	list_for_each_entry(block_cb, &f->block->cb_list, list) {
> 
> Please made struct flow_block *block and argument of cb_lookup instead
> of struct flow_block_offload *f (as it was previously).

I can do so if you insist, this will make this fix larger.

> > 		if (block_cb->cb == cb &&
> > 		    block_cb->cb_ident == cb_ident)
> > 			return block_cb;
> >diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> >index ed17a7c29b86..c565f146435b 100644
> >--- a/net/netfilter/nf_tables_api.c
> >+++ b/net/netfilter/nf_tables_api.c
> >@@ -1662,7 +1662,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
> > 
> > 		chain->flags |= NFT_BASE_CHAIN | flags;
> > 		basechain->policy = NF_ACCEPT;
> >-		INIT_LIST_HEAD(&basechain->cb_list);
> >+		INIT_LIST_HEAD(&basechain->block.cb_list);
> > 	} else {
> > 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
> > 		if (chain == NULL)
> >diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> >index 2c3302845f67..2a184277ee58 100644
> >--- a/net/netfilter/nf_tables_offload.c
> >+++ b/net/netfilter/nf_tables_offload.c
> >@@ -116,7 +116,7 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
> > 	struct flow_block_cb *block_cb;
> > 	int err;
> > 
> >-	list_for_each_entry(block_cb, &basechain->cb_list, list) {
> >+	list_for_each_entry(block_cb, &basechain->block.cb_list, list) {
> > 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
> > 		if (err < 0)
> > 			return err;
> >@@ -154,7 +154,7 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
> > static int nft_flow_offload_bind(struct flow_block_offload *bo,
> > 				 struct nft_base_chain *basechain)
> > {
> >-	list_splice(&bo->cb_list, &basechain->cb_list);
> >+	list_splice(&bo->cb_list, &basechain->block.cb_list);
> > 	return 0;
> > }
> > 
> >@@ -198,6 +198,7 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
> > 		return -EOPNOTSUPP;
> > 
> > 	bo.command = cmd;
> >+	bo.block = &basechain->block;
> > 	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> > 	bo.extack = &extack;
> > 	INIT_LIST_HEAD(&bo.cb_list);
> >diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> >index 51fbe6e95a92..66181961ad6f 100644
> >--- a/net/sched/cls_api.c
> >+++ b/net/sched/cls_api.c
> >@@ -691,6 +691,8 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
> > 	if (!indr_dev->block)
> > 		return;
> > 
> >+	bo.block = &indr_dev->block->flow;
> >+
> > 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
> > 			  &bo);
> > 	tcf_block_setup(indr_dev->block, &bo);
> >@@ -775,6 +777,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
> > 		.command	= command,
> > 		.binder_type	= ei->binder_type,
> > 		.net		= dev_net(dev),
> >+		.block		= &block->flow,
> > 		.block_shared	= tcf_block_shared(block),
> > 		.extack		= extack,
> > 	};
> >@@ -810,6 +813,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
> > 	bo.net = dev_net(dev);
> > 	bo.command = command;
> > 	bo.binder_type = ei->binder_type;
> >+	bo.block = &block->flow;
> > 	bo.block_shared = tcf_block_shared(block);
> > 	bo.extack = extack;
> > 	INIT_LIST_HEAD(&bo.cb_list);
> >@@ -988,7 +992,7 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
> > 	}
> > 	mutex_init(&block->lock);
> > 	INIT_LIST_HEAD(&block->chain_list);
> >-	INIT_LIST_HEAD(&block->cb_list);
> >+	INIT_LIST_HEAD(&block->flow.cb_list);
> 
> With introduction of struct flow_block, please introduce also a helper
> to init this struct. Does not look right to init it from user codes
> (tc/nft).

Done.
