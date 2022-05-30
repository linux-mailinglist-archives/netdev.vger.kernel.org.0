Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB2F5379BD
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiE3LYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiE3LYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:24:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328C447AF2;
        Mon, 30 May 2022 04:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D096116C;
        Mon, 30 May 2022 11:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D310C385B8;
        Mon, 30 May 2022 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653909849;
        bh=X76kuCTxQRPqflicERZfaDFhMhzgz1v/0Rbb41psmy4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=t1i80dAspABZNrHnh3CJxYx79rgvNNGjvPX3cR6Wct6JsdBHcY5pkZ5eK6a61Vvyi
         RZbIbgpJyYgzBJMxPadmSXWNblu9XtFg4CLeW+zIlBJY86FZoueA0mJA3ZDJFM10wo
         na/oKaNtUABTwr3oeVFIex0b4U89J9kMCX8e20PIwo4avuK1Wn0y30v21Jm7RBshEO
         pmxntaQCOtWvUznIUPz+blSolSBCCUI0c8Av+mAqMOY8q6gX7bakry0Yo7eq58kSY0
         HYtGwmvScT+ITKzZOZQRzy0qHkKPVOEyqyUHuUw68P5Ld9HvXnx10cQIPQF/t6EiZc
         PDFZlzhZzvcTg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-wireless@vger.kernel.org, pontus.fuchs@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] ar5523: Fix deadlock bugs caused by cancel_work_sync in ar5523_stop
References: <20220522133055.96405-1-duoming@zju.edu.cn>
Date:   Mon, 30 May 2022 14:24:04 +0300
In-Reply-To: <20220522133055.96405-1-duoming@zju.edu.cn> (Duoming Zhou's
        message of "Sun, 22 May 2022 21:30:55 +0800")
Message-ID: <877d63uuuj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duoming Zhou <duoming@zju.edu.cn> writes:

> If the work item is running, the cancel_work_sync in ar5523_stop will
> not return until work item is finished. If we hold mutex_lock and use
> cancel_work_sync to wait the work item to finish, the work item such as
> ar5523_tx_wd_work and ar5523_tx_work also require mutex_lock. As a result,
> the ar5523_stop will be blocked forever. One of the race conditions is
> shown below:
>
>     (Thread 1)             |   (Thread 2)
> ar5523_stop                |
>   mutex_lock(&ar->mutex)   | ar5523_tx_wd_work
>                            |   mutex_lock(&ar->mutex)
>   cancel_work_sync         |   ...
>
> This patch moves cancel_work_sync out of mutex_lock in order to mitigate
> deadlock bugs.
>
> Fixes: b7d572e1871d ("ar5523: Add new driver")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>

I assume you have found this with a static checker tool, it would be
good document what tool you are using. And if you have not tested this
with real hardware clearly mention that with "Compile tested only".

> ---
>  drivers/net/wireless/ath/ar5523/ar5523.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> index 9cabd342d15..99d6b13ffcf 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -1071,8 +1071,10 @@ static void ar5523_stop(struct ieee80211_hw *hw)
>  	ar5523_cmd_write(ar, WDCMSG_TARGET_STOP, NULL, 0, 0);
>  
>  	del_timer_sync(&ar->tx_wd_timer);
> +	mutex_unlock(&ar->mutex);
>  	cancel_work_sync(&ar->tx_wd_work);
>  	cancel_work_sync(&ar->rx_refill_work);
> +	mutex_lock(&ar->mutex);
>  	ar5523_cancel_rx_bufs(ar);
>  	mutex_unlock(&ar->mutex);
>  }

Releasing a lock and taking it again looks like a hack to me. Please
test with a real device and try to find a better solution.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
