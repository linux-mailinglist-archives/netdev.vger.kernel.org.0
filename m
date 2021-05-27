Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E462F39352E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhE0R6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233395AbhE0R6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 13:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFF36105A;
        Thu, 27 May 2021 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622138191;
        bh=x0DPf6Hvbw2AKD0tbSsqMCMs01y3VeB2L2mC6CORJg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bws/oC0zULBV0xs3Z86y2QQkMROF1Jpac2KnGPu/uusrONN0bWNvQlYoDf0Bmgcrm
         qyntZhd3QfvEWZoWKpS1YpNDrOOuFnI4zgSiEVu7oq3m371c3Ojz5fraFdAsb8JX2G
         n4WLmge4CJkyR4Ih1nqXZ2+h8zdgMFKlOoREIK9/3jXEy4JtkB/TZUskWWX2dWjhB0
         KtPOO/SLUQewKfrYnU5NYxDLNBrmT7pctBVdmiRTT8qFdNDnZNFD7KN0fof8MU4kTr
         Exscs1urdMVHRdD4Tt05iB7+3zjh/p3TWzTV9BzocZGbM3q7Gldh6NHbGQm+k9h0Np
         wHCNcl/JSmUnA==
Date:   Thu, 27 May 2021 10:56:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [RFC PATCH 0/6] BOND TLS flags fixes
Message-ID: <20210527105034.5e11ebef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8182c05b-03ab-1052-79b8-3cdf7ab467b5@gmail.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
        <20210526174714.1328af13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8182c05b-03ab-1052-79b8-3cdf7ab467b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 17:07:06 +0300 Tariq Toukan wrote:
> On 5/27/2021 3:47 AM, Jakub Kicinski wrote:
> > On Wed, 26 May 2021 12:57:41 +0300 Tariq Toukan wrote:  
> >> This RFC series suggests a solution for the following problem:
> >>
> >> Bond interface and lower interface are both up with TLS RX/TX offloads on.
> >> TX/RX csum offload is turned off for the upper, hence RX/TX TLS is turned off
> >> for it as well.
> >> Yet, although it indicates that feature is disabled, new connections are still
> >> offloaded by the lower, as Bond has no way to impact that:
> >> Return value of bond_sk_get_lower_dev() is agnostic to this change.
> >>
> >> One way to solve this issue, is to bring back the Bond TLS operations callbacks,
> >> i.e. provide implementation for struct tlsdev_ops in Bond.
> >> This gives full control for the Bond over its features, making it aware of every
> >> new TLS connection offload request.
> >> This direction was proposed in the original Bond TLS implementation, but dropped
> >> during ML review. Probably it's right to re-consider now.
> >>
> >> Here I suggest another solution, which requires generic changes out of the bond
> >> driver.
> >>
> >> Fixes in patches 1 and 4 are needed anyway, independently to which solution
> >> we choose. I'll probably submit them separately soon.  
> > 
> > No opinions here, semantics of bond features were always clear
> > as mud to me. What does it mean that bond survived 20 years without
> > rx-csum? And it so why would TLS offload be different from what one
> > may presume the semantics of rx-csum are today?
> 
> Advanced device offloads have basic logical dependencies, that are 
> applied for all kind of netdevs, agnostic to internal details of each 
> netdev.
> 
> Nothing special with TLS really.
> TLS device offload behaves similarly to TSO (needs HW_CSUM), and GRO_HW 
> (needs RXCSUM).
> [...]

Right, the inter-dependency between features is obvious enough. 
What makes a feature be part of UPPER_DISABLES though?
