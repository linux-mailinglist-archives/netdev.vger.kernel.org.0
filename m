Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C3B14635F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 09:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgAWIVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 03:21:15 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43226 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgAWIVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 03:21:15 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iuXje-0005Xd-Ny; Thu, 23 Jan 2020 09:21:06 +0100
Date:   Thu, 23 Jan 2020 09:21:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Praveen Chaudhary <praveen5582@gmail.com>, pablo@netfilter.org,
        davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH v3] [net]: Fix skb->csum update in
 inet_proto_csum_replace16().
Message-ID: <20200123082106.GT795@breakpoint.cc>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
 <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
 <16d56ee6-53bc-1124-3700-bc0a78f927d6@iogearbox.net>
 <20200122114333.GQ795@breakpoint.cc>
 <daf995db-37c6-a2f7-4d12-5c1a29e1c59b@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daf995db-37c6-a2f7-4d12-5c1a29e1c59b@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 1/22/20 12:43 PM, Florian Westphal wrote:
> > Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > @@ -449,9 +464,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
> > > >    	if (skb->ip_summed != CHECKSUM_PARTIAL) {
> > > >    		*sum = csum_fold(csum_partial(diff, sizeof(diff),
> > > >    				 ~csum_unfold(*sum)));
> > > > -		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
> > > > -			skb->csum = ~csum_partial(diff, sizeof(diff),
> > > > -						  ~skb->csum);
> > > 
> > > What is the technical rationale in removing this here but not in any of the
> > > other inet_proto_csum_replace*() functions? You changelog has zero analysis
> > > on why here but not elsewhere this change would be needed?
> > 
> > Right, I think it could be dropped everywhere BUT there is a major caveat:
> > 
> > At least for the nf_nat case ipv4 header manipulation (which uses the other
> > helpers froum utils.c) will eventually also update iph->checksum field
> > to account for the changed ip addresses.
> > 
> > And that update doesn't touch skb->csum.
> > 
> > So in a way the update of skb->csum in the other helpers indirectly account
> > for later ip header checksum update.
> > 
> > At least that was my conclusion when reviewing the earlier incarnation
> > of the patch.
> 
> Mainly asking because not inet_proto_csum_replace16() but the other ones are
> exposed via BPF and they are all in no way fundamentally different to each
> other, but my concern is that depending on how the BPF prog updates the csums
> things could start to break. :/

I'm reasonably sure removing the skb->csum update from the other
helpers will also break ipv4 nat :)

So, AFAIU from what you're saying above the patch seems fine as-is and
just needs a more verbose commit message explaining why replace16()
doesn't update skb->csum while all the other ones do.

Is that correct?
