Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91591EEDCD
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFDWjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgFDWjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:39:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706D3C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:39:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 748CD120477C4;
        Thu,  4 Jun 2020 15:39:02 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:39:01 -0700 (PDT)
Message-Id: <20200604.153901.141941797676227009.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: fix NULL pointer dereference in streaming
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603050601.19570-1-tuong.t.lien@dektech.com.au>
References: <20200603050601.19570-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:39:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed,  3 Jun 2020 12:06:01 +0700

> syzbot found the following crash:
 ...
> Call Trace:
>  tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1533
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x32f/0x810 net/socket.c:2352
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2406
>  __sys_sendmmsg+0x195/0x480 net/socket.c:2496
>  __do_sys_sendmmsg net/socket.c:2525 [inline]
>  __se_sys_sendmmsg net/socket.c:2522 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x440199
> ...
> 
> This bug was bisected to commit 0a3e060f340d ("tipc: add test for Nagle
> algorithm effectiveness"). However, it is not the case, the trouble was
> from the base in the case of zero data length message sending, we would
> unexpectedly make an empty 'txq' queue after the 'tipc_msg_append()' in
> Nagle mode.
> 
> A similar crash can be generated even without the bisected patch but at
> the link layer when it accesses the empty queue.
> 
> We solve the issues by building at least one buffer to go with socket's
> header and an optional data section that may be empty like what we had
> with the 'tipc_msg_build()'.
> 
> Note: the previous commit 4c21daae3dbc ("tipc: Fix NULL pointer
> dereference in __tipc_sendstream()") is obsoleted by this one since the
> 'txq' will be never empty and the check of 'skb != NULL' is unnecessary
> but it is safe anyway.
> 
> Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied and queued up for -stable, thanks.
