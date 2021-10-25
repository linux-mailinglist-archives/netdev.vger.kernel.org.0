Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153A343A4FD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhJYUuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhJYUuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:50:37 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6BCC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:48:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v1-20020a17090a088100b001a21156830bso394673pjc.1
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iBVX1vkbpAKr6KFJao03fziD6dbyro6K3uqi+NlS8Us=;
        b=Ahh+mj+6ud5dWuRxC7rj14+sl+hc3zpK6SOhBeu+Xyha9vawi1uyHogMVJrRJcfq2O
         tXjFsCQoeAyl+k8jQcob8a46WcNFu2ZnhUhI3cKjwKO5LYQ2+rRkoJ448ZZqE5PsPCTt
         9J7dfZK6bdMrvlZT7oEfAzPbmFieHow6pCkDNUslxogm+NTtYQ6Rctj9+o4N2WriCYdb
         f/RxT8pcom78y9i9+7uzH5qbst+fItUIGy1xLB/BISp7hNOTrlMbTUQJSF7jE+LGNBpt
         lDBAcUeXvOZ2OmjTO8BcxNLF5HQBjvqaE9qErJC7L8C002Dk31pRgoPTG4pR/Mt8THuS
         DqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iBVX1vkbpAKr6KFJao03fziD6dbyro6K3uqi+NlS8Us=;
        b=kpisSPLaxJDLswGMbHupvAX70CjQ/98Vu5Sc3y2meLrF4bZKbEA6wWVcjsmZ29a6oj
         J3gAD+UBBbXuSPQSCF1IggLaNp+DprSAwXfl+bmCrBgqLjo/oCNHZ39AD2VNEo6Q9Yud
         d9yLVeHXaJy4XN+2X1CNrIdx5l0qBZv6G2tutPSZc2Mjpai8H+rG1MNnPVXFo1cGzN2B
         X7VQZ8xK1VQC3h/uNZ4Od2tC6BtdZXilZCuNynDWou71enySI5M4j9gtNaf7phlMSEXu
         1RHVdj0pf4g5K290SoSLjvEnrko7mkbk+vPNDMaE1uFEolULQd8LtXetNy+RH8WOtvoJ
         gZiA==
X-Gm-Message-State: AOAM5310Lb7neON9yXyhQcz/q+86TqJlmLWi/vjBigGAo43HfGxnem4U
        tEpufS+yN2QUsRcQjIYgJPo=
X-Google-Smtp-Source: ABdhPJyyuLlJPSq/n7bsV54RoVm+4abTJu0aICDwWbpZURnjpn4G7emrEPM0vX0TNjYkVuzzWRNbQA==
X-Received: by 2002:a17:90b:3504:: with SMTP id ls4mr23449083pjb.111.1635194893993;
        Mon, 25 Oct 2021 13:48:13 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:9cf1:268c:881a:90c3? ([2620:15c:2c1:200:9cf1:268c:881a:90c3])
        by smtp.gmail.com with ESMTPSA id w185sm19635196pfb.38.2021.10.25.13.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 13:48:13 -0700 (PDT)
Subject: Re: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Alexander Azimov <mitradir@yandex-team.ru>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     zeil@yandex-team.ru, Lawrence Brakmo <brakmo@fb.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
 <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <87d9c47b-1797-3f9a-9707-48d2b398dba3@gmail.com>
Date:   Mon, 25 Oct 2021 13:48:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/21 12:26 PM, Alexander Azimov wrote:
> Hi Eric,
>  
> Can you please clarify why do you think that SYN RTO should be accessible through BPF and SYN ACK RTO should be bound to TCP_TIMEOUT_INIT constant?
> I can't see the reason for such asymmetry, please advise.
>  
> I also wonder what kind of existing BPF programs can suffer from these changes. Please give us your insights.
> 
> ps: this is a copy of the original message, hope this one will come in a plain text
> 

When commit 8550f328f45db6d37981eb2041bc465810245c03
("bpf: Support for per connection SYN/SYN-ACK RTOs")
was added, tcp_timeout_init() (and potential eBPF prog)
would be called from tcp_conn_request() and tcp_connect_init()

So some users are now using this eBPF program, expecting
it to have an effect only from these call sites.

If you are adding more call sites, suddenly the behavior
of TCP stack for these users will change. You have to
document if bad things could happen for them, like unexpected
max acceptable delays for connection establishment being severely reduced.

In any case, I would prefer adding a new @timeout field
in struct request_sock to carry the base timeout
instead of calling a BPF program all the times,
otherwise we could have weird behavior (eg PAWS checks)
if the return from eBPF program is variable for one 5-tuple.

Also, have you checked if TCP syn cookies would still work
if tcp_timeout_init() returns a small value like 5ms ?

tcp_check_req()
...
tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((tcp_timeout_init((struct sock *)req)/HZ)<<req->num_timeout);

-> tmp_opt.ts_recent_stamp = ktime_get_seconds()




