Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E90332302
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 12:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfFBKdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 06:33:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50556 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfFBKdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 06:33:23 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hXNnj-0004ly-Kj; Sun, 02 Jun 2019 12:33:19 +0200
Date:   Sun, 2 Jun 2019 12:33:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [net-next PATCH] net: rtnetlink: Enslave device before bringing
 it up
Message-ID: <20190602103319.GJ31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        dsahern@gmail.com
References: <20190529135120.32241-1-phil@nwl.cc>
 <20190531.142615.403782868688096350.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531.142615.403782868688096350.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, May 31, 2019 at 02:26:15PM -0700, David Miller wrote:
> From: Phil Sutter <phil@nwl.cc>
> Date: Wed, 29 May 2019 15:51:20 +0200
> 
> > Unlike with bridges, one can't add an interface to a bond and set it up
> > at the same time:
> > 
> > | # ip link set dummy0 down
> > | # ip link set dummy0 master bond0 up
> > | Error: Device can not be enslaved while up.
> > 
> > Of all drivers with ndo_add_slave callback, bond and team decline if
> > IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
> > immediately up again) and the others just don't care.
> > 
> > Support the common notion of setting the interface up after enslaving it
> > by sorting the operations accordingly.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> What about other flags like IFF_PROMISCUITY?

Crap, that's the crux: Upon enslaving, team driver propagates
IFF_PROMISC and IFF_ALLMULTI flags from master to slave. With my change,
these propagations roll back by accident. So please disregard this
patch, I'll have to find a different solution.

Thanks, Phil
