Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845962AFD5A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgKLBbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgKKWt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:49:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3526120679;
        Wed, 11 Nov 2020 22:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605134997;
        bh=GsA+4wgtfMwtneyzD+NwV724aS0h4OluJ/jzxrmT9SA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v9aMfMpRGazvep19rwa8B4OnmWsXgSPGEm/2E6x05twYIUXJRi0EdMytxYSxeKt3e
         UVj3+5wWJVmiqnwqaMnkIl6N4RB3eoQYKT6Ujcz7l3ctK7D2pQ+KQVwyOHboltyMKv
         Ue7/G/7GY977LynNExUUFsxUuI0Egaa4f6AZB7Yo=
Date:   Wed, 11 Nov 2020 14:49:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <tipc-discussion@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] tipc: fix memory leak in tipc_topsrv_start()
Message-ID: <20201111144956.33f6ca58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109140913.47370-1-wanghai38@huawei.com>
References: <20201109140913.47370-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 22:09:13 +0800 Wang Hai wrote:
> kmemleak report a memory leak as follows:
> 
> unreferenced object 0xffff88810a596800 (size 512):
>   comm "ip", pid 21558, jiffies 4297568990 (age 112.120s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 00 83 60 b0 ff ff ff ff  ..........`.....
>   backtrace:
>     [<0000000022bbe21f>] tipc_topsrv_init_net+0x1f3/0xa70
>     [<00000000fe15ddf7>] ops_init+0xa8/0x3c0
>     [<00000000138af6f2>] setup_net+0x2de/0x7e0
>     [<000000008c6807a3>] copy_net_ns+0x27d/0x530
>     [<000000006b21adbd>] create_new_namespaces+0x382/0xa30
>     [<00000000bb169746>] unshare_nsproxy_namespaces+0xa1/0x1d0
>     [<00000000fe2e42bc>] ksys_unshare+0x39c/0x780
>     [<0000000009ba3b19>] __x64_sys_unshare+0x2d/0x40
>     [<00000000614ad866>] do_syscall_64+0x56/0xa0
>     [<00000000a1b5ca3c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 'srv' is malloced in tipc_topsrv_start() but not free before
> leaving from the error handling cases. We need to free it.
> 
> Fixes: 5c45ab24ac77 ("tipc: make struct tipc_server private for server.c")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied, thanks.
