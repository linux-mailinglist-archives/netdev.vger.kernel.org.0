Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE804B0D49
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241465AbiBJMQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:16:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:16:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7F1116D;
        Thu, 10 Feb 2022 04:16:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3965EB82426;
        Thu, 10 Feb 2022 12:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A27C004E1;
        Thu, 10 Feb 2022 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644495395;
        bh=EtUqhE4EZ9tdkev8HxZrxLizLPpEiWHGvcR5Smiyjcc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=r1O7Xl728X6lQMXclEDmP1qt51soJ34yuAs975UmUN1mwAwIz8lI8E5ZDMW4x9r0k
         uzcOjB40XXO7jYXPE97bky+6IS4ffDfvh9ikj191yBlRPPo83CvZd/fsLwDKxSdeKq
         9r/v13pF/CwrXDrcSbLX1B9vwEQgLvf4Jg0sXF0Yq0YSHlUDjHmxxIiyKs06iXFJnC
         tiPliv7heN7wLogCp8zs6JYpCg6zK4u2G/EkAeZSr/6J/arUMgXgeKDRxnhdxjazfl
         VHsWlsWJLLxWKHENbSfw9pQLX0zJT4r/kgsX6mRpPnwZt/3jpLJMMboIPR3hpVQUrs
         DSlB7J+M5gLGA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ath: use div64_u64() instead of do_div()
References: <1644395972-4303-1-git-send-email-wangqing@vivo.com>
Date:   Thu, 10 Feb 2022 14:16:28 +0200
In-Reply-To: <1644395972-4303-1-git-send-email-wangqing@vivo.com> (Qing Wang's
        message of "Wed, 9 Feb 2022 00:39:32 -0800")
Message-ID: <877da2c3xf.fsf@tynnyri.adurom.net>
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

Qing Wang <wangqing@vivo.com> writes:

> From: Wang Qing <wangqing@vivo.com>
>
> do_div() does a 64-by-32 division.
> When the divisor is u64, do_div() truncates it to 32 bits, this means it
> can test non-zero and be truncated to zero for division.
>
> fix do_div.cocci warning:
> do_div() does a 64-by-32 division, please consider using div64_u64 instead.
>
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index 4c944e5..2cee9dd
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -1766,7 +1766,7 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
>  			seq_puts(s, "\n");
>  			if (!num_packets)
>  				continue;
> -			do_div(tx_latency_avg, num_packets);
> +			div64_u64(tx_latency_avg, num_packets);

As you have been pointed out in your other patches, do_div() and
div64_u64() work differently.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
