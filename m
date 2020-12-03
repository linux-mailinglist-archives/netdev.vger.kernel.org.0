Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6632CE182
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgLCWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:21:25 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:33924
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgLCWVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 17:21:25 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkwxv-0001ew-CD
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 23:20:43 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Thu, 3 Dec 2020 22:20:38 -0000 (UTC)
Message-ID: <rqbobm$5qk$1@ciao.gmane.io>
References: <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io> <20201203040758.GC2333853@lunn.ch>
 <rqav0e$4m3$1@ciao.gmane.io> <20201203211702.GK2333853@lunn.ch>
 <rqbluj$l72$1@ciao.gmane.io> <20201203214941.GA2409950@lunn.ch>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03, Andrew Lunn <andrew@lunn.ch> wrote:
>> I don't think there's any way I could justify using a kernel that
>> doesn't have long-term support.
>
> 5.10 is LTS. Well, it will be, once it is actually released!

Convincing people to ship an unreleased kernel would be a whole
'nother bucket of worms.

It's all moot now. The decision was just made to shelve the 5.4 kernel
"upgrade" and stick with 2.6.33 for now.

>> [It looks like we're going to have to abandon the effort to use
>> 5.4. The performance is so bad compared to 2.6.33.7 that our product
>> just plain won't work. We've already had remove features to the get
>> 5.4 kernel down to a usable size, but we were prepared to live with
>> that.]
>
> Ah. Small caches?

Yep. It's An old Atmel ARM926T part (at91sam9g20) with 32KB I-cache
and 32KB D-cache.

A simple user-space multi-threaded TCP echo server benchmark showed a
30-50% (depending on number of parallel connections) drop in max
throughput. Our typical applications also show a 15-25% increase in
CPU usage for an equivalent workload.  Another problem is high
latencies with 5.4. A thread that is supposed to wake up every 1ms
works reliably on 2.6.33, but is a long ways from working on 5.4.

I asked on the arm kernel mailing list if this was typical/expected,
but the post never made it past the moderator.

> The OpenWRT guys make valid complaints that the code
> hot path of the network stack is getting too big to fit in the cache
> of small systems. So there is a lot of cache misses and performance is
> not good. If i remember correctly, just having netfilter in the build
> is bad, even if it is not used.

We've already disabled absoltely everything we can and still have a
working system. With the same features enabled, the 5.4 kernel was
about 75% larger than a 2.6.33 kernel, so we had to trim quite a bit
of meat to get it to boot on existing units.

We also can't get on-die ECC support for Micron NAND flash working
with 5.4. Even it did work, we'd still have to add the ability to
fall-back to SW ECC on read operations for the sake of backwards
compatibility on units that were initially shipped without on-die ECC
support enabled.

--
Grant

