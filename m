Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9627346CC4F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhLHEYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:24:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52550 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhLHEYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:24:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E113B80F00;
        Wed,  8 Dec 2021 04:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63BCC00446;
        Wed,  8 Dec 2021 04:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638937276;
        bh=6/8+Xzld35Bp1hYJCKaK3TwtZk5k6h3TJCVD0uRlSzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fGsu2EhTd3TtPqeDzMqi1hFb+8dLjEBbUJYCEtb8EHen59iHsPwbq0XJ2ntkmyXcp
         d7BVAledUAdED5y1yFf1vzCc8qMqhl5TkvbjgrUfOOCZk9J8mrijadcpL+m1mhIQiY
         /2RcdsYrdGqpea9gpzf6ke3tp9lJYNHGTUpzuGteB/n983J7bMUXizzsVBLxWEoyaj
         XCl+bmlp5uKsB8y5A/i8tKpJWyJyo0tZsAkRyoQXWlATkqTZcQ69zU1eJXGt8ET6u9
         akctRxqQfm/4LCE9T7ksp4Su2Y5aHdqKJnwHk6I8ZpMIadOcZnVuWbmYaMN7uXGNMU
         lvxHUnpH8bRQQ==
Date:   Tue, 7 Dec 2021 20:21:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Allow parallel devlink execution
Message-ID: <20211207202114.5ce27b2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Ya8NPxxn8/OAF4cR@unreal>
References: <cover.1638690564.git.leonro@nvidia.com>
 <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Ya8NPxxn8/OAF4cR@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 09:29:03 +0200 Leon Romanovsky wrote:
> On Mon, Dec 06, 2021 at 06:00:27PM -0800, Jakub Kicinski wrote:
> > On Sun,  5 Dec 2021 10:22:00 +0200 Leon Romanovsky wrote:  
> > > This is final piece of devlink locking puzzle, where I remove global
> > > mutex lock (devlink_mutex), so we can run devlink commands in parallel.
> > > 
> > > The series starts with addition of port_list_lock, which is needed to
> > > prevent locking dependency between netdevsim sysfs and devlink. It
> > > follows by the patch that adds context aware locking primitives. Such
> > > primitives allow us to make sure that devlink instance is locked and
> > > stays locked even during reload operation. The last patches opens
> > > devlink to parallel commands.  
> > 
> > I'm not okay with assuming that all sub-objects are added when devlink
> > is not registered.  
> 
> But none of the patches in this series assume that.
> 
> In devlink_nested_lock() patch [1], I added new marker just to make sure
> that we don't lock if this specific command is called in locked context.
> 
> +#define DEVLINK_NESTED_LOCK XA_MARK_2
> 
> [1] https://lore.kernel.org/all/2b64a2a81995b56fec0231751ff6075020058584.1638690564.git.leonro@nvidia.com/

You skip locking if the marker is set. So a register operation can race
with a user space operation, right?
