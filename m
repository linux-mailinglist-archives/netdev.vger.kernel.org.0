Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA67614CF9
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiKAOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKAOq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31BE13CEC;
        Tue,  1 Nov 2022 07:46:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F854615E8;
        Tue,  1 Nov 2022 14:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A6BC433D6;
        Tue,  1 Nov 2022 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667313987;
        bh=mRINjiRnOBOfJq5iqp3pBxJc+AyDgUafRTpJ4I4NiSs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RSXbWW3paXaR2HPrTjmIaRk/tUgJLKZDePR4ioQKd4K6iiIO6BK8hax1OwbNUQzHR
         WEzqQPCSTrbwm7kh2aPkI0/e2SjTpS0nKQfOkchKjCScUg6TM+nIaKC5l6yQqF/5pJ
         A3LXEjeeKWJr8K6yKd8DJLqsSllRWGtc6KJAt9g3TVgslR+3gp7XC7nDJgGTMVE8Jr
         fgtwTNltOt6C81CdwrJbl7ew5wekQ2AkcF8uZIjCu2uHa3+l4/TZg9MWpPvjHo39CH
         cztGWNbVRT184KoZ2dcnMgOZ4+KGwR4kXLf5nIB67KFzcTij3GDeqS8N0chnmEwYVV
         jebF+Q2ERWRuA==
From:   Kalle Valo <kvalo@kernel.org>
To:     "Tyler J. Stachecki" <stachecki.tyler@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ath11k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH11K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] ath11k: Fix QCN9074 firmware boot on x86
References: <20221022042728.43015-1-stachecki.tyler@gmail.com>
Date:   Tue, 01 Nov 2022 16:46:22 +0200
In-Reply-To: <20221022042728.43015-1-stachecki.tyler@gmail.com> (Tyler J.
        Stachecki's message of "Sat, 22 Oct 2022 00:27:28 -0400")
Message-ID: <87y1sug2bl.fsf@kernel.org>
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

"Tyler J. Stachecki" <stachecki.tyler@gmail.com> writes:

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
> Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>

Ouch, that's pretty bad. Thanks for fixing this!

Does the 2.5.0.1 firmware branch still work with this patch? It's
important that we don't break the old firmware.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
