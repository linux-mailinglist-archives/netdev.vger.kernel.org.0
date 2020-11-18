Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1292B8314
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgKRRU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgKRRU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:20:28 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0947C0613D4;
        Wed, 18 Nov 2020 09:20:27 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id y22so2482477oti.10;
        Wed, 18 Nov 2020 09:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ATDEuVpLOju9Mm9/RI/1NtWHJeAR+WEeQ1UtKSWTQF4=;
        b=Fxwa1ziDMqTSUu0AoBlTRf49VSnTzmV+FosWSfG6nxNfcAHwLHWzuf01zy6wSTurFY
         P7LyUN5JHOzRXXA7QXL/K6DCVvqAGVNZ177gNgRm6wT0ly4Rwp0Mzx2Lh2V0Xv4Y9a+B
         meNHBUyuFjsyCBpF6TbrFhL2SNGdmQfXeLSI59xyyrtuykj1wSUW5WNfWgtScxn4USwp
         uRoL0YA0ETX3/ml3SIyTmm/HuGN9aKOO+oo8mUnJoUuNtOjozqpWcONfDDmmNPePKvEx
         yQzRSSANj9DW5uIffsqrbD/ToCSyOt4zDjRTBbg2l+xhLClBdbhuWyRDyEtzfcih1JeK
         rzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ATDEuVpLOju9Mm9/RI/1NtWHJeAR+WEeQ1UtKSWTQF4=;
        b=n14maso+//3+sSPgFHuVfv0TaY4dioGMbCMWvafDfbj198kK3Kc7vSoq6VJ32SPOiY
         UKnNyKm53SG12yyJafqnmxaJC83QnTQOcQp9i4jeoGR5zHAXljrzabs1pIf/c/SvQdgF
         Wf+KmwjT9qevNgLD5gEIGDlcJBGVbcmx50UEGdR/7CGuxmP+34Tvtjn2/4SinzIfKGI/
         GmcFtuP4jml1HjqWPvQGFCwTycJem0Rc/6bZ5oPZ345FdgX+0Lfq2RvC6/3FjhB86sQ8
         aGJeF0aUKiFWZYR9NsAeFycui/A72SO4AYcGLAfOdGFPmkWkVE+yJkQ1PD/Czn5gtVNW
         0Efw==
X-Gm-Message-State: AOAM532oZMxOSbgzn6zTZf612feTZNlpFHXmYC0QLzdZaZoqS4zvyVPZ
        IRUGCJWNMrVKEdSsX6+xBCtY2Q32bSU=
X-Google-Smtp-Source: ABdhPJyPJRuj21Zpk+C1i8QDS7iilen7A+7XxWs19B7OrEjq8TDxaXYAzQkOaK47WFudtkdaNstAVw==
X-Received: by 2002:a9d:171a:: with SMTP id i26mr6971266ota.313.1605720026808;
        Wed, 18 Nov 2020 09:20:26 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id z25sm954928ooj.39.2020.11.18.09.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 09:20:25 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH v2 1/4] rtlwifi: rtl8188ee: avoid accessing the data
 mapped to streaming DMA
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201118015314.4979-1-baijiaju1990@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d3996305-136a-708b-0dba-e9428f9da5cb@lwfinger.net>
Date:   Wed, 18 Nov 2020 11:20:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201118015314.4979-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 7:53 PM, Jia-Ju Bai wrote:
> In rtl88ee_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
> line 677:
>    dma_addr_t mapping = dma_map_single(..., skb->data, ...);
> 
> On line 680, skb->data is assigned to hdr after cast:
>    struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
> 
> Then hdr->frame_control is accessed on line 681:
>    __le16 fc = hdr->frame_control;
> 
> This DMA access may cause data inconsistency between CPU and hardwre.
> 
> To fix this bug, hdr->frame_control is accessed before the DMA mapping.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

What changed between v1 and v2?

As outlined in Documentation/process/submitting-patches.rst, you should add a 
'---' marker and descrive what was changed. I usually summarize the changes, but 
it is also possible to provide a diffstat of the changes as the above file shows.

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> index b9775eec4c54..c948dafa0c80 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> @@ -674,12 +674,12 @@ void rtl88ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
>   	u8 fw_queue = QSLT_BEACON;
>   	__le32 *pdesc = (__le32 *)pdesc8;
>   
> -	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
> -					    skb->len, DMA_TO_DEVICE);
> -
>   	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
>   	__le16 fc = hdr->frame_control;
>   
> +	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
> +					    skb->len, DMA_TO_DEVICE);
> +
>   	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
>   		rtl_dbg(rtlpriv, COMP_SEND, DBG_TRACE,
>   			"DMA mapping error\n");
> 

