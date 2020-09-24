Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCBF2767F7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgIXEpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:45:51 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:58668 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgIXEpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 00:45:51 -0400
Received: from [10.193.177.193] (thasreef.asicdesigners.com [10.193.177.193] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08O4jdN4021018;
        Wed, 23 Sep 2020 21:45:40 -0700
Subject: Re: [net-next 1/3] ch_ktls: Issue if connection offload fails
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
References: <20200922174501.14943-1-rohitm@chelsio.com>
 <20200922174501.14943-2-rohitm@chelsio.com>
 <20200922154443.17ed8b94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <8352e9da-e10f-43cd-6616-e11f7d2f8822@chelsio.com>
Date:   Thu, 24 Sep 2020 10:15:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200922154443.17ed8b94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/09/20 4:14 AM, Jakub Kicinski wrote:
> On Tue, 22 Sep 2020 23:14:59 +0530 Rohit Maheshwari wrote:
>> Since driver first return success to tls_dev_add, if req to HW is
>> successful, but later if HW returns failure, that connection traffic
>> fails permanently and connection status remains unknown to stack.
>>
>> Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>>   #if IS_ENABLED(CONFIG_IPV6)
>>   	} else {
>> -		if (!sk->sk_ipv6only &&
>> -		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
>> -			tx_info->ip_family = AF_INET;
>> -			ret = chcr_ktls_act_open_req(sk, tx_info, atid);
>> -		} else {
>> -			tx_info->ip_family = AF_INET6;
>> -			ret = cxgb4_clip_get(tx_info->netdev,
>> -					     (const u32 *)
>> -					     &sk->sk_v6_rcv_saddr.s6_addr,
>> -					     1);
>> -			if (ret)
>> -				goto out;
>> -			ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
>> -		}
>> +		ret = cxgb4_clip_get(tx_info->netdev, (const u32 *)
>> +				     &sk->sk_v6_rcv_saddr,
>> +				     1);
>> +		if (ret)
>> +			return ret;
>> +		ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
> You removed the mapped socket handling which seems unrelated to the
> rest of the patch.

This mapped check is taken care in tls_dev_add, and this extra if

isn't needed anymore.

>> +	spin_lock(&tx_info->lock);
>> +	tx_info->conn_up = true;
>> +	spin_unlock(&tx_info->lock);
> What's the context this lock is taken in? You seem to always do only
> spin_lock(), does the control path not need to be _bh() or _irq()?
This conn_up isn't required anymore. I'll remove this.
