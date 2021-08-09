Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A9F3E4CBE
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhHITOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:14:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235487AbhHITOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 15:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pdPS4DbsQlHRcVGdr/bFR6yIluGur1+FIkgpBCAj+pI=; b=mRss+3ZYNrxfQ1se3Jf1E6HDRY
        n7L4w2LV3WK/pM5WhK9/uH2q9V0idSS8VIw3g6BeK8GqCiYOmE4f9nEAOwxI2bQcjJ09AAU2V+0NQ
        Y9Q8PH8e25F5p+xnqqtSuKQmCFtHkJagagmGp04FE8+jAS57XTWBxiX+cQNFJ0j+QWng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDAiZ-00GlVC-AS; Mon, 09 Aug 2021 21:13:47 +0200
Date:   Mon, 9 Aug 2021 21:13:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <YRF+a6C/wHa7+2Gs@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809102152.719961-3-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:21:46PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add a new ethtool message, 'ETHTOOL_MSG_MODULE_RESET_ACT', which allows
> user space to request a reset of transceiver modules. A successful reset
> results in a notification being emitted to user space in the form of a
> 'ETHTOOL_MSG_MODULE_RESET_NTF' message.
> 
> Reset can be performed by either asserting the relevant hardware signal
> ("Reset" in CMIS / "ResetL" in SFF-8636) or by writing to the relevant
> reset bit in the module's EEPROM (page 00h, byte 26, bit 3 in CMIS /
> page 00h, byte 93, bit 7 in SFF-8636).
> 
> Reset is useful in order to allow a module to transition out of a fault
> state. From section 6.3.2.12 in CMIS 5.0: "Except for a power cycle, the
> only exit path from the ModuleFault state is to perform a module reset
> by taking an action that causes the ResetS transition signal to become
> TRUE (see Table 6-11)".
> 
> To avoid changes to the operational state of the device, reset can only
> be performed when the device is administratively down.
> 
> Example usage:
> 
>  # ethtool --reset-module swp11
>  netlink error: Cannot reset module when port is administratively up
>  netlink error: Invalid argument
> 
>  # ip link set dev swp11 down
> 
>  # ethtool --reset-module swp11
> 
> Monitor notifications:
> 
>  $ ethtool --monitor
>  listening...
> 
>  Module reset done for swp11

Again, i'm wondering, why is user space doing the reset? Can you think
of any other piece of hardware where Linux relies on user space
performing a reset before the kernel can properly use it?

How long does a reset take? Table 10-1 says the reset pulse must be
10uS and table 10-2 says the reset should not take longer than
2000ms. So maybe reset it on ifup if it is in a bad state?

I assume the driver/firmware is monitoring the SFP and if it goes into
a state which requires a reset it indicates carrier down? Wasn't there
some patches which added link down reasons? It would make sense to add
enum ethtool_link_ext_substate_sfp_fault? You can then use ethtool to
see what state the module is in, and a down/ip should reset it?

    Andrew
