Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C7D254F69
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgH0TxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 15:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH0TxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 15:53:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FE4C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 12:53:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 67so4094767pgd.12
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 12:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=zT+7i5F922jHW3xbSyPsodONvU+BJMw5RUOU+GrK9AQ=;
        b=TVKHk5a2L7Dz8RyYn3vl2Tz9EeaHrWu+6ykLMI/rbaMrf4SzaRvoGZo+KQRfof1qNR
         Sx1O0NcljRSe1YX39+iBl69ePi7jf9wmedUKHnaAyF58159dq2jD2sl7IWC4CiULbg8Y
         dhcvEGrKcmTjYidzAcRG12FfM+W1ggs0//8ozEbsBTdyiZYmdlqu0qO9CcxRAQ6i82gP
         AGIQ4y13LDfrQlYIg34BicEpBC9b62ZehP9cNjRPoKSAZnVgvO19u8hkos6zibCd1V76
         HO/LY4MuRN7o0knflEwq6I1Sqk3lE79U1UxloF+IAxP5n+Gsd27sc/Grdlzm2qQwp/De
         Rl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zT+7i5F922jHW3xbSyPsodONvU+BJMw5RUOU+GrK9AQ=;
        b=FyfR0tk6snlUnT6xecmS8duWvNUYDnPtZ/xWNBZwuyxX6J1iXkuhdBCNBcpcwJ8TjB
         XHXWAVk9QXOEcsH1S2mBvVRFdFQjvtY0gwuuIktn4kGLVqV4JjVscSK41x2EbDnsWfdt
         ldzgsUKJ2CxYyRYF5NIxCGQiVs/r3j+maa8+NsUArZ4tlFJkzTcO2muyVVdVwttZE5D7
         9jjqqTt9c0cAMEnk5Wi6UFT8M1t4EkaB1qV7ZoFUgTdJeXUHIH7aXCYGsCcWT8vZN44J
         6sY5+9X82aXc/p7h0xHiwMgLAYWpJoriBzifBjwMd7Jb/l9UoqPfQNtrnA9HQ4O7PPCs
         SDZw==
X-Gm-Message-State: AOAM5306yRg9+Zzx4fAlaMEA7yiHIwy57kagAxq4i5UHXHd4q+RevcLI
        Cxvc9vPebtZrmfXHo2UbT1g5y2TV6BJeXA==
X-Google-Smtp-Source: ABdhPJwizxVMWdbPOC0ZmeXgSXjoXIaTl6mrDaGCW+wP5QhOWe2ByMj6kauuROrMUHRL20FYxQRJKQ==
X-Received: by 2002:a17:902:d341:: with SMTP id l1mr16665249plk.36.1598557999700;
        Thu, 27 Aug 2020 12:53:19 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id k6sm2914897pju.2.2020.08.27.12.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 12:53:18 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 07/12] ionic: reduce contiguous memory
 allocation requirement
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200827180735.38166-1-snelson@pensando.io>
 <20200827180735.38166-8-snelson@pensando.io>
 <20200827124625.511ef647@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <bd9b0427-6772-068e-d7bd-b1aabf1ac6ed@pensando.io>
Date:   Thu, 27 Aug 2020 12:53:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827124625.511ef647@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/20 12:46 PM, Jakub Kicinski wrote:
> On Thu, 27 Aug 2020 11:07:30 -0700 Shannon Nelson wrote:
>> +	q_base = (void *)PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
> The point of PTR_ALIGN is to make the casts unnecessary. Does it not
> work?
Here's what I see from two different compiler versions:

drivers/net/ethernet/pensando/ionic/ionic_lif.c:514:9: warning: 
assignment makes pointer from integer without a cast [-Wint-conversion]
   q_base = PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);


drivers/net/ethernet/pensando/ionic/ionic_lif.c:514:9: warning: 
assignment to 'void *' from 'long unsigned int' makes pointer from 
integer without a cast [-Wint-conversion]
   q_base = PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);

sln
