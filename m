Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F790C2BFB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 04:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfJACkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 22:40:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41664 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfJACkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 22:40:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so8562929pgv.8
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 19:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iOpc9A8RXZB7+5gXRooFpQuN/ZzEcWnsztvncTpLtmg=;
        b=JjmmQpAykNQdFBpXy5xDAJS32YWwR/cqD2IqHuvfzuET42mHYmrKg8oy38teNkmNpc
         pJ6YRDHhfSFSnvX53aqtN11CETl2A98kZjTgW0pUTqRU7r175MtA7uAy+52waykxmZPR
         6NCTulOX65xZmDTEgT2O+A6m39RZql13IfhAjbWezzdsw/NRYoHAKu4GSnXA1liArXTt
         tg4YQZTLEKHB2o7KXX9M1uC+TOAJYstZARSdchkBr84PCeLcvB6Hf9eF5sc4Gb5XtBqJ
         5VCcOg/odJPL17V3v4CNVfv18AOpWqv9AqiKq9jbpE1P9dYPR+9oFi/eZ3Cg3rZINNUm
         /VyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOpc9A8RXZB7+5gXRooFpQuN/ZzEcWnsztvncTpLtmg=;
        b=kP297gerdXamIFyc7gUYanihiuQ5ZNUMHRyc//L+59PyEB1Fat4K630dDIE1Ul2pzV
         K8sikreGi4o6iaUid8/mtgNJMRzqrgT5US0+jMo92VyZOEAJyQhvaCtHmg1yqHfiU9kD
         uZXwj26yGLiwEyThry95/GzUIIR4qexhTZyB1IYrdB72sDq75vpYMiClzNhxMnzLCdv9
         w2e+pl6COaha5r9m3fNdSsGPMph7agvWVFK7hEiV5Y8xkMFtdsYD2H9TBvMzQQs5W5uf
         4z61w3zp7yUqIl0yRlMNkgFI6cGu/dNZ5Aj3Ukkmc6Nuae23E5nSfI0ZxmikcD9QehPh
         ed8Q==
X-Gm-Message-State: APjAAAXBJPwZJvFqu84mple3RSWP/TkVt6X/bfkcoMl39KJ74rr/DX7s
        H964HzcspKnQoFbIziy9TNKhLDax
X-Google-Smtp-Source: APXvYqzhy/Sp4un4coHZQhBBpxchP+YKiuQi/OAw2/BVZMmq1QiotuwfzGdSetmZ1GXhD2ficmyQ4w==
X-Received: by 2002:a65:4002:: with SMTP id f2mr27841712pgp.447.1569897639797;
        Mon, 30 Sep 2019 19:40:39 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id v1sm19402680pfg.26.2019.09.30.19.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 19:40:38 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
References: <20191001013736.25119-1-dsahern@kernel.org>
 <89c92628-57ec-72ec-3d05-9c4511e8ee38@gmail.com>
 <57eab627-8cc5-4834-a865-1970a290821a@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8a53dcff-729f-aaea-b136-ff997cf43e08@gmail.com>
Date:   Mon, 30 Sep 2019 19:40:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <57eab627-8cc5-4834-a865-1970a290821a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/19 7:23 PM, David Ahern wrote:
> On 9/30/19 8:01 PM, Eric Dumazet wrote:
>>

>>
>> Do we need to keep the test on IF_READY done later in this function ?
>>
>> If IF_READY can disappear only under RTNL, we might clean this.
>>
>> (unless addrconf_dad_work() releases rtnl and reacquires it)
> 
> Unless I am missing something none of the functions called by dad_work
> release the rtnl, but your comment did have me second guessing the locking.
> 
> The interesting cases for changing the idev flag are addrconf_notify
> (NETDEV_UP and NETDEV_CHANGE) and addrconf_ifdown (reset the flag). The
> former does not have the idev lock - only rtnl. The latter has both.
> Checking the flag is inconsistent with respect to locks.
> 
> As for your suggestion, the 'dead' flag is set only under rtnl in
> addrconf_ifdown and it means the device is getting removed (or IPv6 is
> disabled). Based on that I think the existing:
> 
> 	if (idev->dead || !(idev->if_flags & IF_READY))
> 		goto out;
> 
> can be moved to right after the rtnl_lock in addrconf_dad_work in place
> of the above change, so the end result is:
> 
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 6a576ff92c39..dd3be06d5a06 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -4032,6 +4032,12 @@ static void addrconf_dad_work(struct work_struct *w)
> 
>         rtnl_lock();
> 
> +       /* check if device was taken down before this delayed work
> +        * function could be canceled
> +        */
> +       if (idev->dead || !(idev->if_flags & IF_READY))
> +               goto out;
> +
>         spin_lock_bh(&ifp->lock);
>         if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
>                 action = DAD_BEGIN;
> @@ -4077,11 +4083,6 @@ static void addrconf_dad_work(struct work_struct *w)
>                 goto out;
> 
>         write_lock_bh(&idev->lock);
> -       if (idev->dead || !(idev->if_flags & IF_READY)) {
> -               write_unlock_bh(&idev->lock);
> -               goto out;
> -       }
> -
>         spin_lock(&ifp->lock);
>         if (ifp->state == INET6_IFADDR_STATE_DEAD) {
>                 spin_unlock(&ifp->lock);
> 
> 
> agree?
> 

SGTM, thanks !

