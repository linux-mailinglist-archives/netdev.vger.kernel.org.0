Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60909437EAF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhJVTe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhJVTez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 15:34:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35176C061764;
        Fri, 22 Oct 2021 12:32:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x1-20020a17090a530100b001a1efa4ebe6so1545519pjh.0;
        Fri, 22 Oct 2021 12:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KGuhaaAGa7HJ+q6TZKoJHHAr1+bKfVkj8J7RR7y3VKk=;
        b=BJcJcsV+qyHQLSr36qxzk/eSZGcmfCMiSPjiHVz6HZXD8+N3JkwksLfFvpp6zUIM/f
         yI6XKZsejKSqFH9UkVbCZdEkpL9G3MY8wkAXT1DFtbagRW5kBgLOBnx/UERtl/1nTUT7
         YoQLFImQ9RH4+ZwxmsKMHcoFDiLbL6pWG+S8+VNq+4FghsVpSjpGMkd6OKxg3cO14RPm
         6NkCWcSHWeFGogh9lzskX8krcdyBN1JMQg3SZ35I3xu8EbE5EfDWFOV5eBMbMlwzmspu
         HDG8ls803XIdvrmpJIFQ3QKg/sGeVF1Wu4QFnY8tdh+tmF0P9RNCKf0Mc4uGnAZHojqa
         NpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KGuhaaAGa7HJ+q6TZKoJHHAr1+bKfVkj8J7RR7y3VKk=;
        b=2e49355ZqvMEquDuuUYoGkoi9bMIx+CjiJ7PTya22H30y/U7DYUzXRP9xVeOxHUAKR
         G8UCZAdYaE6SDJc+4vplGWbrq1YTCiUvvo6kkVpdqMGma+eICWb4urgfv7NT0J3nSAEC
         V6Ft8GBVjrBCoGauzKu85WNhdZxRBWd/mR8raVF8r3638ovA9TB4lx++oulw2C0aAfXh
         RgYIoCGpMa//eumsZozakFwraBru3m6fYtAOqL1Jx4gTOq8QxfsNz4Ags5MaEI7+JL7a
         16OsMnAzaMjJb4ep9aip4l3qH+Cc5lqFWFR7PhX/ywBgSGdzvPBklJLKiLosvq4nsPlv
         0vsQ==
X-Gm-Message-State: AOAM533dRJexWaCtj7qB8FHR3Xd8EoMi6dnM9l1HL9k+pxrFAVaZQepB
        K0KuDulpSEmRF7Vv4sqlgHY=
X-Google-Smtp-Source: ABdhPJwLgbkdtzb65l5w4UCp/RN4ia/VWySOZizprrGJxw11yK8FG5osK6NVFxsjHTQRMHno1bR4dA==
X-Received: by 2002:a17:90b:185:: with SMTP id t5mr2143936pjs.54.1634931157771;
        Fri, 22 Oct 2021 12:32:37 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c12sm10560459pfc.161.2021.10.22.12.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:32:37 -0700 (PDT)
Subject: Re: [PATCH net v10] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@openvz.org
References: <2721362c-462b-878f-9e09-9f6c4353c73d@gmail.com>
 <644330dd-477e-0462-83bf-9f514c41edd1@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a55b298d-703f-d204-d425-a1d0704b2bb8@gmail.com>
Date:   Fri, 22 Oct 2021 12:32:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <644330dd-477e-0462-83bf-9f514c41edd1@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/22/21 3:28 AM, Vasily Averin wrote:
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
> - skb_set_owner_w() for newly cloned skb is called too early,
> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> In this case sk->sk_wmem_alloc should be adjusted too.
> 
> [1] https://lkml.org/lkml/2021/8/20/1082
> 
> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
> Fixes: 2d85a1b31dde ("ipv6: ip6_finish_output2: set sk into newly allocated nskb")
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v10: is_skb_wmem() was moved into separate header (it depends on net/tcp.h)
>      use it after pskb_expand_head() insted of strange sock_edemux check

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
