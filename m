Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535962690AF
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgINPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgINPxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 11:53:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF72208DB;
        Mon, 14 Sep 2020 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600098789;
        bh=fwvf9APRIHcpFPUQ6bGOOXgVd4ceOq903toa/SaMpac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n5QngFKuQEmf7bjNZh5456/BM3IBXgHWtlHIwgQeyq0Vwc45nMymLhzIIY9/RbN4k
         L33aihsq2URcghYITjSJDroXdXyrlVppp2F23rBTAu4zEWDEvaznjt5i0CZ9yNrrUt
         8KtQuBCXI3u0DTVlIr9P1u9NlLtYQAnRStjdc/fg=
Date:   Mon, 14 Sep 2020 08:53:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912001542.fqn2hcp35xkwqoun@skbuf>
        <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 19:54:11 -0700 Florian Fainelli wrote:
> > I think I'm missing the problem you're trying to describe.
> > Are you making a general comment / argument on ethtool stats?
> > 
> > Pause stats are symmetrical - as can be seen in your quote
> > what's RX for the CPU is TX for the switch, and vice versa.
> > 
> > Since ethtool -A $cpu_mac controls whether CPU netdev generates
> > and accepts pause frames, correspondingly the direction and meaning
> > of pause statistics on that interface is well defined.
> > 
> > You can still append your custom CPU port stats to ethtool -S or
> > debugfs or whatnot, but those are only useful for validating that
> > the configuration of the CPU port is not completely broken. Otherwise
> > the counters are symmetrical. A day-to-day user of the device doesn't
> > need to see both of them.  
> 
> It would be a lot easier to append the stats if there was not an 
> additional ndo introduce to fetch the pause statistics because DSA 
> overlay ndo on a function by function basis. Alternatively we should 
> consider ethtool netlink operations over a devlink port at some point so 
> we can get rid of the ugly ndo and ethtool_ops overlay that DSA does.

I'm trying to target the 99.9% of users here, so in all honesty I'm
concerned that if we try to cater to strange corner cases too much 
the entire interface will suffer. Hence I decided not to go with
devlink, but extend the API people already know and use. It's the most
logical and obvious place to me.

> Can we consider using get_ethtool_stats and ETH_SS_PAUSE_STATS as a 
> stringset identifier? That way there is a single point within driver to 
> fetch stats.

Can you say more? There are no strings reported in this patch set.
