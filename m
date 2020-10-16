Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1F290C25
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391055AbgJPTPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 15:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390811AbgJPTPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 15:15:39 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9D1C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 12:15:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id dn5so3548943edb.10
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 12:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lNly6HduSYb6ohjGS5pJuQvuabbxCH7H5JEAUUD5ptM=;
        b=fYvq2c7EBWClSpbZSGen+lRtgqM40hN/YCndShZr1I0ALFibYw57FDU18RpWEjTLal
         OGiW/CK4QlT91HJ0rYtXBwK1q6lXn96+OLCU5KlCUaThPoL3Ruq++BAtVt3KJ08bXItn
         3Q7X0SYmRTg99DG4HnQnze+pq2cj4dHbySLnvj6HhXD+06rMVjc/6TTzr727B2Ah0Z/g
         gaBYZELND1uGM+c4s5SmMh4tpkX7IB9ExcYlZZCmiteIO+0dSvhDnVNOEilutw4DXSji
         mplY/qPTehqz+yR8jyH42xqBUAge5iao4Hf9wh8kmqf3fpqnsQywxRQHEplfVkutdy2q
         G89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lNly6HduSYb6ohjGS5pJuQvuabbxCH7H5JEAUUD5ptM=;
        b=c5wz8PNyduJfWPvOYr5FQjouRDT/xKw4sreNe00SSHCyEPPTiU8vIdfjtAh6snHfdO
         qhFQcxwdNjK4IkcPsMrgxHztaHKcUG+xFO9uVuY6SnJ+3TC0AJ168r8aLS6OKptcljd7
         zuhm/m5OjfuJeknO3DBzx06hTqshTcxnB1jfG17R/zo9Cdmafd8KnNBk4XWh5TSxyYbb
         HHMCHfCZH2bHJl1DBvh23ZjTk3776/Qh8IKSi3kspRvzvv9oDnivbgnF0kjXGOO8NWrr
         mSwPHeoUkwWqlmgb243Hlk/c5u324Dk76Qn3Y5bWq5C/QEA7p02yFHK4d+nGlXOo+Fy5
         NJ5g==
X-Gm-Message-State: AOAM533oyMrWYLTEr6VyBs1lmM/T12kYD/wwTo6G6F8XCRomhtJbFrqo
        wZHYEm2si4T8XA91GrYGoVQ=
X-Google-Smtp-Source: ABdhPJzn7O6z5FzQPx1X8RK0kBYHVUYoD+bTjdYA05p5zKKFAYAp18ovhHAFG2X4izvWaxU/QwInMQ==
X-Received: by 2002:a50:abc3:: with SMTP id u61mr5678307edc.253.1602875737535;
        Fri, 16 Oct 2020 12:15:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:341e:4b6e:cb58:ea22? (p200300ea8f232800341e4b6ecb58ea22.dip0.t-ipconnect.de. [2003:ea:8f23:2800:341e:4b6e:cb58:ea22])
        by smtp.googlemail.com with ESMTPSA id k21sm2398987edv.31.2020.10.16.12.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 12:15:37 -0700 (PDT)
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
To:     Mike Galbraith <efault@gmx.de>, Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
 <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
 <20201016142611.zpp63qppmazxl4k7@skbuf>
 <42ff951039f3c92def8490d3842e3f7eaf6900ff.camel@gmx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e65ea1a0-fa97-5d07-fbbf-4071f91e2429@gmail.com>
Date:   Fri, 16 Oct 2020 21:15:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <42ff951039f3c92def8490d3842e3f7eaf6900ff.camel@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.10.2020 19:11, Mike Galbraith wrote:
> On Fri, 2020-10-16 at 17:26 +0300, Vladimir Oltean wrote:
>> On Fri, Oct 16, 2020 at 01:34:55PM +0200, Heiner Kallweit wrote:
>>> I'm aware of the topic, but missing the benefits of the irqoff version
>>> unconditionally doesn't seem to be the best option.
>>
>> What are the benefits of the irqoff version? As far as I see it, the
>> only use case for that function is when the caller has _explicitly_
>> disabled interrupts.
> 
> Yeah, it's a straight up correctness issue as it sits.  There is a
> dinky bit of overhead added to the general case when using the correct
> function though, at least on x86.  I personally don't see why we should
> care deeply enough to want to add more code to avoid it given there are
> about a zillions places where we do the same for the same reason, but
> that's a maintainer call.
> 
Of course switching back to napi_schedule() is the easiest solution,
and also for r8169 we may come to the conclusion that it's the best one.
(or, considering full RT, we may even remove the irqoff version completely)
But we should spend at least a few thoughts on whether and how the
irqoff version could be improved. This would have two benefits:
- avoid the local_irq_save/local_irq_restore overhead (architecture-dependent)
- automatically fix all drivers using the irqoff version
If others go the easy way, then this doesn't mean that we must not think
about a better way.
