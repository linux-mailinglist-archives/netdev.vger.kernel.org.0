Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0312E2A9A16
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKFQ7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgKFQ7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:59:30 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A187217A0;
        Fri,  6 Nov 2020 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604681970;
        bh=slj61GUBXi1bmb+n2Tw/4ksqQEdpNsvLndzv+XEqmOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I5VYcOXmeeuYNGxRWDNI/oSEL1zxJ70cCYO5It0wHAwi5ORjFPMIMIaY+Y1g0XfX3
         BhPzWjuZpcz1w/NOoWtSXZdaUDt541An4cALCCVrlrmBbCHOHAZg5AsLH6ycVTmKeD
         XKH1gtiZhnxtz8o5u/XxaUUNUSHDt0qxL9DQ3xeA=
Date:   Fri, 6 Nov 2020 08:59:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net 1/2] net/af_iucv: fix null pointer dereference on
 shutdown
Message-ID: <20201106085928.183e0c77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106125008.36478-2-jwi@linux.ibm.com>
References: <20201106125008.36478-1-jwi@linux.ibm.com>
        <20201106125008.36478-2-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 13:50:07 +0100 Julian Wiedmann wrote:
> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> syzbot reported the following KASAN finding:
> 
> BUG: KASAN: nullptr-dereference in iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
> Read of size 2 at addr 000000000000021e by task syz-executor907/519
> 
> CPU: 0 PID: 519 Comm: syz-executor907 Not tainted 5.9.0-syzkaller-07043-gbcf9877ad213 #0
> Hardware name: IBM 3906 M04 701 (KVM/Linux)
> Call Trace:
>  [<00000000c576af60>] unwind_start arch/s390/include/asm/unwind.h:65 [inline]
>  [<00000000c576af60>] show_stack+0x180/0x228 arch/s390/kernel/dumpstack.c:135
>  [<00000000c9dcd1f8>] __dump_stack lib/dump_stack.c:77 [inline]
>  [<00000000c9dcd1f8>] dump_stack+0x268/0x2f0 lib/dump_stack.c:118
>  [<00000000c5fed016>] print_address_description.constprop.0+0x5e/0x218 mm/kasan/report.c:383
>  [<00000000c5fec82a>] __kasan_report mm/kasan/report.c:517 [inline]
>  [<00000000c5fec82a>] kasan_report+0x11a/0x168 mm/kasan/report.c:534
>  [<00000000c98b5b60>] iucv_send_ctrl+0x390/0x3f0 net/iucv/af_iucv.c:385
>  [<00000000c98b6262>] iucv_sock_shutdown+0x44a/0x4c0 net/iucv/af_iucv.c:1457
>  [<00000000c89d3a54>] __sys_shutdown+0x12c/0x1c8 net/socket.c:2204
>  [<00000000c89d3b70>] __do_sys_shutdown net/socket.c:2212 [inline]
>  [<00000000c89d3b70>] __s390x_sys_shutdown+0x38/0x48 net/socket.c:2210
>  [<00000000c9e36eac>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415
> 
> There is nothing to shutdown if a connection has never been established.
> Besides that iucv->hs_dev is not yet initialized if a socket is in
> IUCV_OPEN state and iucv->path is not yet initialized if socket is in
> IUCV_BOUND state.
> So, just skip the shutdown calls for a socket in these states.
> 
> Fixes: eac3731bd04c ("s390: Add AF_IUCV socket support")
> Fixes: 82492a355fac ("af_iucv: add shutdown for HS transport")
> Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Fixes tag: Fixes: eac3731bd04c ("s390: Add AF_IUCV socket support")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
