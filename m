Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C9D616103
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiKBKiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiKBKhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:37:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4C62936F;
        Wed,  2 Nov 2022 03:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 593E0B82078;
        Wed,  2 Nov 2022 10:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5FCC433C1;
        Wed,  2 Nov 2022 10:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667385436;
        bh=e2Pf5tH9e17qtvqUbk6y6qwTol1CmGJDuVLGWQfNJnk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HIxbx8DHYPho2RHu1Xsl9LnJcKqCx5XP7a590YE6XgcTl2oSfpmTlRvuQV+C8/QXT
         DvNKTMOZXc9I1SRY4APGau56HT9JI43hbRJWksUZqhV4r7HFJeuHZx65pomTierPhw
         re6VR15yDCDStv/evTW0BOALRJZ9Pgwc1/2TtwDwQAfaUdX7VRWqiPSH95VlS/hDrr
         xbd1j48WS7hSflxkq145uKYVD6lLR3nDykLZ/n2v2f3PqbH0z3zHa7vpJ6ISg372Lc
         aigBXpnYowkCCVIZ3JT96A2ecIP7KvaNAJGhlx6cbp+HbwK7TqVKdGXWHwgrObhk4m
         yMAtfN/Gw4u2A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list\:QUALCOMM ATHEROS ATH11K WIRELESS DRIVER" 
        <ath11k@lists.infradead.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath11k: Fix QCN9074 firmware boot on x86
References: <20221022042728.43015-1-stachecki.tyler@gmail.com>
        <87y1sug2bl.fsf@kernel.org>
        <CAC6wqPXjtkiP8pZ_nTXdZva6JnQLWbW7p+ukyAZO6scF5CR7Rw@mail.gmail.com>
        <87edulvrj0.fsf@kernel.org>
Date:   Wed, 02 Nov 2022 12:37:09 +0200
In-Reply-To: <87edulvrj0.fsf@kernel.org> (Kalle Valo's message of "Wed, 02 Nov
        2022 07:45:07 +0200")
Message-ID: <87pme5fxre.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Tyler Stachecki <stachecki.tyler@gmail.com> writes:
>
>> On Tue, Nov 1, 2022 at 10:46 AM Kalle Valo <kvalo@kernel.org> wrote:
>>>
>>> "Tyler J. Stachecki" <stachecki.tyler@gmail.com> writes:
>>>
>>> > The 2.7.0 series of QCN9074's firmware requests 5 segments
>>> > of memory instead of 3 (as in the 2.5.0 series).
>>> >
>>> > The first segment (11M) is too large to be kalloc'd in one
>>> > go on x86 and requires piecemeal 1MB allocations, as was
>>> > the case with the prior public firmware (2.5.0, 15M).
>>> >
>>> > Since f6f92968e1e5, ath11k will break the memory requests,
>>> > but only if there were fewer than 3 segments requested by
>>> > the firmware. It seems that 5 segments works fine and
>>> > allows QCN9074 to boot on x86 with firmware 2.7.0, so
>>> > change things accordingly.
>>> >
>>> > Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
>>>
>>> Ouch, that's pretty bad. Thanks for fixing this!
>>>
>>> Does the 2.5.0.1 firmware branch still work with this patch? It's
>>> important that we don't break the old firmware.
>>>
>>> --
>>> https://patchwork.kernel.org/project/linux-wireless/list/
>>>
>>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>>
>> Yep, tested the patch with all 3 combinations, below:
>>
>> QCN9074:
>> WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
>> WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
>>
>> WCN6855:
>> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.16
>
> Excellent, I'll add Tested-on tags for these. Thank you again.

I'll think I'll queue this to v6.1, it's an important fix to have.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
