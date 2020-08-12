Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B6C242FE3
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgHLUIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgHLUIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:08:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EC0C061383;
        Wed, 12 Aug 2020 13:08:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FC721283876D;
        Wed, 12 Aug 2020 12:51:32 -0700 (PDT)
Date:   Wed, 12 Aug 2020 13:08:17 -0700 (PDT)
Message-Id: <20200812.130817.122386282206254332.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     linux-kernel@vger.kernel.org, decui@microsoft.com,
        netdev@vger.kernel.org, stefanha@redhat.com, kuba@kernel.org,
        jhansen@vmware.com
Subject: Re: [PATCH net v2] vsock: fix potential null pointer dereference
 in vsock_poll()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200812125602.96598-1-sgarzare@redhat.com>
References: <20200812125602.96598-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 12:51:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 12 Aug 2020 14:56:02 +0200

> syzbot reported this issue where in the vsock_poll() we find the
> socket state at TCP_ESTABLISHED, but 'transport' is null:
>   general protection fault, probably for non-canonical address 0xdffffc0000000012: 0000 [#1] PREEMPT SMP KASAN
>   KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
>   CPU: 0 PID: 8227 Comm: syz-executor.2 Not tainted 5.8.0-rc7-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:vsock_poll+0x75a/0x8e0 net/vmw_vsock/af_vsock.c:1038
>   Call Trace:
>    sock_poll+0x159/0x460 net/socket.c:1266
>    vfs_poll include/linux/poll.h:90 [inline]
>    do_pollfd fs/select.c:869 [inline]
>    do_poll fs/select.c:917 [inline]
>    do_sys_poll+0x607/0xd40 fs/select.c:1011
>    __do_sys_poll fs/select.c:1069 [inline]
>    __se_sys_poll fs/select.c:1057 [inline]
>    __x64_sys_poll+0x18c/0x440 fs/select.c:1057
>    do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This issue can happen if the TCP_ESTABLISHED state is set after we read
> the vsk->transport in the vsock_poll().
> 
> We could put barriers to synchronize, but this can only happen during
> connection setup, so we can simply check that 'transport' is valid.
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-and-tested-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied and queued up for -stable, thank you.
