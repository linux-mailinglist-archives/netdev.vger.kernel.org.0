Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4406D864C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbfJPDVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:21:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729677AbfJPDVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:21:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8A9C128F387F;
        Tue, 15 Oct 2019 20:21:34 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:21:34 -0700 (PDT)
Message-Id: <20191015.202134.33836858979543563.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: avoid potential infinite loop in
 tc_ctl_action()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014182230.205162-1-edumazet@google.com>
References: <20191014182230.205162-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:21:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 14 Oct 2019 11:22:30 -0700

> tc_ctl_action() has the ability to loop forever if tcf_action_add()
> returns -EAGAIN.
> 
> This special case has been done in case a module needed to be loaded,
> but it turns out that tcf_add_notify() could also return -EAGAIN
> if the socket sk_rcvbuf limit is hit.
> 
> We need to separate the two cases, and only loop for the module
> loading case.
> 
> While we are at it, add a limit of 10 attempts since unbounded
> loops are always scary.
> 
> syzbot repro was something like :
> 
> socket(PF_NETLINK, SOCK_RAW|SOCK_NONBLOCK, NETLINK_ROUTE) = 3
> write(3, ..., 38) = 38
> setsockopt(3, SOL_SOCKET, SO_RCVBUF, [0], 4) = 0
> sendmsg(3, {msg_name(0)=NULL, msg_iov(1)=[{..., 388}], msg_controllen=0, msg_flags=0x10}, ...)
 ...
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks.
