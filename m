Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754D549554
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfFQWmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:42:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48516 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728701AbfFQWmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:42:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hd0Ke-0001f1-Go; Tue, 18 Jun 2019 00:42:32 +0200
Date:   Tue, 18 Jun 2019 00:42:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, wenxu@ucloud.cn,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617223004.tnqz2bl7qp63fcfy@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Subject: Change bridge l3 dependency to meta protocol
> > 
> > This examines skb->protocol instead of ethernet header type, which
> > might be different when vlan is involved.
> >  
> > +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
> > +		if (expr->payload.desc == &proto_ip ||
> > +		    expr->payload.desc == &proto_ip6)
> > +			desc = &proto_metaeth;
> > +	}i
> 
> Is this sufficient to restrict the matching? Is this still buggy from
> ingress?

This is what netdev family uses as well (skb->protocol i mean).
I'm not sure it will work for output however (haven't checked).

> I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
> the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
> NFTA_PAYLOAD_FLAGS and place it there. Just an idea.

What would NFT_PAYLOAD_CHECK_VLAN do?
You mean disable/enable the 'vlan is there' illusion that nft_payload
provides?  That would work as well of course, but I would prefer to
switch to meta dependencies where possible so we don't rely on
particular layout of a different header class (e.g. meta l4proto doesn't
depend on ip version, and meta protocol won't depend on particular
ethernet frame).

What might be useful is an nft switch to turn off dependeny
insertion, this would also avoid the problem (if users restrict the
matching properly...).

Another unresolved issue is presence of multiple vlan tags, so we might
have to add yet another meta key to retrieve the l3 protocol in use

(the problem at hand was 'ip protocol icmp' not matching traffic inside
 a vlan).

The other issue is lack of vlan awareness in some bridge/netdev
expressions, e.g. reject.

I think we could apply this patch to nft after making sure it works
for output as thats probably the only solution that won't need
changes in the kernel.

If it doesn't, we will need to find a different solution in any case.
