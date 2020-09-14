Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA662695B7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgINThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgINTgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 15:36:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92240207EA;
        Mon, 14 Sep 2020 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600112212;
        bh=pxv1uXuYl8EUrraIlhcpOU/GbISO0zTf7ojuacw8pWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uwTG3olAp2usy9MHPgC4jYNLj+dPDS/zdsqIAVGBiUiBVdhSsrJO9ASWPG2QEFv+c
         /XLjue1opFtFGU5OGKOQ+v6Vl77KU9Gk43PUrX2GtCxR6PPHI7SUA0otTADzpppcci
         /jy/sNVAuivYuzrLD52nQvfpGybmruODRT48TeDo=
Date:   Mon, 14 Sep 2020 12:36:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914123649.101ac84f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914172829.GC3485708@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911234932.ncrmapwpqjnphdv5@skbuf>
        <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912001542.fqn2hcp35xkwqoun@skbuf>
        <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200912071612.cq7adzzxxgpcauux@skbuf>
        <20200914091518.0bcf0d58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200914172829.GC3485708@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 19:28:29 +0200 Andrew Lunn wrote:
> On Mon, Sep 14, 2020 at 09:15:18AM -0700, Jakub Kicinski wrote:
> > On Sat, 12 Sep 2020 10:16:12 +0300 Vladimir Oltean wrote:
> > I never used a DSA device. But I was under the impression they were
> > supposed to be modeled like separate NICs..  
> 
> The front panel ports are. However there are other types of ports as
> well. You have at least one port of the switch connected to the SoC,
> so the SoC can send/receive frames. This is the so called CPU port of
> the switch. And Marvell switches support connecting switch ports
> together to form a cluster of switches. These are the so called DSA
> ports of the switch. Neither CPU nor DSA ports have a netdev, since
> they are internal plumbing.
> 
> > Stats on the "CPU port" should be symmetrical with the CPU MAC.  
> 
> If things are working as expected. But pause is configurable per
> MAC. It could be one end has been configured to asym pause, and the
> other to pause. It could be one end is configured to asym pause, and
> the other end is failing to autoneg, etc. Just seeing that the stats
> are significantly different is a good clue something is up.

Andrew, I appreciate DSA's complexities, but those are inherent to 
the lack of netdevs. Nobody raised an eyelid when pause config was
converted to ethtool-nl, why are the statistics a problem?

I'm adding an interface for monitoring daemons to use. sigar, zabbix,
whatever. For those being able to query pause frames or FEC errors of
real ports is important. 

Pauses on internal DSA ports are a different beast. If the monitoring
dashboard starts listing internal DSA ports alongside real netdevs
users will see them as ports, and wonder where the netdevs are.
