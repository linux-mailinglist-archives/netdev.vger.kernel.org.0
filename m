Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A315231466
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgG1VBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:01:24 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:54155 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbgG1VBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:01:23 -0400
Received: (qmail 36977 invoked by uid 89); 28 Jul 2020 21:01:21 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 28 Jul 2020 21:01:21 -0000
Date:   Tue, 28 Jul 2020 14:01:16 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
        kernel-team@fb.com, robin.murphy@arm.com,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, edumazet@google.com,
        steffen.klassert@secunet.com, saeedm@mellanox.com,
        maximmi@mellanox.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728210116.56potw45eyptmlc7@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-22-jonathan.lemon@gmail.com>
 <20200727073509.GB3917@lst.de>
 <20200727170003.clx5ytf7vn2emhvl@bsd-mbp.dhcp.thefacebook.com>
 <20200727182424.GA10178@lst.de>
 <20200728014812.izihmnon3khzyr32@bsd-mbp.dhcp.thefacebook.com>
 <20200728181904.GA138520@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728181904.GA138520@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 03:19:04PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 27, 2020 at 06:48:12PM -0700, Jonathan Lemon wrote:
> 
> > While the current GPU utilized is nvidia, there's nothing in the rest of
> > the patches specific to Nvidia - an Intel or AMD GPU interface could be
> > equally workable.
> 
> I think that is very misleading.
> 
> It looks like this patch, and all the ugly MM stuff, is done the way
> it is *specifically* to match the clunky nv_p2p interface that only
> the NVIDIA driver exposes.

For /this/ patch [21], this is quite true.  I'm forced to use the nv_p2p
API if I want to use the hardware that I have.  What's being overlooked
is that the host mem driver does not do this, nor would another GPU
if it used p2p_dma.  I'm just providing get_page, put_page, get_dma.


> Any approach done in tree, where we can actually modify the GPU
> driver, would do sane things like have the GPU driver itself create
> the MEMORY_DEVICE_PCI_P2PDMA pages, use the P2P DMA API framework, use
> dmabuf for the cross-driver attachment, etc, etc.

So why doesn't Nvidia implement the above in the driver?
Actually a serious question, not trolling here.


> If you are serious about advancing this then the initial patches in a
> long road must be focused on building up the core kernel
> infrastructure for P2P DMA to a point where netdev could consume
> it. There has been a lot of different ideas thrown about on how to do
> this over the years.

Yes, I'm serious about doing this work, and may not have seen or
remember all the various ideas I've seen over time.  The netstack
operates on pages - are you advocating replacing them with sglists?


> > I think this is a better patch than all the various implementations of
> > the protocol stack in the form of RDMA, driver code and device firmware.
> 
> Oh? You mean "better" in the sense the header split offload in the NIC
> is better liked than a full protocol running in the NIC?

Yes.  The NIC firmware should become simpler, not more complicated.
-- 
Jonathan

