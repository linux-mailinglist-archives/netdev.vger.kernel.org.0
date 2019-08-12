Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57989645
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfHLE3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:29:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38566 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfHLE3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:29:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F9FC145487CD;
        Sun, 11 Aug 2019 21:29:29 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:29:28 -0700 (PDT)
Message-Id: <20190811.212928.1681769879219779999.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, jaltman@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix local refcounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156538726702.16201.13552536596121161945.stgit@warthog.procyon.org.uk>
References: <156538726702.16201.13552536596121161945.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:29:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 09 Aug 2019 22:47:47 +0100

> Fix rxrpc_unuse_local() to handle a NULL local pointer as it can be called
> on an unbound socket on which rx->local is not yet set.
> 
> The following reproduced (includes omitted):
> 
> 	int main(void)
> 	{
> 		socket(AF_RXRPC, SOCK_DGRAM, AF_INET);
> 		return 0;
> 	}
> 
> causes the following oops to occur:
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000010
> 	...
> 	RIP: 0010:rxrpc_unuse_local+0x8/0x1b
> 	...
> 	Call Trace:
> 	 rxrpc_release+0x2b5/0x338
> 	 __sock_release+0x37/0xa1
> 	 sock_close+0x14/0x17
> 	 __fput+0x115/0x1e9
> 	 task_work_run+0x72/0x98
> 	 do_exit+0x51b/0xa7a
> 	 ? __context_tracking_exit+0x4e/0x10e
> 	 do_group_exit+0xab/0xab
> 	 __x64_sys_exit_group+0x14/0x17
> 	 do_syscall_64+0x89/0x1d4
> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Reported-by: syzbot+20dee719a2e090427b5f@syzkaller.appspotmail.com
> Fixes: 730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jeffrey Altman <jaltman@auristor.com>

Applied.
