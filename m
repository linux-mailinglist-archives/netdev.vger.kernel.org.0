Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7633849DB6
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfFRJqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:46:18 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51458 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729308AbfFRJqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:46:17 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdAgv-0007OL-QD; Tue, 18 Jun 2019 11:46:13 +0200
Date:   Tue, 18 Jun 2019 11:46:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, wenxu@ucloud.cn,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190618094613.ztbwcclgsq54vkop@breakpoint.cc>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
 <20190618093508.3c5jjmmmuz3m26uj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618093508.3c5jjmmmuz3m26uj@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jun 18, 2019 at 12:42:32AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Subject: Change bridge l3 dependency to meta protocol
> > > > 
> > > > This examines skb->protocol instead of ethernet header type, which
> > > > might be different when vlan is involved.
> > > >  
> > > > +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
> > > > +		if (expr->payload.desc == &proto_ip ||
> > > > +		    expr->payload.desc == &proto_ip6)
> > > > +			desc = &proto_metaeth;
> > > > +	}i
> > > 
> > > Is this sufficient to restrict the matching? Is this still buggy from
> > > ingress?
> > 
> > This is what netdev family uses as well (skb->protocol i mean).
> > I'm not sure it will work for output however (haven't checked).
> 
> You mean for locally generated traffic?

Yes.

> > > I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
> > > the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
> > > NFTA_PAYLOAD_FLAGS and place it there. Just an idea.
> > 
> > What would NFT_PAYLOAD_CHECK_VLAN do?
> 
> Similar to the checksum approach, it provides a hint to the kernel to
> say that "I want to look at the vlan header" from the link layer.

I see.  Its a bit of a furhter problem because tags can be nested,
so we would have to provide a more dynamic approach, similar to tunnel
matching (vlan header 0 id 42 vlan header 1 id 23' etc).

> > What might be useful is an nft switch to turn off dependeny
> > insertion, this would also avoid the problem (if users restrict the
> > matching properly...).
> 
> Hm. How does this toggle would look like?

nft --nodep add rule bridge filter input ip protocol icmp # broken, has false positives
nft --nodep add rule bridge filter input ip version 4 ip protocol icmp # might work
nft --nodep add rule bridge filter input meta protocol ip ip protocol icmp # might work too

Its kind of I-Know-What-I-Am-Doing switch ...

We can already do this with raw payload expressions but those aren't that user
friendly.

> > Another unresolved issue is presence of multiple vlan tags, so we might
> > have to add yet another meta key to retrieve the l3 protocol in use
> > 
> > (the problem at hand was 'ip protocol icmp' not matching traffic inside
> >  a vlan).
> 
> Could you describe this problem a bit more? Small example rule plus
> scenario.

It was what wenxu reported originally:

nft add rule bridge filter forward ip protocol counter ..

The rule only matches if the ip packet is contained in an ethernet frame
without vlan tag -- and thats neither expected nor desirable.

This rule works when using 'meta protocol ip' as dependency instead
of ether type ip (what we do now), because VLAN stripping will fix/alter
skb->protocol to the inner type when the VLAN tag gets removes.

It will still fail in case there are several VLAN tags, so we might
need another meta expression that can figure out the l3 protocol type.

Does that make sense so far?
