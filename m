Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F0F3496BB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCYQZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:25:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3273C06174A;
        Thu, 25 Mar 2021 09:25:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m11so2565777pfc.11;
        Thu, 25 Mar 2021 09:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ih+luDUaxDLVPOZQtuG7QiiLKORn63SvGKEgjdkkdGM=;
        b=N4pLEkiDiYPdS4rfOshtXbT9/742Np9N0bWwh6irdur8+A9lyglSaeb9VJVw02Of4t
         wEjoD1D2FcSXMXwoua3OyKbio2sH6qcKGrBKUuM08FZmbcSZF6XKwgCGWo2DruoDZHro
         KQjmHlyOdZyHGQGgQw64o3wExC/4GJyB9lJGVHKJGK4M3nncsHwLPpU1DX96x46yWe52
         iVBYNNzUEzclsEafGDqAmjPN4jSTt2yQ1sRX/5jmWcDCs5deuVpPam4WxOpxGTDnYyFe
         NEIR8cT5femJ8SwxBSbHCRMWo6u3LL/TXNw1/VOsCjrM3VGTBTI07n0MR1hO53ZmmHYZ
         nlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ih+luDUaxDLVPOZQtuG7QiiLKORn63SvGKEgjdkkdGM=;
        b=ldvwBpX91CEYXXqB9NuLttkjbOdZB8A0EXpME+mnp+uI+6T1bY87eJWWlK+uDf36Fr
         k+G4JsHjeDgm3tHjnmlzVlM+H9axZILX6kM1ss3HWjqc9DKkAoPIYKMC6YnMWyqwMUq+
         9n3tSIwhD5pa8S2UXSGdn5KY3veUKMxYwqbnE4gE4c8oJIh42GFc1+eG/4tuLIuNPyfZ
         DBr6RE5p4jLj4JK1NUQYLsoa+p4iv8BnKUKQc1UyVsZn61CNFbFmSUYmIEFd8GmdB+Q0
         Jhudx8cMO7W4laeqpOPzRUXsSMpMe1wHlq7z9WUf8tO5ACHAFK5yRLiwhIJGDghaikmM
         IRqA==
X-Gm-Message-State: AOAM531NPp4QRyrUqmpY3Ct6v2P+TMYWMpN74RS6VoaJOUwjP4X0pKp6
        +IqWNis87aPbheiwOQg+oZ4=
X-Google-Smtp-Source: ABdhPJyd8ZWYG69nlZYOuolV8dgM2vQ/V4vbHvDr5ZsOETnvIxuhLxo04JiEjVJ/pTmSrRifMede9Q==
X-Received: by 2002:a62:764c:0:b029:1ef:20d2:b44 with SMTP id r73-20020a62764c0000b02901ef20d20b44mr8567083pfc.45.1616689504283;
        Thu, 25 Mar 2021 09:25:04 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id w37sm6157275pgl.13.2021.03.25.09.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 09:25:03 -0700 (PDT)
