Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001EF2EFD6A
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 04:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbhAIDXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 22:23:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbhAIDXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 22:23:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1972399C;
        Sat,  9 Jan 2021 03:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610162584;
        bh=WplpMGnkahX6iTr8yPmLLqFf4dUfuLwHrquba5+P4HI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYS4kIs3eEBXVt+wcTubr7SnpHU+yh5N71L5MtL+DhvD/o2dpb18v721u7q0vbAUt
         LL4v/MScQBTPTBzvnv+fYZ0nydBoBP2FCxZUUStR5uhTfQbi9HbofL5ePTr6zRvEMk
         enU9IaS2GGxFN+WC+0WP7wq2fi5IooViPMRQGSie6EXXnaJN+JljNjYwlQ3sqOpQh6
         /SqQTcd7GekGORlCTerOD5QQge/APxi6k7WdyAQudCxORsNGXaTfn1iLhuqntvbVil
         fdAaxP6U9c1cxJzXt1ThbpEGX6em3d7cHFc+6lczkxYvuJ2wlINvE2iUmpe4Fn6kbz
         8mWc3bUtfsjIg==
Date:   Fri, 8 Jan 2021 19:23:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>,
        Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net v3] ppp: fix refcount underflow on channel unbridge
Message-ID: <20210108192303.6171c90c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108205750.GA14215@linux.home>
References: <20210107181315.3128-1-tparkin@katalix.com>
        <20210108205750.GA14215@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 21:57:50 +0100 Guillaume Nault wrote:
> On Thu, Jan 07, 2021 at 06:13:15PM +0000, Tom Parkin wrote:
> > When setting up a channel bridge, ppp_bridge_channels sets the
> > pch->bridge field before taking the associated reference on the bridge
> > file instance.
> > 
> > This opens up a refcount underflow bug if ppp_bridge_channels called
> > via. iotcl runs concurrently with ppp_unbridge_channels executing via.
> > file release.
> > 
> > The bug is triggered by ppp_bridge_channels taking the error path
> > through the 'err_unset' label.  In this scenario, pch->bridge is set,
> > but the reference on the bridged channel will not be taken because
> > the function errors out.  If ppp_unbridge_channels observes pch->bridge
> > before it is unset by the error path, it will erroneously drop the
> > reference on the bridged channel and cause a refcount underflow.
> > 
> > To avoid this, ensure that ppp_bridge_channels holds a reference on
> > each channel in advance of setting the bridge pointers.  
> 
> Thanks for following up on this!
> 
> Acked-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks!
