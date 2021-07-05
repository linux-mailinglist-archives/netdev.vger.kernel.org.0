Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E0D3BC1BC
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGEQhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhGEQhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:37:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED4DC06175F;
        Mon,  5 Jul 2021 09:35:03 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b14-20020a17090a7aceb029017261c7d206so9045180pjl.5;
        Mon, 05 Jul 2021 09:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fJA+d5ID8q3IsTw9va0CZTFXOsFZE3rsEkxwpk4NWbM=;
        b=H5V1Lk+cSTzjUoH3HLe+PiPcr3U0ePf5/obcZHzGbuX7ko73wrzWJjIwZqtChvRk8c
         0J5s53u19WPJbISAFqiiwhenCJfGvK60bF4NXJLlSZ2ZWTfdTSrxZRIS0vbaxYUpjap6
         cQzWRzTdvXZpj13UQN6J5m0lcyTx5IpjM6WR1Vs+272JXWAoZCKObgtKKq7d2Y78BGXm
         nNKK84pHhXzzYtjSOq5syjuURF5JVc9Xy4EpCboP7VIww4rebJhfr+PeOH5AipVzzbNh
         qx6wCnL4YchmfCJW4WRKN3A1vxwX7ao6E5brYcwMBJ4JsmyCipHECJP+lyxqvGeXkS/I
         c4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fJA+d5ID8q3IsTw9va0CZTFXOsFZE3rsEkxwpk4NWbM=;
        b=hdsHuKjlRI8nolP+iukEC/vZoM/3YTkxJG/aMmR+49X3xsdgjTm4f2LDCp501GDSTc
         TqQNB6rDmj8BH6U8kJP8vizyGtxwsBc9jv1O8d61AxEN6pd12w1IJecVDvSq84tnIm3H
         5c6hqi6QUF85wpQi/CiuAHSW1PhX53gX3NNN5J+xgVNCUbFRUfz8oApHRYm/BNciucqh
         ofwhZAWbRHn0oTgL84C2+wiRZhcJO+IhKnbZUeI4QynmWzETLGs3Lboe56ttFCv2jqL6
         GvyGhsKSv3LWrhEnWcOD7/jc39xQkZ7HP6cGOQiSUfBwD8eTjKAG5VlZMFQaUQBUCxFQ
         2O0A==
X-Gm-Message-State: AOAM532QEpvZfplFejZ8zT6tlc3UTGAIcI/MZ49htWsZLO0ronVKLgp4
        rECSnbxTH9ar02kOm6EwnME=
X-Google-Smtp-Source: ABdhPJyYnDrM6ONgbRFkp9RIr5kc0oySIgLKyHM4GePcEqZcwvV4LC194NZShXNsrrxS6D/vARkc2w==
X-Received: by 2002:a17:90a:f16:: with SMTP id 22mr21345pjy.38.1625502903374;
        Mon, 05 Jul 2021 09:35:03 -0700 (PDT)
Received: from [192.168.93.106] (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id u21sm13118250pfh.163.2021.07.05.09.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 09:35:02 -0700 (PDT)
Subject: Re: [PATCH v4] tcp: fix tcp_init_transfer() to not reset
 icsk_ca_initialized
To:     Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>
Cc:     yhs@fb.com, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, ycheng@google.com, yyd@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
References: <20210703093417.1569943-1-phind.uet@gmail.com>
 <20210703.144945.1327654903412498334.davem@davemloft.net>
 <CADVnQynxFKthexWRFRGN_9enRt7cmgrNo7mpNOMpNVm_jJpt4w@mail.gmail.com>
From:   Phi Nguyen <phind.uet@gmail.com>
Message-ID: <ea882927-a6f6-6d26-66bd-442d03ac3ea0@gmail.com>
Date:   Tue, 6 Jul 2021 00:34:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADVnQynxFKthexWRFRGN_9enRt7cmgrNo7mpNOMpNVm_jJpt4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/2021 9:52 PM, Neal Cardwell wrote:
> 
> 
> On Sat, Jul 3, 2021 at 5:49 PM David Miller <davem@davemloft.net 
> <mailto:davem@davemloft.net>> wrote:
>  >
>  > From: Nguyen Dinh Phi <phind.uet@gmail.com <mailto:phind.uet@gmail.com>>
>  > Date: Sat,  3 Jul 2021 17:34:17 +0800
>  >
>  > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>  > > index 7d5e59f688de..855ada2be25e 100644
>  > > --- a/net/ipv4/tcp_input.c
>  > > +++ b/net/ipv4/tcp_input.c
>  > > @@ -5922,7 +5922,6 @@ void tcp_init_transfer(struct sock *sk, int 
> bpf_op, struct sk_buff *skb)
>  > >               tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
>  > >       tp->snd_cwnd_stamp = tcp_jiffies32;
>  > >
>  > > -     icsk->icsk_ca_initialized = 0;
>  > >       bpf_skops_established(sk, bpf_op, skb);
>  > >       if (!icsk->icsk_ca_initialized)
>  > >               tcp_init_congestion_control(sk);
>  >
>  > Don't you have to make the tcp_init_congestion_control() call 
> unconditional now?
> 
> I think we want to keep it conditional, to avoid double-initialization 
> if the BPF code sets the congestion control algorithm and initializes 
> it. But that's relatively new and subtle, so it might be nice for this 
> patch to add a comment about that, since it's touching this part of the 
> code anyway:
> 
> -       icsk->icsk_ca_initialized = 0;
>          bpf_skops_established(sk, bpf_op, skb);
> +       /* Initialize congestion control unless a BPF op initialized it 
> already: */
>          if (!icsk->icsk_ca_initialized)
>                  tcp_init_congestion_control(sk);
> 
> neal
> 
I will make a new version with your comment.
Thank you very much for helping.
