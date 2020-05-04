Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08091C466F
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEDSx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725981AbgEDSx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:53:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE8AC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:53:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1AB511F5F61A;
        Mon,  4 May 2020 11:53:55 -0700 (PDT)
Date:   Mon, 04 May 2020 11:53:54 -0700 (PDT)
Message-Id: <20200504.115354.1185304352631980931.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:53:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 30 Apr 2020 20:53:49 -0700

> When we tell kernel to dump filters from root (ffff:ffff),
> those filters on ingress (ffff:0000) are matched, but their
> true parents must be dumped as they are. However, kernel
> dumps just whatever we tell it, that is either ffff:ffff
> or ffff:0000:
> 
>  $ nl-cls-list --dev=dummy0 --parent=root
>  cls basic dev dummy0 id none parent root prio 49152 protocol ip match-all
>  cls basic dev dummy0 id :1 parent root prio 49152 protocol ip match-all
>  $ nl-cls-list --dev=dummy0 --parent=ffff:
>  cls basic dev dummy0 id none parent ffff: prio 49152 protocol ip match-all
>  cls basic dev dummy0 id :1 parent ffff: prio 49152 protocol ip match-all
> 
> This is confusing and misleading, more importantly this is
> a regression since 4.15, so the old behavior must be restored.
> 
> And, when tc filters are installed on a tc class, the parent
> should be the classid, rather than the qdisc handle. Commit
> edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
> removed the classid we save for filters, we can just restore
> this classid in tcf_block.
> 
> Steps to reproduce this:
 ...
> Fixes: a10fa20101ae ("net: sched: propagate q and parent from caller down to tcf_fill_node")
> Fixes: edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thanks.
