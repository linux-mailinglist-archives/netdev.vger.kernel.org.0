Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000EC4E6709
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243633AbiCXQdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351724AbiCXQdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:33:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D0EAA017;
        Thu, 24 Mar 2022 09:31:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 364BB68B05; Thu, 24 Mar 2022 17:31:32 +0100 (CET)
Date:   Thu, 24 Mar 2022 17:31:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
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
Message-ID: <20220324163132.GB26098@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com> <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name> <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk> <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 05:29:12PM +0100, Maxime Bizon wrote:
> > I'm looking into this; but in the interest of a speedy resolution of
> > the regression I would be in favour of merging that partial revert
> > and reinstating it if/when we identify (and fix) any bugs in ath9k :)
> 
> This looks fishy:
> 
> ath9k/recv.c
> 
>                 /* We will now give hardware our shiny new allocated skb */
>                 new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
>                                               common->rx_bufsize, dma_type);
>                 if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
>                         dev_kfree_skb_any(requeue_skb);
>                         goto requeue_drop_frag;
>                 }
> 
>                 /* Unmap the frame */
>                 dma_unmap_single(sc->dev, bf->bf_buf_addr,
>                                  common->rx_bufsize, dma_type);
> 
>                 bf->bf_mpdu = requeue_skb;
>                 bf->bf_buf_addr = new_buf_addr;

Creating a new mapping for the same buffer before unmapping the
previous one does looks rather bogus.  But it does not fit the
pattern where revering the sync_single changes make the driver
work again.
