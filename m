Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ABD44AFBE
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbhKIOwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232967AbhKIOwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:52:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC5F600CC;
        Tue,  9 Nov 2021 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636469364;
        bh=ZUUw0hG0gNScdGrI9rGDPhca7P96fHksKizZuV5o9ZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HkNXFTviO47paw92Jh/pOYSVeWFD1HI30AiZJkVExd2HwxvPtsTenarWoyVq2eaha
         MbY35npBQfZiYjNyB2U3aSYfeSmeZAxssJFkDlr0ugUg2K+hGtSeScErilxhrf+EHS
         s6Wjp1Md0ER7wQQN/uZCY8hm6Ld2rKTmFnr+2qAOm/AUnQMRwu5KI/Aq3+WzEi/wok
         7A4kAoKDLeCu0J6xBDlIs9XaIkNvdYkkJOLjEJrajxBvQr89Wm7vXqbgr9DmCOIWTw
         G++3NXpfxB0AJHWJgaKoGNl6GS5ql6z4ZdnvBC90Md8lqyZ3A+XR3receeMfcGCHaF
         GHY+G25Lsf7BQ==
Date:   Tue, 9 Nov 2021 06:49:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109064921.6bd65f3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYqF+MwB5uDMpZ7V@unreal>
References: <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
        <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYmBbJ5++iO4MOo7@unreal>
        <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYqB0VZcWnmtSS91@unreal>
        <20211109061729.32f20616@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYqF+MwB5uDMpZ7V@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 16:30:16 +0200 Leon Romanovsky wrote:
> On Tue, Nov 09, 2021 at 06:17:29AM -0800, Jakub Kicinski wrote:
> > On Tue, 9 Nov 2021 16:12:33 +0200 Leon Romanovsky wrote:  
> > > RDMA subsystem supports two net namespace aware scenarios.
> > > 
> > > We need global netdev_notifier for shared mode. This is legacy mode where
> > > we listen to all namespaces. We must support this mode otherwise we break
> > > whole RDMA world.
> > > 
> > > See commit below:
> > > de641d74fb00 ("Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"")  
> > 
> > But why re-reg? To take advantage of clean event replay?
> > 
> > IIUC the problem is that the un-reg is called from the reload_down path.  
> 
> This is how devlink reload was explained to me by Jiri. It suppose to
> unload and load whole driver again. In our case, it unloads mlx5_core,
> which destroys all ULPs (VDPA, RDMA, e.t.c) and these ULPs are not aware
> of devlink at all. Especially they are not aware of the reason of
> devlink reload.

Anything registering the global notifier outside of init_net needs
scrutiny. If the devlink instance was moved into namespace A then
paying attention to anything outside namespace A weakens the namespace
abstraction. init_net is legacy/special and it can't disappear so the
problem at hand won't happen (as it is triggered on namespace cleanup).

Maybe you can install the global notifier only if instance is in
init_net? That's my thinking with the scant information at hand.

> This is why I asked you. It is not related to devlink locking directly,
> but indirectly I didn't want to work on anything related to locking
> without making sure that devlink.c is correct.
