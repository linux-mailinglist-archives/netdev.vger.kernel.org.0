Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC9C23C076
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgHDUEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgHDUEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:04:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550A4C061756
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:04:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB75C12880E01;
        Tue,  4 Aug 2020 12:47:35 -0700 (PDT)
Date:   Tue, 04 Aug 2020 13:04:20 -0700 (PDT)
Message-Id: <20200804.130420.1170398750895013643.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, dnelson@redhat.com,
        linux-arm-kernel@lists.infradead.org, sgoutham@cavium.com,
        rric@kernel.org, pabeni@redhat.com
Subject: Re: [PATCHv2 net] net: thunderx: use spin_lock_bh in
 nicvf_set_rx_mode_task()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9809b6b99bf5ba2dc8d1440c7d4fc93d04a7504a.1596524550.git.lucien.xin@gmail.com>
References: <9809b6b99bf5ba2dc8d1440c7d4fc93d04a7504a.1596524550.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 12:47:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  4 Aug 2020 15:02:30 +0800

> A dead lock was triggered on thunderx driver:
> 
>         CPU0                    CPU1
>         ----                    ----
>    [01] lock(&(&nic->rx_mode_wq_lock)->rlock);
>                            [11] lock(&(&mc->mca_lock)->rlock);
>                            [12] lock(&(&nic->rx_mode_wq_lock)->rlock);
>    [02] <Interrupt> lock(&(&mc->mca_lock)->rlock);
> 
> The path for each is:
> 
>   [01] worker_thread() -> process_one_work() -> nicvf_set_rx_mode_task()
>   [02] mld_ifc_timer_expire()
>   [11] ipv6_add_dev() -> ipv6_dev_mc_inc() -> igmp6_group_added() ->
>   [12] dev_mc_add() -> __dev_set_rx_mode() -> nicvf_set_rx_mode()
> 
> To fix it, it needs to disable bh on [1], so that the timer on [2]
> wouldn't be triggered until rx_mode_wq_lock is released. So change
> to use spin_lock_bh() instead of spin_lock().
> 
> Thanks to Paolo for helping with this.
> 
> v1->v2:
>   - post to netdev.
> 
> Reported-by: Rafael P. <rparrazo@redhat.com>
> Tested-by: Dean Nelson <dnelson@redhat.com>
> Fixes: 469998c861fa ("net: thunderx: prevent concurrent data re-writing by nicvf_set_rx_mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
