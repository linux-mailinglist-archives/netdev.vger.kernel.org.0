Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C877325CBF7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgICVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgICVP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 17:15:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ACF0206CA;
        Thu,  3 Sep 2020 21:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599167728;
        bh=gZ3/VMuRXrxH7GQKc3LPU6gUeCyfH6iQWGinG1YFszw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HH7WyteLQFJx5kBRs+19Z0LjdT6D3kDOwyNoz2+6dsjojUtsXobtdffnVZM92GgZx
         75GnxHGQTQ8m39PsnGm3z7Pk4gwUBzrfCSYm2GyT7JjS7rfq6DujnNhSWZAh2HgQK5
         bkgWaPvMZ17Un3aUPyGAPwQGtshp1NJI1BEvNK1s=
Date:   Thu, 3 Sep 2020 14:15:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, andrew@lunn.ch,
        mkubecek@suse.cz, dsahern@gmail.com,
        Michael Chan <michael.chan@broadcom.com>, saeedm@mellanox.com,
        rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next] net: tighten the definition of interface
 statistics
Message-ID: <20200903141526.606e6178@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <52ad841c-c51d-f606-09e3-e757fc0d193b@gmail.com>
References: <20200903020336.2302858-1-kuba@kernel.org>
        <CAKOOJTwwZ0wug6Wn6vVmvyWX=vz_n1shu5t_Gf-NT21MP7HMxg@mail.gmail.com>
        <20200903134507.4ba426f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <52ad841c-c51d-f606-09e3-e757fc0d193b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 13:48:39 -0700 Florian Fainelli wrote:
> >>> + * @rx_bytes: Number of good incoming bytes, corresponding to @rx_packets.
> >>> + * @tx_bytes: Number of good incoming bytes, corresponding to @tx_packets.  
> >>
> >> Including or excluding FCS?  
> > 
> > Good point, no FCS is probably a reasonable expectation.
> > 
> > I'm not sure what to say about pad. I'm tempted to also mention that
> > for tx we shouldn't count pad, no? (IOW Ethernet Frame - FCS - pad)  
> 
> It depends I would say, if the driver needed to add padding in order to 
> get the frame to be transmitted because the Ethernet MAC cannot pad 
> automatically then it would seem natural to count the added padding.

Ack, I was actually hoping "modern" devices don't need this, but I was
wrong :S Looks like bnxt is padding. And Intel devices pad on RX, which
NFP used to do as well, until I removed it. Any idea why do people do
this?

> If you implement BQL that is what you will be reporting because that how 
> much travels on the wire. What do you think?

No strong preference. I'm not very concerned about BQL, it doesn't
account for other "realities" of wire transmission anyway. And I
thought it would be nice for interface stats to match Qdisc stats.
Plus feels strange putting burden on devices which do things "right".

But unless we count pad on TX we'd have an asymmetry where we expect
pad on RX but not TX. So I think you're right. Let's suggest to count
pad both ways (for Ethernet, at least).
