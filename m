Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3293E24682C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgHQOMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:12:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbgHQOMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:12:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7fsU-009jlf-Iv; Mon, 17 Aug 2020 16:12:46 +0200
Date:   Mon, 17 Aug 2020 16:12:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, amcohen@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, roopa@nvidia.com, dsahern@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/6] devlink: Add device metric
 infrastructure
Message-ID: <20200817141246.GB2291654@lunn.ch>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200817125059.193242-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817125059.193242-2-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 03:50:54PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add an infrastructure that allows device drivers to dynamically register
> and unregister their supported metrics with devlink. The metrics and
> their values are exposed to user space which can decide to group certain
> metrics together. This allows user space to request a filtered dump of
> only the metrics member in the provided group.
> 
> Currently, the only supported metric type is a counter, but histograms
> will be added in the future for devices that implement histogram agents
> in hardware.

Hi Ido, Amit

Some initial thoughts.

I said this during netdevconf, i think we need some way to group
metrics together. The example you gave was supporting the counters for
a TCAM and VXLAN offload. I expect users are wanting to get just the
TCAM counters, or just the VXLAN counters.

Maybe one way to support this is to allow the create function to pass
the group, rather than defaulting it to 0? The drive can then split
them up, if it wants to. Otherwise, provide some other sort of
identifier which can be used, maybe a hardware block name?

One big difference between this API and normal netlink statistics is
that each devlink counter is totally independent of every other
devlink counter. You cannot compare counters, because they are not
atomically read. Most hardware i come across supports snapshots of the
counters. So with the current ethtool counters, you snapshot them,
read them all into one buffer, and then return them to user space. The
rtnl lock prevents two snapshots at the same time.

	Andrew
