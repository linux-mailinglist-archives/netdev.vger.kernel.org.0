Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0706454E45
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 21:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhKQUGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 15:06:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235943AbhKQUGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 15:06:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBDB5603E7;
        Wed, 17 Nov 2021 20:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637179429;
        bh=RpvP06nPQs/CA44mRZizzf1OKpKG8b0vvkN4yqRX38E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rdPFd6TF2A0o6AToAaTOdAFaHRNFkNLTJu8XtxhBBlpFKIyOo1Q3zlk2q21C6UFA1
         8jo+O4f8oi+NHkG+xdpdCsjV9FZ/phRGJAIP6XTpF1ivcypQXShgSSMNDmOVvwWyJI
         lIe7vUFDVgE8lHPVpGXEAFj3tRVxrxm3AeUD8wovm3vAYQVtDNDU/Y6OLzo5YuAvcm
         P60OCq+jiDMrPGRm0y06Y8/Vmz3jdeLiC895wLa6DagGi+fsVXmmy6L0GR4rwwAXyr
         Gh1AtGI5A9gneqtqLhc1F52N2iwEq5uPmBRaFYkjscHhluAfyw4SNAGJLxfF9/qeCq
         syjwsfxq2ufHA==
Date:   Wed, 17 Nov 2021 12:03:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
Message-ID: <20211117120347.5176b96f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211117192031.3906502-2-eric.dumazet@gmail.com>
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
        <20211117192031.3906502-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 11:20:30 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It can be hard to track where references are taken and released.
> 
> In networking, we have annoying issues at device dismantles,
> and we had various proposals to ease root causing them.
> 
> This patch adds new infrastructure pairing refcount increases
> and decreases. This will self document code, because programmer
> will have to associate increments/decrements.
> 
> This is controled by CONFIG_REF_TRACKER which can be selected
> by users of this feature.
> 
> This adds both cpu and memory costs, and thus should be reserved
> for debug kernel builds, or be enabled on demand with a static key.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Looks great, this is what I had in mind when I said:

| In the future we can extend this structure to also catch those
| who fail to release the ref on unregistering notification.

I realized today we can get quite a lot of coverage by just plugging 
in object debug infra.

The main differences I see:
 - do we ever want to use this in prod? - if not why allocate the
   tracker itself dynamically? The double pointer interface seems
   harder to compile out completely
 - whether one stored netdev ptr can hold multiple refs
 - do we want to wrap the pointer itself or have the "tracker" object
   be a separate entity
 - do we want to catch "use after free" when ref is accessed after
   it was already released

No strong preference either way.
