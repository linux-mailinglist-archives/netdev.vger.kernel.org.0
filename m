Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46D5250BE6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgHXWvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHXWvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:51:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0543DC061574;
        Mon, 24 Aug 2020 15:51:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBC351290EBA8;
        Mon, 24 Aug 2020 15:34:23 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:51:08 -0700 (PDT)
Message-Id: <20200824.155108.8657858310039234.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        edumazet@google.com, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCHv2 net] sctp: not disable bh in the whole
 sctp_get_port_local()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
References: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:34:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 21 Aug 2020 14:59:38 +0800

> With disabling bh in the whole sctp_get_port_local(), when
> snum == 0 and too many ports have been used, the do-while
> loop will take the cpu for a long time and cause cpu stuck:
> 
>   [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
>   [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
>   [ ] Call Trace:
>   [ ]  _raw_spin_lock+0xc1/0xd0
>   [ ]  sctp_get_port_local+0x527/0x650 [sctp]
>   [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
>   [ ]  sctp_autobind+0x165/0x1e0 [sctp]
>   [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
>   [ ]  __sctp_connect+0x360/0xb10 [sctp]
> 
> There's no need to disable bh in the whole function of
> sctp_get_port_local. So fix this cpu stuck by removing
> local_bh_disable() called at the beginning, and using
> spin_lock_bh() instead.
> 
> The same thing was actually done for inet_csk_get_port() in
> Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
> ports in bind()").
> 
> Thanks to Marcelo for pointing the buggy code out.
> 
> v1->v2:
>   - use cond_resched() to yield cpu to other tasks if needed,
>     as Eric noticed.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
