Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A9244F62
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 22:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgHNU5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 16:57:40 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60707 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgHNU5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 16:57:39 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bf5f1a45;
        Fri, 14 Aug 2020 20:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=+TN2wa+LOq4QM87ME7P9NUTEp60=; b=HOMFuv
        uzpvALkSBeVcE1qzFX99qQxChE2wW2WX1nv2lF8qEa0s5/GdWMeBkP87MrjZuTwD
        BxOXbl7SNwjw/ZMb899u6KaUt0SkS2B7lS8OZXYKBbT6+8qjoC1FfLh8LqKJ9w+R
        Rg79ld2pDDXHz68IY5wZtw3G1UcrGc7btyxh9om/LkHj+j1uLwBtrOOTdcKWaM0+
        i15hNDOck5n7e8SH4p7g3CE2WFqqgubzX03LkNjSyvYSukaX85PDAR24XJJzlfRP
        HziGKlyzC1dAAMIOMFWKH6ChAvbAwLgIm5jJUWDTJh0qStqpY5R17JBiikil5AQV
        yI5A0T7DGSomQ/Yg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id da41d064 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 14 Aug 2020 20:31:55 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id b16so12107234ioj.4;
        Fri, 14 Aug 2020 13:57:37 -0700 (PDT)
X-Gm-Message-State: AOAM531cN3ksEC7yPLfUKuSDRgXN+kvaWBBwEB4udDUNRgyz6LNrySdf
        6kjJcRoJZNV4FoVzzn6yLac9I+X8hoxk+w1t8vc=
X-Google-Smtp-Source: ABdhPJydifujAdRmCW4r1wpKJqKOGmdl0myw4po/WElOQTXq97MXyEdg0w5t6X9nXhChvUSv7gHDne+iOopcTfRfp3c=
X-Received: by 2002:a05:6602:15c3:: with SMTP id f3mr3693477iow.25.1597438656291;
 Fri, 14 Aug 2020 13:57:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a92:995a:0:0:0:0:0 with HTTP; Fri, 14 Aug 2020 13:57:35
 -0700 (PDT)
In-Reply-To: <20200814.135546.2266851283177227377.davem@davemloft.net>
References: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
 <20200814073048.30291-1-Jason@zx2c4.com> <20200814.135546.2266851283177227377.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Aug 2020 22:57:35 +0200
X-Gmail-Original-Message-ID: <CAHmME9pQwHeVAseqzA9WYMeh1VHZKRRUc1J=VzWv_0Zoyf8uPg@mail.gmail.com>
Message-ID: <CAHmME9pQwHeVAseqzA9WYMeh1VHZKRRUc1J=VzWv_0Zoyf8uPg@mail.gmail.com>
Subject: Re: [PATCH net v5] net: xdp: account for layer 3 packets in generic
 skb handler
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        kuba@kernel.org, alexei.starovoitov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/20, David Miller <davem@davemloft.net> wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Fri, 14 Aug 2020 09:30:48 +0200
>
>> @@ -4676,6 +4688,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff
>> *skb,
>>  	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
>>  		__skb_push(skb, ETH_HLEN);
>>  		skb->protocol = eth_type_trans(skb, skb->dev);
>> +		__skb_pull(skb, ETH_HLEN);
>>  	}
>>
>>  	switch (act) {
>
> This bug fix is separate from your other changes.  Please do not combine
> them.
>

No problem. I'll split this out and resend tomorrow morning.

Jason
