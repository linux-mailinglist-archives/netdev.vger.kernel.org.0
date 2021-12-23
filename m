Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D39C47E745
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244701AbhLWRxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244509AbhLWRxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A9C061401;
        Thu, 23 Dec 2021 09:53:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16DE061F18;
        Thu, 23 Dec 2021 17:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB02C36AE5;
        Thu, 23 Dec 2021 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640281999;
        bh=zuRBRwr5iT82jY4jcXwCHAfBA8FmOpPZpBY8RKNWnAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A8BoNl9IrnX6NydMKn8FZVjrKtDqGqJwZKd5Q5rBoFfROKK1PXYM9z/FzV9KnKk5E
         CLrVFWhJEvbs2tpC4l811jDsp0CoSQZZpi6d+808onhfQEhoo3t5FkjDlq2P0F4o6v
         KsiCnIoEWiU8kGpkoOorwTu1rjLpNeaUFXYs+a6HR6cMi28sHxIiQe/DPgFDooJhZi
         P4wO9tK8cQWMnqUA6ucjOE10FGGgfPnK4wkvs0Smgk92jXOBs1bHpRRjmanXog9EXF
         yc2DJDQZY7ORn4yCT3snqdWRcpGh+0hxu84tnxvWRmC2I3XOFdDAbGeOd4BaiE3yKc
         sPK40tCklqjEg==
Date:   Thu, 23 Dec 2021 09:53:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl
 working in compat mode
Message-ID: <20211223095318.30d2b9ce@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <YcS25oqoo+xnAIIW@pilgrim>
References: <20211223153139.7661-1-repk@triplefau.lt>
        <20211223153139.7661-3-repk@triplefau.lt>
        <20211223085944.55b43857@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <YcS25oqoo+xnAIIW@pilgrim>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 18:50:30 +0100 Remi Pommarel wrote:
> On Thu, Dec 23, 2021 at 08:59:44AM -0800, Jakub Kicinski wrote:
> > On Thu, 23 Dec 2021 16:31:39 +0100 Remi Pommarel wrote:  
> > > In compat mode SIOC{G,S}IFBR ioctls were only supporting
> > > BRCTL_GET_VERSION returning an artificially version to spur userland
> > > tool to use SIOCDEVPRIVATE instead. But some userland tools ignore that
> > > and use SIOC{G,S}IFBR unconditionally as seen with busybox's brctl.
> > > 
> > > Example of non working 32-bit brctl with CONFIG_COMPAT=y:
> > > $ brctl show
> > > brctl: SIOCGIFBR: Invalid argument
> > > 
> > > Example of fixed 32-bit brctl with CONFIG_COMPAT=y:
> > > $ brctl show
> > > bridge name     bridge id               STP enabled     interfaces
> > > br0
> > > 
> > > Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> > > Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>  
> > 
> > Since Arnd said this is not supposed to be backported I presume it
> > should go to net-next?  
> 
> Yes, out of curiosity, is it appropriate to mix "[PATCH net]" and
> "[PATCH net-next]" in the same serie ?

It's not, mixing makes it quite hard to know what's needed where.
Also hard to automate things on our end. Let me pick out the first
patch, I'll be sending a PR to Linus shortly and then merge net into
net-next. At which point you'll be able to rebase on top of net-next
and resend just the second patch for net-next..
