Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5BD27B842
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgI1Xdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgI1Xdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:33:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F4C0613E1
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 15:14:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22E4411E3E4CE;
        Mon, 28 Sep 2020 14:57:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:14:10 -0700 (PDT)
Message-Id: <20200928.151410.232993869895631044.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net 0/3] net: core: fix a lockdep splat in the
 dev_addr_list.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925181246.25090-1-ap420073@gmail.com>
References: <20200925181246.25090-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 14:57:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 25 Sep 2020 18:12:46 +0000

> This patchset is to avoid lockdep splat.
> 
> When a stacked interface graph is changed, netif_addr_lock() is called
> recursively and it internally calls spin_lock_nested().
> The parameter of spin_lock_nested() is 'dev->lower_level',
> this is called subclass.
> The problem of 'dev->lower_level' is that while 'dev->lower_level' is
> being used as a subclass of spin_lock_nested(), its value can be changed.
> So, spin_lock_nested() would be called recursively with the same
> subclass value, the lockdep understands a deadlock.
> In order to avoid this, a new variable is needed and it is going to be
> used as a parameter of spin_lock_nested().
> The first and second patch is a preparation patch for the third patch.
> In the third patch, the problem will be fixed.
> 
> The first patch is to add __netdev_upper_dev_unlink().
> An existed netdev_upper_dev_unlink() is renamed to
> __netdev_upper_dev_unlink(). and netdev_upper_dev_unlink()
> is added as an wrapper of this function.
> 
> The second patch is to add the netdev_nested_priv structure.
> netdev_walk_all_{ upper | lower }_dev() pass both private functions
> and "data" pointer to handle their own things.
> At this point, the data pointer type is void *.
> In order to make it easier to expand common variables and functions,
> this new netdev_nested_priv structure is added.
> 
> The third patch is to add a new variable 'nested_level'
> into the net_device structure.
> This variable will be used as a parameter of spin_lock_nested() of
> dev->addr_list_lock.
> Due to this variable, it can avoid lockdep splat.

Series applied, thank you.
