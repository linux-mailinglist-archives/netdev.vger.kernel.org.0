Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD40A2BAF58
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgKTPxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgKTPxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 10:53:51 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D4C0613CF;
        Fri, 20 Nov 2020 07:53:49 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id o11so10352277ioo.11;
        Fri, 20 Nov 2020 07:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qtiyx+77bOSknaKU6/EmG6RGmVVx/hxoi5PgjEwujl8=;
        b=f/OKGNXvKLRykdLKcHwZRaTmOpQ+FolMBFb0fizQJGconDQ8M5pil3C79VOs6R6JNt
         5peOOfjZ8qYC5Uqd6DUYja2uV/LcW7R8Hd4QoQ2cVbaVAu38ko/XqDmA1vJwcZrLsKN3
         bVnnVJ4GF3dE6rwhTCkjp+Vay0UfkKGxVa1BmaoucxZxCtfcDmJ9J9C6t07Rgtlliwf5
         Xj9PaSW6l+sbHLAPH7yrC6p0JzKl1C2xUaUuEOtgANVOzcx85ZxyA/DJuzD7KZrMe1Iz
         bth6WT/IxvOq2IQMwgQihdszP9ZALudr+eCi2KdryET9E28wVrXz1PvP+W/BFIU74pFm
         yFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qtiyx+77bOSknaKU6/EmG6RGmVVx/hxoi5PgjEwujl8=;
        b=MPpOjQ5QLJ7P9Lm//xtl4PmhSSUeLNXJKVIWij8lWHerqztwG9aL8lMFPdep+XFUcG
         7M0a+VY1AAvqwwzwLmCG0O+ZXwCkcpvKdBV0zNFaMsKUpfk95uTKZaj46vzCGrvtkBcR
         g7nxOSQwTjTneGprI5HtlZFdRAkA/O8HTkmSOBpiZ9d8JRC6fxmExeOBPlpU4HHVSqYX
         Fd9nFgpzKGccgwYvXBX+sEuwyC+4fGp8DXs6s34qxNSUGdvSSYLzxS0+5MOuvanLc5FX
         LMo99ESX1FSuYaXXaySQP6VYOHJi4L4KLxT+0kRyVNazbkbJloBb92IzCWqmkTUGO+bc
         6CNA==
X-Gm-Message-State: AOAM530HMs9GKAj6gxW+lIjk3tyyP00tAs+ZfIT451UQ6o6UFMN5yacc
        oIC32+1NUSvKP/0Rsm7wueg=
X-Google-Smtp-Source: ABdhPJyU0GAsa8tt6QUR7uIX8VRlqQSaBDAsjgPgW8Hyu2FhOxJfmNTk+iYxP1QoJVwHQH4VXeo5AA==
X-Received: by 2002:a02:a15b:: with SMTP id m27mr19996738jah.116.1605887628978;
        Fri, 20 Nov 2020 07:53:48 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:61e9:2b78:3570:a66])
        by smtp.googlemail.com with ESMTPSA id f8sm1768263ioc.24.2020.11.20.07.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 07:53:48 -0800 (PST)
Subject: Re: [PATCH bpf-next V6 2/7] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
To:     Carlo Carraro <colrack@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160571331409.2801246.11527010115263068327.stgit@firesoul>
 <160571337537.2801246.15228178384451037535.stgit@firesoul>
 <20201120092638.14e09025@carbon>
 <CAMdLmZmfr=fe+g+LGpgjRcsw_VfL5rmO3dSeo=WAouczse5BZA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a8683287-71c6-26b0-055b-3988eda111a9@gmail.com>
Date:   Fri, 20 Nov 2020 08:53:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAMdLmZmfr=fe+g+LGpgjRcsw_VfL5rmO3dSeo=WAouczse5BZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 6:15 AM, Carlo Carraro wrote:
> I report here the issue with the previous patch.
> The code is now checking against params->tot_len but then it is still
> using is_skb_forwardable.
> Consider this case where I shrink the packet:
> skb->len == 1520
> dev->mtu == 1500
> params->tot_len == 1480
> So the incoming pkt has len 1520, and the out interface has mtu 1500.
> In this case fragmentation is not needed because params->tot_len < dev->mtu.
> However the code calls is_skb_forwardable and may return false because
> skb->len > dev->mtu, resulting in BPF_FIB_LKUP_RET_FRAG_NEEDED.
> What I propose is using params->tot_len only if provided, without
> falling back to use is_skb_forwardable when provided.
> Something like this:
> 
> if (params->tot_len > 0) {
>   if (params->tot_len > mtu)
>     rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> } else if (!is_skb_forwardable(dev, skb)) {
>   rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> }
> 
> However, doing so we are skipping more relaxed MTU checks inside
> is_skb_forwardable, so I'm not sure about this.
> Please comment


Daniel's just proposed patch changes this again (removes the
is_skb_forwardable check). Jesper: you might want to hold off until that
happens.
