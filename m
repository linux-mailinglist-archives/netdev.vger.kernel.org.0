Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360F311BDA1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfLKUFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:05:19 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40362 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfLKUFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 15:05:18 -0500
Received: by mail-ot1-f68.google.com with SMTP id i15so1032408oto.7
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 12:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5k9JDisu4nlmgsGGCk8F1l9/uTx9aqZ9sIEI/B73PFg=;
        b=i7RPrCyZfCDv/J5cVZ+6QPIB3BkSlMtRTtw8L+eDFd7fN1NKkZWn6gt2ngiRWgqLTC
         KvUPI1lD0xntTe+KXlsagGe1wEsTiDiCORo1RBuAwLa5psC0iI5Lv5SDQCeo5egzn2IC
         iaPEP68kYHN0QjzWiSL8EOf7z/QLwWSlLCQTWMvhlpQVHLdltX8uQM6LKybQA7OvCcDz
         MTc+w9DKq8CsuMHo5p3VoaArNeh0wjGYCHiXfFhssJZ8oY2UZH7yo1bZgFqu6G8qX6xT
         Ezr5UGSOXya/EASKhB+4Ktzi16QuiOCppqSBgVBfoVCUPcD7oV9FHEPKqC7y8DSrXWtC
         blyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5k9JDisu4nlmgsGGCk8F1l9/uTx9aqZ9sIEI/B73PFg=;
        b=kOckpE+zNBIUK6apGmIKA5sGHfCX9jm1OQK2w38Hsnns/QudYvcdFGfgK2EqMhhxuw
         Nsr25AIoYmvL3lGZolxJCFpvGGvvUTwWrJSJzn/ZsLBLaYVgaoAEoTtj3LwEESbd556W
         kURIKSDAB03/abqqfSh4DHbtsavELtQO/JRX/GW9DVo/AoFOXga6i/wrFoc5XVcGnRrl
         uyrTTgFuTn3CXSHmXzVUX2myw+uIYDhLS0gJYDzs/U3mFqs+EpTFTEuBM6ajhtjnbMTy
         rFAeMN21RK2PSnw2vBBCyQUs4cOKwvgDv48eie0Z2sdH9TkW2X2kSYHESFh7ORLoVZz9
         hW8Q==
X-Gm-Message-State: APjAAAXtkRjpi7RmdzVY5q9+nn6dVVVqNhoByPst9Vq6QIPD+8cslZsB
        ZFkPmafzNQdTcBAQlgkNsSYDUff//bxIr9pUAfZckw==
X-Google-Smtp-Source: APXvYqxrxwYJk3poybbZjGi3ZJb/Cf7/rFC/kMZoFFByzypSQZVZ3WVhc4nCVhLtiNKUivBE5l2TaosPf1enwqJyri4=
X-Received: by 2002:a9d:480c:: with SMTP id c12mr3911196otf.255.1576094717708;
 Wed, 11 Dec 2019 12:05:17 -0800 (PST)
MIME-Version: 1.0
References: <20191211073419.258820-1-edumazet@google.com>
In-Reply-To: <20191211073419.258820-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 11 Dec 2019 15:05:01 -0500
Message-ID: <CADVnQyms0+Mf5u_OkC1Knq2C+swO8+H6upR-LrtPOD7mrRqpZg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: do not send empty skb from tcp_write_xmit()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 2:34 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
> write queue in error cases") in linux-4.14 stable triggered
> various bugs. One of them has been fixed in commit ba2ddb43f270
> ("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
> we still have crashes in some occasions.
>
> Root-cause is that when tcp_sendmsg() has allocated a fresh
> skb and could not append a fragment before being blocked
> in sk_stream_wait_memory(), tcp_write_xmit() might be called
> and decide to send this fresh and empty skb.
>
> Sending an empty packet is not only silly, it might have caused
> many issues we had in the past with tp->packets_out being
> out of sync.
>
> Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Christoph Paasch <cpaasch@apple.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
