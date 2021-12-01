Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566E94653D5
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351824AbhLAR0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:26:03 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:13779 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241289AbhLAR0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638379360; x=1669915360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vlNXZUymzyuuroQ9ghBCswMVj5MU29+Wcv0U/rbpDLc=;
  b=BL6P8j1K1mn1Y9oe6bA+Q3d3Re31bXqtyHm43rISrtj8v5aFYcYWdi6y
   UcuoGrd2I8f5NsTjBvPjQsuVzmfOcQdTW6tC8DyKU3h4lUXSjQ5/bld9g
   wponxdBWyJg8OXB1jy+BqyK9FsPqripe56gryRGJMrTidX4n1oSREgn1N
   I=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 01 Dec 2021 09:22:39 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 09:22:38 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Wed, 1 Dec 2021 09:22:38 -0800
Received: from [10.48.242.103] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Wed, 1 Dec 2021
 09:22:37 -0800
Message-ID: <a29a8153-2a4f-1876-ec48-47e08db00a98@quicinc.com>
Date:   Wed, 1 Dec 2021 09:22:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH] ath11k: Fix a NULL pointer dereference in
 ath11k_mac_op_hw_scan()
Content-Language: en-US
To:     Zhou Qingyang <zhou1615@umn.edu>
CC:     <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Govindaraj Saminathan <gsamin@codeaurora.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211130084304.72160-1-zhou1615@umn.edu>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20211130084304.72160-1-zhou1615@umn.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/2021 12:43 AM, Zhou Qingyang wrote:
> In ath11k_mac_op_hw_scan(), the return value of kzalloc() is directly
> used in memcpy(), which may lead to a NULL pointer dereference on
> failure of kzalloc().
> 
> Fix this bug by adding a check of arg.extraie.ptr.
> 
> This bug was found by a static analyzer. The analysis employs
> differential checking to identify inconsistent security operations
> (e.g., checks or kfrees) between two code paths and confirms that the
> inconsistent operations are not recovered in the current function or
> the callers, so they constitute bugs.
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger. Multiple researchers have cross-reviewed
> the bug.
> 
> Builds with CONFIG_ATH11K=m show no new warnings, and our static
> analyzer no longer warns about this code.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> ---
>   drivers/net/wireless/ath/ath11k/mac.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 1cc55602787b..095f1f9b7611 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -3237,8 +3237,13 @@ static int ath11k_mac_op_hw_scan(struct ieee80211_hw *hw,
>   	arg.scan_id = ATH11K_SCAN_ID;
>   
>   	if (req->ie_len) {
> -		arg.extraie.len = req->ie_len;
>   		arg.extraie.ptr = kzalloc(req->ie_len, GFP_KERNEL);

Your patch looks good, but since you are touching this code IMO this 
should be changed to kmemdup() and we should remove the memcpy() below.

> +		if (!arg.extraie.ptr) {
> +			ret = -ENOMEM;
> +			goto exit;
> +		}
> +
> +		arg.extraie.len = req->ie_len;
>   		memcpy(arg.extraie.ptr, req->ie, req->ie_len);
>   	}
>   
> 

