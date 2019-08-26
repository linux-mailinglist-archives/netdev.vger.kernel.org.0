Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC969D7FF
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfHZVST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:18:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHZVST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:18:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38DCD14FD2C47;
        Mon, 26 Aug 2019 14:18:18 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:18:17 -0700 (PDT)
Message-Id: <20190826.141817.262857334547814479.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, jakub.kicinski@netronome.com, pablo@netfilter.org
Subject: Re: [PATCH net-next v3 00/10] Refactor cls hardware offload API to
 support rtnl-independent drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 14:18:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Mon, 26 Aug 2019 16:44:56 +0300

> Implement following cls API changes:
> 
> - Introduce new "unlocked_driver_cb" flag to struct flow_block_offload
>   to allow registering and unregistering block hardware offload
>   callbacks that do not require caller to hold rtnl lock. Drivers that
>   doesn't require users of its tc offload callbacks to hold rtnl lock
>   sets the flag to true on block bind/unbind. Internally tcf_block is
>   extended with additional lockeddevcnt counter that is used to count
>   number of devices that require rtnl lock that block is bound to. When
>   this counter is zero, tc_setup_cb_*() functions execute callbacks
>   without obtaining rtnl lock.
> 
> - Extend cls API single hardware rule update tc_setup_cb_call() function
>   with tc_setup_cb_add(), tc_setup_cb_replace(), tc_setup_cb_destroy()
>   and tc_setup_cb_reoffload() functions. These new APIs are needed to
>   move management of block offload counter, filter in hardware counter
>   and flag from classifier implementations to cls API, which is now
>   responsible for managing them in concurrency-safe manner. Access to
>   cb_list from callback execution code is synchronized by obtaining new
>   'cb_lock' rw_semaphore in read mode, which allows executing callbacks
>   in parallel, but excludes any modifications of data from
>   register/unregister code. tcf_block offloads counter type is changed
>   to atomic integer to allow updating the counter concurrently.
> 
> - Extend classifier ops with new ops->hw_add() and ops->hw_del()
>   callbacks which are used to notify unlocked classifiers when filter is
>   successfully added or deleted to hardware without releasing cb_lock.
>   This is necessary to update classifier state atomically with callback
>   list traversal and updating of all relevant counters and allows
>   unlocked classifiers to synchronize with concurrent reoffload without
>   requiring any changes to driver callback API implementations.
 ...

Looks good, series applied, thanks.
