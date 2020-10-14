Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56A028DB22
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgJNIXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgJNIXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:23:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A7BC051111;
        Wed, 14 Oct 2020 01:23:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kSc4T-0000RN-HK; Wed, 14 Oct 2020 10:23:41 +0200
Date:   Wed, 14 Oct 2020 10:23:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201014082341.GA16895@breakpoint.cc>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
 <20201009200548.GG5723@breakpoint.cc>
 <20201014000628.GA15290@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014000628.GA15290@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes, we iterate table on re-register and modify the existing entries.
> 
> For iptables-nft, it might be possible to avoid this deregister +
> register ct hooks in the same transaction: Maybe add something like
> nf_ct_netns_get_all() to bump refcounters by one _iff_ they are > 0
> before starting the transaction processing, then call
> nf_ct_netns_put_all() which decrements refcounters and unregister
> hooks if they reach 0.

No need, its already fine.  Decrement happens from destroy path,
so new rules are already in place.

> The only problem with this approach is that this pulls in the
> conntrack module, to solve that, struct nf_ct_hook in
> net/netfilter/core.c could be used to store the reference to
> ->netns_get_all and ->net_put_all.
> 
> Legacy would still be flawed though.

Its fine too, new rule blob gets handled (and match/target checkentry
called) before old one is dismantled.

We only have a 0 refcount + hook unregister when rules get
flushed/removed explicitly.
