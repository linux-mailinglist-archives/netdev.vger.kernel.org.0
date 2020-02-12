Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C52E15AEF5
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgBLRoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:44:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLRoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:44:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 484DE13B28916;
        Wed, 12 Feb 2020 09:43:59 -0800 (PST)
Date:   Wed, 12 Feb 2020 09:43:56 -0800 (PST)
Message-Id: <20200212.094356.734697556409905980.davem@davemloft.net>
To:     firo.yang@suse.com
Cc:     netdev@vger.kernel.org, pkaustub@cisco.com, _govind@gmx.com,
        benve@cisco.com, firogm@gmail.com
Subject: Re: [PATCH 1/1] enic: prevent waking up stopped tx queues over
 watchdog reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212050917.848742-1-firo.yang@suse.com>
References: <20200212050917.848742-1-firo.yang@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2020 09:43:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Firo Yang <firo.yang@suse.com>
Date: Wed, 12 Feb 2020 06:09:17 +0100

> Recent months, our customer reported several kernel crashes all
> preceding with following message:
> NETDEV WATCHDOG: eth2 (enic): transmit queue 0 timed out
> Error message of one of those crashes:
> BUG: unable to handle kernel paging request at ffffffffa007e090
> 
> After analyzing severl vmcores, I found that most of crashes are
> caused by memory corruption. And all the corrupted memory areas
> are overwritten by data of network packets. Moreover, I also found
> that the tx queues were enabled over watchdog reset.
> 
> After going through the source code, I found that in enic_stop(),
> the tx queues stopped by netif_tx_disable() could be woken up over
> a small time window between netif_tx_disable() and the
> napi_disable() by the following code path:
> napi_poll->
>   enic_poll_msix_wq->
>      vnic_cq_service->
>         enic_wq_service->
>            netif_wake_subqueue(enic->netdev, q_number)->
>               test_and_clear_bit(__QUEUE_STATE_DRV_XOFF, &txq->state)
> In turn, upper netowrk stack could queue skb to ENIC NIC though
> enic_hard_start_xmit(). And this might introduce some race condition.
> 
> Our customer comfirmed that this kind of kernel crash doesn't occur over
> 90 days since they applied this patch.
> 
> Signed-off-by: Firo Yang <firo.yang@suse.com>

Applied and queued up for -stable, thanks.
