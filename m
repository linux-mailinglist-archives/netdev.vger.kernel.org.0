Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D6B24C8BB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgHTXnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgHTXnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:43:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12B0C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:43:01 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E55FF1287CBA6;
        Thu, 20 Aug 2020 16:26:12 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:42:58 -0700 (PDT)
Message-Id: <20200820.164258.1142916452755887278.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, tuong.t.lien@dektech.com.au
Subject: Re: [PATCH net] tipc: call rcu_read_lock() in
 tipc_aead_encrypt_done()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7f24b6b0a0d2cb82b9dfbf5343c01266d2840561.1597908887.git.lucien.xin@gmail.com>
References: <7f24b6b0a0d2cb82b9dfbf5343c01266d2840561.1597908887.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:26:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 20 Aug 2020 15:34:47 +0800

> b->media->send_msg() requires rcu_read_lock(), as we can see
> elsewhere in tipc,  tipc_bearer_xmit, tipc_bearer_xmit_skb
> and tipc_bearer_bc_xmit().
> 
> Syzbot has reported this issue as:
> 
>   net/tipc/bearer.c:466 suspicious rcu_dereference_check() usage!
>   Workqueue: cryptd cryptd_queue_worker
>   Call Trace:
>    tipc_l2_send_msg+0x354/0x420 net/tipc/bearer.c:466
>    tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
>    cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
>    cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
>    process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>    worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>    kthread+0x3b5/0x4a0 kernel/kthread.c:291
>    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> 
> So fix it by calling rcu_read_lock() in tipc_aead_encrypt_done()
> for b->media->send_msg().
> 
> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
> Reported-by: syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
