Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C464E6FEB
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 10:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356736AbiCYJXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 05:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345014AbiCYJXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 05:23:23 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A99BCF49F;
        Fri, 25 Mar 2022 02:21:49 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nXg8U-00023m-32; Fri, 25 Mar 2022 10:21:34 +0100
Message-ID: <a45549b5-1c05-f995-2c0f-99c0e40cea09@leemhuis.info>
Date:   Fri, 25 Mar 2022 10:21:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Content-Language: en-US
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@toke.dk>
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
References: <1812355.tdWV9SEqCh@natalenko.name>
 <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
 <4699073.GXAFRqVoOG@natalenko.name>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <4699073.GXAFRqVoOG@natalenko.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1648200109;1a0d0afe;
X-HE-SMSGID: 1nXg8U-00023m-32
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.22 08:12, Oleksandr Natalenko wrote:
> On čtvrtek 24. března 2022 18:07:29 CET Toke Høiland-Jørgensen wrote:
>> Right, but is that sync_for_device call really needed? AFAICT, that
>> ath9k_hw_process_rxdesc_edma() invocation doesn't actually modify any of
>> the data when it returns EINPROGRESS, so could we just skip it? Like
>> the patch below? Or am I misunderstanding the semantics here?
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index 0c0624a3b40d..19244d4c0ada 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -647,12 +647,8 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
>>                                 common->rx_bufsize, DMA_FROM_DEVICE);
>>  
>>         ret = ath9k_hw_process_rxdesc_edma(ah, rs, skb->data);
>> -       if (ret == -EINPROGRESS) {
>> -               /*let device gain the buffer again*/
>> -               dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
>> -                               common->rx_bufsize, DMA_FROM_DEVICE);
>> +       if (ret == -EINPROGRESS)
>>                 return false;
>> -       }
>>  
>>         __skb_unlink(skb, &rx_edma->rx_fifo);
>>         if (ret == -EINVAL) {
> 
> With this patch and both ddbd89deb7d3+aa6f8dcbab47 in place the AP works for me.

TWIMC: If anyone needs more testers or something, I noticed two bug
report in bko about this problem:

https://bugzilla.kernel.org/show_bug.cgi?id=215703
https://bugzilla.kernel.org/show_bug.cgi?id=215698

I'll point both to this discussion and the patch.

Ciao, Thorsten
