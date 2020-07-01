Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC545211645
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgGAWtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgGAWtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:49:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6BCC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 15:49:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3F7514A8D6B2;
        Wed,  1 Jul 2020 15:49:54 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:49:54 -0700 (PDT)
Message-Id: <20200701.154954.1302175682029862763.davem@davemloft.net>
To:     stranche@codeaurora.org
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        johannes.berg@intel.com, subashab@codeaurora.org
Subject: Re: [PATCH net v2] genetlink: remove genl_bind
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593539417-19973-1-git-send-email-stranche@codeaurora.org>
References: <1593539417-19973-1-git-send-email-stranche@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:49:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Tranchetti <stranche@codeaurora.org>
Date: Tue, 30 Jun 2020 11:50:17 -0600

> A potential deadlock can occur during registering or unregistering a
> new generic netlink family between the main nl_table_lock and the
> cb_lock where each thread wants the lock held by the other, as
> demonstrated below.
> 
> 1) Thread 1 is performing a netlink_bind() operation on a socket. As part
>    of this call, it will call netlink_lock_table(), incrementing the
>    nl_table_users count to 1.
> 2) Thread 2 is registering (or unregistering) a genl_family via the
>    genl_(un)register_family() API. The cb_lock semaphore will be taken for
>    writing.
> 3) Thread 1 will call genl_bind() as part of the bind operation to handle
>    subscribing to GENL multicast groups at the request of the user. It will
>    attempt to take the cb_lock semaphore for reading, but it will fail and
>    be scheduled away, waiting for Thread 2 to finish the write.
> 4) Thread 2 will call netlink_table_grab() during the (un)registration
>    call. However, as Thread 1 has incremented nl_table_users, it will not
>    be able to proceed, and both threads will be stuck waiting for the
>    other.
> 
> genl_bind() is a noop, unless a genl_family implements the mcast_bind()
> function to handle setting up family-specific multicast operations. Since
> no one in-tree uses this functionality as Cong pointed out, simply removing
> the genl_bind() function will remove the possibility for deadlock, as there
> is no attempt by Thread 1 above to take the cb_lock semaphore.
> 
> Fixes: c380d9a7afff ("genetlink: pass multicast bind/unbind to families")
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Acked-by: Johannes Berg <johannes.berg@intel.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>

Applied and queued up for -stable, thanks.
