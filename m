Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC9A289168
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbgJISst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:48:49 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:48583 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733157AbgJISss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 14:48:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id EE0A8CC011F;
        Fri,  9 Oct 2020 20:48:46 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  9 Oct 2020 20:48:44 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8F01ECC011B;
        Fri,  9 Oct 2020 20:48:42 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3BE9E340D60; Fri,  9 Oct 2020 20:48:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 37C65340D5C;
        Fri,  9 Oct 2020 20:48:42 +0200 (CEST)
Date:   Fri, 9 Oct 2020 20:48:42 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Florian Westphal <fw@strlen.de>
cc:     Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, fw@strlen.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
In-Reply-To: <20201009110323.GC5723@breakpoint.cc>
Message-ID: <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com> <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com> <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu> <20201009110323.GC5723@breakpoint.cc>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 9 Oct 2020, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > The reproducer has two files. client_server.py creates both ends of 
> > > a tcp connection, bounces a few packets back and forth, and then 
> > > blocks on a recv on the client side. The client's keepalive is 
> > > configured to time out in 20 seconds. This connection should not 
> > > time out. test is a bash script that creates a net namespace where 
> > > it sets iptables rules for the connection, starts client_server.py, 
> > > and then clears and restores the iptables rules (which causes 
> > > conntrack hooks to be de-registered and re-registered).
> > 
> > In my opinion an iptables restore should not cause conntrack hooks to be 
> > de-registered and re-registered, because important TCP initialization 
> > parameters cannot be "restored" later from the packets. Therefore the 
> > proper fix would be to prevent it to happen. Otherwise your patch looks OK 
> > to handle the case when conntrack is intentionally restarted.
> 
> The repro clears all rules, waits 4 seconds, then restores the ruleset. 
> using iptables-restore < FOO; sleep 4; iptables-restore < FOO will not 
> result in any unregister ops.
>
> We could make kernel defer unregister via some work queue but i don't
> see what this would help/accomplish (and its questionable of how long it
> should wait).

Sorry, I can't put together the two paragraphs above: in the first you 
wrote that no (hook) unregister-register happens and in the second one 
that those could be derefed.

> We could disallow unregister, but that seems silly (forces reboot...).
> 
> I think the patch is fine.

The patch is fine, but why the packets are handled by conntrack (after the 
first restore and during the 4s sleep? And then again after the second 
restore?) as if all conntrack entries were removed?
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
