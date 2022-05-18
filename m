Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D3152BF45
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbiERPyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiERPyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03AED1CC9B8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652889273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o+41K9LoDFefNHlN38q9XLtLo2Wd5hJ3TPpp2R0V7lQ=;
        b=E95sZn7bE4YRRLkw7PDO0EbcyUoOkHMuZo6vlOf1fDRD1Ckw9kfDM1hz5R5k4Z8JQQqJwV
        mcC5drmeGN9ZTDc9yy2dk4eZ3i2QP7lo8nFoRsIz9k1Iu+8ZNCVoRmF8nGd5H/MEB8vOjK
        /bEAYL92xUzrM2G3SLjYxzQDRKBC+Gg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-2nADQ5tUPkei1XR17W-bpw-1; Wed, 18 May 2022 11:54:31 -0400
X-MC-Unique: 2nADQ5tUPkei1XR17W-bpw-1
Received: by mail-qt1-f199.google.com with SMTP id h5-20020ac81385000000b002f3f91834ffso1974271qtj.10
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o+41K9LoDFefNHlN38q9XLtLo2Wd5hJ3TPpp2R0V7lQ=;
        b=pHOYopA8Yyr667/X1LxRbX3vgGmF7CI3i6F3yQxV/JIbQ5nNgTakxJunpvN4lrs5re
         DH/8jQf/ZutKeDly+Xg3O72ktLns1yJ5nhtSXduHaWFKUDmmaC3gGBlnGYPRTzG8mCyR
         hlZyFbqBwzg6kJhdRK9wQe0qDMcpT9l0H97w0tAs3ieqSFw9GdAo682OeixhxoCjEZHd
         K8wRsczTINzUJ9WTKdJddMDLPH0aGexMZc9FwN4qYrZf/s9V91v7z+/PqStZ4XgIZ6c9
         7OvR8UXmJF2vDh1OKU+JepcarS6wsnsKH2iW0EpXnS0/pOjWhA3EsD/gCMcO7z7oQwvt
         BrpA==
X-Gm-Message-State: AOAM531gSchr2XPomDDLnrUx2IRDIUDbmQd0++akmi/9F3ZagYqHmwwH
        oB0cCIf2EvH5m5J9acnX6R3w0RpGjI10/0gJAwhk+ddsSBKjI4W27CoPJO6+XUhpMr61MZe/lIL
        3DDKehLeMXfk1UylV
X-Received: by 2002:a37:d245:0:b0:69b:f153:9c38 with SMTP id f66-20020a37d245000000b0069bf1539c38mr40667qkj.692.1652889271130;
        Wed, 18 May 2022 08:54:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzJmSYB+nUCTtpA5X7u3VijTdR+HPQ+dvCcudSZ2ylQNwAuYjLtHQEOx0PAErPgsRNeXt/Mw==
X-Received: by 2002:a37:d245:0:b0:69b:f153:9c38 with SMTP id f66-20020a37d245000000b0069bf1539c38mr40644qkj.692.1652889270798;
        Wed, 18 May 2022 08:54:30 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id h4-20020a376c04000000b0069fc13ce1d4sm1722361qkc.5.2022.05.18.08.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 08:54:30 -0700 (PDT)
Message-ID: <55870b80-7297-f3f9-967c-d23c2b39fea4@redhat.com>
Date:   Wed, 18 May 2022 11:54:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCHv2 net] bonding: fix missed rcu protection
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     andy@greyhouse.net, davem@davemloft.net, dsahern@gmail.com,
        eric.dumazet@gmail.com, j.vosburgh@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        vfalico@gmail.com, vladimir.oltean@nxp.com,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <20220517082312.805824-1-liuhangbin@gmail.com>
 <a4ed2a83d38a58b0984edb519382c867204b7ea2.1652804144.git.jtoppins@redhat.com>
 <YoRXjeCR2bbr5qzF@Laptop-X1>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <YoRXjeCR2bbr5qzF@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/22 22:18, Hangbin Liu wrote:
> On Tue, May 17, 2022 at 01:32:58PM -0400, Jonathan Toppins wrote:
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>> RESEND, list still didn't receive my last version
>>
>> The diffstat is slightly larger but IMO a slightly more readable version.
>> When I was reading v2 I found myself jumping around.
> 
> Hi Jon,
> 
> Thanks for the commit. But..
> 
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 38e152548126..f9d27b63c454 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -5591,23 +5591,32 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>>   	const struct ethtool_ops *ops;
>>   	struct net_device *real_dev;
>>   	struct phy_device *phydev;
>> +	int ret = 0;
>>   
>> +	rcu_read_lock();
>>   	real_dev = bond_option_active_slave_get_rcu(bond);
>> -	if (real_dev) {
>> -		ops = real_dev->ethtool_ops;
>> -		phydev = real_dev->phydev;
>> -
>> -		if (phy_has_tsinfo(phydev)) {
>> -			return phy_ts_info(phydev, info);
>> -		} else if (ops->get_ts_info) {
>> -			return ops->get_ts_info(real_dev, info);
>> -		}
>> -	}
>> +	if (real_dev)
>> +		dev_hold(real_dev);
>> +	rcu_read_unlock();
>> +
>> +	if (!real_dev)
>> +		goto software;
>>   
>> +	ops = real_dev->ethtool_ops;
>> +	phydev = real_dev->phydev;
>> +
>> +	if (phy_has_tsinfo(phydev))
>> +		ret = phy_ts_info(phydev, info);
>> +	else if (ops->get_ts_info)
>> +		ret = ops->get_ts_info(real_dev, info);
> 	else {
> 		dev_put(real_dev);
> 		goto software;
> 	}
> 
> Here we need another check and goto software if !phy_has_tsinfo() and
> no ops->get_ts_info. With this change we also have 2 goto and dev_put().

Ah yes. I cannot think of a way to make this simpler. The patch below 
looks good.

> 
>> +
>> +	dev_put(real_dev);
>> +	return ret;
>> +
>> +software:
>>   	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
>>   				SOF_TIMESTAMPING_SOFTWARE;
>>   	info->phc_index = -1;
>> -
>>   	return 0;
>>   }
> 
> As Jakub remind, dev_hold() and dev_put() can take NULL now. So how about
> this new patch:
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 38e152548126..b5c5196e03ee 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -5591,16 +5591,23 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>   	const struct ethtool_ops *ops;
>   	struct net_device *real_dev;
>   	struct phy_device *phydev;
> +	int ret = 0;
>   
> +	rcu_read_lock();
>   	real_dev = bond_option_active_slave_get_rcu(bond);
> +	dev_hold(real_dev);
> +	rcu_read_unlock();
> +
>   	if (real_dev) {
>   		ops = real_dev->ethtool_ops;
>   		phydev = real_dev->phydev;
>   
>   		if (phy_has_tsinfo(phydev)) {
> -			return phy_ts_info(phydev, info);
> +			ret = phy_ts_info(phydev, info);
> +			goto out;
>   		} else if (ops->get_ts_info) {
> -			return ops->get_ts_info(real_dev, info);
> +			ret = ops->get_ts_info(real_dev, info);
> +			goto out;
>   		}
>   	}
>   
> @@ -5608,7 +5615,9 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
>   				SOF_TIMESTAMPING_SOFTWARE;
>   	info->phc_index = -1;
>   
> -	return 0;
> +out:
> +	dev_put(real_dev);
> +	return ret;
>   }
> 
> Thanks
> Hangbin
> 

