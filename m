Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CD2289231
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388464AbgJITtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:49:14 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:55637 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgJITtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:49:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 71FFD3C80102;
        Fri,  9 Oct 2020 21:49:11 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  9 Oct 2020 21:49:04 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 481B13C80101;
        Fri,  9 Oct 2020 21:49:04 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 09601340D60; Fri,  9 Oct 2020 21:49:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 042DF340D5C;
        Fri,  9 Oct 2020 21:49:04 +0200 (CEST)
Date:   Fri, 9 Oct 2020 21:49:03 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Florian Westphal <fw@strlen.de>
cc:     Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
In-Reply-To: <20201009185552.GF5723@breakpoint.cc>
Message-ID: <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com> <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com> <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu> <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu> <20201009185552.GF5723@breakpoint.cc>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020, Florian Westphal wrote:

> Matches/targets that need conntrack increment a refcount. So, when all 
> rules are flushed, refcount goes down to 0 and conntrack is disabled 
> because the hooks get removed..
> 
> Just doing iptables-restore doesn't unregister as long as both the old
> and new rulesets need conntrack.
> 
> The "delay unregister" remark was wrt. the "all rules were deleted"
> case, i.e. add a "grace period" rather than acting right away when
> conntrack use count did hit 0.

Now I understand it, thanks really. The hooks are removed, so conntrack 
cannot "see" the packets and the entries become stale. 

What is the rationale behind "remove the conntrack hooks when there are no 
rule left referring to conntrack"? Performance optimization? But then the 
content of the whole conntrack table could be deleted too... ;-)
 
> Conntrack entries are not removed, only the base hooks get unregistered. 
> This is a problem for tcp window tracking.
> 
> When re-register occurs, kernel is supposed to switch the existing 
> entries to "loose" mode so window tracking won't flag packets as 
> invalid, but apparently this isn't enough to handle keepalive case.

"loose" (nf_ct_tcp_loose) mode doesn't disable window tracking, it 
enables/disables picking up already established connections. 

nf_ct_tcp_be_liberal would disable TCP window checking (but not tracking) 
for non RST packets.

But both seems to be modified only via the proc entries.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
