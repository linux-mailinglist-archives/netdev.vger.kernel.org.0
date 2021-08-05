Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468A03E17F7
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 17:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhHEP2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 11:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242000AbhHEP2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 11:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B87260EE8;
        Thu,  5 Aug 2021 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628177277;
        bh=o57GJ3sliaVu1Q2bcjghJWAuGMef1lEdT5qr7H34+/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A8Ez2z2ovFOIYGH39cWHus2P7Zsci7P3yaK6GxNrkPwjfwQ8s9+whyCXuQ2oM/vBW
         yQi89O2DjNAkszRmy01d47CNhBknENIJaapyVVNN53jtRbcf55rdGyxnJvLS+3b/b1
         bkTJXmUhLJOt2D3l7bL4d59mcx69WNhX6L3Roy7gDW8vH/cKDCpOlVZi2AmZZliXBf
         MyUlNuLPIOat3Cmv7WATrgFHTHqkiqHK5FtEY/2s0ziC/DGR5zT19Dr8fRC4bHiSvR
         bVckNO5dt1upznnN44fzVdVUAbGVWSqFfDmNd/qM0RR5XK3IviUczwQ16sabAk/9tG
         FQCuShA8Aeh4w==
Date:   Thu, 5 Aug 2021 08:27:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when
 adding or deleting ports
Message-ID: <20210805082756.0b4e61d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YQv2v5cTqLvoPc4n@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
        <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQvs4wRIIEDG6Dcu@unreal>
        <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQv2v5cTqLvoPc4n@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 17:33:35 +0300 Leon Romanovsky wrote:
> On Thu, Aug 05, 2021 at 07:23:42AM -0700, Jakub Kicinski wrote:
> > > This is what devlink_reload_disable() returns, so I kept same error.
> > > It is not important at all.
> > > 
> > > What about the following change on top of this patch?  
> > 
> > LGTM, the only question is whether we should leave in_reload true 
> > if nsim_dev->fail_reload is set.  
> 
> I don't think so, it will block add/delete ports.

As it should, given add/delete ports takes the port_list_lock which is
destroyed by down but not (due to the forced failure) re-initialized by
up.

If we want to handle adding ports while down we can just bump port
count and return, although I don't think there's a practical need
to support that.
