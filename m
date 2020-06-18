Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2005F1FE006
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733120AbgFRBoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:44:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733116AbgFRBom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:44:42 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 157B49A9E19E041506C1;
        Thu, 18 Jun 2020 09:44:39 +0800 (CST)
Received: from [10.166.213.22] (10.166.213.22) by smtp.huawei.com
 (10.3.19.206) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 18 Jun
 2020 09:44:34 +0800
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        "Lu Fengqi" <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
From:   Zefan Li <lizefan@huawei.com>
Message-ID: <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
Date:   Thu, 18 Jun 2020 09:44:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.22]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Roman Gushchin <guro@fb.com>

Thanks for fixing this.

On 2020/6/17 2:03, Cong Wang wrote:
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
> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")

but I don't think the bug was introduced by this commit, because there
are already calls to cgroup_sk_alloc_disable() in write_priomap() and
write_classid(), which can be triggered by writing to ifpriomap or
classid in cgroupfs. This commit just made it much easier to happen
with systemd invovled.

I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
which added cgroup_bpf_get() in cgroup_sk_alloc().

> Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
> Reported-by: Peter Geis <pgwipeout@gmail.com>
> Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Reported-by: Daniël Sonck <dsonck92@gmail.com>
> Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Zefan Li <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

