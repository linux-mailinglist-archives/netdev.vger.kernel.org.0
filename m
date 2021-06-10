Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A36D3A3279
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhFJRxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhFJRxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 13:53:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 626B0613CA;
        Thu, 10 Jun 2021 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623347473;
        bh=lCGJRHFmgyGy14hX7d0GCF2ozflAS/+GEcyyj0awbxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UcqnFRY0InkyUs9iHJsHROBDaSWwxKwEd0n2YZ577/dS6RTqcloWIirdpUiXfDNRs
         iACitaJqN+aIg85zx4+RRcytoXb4rkvIf5gKGVvYs1PWjdaeYFuGZIKjaUBjFOyKTU
         39839+Bg3u/aBcWokJgdeuwNe7DxBtSIvI45wzCMt8T03uZe5AmCSOSxJpHBjDHRDq
         ZVMAfULEhDzbPQunKERzicvvjZFjeK5jnbmEkXZVwI0KUUEFkX2YZQznd/O0sjGIdu
         pqCyYzL8pd2pkI6S1aPix9eTpbiYJcA68QP3hboGewE1K73CdJcCMMmrh9/bHqCeuS
         OH19NSWVlmc/Q==
Date:   Thu, 10 Jun 2021 10:51:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3] net: make get_net_ns return error if NET_NS is
 disabled
Message-ID: <20210610105112.787a0d5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210610153941.118945-1-changbin.du@gmail.com>
References: <20210610153941.118945-1-changbin.du@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 23:39:41 +0800 Changbin Du wrote:
> There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
> The reason is that nsfs tries to access ns->ops but the proc_ns_operations
> is not implemented in this case.
> 
> [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> [7.670268] pgd = 32b54000
> [7.670544] [00000010] *pgd=00000000
> [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> [7.672315] Modules linked in:
> [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> [7.673309] Hardware name: Generic DT based system
> [7.673642] PC is at nsfs_evict+0x24/0x30
> [7.674486] LR is at clear_inode+0x20/0x9c
> 
> The same to tun SIOCGSKNS command.
> 
> To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
> disabled. Meanwhile move it to right place net/core/net_namespace.c.

I'm assuming you went from EOPNOTSUPP to EINVAL to follow what the
existing helpers in the header do?

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
