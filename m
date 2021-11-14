Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E7244F707
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 07:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhKNGWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 01:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhKNGV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 01:21:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4FE60EC0;
        Sun, 14 Nov 2021 06:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636870746;
        bh=JlVUiwdc4qyknyw67PdGTWXoU+8TUzy/JW3C4ARk/bg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JaxqALHoZl2AAADp8zlXqbefKkVEkCr1BhTXjHpVMPh5jazAcZmfqZ0GO7k5002Kx
         OGkk4GsMRayDqNLH59AmUgWW17KWzCjLzAZgTh27lOICdUp1jCSqMnAYNOPsjeQqr0
         WyRaE8P7WLfCTamj9yE0i6fMWfP7k4mC9btGbjH/ARD4ca9pOeQAVwhaboMFFN0goR
         y2I0UwzI7xMFp/Y+jdtB4VQz3KBPUG4w1tlYGTdfOPG7D/hha9LztrvGksSSd7TWDv
         pIN/eNabrbpBYX5vulDbwvLSBlRq+NXf/phxbVkhSpTEBGmKcX2FODeOw7nrEJcg15
         E5iKL783J6Eqw==
Date:   Sun, 14 Nov 2021 08:19:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YZCqVig9GQi/o1iz@unreal>
References: <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY4aEFkVuqR+vauw@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 08:38:56AM +0100, Jiri Pirko wrote:
> Thu, Nov 11, 2021 at 01:17:52PM CET, leon@kernel.org wrote:
> >On Thu, Nov 11, 2021 at 01:05:11PM +0100, Jiri Pirko wrote:
> >> Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
> >> >On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
> >> >> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
> >> >> > > > I once sketched out fixing this by removing the need to hold the
> >> >> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
> >> >> > > > over the devlink reload paths. It seemed like a reasonable step toward
> >> >> > > > finer grained locking.  
> >> >> > > 
> >> >> > > Seems to me the locking is just a symptom.  
> >> >> > 
> >> >> > My fear is this reload during net ns destruction is devlink uAPI now
> >> >> > and, yes it may be only a symptom, but the root cause may be unfixable
> >> >> > uAPI constraints.
> >> >> 
> >> >> If I'm reading this right it locks up 100% of the time, what is a uAPI
> >> >> for? DoS? ;)
> >> >> 
> >> >> Hence my questions about the actual use cases.
> >> >
> >> >Removing namespace support from devlink would solve the crasher. I
> >> >certainly didn't feel bold enough to suggest such a thing :)
> >> >
> >> >If no other devlink driver cares about this it is probably the best
> >> >idea.
> >> 
> >> Devlink namespace support is not generic, not related to any driver.
> >
> >What do you mean?
> >
> >devlink_pernet_pre_exit() calls to devlink reload, which means that only
> >drivers that support reload care about it. The reload is driver thing.
> 
> However, Jason was talking about "namespace support removal from
> devlink"..

The code that sparkles deadlocks is in devlink_pernet_pre_exit() and
this will be nice to remove. I just don't know if it is possible to do
without ripping whole namespace support from devlink.

Thanks

> 
> 
> >
> >Thanks
> >
> >> 
> >> >
> >> >Jason
