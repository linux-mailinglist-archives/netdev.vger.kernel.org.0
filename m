Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED892358F1E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhDHVZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDHVZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:25:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56982610E7;
        Thu,  8 Apr 2021 21:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617917146;
        bh=4kxd+r4EzHM/+hO4g00BIA8ng7JGCbaMzCEU9M2qhsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MD9rmvyjCIMEQfS1PupFDn4TDUuL8jceoDoyknTv/Mroed2Og9b8D5UR0GUAecZe9
         ntn7I7+OPFBMVFsfBN1AmPtAhdoO2+afwbi6OGULhZKrT6MbZJPEUaOMh7SMR7B0lm
         djOOHBVYdr0SVgg6p6mHPRhvQb27bCXHJZKAPHEPMW2BkfjtX41yNiYBqtS3hZJGq5
         5jr4DKN0IMOBlB0hDPoOWWythIQs02R9mEmhcFn7VLUKmNr1zJW1eW1N+thg7MiG/W
         N+2HouRM2ELPNLB7fv4zPYlwY3Epn9AuQ6NAAFw40CPIW1LdDHI1Nca6gaVQJobRG7
         yflPUJpqWQw9A==
Date:   Thu, 8 Apr 2021 14:25:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
Message-ID: <20210408142545.1a6424e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
        <20210408133829.2135103-2-petrm@nvidia.com>
        <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Apr 2021 10:05:07 -0400 Jamal Hadi Salim wrote:
> On 2021-04-08 9:38 a.m., Petr Machata wrote:
> > The TC action "trap" is used to instruct the HW datapath to drop the
> > matched packet and transfer it for processing in the SW pipeline. If
> > instead it is desirable to forward the packet and transferring a _copy_ to
> > the SW pipeline, there is no practical way to achieve that.
> > 
> > To that end add a new generic action, trap_fwd. In the software pipeline,
> > it is equivalent to an OK. When offloading, it should forward the packet to
> > the host, but unlike trap it should not drop the packet.
> 
> I am concerned about adding new opcodes which only make sense if you
> offload (or make sense only if you are running in s/w).
> 
> Those opcodes are intended to be generic abstractions so the dispatcher
> can decide what to do next. Adding things that are specific only
> to scenarios of hardware offload removes that opaqueness.
> I must have missed the discussion on ACT_TRAP because it is the
> same issue there i.e shouldnt be an opcode. For details see:
> https://people.netfilter.org/pablo/netdev0.1/papers/Linux-Traffic-Control-Classifier-Action-Subsystem-Architecture.pdf
> 
> IMO:
> It seems to me there are two actions here encapsulated in one.
> The first is to "trap" and the second is to "drop".
> This is no different semantically than say "mirror and drop"
> offload being enunciated by "skip_sw".
> 
> Does the spectrum not support multiple actions?
> e.g with a policy like:
>   match blah action trap action drop skip_sw

To make sure I understand - are you saying that trap should become 
more general and support both "and then drop" as well as "and then 
pass" semantics?

Seems like that ship has sailed, but also - how does it make it any
better WRT not having HW only opcodes? Or are you saying one is better
than two?
