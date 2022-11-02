Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2A6616A59
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiKBRP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiKBRPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:15:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69241091;
        Wed,  2 Nov 2022 10:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965CBB823F6;
        Wed,  2 Nov 2022 17:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B682C433C1;
        Wed,  2 Nov 2022 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667409316;
        bh=qK3bx7QoAh9fwPJHJizhUKV9fbdiG40FN0gZzQ2hwIg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=n03OxBc7g3UloZP5Z04sZpbPDxEhvFkRIXuQ0rcShfJ0CirVAxiXaKK6TJEJpUQZw
         JKU0gfhRV03o/QSNwHlTKskHaW7Zeg3jGsvarI1i1naMUOLbus8RMTLOD23ulMuD26
         FKcz82vtDP50uvekdh1h2tCM7PcWq3Rf+m5EajFQ1eYdHYpLmnpS1qKgE3BYyJvQ4E
         pMurRK7lH/3wAE+N6SQBdtXsT25zauiLT53iw89YJ2hYVeyzg2rsyJFNcv8l2kQPcs
         guppyO8qQUwq5UqxHF9MppL02VvMqW1H/vJ0enJ6mFjUALAdhmd1SKug5oY0fQo3Hu
         24jkyAkKAGxGA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Fix QCN9074 firmware boot on x86
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221022042728.43015-1-stachecki.tyler@gmail.com>
References: <20221022042728.43015-1-stachecki.tyler@gmail.com>
To:     "Tyler J. Stachecki" <stachecki.tyler@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        "Tyler J. Stachecki" <stachecki.tyler@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ath11k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH11K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)"Tyler J. Stachecki" <stachecki.tyler@gmail.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166740930971.12704.12404773753216417373.kvalo@kernel.org>
Date:   Wed,  2 Nov 2022 17:15:13 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Tyler J. Stachecki" <stachecki.tyler@gmail.com> wrote:

> The 2.7.0 series of QCN9074's firmware requests 5 segments
> of memory instead of 3 (as in the 2.5.0 series).
> 
> The first segment (11M) is too large to be kalloc'd in one
> go on x86 and requires piecemeal 1MB allocations, as was
> the case with the prior public firmware (2.5.0, 15M).
> 
> Since f6f92968e1e5, ath11k will break the memory requests,
> but only if there were fewer than 3 segments requested by
> the firmware. It seems that 5 segments works fine and
> allows QCN9074 to boot on x86 with firmware 2.7.0, so
> change things accordingly.
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.16
> 
> Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-current branch of ath.git, thanks.

3a89b6dec992 wifi: ath11k: Fix QCN9074 firmware boot on x86

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221022042728.43015-1-stachecki.tyler@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

