Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2F282DD4
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgJDVy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgJDVyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:54:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4466C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 14:54:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3078912780FC3;
        Sun,  4 Oct 2020 14:38:07 -0700 (PDT)
Date:   Sun, 04 Oct 2020 14:54:53 -0700 (PDT)
Message-Id: <20201004.145453.1397904175583154013.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com,
        vladbu@mellanox.com, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: check error pointer in tcf_dump_walker()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002191334.14135-1-xiyou.wangcong@gmail.com>
References: <20201002191334.14135-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:38:07 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri,  2 Oct 2020 12:13:34 -0700

> Although we take RTNL on dump path, it is possible to
> skip RTNL on insertion path. So the following race condition
> is possible:
> 
> rtnl_lock()		// no rtnl lock
> 			mutex_lock(&idrinfo->lock);
> 			// insert ERR_PTR(-EBUSY)
> 			mutex_unlock(&idrinfo->lock);
> tc_dump_action()
> rtnl_unlock()
> 
> So we have to skip those temporary -EBUSY entries on dump path
> too.
> 
> Reported-and-tested-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com
> Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
