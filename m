Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3BE8E85D
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfHOJf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:35:27 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42710 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbfHOJf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 05:35:27 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so1648992wrq.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 02:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d5q7TWUpqsGm62p1Q7uz62qxO+UQ8ow0BrjLgb4A15Q=;
        b=kkroIqSmOC7WM2JhZuOzedVYJ+qkBs/c1bvB2miszqAqgk1nIu1AKigaW2Yrr8f+Rk
         /0XjR8GMqSvxTkwfqdB8gLBfl9WWfOCCjUf/D2FLRrVAw8HYRgHBZuOGj99zLH6MmtRO
         8oxzc4tZLf/rFWBF6I2C59Ve/GrMtN0pInkp3qvigbbJzHu0FHEujaML8991u2V9uCHc
         ihX/rmCpKmUIrgqgwyjafsyuJ9INIgudgI11imhaLehGYsG5aSZRyyzDv5Efy26s7Vju
         IDi5rx2TPOYC1ZKdhYKpL4K3axs3J167jA/FWNN0BvGSCbB4YoZKxrWeSyF1luDtdI0g
         zv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d5q7TWUpqsGm62p1Q7uz62qxO+UQ8ow0BrjLgb4A15Q=;
        b=WweMU0anaQiwDRlkA8B7jGUdtjIGEOEEoPCcJhKbsClnlw117pjpJrXSyU7QQN9vOU
         oOG+afPYSf2smrDvAXWqSVrQps0uJuiywsq43Lxk8tVCucOoCpFzwv9cMXoLqSqEmRSn
         qUHLaP8+xPQb2qFwxVjq24iOGfyRCmRm3PBmNZXhPnmpBflC9WbCbnm1UqO7hSEVpcE8
         Ix2zywEqnJs7EHn2FI/yDpV/Ju1e7gm0/x+N3y15f3aDz+XubjaBcljiEz8kQmKO2K9C
         tcBcefIu2AvDwSgD0oTWl0ifTtQFmRuqeNsXV69MiNNzNuQgljwkVpOByf1q+IGQTFAT
         MIZA==
X-Gm-Message-State: APjAAAUsJX1spHkK6770FpgiAXCRap5UllvSYnTq3QC6pbApWRmKCvR5
        BiK80Thd2N33K4uMQFUMYHu5Ih3p
X-Google-Smtp-Source: APXvYqw3+IPWbRn8hqfA8m0kowzl+vApPVwjWSN7I6SUn+YjR7xjsI0T6BVw7nQ6rAehQBJ+kcVpbw==
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr4480362wrr.141.1565861724523;
        Thu, 15 Aug 2019 02:35:24 -0700 (PDT)
Received: from [192.168.8.147] (178.161.185.81.rev.sfr.net. [81.185.161.178])
        by smtp.gmail.com with ESMTPSA id h97sm6408845wrh.74.2019.08.15.02.35.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:35:23 -0700 (PDT)
Subject: Re: [PATCH] tun: fix use-after-free when register netdev failed
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     jasowang@redhat.com, xiyou.wangcong@gmail.com, davem@davemloft.net
References: <1565857122-24660-1-git-send-email-yangyingliang@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a6f519cf-95ed-02de-d432-363610e4c332@gmail.com>
Date:   Thu, 15 Aug 2019 11:35:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1565857122-24660-1-git-send-email-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/19 10:18 AM, Yang Yingliang wrote:
> I got a UAF repport in tun driver when doing fuzzy test:
> 
>
> [  466.368604] page:ffffea000dc84e00 refcount:1 mapcount:0 mapping:ffff8883df1b4f00 index:0x0 compound_mapcount: 0
> [  466.371582] flags: 0x2fffff80010200(slab|head)
> [  466.372910] raw: 002fffff80010200 dead000000000100 dead000000000122 ffff8883df1b4f00
> [  466.375209] raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
> [  466.377778] page dumped because: kasan: bad access detected
> [  466.379730]
> [  466.380288] Memory state around the buggy address:
> [  466.381844]  ffff888372139100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  466.384009]  ffff888372139180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  466.386131] >ffff888372139200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  466.388257]                                                  ^
> [  466.390234]  ffff888372139280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  466.392512]  ffff888372139300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  466.394667] ==================================================================
> 
> tun_chr_read_iter() accessed the memory which freed by free_netdev()
> called by tun_set_iff():
> 
> 	CPUA				CPUB
>     tun_set_iff()
>       alloc_netdev_mqs()
>       tun_attach()
> 				    tun_chr_read_iter()
> 				      tun_get()
>       register_netdevice()
>       tun_detach_all()
>         synchronize_net()
> 				      tun_do_read()
> 				        tun_ring_recv()
> 				          schedule()
>       free_netdev()
> 				      tun_put() <-- UAF

UAF on what exactly ? The dev_hold() should prevent the free_netdev().

> 
> Set a new bit in tun->flag if register_netdevice() successed,
> without this bit, tun_get() returns NULL to avoid using a
> freed tun pointer.
> 
> Fixes: eb0fb363f920 ("tuntap: attach queue 0 before registering netdevice")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/tun.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index db16d7a13e00..cbd60c276c40 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -115,6 +115,7 @@ do {								\
>  /* High bits in flags field are unused. */
>  #define TUN_VNET_LE     0x80000000
>  #define TUN_VNET_BE     0x40000000
> +#define TUN_DEV_REGISTERED	0x20000000
>  
>  #define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
>  		      IFF_MULTI_QUEUE | IFF_NAPI | IFF_NAPI_FRAGS)
> @@ -719,8 +720,10 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>  			netif_carrier_off(tun->dev);
>  
>  			if (!(tun->flags & IFF_PERSIST) &&
> -			    tun->dev->reg_state == NETREG_REGISTERED)
> +			    tun->dev->reg_state == NETREG_REGISTERED) {
>  				unregister_netdevice(tun->dev);
> +				tun->flags &= ~TUN_DEV_REGISTERED;

Isn't this done too late ?

> +			}
>  		}
>  		if (tun)
>  			xdp_rxq_info_unreg(&tfile->xdp_rxq);
> @@ -884,8 +887,10 @@ static struct tun_struct *tun_get(struct tun_file *tfile)
>  
>  	rcu_read_lock();
>  	tun = rcu_dereference(tfile->tun);
> -	if (tun)
> +	if (tun && (tun->flags & TUN_DEV_REGISTERED))
>  		dev_hold(tun->dev);
> +	else
> +		tun = NULL;
>  	rcu_read_unlock();
>  
>  	return tun;
> @@ -2836,6 +2841,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  		err = register_netdevice(tun->dev);
>  		if (err < 0)
>  			goto err_detach;
> +		tun->flags |= TUN_DEV_REGISTERED;
>  	}
>  
>  	netif_carrier_on(tun->dev);
> 


So tun_get() will return NULL as long as  tun_set_iff() (TUNSETIFF ioctl()) has not yet been called ?

This could break some applications, since tun_get() is used from poll() and other syscalls.

