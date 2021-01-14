Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7622F6717
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhANRMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbhANRMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:12:52 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18E0C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:12:11 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u26so12636051iof.3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 09:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V6xhx1xdXt6YlSe2sCGOf2AxR90CjnY1bihZzHOPvJk=;
        b=QLhoUCpSjbryB4uc9zDc2yh2uQ7gVLlKqCbZj42Ik7Q38YukjCvb4hKMdVoMVHvnLk
         94ofk+2HsZCsfB/d9FEzceKPpMTy4d0m3VK0wxGxRT473ZEWmDjKzHCIAVqYO9C+mGu5
         V/WvoUl1vBJmgBXDugbv3q10Jm/iouB6pL5m4tM+Uh/xol5/7oXNgBsZX/6Y0YkOymPh
         2ZCYZRxjhJH2Xq7Fc5l6v0U4Bh0K9rwI/obiN06K1f8Cs6pXObXrXAt91p0QgoRqY1lf
         td4B6AnxUFWNjrM8Jork1CazB3JV3pp3oFzfZvDqL/54mjXzZdooIjdQHLcp2tcw/kk5
         LE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V6xhx1xdXt6YlSe2sCGOf2AxR90CjnY1bihZzHOPvJk=;
        b=p4iaIGGKwO/reNhHd7pkg+rEQSEMAiQAHZ1zqH5Hcul9sN/qIWahTlWMb7ZjRd7yaN
         3mkkSLoM0YY2WXQbILs9atwF/Ug9lHjI2dBVe10neZBUhsAQ8RJ/y3+8rwbLAkj4iBhR
         hvsh6c39G0J+bbJwsMlqIPSlV9WSFQG5vaKkAvVsEgboiQSNzz4miYe/ybBFK2ZAKGpy
         izjE0dMXX1eHzAyqW9IjpHfhXus4li/LamUMBX+kEAhSYbkLyBMqJk+LrxIdsgHRwkQq
         RPc2SOSkAufFs48uWSWz7TX+fTz6VDHm2xBxWdtnqcjglpmD/gAC+f82lfwkk/qoZNRV
         4M4g==
X-Gm-Message-State: AOAM530nIH4x6twz2W8Av8QV1sMMHun24WOyh/QGTjReozIFSu9XAeQ5
        v/VPEsJ2BV4TmnQ1WUoZUQ81w3t85fJ1p1OsYLUPXQ==
X-Google-Smtp-Source: ABdhPJzjMiW2/A/Q9x2LhEINscM0FhzRNcJbL2WdYo09NumDbOn/R5RX7AYnpS8E0ZsYm5dEgCIKHR39/3UEzlpMQzo=
X-Received: by 2002:a92:ce09:: with SMTP id b9mr7294634ilo.69.1610644331127;
 Thu, 14 Jan 2021 09:12:11 -0800 (PST)
MIME-Version: 1.0
References: <1609192760-4505-1-git-send-email-yangpc@wangsu.com> <20210114085308.7cda4d92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114085308.7cda4d92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 14 Jan 2021 18:11:59 +0100
Message-ID: <CANn89iK5N-u-DKLmAF4+RSiG1g4Y1YkcizTX5h12hsTdpMt0DA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TCP_SKB_CB(skb)->tcp_tw_isn not being used
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 29 Dec 2020 05:59:20 +0800 Pengcheng Yang wrote:
> > TCP_SKB_CB(skb)->tcp_tw_isn contains an ISN, chosen by
> > tcp_timewait_state_process() , when SYN is received in TIMEWAIT state.
> > But tcp_tw_isn is not used because it is overwritten by
> > tcp_v4_restore_cb() after commit eeea10b83a13 ("tcp: add
> > tcp_v4_fill_cb()/tcp_v4_restore_cb()").
> >
> > To fix this case, we record tcp_tw_isn before tcp_v4_restore_cb() and
> > then set it in tcp_v4_fill_cb(). V6 does the same.
> >
> > Fixes: eeea10b83a13 ("tcp: add tcp_v4_fill_cb()/tcp_v4_restore_cb()")
> > Reported-by: chenc <chenc9@wangsu.com>
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
>
> Please fix the date and resend. This patch came in last night,
> but it has a date of December 28th.

Not this whole madness about tcp_v4_fill_cb()/tcp_v4_restore_cb()
could be reverted
now we have an RB tree for out-of-order packets.
