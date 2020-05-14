Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA81D3563
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgENPls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgENPls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 11:41:48 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC84C061A0E
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 08:41:47 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i22so8308995oik.10
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 08:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krhEvs5AIC6c0blTdWgcO9e/a3Tv7GaFT6TP0m8Yvrg=;
        b=VB9/gPmHsoRpHSiZ+teQTdbR7k5Yx9LUkOOlUhj6CK9m6appdBeu58cVhfrSPmSix/
         3v3ZUdasGK8BSHClTekzcGkFePUktwlGQZ1nSVQDKo8aiBQzX6bu17upOZvBsq7RaaEI
         lNYHL+Pbu+eDytzphVZ0j4ysZcQNNyaubkxv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krhEvs5AIC6c0blTdWgcO9e/a3Tv7GaFT6TP0m8Yvrg=;
        b=CO/7gUFurti5DCKrwTjhFpeT07HRvZXEKtWrX6dq2+W+2HoIcmEX3Cnxu0insBVV5p
         dq4wAa2zds+Zwu/nmzB8nG5MXnvcENt8VJrRmQ7ZC7f56W95Zy92PGmQjTS7tJfFaUDa
         pflLR36ZhAfJbbeAEAznhCmld0+gIwv9fUPvhSayHLTX19QxVaYyHNTubkSw09h5WT/b
         6AhS20DcWSthdM+hzagmHwNQV4Toh9ICdhiBpYePG4SxRVz0To7fQTsU9LEZoeTpt6Co
         krw8gE587qqMKehErGsdzgdJBBQrmt7z6FVBerMvAqGpBtoLp1T8vDdaJxX4MiW3XTXg
         7OKw==
X-Gm-Message-State: AGi0PuaUfqgHrj2e6lh9pGPwWR3rQpg8S7lYj/VfpRrB8ueDyylG+jGy
        11viKOgUnB886EOgfnjVeU6/8RB2U+b8fg6LTjwrjA==
X-Google-Smtp-Source: APiQypJ31s2KLZTgcqdErYLq4+L9Mykr2/IzY3TtcqTc0aQO8sNe28o8Z8FhG5lx/JIbxY5/yN/4559ZnylTzXEpAdE=
X-Received: by 2002:a05:6808:a91:: with SMTP id q17mr29695049oij.102.1589470904531;
 Thu, 14 May 2020 08:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <51358f25-72c2-278d-55aa-f80d01d682f9@gmail.com>
In-Reply-To: <51358f25-72c2-278d-55aa-f80d01d682f9@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 14 May 2020 16:41:33 +0100
Message-ID: <CACAyw9-7Ua1W6t1B8StWjUC4ui4OUpOX7XtKnzTNARVdgMFqsg@mail.gmail.com>
Subject: Re: "Forwarding" from TC classifier
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 at 22:23, David Ahern <dsahern@gmail.com> wrote:
>
> On 5/13/20 10:40 AM, Lorenz Bauer wrote:
> > Really, I'd like to get rid of step 1, and instead rely on the network
> > stack to switch or route
> > the packet for me. The bpf_fib_lookup helper is very close to what I need. I've
> > hacked around a bit, and come up with the following replacement for step 1:
> >
> >     switch (bpf_fib_lookup(skb, &fib, sizeof(fib), 0)) {
> >     case BPF_FIB_LKUP_RET_SUCCESS:
> >         /* There is a cached neighbour, bpf_redirect without going
> > through the stack. */
> >         return bpf_redirect(...);
>
> BTW, as shown in samples/bpf/xdp_fwd_kern.c, you have a bit more work to
> do for proper L3 forwarding:
>
>         if (rc == BPF_FIB_LKUP_RET_SUCCESS) {
>                 ...
>                 if (h_proto == htons(ETH_P_IP))
>                         ip_decrease_ttl(iph);
>                 else if (h_proto == htons(ETH_P_IPV6))
>                         ip6h->hop_limit--;
>
>                 memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
>                 memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
>                 return bpf_redirect_map(&xdp_tx_ports,
> fib_params.ifindex, 0);
>
> The ttl / hoplimit decrements assumed you checked it earlier to be > 1

Thanks for the pointer :)


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
