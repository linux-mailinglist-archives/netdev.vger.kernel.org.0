Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4485643C440
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbhJ0HrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:47:00 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59532 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240582AbhJ0Hq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 03:46:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635320675; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mz8nJIGGpohR0wU+Oe8hK35Xu2THKa0asqPSQzly+Qw=;
 b=mJe9irhQI3CrEPlLIYygTH3qkKDM3avvkh12hKtvBZiF1grX323aXmc6IqPrCK5ipOj6ppuU
 OWElueXigbrF2cFvfZiAOblMrfm824YQHTSdHLmvilbMbqf6x9z8NvkWGxY+DmOVh4nuQF9+
 P6wF24t1JjvUPch+6n+3GfBFE0M=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6179035a321f2400517d1dfd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:44:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D404FC43617; Wed, 27 Oct 2021 07:44:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 71612C4338F;
        Wed, 27 Oct 2021 07:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 71612C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: add proper DMA memory barriers in rx path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211023001528.3077822-1-benl@squareup.com>
References: <20211023001528.3077822-1-benl@squareup.com>
To:     Benjamin Li <benl@squareup.com>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163532066175.19793.9331674894554153079.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:44:26 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> wrote:

> This is essentially exactly following the dma_wmb()/dma_rmb() usage
> instructions in Documentation/memory-barriers.txt.
> 
> The theoretical races here are:
> 
> 1. DXE (the DMA Transfer Engine in the Wi-Fi subsystem) seeing the
> dxe->ctrl & WCN36xx_DXE_CTRL_VLD write before the dxe->dst_addr_l
> write, thus performing DMA into the wrong address.
> 
> 2. CPU reading dxe->dst_addr_l before DXE unsets dxe->ctrl &
> WCN36xx_DXE_CTRL_VLD. This should generally be harmless since DXE
> doesn't write dxe->dst_addr_l (no risk of freeing the wrong skb).
> 
> Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
> Signed-off-by: Benjamin Li <benl@squareup.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9bfe38e064af wcn36xx: add proper DMA memory barriers in rx path

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211023001528.3077822-1-benl@squareup.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

