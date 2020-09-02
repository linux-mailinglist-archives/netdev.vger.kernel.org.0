Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4901425B6AF
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIBWuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIBWuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 18:50:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84111C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 15:50:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1B811574121A;
        Wed,  2 Sep 2020 15:33:31 -0700 (PDT)
Date:   Wed, 02 Sep 2020 15:50:17 -0700 (PDT)
Message-Id: <20200902.155017.1839963224242775770.davem@davemloft.net>
To:     penguin-kernel@I-love.SAKURA.ne.jp
Cc:     syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com,
        jmaloy@redhat.com, ying.xue@windriver.com,
        syzkaller-bugs@googlegroups.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v2] tipc: fix shutdown() of connectionless socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8267b7c2-3dc9-41ec-5490-d1080a63be11@I-love.SAKURA.ne.jp>
References: <0000000000003feb9805a9c77128@google.com>
        <1eb799fb-c6e0-3eb5-f6fe-718cd2f62e92@I-love.SAKURA.ne.jp>
        <8267b7c2-3dc9-41ec-5490-d1080a63be11@I-love.SAKURA.ne.jp>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:33:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 2 Sep 2020 22:44:16 +0900

> syzbot is reporting hung task at nbd_ioctl() [1], for there are two
> problems regarding TIPC's connectionless socket's shutdown() operation.
 ...
> One problem is that wait_for_completion() from flush_workqueue() from
> nbd_start_device_ioctl() from nbd_ioctl() cannot be completed when
> nbd_start_device_ioctl() received a signal at wait_event_interruptible(),
> for tipc_shutdown() from kernel_sock_shutdown(SHUT_RDWR) from
> nbd_mark_nsock_dead() from sock_shutdown() from nbd_start_device_ioctl()
> is failing to wake up a WQ thread sleeping at wait_woken() from
> tipc_wait_for_rcvmsg() from sock_recvmsg() from sock_xmit() from
> nbd_read_stat() from recv_work() scheduled by nbd_start_device() from
> nbd_start_device_ioctl(). Fix this problem by always invoking
> sk->sk_state_change() (like inet_shutdown() does) when tipc_shutdown() is
> called.
> 
> The other problem is that tipc_wait_for_rcvmsg() cannot return when
> tipc_shutdown() is called, for tipc_shutdown() sets sk->sk_shutdown to
> SEND_SHUTDOWN (despite "how" is SHUT_RDWR) while tipc_wait_for_rcvmsg()
> needs sk->sk_shutdown set to RCV_SHUTDOWN or SHUTDOWN_MASK. Fix this
> problem by setting sk->sk_shutdown to SHUTDOWN_MASK (like inet_shutdown()
> does) when the socket is connectionless.
> 
> [1] https://syzkaller.appspot.com/bug?id=3fe51d307c1f0a845485cf1798aa059d12bf18b2
> 
> Reported-by: syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Applied and queued up for -stable, thank you.
