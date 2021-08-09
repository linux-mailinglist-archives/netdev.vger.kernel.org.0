Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5683E4ADF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhHIRbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233996AbhHIRbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 13:31:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE141604DC;
        Mon,  9 Aug 2021 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628530275;
        bh=eDy1pEzRt6RUJc3M+OdmFDgeBpFyrnusEt6fYQvnavU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=B0Wi30G8/HhJIylJTtEL4v1GoqNPI0mOQgVd8xULg+NA5dfVLS5RUhnsbTSycKp3v
         +EbkHHiTStAXkfj6/q19uu6IrSUOK3lARbC+PhKsjLZlg2l7aZ7VMZWCeKHYY5H2Ye
         +h1lmR9iwsyGwjDTD+vqmEzXkWSUc/WElw7QQZKoPhFj1vSFfMlRfr/1W2QOxEfiKH
         Z0ufkojNh3NEPeyjm71P08YzGnoHm4QnonbSlDdqANHzVyVyjkQR6QQh6GyvMFwgzu
         t+Rl6ewTdRJ15Z97FQ5dKB9gjzoCSTPzo4FPyySFozRG4rtO6nBTA2h+E5qGlPKQvn
         rNyzEIwhLG5wg==
Date:   Mon, 9 Aug 2021 12:31:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Message-ID: <20210809173113.GA2166744@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f98331-cc39-ee37-85f7-185fdd1ccea5@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 07, 2021 at 03:11:34PM +0800, Dongdong Liu wrote:
> 
> On 2021/8/6 2:12, Bjorn Helgaas wrote:
> > On Wed, Aug 04, 2021 at 09:47:08PM +0800, Dongdong Liu wrote:
> > > Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> > > 10-Bit Tag Requester doesn't interact with a device that does not
> > > support 10-BIT Tag Completer. Before that happens, the kernel should
> > > emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
> > > disable 10-BIT Tag Requester for PF device.
> > > "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
> > > 10-BIT Tag Requester for VF device.
> > 
> > s/10-BIT/10-Bit/ several times.
> Will fix.
> > 
> > Add blank lines between paragraphs.
> Will fix.
> > 
> > > Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> > > ---
> > >  drivers/pci/p2pdma.c | 40 ++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 40 insertions(+)
> > > 
> > > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > > index 50cdde3..948f2be 100644
> > > --- a/drivers/pci/p2pdma.c
> > > +++ b/drivers/pci/p2pdma.c
> > > @@ -19,6 +19,7 @@
> > >  #include <linux/random.h>
> > >  #include <linux/seq_buf.h>
> > >  #include <linux/xarray.h>
> > > +#include "pci.h"
> > > 
> > >  enum pci_p2pdma_map_type {
> > >  	PCI_P2PDMA_MAP_UNKNOWN = 0,
> > > @@ -410,6 +411,41 @@ static unsigned long map_types_idx(struct pci_dev *client)
> > >  		(client->bus->number << 8) | client->devfn;
> > >  }
> > > 
> > > +static bool check_10bit_tags_vaild(struct pci_dev *a, struct pci_dev *b,
> > 
> > s/vaild/valid/
> > 
> > Or maybe s/valid/safe/ or s/valid/supported/, since "valid" isn't
> > quite the right word here.  We want to know whether the source is
> > enabled to generate 10-bit tags, and if so, whether the destination
> > can handle them.
> > 
> > "if (check_10bit_tags_valid())" does not make sense because
> > "check_10bit_tags_valid()" is not a question with a yes/no answer.
> > 
> > "10bit_tags_valid()" *might* be, because "if (10bit_tags_valid())"
> > makes sense.  But I don't think you can start with a digit.
> > 
> > Or maybe you want to invert the sense, e.g.,
> > "10bit_tags_unsupported()", since that avoids negation at the caller:
> > 
> >   if (10bit_tags_unsupported(a, b) ||
> >       10bit_tags_unsupported(b, a))
> >         map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
> Good suggestion. add a pci_ prefix.
> 
> if (pci_10bit_tags_unsupported(a, b) ||
>     pci_10bit_tags_unsupported(b, a))
> 	map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;

This treats both directions as equally important.  I don't know P2PDMA
very well, but that doesn't seem like it would necessarily be the
case.  I would think a common case would be device A doing DMA to B,
but B *not* doing DMA to A.  So can you tell which direction you're
setting up here, and can you take advantage of any asymmetry, e.g., by
enabling 10-bit tags in the direction that supports it even if the
other direction does not?
