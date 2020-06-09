Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C721F47A5
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbgFIUAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgFIUAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:00:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20249C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 13:00:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A86AB12775D3D;
        Tue,  9 Jun 2020 13:00:49 -0700 (PDT)
Date:   Tue, 09 Jun 2020 13:00:48 -0700 (PDT)
Message-Id: <20200609.130048.1344695073399682276.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        ap420073@gmail.com, dvyukov@google.com
Subject: Re: [Patch net] net: change addr_list_lock back to static key
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 13:00:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon,  8 Jun 2020 14:53:01 -0700

> The dynamic key update for addr_list_lock still causes troubles,
> for example the following race condition still exists:
> 
> CPU 0:				CPU 1:
> (RCU read lock)			(RTNL lock)
> dev_mc_seq_show()		netdev_update_lockdep_key()
> 				  -> lockdep_unregister_key()
>  -> netif_addr_lock_bh()
> 
> because lockdep doesn't provide an API to update it atomically.
> Therefore, we have to move it back to static keys and use subclass
> for nest locking like before.
> 
> In commit 1a33e10e4a95 ("net: partially revert dynamic lockdep key
> changes"), I already reverted most parts of commit ab92d68fc22f
> ("net: core: add generic lockdep keys").
> 
> This patch reverts the rest and also part of commit f3b0a18bb6cb
> ("net: remove unnecessary variables and callback"). After this
> patch, addr_list_lock changes back to using static keys and
> subclasses to satisfy lockdep. Thanks to dev->lower_level, we do
> not have to change back to ->ndo_get_lock_subclass().
> 
> And hopefully this reduces some syzbot lockdep noises too.
> 
> Reported-by: syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Ok, let's see how this goes.

Applied, thanks Cong.
