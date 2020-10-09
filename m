Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C659E288786
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 13:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387901AbgJILDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 07:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732761AbgJILDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 07:03:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BC9C0613D2;
        Fri,  9 Oct 2020 04:03:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kQqBH-0006lw-QK; Fri, 09 Oct 2020 13:03:23 +0200
Date:   Fri, 9 Oct 2020 13:03:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, fw@strlen.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201009110323.GC5723@breakpoint.cc>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > Any comments?
> > Here is a simple reproducer. The idea is to show that keepalive packets 
> > in an idle tcp connection will be dropped (and the connection will time 
> > out) if conntrack hooks are de-registered and then re-registered. The 
> > reproducer has two files. client_server.py creates both ends of a tcp 
> > connection, bounces a few packets back and forth, and then blocks on a 
> > recv on the client side. The client's keepalive is configured to time 
> > out in 20 seconds. This connection should not time out. test is a bash 
> > script that creates a net namespace where it sets iptables rules for the 
> > connection, starts client_server.py, and then clears and restores the 
> > iptables rules (which causes conntrack hooks to be de-registered and 
> > re-registered).
> 
> In my opinion an iptables restore should not cause conntrack hooks to be 
> de-registered and re-registered, because important TCP initialization 
> parameters cannot be "restored" later from the packets. Therefore the 
> proper fix would be to prevent it to happen. Otherwise your patch looks OK 
> to handle the case when conntrack is intentionally restarted.

The repro clears all rules, waits 4 seconds, then restores the ruleset.
using iptables-restore < FOO; sleep 4; iptables-restore < FOO will
not result in any unregister ops.

We could make kernel defer unregister via some work queue but i don't
see what this would help/accomplish (and its questionable of how long it
should wait).

We could disallow unregister, but that seems silly (forces reboot...).

I think the patch is fine.
