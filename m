Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36881A4B31
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfIASoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 14:44:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbfIASoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 14:44:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9495715166549;
        Sun,  1 Sep 2019 11:44:06 -0700 (PDT)
Date:   Sun, 01 Sep 2019 11:44:06 -0700 (PDT)
Message-Id: <20190901.114406.528788701327829265.davem@davemloft.net>
To:     ebiggers@kernel.org
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] isdn/capi: check message length in capi_write()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190901143239.13828-1-ebiggers@kernel.org>
References: <0000000000000e35f00581a579cd@google.com>
        <20190901143239.13828-1-ebiggers@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Sep 2019 11:44:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Sun,  1 Sep 2019 09:32:39 -0500

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
> ---
>  drivers/isdn/capi/capi.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
> index 3c3ad42f22bf..a016d8c3c410 100644
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -688,6 +688,9 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
>  	if (!cdev->ap.applid)
>  		return -ENODEV;
>  
> +	if (count < CAPIMSG_BASELEN)
> +		return -EINVAL;
> +
>  	skb = alloc_skb(count, GFP_USER);
>  	if (!skb)
>  		return -ENOMEM;

This is fine.

> @@ -698,7 +701,8 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
>  	}
>  	mlen = CAPIMSG_LEN(skb->data);
>  	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
> -		if ((size_t)(mlen + CAPIMSG_DATALEN(skb->data)) != count) {
> +		if (count < 18 ||
 ...
> +		if (count < 12) {

These magic constants, on the other hand, are not.
