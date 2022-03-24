Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8D4E6750
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352036AbiCXQ4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352043AbiCXQzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:55:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAB55B7156;
        Thu, 24 Mar 2022 09:52:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39B06D6E;
        Thu, 24 Mar 2022 09:52:38 -0700 (PDT)
Received: from [10.57.41.19] (unknown [10.57.41.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D3993F73B;
        Thu, 24 Mar 2022 09:52:35 -0700 (PDT)
Message-ID: <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
Date:   Thu, 24 Mar 2022 16:52:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     Christoph Hellwig <hch@lst.de>, Maxime Bizon <mbizon@freebox.fr>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
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
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220324163132.GB26098@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-24 16:31, Christoph Hellwig wrote:
> On Thu, Mar 24, 2022 at 05:29:12PM +0100, Maxime Bizon wrote:
>>> I'm looking into this; but in the interest of a speedy resolution of
>>> the regression I would be in favour of merging that partial revert
>>> and reinstating it if/when we identify (and fix) any bugs in ath9k :)
>>
>> This looks fishy:
>>
>> ath9k/recv.c
>>
>>                  /* We will now give hardware our shiny new allocated skb */
>>                  new_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
>>                                                common->rx_bufsize, dma_type);
>>                  if (unlikely(dma_mapping_error(sc->dev, new_buf_addr))) {
>>                          dev_kfree_skb_any(requeue_skb);
>>                          goto requeue_drop_frag;
>>                  }
>>
>>                  /* Unmap the frame */
>>                  dma_unmap_single(sc->dev, bf->bf_buf_addr,
>>                                   common->rx_bufsize, dma_type);
>>
>>                  bf->bf_mpdu = requeue_skb;
>>                  bf->bf_buf_addr = new_buf_addr;
> 
> Creating a new mapping for the same buffer before unmapping the
> previous one does looks rather bogus.  But it does not fit the
> pattern where revering the sync_single changes make the driver
> work again.

OK, you made me look :)

Now that it's obvious what to look for, I can only conclude that during 
the stanza in ath_edma_get_buffers(), the device is still writing to the 
buffer while ownership has been transferred to the CPU, and whatever got 
written while ath9k_hw_process_rxdesc_edma() was running then gets wiped 
out by the subsequent sync_for_device, which currently resets the 
SWIOTLB slot to the state that sync_for_cpu copied out. By the letter of 
the DMA API that's not allowed, but on the other hand I'm not sure if we 
even have a good idiom for "I can't tell if the device has finished with 
this buffer or not unless I look at it" :/

Robin.
