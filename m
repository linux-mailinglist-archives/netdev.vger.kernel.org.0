Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD402695E1
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgINTwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgINTwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 15:52:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 882B7207EA;
        Mon, 14 Sep 2020 19:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600113132;
        bh=MicLmGXft+HdG4bCr7FTJ6ZjGkwsH7vXvagEsZpmBhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D5tGmD5BzTlkSKtNburxNMbI5OCI9X7o5HZp0A9uyZfrcInXXQrmburLCklAQO1gY
         rupXTFOzGgH1Mmn3OISbNqKg2PM50L/7IhWUlFZRn7e+n9BDHBTOeyzna5voLEJL58
         m89eLgPkllPKOd9Nxc6ox5PKGkDJPPUpLrLcv/Mw=
Date:   Mon, 14 Sep 2020 12:52:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Tariq Toukan <tariqt@nvidia.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/8] docs: net: include the new ethtool
 pause stats in the stats doc
Message-ID: <20200914125210.3b230a32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1ee0f0af5fc15236689028a95ea25082138a6ebd.camel@nvidia.com>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911232853.1072362-3-kuba@kernel.org>
        <1ee0f0af5fc15236689028a95ea25082138a6ebd.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 19:33:08 +0000 Saeed Mahameed wrote:
> > +Protocol-specific statistics
> > +----------------------------
> > +
> > +Some of the interfaces used for configuring devices are also able
> > +to report related statistics. For example ethtool interface used
> > +to configure pause frames can report corresponding hardware
> > counters::
> > +
> > +  $ ethtool --include-statistics -a eth0
> > +  Pause parameters for eth0:
> > +  Autonegotiate:	on
> > +  RX:			on
> > +  TX:			on
> > +  Statistics:
> > +    tx_pause_frames: 1
> > +    rx_pause_frames: 1
> > +  
> 
> this will require to access the HW twice per stats request to read both
> stats and current parameters, maybe this is not a big deal, but sharp
> accuracy can be important for some performance enthusiasts.
> 
> Do we need an API that only reports statistics without the current
> parameters ?

That crossed my mind. IDK how real this concern is if we have ethtool
-S which dumps half of the universe and nobody ever done anything
about it..

Once we start adding more interfaces (as I said elsewhere I plan to add
FEC counters) we'll also have to do multiple calls for multiple types
of stats. But I think that's fine as a starting point. We can extend
RTM_GETSTATS to provide an efficient interface when needed.

As you may recall a couple years back I posted a set with "hierarchical
stats" which as an attempt to solve all the problems at once. 
I concluded that it's a wrong approach. We should start with the simple
and obvious stuff. We can build complexity later.
