Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E5CD5135
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbfJLQ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:59:09 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41142 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfJLQ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:57:08 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so12718238ljg.8;
        Sat, 12 Oct 2019 09:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3hhyLxqkjn0n6SNfrqqq1R/avlplX4Y2rtgBXvZcRbc=;
        b=Lg3F8xUUlWjlKPC4uNuZmdVV6lqg9waQUHCvE1vZ5J8XDFMupAFnRWqSjVlpT8/v78
         TRnM3WgS0YK0vjDgg8yJHRxoBAhpj+7nOzF423d3QwGoxh00Pme52M+moKuEGjSInC4b
         HASXp5hfQKHaEcTLeYV87jwkhAbyFEeVpcb8C2gQS15pIOsxh5JqGqwnbc8VJej9FgLr
         YmC3oPTCfAmKPBQfo+ArTRw3NO2SSZTxOlh+nsA5Rl10nJX68RSqgGhhnI8rLgNmH0+x
         lz1NAfHMx4jMpYkYNahxUFYT/KH7uLg/ZM+HtI5nhfJjh4AxnFlSt5KYdbepWaoAkCnO
         XS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3hhyLxqkjn0n6SNfrqqq1R/avlplX4Y2rtgBXvZcRbc=;
        b=aFFvGNZCr8fLcF8Q9tiZjIuXrBXZ3eCb0UuZdgESkfxgVfkBaV02GOzh+Sw52ToDWh
         HFGXX5iETRV6K4N3rl3jm+MlBTNFOrtouSQS/HlL5qlzhHdM6Ey6lukhCvDU9bliJnBc
         FgguqKELnilj33iZi/+XSmq9cPC60VyJbAdJn4XLvn9KOi3k2Gs+AJdd7tbEPrfn3Wah
         yghv6ed2u68nimDX3/Dhc3fm/SsqNj2qrvhKIhfs5GABdc20gqRmxAdAtXrhuqvi+EOj
         gbIB/RwpH9UTkU55HqXUj6qnrc7ZGz0CcADCGOE4PZqx/nc3GDiW5IT/UeSmBWeNBKRb
         miRQ==
X-Gm-Message-State: APjAAAU0IBuYzoNYTEj6KKbBFr6amhOXHXx4MamDvmqTGWteLpaTm6ca
        7j97KK/2xyu9jFFIHHLjOof3t1YlAuieAHkM8is=
X-Google-Smtp-Source: APXvYqyXDmK4QIBaFFIu6/W9zAHTTeymG5uwyuvP0mBeQbhc6i9W4XEu7+p21w3RH4eg1bLADc60lirZ3tv++suW/LQ=
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr12207183ljj.188.1570899425130;
 Sat, 12 Oct 2019 09:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <111664d58fe4e9dd9c8014bb3d0b2dab93086a9e.1570609794.git.jbenc@redhat.com>
In-Reply-To: <111664d58fe4e9dd9c8014bb3d0b2dab93086a9e.1570609794.git.jbenc@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 12 Oct 2019 09:56:53 -0700
Message-ID: <CAADnVQKgXnmbEhBd1FvM16RP_i8s7+risvgM9yftwuP2DejFmA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: lwtunnel: fix reroute supplying invalid dst
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 1:31 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> The dst in bpf_input() has lwtstate field set. As it is of the
> LWTUNNEL_ENCAP_BPF type, lwtstate->data is struct bpf_lwt. When the bpf
> program returns BPF_LWT_REROUTE, ip_route_input_noref is directly called on
> this skb. This causes invalid memory access, as ip_route_input_slow calls
> skb_tunnel_info(skb) that expects the dst->lwstate->data to be
> struct ip_tunnel_info. This results to struct bpf_lwt being accessed as
> struct ip_tunnel_info.
>
> Drop the dst before calling the IP route input functions (both for IPv4 and
> IPv6).
>
> Reported by KASAN.
>
> Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
> Cc: Peter Oskolkov <posk@google.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Peter and other google folks,
please review.
