Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5DD49E7E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfFRKpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:45:54 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51688 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729098AbfFRKpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 06:45:51 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdBca-0007ip-2a; Tue, 18 Jun 2019 12:45:48 +0200
Date:   Tue, 18 Jun 2019 12:45:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, wenxu@ucloud.cn,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190618104548.xt5mee2iinx4ve6u@breakpoint.cc>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
 <20190618093508.3c5jjmmmuz3m26uj@salvia>
 <20190618094613.ztbwcclgsq54vkop@breakpoint.cc>
 <20190618100423.tirukx3ro2fl4khs@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618100423.tirukx3ro2fl4khs@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jun 18, 2019 at 11:46:13AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> [...]
> > > Could you describe this problem a bit more? Small example rule plus
> > > scenario.
> > 
> > It was what wenxu reported originally:
> > 
> > nft add rule bridge filter forward ip protocol counter ..
> > 
> > The rule only matches if the ip packet is contained in an ethernet frame
> > without vlan tag -- and thats neither expected nor desirable.
> > 
> > This rule works when using 'meta protocol ip' as dependency instead
> > of ether type ip (what we do now), because VLAN stripping will fix/alter
> > skb->protocol to the inner type when the VLAN tag gets removes.
> > 
> > It will still fail in case there are several VLAN tags, so we might
> > need another meta expression that can figure out the l3 protocol type.
> 
> How would that new meta expression would look like?

I thought about extending nft_exthdr.c for L2, i.e. take
ether->type, and then advance to next vlan header (if vlan type)
until it either reaches skb network offset or an unknown type
(which would then be considered the last/topmost one and the one
 carrying the l3 protocol number).
