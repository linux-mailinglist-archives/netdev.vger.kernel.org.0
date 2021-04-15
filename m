Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813B4361697
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhDOXxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234735AbhDOXxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC8E061074;
        Thu, 15 Apr 2021 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618530765;
        bh=Xu6r+A/Pb5IULkEYH+CQcufajrbH4zbBOcy5iAVNh/A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Anle2IzmG+yHjfUIPaxRq1xr2UfWetjza9ep46xFOtyQoDADWVuQSMOFBJEX43HBB
         HFfilqnuxEocDIoMumLMN7hXjOvCM61y/ofwfA+pl55bV22O1vfdQogkUWSbD0XSVp
         L9jrheSeqrOPn6KVcMIBVq9xm/o5J3EIJ4hpZ3OUi8ukCZaoW/STpXHHVFiYDBVQ+9
         ls7Y8DNNo5eQM6HEs+o9HwEjUnI5Ip0rWZW9qpPgfM6l220lX1n+i8oHA/v37IiAoz
         9Jvpqf3iJWsSBbUlh6m/0U6Cxsw4IPCWp6ms7PrE097q8SF0HZ67eq3+/RUJm+0TAO
         xnoBiSpugNJZg==
Message-ID: <27df679a1307131b8f515435f0991f185d72c4fa.camel@kernel.org>
Subject: Re: [RFC net-next 4/6] ethtool: add interface to read standard MAC
 stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com
Date:   Thu, 15 Apr 2021 16:52:44 -0700
In-Reply-To: <20210415160556.1b4f32b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210414202325.2225774-1-kuba@kernel.org>
         <20210414202325.2225774-5-kuba@kernel.org>
         <335639a79d72cec4abb3775bc84336f8390a57b7.camel@kernel.org>
         <20210415083837.6dfc0af9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <7e82c145335a2cdd080cf9bcb731a315ca317fb3.camel@kernel.org>
         <20210415160556.1b4f32b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-15 at 16:05 -0700, Jakub Kicinski wrote:
> On Thu, 15 Apr 2021 15:46:52 -0700 Saeed Mahameed wrote:
> > > > best practice here is to centralize all the data structures and
> > > > information definitions in one place, you define the stat id,
> > > > string,
> > > > and value offset, then a generic loop can generate the strset
> > > > and
> > > > fill
> > > > up values in the correct offset.
> > > > 
> > > > similar implementation is already in mlx5:
> > > > 
> > > > see pport_802_3_stats_desc:
> > > >   
> > > > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c#L682
> > > > 
> > > > the "pport_802_3_stats_desc" has a description of the strings
> > > > and
> > > > offsets of all stats in this stats group
> > > > and the fill/put functions are very simple and they just
> > > > iterate
> > > > over
> > > > the array/group and fill up according to the descriptor.  
> > > 
> > > We can maybe save 60 lines if we generate stats_eth_mac_names 
> > > in a initcall, is it really worth it? I prefer the readability 
> > > / grepability.  
> > 
> > I don't think readability will be an issue if the infrastructure is
> > generic enough.. 
> > 
> > This just a preference, of course you can go with the current code.
> > My point is that someone doesn't need to change multiple places and
> > possibly files every time they need to expose a new stat, you just
> > update some central database of the new data you want to expose.
> 
> Understood, I've written those table-based generators for ethtool
> stats
> in the drivers in the past as well, but here we can only generate the
> dumping and the names. We'll need to manually fill in defines/enums
> in
> uAPI, struct members and the generator table. I'd rather stick to
> real struct members in the core<->driver API than indexing an array
> with an enums. So the savings are 4 places => 3 places?
> 
> Unless I'm missing some clever, yet robust and readable ways of
> coding
> this up..
> 
> Can we leave as is as starting point and see where we go from here?
> So far MAC stats are the only sizable ones were we'd see noticeable
> gain.

Sure ! if we see it is exploding with stats and long if conditions, we
can reconsider :) .. 



