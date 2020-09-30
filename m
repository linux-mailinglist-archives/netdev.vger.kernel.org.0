Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE0827EBC3
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgI3PDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:03:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:35942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgI3PDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:03:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B718EAB8F;
        Wed, 30 Sep 2020 15:03:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4D31C60787; Wed, 30 Sep 2020 17:03:20 +0200 (CEST)
Date:   Wed, 30 Sep 2020 17:03:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: ethtool/phy tunables and extack (was Re: [PATCH net-next 0/3] net:
 atlantic: phy tunables from mac driver)
Message-ID: <20200930150320.6rluu7ywt5iqj5qj@lion.mk-sys.cz>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929170413.GA3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929170413.GA3996795@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 07:04:13PM +0200, Andrew Lunn wrote:
> On Tue, Sep 29, 2020 at 07:13:04PM +0300, Igor Russkikh wrote:
> > This series implements phy tunables settings via MAC driver callbacks.
> > 
> > AQC 10G devices use integrated MAC+PHY solution, where PHY is fully controlled
> > by MAC firmware. Therefore, it is not possible to implement separate phy driver
> > for these.
> > 
> > We use ethtool ops callbacks to implement downshift and EDPC tunables.
> 
> Hi Michal
> 
> Do you have any code to implement tunables via netlink?

I already tried to open a discussion about tunables once but it somehow
died before we got somewhere and I'm not sure I was fully understood
then.

My view is that tunables (both the "ethtool" ones and PHY tunables) were
a workaround for lack of extensibility of the ioctl interface where
adding a new parameter to existing command was often impossible while
adding a tunable was relatively easy. But the implementation doesn't
really scale well so a rework would be necessary if the number of
tunables were to grow to the order of tens. Moreover, recently it
surfaced that while we have type id for string tunables, nobody seems to
know how exactly are they supposed to work.

With netlink, we can add new attributes easily and I don't see much
advantage in adding more tunables (assorted heap of unrelated values)
over adding either attributes to existing commands or new commands (for
new types of information or settings). PHY tunables could be probably
grouped into one command. Rx and Tx copybreak could belong together as
"skb handling parameters" (?) and I've seen someone proposing another
parameter (IIRC related to head split) which would also belong there.
I'm not sure about ETHTOOL_PFC_PREVENTION_TOUT.

What would IMHO justify a similar concept to current tunables would be
device (driver) specific tunables, i.e. generalization of private flags
to other data types. But as I said before, I'm not sure if we want such
feature as it would be probably too tempting to abuse by NIC vendors.

> This code is defining new ethtool calls. It seems like now would be a
> good time to plumb in extack, so the driver can report back the valid
> range of a tunable when given an unsupported value.

Adding an extack pointer to new ethtool ops seems like the most natural
solution. For existing ethtool ops, David Miller suggested that as all
of them are called under RTNL lock (and we cannot easily git rid of it
after many years of such guarantee), we could in fact use a global
variable. Or maybe rather a helper function.

Another question is how to allow ethtool ops setting not only the text
message but also the offending attribute. So far the idea I was able to
come with is that the ethtool_ops callback could set one (or two in case
of nested requests, we probably won't need more) integers to identify
the attribute (or top level and nested) and caller would translate them
to a pointer into the request message.

Michal
