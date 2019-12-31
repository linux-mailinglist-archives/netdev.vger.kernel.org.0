Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B7412D630
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfLaEgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:36:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50548 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaEgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:36:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED7D214048431;
        Mon, 30 Dec 2019 20:36:02 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:36:02 -0800 (PST)
Message-Id: <20191230.203602.1059248668690070255.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     netdev@vger.kernel.org, vladbu@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net] net/sched: add delete_empty() to filters and use
 it in cls_flower
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3f0b159cd943476d4beb8106b5a1405d050ec392.1577546059.git.dcaratti@redhat.com>
References: <3f0b159cd943476d4beb8106b5a1405d050ec392.1577546059.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:36:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Sat, 28 Dec 2019 16:36:58 +0100

> Revert "net/sched: cls_u32: fix refcount leak in the error path of
> u32_change()", and fix the u32 refcount leak in a more generic way that
> preserves the semantic of rule dumping.
> On tc filters that don't support lockless insertion/removal, there is no
> need to guard against concurrent insertion when a removal is in progress.
> Therefore, for most of them we can avoid a full walk() when deleting, and
> just decrease the refcount, like it was done on older Linux kernels.
> This fixes situations where walk() was wrongly detecting a non-empty
> filter, like it happened with cls_u32 in the error path of change(), thus
> leading to failures in the following tdc selftests:
> 
>  6aa7: (filter, u32) Add/Replace u32 with source match and invalid indev
>  6658: (filter, u32) Add/Replace u32 with custom hash table and invalid handle
>  74c2: (filter, u32) Add/Replace u32 filter with invalid hash table id
> 
> On cls_flower, and on (future) lockless filters, this check is necessary:
> move all the check_empty() logic in a callback so that each filter
> can have its own implementation. For cls_flower, it's sufficient to check
> if no IDRs have been allocated.
> 
> This reverts commit 275c44aa194b7159d1191817b20e076f55f0e620.
> 
> Changes since v1:
>  - document the need for delete_empty() when TCF_PROTO_OPS_DOIT_UNLOCKED
>    is used, thanks to Vlad Buslov
>  - implement delete_empty() without doing fl_walk(), thanks to Vlad Buslov
>  - squash revert and new fix in a single patch, to be nice with bisect
>    tests that run tdc on u32 filter, thanks to Dave Miller
> 
> Fixes: 275c44aa194b ("net/sched: cls_u32: fix refcount leak in the error path of u32_change()")
> Fixes: 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is empty")
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Suggested-by: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
