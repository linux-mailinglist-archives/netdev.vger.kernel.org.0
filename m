Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8F529C8A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbiEQIcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbiEQIcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:32:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1A0D427E9;
        Tue, 17 May 2022 01:32:06 -0700 (PDT)
Date:   Tue, 17 May 2022 10:32:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <YoNdg/5IBucYJ+hi@salvia>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <YoI/z+aWkmAAycR3@salvia>
 <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
 <YoJG2j0w551KM17k@salvia>
 <20220516130213.bedrzjmvgvdzuzdc@SvensMacbookPro.hq.voleatech.com>
 <YoKO0dPJs+VjbTXP@salvia>
 <20220516182310.iiufw3exfy2xmb2l@Svens-MacBookPro.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KyuGcuBaevpz6L97"
Content-Disposition: inline
In-Reply-To: <20220516182310.iiufw3exfy2xmb2l@Svens-MacBookPro.local>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KyuGcuBaevpz6L97
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, May 16, 2022 at 08:23:10PM +0200, Sven Auhagen wrote:
> On Mon, May 16, 2022 at 07:50:09PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, May 16, 2022 at 03:02:13PM +0200, Sven Auhagen wrote:
> > > On Mon, May 16, 2022 at 02:43:06PM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, May 16, 2022 at 02:23:00PM +0200, Sven Auhagen wrote:
> > > > > On Mon, May 16, 2022 at 02:13:03PM +0200, Pablo Neira Ayuso wrote:
> > > > > > On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> > > > > > > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > [...]
> > > > > > > [...]
> > > > > > > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > > > > > > index 0164e5f522e8..324fdb62c08b 100644
> > > > > > > > --- a/net/netfilter/nf_conntrack_core.c
> > > > > > > > +++ b/net/netfilter/nf_conntrack_core.c
> > > > > > > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > > > > > > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > > > > > > >
> > > > > > > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > > > > > > -				nf_ct_offload_timeout(tmp);
> > > > > > >
> > > > > > > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > > > > > > path that triggers the race, ie. nf_ct_is_expired()
> > > > > > >
> > > > > > > The flowtable ct fixup races with conntrack gc collector.
> > > > > > >
> > > > > > > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > > > > > > the closing packets.
> > > > > > >
> > > > > > > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > > > > > > in a TCP state that represent closure?
> > > > > > >
> > > > > > >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > > > > > >   			goto out;
> > > > > > >
> > > > > > > this is already the intention in the existing code.
> > > > > >
> > > > > > I'm attaching an incomplete sketch patch. My goal is to avoid the
> > > > > > extra IPS_ bit.
> > > > >
> > > > > You might create a race with ct gc that will remove the ct
> > > > > if it is in close or end of close and before flow offload teardown is running
> > > > > so flow offload teardown might access memory that was freed.
> > > >
> > > > flow object holds a reference to the ct object until it is released,
> > > > no use-after-free can happen.
> > > >
> > >
> > > Also if nf_ct_delete is called before flowtable delete?
> > > Can you let me know why?
> >
> > nf_ct_delete() removes the conntrack object from lists and it
> > decrements the reference counter by one.
> >
> > flow_offload_free() also calls nf_ct_put(). flow_offload_alloc() bumps
> > the reference count on the conntrack object before creating the flow.
> >
> > > > > It is not a very likely scenario but never the less it might happen now
> > > > > since the IPS_OFFLOAD_BIT is not set and the state might just time out.
> > > > >
> > > > > If someone sets a very small TCP CLOSE timeout it gets more likely.
> > > > >
> > > > > So Oz and myself were debatting about three possible cases/problems:
> > > > >
> > > > > 1. ct gc sets timeout even though the state is in CLOSE/FIN because the
> > > > > IPS_OFFLOAD is still set but the flow is in teardown
> > > > > 2. ct gc removes the ct because the IPS_OFFLOAD is not set and
> > > > > the CLOSE timeout is reached before the flow offload del
> > > >
> > > > OK.
> > > >
> > > > > 3. tcp ct is always set to ESTABLISHED with a very long timeout
> > > > > in flow offload teardown/delete even though the state is already
> > > > > CLOSED.
> > > > >
> > > > > Also as a remark we can not assume that the FIN or RST packet is hitting
> > > > > flow table teardown as the packet might get bumped to the slow path in
> > > > > nftables.
> > > >
> > > > I assume this remark is related to 3.?
> > >
> > > Yes, exactly.
> > >
> > > > if IPS_OFFLOAD is unset, then conntrack would update the state
> > > > according to this FIN or RST.
> > >
> > > It will move to a different TCP state anyways only the ct state
> > > will be at IPS_OFFLOAD_BIT and prevent it from beeing garbage collected.
> > > The timeout will be bumped back up as long as IPS_OFFLOAD_BIT is set
> > > even though TCP might already be CLOSED.
>
> I see what you are trying to do here, I have some remarks:
>
> >
> > If teardown fixes the ct state and timeout to established, and IPS_OFFLOAD is
> > unset, then the packet is passed up in a consistent state.
> >
> > I made a patch, it is based on yours, it's attached:
> >
> > - If flow timeout expires or rst/fin is seen, ct state and timeout is
> >   fixed up (to established state) and IPS_OFFLOAD is unset.
> >
> > - If rst/fin packet is seen, ct state and timeout is fixed up (to
> >   established state) and IPS_OFFLOAD is unset. The packet continues
> >   its travel up to the classic path, so conntrack triggers the
> >   transition from established to one of the close states.
> >
> > For the case 1., IPS_OFFLOAD is not set anymore, so conntrack gc
> > cannot race to reset the ct timeout anymore.
> >
> > For the case 2., if gc conntrack ever removes the ct entry, then the
> > IPS_DYING bit is set, which implicitly triggers the teardown state
> > from the flowtable gc. The flowtable still holds a reference to the
> > ct object, so no UAF can happen.
> >
> > For the case 3. the conntrack is set to ESTABLISHED with a long
> > timeout, yes. This is to deal with the two possible cases:
> >
> > a) flowtable timeout expired, so conntrack recovers control on the
> >    flow.
> > b) tcp rst/fin will take back the packet to slow path. The ct has been
> >    fixed up to established state so it will trasition to one of the
> >    close states.
> >
> > Am I missing anything?
>
> You should not fixup the tcp state back to established.
> If flow_offload_teardown is not called because a packet got bumped up to the slow path
> and you call flow_offload_teardown from nf_flow_offload_gc_step, the tcp state might already
> be in CLOSE state and you just moved it back to established.

