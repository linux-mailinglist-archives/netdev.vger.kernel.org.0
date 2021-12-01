Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0333F4650DD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350427AbhLAPIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:08:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350460AbhLAPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:08:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A05A9B81FE1
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 15:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1843BC53FCD;
        Wed,  1 Dec 2021 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638371114;
        bh=JoQ9VfRB6MiEGwQi1FdAb0VtjRCTSz1UIG5ga/e2/+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxSw0aHDPXvGQRnJiYl38C9FVrJyU/4P+mnx7K7nEf13MdGzCOYqWVOXhHtoFhsRz
         MxttTQz/dKxAhf6rnK9ghgpArR+SYxyZfj5RJExHSAoCNHksrD+NNUtmZxcyIMZRLc
         McjycHsijwjJA++zESlBwwZv9pXkMUMTpjkjexxfpZIJpUKR72d+IKoC23uiEi1G1t
         fP8D59hNlNzRf7Bd/fJkk/2gT6P5t5TsEezzgvHlGm6utAfbY/BRs7LwbOY9PcDvL8
         VV/h2RyHUFV/NUSJfFzlDg2MtoAeweFPDcTRZewmZi3/8gBmgYBxpUnAVC+2wtFDmp
         H3Sm+YmOSKKkQ==
Date:   Wed, 1 Dec 2021 07:05:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net-sysfs: update the queue counts in the
 unregistration path
Message-ID: <20211201070513.6830f1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163835112179.4366.10853783909376430643@kwain>
References: <20211129154520.295823-1-atenart@kernel.org>
        <20211130180839.285e31be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <163835112179.4366.10853783909376430643@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 01 Dec 2021 10:32:01 +0100 Antoine Tenart wrote:
> > Would you mind pointing where in the code that happens? I can't seem 
> > to find anything looking at real_num_.x_queues outside dev.c and
> > net-sysfs.c :S  
> 
> I read the above commit message again; it's not well explained... Sorry
> for that.
> 
> The above trace was triggered using veths and this patch would solve
> this as veths do use real_num_x_queues to fill 'struct ethtool_channels'
> in its get_channels ops[1] which is then used to avoid making channel
> counts updates if it is 0[2].

But when we are at line 175 in [2] we already updated the values from
the user space request at lines 144-151. This check validates the new
config so a transition from 0 -> n should not be prevented here AFAICT.

> In addition, keeping track of the queue counts in the unregistration
> path do help other drivers as it will allow adding a warning in
> netdev_queue_update_kobjects when adding queues after unregister
> (without tracking the queue counts in the unregistration path we can't
> detect illegal queue additions). We could also not only warn for illegal
> uses of netdev_queue_update_kobjects but also return an error.
> 
> Another change that was discussed is to forbid ethtool ops after
> unregister. This is good, but is outside of the queue code so it might
> not solve all issues.
> 
> (I do have those two patches, warn + ethtool, in my local tree and plan
> on targeting net-next).
> 
> As you can see I'm a bit puzzled at how to fix this in the best way
> possible[3]. I think the combination of the three patches should be good
> enough, with only one sent to net as it does fix veths which IMHO is
> easier to trigger. WDYT?
> 
> [1] https://elixir.bootlin.com/linux/latest/source/drivers/net/veth.c#L222
> [2] https://elixir.bootlin.com/linux/latest/source/net/ethtool/channels.c#L175
> [3] Because the queue code does rely on external states.

Any way of fixing this is fine. If you ask me personally I'd probably
go with the ethtool fix to net and the zeroing and warn to net-next.
Unless I'm misreading and this fix does work, in which case your plan
is good, too.
