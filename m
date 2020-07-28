Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C27231107
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbgG1Rlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:41:42 -0400
Received: from smtp4.emailarray.com ([65.39.216.22]:42880 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731918AbgG1Rll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:41:41 -0400
Received: (qmail 73170 invoked by uid 89); 28 Jul 2020 17:41:40 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 28 Jul 2020 17:41:40 -0000
Date:   Tue, 28 Jul 2020 10:41:38 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 10/21] netgpu: add network/gpu/host dma module
Message-ID: <20200728174138.hmpq2vsslh7qdud3@bsd-mbp.dhcp.thefacebook.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-11-jonathan.lemon@gmail.com>
 <20200728162608.GA4181352@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728162608.GA4181352@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 06:26:08PM +0200, Greg KH wrote:
> On Mon, Jul 27, 2020 at 03:44:33PM -0700, Jonathan Lemon wrote:
> > From: Jonathan Lemon <bsd@fb.com>
> > 
> > Netgpu provides a data path for zero-copy sends and receives
> > without having the host CPU touch the data.  Protocol processing
> > is done on the host CPU, while data is DMA'd to and from DMA
> > mapped memory areas.  The initial code provides transfers between
> > (mlx5 / host memory) and (mlx5 / nvidia GPU memory).
> > 
> > The use case for this module are GPUs used for machine learning,
> > which are located near the NICs, and have a high bandwidth PCI
> > connection between the GPU/NIC.
> 
> Do we have such a GPU driver in the kernel today?  We can't add new
> apis/interfaces for no in-kernel users, as you well know.

No, that's what I'm trying to create.  But Jens pointed out that the
main sticking point here seems to be Nvidia, so I'll look into seeing
whether there are some AMD or Intel GPUS I can use.


> There's lots of crazyness in this patch, but this is just really odd:
> 
> > +#if IS_MODULE(CONFIG_NETGPU)
> > +#define MAYBE_EXPORT_SYMBOL(s)
> > +#else
> > +#define MAYBE_EXPORT_SYMBOL(s)	EXPORT_SYMBOL(s)
> > +#endif
> 
> Why is that needed at all?  Why does no one else in the kernel need such
> a thing?

Really, this is just development code, allowing the netgpu to be built
as a loadable module.  I'll rip it out.


> And why EXPORT_SYMBOL() and not EXPORT_SYMBOL_GPL() (I have to ask).

Shorter typing, didn't think to add _GPL, I'll do that.
-- 
Jonathan
