Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9660F28DADD
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgJNILs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:11:48 -0400
Received: from correo.us.es ([193.147.175.20]:49516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgJNILr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 04:11:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37EF4120825
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 10:11:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28021DA72F
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 10:11:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D6B1DA793; Wed, 14 Oct 2020 10:11:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C37DDDA844;
        Wed, 14 Oct 2020 10:11:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 10:11:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9912442EFB81;
        Wed, 14 Oct 2020 10:11:40 +0200 (CEST)
Date:   Wed, 14 Oct 2020 10:11:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201014081140.GA16515@salvia>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201014000628.GA15290@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 02:06:28AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 09, 2020 at 10:05:48PM +0200, Florian Westphal wrote:
> > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > The "delay unregister" remark was wrt. the "all rules were deleted"
> > > > case, i.e. add a "grace period" rather than acting right away when
> > > > conntrack use count did hit 0.
> > > 
> > > Now I understand it, thanks really. The hooks are removed, so conntrack 
> > > cannot "see" the packets and the entries become stale. 
> > 
> > Yes.
> > 
> > > What is the rationale behind "remove the conntrack hooks when there are no 
> > > rule left referring to conntrack"? Performance optimization? But then the 
> > > content of the whole conntrack table could be deleted too... ;-)
> > 
> > Yes, this isn't the case at the moment -- only hooks are removed,
> > entries will eventually time out.
> > 
> > > > Conntrack entries are not removed, only the base hooks get unregistered. 
> > > > This is a problem for tcp window tracking.
> > > > 
> > > > When re-register occurs, kernel is supposed to switch the existing 
> > > > entries to "loose" mode so window tracking won't flag packets as 
> > > > invalid, but apparently this isn't enough to handle keepalive case.
> > > 
> > > "loose" (nf_ct_tcp_loose) mode doesn't disable window tracking, it 
> > > enables/disables picking up already established connections. 
> > > 
> > > nf_ct_tcp_be_liberal would disable TCP window checking (but not tracking) 
> > > for non RST packets.
> > 
> > You are right, mixup on my part.
> > 
> > > But both seems to be modified only via the proc entries.
> > 
> > Yes, we iterate table on re-register and modify the existing entries.
> 
> For iptables-nft, it might be possible to avoid this deregister +
> register ct hooks in the same transaction: Maybe add something like
> nf_ct_netns_get_all() to bump refcounters by one _iff_ they are > 0
> before starting the transaction processing, then call
> nf_ct_netns_put_all() which decrements refcounters and unregister
> hooks if they reach 0.

Hm, scratch that, put_all() would create an imbalance with this
conditional increment.

> The only problem with this approach is that this pulls in the
> conntrack module, to solve that, struct nf_ct_hook in
> net/netfilter/core.c could be used to store the reference to
> ->netns_get_all and ->net_put_all.
> 
> Legacy would still be flawed though.
