Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66691CC65A
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 06:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgEJECR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 00:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgEJECR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 00:02:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FA020801;
        Sun, 10 May 2020 04:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589083336;
        bh=iIlip5Pvd+/nd22NeY8yhi15wbomwAP7PKDtjMfhDj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jt/Lu4MpG2XiLOF+j8YPcqZ4sHVm+vw975QlQVLhxR2U4bY7oXARENrwmZCyuzPr6
         zFdhJhlfElJeK4kEP4G3Teypdvui3NPeLMLlqE26xrQjZ5nexhMPbWUN0Tiu7bxTvM
         xGyXC1XUZ7RA2Bc3pdE+POWvblB2W29X4MnUmmXc=
Date:   Sat, 9 May 2020 21:02:14 -0700
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
Message-ID: <20200509210214.408e847a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
        <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
        <20200508225829.0880cf8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 22:58:29 -0700 Jakub Kicinski wrote:
> On Sat, 9 May 2020 11:32:10 +0800 Zefan Li wrote:
> > If systemd is configured to use hybrid mode which enables the use of
> > both cgroup v1 and v2, systemd will create new cgroup on both the default
> > root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
> > task to the two cgroups. If the task does some network thing then the v2
> > cgroup can never be freed after the session exited.
> > 
> > One of our machines ran into OOM due to this memory leak.
> > 
> > In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
> > thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
> > and increments the cgroup refcnt, but then sock_update_netprioidx() thought
> > it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
> > cgroup refcnt will never be freed.
> > 
> > Currently we do the mode switch when someone writes to the ifpriomap cgroup
> > control file. The easiest fix is to also do the switch when a task is attached
> > to a new cgroup.
> > 
> > Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")  
> 
>                      ^ space missing here
> 
> > Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> > Tested-by: Yang Yingliang <yangyingliang@huawei.com>
> > Signed-off-by: Zefan Li <lizefan@huawei.com>

Fixed up the commit message and applied, thank you.
