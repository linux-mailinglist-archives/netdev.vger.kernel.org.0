Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9082844AF7B
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhKIOdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238529AbhKIOdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A838561105;
        Tue,  9 Nov 2021 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636468221;
        bh=9q1zcmzhKjwOsZPueYjISh0s622YSPmbrecA4DQ7LZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IbPaYlwR/ZR/cXg16DmyV5/ffuOjcpQxsBVJ8ZtxSXvcsZh5I2AJsOHhw6MOqRbHe
         XLdCrPif9emkLsYzseab3busZDmhY/ha/0e6GrKU+iezgUyhwR33hLEGQ5LMo63g7J
         iHTaq7gmNY1iFCBH7OT0hfFv/NLu5p2arQlivzZ6AcoNy7bv8UTE5c/wIZMmSBRK2p
         2uKZZfs0QSZS6tKOaZfJkfFnRseJfRwiVmLNjmojaWcCu5IQAmVf4RGfGWRaY6C5+L
         g3RIjv5LyhLeISFU9373FRB5ipaVK6QHd/ravvNZLrDMUaakOL+vAtUnNQWx8621Jk
         I6smsov4YVTGw==
Date:   Tue, 9 Nov 2021 16:30:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYqF+MwB5uDMpZ7V@unreal>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109061729.32f20616@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 06:17:29AM -0800, Jakub Kicinski wrote:
> On Tue, 9 Nov 2021 16:12:33 +0200 Leon Romanovsky wrote:
> > > You'd need to tell me more about what the notifier is used for (I see
> > > RoCE in the call trace). I don't understand why you need to re-register 
> > > a global (i.e. not per netns) notifier when devlink is switching name
> > > spaces.  
> > 
> > RDMA subsystem supports two net namespace aware scenarios.
> > 
> > We need global netdev_notifier for shared mode. This is legacy mode where
> > we listen to all namespaces. We must support this mode otherwise we break
> > whole RDMA world.
> > 
> > See commit below:
> > de641d74fb00 ("Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"")
> 
> But why re-reg? To take advantage of clean event replay?
> 
> IIUC the problem is that the un-reg is called from the reload_down path.

This is how devlink reload was explained to me by Jiri. It suppose to
unload and load whole driver again. In our case, it unloads mlx5_core,
which destroys all ULPs (VDPA, RDMA, e.t.c) and these ULPs are not aware
of devlink at all. Especially they are not aware of the reason of
devlink reload.

This is why I asked you. It is not related to devlink locking directly,
but indirectly I didn't want to work on anything related to locking
without making sure that devlink.c is correct.

Thanks
