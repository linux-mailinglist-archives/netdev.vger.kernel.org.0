Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8328B1CBDFA
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgEIF6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgEIF6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:58:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF66D21582;
        Sat,  9 May 2020 05:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003911;
        bh=vEVp4ZM8+5FOQMgtlwLDv2fPcu5BE4CM5MCDTzrtfE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lBypPstpmdRtZHZEmvO6U1DLXwxBnjwFnjd4K4VnMet519UGRGbyTkkDgSOs8HLy+
         A4CUz00w4gbYZvhcn5BzKZ4JZlO2aaOfl992Om+t5SF/kHDeTmh7NfM7nuK/VVtVWW
         YszoJzmGpLH39Ba6TbzBaTvLPTvkZN4a7ArAqW9w=
Date:   Fri, 8 May 2020 22:58:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zefan Li <lizefan@huawei.com>
Cc:     Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>,
        yangyingliang <yangyingliang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        <huawei.libin@huawei.com>, <guofan5@huawei.com>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
Message-ID: <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
        <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 11:32:10 +0800 Zefan Li wrote:
> If systemd is configured to use hybrid mode which enables the use of
> both cgroup v1 and v2, systemd will create new cgroup on both the default
> root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
> task to the two cgroups. If the task does some network thing then the v2
> cgroup can never be freed after the session exited.
> 
> One of our machines ran into OOM due to this memory leak.
> 
> In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
> thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
> and increments the cgroup refcnt, but then sock_update_netprioidx() thought
> it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
> cgroup refcnt will never be freed.
> 
> Currently we do the mode switch when someone writes to the ifpriomap cgroup
> control file. The easiest fix is to also do the switch when a task is attached
> to a new cgroup.
> 
> Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")

                     ^ space missing here

> Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> Tested-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
> 
> forgot to rebase to the latest kernel.
> 
> ---
>  net/core/netprio_cgroup.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 8881dd9..9bd4cab 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -236,6 +236,8 @@ static void net_prio_attach(struct cgroup_taskset *tset)
>  	struct task_struct *p;
>  	struct cgroup_subsys_state *css;
>  
> +	cgroup_sk_alloc_disable();
> +
>  	cgroup_taskset_for_each(p, css, tset) {
>  		void *v = (void *)(unsigned long)css->id;
>  

