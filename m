Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043263CB89E
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 16:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbhGPOUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 10:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhGPOUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 10:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 908C3613F8;
        Fri, 16 Jul 2021 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626445033;
        bh=roBf1Wt7hwRbg8jZMq/FXbJlPyIY+1hOlDEHXSRw5Ek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=aR9bhms2VTxbePnfsjB++kQWjWAYAKFRbk1bDPhWMMyPgUyrVA2d35rEjxNwrNl7X
         ctJT/PSAbI1madzLW6dEl8SyFDiFq4jcYKlL8tDxJrK6bOA/r8FS9DFQdr/g40zeGQ
         oz1PtxnOzuc/3ibvR/VawPJ7wzqMGzhn1G5hTgHoYFoYrFTYdwik0uGBfRD19nQh/g
         bqYrmuTV3HfDCzpJL7HEAo6ftVZe7UjJ8BI5Ppm9A4+nUJBFahUloSVsJiKL6glbt7
         yd8KVLsoeayeMuG55sTyNNmzjp7rK8umIMc5WkZFjeq0Ek0H7FDNep3N8jrG4TlioW
         WlzJl/q4L6GoQ==
Date:   Fri, 16 Jul 2021 09:17:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH V5 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint
 devices
Message-ID: <20210716141712.GA2096096@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db506d81-3cb9-4cdc-fb4a-f2d28587b9b2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 07:12:16PM +0800, Dongdong Liu wrote:
> Hi Bjorn
> 
> Many thanks for your review.
> 
> On 2021/7/16 1:23, Bjorn Helgaas wrote:
> > [+cc Logan]
> > 
> > On Mon, Jun 21, 2021 at 06:27:20PM +0800, Dongdong Liu wrote:
> > > 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
> > > field size from 8 bits to 10 bits.
> > > 
> > > For platforms where the RC supports 10-Bit Tag Completer capability,
> > > it is highly recommended for platform firmware or operating software
> > 
> > Recommended by whom?  If the spec recommends it, we should provide the
> > citation.
>
> PCIe spec 5.0 r1.0 section 2.2.6.2 IMPLEMENTATION NOTE says that.
> Will fix.

Thanks, that will be helpful.

> > > that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
> > > bit automatically in Endpoints with 10-Bit Tag Requester capability. This
> > > enables the important class of 10-Bit Tag capable adapters that send
> > > Memory Read Requests only to host memory.
> > 
> > What is the implication for P2PDMA?  What happens if we enable 10-bit
> > tags for device A, and A generates Mem Read Requests to device B,
> > which does not support 10-bit tags?
>
> PCIe spec 5.0 r1.0 section 2.2.6.2 says
> If an Endpoint supports sending Requests to other Endpoints (as opposed to
> host memory), the Endpoint must not send 10-Bit Tag Requests to another
> given Endpoint unless an implementation-specific mechanism determines that
> the Endpoint supports 10-Bit Tag Completer capability. Not sending 10-Bit
> Tag Requests to other Endpoints at all
> may be acceptable for some implementations. More sophisticated mechanisms
> are outside the scope of this specification.
> 
> Not sending 10-Bit Tag Requests to other Endpoints at all seems simple.
> Add kernel parameter pci=pcie_bus_peer2peer when boot kernel with P2PDMA,
> then do not config 10-BIT Tag.
> 
> if (pcie_bus_config != PCIE_BUS_PEER2PEER)
> 	pci_configure_10bit_tags(dev);

Seems like a reasonable start.  I wish this were more dynamic and we
didn't have to rely on a kernel parameter to make P2PDMA safe, but
that seems to be the current situation.

Does the same consideration apply to enabling Extended Tags (8-bit
tags)?  I would guess so, but sec 2.2.6.2 says "Receivers/Completers
must handle 8-bit Tag values correctly regardless of the setting of
their Extended Tag Field Enable bit" so there's some subtlety there
with regard to what "Extended Tag Field Supported" means.

I don't know why the "Extended Tag Field Supported" bit exists if all
receivers are required to support 8-bit tags.

If we need a similar change to pci_configure_extended_tags() to check
pcie_bus_config, that should be a separate patch because it would be a
bug fix independent of 10-bit tag support.

Bjorn
