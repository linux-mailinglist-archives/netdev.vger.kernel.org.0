Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DEB2C6399
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgK0LJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 06:09:46 -0500
Received: from correo.us.es ([193.147.175.20]:54804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgK0LJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 06:09:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11D47191918
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 12:09:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02711DA85E
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 12:09:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EB356DA840; Fri, 27 Nov 2020 12:09:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D100DA84F;
        Fri, 27 Nov 2020 12:09:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Nov 2020 12:09:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D97142EF42C;
        Fri, 27 Nov 2020 12:09:41 +0100 (CET)
Date:   Fri, 27 Nov 2020 12:09:41 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Wang Hai <wanghai38@huawei.com>, horms@verge.net.au,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, christian@brauner.io,
        hans.schillstrom@ericsson.com, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] ipvs: fix possible memory leak in
 ip_vs_control_net_init
Message-ID: <20201127110941.GA11008@salvia>
References: <20201124080749.69160-1-wanghai38@huawei.com>
 <3164a9e0-962a-c54-129e-9ad780c454c8@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3164a9e0-962a-c54-129e-9ad780c454c8@ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 08:09:19PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 24 Nov 2020, Wang Hai wrote:
> 
> > kmemleak report a memory leak as follows:
> > 
> > BUG: memory leak
> > unreferenced object 0xffff8880759ea000 (size 256):
> > backtrace:
> > [<00000000c0bf2deb>] kmem_cache_zalloc include/linux/slab.h:656 [inline]
> > [<00000000c0bf2deb>] __proc_create+0x23d/0x7d0 fs/proc/generic.c:421
> > [<000000009d718d02>] proc_create_reg+0x8e/0x140 fs/proc/generic.c:535
> > [<0000000097bbfc4f>] proc_create_net_data+0x8c/0x1b0 fs/proc/proc_net.c:126
> > [<00000000652480fc>] ip_vs_control_net_init+0x308/0x13a0 net/netfilter/ipvs/ip_vs_ctl.c:4169
> > [<000000004c927ebe>] __ip_vs_init+0x211/0x400 net/netfilter/ipvs/ip_vs_core.c:2429
> > [<00000000aa6b72d9>] ops_init+0xa8/0x3c0 net/core/net_namespace.c:151
> > [<00000000153fd114>] setup_net+0x2de/0x7e0 net/core/net_namespace.c:341
> > [<00000000be4e4f07>] copy_net_ns+0x27d/0x530 net/core/net_namespace.c:482
> > [<00000000f1c23ec9>] create_new_namespaces+0x382/0xa30 kernel/nsproxy.c:110
> > [<00000000098a5757>] copy_namespaces+0x2e6/0x3b0 kernel/nsproxy.c:179
> > [<0000000026ce39e9>] copy_process+0x220a/0x5f00 kernel/fork.c:2072
> > [<00000000b71f4efe>] _do_fork+0xc7/0xda0 kernel/fork.c:2428
> > [<000000002974ee96>] __do_sys_clone3+0x18a/0x280 kernel/fork.c:2703
> > [<0000000062ac0a4d>] do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
> > [<0000000093f1ce2c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > In the error path of ip_vs_control_net_init(), remove_proc_entry() needs
> > to be called to remove the added proc entry, otherwise a memory leak
> > will occur.
> > 
> > Also, add some '#ifdef CONFIG_PROC_FS' because proc_create_net* return NULL
> > when PROC is not used.
> > 
> > Fixes: b17fc9963f83 ("IPVS: netns, ip_vs_stats and its procfs")
> > Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Applied, thanks.
