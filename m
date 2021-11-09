Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC2E44AF3C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhKIOPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236744AbhKIOPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:15:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4072961077;
        Tue,  9 Nov 2021 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636467157;
        bh=ibv5S3X3VOybyGY3Q4Atuq9j4OFPKFJkJ3B8gu8K7Kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B/Ls0f0Foznn6ADcKqiqjnJzca/VLfd7pfTjeKFGhf3jzXOl3NeH26uy9+PorCvqf
         EpaqHuUbmwLMwP1VfXNHx8EoIv12kyo3wDTPS/tYej3KhGSHOA5ehBkzo7RrmQQZI0
         CbTMJlbBHclZLlPQDwnis9v8aqBXFhQJ5Ytfcubx63SDcuQqW0BjqsaqRdNk9k1h9Z
         h1YbS5YZXNY+iN2GdWt58KslyvapZwK5FlDZ28ZdPZubcx7ejMVLBoOTWbOHgMEPIv
         Kx8x3lJ9l/KJ+zMhqxOPmpROTeNDHMO+4IGY2/Ch12XVXAH6XcxSyItw3SoI+p4vaj
         bHjV1SsAeb41w==
Date:   Tue, 9 Nov 2021 16:12:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYqB0VZcWnmtSS91@unreal>
References: <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
 <YYgJ1bnECwUWvNqD@shredder>
 <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 03:31:26PM -0800, Jakub Kicinski wrote:
> On Mon, 8 Nov 2021 21:58:36 +0200 Leon Romanovsky wrote:
> > > > > nfp will benefit from the simplified locking as well, and so will bnxt,
> > > > > although I'm not sure the maintainers will opt for using devlink framework
> > > > > due to the downstream requirements.    
> > > > 
> > > > Exactly why devlink should be fixed first.  
> > > 
> > > If by "fixed first" you mean it needs 5 locks to be added and to remove
> > > any guarantees on sub-object lifetime then no thanks.  
> > 
> > How do you plan to fix pernet_ops_rwsem lock? By exposing devlink state
> > to the drivers? By providing unlocked version of unregister_netdevice_notifier?
> > 
> > This simple scenario has deadlocks:
> > sudo ip netns add n1
> > sudo devlink dev reload pci/0000:00:09.0 netns n1
> > sudo ip netns del n1
> 
> Okay - I'm not sure why you're asking me this. This is not related to
> devlink locking as far as I can tell. Neither are you fixing this
> problem in your own RFC.

I asked you because you clearly showed to me that things that makes
sense for me, doesn't make sense for you and vice versa.

I don't want to do work that will be thrown away.

> 
> You'd need to tell me more about what the notifier is used for (I see
> RoCE in the call trace). I don't understand why you need to re-register 
> a global (i.e. not per netns) notifier when devlink is switching name
> spaces.

RDMA subsystem supports two net namespace aware scenarios.

We need global netdev_notifier for shared mode. This is legacy mode where
we listen to all namespaces. We must support this mode otherwise we break
whole RDMA world.

See commit below:
de641d74fb00 ("Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"")

Thanks
