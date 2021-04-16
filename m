Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E64362531
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 18:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239937AbhDPQIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 12:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238368AbhDPQIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 12:08:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846A16113D;
        Fri, 16 Apr 2021 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618589297;
        bh=LmTEAeignnprSJzh6UuWt7Lm13WE4iW0URmF55YDyPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ixlPpLfUMUvypv7+VA+MDKLoUM0ezQTZariTOrBYQlzNHd6yc2GnI92R/n1+ksqdu
         fJ+L56OZq9K7FS7h88EnYdJ52+mh+yHtPkz/OFd8qoFaySio6LJnqunA5EPB86hCD3
         hK7ytIdtiUWb1AiUqkvJbrKrelgtBzyvrBy6CI1Q4oJe+zeE5iUR17WS99ZaTj5rfA
         u6LQtVZz4SGYzkqCxis3rmZRwAZOemowwv08P7CPxfFQetoDQ1tAfuRvUhfzM9Gg2F
         riv/vFOMXiWrXPDRAOAZoSACi24VdagXLIgvm2iSiP+B85ml8+rrscgn/cf61i/MLS
         GV8NIB7Ra57JQ==
Date:   Fri, 16 Apr 2021 09:08:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next 0/9] ethtool: add uAPI for reading standard
 stats
Message-ID: <20210416090816.3f805b96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHmw2tmhFGWFTzPo@shredder.lan>
References: <20210416022752.2814621-1-kuba@kernel.org>
        <YHmw2tmhFGWFTzPo@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 18:44:26 +0300 Ido Schimmel wrote:
> On Thu, Apr 15, 2021 at 07:27:43PM -0700, Jakub Kicinski wrote:
> > Continuing the effort of providing a unified access method
> > to standard stats, and explicitly tying the definitions to
> > the standards this series adds an API for general stats
> > which do no fit into more targeted control APIs.
> > 
> > There is nothing clever here, just a netlink API for dumping
> > statistics defined by standards and RFCs which today end up
> > in ethtool -S under infinite variations of names.
> > 
> > This series adds basic IEEE stats (for PHY, MAC, Ctrl frames)
> > and RMON stats. AFAICT other RFCs only duplicate the IEEE
> > stats.
> > 
> > This series does _not_ add a netlink API to read driver-defined
> > stats. There seems to be little to gain from moving that part
> > to netlink.
> > 
> > The netlink message format is very simple, and aims to allow
> > adding stats and groups with no changes to user tooling (which
> > IIUC is expected for ethtool).
> > 
> > On user space side we can re-use -S, and make it dump
> > standard stats if --groups are defined.  
> 
> Jakub, do you have a link for the user space patches? I would like to
> test it with mlxsw given you already patched it (thanks!).

Done!

> > $ ethtool -S eth0 --groups eth-phy eth-mac eth-ctrl rmon  
> 
> Given that you have now standardized these stats, do you plan to feed
> them into some monitoring system? 

Yes and no, I'm only intending to replace the internal FB ethtool
scraping script with these stats..

> For example, Prometheus has an ethtool
> exporter [1] and now I see that support is also being added to
> node_exporter [2] where it really belongs. They obviously mentioned [3]
> the problem with lack of standardization: "There is also almost no
> standardization, so if you use multiple network card vendors, you have
> to examine the data closely to find out what is useful to you and set up
> your alerts and dashboards accordingly."
> 
> [1] https://github.com/Showmax/prometheus-ethtool-exporter
> [2] https://github.com/prometheus/node_exporter/pull/1832
> [3] https://tech.showmax.com/2018/11/scraping-ethtool-data-into-prometheus/
 
Wow, are you working with those projects? We should probably let them
know about the patches.
