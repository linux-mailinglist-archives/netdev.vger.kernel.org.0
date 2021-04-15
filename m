Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF03601EA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhDOFwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhDOFwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 01:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581E6613EB;
        Thu, 15 Apr 2021 05:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618465900;
        bh=hDc5bPIxgAjGapnGkqBQNQekaPrQ+xAflMrgS7PaiCA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=evGpwxBilND4Wecf81x5QOhOo7oYW7Dp3+dHERprWO0lGDm7uy9w/g5X+KjTjaiFQ
         APCPGXNfKGwey3qVyTemksap1bQTOvuIF5kbycWW5Jsffh/sVVDD5Hjptg35QXqyRH
         lCDPwgrHqMl0X8xa8hki2kTzqQDUX+z6lBhsGf6KL7TdcaZjRIK0mW8xle9RcVLxej
         5RZqXnyYSlq0Mdl0n7Sy5fqFCaCqx/747sPmoxLQUW8MXApnx7kK63oC9iXh7fOFyQ
         Gyrg0J4+YvIWMh5k58XNBt69A6x3S+r0ilms1S2ze8J9M74lZ3E6grEKXdVzvE+SB7
         rZBySJLiaGcuA==
Message-ID: <4425ee5839ac86270542ffa3d40cda67dc5068e1.camel@kernel.org>
Subject: Re: [RFC net-next 0/6] ethtool: add uAPI for reading standard stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, Ariel Almog <ariela@nvidia.com>
Date:   Wed, 14 Apr 2021 22:51:39 -0700
In-Reply-To: <20210414202325.2225774-1-kuba@kernel.org>
References: <20210414202325.2225774-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-14 at 13:23 -0700, Jakub Kicinski wrote:
> This series adds a new ethtool command to read well defined
> device statistics. There is nothing clever here, just a netlink
> API for dumping statistics defined by standards and RFCs which
> today end up in ethtool -S under infinite variations of names.
> 
> This series adds basic IEEE stats (for PHY, MAC, Ctrl frames)
> and RMON stats. AFAICT other RFCs only duplicate the IEEE
> stats.
> 
> This series does _not_ add a netlink API to read driver-defined
> stats. There seems to be little to gain from moving that part
> to netlink.
> 
> The netlink message format is very simple, and aims to allow
> adding stats and groups with no changes to user tooling (which
> IIUC is expected for ethtool). Stats are dumped directly
> into netlink with netlink attributes used as IDs. This is
> perhaps where the biggest question mark is. We could instead
> pack the stats into individual wrappers:
> 
>  [grp]
>    [stat] // nest
>      [id]    // u32
>      [value] // u64
>    [stat] // nest
>      [id]    // u32
>      [value] // u64
> 
> which would increase the message size 2x but allow
> to ID the stats from 0, saving strset space as well as

don't you need to translate such ids to strs in userspace ? 
I am not fond of upgrading userspace every time we add new stat.. 

Just throwing crazy ideas.. BTF might be a useful tool here! :)) 

> allow seamless adding of legacy stats to this API
which legacy stats ? 

> (which are IDed from 0).
> 
> On user space side we can re-use -S, and make it dump
> standard stats if --groups are defined.
> 
> $ ethtool -S eth0 --groups eth-phy eth-mac rmon eth-ctrl

Deja-vu, I honestly remember someone in mlnx suggsting this exact
command a couple of years ago.. :) 

> Stats for eth0:
> eth-phy-SymbolErrorDuringCarrier: 0
> eth-mac-FramesTransmittedOK: 0
> eth-mac-FrameTooLongErrors: 0
> eth-ctrl-MACControlFramesTransmitted: 0
> eth-ctrl-MACControlFramesReceived: 1
> eth-ctrl-UnsupportedOpcodesReceived: 0
> rmon-etherStatsUndersizePkts: 0
> rmon-etherStatsJabbers: 0
> rmon-rx-etherStatsPkts64Octets: 1
> rmon-rx-etherStatsPkts128to255Octets: 0
> rmon-rx-etherStatsPkts1024toMaxOctets: 1
> rmon-tx-etherStatsPkts64Octets: 1
> rmon-tx-etherStatsPkts128to255Octets: 0
> rmon-tx-etherStatsPkts1024toMaxOctets: 1
> 
> Jakub Kicinski (6):
>   docs: networking: extend the statistics documentation
>   docs: ethtool: document standard statistics
>   ethtool: add a new command for reading standard stats
>   ethtool: add interface to read standard MAC stats
>   ethtool: add interface to read standard MAC Ctrl stats
>   ethtool: add interface to read RMON stats
> 
>  Documentation/networking/ethtool-netlink.rst |  74 ++++
>  Documentation/networking/statistics.rst      |  44 ++-
>  include/linux/ethtool.h                      |  95 +++++
>  include/uapi/linux/ethtool.h                 |  10 +
>  include/uapi/linux/ethtool_netlink.h         | 134 +++++++
>  net/ethtool/Makefile                         |   2 +-
>  net/ethtool/netlink.c                        |  10 +
>  net/ethtool/netlink.h                        |   8 +
>  net/ethtool/stats.c                          | 374
> +++++++++++++++++++
>  net/ethtool/strset.c                         |  25 ++
>  10 files changed, 773 insertions(+), 3 deletions(-)
>  create mode 100644 net/ethtool/stats.c
> 


