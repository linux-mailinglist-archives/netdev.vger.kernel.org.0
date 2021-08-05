Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C543E1A7D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbhHERgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240060AbhHERgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 13:36:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D565060F42;
        Thu,  5 Aug 2021 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628184964;
        bh=AnGQRaP8nkqNwiFWtMqvZz6Ciyna+r9FB3Un0pnNMWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnUO66Jl6tej8HglOHBrL2fhDWV24R4mTC8gWe0UlnUc7LLdvTR8fQlp4XlIcLFqh
         dkRqmMQPxo1O/SdyP7NVOjH/70QlTGLjg+r2n7Jl3IykNyuXG4aW6d4rzQIvuw8dOR
         Uh2pt2p0WIoyOQ1hjWrTYIccFxJFu3ovlKexZ1nmQUyhGhxmKzAHmoX28y247psB79
         lY3BxE2QbHHih6awfQ4fYjKYGU17TgNFVvIWDV8qmpUUMsVGvqs1SEO9E1gs+F171j
         sEWkLIW6PkWZTXC+B/4XARcT6IzBxPaGzuBvRON5N8zM88KmFs4gsVnGUuN23s66BU
         Ms89efTXKbh7w==
Date:   Thu, 5 Aug 2021 20:35:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when adding
 or deleting ports
Message-ID: <YQwhf+3oeqOv/OMU@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
 <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQvs4wRIIEDG6Dcu@unreal>
 <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQv2v5cTqLvoPc4n@unreal>
 <20210805082756.0b4e61d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805082756.0b4e61d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 08:27:56AM -0700, Jakub Kicinski wrote:
> On Thu, 5 Aug 2021 17:33:35 +0300 Leon Romanovsky wrote:
> > On Thu, Aug 05, 2021 at 07:23:42AM -0700, Jakub Kicinski wrote:
> > > > This is what devlink_reload_disable() returns, so I kept same error.
> > > > It is not important at all.
> > > > 
> > > > What about the following change on top of this patch?  
> > > 
> > > LGTM, the only question is whether we should leave in_reload true 
> > > if nsim_dev->fail_reload is set.  
> > 
> > I don't think so, it will block add/delete ports.
> 
> As it should, given add/delete ports takes the port_list_lock which is
> destroyed by down but not (due to the forced failure) re-initialized by
> up.
> 
> If we want to handle adding ports while down we can just bump port
> count and return, although I don't think there's a practical need
> to support that.

Sorry, but for me netdevsim looks like complete dumpster. It was
intended for fast prototyping, but ended to be huge pile of debugfs
entries and selftest to execute random flows.

Do you want me to move in_reload = false line to be after if (nsim_dev->fail_reload)
check?

Thanks
