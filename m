Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736F71492C3
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 02:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgAYBmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 20:42:40 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38771 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387475AbgAYBmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 20:42:40 -0500
Received: by mail-pl1-f196.google.com with SMTP id t6so1503655plj.5
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 17:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tlFaD//BvBZv3xMn475Kee1Ktpmgh8PdbAcukkFkcZk=;
        b=FKFao3/vBoD6gBdGn/A1bfmgaHYMK7YAgelnIVuBpEG8ZuvRp77moVXqR+i9VeLph1
         IjGqumeDHzLyhQ2ok076w/2lhWeZqlcVHAKpamYkke+XuN7qcrInusYq+NBAGAxnRJtz
         ujxIASjG7ecf9qW2DXodQbKE3AVXZzUZUrozc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tlFaD//BvBZv3xMn475Kee1Ktpmgh8PdbAcukkFkcZk=;
        b=NEZq8YGGn78OF55+m+H1qtps6ogsTJTRwns+8DYpc4I/yANOayeDkDlclNUpcJ0RzC
         tTKSJvKJc94h9mAIo0rth4oweob/lD3vOQG6aZH5i0Rp0JiSE4GO31Bfqm6UmKeUkXp6
         yooZzuohJ2lzK5MbH08DPTQGcOCvK3MNisgsWU2JN6Psu1h1vxL/ia+petDLttZ191Eh
         Tc1fJ2jguDHt5UD9LzIjHhc0k8J0Y+sj6x/1WB+6CbPo1nu7mvoy/iA3jH/O1K6VcZrp
         H2Ee0kOAB17SmnhntjrXsDjfhQL/nymy4mBvKc02p+f7kYWindsNz8srQNQIpiFvJEqj
         C8gg==
X-Gm-Message-State: APjAAAWK5YVNPIAYjc2LzWUDJK8z9ktlqM8awQsygLGxEwdWAFBVtkCi
        EHf81Mb1W1uZpIoX6bWEq5y3Kw==
X-Google-Smtp-Source: APXvYqzcTplmxy+Fp0EM4pzo5ggzYAc1VJGxYEM0GGZv7D2MP/UkjtiILAh+DW8IK4zu9wJNLy1Uew==
X-Received: by 2002:a17:90b:941:: with SMTP id dw1mr2403404pjb.21.1579916559059;
        Fri, 24 Jan 2020 17:42:39 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t1sm8075530pgq.23.2020.01.24.17.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 17:42:38 -0800 (PST)
Subject: Re: [PATCH net-next] net: systemport: Do not block interrupts in TX
 reclaim
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, edumazet@google.com,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200124235930.640-1-f.fainelli@gmail.com>
 <de50408a-37db-e55e-57af-54574c7b5e42@gmail.com>
From:   Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 mQENBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAG0MEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPokB
 xAQQAQgArgUCXJvPrRcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFrZXktdXNh
 Z2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2RpbmdAcGdw
 LmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29tLmNvbQUb
 AwAAAAMWAgEFHgEAAAAEFQgJCgAKCRCBMbXEKbxmoE4DB/9JySDRt/ArjeOHOwGA2sLR1DV6
 Mv6RuStiefNvJ14BRfMkt9EV/dBp9CsI+slwj9/ZlBotQXlAoGr4uivZvcnQ9dWDjTExXsRJ
 WcBwUlSUPYJc/kPWFnTxF8JFBNMIQSZSR2dBrDqRP0UWYJ5XaiTbVRpd8nka9BQu4QB8d/Bx
 VcEJEth3JF42LSF9DPZlyKUTHOj4l1iZ/Gy3AiP9jxN50qol9OT37adOJXGEbix8zxoCAn2W
 +grt1ickvUo95hYDxE6TSj4b8+b0N/XT5j3ds1wDd/B5ZzL9fgBjNCRzp8McBLM5tXIeTYu9
 mJ1F5OW89WvDTwUXtT19P1r+qRqKuQENBFPAG8EBCACsa+9aKnvtPjGAnO1mn1hHKUBxVML2
 C3HQaDp5iT8Q8A0ab1OS4akj75P8iXYfZOMVA0Lt65taiFtiPT7pOZ/yc/5WbKhsPE9dwysr
 vHjHL2gP4q5vZV/RJduwzx8v9KrMZsVZlKbvcvUvgZmjG9gjPSLssTFhJfa7lhUtowFof0fA
 q3Zy+vsy5OtEe1xs5kiahdPb2DZSegXW7DFg15GFlj+VG9WSRjSUOKk+4PCDdKl8cy0LJs+r
 W4CzBB2ARsfNGwRfAJHU4Xeki4a3gje1ISEf+TVxqqLQGWqNsZQ6SS7jjELaB/VlTbrsUEGR
 1XfIn/sqeskSeQwJiFLeQgj3ABEBAAGJAkEEGAECASsFAlPAG8IFGwwAAADAXSAEGQEIAAYF
 AlPAG8EACgkQk2AGqJgvD1UNFQgAlpN5/qGxQARKeUYOkL7KYvZFl3MAnH2VeNTiGFoVzKHO
 e7LIwmp3eZ6GYvGyoNG8cOKrIPvXDYGdzzfwxVnDSnAE92dv+H05yanSUv/2HBIZa/LhrPmV
 hXKgD27XhQjOHRg0a7qOvSKx38skBsderAnBZazfLw9OukSnrxXqW/5pe3mBHTeUkQC8hHUD
 Cngkn95nnLXaBAhKnRfzFqX1iGENYRH3Zgtis7ZvodzZLfWUC6nN8LDyWZmw/U9HPUaYX8qY
 MP0n039vwh6GFZCqsFCMyOfYrZeS83vkecAwcoVh8dlHdke0rnZk/VytXtMe1u2uc9dUOr68
 7hA+Z0L5IQAKCRCBMbXEKbxmoLoHCACXeRGHuijOmOkbyOk7x6fkIG1OXcb46kokr2ptDLN0
 Ky4nQrWp7XBk9ls/9j5W2apKCcTEHONK2312uMUEryWI9BlqWnawyVL1LtyxLLpwwsXVq5m5
 sBkSqma2ldqBu2BHXZg6jntF5vzcXkqG3DCJZ2hOldFPH+czRwe2OOsiY42E/w7NUyaN6b8H
 rw1j77+q3QXldOw/bON361EusWHdbhcRwu3WWFiY2ZslH+Xr69VtYAoMC1xtDxIvZ96ps9ZX
 pUPJUqHJr8QSrTG1/zioQH7j/4iMJ07MMPeQNkmj4kGQOdTcsFfDhYLDdCE5dj5WeE6fYRxE
 Q3up0ArDSP1L
