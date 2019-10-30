Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DC9E945D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJ3BEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 21:04:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfJ3BEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 21:04:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A1DE142D4213;
        Tue, 29 Oct 2019 18:04:45 -0700 (PDT)
Date:   Tue, 29 Oct 2019 18:04:44 -0700 (PDT)
Message-Id: <20191029.180444.454132430553767413.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        j.vosburgh@gmail.com
Subject: Re: [PATCH net] bonding: fix using uninitialized mode_lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029091232.12026-1-ap420073@gmail.com>
References: <20191029091232.12026-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 18:04:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue, 29 Oct 2019 09:12:32 +0000

> When a bonding interface is being created, it setups its mode and options.
> At that moment, it uses mode_lock so mode_lock should be initialized
> before that moment.
> 
> rtnl_newlink()
> 	rtnl_create_link()
> 		alloc_netdev_mqs()
> 			->setup() //bond_setup()
> 	->newlink //bond_newlink
> 		bond_changelink()
> 		register_netdevice()
> 			->ndo_init() //bond_init()
> 
> After commit 089bca2caed0 ("bonding: use dynamic lockdep key instead of
> subclass"), mode_lock is initialized in bond_init().
> So in the bond_changelink(), un-initialized mode_lock can be used.
> mode_lock should be initialized in bond_setup().
> This patch partially reverts commit 089bca2caed0 ("bonding: use dynamic
> lockdep key instead of subclass")
> 
> Test command:
>     ip link add bond0 type bond mode 802.3ad lacp_rate 0
> 
> Splat looks like:
 ...
> Reported-by: syzbot+8da67f407bcba2c72e6e@syzkaller.appspotmail.com
> Reported-by: syzbot+0d083911ab18b710da71@syzkaller.appspotmail.com
> Fixes: 089bca2caed0 ("bonding: use dynamic lockdep key instead of subclass")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thanks for fixing this so quickly.
