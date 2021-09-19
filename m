Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB40410ADD
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbhISJVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 05:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhISJVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 05:21:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4B5C061574;
        Sun, 19 Sep 2021 02:20:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mRszS-0001im-7g; Sun, 19 Sep 2021 11:20:02 +0200
Date:   Sun, 19 Sep 2021 11:20:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf] netfilter: conntrack: serialize hash resizes and
 cleanups
Message-ID: <20210919092002.GG15906@breakpoint.cc>
References: <20210917221556.1162846-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917221556.1162846-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Syzbot was able to trigger the following warning [1]
> 
> No repro found by syzbot yet but I was able to trigger similar issue
> by having 2 scripts running in parallel, changing conntrack hash sizes,
> and:
> 
> for j in `seq 1 1000` ; do unshare -n /bin/true >/dev/null ; done
> 
> It would take more than 5 minutes for net_namespace structures
> to be cleaned up.
> 
> This is because nf_ct_iterate_cleanup() has to restart everytime
> a resize happened.
> 
> By adding a mutex, we can serialize hash resizes and cleanups
> and also make get_next_corpse() faster by skipping over empty
> buckets.
> 
> Even without resizes in the picture, this patch considerably
> speeds up network namespace dismantles.

LGTM, thanks Eric.

I have been working on patches to make hash table pernet again,
but they will take a bit more time to finish and are not suited for -net.
