Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85260528461
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiEPMnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiEPMnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:43:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3C8C38BD7;
        Mon, 16 May 2022 05:43:08 -0700 (PDT)
Date:   Mon, 16 May 2022 14:43:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <YoJG2j0w551KM17k@salvia>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <YoI/z+aWkmAAycR3@salvia>
 <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 02:23:00PM +0200, Sven Auhagen wrote:
> On Mon, May 16, 2022 at 02:13:03PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > > > Connections leaving the established state (due to RST / FIN TCP packets)
> > > > set the flow table teardown flag. The packet path continues to set lower
> > > > timeout value as per the new TCP state but the offload flag remains set.
> > > >
> > > > Hence, the conntrack garbage collector may race to undo the timeout
> > > > adjustment of the packet path, leaving the conntrack entry in place with
> > > > the internal offload timeout (one day).
> > > >
> > > > Avoid ct gc timeout overwrite by flagging teared down flowtable
> > > > connections.
> > > >
> > > > On the nftables side we only need to allow established TCP connections to
> > > > create a flow offload entry. Since we can not guaruantee that
> > > > flow_offload_teardown is called by a TCP FIN packet we also need to make
> > > > sure that flow_offload_fixup_ct is also called in flow_offload_del
> > > > and only fixes up established TCP connections.
> > > [...]
> > > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > > index 0164e5f522e8..324fdb62c08b 100644
> > > > --- a/net/netfilter/nf_conntrack_core.c
> > > > +++ b/net/netfilter/nf_conntrack_core.c
> > > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > > >  
> > > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > > -				nf_ct_offload_timeout(tmp);
> > > 
> > > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > > path that triggers the race, ie. nf_ct_is_expired()
> > > 
> > > The flowtable ct fixup races with conntrack gc collector.
> > > 
> > > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > > the closing packets.
> > > 
> > > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > > in a TCP state that represent closure?
> > > 
> > >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > >   			goto out;
> > > 
> > > this is already the intention in the existing code.
> > 
> > I'm attaching an incomplete sketch patch. My goal is to avoid the
> > extra IPS_ bit.
> 
> You might create a race with ct gc that will remove the ct
> if it is in close or end of close and before flow offload teardown is running
> so flow offload teardown might access memory that was freed.

flow object holds a reference to the ct object until it is released,
no use-after-free can happen.

> It is not a very likely scenario but never the less it might happen now
> since the IPS_OFFLOAD_BIT is not set and the state might just time out.
> 
> If someone sets a very small TCP CLOSE timeout it gets more likely.
> 
> So Oz and myself were debatting about three possible cases/problems:
> 
> 1. ct gc sets timeout even though the state is in CLOSE/FIN because the
> IPS_OFFLOAD is still set but the flow is in teardown
> 2. ct gc removes the ct because the IPS_OFFLOAD is not set and
> the CLOSE timeout is reached before the flow offload del

OK.

> 3. tcp ct is always set to ESTABLISHED with a very long timeout
> in flow offload teardown/delete even though the state is already
> CLOSED.
>
> Also as a remark we can not assume that the FIN or RST packet is hitting
> flow table teardown as the packet might get bumped to the slow path in
> nftables.

I assume this remark is related to 3.?

if IPS_OFFLOAD is unset, then conntrack would update the state
according to this FIN or RST.

Thanks for the summary.
