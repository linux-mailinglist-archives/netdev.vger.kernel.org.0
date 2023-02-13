Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E06693F64
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBMIRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMIRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:17:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320A711649;
        Mon, 13 Feb 2023 00:17:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pRU1F-0002zj-MZ; Mon, 13 Feb 2023 09:17:01 +0100
Date:   Mon, 13 Feb 2023 09:17:01 +0100
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
Message-ID: <20230213081701.GA10665@breakpoint.cc>
References: <20230210071730.21525-1-hbh25y@gmail.com>
 <20230210103250.GC17303@breakpoint.cc>
 <Y+ZrvJZ2lJPhYFtq@salvia>
 <20230212125320.GA780@breakpoint.cc>
 <4c1e4e28-1dea-9750-348d-cb36bd5f5286@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c1e4e28-1dea-9750-348d-cb36bd5f5286@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua <hbh25y@gmail.com> wrote:
> On 12/2/2023 20:53, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > One way would be to return 0 in that case (in
> > > > nf_conntrack_hash_check_insert()).  What do you think?
> > > 
> > > This is misleading to the user that adds an entry via ctnetlink?
> > > 
> > > ETIMEDOUT also looks a bit confusing to report to userspace.
> > > Rewinding: if the intention is to deal with stale conntrack extension,
> > > for example, helper module has been removed while this entry was
> > > added. Then, probably call EAGAIN so nfnetlink has a chance to retry
> > > transparently?
> > 
> > Seems we first need to add a "bool *inserted" so we know when the ct
> > entry went public.
> > 
> I don't think so.
> 
> nf_conntrack_hash_check_insert(struct nf_conn *ct)
> {
> ...
> 	/* The caller holds a reference to this object */
> 	refcount_set(&ct->ct_general.use, 2);			// [1]
> 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
> 	nf_conntrack_double_unlock(hash, reply_hash);
> 	NF_CT_STAT_INC(net, insert);
> 	local_bh_enable();
> 
> 	if (!nf_ct_ext_valid_post(ct->ext)) {
> 		nf_ct_kill(ct);					// [2]
> 		NF_CT_STAT_INC_ATOMIC(net, drop);
> 		return -ETIMEDOUT;
> 	}
> ...
> }
> 
> We set ct->ct_general.use to 2 in nf_conntrack_hash_check_insert()([1]).
> nf_ct_kill willn't put the last refcount. So ct->master will not be freed in
> this way. But this means the situation not only causes ct->master's refcount
> leak but also releases ct whose refcount is still 1 in nf_conntrack_free()
> (in ctnetlink_create_conntrack() err1).

at [2] The refcount could be > 1, as entry became public.  Other CPU
might have obtained a reference.

> I think it may be a good idea to set ct->ct_general.use to 0 after
> nf_ct_kill() ([2]) to put the caller's reference. What do you think?

We can't, see above.  We need something similar to this (not even compile
tested):

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 24002bc61e07..b9e0e01dae43 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -379,12 +379,16 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
 struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 {
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
+	bool inserted;
 	int err;
 
 	nfct->status |= IPS_CONFIRMED;
-	err = nf_conntrack_hash_check_insert(nfct);
+	err = nf_conntrack_hash_check_insert(nfctm, &inserted);
 	if (err < 0) {
-		nf_conntrack_free(nfct);
+		if (inserted)
+			nf_ct_put(nfct);
+		else
+			nf_conntrack_free(nfct);
 		return NULL;
 	}
 	return nfct;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 496c4920505b..5f7b1fd744ef 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -872,7 +872,7 @@ static bool nf_ct_ext_valid_post(struct nf_ct_ext *ext)
 }
 
 int
-nf_conntrack_hash_check_insert(struct nf_conn *ct)
+nf_conntrack_hash_check_insert(struct nf_conn *ct, bool *inserted)
 {
 	const struct nf_conntrack_zone *zone;
 	struct net *net = nf_ct_net(ct);
@@ -884,12 +884,11 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	unsigned int sequence;
 	int err = -EEXIST;
 
+	*inserted = false;
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
-		return -ETIMEDOUT;
-	}
+	if (!nf_ct_ext_valid_pre(ct->ext))
+		return -EAGAIN;
 
 	local_bh_disable();
 	do {
@@ -924,6 +923,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 			goto chaintoolong;
 	}
 
+	*inserted = true;
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
@@ -934,8 +934,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return -ETIMEDOUT;
+		return -EAGAIN;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1286ae7d4609..7ada6350c34d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2244,8 +2244,10 @@ ctnetlink_create_conntrack(struct net *net,
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_tstamp *tstamp;
+	bool inserted;
 	u64 timeout;
 
+restart:
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
 		return ERR_PTR(-ENOMEM);
@@ -2373,10 +2375,26 @@ ctnetlink_create_conntrack(struct net *net,
 	if (tstamp)
 		tstamp->start = ktime_get_real_ns();
 
-	err = nf_conntrack_hash_check_insert(ct);
-	if (err < 0)
-		goto err2;
+	err = nf_conntrack_hash_check_insert(ct, &inserted);
+	if (err < 0) {
+		if (inserted) {
+			nf_ct_put(ct);
+			rcu_read_unlock();
+			if (err == -EAGAIN)
+				goto restart;
+			return err;
+		}
 
+		if (ct->master)
+			nf_ct_put(ct->master);
+
+		if (err == -EAGAIN) {
+			rcu_read_unlock();
+			nf_conntrack_free(ct);
+			goto restart;
+		}
+		goto err2;
+	}
 	rcu_read_unlock();
 
 	return ct;
