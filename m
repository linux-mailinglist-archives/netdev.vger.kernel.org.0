Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D8F1A651D
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 12:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgDMKVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 06:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbgDMKU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 06:20:58 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E795520678;
        Mon, 13 Apr 2020 10:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586773257;
        bh=ns3ZwZL4JuRqV8qIWnV+5Szwjqv/4+kAFudEM6hyiOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f22y8AV744y3RwqSpwlDVxAv/s9tgG8DK+61QCm2Aw0sLF7+bIvWW6FQG+UlsSIUS
         ZANImpZbxo4bMePdy+QQP8WDSKQ9uqTR8Wb2NcRNaPKfNvJI4IzlN8hYHSe19JmpJY
         YCTFr1oheDkFUp1JEPRu+c0Z4WRbzCs6oMNbOrvc=
Date:   Mon, 13 Apr 2020 13:20:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200413102053.GI334007@unreal>
References: <20200412060854.334895-1-leon@kernel.org>
 <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 09:01:32AM +0000, Jose Abreu wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Apr/12/2020, 07:08:54 (UTC+00:00)
>
> > [  281.170584] ------------[ cut here ]------------
>
> Not objecting to the patch it-self (because usually stack trace is
> useless), but just FYI we use this marker in our CI to track for timeouts
> or crashes. I'm not sure if anyone else is using it.

I didn't delete the "NETDEV WATCHDOG .." message and it will be still
visible as a marker.

>
> And actually, can you please explain why BQL is not suppressing your
> timeouts ?

Driver can't distinguish between "real" timeout and "mixed traffic" timeout,
so we don't want to completely disable "dev->netdev_ops->ndo_tx_timeout(dev, i);"
call in watchdog [1]. The goal is to leave functionality in place and
simply remove stack trace to be similar to other BUG prints in that file [2].

[1] https://elixir.bootlin.com/linux/latest/source/net/sched/sch_generic.c#L444
[2] https://elixir.bootlin.com/linux/latest/source/net/sched/sch_generic.c#L328

>
> ---
> Thanks,
> Jose Miguel Abreu
