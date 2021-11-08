Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142E2449B88
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhKHSTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:19:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhKHSTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 13:19:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D3D61152;
        Mon,  8 Nov 2021 18:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636395408;
        bh=M50rbyGj2ca5vH7g57RESoPnaunwgYO/EhVtUpGlqo0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BqGaSnSOR6sU8rG6o+A5oeTtkj5nNkhMn0E0uDEBw47w96uC/bFCqbCCUkVhL1Ciy
         vD2eFsDAoaGTkU3ZZamBxSYRwELt88UcDhBVJrOVosRoyeNiV6Bb5fUF1m3CNlwya0
         0gmiF8n+pE2NwMDpMlt88L5CNZlUvnO3dqtuedt9ZYywSLMwbJImICdb07PJwA4adh
         C24qfXqmtAriRbsjZZYiMJGpV785iIh670MlKq9AZC+nNeYA7izbHBeu29rY/NlBgm
         pWm+50fygqLBqFVGYdKoF71kigY3FmB58eOZl7cfYpF2M9qZf3Ew+uKvmzDt0h0Ta5
         fjUgyBd5idg3w==
Date:   Mon, 8 Nov 2021 10:16:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYlfI4UgpEsMt5QI@unreal>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
        <YYABqfFy//g5Gdis@nanopsycho>
        <YYBTg4nW2BIVadYE@shredder>
        <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
        <YYgJ1bnECwUWvNqD@shredder>
        <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 19:32:19 +0200 Leon Romanovsky wrote:
> > I think it's common sense. We're just exporting something to make our
> > lives easier somewhere else in the three. Do you see a way in which
> > taking refs on devlink can help out-of-tree code?  
> 
> I didn't go such far in my thoughts. My main concern is that you ore
> exposing broken devlink internals in the hope that drivers will do better
> locking. I wanted to show that internal locking should be fixed first.
> 
> https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/T/#m093f067d0cafcbe6c05ed469bcfd708dd1eb7f36
> 
> While this series fixes locking and after all my changes devlink started
> to be more secure, that works correctly for simple drivers.

I prefer my version. I think I asked you to show how the changes make
drivers simpler, which you failed to do.

I already told you how this is going to go, don't expect me to comment
too much.

> However for net namespace aware drivers it still stays DOA.
> 
> As you can see, devlink reload holds pernet_ops_rwsem, which drivers should
> take too in order to unregister_netdevice_notifier.
> 
> So for me, the difference between netdevsim and real device (mlx5) is
> too huge to really invest time into netdevsim-centric API, because it
> won't solve any of real world problems.

Did we not already go over this? Sorry, it feels like you're repeating
arguments which I replied to before. This is exhausting.

nfp will benefit from the simplified locking as well, and so will bnxt,
although I'm not sure the maintainers will opt for using devlink framework
due to the downstream requirements.
