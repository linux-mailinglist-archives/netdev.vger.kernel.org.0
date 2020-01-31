Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C15C14F2EF
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgAaTsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:48:50 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43405 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAaTsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 14:48:50 -0500
Received: by mail-ot1-f65.google.com with SMTP id p8so7686833oth.10
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 11:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lnncWQBycsqnIddAEsIGJKnJ6OCaRzi46wYEqqEzFQM=;
        b=h1u6+JEuWIZyKrlCIN8wE9SLi7r3k9YqCDH1Q6qCSZoWEzwbaArmjjjdFESkg9ZrV3
         mP1BMSc0pAJdS6DDym/EkfX4RN7cQWwb3dxljYXK3yxa2M1SMHbcQQtFKnujORwIzcrt
         1UmXSzDvfXvmcgInVc5jVZuAYMo4/HEUUPT6rmpM0cIW4iSDjva5oWtmkEcN2f1HYBw6
         V4CVRPODf9DAHguGRVYxJTQgjFb7JiERicJ3sR8V1frjWSFkbFgxnauJU36mKi2c/2Kq
         QhumDm3bZbacJxz9SyH9YtI00qon1Edf4oQV/biZX66EQMNjlYpfRp62yCBn43NMBxzN
         5kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lnncWQBycsqnIddAEsIGJKnJ6OCaRzi46wYEqqEzFQM=;
        b=OvuWNXJRKi+dEDXmNKdrWCO9nacC1E5qCbeYmhIh4o7yKuWkqWvK7CPrj31OdvehpD
         e7c1JCTRGtg8IBW7W0MQgXY4+QMlBbvB4p+EnaDtdiW0Lh4hGjjhuNwyNFZY17e7XQba
         B9hoYMG1olyWu9vDCD6LlUDwOBU8GznhgaTt5dSH6VHMJ9hihdytYAQrJ/7Bv3QVJ7gM
         yvnVLtd8ZMl4aocL9cuVx6mfPyd6Jx5BLyGo4tlpDL+aYV7lALLHSxNzUFW+yNtldNBE
         Ug20BxtMMI3JP9R6VkcV9tb3xPcDhvNapSYdykpWciG097CrudQ0iLSbsehCt14U3JqG
         aBhw==
X-Gm-Message-State: APjAAAUlPEKRKOwqYdnHF/uO0lUH05pBLWmWMUnj00x2AZzaqUksrDZl
        +13Kx2IkzzAa1l8GK3hUwVp244riVMbSwt8L4l9vUg==
X-Google-Smtp-Source: APXvYqzl2Koc1GBztoHy1NWAKmZ6WL5mLWBE7nVZThE8AVy8IYDhMJogQAFcXMoEWbUFkyV7yvsrT8hBCZnw7AXSB3Y=
X-Received: by 2002:a9d:7b51:: with SMTP id f17mr8638299oto.302.1580500129528;
 Fri, 31 Jan 2020 11:48:49 -0800 (PST)
MIME-Version: 1.0
References: <20200131183241.140636-1-edumazet@google.com>
In-Reply-To: <20200131183241.140636-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 31 Jan 2020 14:48:33 -0500
Message-ID: <CADVnQymbDMHMUxGyy5jequ6iEzL+eFSAR0p+wRk0WGrsjNFs8A@mail.gmail.com>
Subject: Re: [PATCH net] tcp: clear tp->data_segs{in|out} in tcp_disconnect()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 1:32 PM Eric Dumazet <edumazet@google.com> wrote:
>
> tp->data_segs_in and tp->data_segs_out need to be cleared
> in tcp_disconnect().
>
> tcp_disconnect() is rarely used, but it is worth fixing it.
>
> Fixes: a44d6eacdaf5 ("tcp: Add RFC4898 tcpEStatsPerfDataSegsOut/In")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  net/ipv4/tcp.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index a8ffdfb61f422228d4af1de600b756c9d3894ef5..3b601823f69a93dd20f9a4876945a87cd2196dc9 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2643,6 +2643,8 @@ int tcp_disconnect(struct sock *sk, int flags)
>         tp->bytes_acked = 0;
>         tp->bytes_received = 0;
>         tp->bytes_retrans = 0;
> +       tp->data_segs_in = 0;
> +       tp->data_segs_out = 0;
>         tp->duplicate_sack[0].start_seq = 0;
>         tp->duplicate_sack[0].end_seq = 0;
>         tp->dsack_dups = 0;
> --

Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
