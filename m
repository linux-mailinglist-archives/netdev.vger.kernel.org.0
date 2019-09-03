Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5447FA625C
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfICHT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:19:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34558 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfICHT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 03:19:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id s18so16246705wrn.1;
        Tue, 03 Sep 2019 00:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GqH/uYZ59Bqs/aZMOtR7L5hy5zatr+ayALX3/njulog=;
        b=SdjKZTcKow3BwpqzEoZ74B/a0a4BzQMcq17IpfK/VbNfdBnz0guteqJRqoqJCjFdMu
         O/i3gQWktka6LrFwgkXToXYMiwvtpvBOh/4yTyuiHz4kOhmmoucFxSsnBzj7Mr1SyOUM
         lu/wG6vKwhcX8EpVp0Sfwen11G38vEkqDJ7hJx3O0MXKqq0zlfBHPf6q2IQ90WNTNeF+
         D0EEaNDCEixjvBR1jXcNRV0FjOq6HZbRSK1APaZK29E8vIUrEAllRVwmHqqQ8P1xeQDr
         XhRfqLbQVaYKxJ7FRbMCe/dfJPVZvG0WYrHZ9o6xwm1XR9ZrKPFdVLUG4BbRAXcjmuj3
         Y/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GqH/uYZ59Bqs/aZMOtR7L5hy5zatr+ayALX3/njulog=;
        b=RrsVxAOKmRhqhKAdR6LdzQW5dEniuIP+OZQZXd49qmPXJY1EJhMZBBvY82t5pqiXg1
         3nFU4Fng1RiZ9PlgzEwEyY8PaFP5vBeZLz8jMEfp9qYtq7yD7QGcQxHFDbR9+nwm+tTN
         NyaNP0E8uHccNVlM5j70kL82AIy/vIXW+JoS7sj06Nkg5qjf7xQnvJG/OX+7qhyzgpGF
         qNCFPtHFZ0VSdRtne+atIV8J6L4+zttCm/0CBvjMHirwv8JdqBRbrtaV+AYb2XeUelBI
         BzjppKkA6ailjeN4PuqyXy7MeFd9tVUS6GxoDYRGuQFkw7TZbaerg/pRe0Y0RmAem+D6
         scVg==
X-Gm-Message-State: APjAAAW6mJiNO1RSot94wwiOTw8zGUIq5lVwqV+1Ek+go8Gp2Q53m+Xa
        dtE3Nf2UTXGDjN4AjkAhUDLE204r
X-Google-Smtp-Source: APXvYqxOocrTfmKiAGEZz4fx57g2L5+yjh0cPJzIhAabUSSgcLVev56Qus1QEHOFR5x1pb8KHAwiug==
X-Received: by 2002:adf:a415:: with SMTP id d21mr7857725wra.94.1567495164717;
        Tue, 03 Sep 2019 00:19:24 -0700 (PDT)
Received: from [192.168.8.147] (85.162.185.81.rev.sfr.net. [81.185.162.85])
        by smtp.gmail.com with ESMTPSA id n12sm23312517wmc.24.2019.09.03.00.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 00:19:23 -0700 (PDT)
Subject: Re: [PATCH] net: sched: taprio: Fix potential integer overflow in
 taprio_set_picos_per_byte
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190903010817.GA13595@embeddedor>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cb7d53cd-3f1e-146b-c1ab-f11a584a7224@gmail.com>
Date:   Tue, 3 Sep 2019 09:19:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903010817.GA13595@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 3:08 AM, Gustavo A. R. Silva wrote:
> Add suffix LL to constant 1000 in order to avoid a potential integer
> overflow and give the compiler complete information about the proper
> arithmetic to use. Notice that this constant is being used in a context
> that expects an expression of type s64, but it's currently evaluated
> using 32-bit arithmetic.
> 
> Addresses-Coverity-ID: 1453459 ("Unintentional integer overflow")
> Fixes: f04b514c0ce2 ("taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  net/sched/sch_taprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8d8bc2ec5cd6..956f837436ea 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -966,7 +966,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
>  
>  skip:
>  	picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
> -				   speed * 1000 * 1000);
> +				   speed * 1000LL * 1000);
>  
>  	atomic64_set(&q->picos_per_byte, picos_per_byte);
>  	netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
> 

But, why even multiplying by 1,000,000 in the first place, this seems silly,
a standard 32 bit divide could be used instead.

->

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8d8bc2ec5cd6281d811fd5d8a5c5211ebb0edd73..944b1af3215668e927d486b6c6c65c4599fb9539 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -965,8 +965,7 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
                speed = ecmd.base.speed;
 
 skip:
-       picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
-                                  speed * 1000 * 1000);
+       picos_per_byte = (USEC_PER_SEC * 8) / speed;
 
        atomic64_set(&q->picos_per_byte, picos_per_byte);
        netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",



