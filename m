Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526B4223006
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgGQAhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgGQAha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:37:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3596E207BC;
        Fri, 17 Jul 2020 00:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594946250;
        bh=ne0KynSrbnkOKMfI+5xxmGMmuc4TP8GeBpbris8h7JY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r1fOiG0KF7nP2jrSu7GwyPxvCA+5oN0wEo/P2qdF0JMY6gsnDa3GLaopiHJWNl+ZG
         7+aoHjE0AKRk/B5CS6WwBUocs4kLzNm209RuiRpZfa4hT0kfQeEHG7s3X/zW57fAH/
         Rs3MjVufwShjg7L02PFeAWufCVNFRR+4ORqGzung=
Date:   Thu, 16 Jul 2020 17:37:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next v3 0/2] net: sched: Do not drop root lock in
 tcf_qevent_handle()
Message-ID: <20200716173728.0a55175d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1594746074.git.petrm@mellanox.com>
References: <cover.1594746074.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 20:03:06 +0300 Petr Machata wrote:
> Mirred currently does not mix well with blocks executed after the qdisc
> root lock is taken. This includes classification blocks (such as in PRIO,
> ETS, DRR qdiscs) and qevents. The locking caused by the packet mirrored by
> mirred can cause deadlocks: either when the thread of execution attempts to
> take the lock a second time, or when two threads end up waiting on each
> other's locks.
> 
> The qevent patchset attempted to not introduce further badness of this
> sort, and dropped the lock before executing the qevent block. However this
> lead to too little locking and races between qdisc configuration and packet
> enqueue in the RED qdisc.
> 
> Before the deadlock issues are solved in a way that can be applied across
> many qdiscs reasonably easily, do for qevents what is done for the
> classification blocks and just keep holding the root lock.
> 
> That is done in patch #1. Patch #2 then drops the now unnecessary root_lock
> argument from Qdisc_ops.enqueue.

Applied, thanks.
