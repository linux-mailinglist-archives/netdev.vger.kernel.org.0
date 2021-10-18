Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0B431A6F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhJRNM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:12:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:26758 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhJRNM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 09:12:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634562647; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=2iZh5xPrIPUDbVFXGh7W2cb2/hGVEE7gEkCaxI5tQ2Y=; b=V1CJJh0dPIw1jvkmebXK/qfQ7H0f/BKVH1Q2N4TOZ5eFPRuTsZirqnaHDugeflZlntUzG+DD
 87CL5+9KYGq4JbijAWUCHeHSezlIac3GeXoNJBGzoLIb2ds1xwgwCwFRg+Mq58BBCW7DCdPk
 OfqMmuNJbhLgNwXTAXsMLMEfNZo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 616d72490605239689a079b1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 13:10:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AAA0BC4361C; Mon, 18 Oct 2021 13:10:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D04D4C4338F;
        Mon, 18 Oct 2021 13:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D04D4C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Wen Gong <wgong@codeaurora.org>,
        Tamizh Chelvam <tamizhr@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        Ben Greear <greearb@candelatech.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Fabio Estevam <festevam@denx.de>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix invalid dma_addr_t token assignment
References: <20211014075153.3655910-1-arnd@kernel.org>
Date:   Mon, 18 Oct 2021 16:10:21 +0300
In-Reply-To: <20211014075153.3655910-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Thu, 14 Oct 2021 09:51:15 +0200")
Message-ID: <87fssytr5u.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Using a kernel pointer in place of a dma_addr_t token can
> lead to undefined behavior if that makes it into cache
> management functions. The compiler caught one such attempt
> in a cast:
>
> drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_add_interface':
> drivers/net/wireless/ath/ath10k/mac.c:5586:47: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>  5586 |                         arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
>       |                                               ^
>
> Looking through how this gets used down the way, I'm fairly
> sure that beacon_paddr is never accessed again for ATH10K_DEV_TYPE_HL
> devices, and if it was accessed, that would be a bug.

That's my understanding as well. beacon_paddr is only accessed in
ath10k_wmi_event_host_swba() and only low latency (ATH10K_DEV_TYPE_LL)
should use that function.

> Change the assignment to use a known-invalid address token
> instead, which avoids the warning and makes it easier to catch
> bugs if it does end up getting used.
>
> Fixes: e263bdab9c0e ("ath10k: high latency fixes for beacon buffer")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 7ca68c81d9b6..c0e78eaa65f8 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5583,7 +5583,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>  		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
>  			arvif->beacon_buf = kmalloc(IEEE80211_MAX_FRAME_LEN,
>  						    GFP_KERNEL);
> -			arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
> +			arvif->beacon_paddr = DMA_MAPPING_ERROR;

In the pending branch I added a comment here:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=02a383c9bf959147a95c4efeaa4edf35c4450fac

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
