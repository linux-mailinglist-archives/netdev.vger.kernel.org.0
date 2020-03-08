Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3EC17D393
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 12:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCHLFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 07:05:17 -0400
Received: from edrik.securmail.fr ([45.91.125.3]:31671 "EHLO
        edrik.securmail.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCHLFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 07:05:16 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Mar 2020 07:05:16 EDT
Received: by edrik.securmail.fr (Postfix, from userid 58)
        id 4DB8EB0E6E; Sun,  8 Mar 2020 11:58:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583665105;
        bh=lbRvxeTm9MsNfoD1aEkwWZ8Yj6RXq18nNGVupPf9GBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=i9ftrOkrSym0njVyecsQTFhBNxFoEswP3wPTWSDVZulN+JqB8YQL7ibbxx/U6vEe9
         R8rbiHpVopAEaEVzWbaWePTAzE6qjDzkcALB99z17cCivsW3KZbQPf/36TMUF/CTL+
         +XYb9y30+/uWJDa1KcGxFRXXcgUCeE3xVGyj/5WQ=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on edrik.securmail.fr
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU autolearn=unavailable
        autolearn_force=no version=3.4.2
Received: from mew.swordarmor.fr (mew.swordarmor.fr [IPv6:2a00:5884:102:1::4])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id CA039B0E50;
        Sun,  8 Mar 2020 11:57:50 +0100 (CET)
Authentication-Results: edrik.securmail.fr/CA039B0E50; dmarc=none (p=none dis=none) header.from=swordarmor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1583665071;
        bh=lbRvxeTm9MsNfoD1aEkwWZ8Yj6RXq18nNGVupPf9GBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=HWmJztSDCYcunfVcuW/CmXNYG+r4++307sd+c0YOrNftq3oN7WIE60OPZVqm3TvGI
         MyyNdcsMVFM9JMR6cbdpt7bTZXoGbC7If9jr2dPId6eDynG6Qn/wVaI8lhPLb6WOIW
         QXpWbUFZY6SEVcFhxOVCuFLfNGxuD7e/WB3Q4A4I=
Date:   Sun, 8 Mar 2020 11:57:42 +0100
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, jack@basilfillan.uk,
        Vincent Bernat <bernat@debian.org>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On sam.  7 mars 17:52:10 2020, David Ahern wrote:
> On 3/5/20 1:17 AM, Alarig Le Lay wrote:
> Kernel version?

I’ve seen this from 4.19 on my experience, it works at least until 4.15.

> you are monitoring neighbor states with 'ip monitor' or something else?

Yes, 'ip -ts monitor neigh' to be exact.

> The above does not reproduce for me on 5.6 or 4.19, and I would have
> been really surprised if it had, so I have to question the git bisect
> result.

My personal experience is that, while routing is activated (and having a
full-view, I don’t have any soft router without it), the neighbors are
flapping, thus causing a blackhole.
It doesn’t happen with a limit traffic processing. The limit is around
20 Mbps from what I can see.

> There is no limit on fib entries, and the number of FIB entries has no
> impact on the sysctl in question, net.ipv6.route.max_size. That sysctl
> limits the number of dst_entry instances. When the threshold is exceeded
> (and the gc_thesh for ipv6 defaults to 1024), each new alloc attempts to
> free one via gc. There are many legitimate reasons for why 4k entries
> have been created - mtu exceptions, redirects, per-cpu caching, vrfs, ...

I also tried to find a sysctl to ignore the MTU exceptions, as a router
it’s not my problem at all: if the packet is fragmentable, I will do it,
otherwise I will drop it. The MTU negotiation is on the duty of the ends.
I’m not taking the MSS clamping in account as it’s done with iptables
and the mangle table is empty (but CONFIG_IP_NF_MANGLE is enabled).

> In 4.9 FIB entries are created as an rt6_info which is a v6 wrapper
> around dst_entry. That changed in 4.15 or 4.16 - I forget which now, and
> the commit you reference above is part of the refactoring to make IPv6
> more like IPv4 with a different, smaller data structure for fib entries.
> A lot of other changes have also gone into IPv6 between 4.9 and top of
> tree, and at this point the whole gc thing can probably go away for v6
> like it was removed for ipv4.

As it works on 4.15 (the kernel shipped with proxomox 5), I would say
that it has been introduced in 4.16. But I didn’t checked each version
myself.

> Try the 5.4 LTS and see if you still hit a problem.

I have the problem with 5.3 (proxmox 6), so unless FIB handling has been
changed since then, I doubt that it will works, but I will try on
Monday.

Regards,
-- 
Alarig
