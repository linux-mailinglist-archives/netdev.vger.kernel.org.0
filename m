Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8971A5FFF
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 21:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgDLTXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 15:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgDLTXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 15:23:41 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AE6C0A3BF0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 12:23:41 -0700 (PDT)
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CAF2063A;
        Sun, 12 Apr 2020 19:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586719421;
        bh=7hj+PG56nTVje1U7oj/g//l4peysHhbrUFgvlgsJbdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xYCOQi5uShvT5ztLhchoY/c7tlIw46T+jo3+j9q7qf4UlDteS4oTPjAlVIfn1vO8l
         nQy9G+6KclmfPhHWhqXnexJDUwd0jUKcZ4gqGkRNoZMYnjBhL548hvOmsUBwNrTKPP
         P6JxzhfBNFS+xrqDTz4cX1BkW3uV087K7UISlcgk=
Date:   Sun, 12 Apr 2020 22:23:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200412192336.GD334007@unreal>
References: <20200412060854.334895-1-leon@kernel.org>
 <20200412115913.14d69a7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412115913.14d69a7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 11:59:13AM -0700, Jakub Kicinski wrote:
> On Sun, 12 Apr 2020 09:08:54 +0300 Leon Romanovsky wrote:
> > Hi Dave,
> >
> > This is a new version of previously sent v0 [1] with change in print error
> > level as was suggested by Jakub and Cong. I'm asking you to reevaluate
> > your previous decision [2] given the fact that this is user triggered
> > bug and very similar scenario was committed by Linus "fs/filesystems.c:
> > downgrade user-reachable WARN_ONCE() to pr_warn_once()" a couple of days
> > ago [3].
> >
> > [1] https://lore.kernel.org/netdev/20200402152336.538433-1-leon@kernel.org
> > [2] https://lore.kernel.org/netdev/20200402.180218.940555077368617365.davem@davemloft.net
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=26c5d78c976ca298e59a56f6101a97b618ba3539
>
> How is it user triggerable? If there's a IB-specific reason maybe ib
> netdev should stop implementing ndo_tx_timeout.

It is happening if device is extremely over loaded with traffic,
internally HW decreases the performance (HW bug), it is causing to
the TX timeouts and to the WARN_ON splat.

We don't want to stop implementing ndo_tx_timeout, because it works
right most (if not all) of the time.

If it is very important, I will dig into internal bug reports to see
the possible reproduction scenarios, but from what I saw till now,
it is statistical failure.

And it is not IB specific, but mlx4 specific.

Thanks
