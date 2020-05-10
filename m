Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B711CC660
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 06:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgEJEF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 00:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgEJEF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 00:05:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B7420722;
        Sun, 10 May 2020 04:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589083528;
        bh=GddumRUIbMsnM5ccXItC4vDcJ8odNZ6Nse43nuglUNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UG1ccPFJFT3w6CGWDn8geRRl6fFheJZbtGyHYDTLrM5R+rGNqgs+diuUplnFg4T/S
         SwSiXN1rk8o40ESgn2le/z8qPtli9Yzfzp5U4yctbLPtfif8FZS/9KH2IXvyxqzmXx
         BjYCftrom5m3aQz+s+VWgNIyAVKzlDBME+095knk=
Date:   Sat, 9 May 2020 21:05:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, davem@davemloft.net,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
Subject: Re: [PATCH v3] octeontx2-pf: Use the napi_alloc_frag() to alloc the
 pool buffers
Message-ID: <20200509210526.7f0be0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509104310.40667-1-haokexin@gmail.com>
References: <20200509104310.40667-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 18:43:10 +0800 Kevin Hao wrote:
> In the current codes, the octeontx2 uses its own method to allocate
> the pool buffers, but there are some issues in this implementation.
> 1. We have to run the otx2_get_page() for each allocation cycle and
>    this is pretty error prone. As I can see there is no invocation
>    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
>    the allocated pages have the wrong refcount and may be freed wrongly.
> 2. It wastes memory. For example, if we only receive one packet in a
>    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
>    to refill the pool buffers and leave the remain area of the allocated
>    page wasted. On a kernel with 64K page, 62K area is wasted.
> 
> IMHO it is really unnecessary to implement our own method for the
> buffers allocate, we can reuse the napi_alloc_frag() to simplify
> our code.
> 
> Signed-off-by: Kevin Hao <haokexin@gmail.com>

Applied, thank you!
