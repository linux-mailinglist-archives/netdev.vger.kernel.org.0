Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8C81CFDFB
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbgELTI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:08:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:34620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730610AbgELTI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 15:08:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6683FAF9F;
        Tue, 12 May 2020 19:08:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E7954604F3; Tue, 12 May 2020 21:08:55 +0200 (CEST)
Date:   Tue, 12 May 2020 21:08:55 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200512190855.GB9071@lion.mk-sys.cz>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 11:31:39AM -0700, Doug Berger wrote:
> On 5/11/2020 5:47 PM, Andrew Lunn wrote:
> > On Mon, May 11, 2020 at 05:24:07PM -0700, Doug Berger wrote:
> >> A comment in uapi/linux/ethtool.h states "Drivers should reject a
> >> non-zero setting of @autoneg when autoneogotiation is disabled (or
> >> not supported) for the link".
> >>
> >> That check should be added to phy_validate_pause() to consolidate
> >> the code where possible.
> >>
> >> Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")
> > 
> > Hi Doug
> > 
> > If this is a real fix, please submit this to net, not net-next.
> > 
> >    Andrew
> > 
> This was intended as a fix, but I thought it would be better to keep it
> as part of this set for context and since net-next is currently open.
> 
> The context is trying to improve the phylib support for offloading
> ethtool pause configuration and this is something that could be checked
> in a single location rather than by individual drivers.
> 
> I included it here to get feedback about its appropriateness as a common
> behavior. I should have been more explicit about that.
> 
> Personally, I'm actually not that fond of this change since it can
> easily be a source of confusion with the ethtool interface because the
> link autonegotiation and the pause autonegotiation are controlled by
> different commands.
> 
> Since the ethtool -A command performs a read/modify/write of pause
> parameters, you can get strange results like these:
> # ethtool -s eth0 speed 100 duplex full autoneg off
> # ethtool -A eth0 tx off
> Cannot set device pause parameters: Invalid argument
> #
> Because, the get read pause autoneg as enabled and only the tx_pause
> member of the structure was updated.

This would be indeed unfortunate. We could use extack to make the error
message easier to understand but the real problem IMHO is that
ethtool_ops::get_pauseparam() returns value which is rejected by
ethtool_ops::set_pauseparam(). This is something we should avoid.

If we really wanted to reject ethtool_pauseparam::autoneg on when
general autonegotiation is off, we would have to disable pause
autonegotiation whenever general autonegotiation is disabled. I don't
like that idea, however, as that would mean that

  ethtool -s dev autoneg off ...
  ethtool -s dev autoneg on ...

would reset the setting of pause autonegotiation.

Therefore I believe the comment should be rather replaced by a warning
that even if ethtool_pauseparam::autoneg is enabled, pause
autonegotiation is only active if general autonegotiation is also
enabled.

Michal
