Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D032E3631AF
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbhDQR6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhDQR6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 13:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E335613B0;
        Sat, 17 Apr 2021 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618682263;
        bh=mEPJFY5iUS+A2qv1Ly11iClNStgEqSIFIr4M5MOW+As=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YouBvaNyY3O5Yr4U7zCMEAZOFUYlmqffMP5nl8z9ODjVHn6R5u5tXftzA6HiPNfdP
         cIQmgJf9QaKnmJfsdID+KX8n0OOVAX5Ge+E2PtevWkhzF3K/xf//4XbgmIfLYCI+q8
         buRcK7+hg/otcI8NAXmi1OQWCRoyyjq4I+CEVkEahc0LgT9kwnSvYT7VF4Gq1HWZ+I
         nya18Z3xjosYniF7Cv06+IHsQeo2ODLkhMXYIbkDPCgSL2eeWTz+ZNUASotH36qLTR
         abIo5FOEC144KfcTiajNBwmNNJcLREa5wL5E84CusUIEIKFpidomxa0bornhyM4Zp1
         jyt2FJ1ARAkOw==
Date:   Sat, 17 Apr 2021 10:57:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHsXnzqVDjL9Q0Bz@shredder.lan>
References: <20210416192745.2851044-1-kuba@kernel.org>
        <20210416192745.2851044-4-kuba@kernel.org>
        <YHsXnzqVDjL9Q0Bz@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 20:15:11 +0300 Ido Schimmel wrote:
> On Fri, Apr 16, 2021 at 12:27:39PM -0700, Jakub Kicinski wrote:
> > Add an interface for reading standard stats, including
> > stats which don't have a corresponding control interface.
> > 
> > Start with IEEE 802.3 PHY stats. There seems to be only
> > one stat to expose there.
> > 
> > Define API to not require user space changes when new
> > stats or groups are added. Groups are based on bitset,
> > stats have a string set associated.  
> 
> I tried to understand how you add new groups without user space
> changes and I think this statement is not entirely accurate.
> 
> At minimum, user space needs to know the names of these groups, but
> currently there is no way to query the information, so it's added to
> ethtool's help message:
> 
> ethtool [ FLAGS ] -S|--statistics DEVNAME       Show adapter statistics       
>        [ --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]

Um, yes and now. The only places the user space puts those names 
is the help message and man page.

Thru the magic of bitsets it doesn't actually interpret them, so
with old user space you can still query a new group, it will just 
not show up in "ethtool -h".

Is that what you're saying?

> I was thinking about adding a new command (e.g.,
> ETHTOOL_MSG_STATS_GROUP_GET) to query available groups, but maybe it's
> an overkill. How about adding a new flag to ethtool:
> 
> ethtool [ FLAGS ] -S|--statistics DEVNAME       Show adapter statistics       
>        [ { --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] | --all-groups } ]
> 
> Which will be a new flag attribute (e.g., ETHTOOL_A_STATS_ALL_GROUPS) in
> ETHTOOL_MSG_STATS_GET. Kernel will validate that
> ETHTOOL_A_STATS_ALL_GROUPS and ETHTOOL_A_STATS_GROUPS are not passed
> together.

We don't need any new API, user space can just query the string set 
(ETH_SS_STATS_STD) and each string there corresponds to a bit.
Would that work our you think that's not clean enough?

> It's not the end of the world to leave it as-is, but the new flag will
> indeed allow you to continue using your existing ethtool binary when
> upgrading the kernel and still getting all the new stats.
> 
> Actually, if we ever get an exporter to query this information, it will
> probably want to use the new flag instead of having to be patched
> whenever a new group is added.

I like the idea of --all-groups, I'll add that to user space if you're
okay with doing it based on the strset. Or can add the new flag attr if
you prefer.

Unfortunately I did not come up with any way to auto-update the man
page which is a slight bummer.
