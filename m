Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB02132DE
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgGCEZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:25:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649D72067D;
        Fri,  3 Jul 2020 04:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593750313;
        bh=iyHe/pIZbRw4Jk11QNz9sdmCGjg9dh9AI7GKzExHdQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mvUE4GuWdIQ3ZG59OdAw41ylkoXV9042XGAGRrCuDeXDVumBlBrr+6XqGpjRpbPjr
         YT6vbXDpzOoE3xytrf2T6cIIeq1LbrHXwPgMsY/SUetvlXY7Lc7LHrqY1Gg/7jnwi2
         fQvOuj8khqlx0iEI5zOhJ9+fpqTf01jqnxo64hb4=
Date:   Thu, 2 Jul 2020 21:25:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ron Diskin <rondi@mellanox.com>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Message-ID: <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
        <20200702221923.650779-3-saeedm@mellanox.com>
        <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 03:45:45 +0000 Saeed Mahameed wrote:
> On Thu, 2020-07-02 at 18:47 -0700, Jakub Kicinski wrote:
> > On Thu,  2 Jul 2020 15:19:14 -0700 Saeed Mahameed wrote:  
> > > From: Ron Diskin <rondi@mellanox.com>
> > > 
> > > Currently the FW does not generate events for counters other than
> > > error
> > > counters. Unlike ".get_ethtool_stats", ".ndo_get_stats64" (which ip
> > > -s
> > > uses) might run in atomic context, while the FW interface is non
> > > atomic.
> > > Thus, 'ip' is not allowed to issue fw commands, so it will only
> > > display
> > > cached counters in the driver.
> > > 
> > > Add a SW counter (mcast_packets) in the driver to count rx
> > > multicast
> > > packets. The counter also counts broadcast packets, as we consider
> > > it a
> > > special case of multicast.
> > > Use the counter value when calling "ip -s"/"ifconfig".  Display the
> > > new
> > > counter when calling "ethtool -S", and add a matching counter
> > > (mcast_bytes) for completeness.  
> > 
> > What is the problem that is being solved here exactly?
> > 
> > Device counts mcast wrong / unsuitably?
> >   
> 
> To read mcast counter we need to execute FW command which is blocking,
> we can't block in atomic context .ndo_get_stats64 :( .. we have to
> count in SW. 
> 
> the previous approach wasn't accurate as we read the mcast counter in a
> background thread triggered by the previous read.. so we were off by
> the interval between two reads.

And that's bad enough to cause trouble? What's the worst case time
delta you're seeing?

> > > Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support
> > > ConnectX-4 Ethernet functionality")
> > > Signed-off-by: Ron Diskin <rondi@mellanox.com>
> > > Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>  

