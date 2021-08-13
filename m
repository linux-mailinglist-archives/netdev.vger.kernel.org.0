Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888563EB3E8
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 12:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhHMKRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 06:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbhHMKRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 06:17:12 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAB2C061756;
        Fri, 13 Aug 2021 03:16:46 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k5-20020a05600c1c85b02902e699a4d20cso6565022wms.2;
        Fri, 13 Aug 2021 03:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qqw1S6wFqpcslkxegqQiXTxlXz74o59gYYNcnKgmY4g=;
        b=Iac72rAAdZ6AojYmmBS1b45TFPgBlke8aXSGKhPB+5ChYdcMcO7rrOnxRDymsPQTes
         Sfi0jSDobljIJhCJbdsbs6KE8Wo+0oGJyE0jPPl7KVeVVHxVjzpLS8r78IaunH+YGcvA
         Cyskeksk0kb8Lc4py22Ak+sLqRYBquFwbX9xBkFi6YUCplmh7QPeDhT+NupyF+dGJJQg
         a3VCGO977oB0ja8EHzCBvHK5VfyAw8jJpH4DIFE7/HQDTP3Cys8n/WyOt0OkfOvqgIzS
         UUrd0Pq8lKhUlL44AEvsXjjX2WJ9YT9JYnRG+6DZMzK9iahdYLOv/kww2MyxFbsTnyPK
         ZLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qqw1S6wFqpcslkxegqQiXTxlXz74o59gYYNcnKgmY4g=;
        b=MzuZ0S0kpzxK4mrJ+ec9TBeSu+GABSnOsVJhpCJtTmpagya/KA7tHNNr3ZNlptK5N1
         75r3SWuSjueMbjObUWcFtVKE1IjyBgGe2GlaH6M+CREBV/pG1FpXiUezwlhn1iF1Tn6e
         wqlEUoKWkp80JQ053gC97N7QGUlj4W6FKiRynQC81RpkxH7SsRvse05E3GIzArGlbQ11
         EQfpwpFiQnWrVXkbvTVXZN9KNoB4p2P892KP7QuCdCjBRaTf9keLuLBRE8XLi3ekm729
         pqMxno/OjPQS9hZTRWFUge8guiS0MRG0vs8IbQ7vxtNTxdITKNa/PV6kbkbXHkhrG3Eo
         p6jA==
X-Gm-Message-State: AOAM533PbFDJsYnxIkfpenWLOgS2vDCnLWgB058oI7763qMrCUJT/J1Z
        a6n1g6bm8TiKb8AiyMjCZQk=
X-Google-Smtp-Source: ABdhPJxusspL3XxpzAX1smg8pNVYGaREmsqR1h9AnCCTJ/0mjdcoR9VTniawwni1Ad19eDHMKiwbBA==
X-Received: by 2002:a05:600c:4fd6:: with SMTP id o22mr1880796wmq.45.1628849804786;
        Fri, 13 Aug 2021 03:16:44 -0700 (PDT)
Received: from [10.0.0.3] ([37.165.153.200])
        by smtp.gmail.com with ESMTPSA id p5sm1253942wrd.25.2021.08.13.03.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 03:16:44 -0700 (PDT)
Subject: Re: [PATCH] net: drop skbs in napi->rx_list when removing the napi
 context.
To:     Phi Nguyen <phind.uet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        memxor@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+989efe781c74de1ddb54@syzkaller.appspotmail.com,
        Mahesh Bandewar <maheshb@google.com>
References: <20210811235959.1099333-1-phind.uet@gmail.com>
 <CANn89iLQj4Xm-6Bcygtkd5QqDzmJBDALznL8mEJrF1Fh_W32iQ@mail.gmail.com>
 <663ac8c4-b0c3-5af6-c3c3-f371e0410a43@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8f324e46-f05c-42d7-9599-a43de7be17dc@gmail.com>
Date:   Fri, 13 Aug 2021 12:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <663ac8c4-b0c3-5af6-c3c3-f371e0410a43@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/21 9:17 PM, Phi Nguyen wrote:
> On 8/12/2021 3:07 PM, Eric Dumazet wrote:
>> Also I object to this fix.
>>
>> If packets have been stored temporarily in GRO, they should be
>> released at some point,
>> normally at the end of a napi poll.
>>
>> By released, I mean that these packets should reach the upper stack,
>> instead of being dropped without
>> any notification.
>>
>> It seems a call to gro_normal_list() is missing somewhere.
>>
>> Can you find where ?
>>
>> Thanks !
>> H Eric,
> 
> I think the location that should have a call to gro_normal_list() is __netif_napi_del(). Let say, if the driver call a function that lead to gro_normal_one(), and add a skb to the rx_list while the napi poll is not scheduled, and the driver remove the napi context before a napi poll could be triggered, then the added skb will be lost.
> 
> Actually, this was the first solution that I tried with syzbot (It passed the test too).
> Best regards,
> Phi

I think the real bug is in drivers/net/tun.c

It can call napi_gro_frags() and I do not see corresponding napi_complete()

This seems completely bogus.

Your patch only works around one the many bugs caused by 
commit 90e33d45940793def6f773b2d528e9f3c84ffdc7 tun: enable napi_gro_frags() for TUN/TAP driver

I suggest not adding your patch, because we should fix the root cause.

