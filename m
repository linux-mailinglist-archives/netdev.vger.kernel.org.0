Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57E217A134
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 09:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgCEIZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 03:25:30 -0500
Received: from edrik.securmail.fr ([45.91.125.3]:33153 "EHLO
        edrik.securmail.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEIZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 03:25:30 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 03:25:28 EST
Received: by edrik.securmail.fr (Postfix, from userid 58)
        id 20849B0E66; Thu,  5 Mar 2020 09:18:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583396296;
        bh=ZCoRjkbY/nJFs7Cu4ea12hODt+OY0auh0uf54mkNaXo=;
        h=Date:From:To:Subject;
        b=r3WyDhWZFcOk780+Ivev5U/IoIgM2P395qP//JSbT/vs87B35MQ5OBd/eepJud15j
         e9JfxhjHEMWbTVZ2gRYNyH8qhI0xEEv62obZ4yTKG7vFiBuO9qc2c65DgQqyCPhwcX
         91OvOFpw5o9wECsXSSiW6cE1A4TZ3IdQzHkBLlIg=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on edrik.securmail.fr
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,TRACKER_ID autolearn=no
        autolearn_force=no version=3.4.2
Received: from mew.swordarmor.fr (mew.swordarmor.fr [IPv6:2a00:5884:102:1::4])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id 0F75AB0E50
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 09:17:52 +0100 (CET)
Authentication-Results: edrik.securmail.fr/0F75AB0E50; dmarc=none (p=none dis=none) header.from=swordarmor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583396272;
        bh=ZCoRjkbY/nJFs7Cu4ea12hODt+OY0auh0uf54mkNaXo=;
        h=Date:From:To:Subject;
        b=vXnYdQ5Kgk04ikuBS8k0gA45Av4c+RDKz7tpq/TSkAghqnGmdP2NmBpeh1z2IjcW4
         pa/HS/VrFwMwclGSArR7Oi+uBQBWxddVVxCW9kv8/Ej5aN4SF0K28axh6DPHq1zfb1
         lPD431c26hoFwWrBdNgNcLmzMJkSNMuLHM4neuiw=
Date:   Thu, 5 Mar 2020 09:17:47 +0100
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     netdev@vger.kernel.org
Subject: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On the bird users ML, we discussed a bug we’re facing when having a
full table: from time to time all the IPv6 traffic is dropped (and all
neighbors are invalidated), after a while it comes back again, then wait
a few minutes and it’s dropped again, and so on.

Basil Fillan determined that it comes from the commit
3b6761d18bc11f2af2a6fc494e9026d39593f22c.

Here are the complete archives about it:

https://bird.network.cz/pipermail/bird-users/2019-June/013509.html
https://bird.network.cz/pipermail/bird-users/2019-November/013992.html
https://bird.network.cz/pipermail/bird-users/2019-December/014011.html
https://bird.network.cz/pipermail/bird-users/2020-February/014269.html

Regards,
Alarig Le Lay

----- Forwarded message from Basil Fillan <jack@basilfillan.uk> -----

From: Basil Fillan <jack@basilfillan.uk>
To: bird-users@network.cz
Date: Wed, 26 Feb 2020 22:54:57 +0000
Subject: Re: IPv6 BGP & kernel 4.19
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1

Hi,

We've also experienced this after upgrading a few routers to Debian Buster.
With a kernel bisect we found that a bug was introduced in the following
commit:

3b6761d18bc11f2af2a6fc494e9026d39593f22c

This bug was still present in master as of a few weeks ago.

It appears entries are added to the IPv6 route cache which aren't visible from
"ip -6 route show cache", but are causing the route cache garbage collection
system to trigger extremely often (every packet?) once it exceeds the value of
net.ipv6.route.max_size. Our original symptom was extreme forwarding jitter
caused within the ip6_dst_gc function (identified by some spelunking with
systemtap & perf) worsening as the size of the cache increased. This was due
to our max_size sysctl inadvertently being set to 1 million. Reducing this
value to the default 4096 broke IPv6 forwarding entirely on our test system
under affected kernels. Our documentation had this sysctl marked as the
maximum number of IPv6 routes, so it looks like the use changed at some point.

We've rolled our routers back to kernel 4.9 (with the sysctl set to 4096) for
now, which fixed our immediate issue.

You can reproduce this by adding more than 4096 (default value of the sysctl)
routes to the kernel and running "ip route get" for each of them. Once the
route cache is filled, the error "RTNETLINK answers: Network is unreachable"
will be received for each subsequent "ip route get" incantation, and v6
connectivity will be interrupted.

Thanks,

Basil


On 26/02/2020 20:38, Clément Guivy wrote:
> Hi, did anyone find a solution or workaround regarding this issue?
> Considering a router use case.
> I have looked at rt6_stats, total route count is around 78k (full view),
> and around 4100 entries in the cache at the moment on my first router
> (forwarding a few Mb/s) and around 2500 entries on my second router
> (forwarding less than 1 Mb/s).
> I have reread the entire thread. At first, Alarig's research seemed to
> lead to a neighbor management problem, my understanding is that route
> cache is something else entirely - or is it related somehow?
> 
> 
> On 03/12/2019 19:29, Alarig Le Lay wrote:
> > We agree then, and I act as a router on all those machines.
> > 
> > Le 3 décembre 2019 19:27:11 GMT+01:00, Vincent Bernat
> > <vincent@bernat.ch> a écrit :
> > 
> >     This is the result of PMTUd. But when you are a router, you don't
> >     need to do that, so it's mostly a problem for end hosts.
> > 
> >     On December 3, 2019 7:05:49 PM GMT+01:00, Alarig Le Lay
> >     <alarig@swordarmor.fr> wrote:
> > 
> >         On 03/12/2019 14:16, Vincent Bernat wrote:
> > 
> >             The information needs to be stored somewhere.
> > 
> > 
> >         Why has it to be stored? It’s not really my problem if someone
> > else has
> >         a non-stantard MTU and can’t do TCP-MSS or PMTUd.

----- End forwarded message -----
