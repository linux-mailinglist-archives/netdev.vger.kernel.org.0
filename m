Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8518B4E58E4
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239209AbiCWTIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 15:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344116AbiCWTIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 15:08:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A15669FE5;
        Wed, 23 Mar 2022 12:06:30 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 409D0D6E;
        Wed, 23 Mar 2022 12:06:30 -0700 (PDT)
Received: from [10.57.43.230] (unknown [10.57.43.230])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A5F83F73B;
        Wed, 23 Mar 2022 12:06:27 -0700 (PDT)
Message-ID: <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
Date:   Wed, 23 Mar 2022 19:06:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-GB
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
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
 <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
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

On 2022-03-23 17:27, Linus Torvalds wrote:
> On Wed, Mar 23, 2022 at 12:19 AM Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
>>
>> The following upstream commits:
>>
>> aa6f8dcbab47 swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
>> ddbd89deb7d3 swiotlb: fix info leak with DMA_FROM_DEVICE
>>
>> break ath9k-based Wi-Fi access point for me. The AP emits beacons, but
>> no client can connect to it, either from the very beginning, or
>> shortly after start. These are the only symptoms I've noticed (i.e.,
>> no BUG/WARNING messages in `dmesg` etc).
> 
> Funky, but clearly true:
> 
>> These commits appeared in v5.17 and v5.16.15, and both kernels are
>> broken for me. I'm pretty confident these commits make the difference
>> since I've built both v5.17 and v5.16.15 without them, and it fixed
>> the issue.
> 
> Can you double-check (or just explicitly confirm if you already did
> that test) that you need to revert *both* of those commits, and it's
> the later "rework" fix that triggers it?
> 
>> So, I do understand this might be an issue with regard to SG I/O
>> handling in ath9k, hence relevant people in Cc.
> 
> Yeah, almost certainly an ath9k bug, but a regression is a regression,
> so if people can't find the issue in ath9k, we'll have to revert those
> commits.
> 
> Honestly, I personally think they were a bit draconian to begin with,
> and didn't limit their effects sufficiently.
> 
> I'm assuming that the ath9k issue is that it gives DMA mapping a big
> enough area to handle any possible packet size, and just expects -
> quite reasonably - smaller packets to only fill the part they need.
> 
> Which that "info leak" patch obviously breaks entirely.

Except that's the exact case which the new patch is addressing - by 
copying the whole original area into the SWIOTLB bounce buffer to begin 
with, if we bounce the whole lot back after the device has only updated 
part of it, the non-updated parts now get overwritten with the same 
original contents, rather than whatever random crap happened to be left 
in the SWIOTLB buffer by its previous user. I'm extremely puzzled how 
any driver could somehow be dependent on non-device-written data getting 
replaced with random crap, given that it wouldn't happen with a real 
IOMMU, or if SWIOTLB just didn't need to bounce, and the data would 
hardly be deterministic either.

I think I can see how aa6f8dcbab47 might increase the severity of a 
driver bug where it calls dma_sync_*_for_device() on part of a 
DMA_FROM_DEVICE mapping that the device *has* written to, without having 
called a corresponding dma_sync_*_for_cpu() first - previously that 
would have had no effect, but now SWIOTLB will effectively behave more 
like an eagerly-prefetching non-coherent cache and write back old data 
over new - but if ddbd89deb7d3 alone makes a difference then something 
really weird must be going on.

Has anyone run a sanity check with CONFIG_DMA_API_DEBUG enabled to see 
if that flags anything up?

Robin.
