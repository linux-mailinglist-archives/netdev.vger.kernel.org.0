Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB06281870
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbgJBQ5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJBQ5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 12:57:47 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0069F20719;
        Fri,  2 Oct 2020 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601657867;
        bh=gtjSdH1PmmXPYzFF9OxT+X88sdCYmFUY0kyVElIJkvo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=zlpkN3K/ifQAkY/2qwJaUab5WMrKNlJD7Et7iih7LUgJQsAXMEbvQ87b1SAM6SGRQ
         HMLNghEZTQC6ir9tN94kgZ2KEJo86MMbBY5cZC15pwaYB/f9b+5neEq5KIvBKa2GRU
         AVfjt1OSDAWwjQctLhWfTPZOa8FrzbqT/smjIPYw=
Message-ID: <8e2c09c059b5866f3133d6d880c1f15becc4fc35.camel@kernel.org>
Subject: Re: [net V2 01/15] net/mlx5: Don't allow health work when device is
 uninitialized
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shay Drory <shayd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Fri, 02 Oct 2020 09:57:46 -0700
In-Reply-To: <20201001161558.1a095385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001195247.66636-1-saeed@kernel.org>
         <20201001195247.66636-2-saeed@kernel.org>
         <20201001161558.1a095385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 16:15 -0700, Jakub Kicinski wrote:
> On Thu,  1 Oct 2020 12:52:33 -0700 saeed@kernel.org wrote:
> > From: Shay Drory <shayd@mellanox.com>
> > 
> > On error flow due to failure on driver load, driver can be
> > un-initializing while a health work is running in the background,
> > health work shouldn't be allowed at this point, as it needs
> > resources to
> > be initialized and there is no point to recover on driver load
> > failures.
> > 
> > Therefore, introducing a new state bit to indicated if device is
> > initialized, for health work to check before trying to recover the
> > driver.
> 
> Can't you cancel this work? Or make sure it's not scheduled?
> IMHO those "INITILIZED" bits are an anti-pattern.
> 

Shay didn't want to make this patch complicated for net, since this
health work should start as early as possible and should be kept
running after driver is initialized, even if the driver instance
reloads after .. the main issue of the design is that we initialize +
allocate the driver structures once on the first boot, after that all
reloads will reuse the same structure, so there is some asymmetry that
we need to deal with, but nothing is impossible, the solution will be
more complicated but won't be too big to make it to net (i hope), I
will drop this patch for now.

> > Fixes: b6e0b6bebe07 ("net/mlx5: Fix fatal error handling during
> > device load")
> > Signed-off-by: Shay Drory <shayd@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> You signed off twice :)
> 

Will fix this, old mellanox email :/

> We should teach verify_signoff to catch that..
it is not exactly twice, different emails.. 