Subject: Re: [PATCH net-next v3 0/7] mld: change context from atomic to
 sleepable
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20210325161657.10517-1-ap420073@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <193f4890-0bb6-8f90-dada-2e1917e0b12b@gmail.com>
Date:   Fri, 26 Mar 2021 01:24:58 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325161657.10517-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/26/21 1:16 AM, Taehee Yoo wrote:
> This patchset changes the context of MLD module.
> Before this patchset, MLD functions are atomic context so it couldn't use
> sleepable functions and flags.
> 
> There are several reasons why MLD functions are under atomic context.
> 1. It uses timer API.
> Timer expiration functions are executed in the atomic context.
> 2. atomic locks
> MLD functions use rwlock and spinlock to protect their own resources.
> 
> So, in order to switch context, this patchset converts resources to use
> RCU and removes atomic locks and timer API.
> 
> 1. The first patch convert from the timer API to delayed work.
> Timer API is used for delaying some works.
> MLD protocol has a delay mechanism, which is used for replying to a query.
> If a listener receives a query from a router, it should send a response
> after some delay. But because of timer expire function is executed in
> the atomic context, this patch convert from timer API to the delayed work.
> 
> 2. The fourth patch deletes inet6_dev->mc_lock.
> The mc_lock has protected inet6_dev->mc_tomb pointer.
> But this pointer is already protected by RTNL and it isn't be used by
> datapath. So, it isn't be needed and because of this, many atomic context
> critical sections are deleted.
> 
> 3. The fifth patch convert ip6_sf_socklist to RCU.
> ip6_sf_socklist has been protected by ipv6_mc_socklist->sflock(rwlock).
> But this is already protected by RTNL So if it is converted to use RCU
> in order to be used in the datapath, the sflock is no more needed.
> So, its control path context can be switched to sleepable.
> 
> 4. The sixth patch convert ip6_sf_list to RCU.
> The reason for this patch is the same as the previous patch.
> 
> 5. The seventh patch convert ifmcaddr6 to RCU.
> The reason for this patch is the same as the previous patch.
> 
> 6. Add new workqueues for processing query/report event.
> By this patch, query and report events are processed by workqueue
> So context is sleepable, not atomic.
> While this logic, it acquires RTNL.
> 
> 7. Add new mc_lock.
> The purpose of this lock is to protect per-interface mld data.
> Per-interface mld data is usually used by query/report event handler.
> So, query/report event workers need only this lock instead of RTNL.
> Therefore, it could reduce bottleneck.
> 
> Changelog:
> v2 -> v3:
> 1. Do not use msecs_to_jiffies().
> (by Cong Wang)
> 2. Do not add unnecessary rtnl_lock() and rtnl_unlock().
> (by Cong Wang)
> 3. Fix sparse warnings because of rcu annotation.
> (by kernel test robot)
>     - Remove some rcu_assign_pointer(), which was used for non-rcu pointer.
>     - Add union for rcu pointer.
>     - Use rcu API in mld_clear_zeros().
>     - Remove remained rcu_read_unlock().
>     - Use rcu API for tomb resources.
> 4. withdraw prevopus 2nd and 3rd patch.
>     - "separate two flags from ifmcaddr6->mca_flags"
>     - "add a new delayed_work, mc_delrec_work"
> 5. Add 6th and 7th patch.
> 
> v1 -> v2:
> 1. Withdraw unnecessary refactoring patches.
> (by Cong Wang, Eric Dumazet, David Ahern)
>      a) convert from array to list.
>      b) function rename.
> 2. Separate big one patch into small several patches.
> 3. Do not rename 'ifmcaddr6->mca_lock'.
> In the v1 patch, this variable was changed to 'ifmcaddr6->mca_work_lock'.
> But this is actually not needed.
> 4. Do not use atomic_t for 'ifmcaddr6->mca_sfcount' and
> 'ipv6_mc_socklist'->sf_count'.
> 5. Do not add mld_check_leave_group() function.
> 6. Do not add ip6_mc_del_src_bulk() function.
> 7. Do not add ip6_mc_add_src_bulk() function.
> 8. Do not use rcu_read_lock() in the qeth_l3_add_mcast_rtnl().
> (by Julian Wiedmann)
> 
> Taehee Yoo (7):
>    mld: convert from timer to delayed work
>    mld: get rid of inet6_dev->mc_lock
>    mld: convert ipv6_mc_socklist->sflist to RCU
>    mld: convert ip6_sf_list to RCU
>    mld: convert ifmcaddr6 to RCU
>    mld: add new workqueues for process mld events
>    mld: add mc_lock for protecting per-interface mld data
> 
>   drivers/s390/net/qeth_l3_main.c |    6 +-
>   include/net/if_inet6.h          |   37 +-
>   include/net/mld.h               |    3 +
>   net/batman-adv/multicast.c      |    6 +-
>   net/ipv6/addrconf.c             |    9 +-
>   net/ipv6/addrconf_core.c        |    2 +-
>   net/ipv6/af_inet6.c             |    2 +-
>   net/ipv6/icmp.c                 |    4 +-
>   net/ipv6/mcast.c                | 1080 ++++++++++++++++++-------------
>   9 files changed, 678 insertions(+), 471 deletions(-)
> 
