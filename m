Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9657D4E78EF
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357901AbiCYQcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241341AbiCYQcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:32:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BCDDB48A;
        Fri, 25 Mar 2022 09:31:18 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E6EC468B05; Fri, 25 Mar 2022 17:31:13 +0100 (CET)
Date:   Fri, 25 Mar 2022 17:31:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Message-ID: <20220325163113.GA16426@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com> <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name> <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk> <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr> <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <20220324193158.5fcae106.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324193158.5fcae106.pasic@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 07:31:58PM +0100, Halil Pasic wrote:
> I agree with your analysis. Especially with the latter part (were you
> state that we don't have a good idiom for that use case). 
> 
> I believe, a stronger statement is also true: it is fundamentally
> impossible to accommodate use cases where the device and the cpu need
> concurrent access to a dma buffer, if the dma buffer isn't in dma
> coherent memory.

Yes, and that is also clearly stated in the DMA API document.  We
only have two platforms that do not support DMA coherent memory,
one are the oldest PARISC platforms, and the other is coldfire.

The first has drivers carefully written to actually support that,
the second only has a single driver using DMA that does manual
global cache flushes (while pretending it supports coherent memory).

> If the dma buffer is in dma coherent memory, and we don't need swiotlb,
> then we don't need the dma_sync functionality. 

Yes.
