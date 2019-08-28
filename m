Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE76A0DCE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfH1Wyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:54:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfH1Wyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:54:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E322B153AF91B;
        Wed, 28 Aug 2019 15:54:30 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:54:30 -0700 (PDT)
Message-Id: <20190828.155430.2117344085860709411.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com
Subject: Re: [PATCH net] net: sched: act_sample: fix psample group handling
 on overwrite
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827184938.1824-1-vladbu@mellanox.com>
References: <20190827184938.1824-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 15:54:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Tue, 27 Aug 2019 21:49:38 +0300

> Action sample doesn't properly handle psample_group pointer in overwrite
> case. Following issues need to be fixed:
> 
> - In tcf_sample_init() function RCU_INIT_POINTER() is used to set
>   s->psample_group, even though we neither setting the pointer to NULL, nor
>   preventing concurrent readers from accessing the pointer in some way.
>   Use rcu_swap_protected() instead to safely reset the pointer.
> 
> - Old value of s->psample_group is not released or deallocated in any way,
>   which results resource leak. Use psample_group_put() on non-NULL value
>   obtained with rcu_swap_protected().
> 
> - The function psample_group_put() that released reference to struct
>   psample_group pointed by rcu-pointer s->psample_group doesn't respect rcu
>   grace period when deallocating it. Extend struct psample_group with rcu
>   head and use kfree_rcu when freeing it.
> 
> Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied and queued up for -stable.
