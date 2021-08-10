Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C063E5C4E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbhHJNyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242049AbhHJNyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9DB560C51;
        Tue, 10 Aug 2021 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628603665;
        bh=iZVe72SbKuxsmlEfQJAIxK+047leBdbzspxxFb3QTIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mwtzNQBsWp3FF0MicMHTwkCaY7xXwDSrbnA+HDswEO28Ba4sBu0YcK9o4KMd8+mW7
         fHhjZhU+EQoJW67SntsdiXkwrBvQWozAROBeCn/Y+mPnTmHJGna4wSOU0uWDJcWmdg
         yqZCXggNVEAb4CX/UEvV8sq/34kIqm6Zfj52ItMc64jpJSIrX/qM0gN9+uLAEDByJU
         WIkG7DUlSy4+B8SPs2us0TZm+oUybKJoHIei6K4A1Z2CaaUTFmTH1Xfcd/IBK3m8yH
         fFsoqx9qoPqKyueyn4yFo9teaJqedza1PsnYPhSfEDMCSAlLS+n4pA+MhBOdu1QkqO
         ROKXmGsinF29g==
Date:   Tue, 10 Aug 2021 06:54:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRJ5g/W11V0mjKHs@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-3-idosch@idosch.org>
        <YRF+a6C/wHa7+2Gs@lunn.ch>
        <YRJ5g/W11V0mjKHs@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 16:05:07 +0300 Ido Schimmel wrote:
> > Again, i'm wondering, why is user space doing the reset? Can you think
> > of any other piece of hardware where Linux relies on user space
> > performing a reset before the kernel can properly use it?
> > 
> > How long does a reset take? Table 10-1 says the reset pulse must be
> > 10uS and table 10-2 says the reset should not take longer than
> > 2000ms.  
> 
> Takes about 1.5ms to get an ACK on the reset request and another few
> seconds to ensure module is in a valid operational state (will remove
> RTNL in next version).

Hm. RTNL-lock-less ethtool ops are a little concerning. The devlink
locking was much complicated by the unclear locking rules. Can we keep
ethtool simple and put this functionality in a different API or make
the reset async?

> > So maybe reset it on ifup if it is in a bad state?  
> 
> We can have multiple ports (split) using the same module and in CMIS
> each data path is controlled by a different state machine. Given the
> complexity of these modules and possible faults, it is possible to
> imagine a situation in which a few ports are fine and the rest are
> unable to obtain a carrier.
> 
> Resetting the module on ifup of swp1s0 is not intuitive and it shouldn't
> affect other split ports (e.g., swp1s1). With the dedicated reset
> command we have the ability to enforce all the required restrictions
> from the start instead of changing the behavior of existing commands.

Sounds similar to what ethtool --reset was trying to address (upper
16 bits). Could we reuse that? Whether its a SFP or other part of the
port being reset may not be entirely important to the user, so perhaps
it's not a bad idea to abstract that away and stick to "reset levels"?
