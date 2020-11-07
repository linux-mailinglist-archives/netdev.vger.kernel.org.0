Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7532AA4C4
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgKGLob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:44:31 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:54471 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbgKGLoa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:44:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604749469; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=KfrqDO+sqQbyMbQAzatoYRHDEZ40eLbmXaDe9WdEpBQ=;
 b=BCf82n2nI/YxqnSUa9T3MLockUx/4/BQYjdUcH6Jz3oRkY6R5fask2vKDxyIf1I4yw8A2BVN
 TAi2/Ez+CaiPI1FjmyHCeYVsEOdxjE1xhaYYGu6sayiFuCVlQzMtow+fDACxRwPeB5uxSvmA
 CTs7sZ69EUouHRzTelU+lt7XBis=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fa6888c1d3980f7d667df5e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:44:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 87F8EC43382; Sat,  7 Nov 2020 11:44:12 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88C16C433C6;
        Sat,  7 Nov 2020 11:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 88C16C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8192ce: avoid accessing the data mapped to streaming
 DMA
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201019030931.4796-1-baijiaju1990@gmail.com>
References: <20201019030931.4796-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        straube.linux@gmail.com, Larry.Finger@lwfinger.net,
        christophe.jaillet@wanadoo.fr, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107114412.87F8EC43382@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 11:44:12 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> In rtl92ce_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
> line 530:
>   dma_addr_t mapping = dma_map_single(..., skb->data, ...);
> 
> On line 533, skb->data is assigned to hdr after cast:
>   struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
> 
> Then hdr->frame_control is accessed on line 534:
>   __le16 fc = hdr->frame_control;
> 
> This DMA access may cause data inconsistency between CPU and hardwre.
> 
> To fix this bug, hdr->frame_control is accessed before the DMA mapping.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Like Ping said, use "rtlwifi:" prefix and have all rtlwifi patches in
the same patchset.

4 patches set to Changes Requested.

11843533 rtl8192ce: avoid accessing the data mapped to streaming DMA
11843541 rtl8192de: avoid accessing the data mapped to streaming DMA
11843553 rtl8723ae: avoid accessing the data mapped to streaming DMA
11843557 rtl8188ee: avoid accessing the data mapped to streaming DMA

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201019030931.4796-1-baijiaju1990@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

