Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DB1382BB8
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 14:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhEQMFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 08:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236859AbhEQMFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 08:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A0A611CC;
        Mon, 17 May 2021 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621253037;
        bh=1u9jCnH0kVDLYN12RB5ASStIPTFL7WCViT8G7rXqkNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TbftmKOb6b7VvA9v0WBiZ3xm+GvfPLuCphxAdd+Gf5qzvw0VOrMUC7CMk8c/TfSHu
         n9UQkD4bZkzds/3J7DJ9IKN8iH78/O26z91M26awzq6T6/eocTQyejXbAbrM5VfQ+1
         qJv9x1NgwAwJEvfz8NqE4WuMY/d6QP4pltCxFhFY=
Date:   Mon, 17 May 2021 14:03:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: Make global sysctls readonly in
 non-init netns
Message-ID: <YKJbq3ubZnUKIjcv@kroah.com>
References: <20210513082835.18854-1-jonathon.reinhart@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513082835.18854-1-jonathon.reinhart@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 04:28:35AM -0400, Jonathon Reinhart wrote:
> commit 2671fa4dc0109d3fb581bc3078fdf17b5d9080f6 upstream.
> 
> These sysctls point to global variables:
> - [0] "nf_conntrack_max"        (&nf_conntrack_max)
> - [2] "nf_conntrack_buckets"    (&nf_conntrack_htable_size_user)
> - [5] "nf_conntrack_expect_max" (&nf_ct_expect_max)
> 
> Because their data pointers are not updated to point to per-netns
> structures, they must be marked read-only in a non-init_net ns.
> Otherwise, changes in any net namespace are reflected in (leaked into)
> all other net namespaces. This problem has existed since the
> introduction of net namespaces.
> 
> This patch is necessarily different from the upstream patch due to the
> heavy refactoring which took place since 4.19:
> 
> d0febd81ae77 ("netfilter: conntrack: re-visit sysctls in unprivileged namespaces")
> b884fa461776 ("netfilter: conntrack: unify sysctl handling")
> 4a65798a9408 ("netfilter: conntrack: add mnemonics for sysctl table")
> 
> Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> ---
> 
> Upstream commit 2671fa4dc010 was already applied to the 5.10, 5.11, and
> 5.12 trees.
> 
> This was tested on 4.19.190, so please apply to 4.19.y.
> 
> It should also apply to:
> - 4.14.y
> - 4.9.y
> 
> Note that 5.4.y would require a slightly different patch that looks more
> like 2671fa4dc010.

All now queued up, thanks!

greg k-h
