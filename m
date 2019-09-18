Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0877B5F4A
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfIRId3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbfIRId2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 04:33:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4629521929;
        Wed, 18 Sep 2019 08:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568795607;
        bh=CLc3y6pr//+2xmg7YLTQLHeHBn+e19hZRGVpbW8meNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=znIfBdHgsym3F5/xNH+YfGG7tXY66oPckgoDte+XpQs2ah4hkok6s4N3bvzfjHGoV
         F53Kp/GN3dTsljFP7m4tLJ2XeZB1M7yc0HFScEqB9gd69OTNrqzqL3zGsodQMu6moL
         QB0ShhFstqLOaCLErX2wtgxDiiJ4xU1ryCgXYRl4=
Date:   Wed, 18 Sep 2019 10:32:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     chien.yen@oracle.com, davem@davemloft.net, stable@vger.kernel.org,
        rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH stable 4.4 net] net: rds: Fix NULL ptr use in
 rds_tcp_kill_sock
Message-ID: <20190918083253.GA1862222@kroah.com>
References: <20190918083733.50266-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918083733.50266-1-maowenan@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 04:37:33PM +0800, Mao Wenan wrote:
> After the commit c4e97b06cfdc ("net: rds: force to destroy
> connection if t_sock is NULL in rds_tcp_kill_sock()."),
> it introduced null-ptr-deref in rds_tcp_kill_sock as below:
> 
> BUG: KASAN: null-ptr-deref on address 0000000000000020
> Read of size 8 by task kworker/u16:10/910
> CPU: 3 PID: 910 Comm: kworker/u16:10 Not tainted 4.4.178+ #3
> Hardware name: linux,dummy-virt (DT)
> Workqueue: netns cleanup_net
> Call trace:
> [<ffffff90080abb50>] dump_backtrace+0x0/0x618
> [<ffffff90080ac1a0>] show_stack+0x38/0x60
> [<ffffff9008c42b78>] dump_stack+0x1a8/0x230
> [<ffffff90085d469c>] kasan_report_error+0xc8c/0xfc0
> [<ffffff90085d54a4>] kasan_report+0x94/0xd8
> [<ffffff90085d1b28>] __asan_load8+0x88/0x150
> [<ffffff9009c9cc2c>] rds_tcp_dev_event+0x734/0xb48
> [<ffffff90081eacb0>] raw_notifier_call_chain+0x150/0x1e8
> [<ffffff900973fec0>] call_netdevice_notifiers_info+0x90/0x110
> [<ffffff9009764874>] netdev_run_todo+0x2f4/0xb08
> [<ffffff9009796d34>] rtnl_unlock+0x2c/0x48
> [<ffffff9009756484>] default_device_exit_batch+0x444/0x528
> [<ffffff9009720498>] ops_exit_list+0x1c0/0x240
> [<ffffff9009724a80>] cleanup_net+0x738/0xbf8
> [<ffffff90081ca6cc>] process_one_work+0x96c/0x13e0
> [<ffffff90081cf370>] worker_thread+0x7e0/0x1910
> [<ffffff90081e7174>] kthread+0x304/0x390
> [<ffffff9008094280>] ret_from_fork+0x10/0x50
> 
> If the first loop add the tc->t_sock = NULL to the tmp_list,
> 1). list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node)
> 
> then the second loop is to find connections to destroy, tc->t_sock
> might equal NULL, and tc->t_sock->sk happens null-ptr-deref.
> 2). list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
> 
> Fixes: c4e97b06cfdc ("net: rds: force to destroy connection if t_sock is NULL in rds_tcp_kill_sock().")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/rds/tcp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Why is this not needed upstream as well?

4.9.y?  4.14.y?  anything else?

thanks,

greg k-h
