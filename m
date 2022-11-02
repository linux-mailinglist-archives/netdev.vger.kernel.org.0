Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C0615BF0
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 06:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKBFpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 01:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKBFpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 01:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4044C5F56;
        Tue,  1 Nov 2022 22:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8E27617B9;
        Wed,  2 Nov 2022 05:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7577C433D6;
        Wed,  2 Nov 2022 05:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667367913;
        bh=3YBSt5wgm3Trm7ZWFbPLf16P9pUekGeHScuENazaKmE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IvdoAqua2SAU/umZCtsBr1KMW+JdH6OpJxaNXxaH+R0dvW1u/JdmE5SfNzmsypOe8
         yNQm3BKWR7HQdIVE1WYKZ50aNz9mHaVNLUfvFmRq3IM0Ei7XpRV/peGdyMUJiU+JtT
         LDdzjJFtMIbplkLc1kpu4LObnWzlb64HTmyLDfu2oLQI3b5C/HVgRqTr54Iv0pCldH
         0ry4SXgGTBqmhwftzbbjTVbM8Tti55ATeN8FmrwLT8cLtEFD+7Dph9Bhwk4Od/5D3w
         XCbPkVxumvI9BF7du0qopTOWm+1tJZYw5rzlhUkmoohtDnRIIJJXR6B2U9/prZcEjN
         C+VneO1ZAMVuQ==
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
Date:   Wed, 02 Nov 2022 07:45:07 +0200
In-Reply-To: <CAC6wqPXjtkiP8pZ_nTXdZva6JnQLWbW7p+ukyAZO6scF5CR7Rw@mail.gmail.com>
        (Tyler Stachecki's message of "Tue, 1 Nov 2022 20:51:22 -0400")
Message-ID: <87edulvrj0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tyler Stachecki <stachecki.tyler@gmail.com> writes:

> On Tue, Nov 1, 2022 at 10:46 AM Kalle Valo <kvalo@kernel.org> wrote:
>>
>> "Tyler J. Stachecki" <stachecki.tyler@gmail.com> writes:
>>
>> > The 2.7.0 series of QCN9074's firmware requests 5 segments
>> > of memory instead of 3 (as in the 2.5.0 series).
>> >
>> > The first segment (11M) is too large to be kalloc'd in one
>> > go on x86 and requires piecemeal 1MB allocations, as was
>> > the case with the prior public firmware (2.5.0, 15M).
>> >
>> > Since f6f92968e1e5, ath11k will break the memory requests,
>> > but only if there were fewer than 3 segments requested by
>> > the firmware. It seems that 5 segments works fine and
>> > allows QCN9074 to boot on x86 with firmware 2.7.0, so
>> > change things accordingly.
>> >
>> > Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
>>
>> Ouch, that's pretty bad. Thanks for fixing this!
>>
>> Does the 2.5.0.1 firmware branch still work with this patch? It's
>> important that we don't break the old firmware.
>>
>> --
>> https://patchwork.kernel.org/project/linux-wireless/list/
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
> Yep, tested the patch with all 3 combinations, below:
>
> QCN9074:
> WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
>
> WCN6855:
> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.16

Excellent, I'll add Tested-on tags for these. Thank you again.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
