Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A595A1459C7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAVQYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:24:48 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35851 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAVQYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:24:48 -0500
Received: by mail-ot1-f68.google.com with SMTP id m2so6817308otq.3
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 08:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKJ1wdIY+1Iqqfq4AvdC8Smm58oqdgvRBFYZjh3bwWM=;
        b=C1YkUKcINiY7sOCra+lVShtzg5HU8YYk/ZrM79CX6X/oH9TGRcU5nWsuEihLsExKSS
         q7KlWcfhQU2DJ0C2up5MqV9mfO8F+AZ24+42LnbdJjw3/KVHm4Npmy4X4krwlyFCmsa0
         YJZY9BNC3E+yZPUHtyU9O35YtIVjSNLvwdRrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKJ1wdIY+1Iqqfq4AvdC8Smm58oqdgvRBFYZjh3bwWM=;
        b=In4Q7RibRCFXvzHpd/tHw76lPTvHn7M82CdNKjiCK32m810e3tPmcxLP0taM9Ir6dN
         kBdHL9VU6X1FiILKTSENbby/8d8dzKqNfVdd2q35ma7Kah3PfE1wEfRG9PGzksWfSg/j
         +KOaG539vxlrruWBUwFNX9q1CjSul7ysaTuZ/8zq/LipKaeDGKMkva9p8dSwCocG9KqM
         ZEY23Nkrq8NaM+GRKd3j0+RnO7CXI8weXajZkOUoc91WCsWU/Gr2YA9t95s5myeUuMPZ
         aMZnBxAt+p5A63nBHKtwSL+CfB3wOhmY8rVLwQ+e/gH3DUMb0K1jwZTUVQIJ3rU0ZSiN
         uF4g==
X-Gm-Message-State: APjAAAXKHirV4KZ9Ki/o3GfF7J1k5DoHqbcJuOCiUlYsVYb+DoL7FOI6
        qzPUnbKIvvjqrvKoVThps0sC430XgezePYNY3Jc5YQ==
X-Google-Smtp-Source: APXvYqw5VLMDedY5e7MNRBOXAVIFA2nX12M2xsuqSym2mSMxUddnyE21MEY8R9uCz6o8HIkUFKyK049z1NZ4E3zANOw=
X-Received: by 2002:a9d:24e8:: with SMTP id z95mr8083116ota.5.1579710287820;
 Wed, 22 Jan 2020 08:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20200122130549.832236-1-jakub@cloudflare.com> <20200122130549.832236-7-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-7-jakub@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 22 Jan 2020 16:24:36 +0000
Message-ID: <CACAyw9_bbZQD604YTJTM7G9rGgON6buoL11zzu0YW_pAa2U0AA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/12] bpf, sockmap: Don't set up sockmap
 progs for listening sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 at 13:06, Jakub Sitnicki <jakub@cloudflare.com> wrote:
> @@ -352,7 +376,15 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
>         if (!link)
>                 return -ENOMEM;
>
> -       ret = sock_map_link(map, &stab->progs, sk);
> +       /* Only established or almost established sockets leaving
> +        * SYN_RECV state need to hold refs to parser/verdict progs
> +        * and have their sk_data_ready and sk_write_space callbacks
> +        * overridden.
> +        */
> +       if (sk->sk_state == TCP_LISTEN)
> +               ret = sock_map_link_no_progs(map, sk);
> +       else
> +               ret = sock_map_link(map, &stab->progs, sk);

Could you use sock_map_redirect_okay from the previous patch here
instead of checking for TCP_LISTEN?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
