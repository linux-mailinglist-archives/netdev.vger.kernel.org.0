Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9D72C2ADE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbgKXPHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:07:12 -0500
Received: from z5.mailgun.us ([104.130.96.5]:27146 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730771AbgKXPHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:07:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606230431; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=LsuBxM5cnW7TMS67JlUwgXhRD1y+7X2AiH5GtE5Sr0g=;
 b=a8Y6m36+Asa0mNdzd308O65dN0ntqCfRqWddC+xBNPDIv9V12B2r3crWRHD3mradK2AzF3L+
 q7A41hX6XeAhdCzf3HzEXxnWoyhcBo01N85k33uJU2kK1+iYhHfPTWLoY1wESHpE/YNC9u6s
 fPGAescshWJWXu65Uw8ZRPZobcw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fbd21971b731a5d9c4090fd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 15:07:03
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C911EC43461; Tue, 24 Nov 2020 15:07:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 42B4BC433ED;
        Tue, 24 Nov 2020 15:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 42B4BC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/4 resend] rtlwifi: rtl8188ee: avoid accessing the
 data
 mapped to streaming DMA
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201119015127.12033-1-baijiaju1990@gmail.com>
References: <20201119015127.12033-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201124150702.C911EC43461@smtp.codeaurora.org>
Date:   Tue, 24 Nov 2020 15:07:02 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> In rtl88ee_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
> line 677:
>   dma_addr_t mapping = dma_map_single(..., skb->data, ...);
> 
> On line 680, skb->data is assigned to hdr after cast:
>   struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
> 
> Then hdr->frame_control is accessed on line 681:
>   __le16 fc = hdr->frame_control;
> 
> This DMA access may cause data inconsistency between CPU and hardwre.
> 
> To fix this bug, hdr->frame_control is accessed before the DMA mapping.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

4 patches applied to wireless-drivers-next.git, thanks.

6df3c293d284 rtlwifi: rtl8188ee: avoid accessing the data mapped to streaming DMA
c7ba0ea0df37 rtlwifi: rtl8192ce: avoid accessing the data mapped to streaming DMA
ff7654833894 rtlwifi: rtl8192de: avoid accessing the data mapped to streaming DMA
8b2c13b2e5da rtlwifi: rtl8723ae: avoid accessing the data mapped to streaming DMA

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201119015127.12033-1-baijiaju1990@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

