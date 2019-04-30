Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7800F004
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfD3Ffa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:35:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:47030 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbfD3Ff3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:35:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8CC0620257;
        Tue, 30 Apr 2019 07:35:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id u-yucW2QBsC7; Tue, 30 Apr 2019 07:35:27 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 07EB7201E1;
        Tue, 30 Apr 2019 07:35:27 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:35:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8A2DD3180584;
 Tue, 30 Apr 2019 07:35:26 +0200 (CEST)
Date:   Tue, 30 Apr 2019 07:35:26 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] vti4: Fix error path in vti_init and vti_fini
Message-ID: <20190430053526.GG17989@gauss3.secunet.de>
References: <20190430033630.27240-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190430033630.27240-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 01763916-A510-404D-987A-D154CA99A683
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 11:36:30AM +0800, YueHaibing wrote:
> KASAN report this:
> 
> BUG: unable to handle kernel paging request at fffffbfff8280cc7
> PGD 237fe4067 P4D 237fe4067 PUD 237e60067 PMD 1ebfd0067 PTE 0
> Oops: 0000 [#1] SMP KASAN PTI
> CPU: 0 PID: 8156 Comm: syz-executor.0 Tainted: G         C        5.1.0-rc3+ #8
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> RIP: 0010:xfrm4_tunnel_register+0xb3/0x1f0 [tunnel4]
> Code: e8 03 42 80 3c 28 00 0f 85 25 01 00 00 48 8b 5d 00 48 85 db 0f 84 a8 00 00 00 e8 08 cd b3 f3 48 8d 7b 18 48 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 74 08 3c 03 0f 8e 04 01 00 00 44 8b 63 18 45
> RSP: 0018:ffff8881b65bf9a0 EFLAGS: 00010a02
> RAX: 1ffffffff8280cc7 RBX: ffffffffc1406620 RCX: ffffffff8d8880a8
> RDX: 0000000000031712 RSI: ffffc900014bf000 RDI: ffffffffc1406638
> RBP: ffffffffc108a4a0 R08: fffffbfff8211401 R09: fffffbfff8211401
> R10: ffff8881b65bf9a0 R11: fffffbfff8211400 R12: ffffffffc1c08000
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffffffc1bfe620
> FS:  00007f5f07be3700(0000) GS:ffff8881f7200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffbfff8280cc7 CR3: 00000001e8d00004 CR4: 00000000007606f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  ? 0xffffffffc1c08000
>  vti_init+0x9d/0x1000 [ip_vti]
>  do_one_initcall+0xbc/0x47d init/main.c:901
>  do_init_module+0x1b5/0x547 kernel/module.c:3456
>  load_module+0x6405/0x8c10 kernel/module.c:3804
>  __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
>  do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> commit dd9ee3444014 ("vti4: Fix a ipip packet processing bug
> in 'IPCOMP' virtual tunnel") misplace xfrm4_tunnel_deregister in
> vti_init and forgot to add cleanup in vti_fini.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: dd9ee3444014 ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

This is already fixed in the ipsec tree by commit
5483844c3fc1 ("vti4: ipip tunnel deregistration fixes.")

Thanks anyway!
