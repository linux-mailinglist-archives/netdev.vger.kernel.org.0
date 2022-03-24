Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722324E6519
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350921AbiCXO3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350902AbiCXO32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:29:28 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEF67B105;
        Thu, 24 Mar 2022 07:27:54 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648132071; bh=tnWUB/odmMKWGyF8he0G98tAGrRwpBch0DMAenM1KqE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Nl31SHkGEOpmzbhGTx/T436+jfkG7FgLD/mSjYD7BSj0K+POWTP/XdxPCiodxbxQl
         fs/0XEz6ZSEqIigCk9/SGOf78e9BBUztwbBZDzqH/ljmF35/Ft7SaJ2tb+ZfJ3B82v
         5Ds6VCknje0VtdskIGdvIYT2IP30ry+Tg++Nwx0V4+GwyeAIHvqo5gXJBHda6FCGFN
         qWMkQGe87jzEr6SAA82toe9moP0NlIgQE7lxYyU93qrPdMDq9NoRbCop8YAlmyRwBG
         DCvoBiDd0G923RpGwr8v+jV+hGB48XSTTIsaeMsKUjkspEaeCquR+2Qwv8L3tLcNxb
         xaKx373cf/cWw==
To:     Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
In-Reply-To: <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
Date:   Thu, 24 Mar 2022 15:27:50 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878rsza0ih.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robin Murphy <robin.murphy@arm.com> writes:

> On 2022-03-24 10:25, Oleksandr Natalenko wrote:
>> Hello.
>>=20
>> On =C4=8Dtvrtek 24. b=C5=99ezna 2022 6:57:32 CET Christoph Hellwig wrote:
>>> On Wed, Mar 23, 2022 at 08:54:08PM +0000, Robin Murphy wrote:
>>>> I'll admit I still never quite grasped the reason for also adding the
>>>> override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I th=
ink
>>>> by that point we were increasingly tired and confused and starting to
>>>> second-guess ourselves (well, I was, at least). I don't think it's wro=
ng
>>>> per se, but as I said I do think it can bite anyone who's been doing
>>>> dma_sync_*() wrong but getting away with it until now. If ddbd89deb7d3
>>>> alone turns out to work OK then I'd be inclined to try a partial rever=
t of
>>>> just that one hunk.
>>>
>>> Agreed.  Let's try that first.
>>>
>>> Oleksandr, can you try the patch below:
>>>
>>>
>>> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
>>> index 6db1c475ec827..6c350555e5a1c 100644
>>> --- a/kernel/dma/swiotlb.c
>>> +++ b/kernel/dma/swiotlb.c
>>> @@ -701,13 +701,10 @@ void swiotlb_tbl_unmap_single(struct device *dev,=
 phys_addr_t tlb_addr,
>>>   void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t t=
lb_addr,
>>>   		size_t size, enum dma_data_direction dir)
>>>   {
>>> -	/*
>>> -	 * Unconditional bounce is necessary to avoid corruption on
>>> -	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
>>> -	 * the whole lengt of the bounce buffer.
>>> -	 */
>>> -	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
>>> -	BUG_ON(!valid_dma_direction(dir));
>>> +	if (dir =3D=3D DMA_TO_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
>>> +		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
>>> +	else
>>> +		BUG_ON(dir !=3D DMA_FROM_DEVICE);
>>>   }
>>>=20=20=20
>>>   void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_=
addr,
>>>
>>=20
>> With this patch the AP works for me.
>
> Cool, thanks for confirming. So I think ath9k probably is doing=20
> something dodgy with dma_sync_*(), but if Linus prefers to make the=20
> above change rather than wait for that to get figured out, I believe=20
> that should be fine.

I'm looking into this; but in the interest of a speedy resolution of the
regression I would be in favour of merging that partial revert and
reinstating it if/when we identify (and fix) any bugs in ath9k :)

-Toke
