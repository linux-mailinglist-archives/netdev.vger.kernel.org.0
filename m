Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75642EE689
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbhAGUFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGUFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D014233EE;
        Thu,  7 Jan 2021 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610049864;
        bh=E7lW9oIB2cNGQPg+ohsNC9cNCQtkSXzmdu2PacJeJX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hVk8t7iAErMPTAeH2ZECVlvaIHGN744JFs0vyI3KRxonbOfrYcNyzBWldVjcO5DVF
         vfaFAZ6bxAVk6eo00H8Go0dQ0W04qxax7p7ipdS3R3J84pw4ryIXTPDyF2SAn4JINs
         0w4V8zr9bTesXBU0dJaLHOsg5/eRCLxgnvX14WaCbv7yHl6euhBQDA87MpK0YfRnja
         wYHNVHf4BHKO58SnJ7UINKUNBVBUnRW03mLDy8IITgewrZSsLloZkbi6YGqnbUBpYC
         FfWEoVvYFXwKZJax45HzTSPcX8d/V7Sw8HRqQpqJJawufr+39pgO2SaVs3sc7WRS8S
         kP1+nIGaqDM3A==
Date:   Thu, 7 Jan 2021 12:04:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Sean Tranchetti <stranche@quicinc.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        subashab@codearurora.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        Wei Wang <weiwan@google.com>
Subject: Re: [net PATCH 1/2] net: ipv6: fib: flush exceptions when purging
 route
Message-ID: <20210107120423.5e7a2490@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9290e64d-7e07-53c7-5b3a-4e24498c65be@gmail.com>
References: <1609892546-11389-1-git-send-email-stranche@quicinc.com>
        <9290e64d-7e07-53c7-5b3a-4e24498c65be@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 09:55:09 -0700 David Ahern wrote:
> On 1/5/21 5:22 PM, Sean Tranchetti wrote:
> > From: Sean Tranchetti <stranche@codeaurora.org>
> > 
> > Route removal is handled by two code paths. The main removal path is via
> > fib6_del_route() which will handle purging any PMTU exceptions from the
> > cache, removing all per-cpu copies of the DST entry used by the route, and
> > releasing the fib6_info struct.
> > 
> > The second removal location is during fib6_add_rt2node() during a route
> > replacement operation. This path also calls fib6_purge_rt() to handle
> > cleaning up the per-cpu copies of the DST entries and releasing the
> > fib6_info associated with the older route, but it does not flush any PMTU
> > exceptions that the older route had. Since the older route is removed from
> > the tree during the replacement, we lose any way of accessing it again.
> > 
> > As these lingering DSTs and the fib6_info struct are holding references to
> > the underlying netdevice struct as well, unregistering that device from the
> > kernel can never complete.
> 
> I think the right fixes tag is:
> 
> Fixes: 2b760fcf5cfb3 ("ipv6: hook up exception table to store dst cache")
> 
> cc'ed author of that patch.
> 
> > Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
