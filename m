Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859FE23CFDB
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgHETZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:25:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbgHERO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 13:14:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k3JFE-008NAi-1O; Wed, 05 Aug 2020 15:14:12 +0200
Date:   Wed, 5 Aug 2020 15:14:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilia Lin <ilia.lin@kernel.org>
Cc:     David Miller <davem@davemloft.net>, ilial@codeaurora.org,
        kuba@kernel.org, jiri@mellanox.com, edumazet@google.com,
        ap420073@gmail.com, xiyou.wangcong@gmail.com, maximmi@mellanox.com,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dev: Add API to check net_dev readiness
Message-ID: <20200805131412.GA1960434@lunn.ch>
References: <1595792274-28580-1-git-send-email-ilial@codeaurora.org>
 <20200726194528.GC1661457@lunn.ch>
 <20200727.103233.2024296985848607297.davem@davemloft.net>
 <CA+5LGR1KwePssqhCkZ6qT_W87fO2o1XPze53mJwjkTWtphiWrA@mail.gmail.com>
 <20200804192435.GG1919070@lunn.ch>
 <CA+5LGR32kKvaeDnb4qpGS_f=t-U4dDCYpnVy7R9zgAQCJW6jtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5LGR32kKvaeDnb4qpGS_f=t-U4dDCYpnVy7R9zgAQCJW6jtA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Well, until the user of this new API is ready, we will not accept the
> > patch.
> OK, but once we submit the change in the driver, is it good to go?

No. You really do need to explain why it is needed, and why it is
safe.

> > You also need to explain "For HW performance reasons". Why is this
> > driver special that it can do things which no over driver does?
> There are very strict KPI requirements. E.g. automotive rear mirror
> must be online 3 sec since boot.

Which does not explain why this driver is special. What you really
should be thinking about is having the required drivers for this use
case built in, and the rest as modules. Get your time critical parts
running, and then load the rest of the driver moduless and kick off
additional user space in a second phase.

You are breaking all sorts of assumptions by loading network drivers
before the stack is ready. You need to expect all sorts of nasty bugs.
If this was just in your vendor kernel, we would not care too much, it
is your problem to solve. But by doing this in mainline, you are
setting a precedent for others to do it as well. And then we really do
need to care about the broken assumptions. I doubt we are ready to
allow this.

      Andrew
