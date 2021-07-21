Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F263D1214
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbhGUOdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:33:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:12932 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239436AbhGUOdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626880394;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=9TOOFJtYcxyvoohpzVlG4nhQVpdpMTEyMSMQeyKKi+c=;
    b=rHgwrvdoQv9AjciiQbQMGeUMAnhN2ZzrnO0jRc3pgkLZv5xb+Y0vR85rFZGGLFPmG9
    YeXdetO5CvmYb0xIs08YkjFBSeMg2Gs51MGowLrh59XSgFuVcJzwMQYSbUzEZm2Da+lh
    LnCPk+YQsqasvSCzWxThMSpAvQvf4yCwICGGfE+/et3+Cx6Vt15j8HeTS/YSqeKkVMSW
    jXYW2gYD2htKGaxA30VZgkjpJSisOx88r6bDqnF2h3YbSgSOqmVLR9D+y8x2XRzUDpuu
    PJR1+gx/DwF3TCtbdSeQeABMNlr6/LcDLYVI2/MKuzRQ9C3V8hw/A06r9RSa6genZ4pm
    KUfg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3htNmYasgbo6AhaFdcg=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cee:8300::b82]
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id Z03199x6LFDEIcT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 21 Jul 2021 17:13:14 +0200 (CEST)
Subject: Re: [PATCH net] can: raw: fix raw_rcv panic for sock UAF
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210721010937.670275-1-william.xuanziyang@huawei.com>
 <YPeoQG19PSh3B3Dc@kroah.com>
 <44c3e0e2-03c5-80e5-001c-03e7e9758bca@hartkopp.net>
 <11822417-5931-b2d8-ae77-ec4a84b8b895@hartkopp.net>
 <d5eb8e8d-bce9-cccd-a102-b60692c242f0@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <fc68ffdf-50f0-9cc7-6943-4b16b1447a9b@hartkopp.net>
Date:   Wed, 21 Jul 2021 17:13:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d5eb8e8d-bce9-cccd-a102-b60692c242f0@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.07.21 13:37, Ziyang Xuan (William) wrote:
> On 7/21/2021 5:24 PM, Oliver Hartkopp wrote:

>>
>> Can you please resend the below patch as suggested by Greg KH and add my
>>
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>
>> as it also adds the dev_get_by_index() return check.
>>
>> diff --git a/net/can/raw.c b/net/can/raw.c
>> index ed4fcb7ab0c3..d3cbc32036c7 100644
>> --- a/net/can/raw.c
>> +++ b/net/can/raw.c
>> @@ -544,14 +544,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>           } else if (count == 1) {
>>               if (copy_from_sockptr(&sfilter, optval, sizeof(sfilter)))
>>                   return -EFAULT;
>>           }
>>
>> +        rtnl_lock();
>>           lock_sock(sk);
>>
>> -        if (ro->bound && ro->ifindex)
>> +        if (ro->bound && ro->ifindex) {
>>               dev = dev_get_by_index(sock_net(sk), ro->ifindex);
>> +            if (!dev)
>> +                goto out_fil;
>> +        }
> At first, I also use this modification. After discussion with my partner, we found that
> it is impossible scenario if we use rtnl_lock to protect net_device object.
> We can see two sequences:
> 1. raw_setsockopt first get rtnl_lock, unregister_netdevice_many later.
> It can be simplified to add the filter in raw_setsockopt, then remove the filter in raw_notify.
> 
> 2. unregister_netdevice_many first get rtnl_lock, raw_setsockopt later.
> raw_notify will set ro->ifindex, ro->bound and ro->count to zero firstly. The filter will not
> be added to any filter_list in raw_notify.
> 
> So I selected the current modification. Do you think so?
> 
> My first modification as following:
> 
> diff --git a/net/can/raw.c b/net/can/raw.c
> index ed4fcb7ab0c3..a0ce4908317f 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -546,10 +546,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>                                  return -EFAULT;
>                  }
> 
> +               rtnl_lock();
>                  lock_sock(sk);
> 
> -               if (ro->bound && ro->ifindex)
> +               if (ro->bound && ro->ifindex) {
>                          dev = dev_get_by_index(sock_net(sk), ro->ifindex);
> +                       if (!dev) {
> +                               err = -ENODEV;
> +                               goto out_fil;
> +                       }
> +               }
> 
>                  if (ro->bound) {
>                          /* (try to) register the new filters */
> @@ -559,11 +565,8 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>                          else
>                                  err = raw_enable_filters(sock_net(sk), dev, sk,
>                                                           filter, count);
> -                       if (err) {
> -                               if (count > 1)
> -                                       kfree(filter);
> +                       if (err)
>                                  goto out_fil;
> -                       }
> 
>                          /* remove old filter registrations */
>                          raw_disable_filters(sock_net(sk), dev, sk, ro->filter,
> @@ -584,10 +587,14 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>                  ro->count  = count;
> 
>    out_fil:
> +               if (err && count > 1)
> +                       kfree(filter);
> +

Setting the err variable to -ENODEV is a good idea but I do not like the 
movement of kfree(filter).

The kfree() has a tight relation inside the if-statement for ro->bound 
which makes it easier to understand.

Regards,
Oliver

ps. your patches have less context than mine. Do you have different 
settings for -U<n>, --unified=<n> for 'git diff' ?

>                  if (dev)
>                          dev_put(dev);
> 
>                  release_sock(sk);
> +               rtnl_unlock();
> 
>                  break;
> 
> @@ -600,10 +607,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
> 
>                  err_mask &= CAN_ERR_MASK;
> 
> +               rtnl_lock();
>                  lock_sock(sk);
> 
> -               if (ro->bound && ro->ifindex)
> +               if (ro->bound && ro->ifindex) {
>                          dev = dev_get_by_index(sock_net(sk), ro->ifindex);
> +                       if (!dev) {
> +                               err = -ENODEV;
> +                               goto out_err;
> +                       }
> +               }
> 
>                  /* remove current error mask */
>                  if (ro->bound) {
> @@ -627,6 +640,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>                          dev_put(dev);
> 
>                  release_sock(sk);
> +               rtnl_unlock();
> 
>                  break;
> 
