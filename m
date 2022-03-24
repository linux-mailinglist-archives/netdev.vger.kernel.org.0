Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9BC4E6723
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351687AbiCXQkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiCXQkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:40:51 -0400
X-Greylist: delayed 603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Mar 2022 09:39:17 PDT
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A088843AD9;
        Thu, 24 Mar 2022 09:39:17 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 7668D208CF;
        Thu, 24 Mar 2022 17:29:12 +0100 (CET)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 6FAA6208C9;
        Thu, 24 Mar 2022 17:29:12 +0100 (CET)
Message-ID: <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Date:   Thu, 24 Mar 2022 17:29:12 +0100
In-Reply-To: <878rsza0ih.fsf@toke.dk>
References: <1812355.tdWV9SEqCh@natalenko.name>
         <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
         <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
         <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Thu Mar 24 17:29:12 2022 +0100 (CET)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 2022-03-24 at 15:27 +0100, Toke Høiland-Jørgensen wrote:

> 
> I'm looking into this; but in the interest of a speedy resolution of
> the regression I would be in favour of merging that partial revert
> and reinstating it if/when we identify (and fix) any bugs in ath9k :)

This looks fishy:

ath9k/recv.c

                /* We will now give hardware our shiny new allocated skb */
                new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
                                              common->rx_bufsize, dma_type);
                if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
                        dev_kfree_skb_any(requeue_skb);
                        goto requeue_drop_frag;
                }

                /* Unmap the frame */
                dma_unmap_single(sc->dev, bf->bf_buf_addr,
                                 common->rx_bufsize, dma_type);

                bf->bf_mpdu = requeue_skb;
                bf->bf_buf_addr = new_buf_addr;

-- 
Maxime