Message-ID: <36eea933-d30b-344b-1f29-d8e5959f27fd@broadcom.com>
Date:   Fri, 24 Jan 2020 17:42:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <de50408a-37db-e55e-57af-54574c7b5e42@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2020 5:35 PM, Eric Dumazet wrote:
> 
> 
> On 1/24/20 3:59 PM, Florian Fainelli wrote:
>> There is no need to disable interrupts with a spin_lock_irqsave() in
>> bcm_sysport_tx_poll() since we are in softIRQ context already. Leave
>> interrupts enabled, thus giving a chance for the RX interrupts to be
>> processed.
>>
>> This now makes bcm_sysport_tx_reclaim() equivalent to
>> bcm_sysport_tx_clean(), thus remove the former, and make
>> bcm_sysport_tx_reclaim_all() to use the latter.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/ethernet/broadcom/bcmsysport.c | 30 ++++++----------------
>>  1 file changed, 8 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
>> index f07ac0e0af59..dfff0657ce8f 100644
>> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
>> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
>> @@ -925,26 +925,6 @@ static unsigned int __bcm_sysport_tx_reclaim(struct bcm_sysport_priv *priv,
>>  	return pkts_compl;
>>  }
>>  
>> -/* Locked version of the per-ring TX reclaim routine */
>> -static unsigned int bcm_sysport_tx_reclaim(struct bcm_sysport_priv *priv,
>> -					   struct bcm_sysport_tx_ring *ring)
>> -{
>> -	struct netdev_queue *txq;
>> -	unsigned int released;
>> -	unsigned long flags;
>> -
>> -	txq = netdev_get_tx_queue(priv->netdev, ring->index);
>> -
>> -	spin_lock_irqsave(&ring->lock, flags);
>> -	released = __bcm_sysport_tx_reclaim(priv, ring);
>> -	if (released)
>> -		netif_tx_wake_queue(txq);
>> -
>> -	spin_unlock_irqrestore(&ring->lock, flags);
>> -
>> -	return released;
>> -}
>> -
>>  /* Locked version of the per-ring TX reclaim, but does not wake the queue */
>>  static void bcm_sysport_tx_clean(struct bcm_sysport_priv *priv,
>>  				 struct bcm_sysport_tx_ring *ring)
>> @@ -960,9 +940,15 @@ static int bcm_sysport_tx_poll(struct napi_struct *napi, int budget)
>>  {
>>  	struct bcm_sysport_tx_ring *ring =
>>  		container_of(napi, struct bcm_sysport_tx_ring, napi);
>> +	struct bcm_sysport_priv *priv = ring->priv;
>>  	unsigned int work_done = 0;
>>  
>> -	work_done = bcm_sysport_tx_reclaim(ring->priv, ring);
>> +	spin_lock(&ring->lock);
>> +	work_done = __bcm_sysport_tx_reclaim(priv, ring);
>> +	if (work_done)
>> +		netif_tx_wake_queue(netdev_get_tx_queue(priv->netdev,
>> +							ring->index));
>> +	spin_unlock(&ring->lock);
>>  
>>  	if (work_done == 0) {
>>  		napi_complete(napi);
>> @@ -984,7 +970,7 @@ static void bcm_sysport_tx_reclaim_all(struct bcm_sysport_priv *priv)
>>  	unsigned int q;
>>  
>>  	for (q = 0; q < priv->netdev->num_tx_queues; q++)
>> -		bcm_sysport_tx_reclaim(priv, &priv->tx_rings[q]);
>> +		bcm_sysport_tx_clean(priv, &priv->tx_rings[q]);
>>  }
>>  
>>  static int bcm_sysport_poll(struct napi_struct *napi, int budget)
>>
> 
> I am a bit confused by this patch, the changelog mixes hard and soft irqs.
> 
> This driver seems to call bcm_sysport_tx_reclaim_all() from hard irq handler 
> (INTRL2_0_TX_RING_FULL condition)
> 
> So it looks you need to acquire ring->lock with some _irqsave() variant when
> bcm_sysport_tx_poll() is running (from BH context)

You are right, I completely missed that path and the very reason why
this is spin_lock_irqsave() in the first place... time to get some sleep.

Thanks!
-- 
Florian
