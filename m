Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF5F621A63
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbiKHRYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiKHRYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8F4E61;
        Tue,  8 Nov 2022 09:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67803616B5;
        Tue,  8 Nov 2022 17:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA76C433D6;
        Tue,  8 Nov 2022 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667928269;
        bh=3I2an1duxohv2+c8cwYzYE3GreFTHQqmioncGIw5CXY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RRkeyAlngu16woa3Ip9iR6+Rnuf99/z8u53ayXiByCj8558mDTeR69SIJ7rai+twB
         UkPZ+jUjWOYUWTPcfZHGSXl8Z7v2NJhklCepECtokGW9sVIfesk3UlhczcX6Kssuil
         Ig6Eel2ECX87BEZbM9A10Ue4aTn3HW0RSShHgieh9iWDgM/J5mErc/NZhXo2ixEaYx
         OwpbmTWovf20WbVvaJsYBLR/z6HLhdM1mm1mR7/JXxG8HRNtaquWMdKOMmUMWFMZpA
         369950n87l2IubAjpv8HOs7ONDb4bXb/+CbRXXCr5e/QpoucfrFPvTkMyLP7gUBM9k
         xAGTV3zZ4vaWw==
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
        <20221107174727.GA7535@thinkpad>
Date:   Tue, 08 Nov 2022 19:24:22 +0200
In-Reply-To: <20221107174727.GA7535@thinkpad> (Manivannan Sadhasivam's message
        of "Mon, 7 Nov 2022 23:17:27 +0530")
Message-ID: <87cz9xcqbd.fsf@kernel.org>
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

Manivannan Sadhasivam <mani@kernel.org> writes:

> On Sat, Nov 05, 2022 at 08:49:43PM +0100, Robert Marko wrote:
>> Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
>> will cause a clash in the QRTR instance node ID and prevent the driver
>> from talking via QMI to the card and thus initializing it with:
>> [    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
>> [    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22
>> 
>
> There is still an outstanding issue where you cannot connect two WLAN modules
> with same node id.
>
>> So, in order to allow for this combination of cards, especially AHB + PCI
>> cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
>> QRTR instance ID offset by calculating a unique one based on PCI domain
>> and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
>> using the SBL state callback that is added as part of the series.
>> We also have to make sure that new QRTR offset is added on top of the
>> default QRTR instance ID-s that are currently used in the driver.
>> 
>
> Register BHI_ERRDBG2 is listed as Read only from Host as per the BHI spec.
> So I'm not sure if this solution is going to work on all ath11k supported
> chipsets.
>
> Kalle, can you confirm?

I can't look at this in detail right now, but hopefully in few days.
I'll get back to you.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
