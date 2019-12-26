Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B48E12AFCC
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfLZXmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:42:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:42:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B431153B0988;
        Thu, 26 Dec 2019 15:42:16 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:42:15 -0800 (PST)
Message-Id: <20191226.154215.2234334150532757208.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     netdev@vger.kernel.org, vladbu@mellanox.com, jhs@mojatatu.com
Subject: Re: [PATCH net 0/2] net/sched: avoid walk() while deleting filters
 that still use rtnl_lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1577179314.git.dcaratti@redhat.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:42:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 24 Dec 2019 10:30:51 +0100

> we don't need to use walk() on deletion of TC filters, at least for those
> implementations that don't have TCF_PROTO_OPS_DOIT_UNLOCKED.
> 
> - patch 1/2 restores walk() semantic in cls_u32, that was recently
>   changed to fix semi-configured filters in the error path of u32_change().
> - patch 2/2 moves the delete_empty() logic to cls_flower, the only filter
>   that currently needs to guard against concurrent insert/delete.
>   For flower, the current delete_empty() still [ab,]uses walk(), to
>   preserve the bugfixes introduced by [1] and [2]: a follow-up commit
>   in the future can implement a proper delete_empty() that avoids calls
>   to fl_walk().
> 
> (tested with tdc "concurrency", "matchall", "basic" and "u32")
> 
> [1] 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is empty")
> [2] 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")

I think you really need to do the revert and the new version of the fix
in the same commit or similar.

Otherwise this series will not bisect cleanly, because any test on this
functionality will fail after patch #1.

Thanks.
