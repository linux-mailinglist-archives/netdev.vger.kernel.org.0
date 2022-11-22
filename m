Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E3F633B6B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiKVLcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiKVLbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:31:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A521860E8A;
        Tue, 22 Nov 2022 03:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 311F661671;
        Tue, 22 Nov 2022 11:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8711C433D7;
        Tue, 22 Nov 2022 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669116390;
        bh=wpFinb0IMYn50p3PDwUFVzoQbgbhxdX0aMO0iiEe7wY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kOoeyjcwSPnSu0LZeG5wzcHO5zKGyJ3SjPV3ItIN/Efm99PtC+mE7dmmDcdVfJmFF
         U56/XJgtp6mg3MyLONRIkKKMqZU4OAqXyO9uQDVL7POSIdpPQ/5TSOAPhNItlTgn6J
         qhsX7hrBbsicZ3b2hCii8e2tIdaqes+DNf8BsXkDS3Z0Vvo9NUbjwOM57rniqnzS2z
         XCz9yxHnppwPFrBIEiBKeYufojxwZ8TKF+Grp47c80qqLkTRjVnOqVmpPNAgKKx9zh
         UKmh3sWnOWow86WOxV1TLv49k4nSX5lH1pEcD20ZQ2FcJBeIouRQ/qWUWCTdsjYyEv
         3UtCKpsE7uW2Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Robert Marko <robimarko@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ansuelsmth@gmail.com
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
References: <20221105194943.826847-1-robimarko@gmail.com>
        <20221105194943.826847-2-robimarko@gmail.com>
        <20221107174727.GA7535@thinkpad> <87cz9xcqbd.fsf@kernel.org>
Date:   Tue, 22 Nov 2022 13:26:24 +0200
In-Reply-To: <87cz9xcqbd.fsf@kernel.org> (Kalle Valo's message of "Tue, 08 Nov
        2022 19:24:22 +0200")
Message-ID: <877czn8c2n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Manivannan Sadhasivam <mani@kernel.org> writes:
>
>> On Sat, Nov 05, 2022 at 08:49:43PM +0100, Robert Marko wrote:
>>> Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
>>> will cause a clash in the QRTR instance node ID and prevent the driver
>>> from talking via QMI to the card and thus initializing it with:
>>> [    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
>>> [    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22
>>> 
>>
>> There is still an outstanding issue where you cannot connect two WLAN modules
>> with same node id.
>>
>>> So, in order to allow for this combination of cards, especially AHB + PCI
>>> cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
>>> QRTR instance ID offset by calculating a unique one based on PCI domain
>>> and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
>>> using the SBL state callback that is added as part of the series.
>>> We also have to make sure that new QRTR offset is added on top of the
>>> default QRTR instance ID-s that are currently used in the driver.
>>> 
>>
>> Register BHI_ERRDBG2 is listed as Read only from Host as per the BHI spec.
>> So I'm not sure if this solution is going to work on all ath11k supported
>> chipsets.
>>
>> Kalle, can you confirm?
>
> I can't look at this in detail right now, but hopefully in few days.
> I'll get back to you.

The solution we have been thinking internally would not use
MHI_CB_EE_SBL_MODE at all, it's not clear for me yet why the mode was
not needed in our solution. Maybe there are firmware modifications? I
think it's best that we submit our proposal as well, then we can then
compare implementations and see what is the best course of action.

But it looks that not all ath11k hardware and firmware releases support
this feature, we would need meta data information from the firmware to
detect it. I am working on adding firmware meta data support[1] to
ath11k, will post patches for that "soon".

[1] similar to firmware-N.bin support ath10k has

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
