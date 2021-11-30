Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265774628D0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhK3AI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:08:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhK3AI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 19:08:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4P0z8N/3qJvQlU8wydMNV/NzIppol0JDzfC2zI6T0xI=; b=dOg8S6KNMM3xEnP7SdruM6G+IO
        ZEJFPGwi/l3nt4UbFXiwRn/NqC19emQXepX21uMSB1bCRMprh5i1SFmoa4rVgueWkQO8SVXRt50QW
        H5HFTVvTXV+IC08DCO2Jr5lLfZDQ93QHy5Ge495G/+R4Kl1OKAeMl2/GL+uYpL3r7JY0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrqdw-00Eyn7-BV; Tue, 30 Nov 2021 01:05:08 +0100
Date:   Tue, 30 Nov 2021 01:05:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 3/4] ethtool: Add ability to flash
 transceiver modules' firmware
Message-ID: <YaVqtD0pOKdrC9X0@lunn.ch>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211127174530.3600237-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211127174530.3600237-4-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 07:45:29PM +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> CMIS complaint modules such as QSFP-DD might be running a firmware that
> can be updated in a vendor-neutral way by exchanging messages between
> the host and the module as described in section 7.3.1 of revision 5.0 of
> the CMIS standard.
> 
> Add a pair of new ethtool messages that allow:
> 
> * User space to trigger firmware update of transceiver modules
> 
> * The kernel to notify user space about the progress of the process
> 
> The user interface is designed to be asynchronous in order to avoid RTNL
> being held for too long and to allow several modules to be updated
> simultaneously. The interface is designed with CMIS complaint modules in
> mind, but kept generic enough to accommodate future use cases, if these
> arise.

Hi Ido

What i'm missing is some sort of state machine to keep track of the
SFP. Since RTNL is not held other operations could be performed in
parallel. Does CMIS allow this? Can you intermix firmware writes with
reading the temperature sensor for hwmon? Poll the LOS indicator to
see if the link has been lost?

With cable testing, phylib already has a state machine, and i added a
new state for cable test running. If any other operation happened
which would cause a change out of this state, like ifdown, or a
request to restart autoneg, the cable test is aborted first.

    Andrew
