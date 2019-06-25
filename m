Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE3854EF7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbfFYMfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:35:05 -0400
Received: from verein.lst.de ([213.95.11.211]:34505 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfFYMfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 08:35:04 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 4BA6A68B05; Tue, 25 Jun 2019 14:34:33 +0200 (CEST)
Date:   Tue, 25 Jun 2019 14:34:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     BjoernRiemerriemer@fokus.fraunhofer.de,
        Matt Porter <mporter@kernel.crashing.org>,
        Herbert Valerio Riedel <hvr@gnu.org>
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: DMA API usage in au1000_eth.c
Message-ID: <20190625123433.GA4607@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

you are the persons that have their names listed in the driver,
hope you all remember what you did 15 years ago :)

The au1000_eth driver uses the DMA API somewhat oddly.  For one
it uses the DMA_ATTR_NON_CONSISTENT flag to allocate memory that
is not DMA coherent, accompanied by a comment say:

	/* Allocate the data buffers
	 * Snooping works fine with eth on all au1xxx
	 */

which suggests that it actually is DMA coherent.  As far as I can
tell many amd mips platforms are DMA coherent, in which case
DMA_ATTR_NON_CONSISTENT is no-op and everything is fine here.  But
it seems some are not, in which case DMA_ATTR_NON_CONSISTENT will
give us not coherent memory, in which case something would be
broken?  Removing DMA_ATTR_NON_CONSISTENT would be no-op on
coherent platforms, but return an address in the cache segement
on those that are non-coherent.  Do you know if the hardware
event cares?

The next issue is that it calls virt_to_phys on the return value
from dma_alloc_attrs.  Why would the hardware care about the physical
address and not the DMA address (in general those are the same in
mips)?

Last but not least it stores the kernel address return from
dma_alloc_attrs in a u32 instead of a pointer, which is a little
odd and not type safe, but not otherwise dramatic.

I can prepare a patch to fix these up, but I'd like to confirm my
theory about coherent of the platform and device first.

