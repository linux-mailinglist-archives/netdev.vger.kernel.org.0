Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA3264EB9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgIJTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgIJTWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:22:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A49C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:22:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FACF12A2A765;
        Thu, 10 Sep 2020 12:05:55 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:22:41 -0700 (PDT)
Message-Id: <20200910.122241.1357846174503997660.davem@davemloft.net>
To:     penguin-kernel@I-love.SAKURA.ne.jp
Cc:     jmaloy@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH] tipc: fix shutdown() of connection oriented socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200905061447.3463-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20200905061447.3463-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:05:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat,  5 Sep 2020 15:14:47 +0900

> I confirmed that the problem fixed by commit 2a63866c8b51a3f7 ("tipc: fix
> shutdown() of connectionless socket") also applies to stream socket.
> 
> ----------
> #include <sys/socket.h>
> #include <unistd.h>
> #include <sys/wait.h>
> 
> int main(int argc, char *argv[])
> {
>         int fds[2] = { -1, -1 };
>         socketpair(PF_TIPC, SOCK_STREAM /* or SOCK_DGRAM */, 0, fds);
>         if (fork() == 0)
>                 _exit(read(fds[0], NULL, 1));
>         shutdown(fds[0], SHUT_RDWR); /* This must make read() return. */
>         wait(NULL); /* To be woken up by _exit(). */
>         return 0;
> }
> ----------
> 
> Since shutdown(SHUT_RDWR) should affect all processes sharing that socket,
> unconditionally setting sk->sk_shutdown to SHUTDOWN_MASK will be the right
> behavior.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Applied and queued up for -stable, thank you.
