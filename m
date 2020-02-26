Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57C3170877
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 20:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBZTHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 14:07:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgBZTHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 14:07:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5044515AA1098;
        Wed, 26 Feb 2020 11:07:52 -0800 (PST)
Date:   Wed, 26 Feb 2020 11:07:49 -0800 (PST)
Message-Id: <20200226.110749.77396284962321904.davem@davemloft.net>
To:     shakeelb@google.com
Cc:     edumazet@google.com, guro@fb.com, hannes@cmpxchg.org,
        tj@kernel.org, gthelen@google.com, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221014604.126118-1-shakeelb@google.com>
References: <20200221014604.126118-1-shakeelb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 11:07:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Date: Thu, 20 Feb 2020 17:46:04 -0800

> We are testing network memory accounting in our setup and noticed
> inconsistent network memory usage and often unrelated cgroups network
> usage correlates with testing workload. On further inspection, it
> seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
> IRQ context specially for cgroup v1.
> 
> mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in IRQ context
> and kind of assumes that this can only happen from sk_clone_lock()
> and the source sock object has already associated cgroup. However in
> cgroup v1, where network memory accounting is opt-in, the source sock
> can be unassociated with any cgroup and the new cloned sock can get
> associated with unrelated interrupted cgroup.
> 
> Cgroup v2 can also suffer if the source sock object was created by
> process in the root cgroup or if sk_alloc() is called in IRQ context.
> The fix is to just do nothing in interrupt.
> 
> WARNING: Please note that about half of the TCP sockets are allocated
> from the IRQ context, so, memory used by such sockets will not be
> accouted by the memcg.

Then if we do this then we have to have some kind of subsequent change
to attach these sockets to the correct cgroup, right?
