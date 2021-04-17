Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DA03631F1
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 21:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhDQTPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 15:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230064AbhDQTPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 15:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22C9761210;
        Sat, 17 Apr 2021 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618686921;
        bh=24GHd9WWbmBz/YVUfzFJDMf/YioHrvv7V8cEu873n1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j8tmS5fM55zdSBGDLd3ac4AZEAYbyR+MQ9IhjcOaYRQGiF/ausy43dF1JfbJYxN/W
         tY40VLJGDlgCliy01B33+STFaW21vmAW36z+hRG8SSUsDClOPNhz5oihmFYiLzHPtV
         +JzWn0obYeL+v8n22zZXnB9wVVQy9vn7vdPVqNpKKF7g6JM6PzrDmGAws5Hb9Dbtni
         bhgsvdoG7CigxK2zhJeArCJxdEH2Ayr5v9TxWJX5jTRJke850vtKrJdM4xiwgyCQ7B
         3HDuQvtbNGJjs84kgLeZvpk7SngEbHNie57ggDMCY91wOF03eyPDTg0Dw2weO/nwAu
         9iblTuy7/PRQA==
Date:   Sat, 17 Apr 2021 12:15:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <20210417121520.242b0c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHsutM6vesbQq+Ju@shredder.lan>
References: <20210416192745.2851044-1-kuba@kernel.org>
        <20210416192745.2851044-4-kuba@kernel.org>
        <YHsXnzqVDjL9Q0Bz@shredder.lan>
        <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YHsutM6vesbQq+Ju@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 21:53:40 +0300 Ido Schimmel wrote:
> On Sat, Apr 17, 2021 at 11:13:51AM -0700, Jakub Kicinski wrote:
> > On Sat, 17 Apr 2021 10:57:42 -0700 Jakub Kicinski wrote:  
> > > Um, yes and now. The only places the user space puts those names 
> > > is the help message and man page.
> > > 
> > > Thru the magic of bitsets it doesn't actually interpret them, so
> > > with old user space you can still query a new group, it will just 
> > > not show up in "ethtool -h".
> > > 
> > > Is that what you're saying?  
> > 
> > FWIW ethnl_parse_bit() -> ETHTOOL_A_BITSET_BIT_NAME
> > User space can also use raw flags like --groups 0xf but that's perhaps
> > too spartan for serious use.  
> 
> So the kernel can work with ETHTOOL_A_BITSET_BIT_INDEX /
> ETHTOOL_A_BITSET_BIT_NAME, but I was wondering if using ethtool binary
> we can query the strings that the kernel will accept. I think not?

For request user space sends the strings inside the netlink message:

ethtool --debug 0xff -S eth0 --groups eth-phy eth-mac

sending genetlink packet (80 bytes):
    msg length 80 ethool ETHTOOL_MSG_STATS_GET
    ETHTOOL_MSG_STATS_GET
        ETHTOOL_A_STATS_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "eth0"
        ETHTOOL_A_STATS_GROUPS
            ETHTOOL_A_BITSET_NOMASK = true
            ETHTOOL_A_BITSET_BITS
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_NAME = "eth-phy"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_NAME = "eth-mac"

Kernel will then search the bitset and respond with:

netlink error: bit name not found

if string is not found. So upfront enumeration is not strictly
necessary.

The only way to query what will be accepted AFAIU is to query 
the string set via ETHTOOL_MSG_STRSET_GET. The string set is part 
of the uAPI:

const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN] = {
	[ETHTOOL_STATS_ETH_PHY]			= "eth-phy",
	[ETHTOOL_STATS_ETH_MAC]			= "eth-mac",
	[ETHTOOL_STATS_ETH_CTRL]		= "eth-ctrl",
	[ETHTOOL_STATS_RMON]			= "rmon",
};

	[ETH_SS_STATS_STD] = {
		.per_dev	= false,
		.count		= __ETHTOOL_STATS_CNT,
		.strings	= stats_std_names,
	},

I believe string set must have the same number of bits as the bitset,
so there's full equivalency. We could try to express the limits in a
static netlink policy one day but today parameters of the bitset are
passed in the code.

> Anyway, I'm fine with implementing '--all-groups' via
> ETHTOOL_MSG_STRSET_GET.

Cool, will do!

> We can always add a new attribute later, but I
> don't see a reason to do so.
