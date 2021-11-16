Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE14C45359F
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhKPPXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:23:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237827AbhKPPXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:23:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E11761BFE;
        Tue, 16 Nov 2021 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637076055;
        bh=Qbt7vW9DG/mWQZEHnQW8Hw8A4Dqiq9HcJAS70+ihJTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OqAJm3aniBetWkX6tUOB77lByIfxaRnttrXuelYfd+G8K1Xz9DaVTU0AxlzDQAGwV
         jRaxXVaffBWMJJQEahq8L21X4UiLWl74vF/U0auQAGj10+uxNQzNX1rQMaTNcmRycL
         6czTfFheIpzzH9n6aeP58v186QAyRpsGYH+BTx9ICiKcX27UoiMjed/+RGIFav/yFV
         lhLGh601hwpoekbXEWSD5uQHyQI4WhAFOEOgc1uw8Tc7C60QZ78rnApsNT0Pyu0DXW
         yMQ8KxL1QHIkcNeBiqXy44wc420OLfzfFrGnPUmEse2z2JJXE9yLO3WNrA58cyxPIf
         jM6lZ+0EBwLFw==
Date:   Tue, 16 Nov 2021 07:20:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
Message-ID: <20211116072054.4d2129cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
        <20211115190249.3936899-18-eric.dumazet@gmail.com>
        <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 07:05:54 -0800 Eric Dumazet wrote:
> On Tue, Nov 16, 2021 at 6:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 15 Nov 2021 11:02:46 -0800 Eric Dumazet wrote:  
> > > One cpu can now be fully utilized for the kernel->user copy,
> > > and another cpu is handling BH processing and skb/page
> > > allocs/frees (assuming RFS is not forcing use of a single CPU)  
> >
> > Are you saying the kernel->user copy is not under the socket lock
> > today? I'm working on getting the crypto & copy from under the socket
> > lock for ktls, and it looked like tcp does the copy under the lock.  
> 
> Copy is done currently with socket lock owned.
> 
> But each skb is freed one at a time, after its payload has been consumed.
> 
> Note that I am also working on performing the copy while still allowing BH
> to process incoming packets.
> 
> This is a bit more complex, but I think it is doable.

Can't wait ! :)
