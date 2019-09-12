Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054C7B13FE
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfILRsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:48:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33853 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfILRsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:48:31 -0400
Received: by mail-pf1-f194.google.com with SMTP id r12so16490771pfh.1
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 10:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BFrqsYYd6MX03SxV2fPIiM9iN/ZjIu0itl7xUsVpP4M=;
        b=QVWHBAwNh6/PmMctl818/tps3xA0OQXWLLAm8PP8eVrQ0xKkGyuIrvrLgibZ8dw12a
         aXYCcA9YjXvS4DO+QAZN97DtZC001vdcqWSvOzT994OP7T92JM8nym/sCcaDQj74t7Gc
         o2Nz1/CYF26+enlgKyLGwbdYpfw1MF6N3nCogSwSalvLMJdA3Y+4G8o/Do9bM8J8qLo0
         BVeSIOkOACp9FUdD35WG1Mh2UiShnbW8gl5B72gcmW3NIql/ykgyUP/LduDBQKwNHOBh
         4E9j6wkQtPNypqBp3H+1RVHCYMtOzjyUVRYADHTRrqpPZwr9YskL/u/6IAqQK0gb2E29
         cBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BFrqsYYd6MX03SxV2fPIiM9iN/ZjIu0itl7xUsVpP4M=;
        b=q8wgSyKqsCYzmE0/yXxrWJO1iNGlBKY1Wiid9khgM4oxb9+wO5ligZPcIFco8lrLTN
         EdnSaaa0uDm0GzpLgoDDAnwANmOm2FoUxBMTcv29lYgrW+v0Wv7LRxzLEfK+KseOBGga
         8vx8ya2hyHrc+MpYvvUROnX4VJtOzomQe9CTr5rR6RQFP23DJPSkVjmzE/CslF81oCCl
         +FupvFl4CeiAgr00/JJ7XrVDodJfIIu3S203v0L//egDHN5IuHam7KNd4CuGasKXH0lv
         1GZ4eCXAEbKJmP/1eXfT8uJ8RL6HGkTiifdTfdDx8p3Pf0RAlzGOScdOlmWPMUi5LFBF
         U9Qg==
X-Gm-Message-State: APjAAAXjwHDwrWypOXtK17Pu6YR0b7cL49SwzIuS5CfxyzS9Kl42MfLh
        FWgBu0NX93gi0G0jRjtu9ipDKC6XJIXOvVb2
X-Google-Smtp-Source: APXvYqwrBHIDGyBOJMmex5fGXu0uCiALFzaPVz+7iLD6f8pBcOy83uGyJUSS3gIJwsmDZwtreSVFew==
X-Received: by 2002:a17:90a:170e:: with SMTP id z14mr1442198pjd.119.1568310510505;
        Thu, 12 Sep 2019 10:48:30 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id z29sm40246355pff.23.2019.09.12.10.48.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 10:48:29 -0700 (PDT)
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     Michael Marley <michael@michaelmarley.com>, netdev@vger.kernel.org
References: <20190912110144.GS2879@gauss3.secunet.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <72fa19de-0a53-bb95-5f63-1990221c6190@pensando.io>
Date:   Thu, 12 Sep 2019 18:48:25 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912110144.GS2879@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 12:01 PM, Steffen Klassert wrote:
> The ixgbe driver currently does IPsec TX offloading
> based on an existing secpath. However, the secpath
> can also come from the RX side, in this case it is
> misinterpreted for TX offload and the packets are
> dropped with a "bad sa_idx" error. Fix this by using
> the xfrm_offload() function to test for TX offload.

Acked-by: Shannon Nelson <snelson@pensando.io>

>
> Fixes: 592594704761 ("ixgbe: process the Tx ipsec offload")
> Reported-by: Michael Marley <michael@michaelmarley.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 9bcae44e9883..ae31bd57127c 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -36,6 +36,7 @@
>   #include <net/vxlan.h>
>   #include <net/mpls.h>
>   #include <net/xdp_sock.h>
> +#include <net/xfrm.h>
>   
>   #include "ixgbe.h"
>   #include "ixgbe_common.h"
> @@ -8696,7 +8697,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
>   #endif /* IXGBE_FCOE */
>   
>   #ifdef CONFIG_IXGBE_IPSEC
> -	if (secpath_exists(skb) &&
> +	if (xfrm_offload(skb) &&
>   	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
>   		goto out_drop;
>   #endif

