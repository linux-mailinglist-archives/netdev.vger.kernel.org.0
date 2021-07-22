Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE053D1C8C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 05:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhGVDQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 23:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhGVDQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 23:16:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740C9C061575;
        Wed, 21 Jul 2021 20:57:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so2392070pjb.0;
        Wed, 21 Jul 2021 20:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eFaQS4/KTkRNWySIsqDTE+2ou4eK63jeGeUW05LyArI=;
        b=WRrHxI57vFLy9CLbw9XY3i3RwyAa+dasAPV46FWPT0Uzy0dVUroR8dLaJw2FgzW9Fl
         eI9d4HMfWtixNbkqAp/fNjpfxXSJM/4BmYeuT9Tc3Ha/9sY/nNTDcUFygJtTLnxE7Xid
         Wit0oyGxrkoKn1DUjdtgtTiNyNVYkT/n5WfaFkQYjK9TiTWdV6RsUtj9cQ++QHFJdApa
         mqLVuGWVCjqySMyNh1X0WrwO+F6Etc7xU5AZ6LCeyI3XZZxjOcNNim/Y/80w6mdERdH4
         IQmxnnTpdtiXw3XXPl4QqUTW1xwt7M7GK4h20lByfRgPHYlOGguOCSMq92fJa6cV72J2
         zIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eFaQS4/KTkRNWySIsqDTE+2ou4eK63jeGeUW05LyArI=;
        b=IPkwxoL7FL3WG8KF4j3+xL2xyFHbATmOT9NYcYy8pc4C1jcBYNZpc2enqarh6U25H3
         0pdx+pHHOhQF2wonIiPR2mr3yMy03+iTnGD5QFrBWzb7VOkhOwev4qADGN0lExj8JvLM
         03bJqOiuUe8GkJx4Xibtyr64sQw9gxmEDPHv5Muzf6cXCmCxNYUEWv9L/EYCiQ91oJyl
         +s77eBzexZ9T3w6MhUbzq+ipdiS5rjPAOGFMrUUNV4LtlkWZONssMu9o95s+iEENrBTE
         ygi8+DUg7KUhos8v4hTHn0e7siTa8C+GheDXTl7eUycad0ed+3hSZ/WvRrukjYfYwt6u
         Pr9A==
X-Gm-Message-State: AOAM530JZ60cUNC2bo25M94mJnmwiw6cBhXozlWTnuLEHG1duIO+tgJJ
        M5tVU2agUVWjoPCH24eKKjf6fQpiAJA=
X-Google-Smtp-Source: ABdhPJz5Xo38lE2dm/V/uqEGpsaVAeNM+tyhZ8R0tGLZYIrGltFKG/w+3qGJePF+G/QlHK45m80cxg==
X-Received: by 2002:a17:90a:e54a:: with SMTP id ei10mr6981023pjb.1.1626926224708;
        Wed, 21 Jul 2021 20:57:04 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x10sm20484384pfh.56.2021.07.21.20.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 20:57:03 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
To:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
 <20210721233549.mhqlrt3l2bbyaawr@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8460fa10-6db7-273c-a2c2-9b54cc660d9a@gmail.com>
Date:   Wed, 21 Jul 2021 20:56:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721233549.mhqlrt3l2bbyaawr@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2021 4:35 PM, Vladimir Oltean wrote:
> On Wed, Jul 21, 2021 at 11:56:41PM +0200, Lino Sanfilippo wrote:
>> The function skb_put() that is used by tail taggers to make room for the
>> DSA tag must only be called for linearized SKBS. However in case that the
>> slave device inherited features like NETIF_F_HW_SG or NETIF_F_FRAGLIST the
>> SKB passed to the slaves transmit function may not be linearized.
>> Avoid those SKBs by clearing the NETIF_F_HW_SG and NETIF_F_FRAGLIST flags
>> for tail taggers.
>> Furthermore since the tagging protocol can be changed at runtime move the
>> code for setting up the slaves features into dsa_slave_setup_tagger().
>>
>> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>> ---
>>   net/dsa/slave.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 22ce11cd770e..ae2a648ed9be 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -1808,6 +1808,7 @@ void dsa_slave_setup_tagger(struct net_device *slave)
>>   	struct dsa_slave_priv *p = netdev_priv(slave);
>>   	const struct dsa_port *cpu_dp = dp->cpu_dp;
>>   	struct net_device *master = cpu_dp->master;
>> +	const struct dsa_switch *ds = dp->ds;
>>   
>>   	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
>>   	slave->needed_tailroom = cpu_dp->tag_ops->needed_tailroom;
>> @@ -1819,6 +1820,14 @@ void dsa_slave_setup_tagger(struct net_device *slave)
>>   	slave->needed_tailroom += master->needed_tailroom;
>>   
>>   	p->xmit = cpu_dp->tag_ops->xmit;
>> +
>> +	slave->features = master->vlan_features | NETIF_F_HW_TC;
>> +	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
>> +		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
>> +	slave->hw_features |= NETIF_F_HW_TC;
>> +	slave->features |= NETIF_F_LLTX;
>> +	if (slave->needed_tailroom)
>> +		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
>>   }
>>   
>>   static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
>> @@ -1881,11 +1890,6 @@ int dsa_slave_create(struct dsa_port *port)
>>   	if (slave_dev == NULL)
>>   		return -ENOMEM;
>>   
>> -	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
>> -	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
>> -		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
>> -	slave_dev->hw_features |= NETIF_F_HW_TC;
>> -	slave_dev->features |= NETIF_F_LLTX;
>>   	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
>>   	if (!is_zero_ether_addr(port->mac))
>>   		ether_addr_copy(slave_dev->dev_addr, port->mac);
>> -- 
>> 2.32.0
>>
> 
> I would have probably changed the code in dsa_slave_create just like
> this:
> 
> -	slave->features = master->vlan_features | NETIF_F_HW_TC;
> +	slave->features = NETIF_F_HW_TC;
> ...
> -	slave_dev->vlan_features = master->vlan_features;
> 
> and in dsa_slave_setup_tagger:
> 
> +	vlan_features = master->vlan_features;
> +	slave->features &= ~vlan_features;
> +	if (slave->needed_tailroom)
> +		vlan_features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
> +	slave->features |= vlan_features;
> +	slave->vlan_features = vlan_features;
> 
> no need to move around NETIF_F_HW_TC and NETIF_F_LLTX. Makes sense?
> 
> And I would probably add:
> 
> Fixes: 91da11f870f0 ("net: Distributed Switch Architecture protocol support")

Agreed, with those fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
