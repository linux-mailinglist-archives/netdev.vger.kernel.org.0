Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8888B217977
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgGGUez convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jul 2020 16:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728335AbgGGUez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:34:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71162C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:34:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBEC6120F93E0;
        Tue,  7 Jul 2020 13:34:53 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:34:52 -0700 (PDT)
Message-Id: <20200707.133452.1011109347469465282.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, cam@neo-zeon.de, pgwipeout@gmail.com,
        lufq.fnst@cn.fujitsu.com, dsonck92@gmail.com,
        qiang.zhang@windriver.com, t.lamprecht@proxmox.com,
        daniel@iogearbox.net, lizefan@huawei.com, tj@kernel.org,
        guro@fb.com
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for
 sk_clone_lock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:34:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu,  2 Jul 2020 11:52:56 -0700

> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> copied, so the cgroup refcnt must be taken too. And, unlike the
> sk_alloc() path, sock_update_netprioidx() is not called here.
> Therefore, it is safe and necessary to grab the cgroup refcnt
> even when cgroup_sk_alloc is disabled.
> 
> sk_clone_lock() is in BH context anyway, the in_interrupt()
> would terminate this function if called there. And for sk_alloc()
> skcd->val is always zero. So it's safe to factor out the code
> to make it more readable.
> 
> The global variable 'cgroup_sk_alloc_disabled' is used to determine
> whether to take these reference counts. It is impossible to make
> the reference counting correct unless we save this bit of information
> in skcd->val. So, add a new bit there to record whether the socket
> has already taken the reference counts. This obviously relies on
> kmalloc() to align cgroup pointers to at least 4 bytes,
> ARCH_KMALLOC_MINALIGN is certainly larger than that.
> 
> This bug seems to be introduced since the beginning, commit
> d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> tried to fix it but not compeletely. It seems not easy to trigger until
> the recent commit 090e28b229af
> ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.
> 
> Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
> Reported-by: Peter Geis <pgwipeout@gmail.com>
> Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Reported-by: Daniël Sonck <dsonck92@gmail.com>
> Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
> Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
> Tested-by: Peter Geis <pgwipeout@gmail.com>
> Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Zefan Li <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks!
