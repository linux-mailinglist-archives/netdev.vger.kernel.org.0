Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBB210DF47
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfK3Ubg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:31:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfK3Ubg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:31:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D51A414522EE6;
        Sat, 30 Nov 2019 12:31:35 -0800 (PST)
Date:   Sat, 30 Nov 2019 12:31:35 -0800 (PST)
Message-Id: <20191130.123135.109392310105227339.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com
Subject: Re: [Patch net] netrom: fix a potential NULL pointer dereference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191130200540.2461-1-xiyou.wangcong@gmail.com>
References: <20191130200540.2461-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 12:31:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 30 Nov 2019 12:05:40 -0800

> It is possible that the skb gets removed between skb_peek() and
> skb_dequeue(). So we should just check the return value of
> skb_dequeue().  Otherwise, skb_clone() may get a NULL pointer.
> 
> Technically, this should be protected by sock lock, but netrom
> doesn't use it correctly. It is harder to fix sock lock than just
> fixing this.
> 
> Reported-by: syzbot+9fe8e3f6c64aa5e5d82c@syzkaller.appspotmail.com
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

This is really bogus because it also means that all of the other
state such as the ack_queue, nr->va, nr->vs, nr->window can also
change meanwhile.

And these determine whether a dequeue should be done at all, and
I'm sure some range violations are possible as a result as well.

This code is really terminally broken and just adding this check
will leave many other other obvious bugs here that syzbot will
trigger eventually.

Sorry I'm not applying this, it's a hack that leaves obvious remaining
problems in the code.