OK.

> The entire function flow_offload_fixup_tcp can go away if we only allow established tcp states
> in the flowtable.

I'm keeping it, but I remove the reset of the tcp state.

> Same goes for the timeout. The timeout should really be set to the current tcp state
> ct->proto.tcp->state which might not be established anymore.

OK.

> For me the question remains, why can the ct gc not remove the ct when nf_ct_delete
> is called before flow_offload_del is called?

nf_ct_delete() removes indeed the entry from the conntrack table, then
it calls nf_ct_put() which decrements the refcnt. Given that the
flowtable holds a reference to the conntrack object...

 struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 {
        struct flow_offload *flow;

        if (unlikely(nf_ct_is_dying(ct) ||
            !refcount_inc_not_zero(&ct->ct_general.use)))
                return NULL;

... use-after-free cannot happen. Note that flow_offload_free() calls
nf_ct_put(flow->ct), so at this point the ct object is released.

Is this your concern?

> Also you probably want to move the IPS_OFFLOAD_BIT to the beginning of
> flow_offload_teardown just to make sure that the ct gc is not bumping up the ct timeout
> while it is changed in flow_offload_fixup_ct.

Done.

See patch attached.
>
>

--KyuGcuBaevpz6L97
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix-pickup-v2.patch"

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 20b4a14e5d4e..ebdf5332e838 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -179,12 +179,11 @@ EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
 static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 {
-	tcp->state = TCP_CONNTRACK_ESTABLISHED;
 	tcp->seen[0].td_maxwin = 0;
 	tcp->seen[1].td_maxwin = 0;
 }
 
-static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
@@ -193,7 +192,9 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
-		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
+		flow_offload_fixup_tcp(&ct->proto.tcp);
+
+		timeout = tn->timeouts[ct->proto.tcp.state];
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
@@ -211,18 +212,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
 }
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
-{
-	if (nf_ct_protonum(ct) == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
-}
-
-static void flow_offload_fixup_ct(struct nf_conn *ct)
-{
-	flow_offload_fixup_ct_state(ct);
-	flow_offload_fixup_ct_timeout(ct);
-}
-
 static void flow_offload_route_release(struct flow_offload *flow)
 {
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
@@ -361,22 +350,14 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
-
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-
-	if (nf_flow_has_expired(flow))
-		flow_offload_fixup_ct(flow->ct);
-	else
-		flow_offload_fixup_ct_timeout(flow->ct);
-
 	flow_offload_free(flow);
 }
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-
-	flow_offload_fixup_ct_state(flow->ct);
+	flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -466,7 +447,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_has_stale_dst(flow))
-		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 187b8cb9a510..06c9f72d16db 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -298,7 +298,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	case IPPROTO_TCP:
 		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
-		if (unlikely(!tcph || tcph->fin || tcph->rst))
+		if (unlikely(!tcph || tcph->fin || tcph->rst ||
+			     nf_conntrack_tcp_established(&ct->proto.tcp)))
 			goto out;
 		break;
 	case IPPROTO_UDP:

--KyuGcuBaevpz6L97--
