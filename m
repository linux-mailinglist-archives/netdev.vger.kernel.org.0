Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C13065D0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhA0VOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233903AbhA0VOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 16:14:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A278E60C3E;
        Wed, 27 Jan 2021 21:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611782035;
        bh=MoCjYZO9i0aM338B6n8Rdn5oVPO+PReC4kzLCcVwUM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LuMCrOgN6kC0p2ynTtu7PnNEQ4dep9Xa1KUEDcdLl5Wvs5MOxK4jI56WMML+fY5v9
         vK0dcZFxNDAEEUHj5oyd0rTnz/LOlsculqg2YoHgztOkMmMobupaOsswjN1A1HTun0
         TLdeg0DxB+C1m9NQWLn43XB7pohdqUIurQm1GD3KDv21BslDm94Zls4+z2Opo4HBoh
         v+WdrFitKr7c4sCBwxfprbbLh0gAvBmFx+79Y07dYSpqX/5ch7o0YBDfk4idyP8lI9
         F5UnITHY5bm9Jx3b7cDazItJVH8wSqGW1a3bWhNXxU7UagDfzOZ2vZ0wD9E+hzRRb6
         z8VjSj91G0efA==
Date:   Wed, 27 Jan 2021 13:13:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Yang Li <abaci-bugfix@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] cxgb4: remove redundant NULL check
Message-ID: <20210127131353.5fc141da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127063426.GC21071@chelsio.com>
References: <1611629413-81373-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        <20210127063426.GC21071@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 12:04:27 +0530 Raju Rangoju wrote:
> On Tuesday, January 01/26/21, 2021 at 10:50:13 +0800, Yang Li wrote:
> > Fix below warnings reported by coccicheck:
> > ./drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:323:3-9: WARNING:
> > NULL check before some freeing functions is not needed.
> > ./drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:3554:2-8: WARNING:
> > NULL check before some freeing functions is not needed.
> > ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c:157:2-7: WARNING:
> > NULL check before some freeing functions is not needed.
> > ./drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:525:3-9: WARNING:
> > NULL check before some freeing functions is not needed.
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>

> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
> > index 77648e4..dd66b24 100644
> > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
> > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c
> > @@ -157,8 +157,7 @@ static int cudbg_alloc_compress_buff(struct cudbg_init *pdbg_init)
> >  
> >  static void cudbg_free_compress_buff(struct cudbg_init *pdbg_init)
> >  {
> > -	if (pdbg_init->compress_buff)  
> 
> NAK. The above check is necessary.
> 
> pdbg_init->compress_buff may be NULL when Zlib is unavailable or when
> pdbg_init->compress_buff allocation fails, in which case we ignore error
> and continue without compression. Check is necessary before calling
> vfree().

Thanks taking a look! The point is that vfree() kfree() etc. all can be
fed NULL in which case they are a nop. E.g.:

/**
 * vfree - Release memory allocated by vmalloc()
 * @addr:  Memory base address
 *
 * Free the virtually continuous memory area starting at @addr, as obtained
 * from one of the vmalloc() family of APIs.  This will usually also free the
 * physical memory underlying the virtual allocation, but that memory is
 * reference counted, so it will not be freed until the last user goes away.
 *
   vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
>* If @addr is NULL, no operation is performed. <=
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 *
 * Context:
 * May sleep if called *not* from interrupt context.
 * Must not be called in NMI context (strictly speaking, it could be
 * if we have CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, but making the calling
 * conventions for vfree() arch-depenedent would be a really bad idea).
 */

I don't think there is any advanced static analysis going on here if
that's what you assumed.

Yang, please respin, and explain in the patch message why removing
those conditions is safe.
