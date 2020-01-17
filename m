Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FDA14074A
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgAQKEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:04:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgAQKEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:04:13 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 742841556DC1F;
        Fri, 17 Jan 2020 02:04:12 -0800 (PST)
Date:   Fri, 17 Jan 2020 02:04:10 -0800 (PST)
Message-Id: <20200117.020410.706060911554362881.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com,
        ap420073@gmail.com
Subject: Re: [Patch net] net: avoid updating qdisc_xmit_lock_key in
 netdev_update_lockdep_key()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115210238.4107-1-xiyou.wangcong@gmail.com>
References: <20200115210238.4107-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 02:04:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 15 Jan 2020 13:02:38 -0800

> syzbot reported some bogus lockdep warnings, for example bad unlock
> balance in sch_direct_xmit(). They are due to a race condition between
> slow path and fast path, that is qdisc_xmit_lock_key gets re-registered
> in netdev_update_lockdep_key() on slow path, while we could still
> acquire the queue->_xmit_lock on fast path in this small window:
> 
> CPU A						CPU B
> 						__netif_tx_lock();
> lockdep_unregister_key(qdisc_xmit_lock_key);
> 						__netif_tx_unlock();
> lockdep_register_key(qdisc_xmit_lock_key);
> 
> In fact, unlike the addr_list_lock which has to be reordered when
> the master/slave device relationship changes, queue->_xmit_lock is
> only acquired on fast path and only when NETIF_F_LLTX is not set,
> so there is likely no nested locking for it.
> 
> Therefore, we can just get rid of re-registration of
> qdisc_xmit_lock_key.
> 
> Reported-by: syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com
> Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
