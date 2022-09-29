Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3025EEECE
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiI2HWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiI2HWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCCFDCEB9;
        Thu, 29 Sep 2022 00:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2679261F88;
        Thu, 29 Sep 2022 07:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0400DC433C1;
        Thu, 29 Sep 2022 07:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436131;
        bh=5yUlZsBlhSSLMgY5U2rEuCCjJuZnbqFQEkw2xiVwspo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NgVcBTtjhA69DpmrwjWkA002BkIPHRxnYrXZDY+Sqa4P6k/oidxgH+MwcahR7TO9m
         JN5fmvtPXOZORdmF7xdvjvn7Wi/p2ph1HvOc19rGvS3VhLVSGvu/SZtUmemn+SEfyW
         Ymzq48aMwnrAUGV9gGG8AphE8o0OPat+Ew7g1UB5ojzp4513V6sdzwvihOMtOf9P6q
         vMTN/Rg0EerssGfuinLstazA7FUUfRiB6M+mEMj9szR4E3nmLwe9CAkIeB7hrCR0dF
         9/prOSgK56i0zScyGqBIoxyN7lTlM3icqNxGiGxDMBxkXbInbkyx+8t1u/dXawM2UW
         X4cjRnaNgT/6g==
Date:   Thu, 29 Sep 2022 10:22:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org
Subject: Re: [PATCH V4] mISDN: fix use-after-free bugs in l1oip timer handlers
Message-ID: <YzVHn6Gtfog6RyNR@unreal>
References: <20220928133938.86143-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928133938.86143-1-duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 09:39:38PM +0800, Duoming Zhou wrote:
> The l1oip_cleanup() traverses the l1oip_ilist and calls
> release_card() to cleanup module and stack. However,
> release_card() calls del_timer() to delete the timers
> such as keep_tl and timeout_tl. If the timer handler is
> running, the del_timer() will not stop it and result in
> UAF bugs. One of the processes is shown below:
> 
>     (cleanup routine)          |        (timer handler)
> release_card()                 | l1oip_timeout()
>  ...                           |
>  del_timer()                   | ...
>  ...                           |
>  kfree(hc) //FREE              |
>                                | hc->timeout_on = 0 //USE
> 
> Fix by calling del_timer_sync() in release_card(), which
> makes sure the timer handlers have finished before the
> resources, such as l1oip and so on, have been deallocated.
> 
> What's more, the hc->workq and hc->socket_thread can kick
> those timers right back in. We add a bool flag to show
> if card is released. Then, check this flag in hc->workq
> and hc->socket_thread.
> 
> Fixes: 3712b42d4b1b ("Add layer1 over IP support")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v4:
>   - Use bool flag to judge whether card is released.
> 
>  drivers/isdn/mISDN/l1oip.h      |  1 +
>  drivers/isdn/mISDN/l1oip_core.c | 13 +++++++------
>  2 files changed, 8 insertions(+), 6 deletions(-)

It looks like it is ok now, but whole mISDN code doesn't look healthy,
so it is hard to say for sure.

Are you fixing real issue that you saw in field?

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
