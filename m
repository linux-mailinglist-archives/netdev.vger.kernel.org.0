Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2AC61E5C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbfGHM0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:26:35 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41415 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfGHM0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:26:35 -0400
Received: by mail-yb1-f194.google.com with SMTP id 13so932502ybx.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 05:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4inZEdjxUhMYTd1dL9zBNIp7bWFCW0mwKGg0oylI8c=;
        b=nZwEOCgrI20V/YnwVedYgEFyUCHXiI2brGngUgESYkHCzCX4oL7MR5LoG0MGQ3l9VH
         XjKJt/2x+k0m3xbwN+sgFNymjRmHPj9OtAIO8hQamYZhlFbP/wPZVT5sredUGGMFmogY
         s35uqzrI8QkRnjLRisI0h4ZfRUeDArQfMrWxGDP55DWHJR4BBt+UsmbZZtz9aRU94RVF
         Rl0REj3xrXBtD1azgFJ1gAnC2QQq4xzjODTAC0FSQOWUZ/30AZDqDVHNOaYD0hr92GNJ
         y4xV5Db2KRWst+rbBO3aM2kIlM2pTRQ3EKxjTpgEZH0C8+bDqSwVKGYkli+apcmIG5J+
         Qqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4inZEdjxUhMYTd1dL9zBNIp7bWFCW0mwKGg0oylI8c=;
        b=IMzKG3+q/E1GoQvzEDQiv5TNbX2zVm49/Jg/FVCO0Xa8Wr1TE6ObMgixqK3B8y7WXZ
         Dxma9BajgW1hLsXbUweaTm8K0FTthyTyoHuirrK5BIBiDUwVZFCGVPJSc9g73WRfKvuv
         mLBgAsYMiZs1ZDl10WxMwgcn23Za4IatAQFxy7s8vMYzMOdMxrtM78IHwQ9rgI0DXkZs
         eW7RaPk9XuSICCzeHQHTrPauh9xX1YmYDqBIBBmN3lPoa1dL3GSAhRNn3b9WIZtQTMzn
         +eoiIJ8BJZNtUtvojKM04dhzAtVjzrbE79yzGoHrV/UQbJVMahOq/SW9mswpThD50Ya3
         QHEw==
X-Gm-Message-State: APjAAAXDJ6Mk+wsLU0/r1Lhj7KqHAYTKntfj+II2s+BrgfPFs06f74LE
        3GziiHkUd5RwfQSttba5Ea3gjioZg07IIMfi6Vk3Mg==
X-Google-Smtp-Source: APXvYqx1Loy+cRza402C9wNYyUuG9q3MEM4QG6WQ5kX8paMVfdkTNjLWwwShDPo9U60oqyCjgYZnnlX/GrQHhsHMDjY=
X-Received: by 2002:a25:8109:: with SMTP id o9mr9250453ybk.132.1562588793883;
 Mon, 08 Jul 2019 05:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190706231307.98483-1-cpaasch@apple.com>
In-Reply-To: <20190706231307.98483-1-cpaasch@apple.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 8 Jul 2019 14:26:21 +0200
Message-ID: <CANn89iK7_girR-iFzsv31NLB34KyS+Lw5GO5urDjhUVeLLywPA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Reset bytes_acked and bytes_received when disconnecting
To:     Christoph Paasch <cpaasch@apple.com>
Cc:     netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 7, 2019 at 1:13 AM Christoph Paasch <cpaasch@apple.com> wrote:
>
> If an app is playing tricks to reuse a socket via tcp_disconnect(),
> bytes_acked/received needs to be reset to 0. Otherwise tcp_info will
> report the sum of the current and the old connection..
>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 0df48c26d841 ("tcp: add tcpi_bytes_acked to tcp_info")
> Fixes: bdd1f9edacb5 ("tcp: add tcpi_bytes_received to tcp_info")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> ---


Signed-off-by: Eric Dumazet <edumazet@google.com>

I am sure other fields miss their zeroing as well.
