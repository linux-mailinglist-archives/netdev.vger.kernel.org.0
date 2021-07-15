Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE5B3CA23C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 18:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhGOQ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 12:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhGOQ1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 12:27:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042A8C06175F;
        Thu, 15 Jul 2021 09:24:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k20so7052922pgg.7;
        Thu, 15 Jul 2021 09:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c3/aXWxwWZsVNIueYyWaOz8QDzCDhXIWUztppUhHk0o=;
        b=XmK0IbNZZ0akQlUnfd3cGbFmKP3y0FC5ONnTK/0JweNayIk7z6nqj4xVD3LAt77FQ7
         G05dg4QVADdJ6+0JC1ozGy6GCwmw3p93RbQ/xVmARcgBlsx6scOJhPkJ1ByWLYtHDPsZ
         38CQ/xr2eVccrHauGtZBXaj9nk2aoGrEYAuusTrm+2DMT5HCYv4oLL4G4EkPKez1PXZp
         QmxNR1oAuN5rWWfQ6tMHmuVphBMhlIVgbsNZ3ig2YvX+2RYNY+RDbL/xiVOVaWkkNVw5
         q4Gcwk2QwTA2wooSYq+D7ieRVwnEnaQXn0WZp5OxADIDnvD3VdSzwilkr9wA3CKnJrTi
         rBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c3/aXWxwWZsVNIueYyWaOz8QDzCDhXIWUztppUhHk0o=;
        b=T9w9XaoqKHH0BuVh+t8jpdMw/VY5ibWJ731dTUGD62vvtonK8CZXFxdFWYaXvYUOAl
         SBxdLBKp1e0lMRSRwPTrhl00YrpIcNXuMCnC8GHab+Ki5cdIv/2BNPEr+kbs6x8mQseQ
         ahFKCTTZBtgdMkbFoZ9Yn4J2EPxrxU8hmZrd6w+hjcj9GucKg7Vo9LydeY4NWu6eIZGk
         722sEc9A4xBsgNADzxMODFXBsSbDVclG+OAIim32kmAAYEapfBvNzHHZ0MvRoRC9bXlR
         BNLeFFx7lXJlSg24LJeS+i4k1e8bhEiWzCYkcYetwH8HqZdEN05Vt+tG3pzNr6XxDwa9
         8mpw==
X-Gm-Message-State: AOAM532EYkpuE3f386SyNO8MECQEud9niSo7VxRPJbd55f7DWIERpiMg
        3kFs5VjXK6WE8nGGxbgpz3nEORAFbQry2g==
X-Google-Smtp-Source: ABdhPJxOffVRL6zizuoAz63szuKFiB7TodJXf8MhnivHFdukopAbh0lHKu0ZzN3VdOWOQd1j7KVeZA==
X-Received: by 2002:a65:4244:: with SMTP id d4mr5441714pgq.83.1626366257187;
        Thu, 15 Jul 2021 09:24:17 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lt14sm6277384pjb.47.2021.07.15.09.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 09:24:16 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf> <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf> <YPAzZXaC/En3s4ly@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2ee678f6-07f3-6747-15a8-280cf1f7ca04@gmail.com>
Date:   Thu, 15 Jul 2021 09:24:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPAzZXaC/En3s4ly@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/21 6:08 AM, Andrew Lunn wrote:
>> - If we inherit NETIF_F_HW_CSUM from the master for tail taggers, it is
>>   actively detrimential to keep this feature enabled, as proven my Lino.
>>   As for header taggers, I fail to see how this would be helpful, since
>>   the DSA master would always fail to see the real IP header (it has
>>   been pushed to the right by the DSA tag), and therefore, the DSA
>>   master offload would be effectively bypassed.
> 
> The Marvell MACs know about DSA and should be able to perform hardware
> checksumming. It is a long time since i looked at how this works, but
> i think there is a field in the descriptor which gets set with the
> offset to the IP header, so it work for DSA as well as EDSA.
> 
> I _think_ Broadcom MACs also know about Broadcom tags and can do the
> right thing.

Yes, the SYSTEMPORT MAC as well as bgmac to some extent will
automagically work, but they have to be told to expect a Broadcom tag in
order to generate an appropriate checksum on receive. This is why we
have this:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom/bcmsysport.c#n144

Likewise, for TX:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom/bcmsysport.c#n172
-- 
Florian
