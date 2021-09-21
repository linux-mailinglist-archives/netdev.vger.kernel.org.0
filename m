Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBDA412ACF
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbhIUB6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39660 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbhIUBxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:53:16 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8EA5863EB5;
        Tue, 21 Sep 2021 03:50:27 +0200 (CEST)
Date:   Tue, 21 Sep 2021 03:51:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf] netfilter: conntrack: serialize hash resizes and
 cleanups
Message-ID: <YUk6rWNxqMi37N7K@salvia>
References: <20210917221556.1162846-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210917221556.1162846-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 03:15:56PM -0700, Eric Dumazet wrote:
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

Applied, thanks.
