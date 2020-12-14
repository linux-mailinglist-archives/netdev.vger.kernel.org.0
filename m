Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB352DA1BA
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbgLNUeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503081AbgLNUdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 15:33:47 -0500
Date:   Mon, 14 Dec 2020 12:33:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607977986;
        bh=VkUl1gBcn4y6Z22aJ5Fk2NTIFgyqnb/HNnKJV9s3SGs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=BaGMS0Qblu/sYWuTV20clVZMDxz7wXcmhRbinkVQUtsWvMcgQjxQ3AQJOZlQIU38/
         jlBKR7MCrDUvQ68L4Iye5LjVv5bwll0yWyZcfbIYZP75Vy1Ccq1RMxKA2QbKXN3fyl
         xlZXIOKn3X10XCaHdZk5TJdtNuIBtAyrQlfQRVomXVceMJTBjCGw5ptbjxdVI0pufn
         i0Hu5QxnUmX4gDJ4zH1jxVB6UOVAcW8omNiV3eDuknle8AZZ6Hf4KDwrxHVgAU/d4w
         93rlcKQrftrweMleuloMqz/SxAX3iEw/sA2Qpt8RDLUZ0lPmCqjL1MH39x2AeNS2FT
         Abw4Q9XlCY+IA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20201214123305.288f49bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_CqD5kfPxXkMrNNh9TozfCCTdovMgjiS2Abf_KXxAJONA@mail.gmail.com>
References: <20201209005444.1949356-1-weiwan@google.com>
        <20201209005444.1949356-3-weiwan@google.com>
        <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_BM_H=2bhYBtJ3LtBT0DBPBeVLyuC=BRQv=H3Ww2eecWA@mail.gmail.com>
        <20201214110203.7a1e8729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CqD5kfPxXkMrNNh9TozfCCTdovMgjiS2Abf_KXxAJONA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 11:45:43 -0800 Wei Wang wrote:
> > It is quite an annoying problem to address, given all relevant NAPI
> > helpers seem to return void :/ But we're pushing the problem onto the
> > user just because of internal API structure.
> >
> > This reminds me of PTP / timestamping issues some NICs had once upon
> > a time. The timing application enables HW time stamping, then later some
> > other application / orchestration changes a seemingly unrelated config,
> > and since NIC has to reset itself it looses the timestamping config.
> > Now the time app stops getting HW time stamps, but those are best
> > effort anyway, so it just assumes the NIC couldn't stamp given frame
> > (for every frame), not that config got completely broken. The system
> > keeps running with suboptimal time for months.
> >
> > What does the deployment you're expecting to see looks like? What
> > entity controls enabling the threaded mode on a system? Application?
> > Orchestration? What's the flow?
> >  
> I see your point. In our deployment, we have a system daemon which is
> responsible for setting up all the system tunings after the host boots
> up (before application starts to run). If certain operation fails, it
> prints out error msg, and will exit with error. For applications that
> require threaded mode, I think a check to the sysfs entry to make sure
> it is enabled is necessary at the startup phase.

That assumes no workload stacking, and dynamic changes after the
workload has started? Or does the daemon have enough clever logic
to resolve config changes?

> > "Forgetting" config based on driver-dependent events feels very fragile.  
> I think we could add a recorded value in dev to represent the user
> setting, and try to enable threaded mode after napi_disable/enable.
> But I think user/application still has to check the sysfs entry value
> to make sure if it is enabled successfully.

In case of an error you're thinking of resetting, still, and returning
disabled from sysfs? I guess that's fine, we can leave failing the bad
reconfig operation (rather than resetting config) as a future extension.
Let's add a WARN_ON, tho, so the failures don't get missed.
