Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020065283EF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiEPMNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiEPMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:13:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3203275E6;
        Mon, 16 May 2022 05:13:07 -0700 (PDT)
Date:   Mon, 16 May 2022 14:13:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <YoI/z+aWkmAAycR3@salvia>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mhiSkIpEXrIlsTSJ"
Content-Disposition: inline
In-Reply-To: <YoIt5rHw4Xwl1zgY@salvia>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mhiSkIpEXrIlsTSJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > Connections leaving the established state (due to RST / FIN TCP packets)
> > set the flow table teardown flag. The packet path continues to set lower
> > timeout value as per the new TCP state but the offload flag remains set.
> >
> > Hence, the conntrack garbage collector may race to undo the timeout
> > adjustment of the packet path, leaving the conntrack entry in place with
> > the internal offload timeout (one day).
> >
> > Avoid ct gc timeout overwrite by flagging teared down flowtable
> > connections.
> >
> > On the nftables side we only need to allow established TCP connections to
> > create a flow offload entry. Since we can not guaruantee that
> > flow_offload_teardown is called by a TCP FIN packet we also need to make
> > sure that flow_offload_fixup_ct is also called in flow_offload_del
> > and only fixes up established TCP connections.
> [...]
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 0164e5f522e8..324fdb62c08b 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> >  
> >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > -				nf_ct_offload_timeout(tmp);
> 
> Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> path that triggers the race, ie. nf_ct_is_expired()
> 
> The flowtable ct fixup races with conntrack gc collector.
> 
> Clearing IPS_OFFLOAD might result in offloading the entry again for
> the closing packets.
> 
> Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> in a TCP state that represent closure?
> 
>   		if (unlikely(!tcph || tcph->fin || tcph->rst))
>   			goto out;
> 
> this is already the intention in the existing code.

I'm attaching an incomplete sketch patch. My goal is to avoid the
extra IPS_ bit.

--mhiSkIpEXrIlsTSJ
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 20b4a14e5d4e..7af1e2e8f595 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -362,8 +362,6 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
 
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(flow->ct);
 	else
@@ -375,6 +373,7 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 
 	flow_offload_fixup_ct_state(flow->ct);
 }
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 187b8cb9a510..7bc56377496c 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -273,6 +273,12 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 	return false;
 }
 
+static bool flow_offload_teardown_state(const struct ip_ct_tcp *state)
+{
+	return state->state > TCP_CONNTRACK_ESTABLISHED &&
+	       state->state <= TCP_CONNTRACK_CLOSE;
+}
+
 static void nft_flow_offload_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -298,7 +304,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	case IPPROTO_TCP:
 		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
-		if (unlikely(!tcph || tcph->fin || tcph->rst))
+		if (unlikely(!tcph || tcph->fin || tcph->rst ||
+			     flow_offload_teardown_state(ct->proto.tcp)))
 			goto out;
 		break;
 	case IPPROTO_UDP:

--mhiSkIpEXrIlsTSJ--
