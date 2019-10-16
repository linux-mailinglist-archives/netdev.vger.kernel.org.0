Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BACD86D3
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbfJPDjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:39:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfJPDjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:39:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C47AD1266043A;
        Tue, 15 Oct 2019 20:39:19 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:39:19 -0700 (PDT)
Message-Id: <20191015.203919.1387270193651224661.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: change sctp_prot .no_autobind with true
From:   David Miller <davem@davemloft.net>
In-Reply-To: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
References: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:39:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 15 Oct 2019 15:24:38 +0800

> syzbot reported a memory leak:
> 
>   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
>   backtrace:
 ...
> It was caused by when sending msgs without binding a port, in the path:
> inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
> .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
> not. Later when binding another port by sctp_setsockopt_bindx(), a new
> bucket will be created as bp->port is not set.
> 
> sctp's autobind is supposed to call sctp_autobind() where it does all
> things including setting bp->port. Since sctp_autobind() is called in
> sctp_sendmsg() if the sk is not yet bound, it should have skipped the
> auto bind.
> 
> THis patch is to avoid calling inet_autobind() in inet_send_prepare()
> by changing sctp_prot .no_autobind with true, also remove the unused
> .get_port.
> 
> Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.

Xin, in the future please always provide a Fixes: even if it is the
initial kernel repository commit.

Thanks.
