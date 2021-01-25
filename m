Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D1D302705
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbhAYPjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 10:39:10 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:44746 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbhAYPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:38:41 -0500
Received: from [192.168.254.6] (unknown [50.34.179.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 90D8F13C2B0;
        Mon, 25 Jan 2021 07:15:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 90D8F13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1611587706;
        bh=D72s6Vo8e4dexbEsXVvtzwjbmu/KhYklot7icQzzIgg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DICVx+MNcWTfvWUhTcJ/Rx5TquEP3WuZJZdwch/gBidovHK8jGHlDLlg4m6/hCcYl
         ajsXQb1z5st6Eruwd43LvLsYCi890ixkKSz8GDF7rYHUJzKGSjxfoNrRM5tFbWhLGD
         GArq1X2Gu+rBgoQoxyO4Ix+OXhS92I0jCbqGFlhc=
Subject: Re: [PATCH net] iwlwifi: provide gso_type to GSO packets
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
References: <20210125150949.619309-1-eric.dumazet@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <97cf98b0-d464-1901-f01f-ac5dd362561d@candelatech.com>
Date:   Mon, 25 Jan 2021 07:15:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210125150949.619309-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 7:09 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> net/core/tso.c got recent support for USO, and this broke iwlfifi
> because the driver implemented a limited form of GSO.
> 
> Providing ->gso_type allows for skb_is_gso_tcp() to provide
> a correct result.
> 
> Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Bisected-by: Ben Greear <greearb@candelatech.com>

I appreciate the credit, but the bisect and some other initial bug hunting was
done by people on this thread:

https://bugzilla.kernel.org/show_bug.cgi?id=209913

Thanks,
Ben

> Tested-by: Ben Greear <greearb@candelatech.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---
>   drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> index a983c215df310776ffe67f3b3ffa203eab609bfc..3712adc3ccc2511d46bcc855efbfba41c487d8e6 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> @@ -773,6 +773,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
>   
>   	next = skb_gso_segment(skb, netdev_flags);
>   	skb_shinfo(skb)->gso_size = mss;
> +	skb_shinfo(skb)->gso_type = ipv4 ? SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
>   	if (WARN_ON_ONCE(IS_ERR(next)))
>   		return -EINVAL;
>   	else if (next)
> @@ -795,6 +796,8 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
>   
>   		if (tcp_payload_len > mss) {
>   			skb_shinfo(tmp)->gso_size = mss;
> +			skb_shinfo(tmp)->gso_type = ipv4 ? SKB_GSO_TCPV4 :
> +							   SKB_GSO_TCPV6;
>   		} else {
>   			if (qos) {
>   				u8 *qc;
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
