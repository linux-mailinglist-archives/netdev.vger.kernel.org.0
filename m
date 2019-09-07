Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E09AC756
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436488AbfIGPsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:48:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391796AbfIGPsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:48:04 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03A5F152F1AD7;
        Sat,  7 Sep 2019 08:48:02 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:47:59 +0200 (CEST)
Message-Id: <20190907.174759.20721812747267246.davem@davemloft.net>
To:     ebiggers@kernel.org
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net v2] isdn/capi: check message length in capi_write()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906023637.768-1-ebiggers@kernel.org>
References: <20190901.114406.528788701327829265.davem@davemloft.net>
        <20190906023637.768-1-ebiggers@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:48:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Thu,  5 Sep 2019 19:36:37 -0700

> From: Eric Biggers <ebiggers@google.com>
> 
> syzbot reported:
> 
>     BUG: KMSAN: uninit-value in capi_write+0x791/0xa90 drivers/isdn/capi/capi.c:700
>     CPU: 0 PID: 10025 Comm: syz-executor379 Not tainted 4.20.0-rc7+ #2
>     Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>     Call Trace:
>       __dump_stack lib/dump_stack.c:77 [inline]
>       dump_stack+0x173/0x1d0 lib/dump_stack.c:113
>       kmsan_report+0x12e/0x2a0 mm/kmsan/kmsan.c:613
>       __msan_warning+0x82/0xf0 mm/kmsan/kmsan_instr.c:313
>       capi_write+0x791/0xa90 drivers/isdn/capi/capi.c:700
>       do_loop_readv_writev fs/read_write.c:703 [inline]
>       do_iter_write+0x83e/0xd80 fs/read_write.c:961
>       vfs_writev fs/read_write.c:1004 [inline]
>       do_writev+0x397/0x840 fs/read_write.c:1039
>       __do_sys_writev fs/read_write.c:1112 [inline]
>       __se_sys_writev+0x9b/0xb0 fs/read_write.c:1109
>       __x64_sys_writev+0x4a/0x70 fs/read_write.c:1109
>       do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
>       entry_SYSCALL_64_after_hwframe+0x63/0xe7
>     [...]
> 
> The problem is that capi_write() is reading past the end of the message.
> Fix it by checking the message's length in the needed places.
> 
> Reported-and-tested-by: syzbot+0849c524d9c634f5ae66@syzkaller.appspotmail.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied and queued up for -stable.
