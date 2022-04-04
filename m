Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6066A4F0FCA
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 09:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377585AbiDDHIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 03:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiDDHIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 03:08:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C7B340E0;
        Mon,  4 Apr 2022 00:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7B361223;
        Mon,  4 Apr 2022 07:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23734C340EE;
        Mon,  4 Apr 2022 07:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649056007;
        bh=kBUstR3J4ItDnVp87evnZA04BHghVTsaKKXGf6QdOCs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Tg/FdtHFmcrmCnSrrTX6e2TfhXvy+gFfSfrRcwTmUN+vOL+1fUZr1X+O9oNBsK77G
         j4ChIZ0Ix083n7qG+D3ZNnSEM8lrbY4Uq3iQQwrHJu+meR56KfXxfiJHs7vQ0XMaRk
         fs/xuIsVC64ZovxMTZFxb0Tw+iN2In5PF1eiIeLwqk3rpM4LanwAswPaJvK+0x2CiS
         MilTbKqH2arAIBqv8rfpBfv+e2GfoR0r67Dkn2opw6HL32p6G8fiuQHRuvMLUXjWyT
         +oqJlrBF0Hw7yZayJMq9oMj2UWYAhFUjmc4NY19QxRoDLi/oFTzx4cvE4JrEUOgsol
         lXXzkUj2VF3vA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath11k: select QRTR for AHB as well
References: <20220401093554.360211-1-robimarko@gmail.com>
        <87ilrsuab4.fsf@kernel.org>
        <CAOX2RU4pCn8C-HhhuOzyikjk2Ax3VDcjMKh7N6X5HeMN4xLMEg@mail.gmail.com>
Date:   Mon, 04 Apr 2022 10:06:40 +0300
In-Reply-To: <CAOX2RU4pCn8C-HhhuOzyikjk2Ax3VDcjMKh7N6X5HeMN4xLMEg@mail.gmail.com>
        (Robert Marko's message of "Sat, 2 Apr 2022 11:52:21 +0200")
Message-ID: <87zgl1s4xr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robimarko@gmail.com> writes:

> On Fri, 1 Apr 2022 at 16:51, Kalle Valo <kvalo@kernel.org> wrote:
>>
>> Robert Marko <robimarko@gmail.com> writes:
>>
>> > Currently, ath11k only selects QRTR if ath11k PCI is selected, however
>> > AHB support requires QRTR, more precisely QRTR_SMD because it is using
>> > QMI as well which in turn uses QRTR.
>> >
>> > Without QRTR_SMD AHB does not work, so select QRTR in ATH11K and then
>> > select QRTR_SMD for ATH11K_AHB and QRTR_MHI for ATH11K_PCI.
>> >
>> > Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
>> >
>> > Signed-off-by: Robert Marko <robimarko@gmail.com>
>> > ---
>> >  drivers/net/wireless/ath/ath11k/Kconfig | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
>> > index ad5cc6cac05b..b45baad184f6 100644
>> > --- a/drivers/net/wireless/ath/ath11k/Kconfig
>> > +++ b/drivers/net/wireless/ath/ath11k/Kconfig
>> > @@ -5,6 +5,7 @@ config ATH11K
>> >       depends on CRYPTO_MICHAEL_MIC
>> >       select ATH_COMMON
>> >       select QCOM_QMI_HELPERS
>> > +     select QRTR
>> >       help
>> >         This module adds support for Qualcomm Technologies 802.11ax family of
>> >         chipsets.
>> > @@ -15,6 +16,7 @@ config ATH11K_AHB
>> >       tristate "Atheros ath11k AHB support"
>> >       depends on ATH11K
>> >       depends on REMOTEPROC
>> > +     select QRTR_SMD
>> >       help
>> >         This module adds support for AHB bus
>> >
>> > @@ -22,7 +24,6 @@ config ATH11K_PCI
>> >       tristate "Atheros ath11k PCI support"
>> >       depends on ATH11K && PCI
>> >       select MHI_BUS
>> > -     select QRTR
>> >       select QRTR_MHI
>> >       help
>> >         This module adds support for PCIE bus
>>
>> I now see a new warning:
>>
>> WARNING: unmet direct dependencies detected for QRTR_SMD
>>   Depends on [n]: NET [=y] && QRTR [=m] && (RPMSG [=n] || COMPILE_TEST [=n] && RPMSG [=n]=n)
>>   Selected by [m]:
>>   - ATH11K_AHB [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && ATH11K [=m] && REMOTEPROC [=y]
>
> Ahh yeah, since it's SMD then it requires RPMGS which in turn requires
> more stuff. What do you think about making it depend on QRTR_SMD
> instead, because without it AHB literally does not work?

To be honest I don't know qrtr well enough to comment right now :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
