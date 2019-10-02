Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88FEC9501
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbfJBXiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40470 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfJBXh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:37:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so583411pll.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XRaP6jsTMiOec7LlRqqtRlzjNg+KzgeggyyHH6v7Xoc=;
        b=hPTLUnUtPTOV9/mAhX4HBNFvedKreKjUzfO6l4E1ZAnvUrn4rK9tVCHXBXN3TAgIgW
         RRFVY7pnDcrZsuTwZZxW3SWBKa8HGTQtQqOmCUVYWIWIkpOrsgZf35Y6YS18F6zJe+iy
         1NiZ0rJVzFqRQHMbIrTyxNHSxj+hpHoRHyb7dpcBlH+C/vdVAME0hWXvnRLmPvw3yLD1
         TaZwRPF8ZKc9x2IYT/HixKBg6r/pFCWBlsZ/mqibgFLsB5JO3hgE8yfUGjUnIYwudYZN
         XrF7CDqjCyQsS9KbAtLXDrlSb3WaVwo2co1PUt06bBwaQz94/09obWzB/jXHLvuA+TyC
         2wsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XRaP6jsTMiOec7LlRqqtRlzjNg+KzgeggyyHH6v7Xoc=;
        b=Obm/FYZpBaAr69TbMNBslx+39euexmlgJCJ4l3ogKB/Q8r397VS9bk2RWPEV8yEynl
         xBXQ2ScFC5mNVPtvCtjmfwgP2pVO/4bzyWGnl9oVH97V1ZNQIwFlPSATh176mG1VaJUI
         dnQtYukPYN/cH9ax/Jnpgz/fpMIwL0WQIg1S4GIo+EXSjR/yaYuxWwb+bB4o+RomFCSB
         Sa8tcHcFvi6pOUkVUgpC9ewNdrIjeAtipv5TObXAsezeeOqaV6GHpRlGmYrRbeaif2qu
         t5EhInRcs17kOV03RNZTNxNoIoFNgxNeiGbuKjkHjs8XGSq1UeYdCqpkAVNOk2nycB6X
         PHTQ==
X-Gm-Message-State: APjAAAVycRk8IwzbtChhCnJhVM/JcRqTjZKsiTVa5gT/Z6vkCorN3x6Z
        DoWGeUtuFKm+hYhLEdcvK8Q=
X-Google-Smtp-Source: APXvYqyZS7SFSB0h0qZpUDaLJt6tnI3gsiL1QrKgAhNRN98Cglv6bBPihkImssMkPVjIUzbMaADvLA==
X-Received: by 2002:a17:902:9689:: with SMTP id n9mr6620444plp.214.1570059475986;
        Wed, 02 Oct 2019 16:37:55 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id l12sm434737pgs.44.2019.10.02.16.37.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 16:37:54 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
 <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
 <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
 <68b04493-1792-e6b9-e248-365f889d0964@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1c93ce72-7a57-8b47-4074-df9e12eadaea@gmail.com>
Date:   Wed, 2 Oct 2019 17:37:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <68b04493-1792-e6b9-e248-365f889d0964@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 5:11 PM, Eric Dumazet wrote:
> 
> 
> On 10/2/19 3:36 PM, Eric Dumazet wrote:
>>
>>
>> On 10/2/19 3:33 PM, David Ahern wrote:
> 
>>>
>>> I flipped to IF_READY based on addrconf_ifdown and idev checks seeming
>>> more appropriate.
>>>
>>
> 
> Note that IF_READY is set in ipv6_add_dev() if all these conditions are true :
> 
> if (netif_running(dev) && addrconf_link_ready(dev))
>      ndev->if_flags |= IF_READY;
> 
> So maybe in my setup IF_READY is set later from a notifier event ?
> 

ipv6_add_dev is called to initialize the ipv6 struct for the device. In
most cases it is invoked when a device is registered (NETDEV_REGISTER in
addrconf_notify).

IF_READY was added by commit 3c21edbd1137 explicitly to delay DAD if the
underlying link is not up (ie., carrier up not just admin up). Given
that it seems appropriate to key off that flag in addrconf_dad_work.

IF_READY is only set or reset under rtnl. It is set on NETDEV_UP (admin
up) or NETDEV_CHANGE (e.g., carrier up) and reset for NETDEV_DOWN. The
latter case is what the patch was trying to detect and bail on.

Maybe dad was getting kicked off too early before (IF_READY not set) and
now it stalls because of the early IF_READY check and nothing restarts
it ...
