Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6E93DFBDA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhHDHOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235377AbhHDHOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F4C60F35;
        Wed,  4 Aug 2021 07:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628061280;
        bh=cCgCZgIImHFNoxPAyAyaUjiJiyOgILXo5u6tNH3e+wM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTSKyrsVPViua6n9kX2sZ6Gagm4cZuJtLx8inoxF9jEnv7PQuWJkOQCOj31Hri0RT
         u049wuzQG2WsmfoOZngs/qGzoiF9lJYSRXpOQlZoOGXnXaN9cHDfoixVLeUqe+h3WL
         f9h+TFIFoqAq9gCLiM0kzyDnh7uutFyWM2j3hSiucwLdlwfTeb0qxctZ3ML6J1T2E1
         u5Zdm44KNyGAckDrh5hycgT4QzT1RcXqeMeKti+vHtgpVw/gfMUL8Gpu8B89uTiEQi
         ylrUiwg58jFvLhIEbJxtP/Esf/PRLpMuFDmUa7Y0v9ikb8L4T9QLMiF5DPVNeQA/z3
         pxPr1YibVPvYg==
Date:   Wed, 4 Aug 2021 10:14:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <YQo+XJQNAP7jnGw0@unreal>
References: <20210803123921.2374485-1-kuba@kernel.org>
 <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
 <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
 <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 02:51:24PM -0700, Jakub Kicinski wrote:
> On Tue, 3 Aug 2021 14:32:19 -0700 Cong Wang wrote:
> > On Tue, Aug 3, 2021 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:

<...>

> > Please remove all those not covered by upstream tests just to be fair??
> 
> I'd love to remove all test harnesses upstream which are not used by
> upstream tests, sure :)

Jakub,

Something related and unrelated at the same time.

I need to get rid of devlink_reload_enable()/_disable() to fix some
panics in the devlink reload flow.

Such change is relatively easy for the HW drivers, but not so for the
netdevism due to attempt to synchronize sysfs with devlink.

  200         mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
  201         devlink_reload_disable(devlink);
  202         ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
  203         devlink_reload_enable(devlink);
  204         mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);

Are these sysfs files declared as UAPI? Or can I update upstream test
suite and delete them safely?

Thanks
