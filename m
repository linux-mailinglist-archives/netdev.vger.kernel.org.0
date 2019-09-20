Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B55B9097
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfITNZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 09:25:28 -0400
Received: from foss.arm.com ([217.140.110.172]:44720 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfITNZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 09:25:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA67F1570;
        Fri, 20 Sep 2019 06:25:26 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68BB93F67D;
        Fri, 20 Sep 2019 06:25:23 -0700 (PDT)
Subject: Re: [PATCH] mt7601u: phy: simplify zero check on val
To:     Colin King <colin.king@canonical.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190920125414.15507-1-colin.king@canonical.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <2f9ab78a-ea76-0b60-375a-9a22cd2ff0f5@arm.com>
Date:   Fri, 20 Sep 2019 14:25:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190920125414.15507-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2019 13:54, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the zero check on val to break out of a loop
> is a little obscure.  Replace the val is zero and break check
> with a loop while value is non-zero.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/wireless/mediatek/mt7601u/phy.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
> index 06f5702ab4bd..4e0e473caae1 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/phy.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
> @@ -213,9 +213,7 @@ int mt7601u_wait_bbp_ready(struct mt7601u_dev *dev)
>   
>   	do {
>   		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
> -		if (val && ~val)
> -			break;

AFAICS, this effectively implements "while (val == 0 || val == 0xff)", 
which is not at all equivalent to "while(val)"... :/

Robin.

> -	} while (--i);
> +	} while (val && --i);
>   
>   	if (!i) {
>   		dev_err(dev->dev, "Error: BBP is not ready\n");
> 
