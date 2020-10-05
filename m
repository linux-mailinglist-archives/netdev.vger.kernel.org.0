Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA792837E7
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgJEOer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgJEOer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 10:34:47 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63739C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 07:34:47 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id s15so2054128vsm.0
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 07:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2CttzVWcw4HA5dVt3kuV8tBJMlV+RDA8gwaBv6ot78=;
        b=HAAzHUQIm5ZjVafRPo0wWuPGreJ1im2R1pwfPX5o2213neRTtqtwJsuAfG5egUWYJM
         GJ7hkoSek6s6MrEzhVZACaBrMlktPcd2bsbU61uUXGcVMw00v2iKOkKSuH0OpaYTp4zE
         y14+cMcplm+08shZ40JHp8gTYFT6QZLoi5dAo2sx1SXHCJ1W2l6rOSdcC+YrLUbdi63L
         mPKfshbuZz/MVjllPSyIbtDTk/BjE7kUXrUS9jMz74t77yxMVxomjPbkWS700gQtb3zh
         kpSgWfmiWXIG7Az1fs5KXfLrcrzZhOpzNwimEu2rZ3VantnH7nK6z6nYx+sex7LZLxrE
         JkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2CttzVWcw4HA5dVt3kuV8tBJMlV+RDA8gwaBv6ot78=;
        b=e9lpNSY/xdNpKC2QA4n74ih4NS5ksZODWbpq5EQ3/TQ/DPoasjS3Ezt0Ldv8CWarjH
         sOf/lEYAIFPzgeCvFUgehwSke0qBUAZDz1h7Ncic5HnxzxZLk2nIGvKSG6lC3Zl8WjjE
         zov/qxVvZy/gbIfhdjVMKrbeZ5cU8+dl2+TKMXidUWpdbwq3MsQB2HKaXLBwnbiZLiEg
         yo2P4+c3geWYJ76nc2rwSXmbVq9SYFChfArIcSB31PTmCf2+/j88/P0K7IckqkGOIB3I
         Lx8/isqMVLGd0MjyqbRweiFMxbhGyakPQfmxTOzvhnrd96Hqhok5Uq7E0gZ7bANpw1pt
         1Weg==
X-Gm-Message-State: AOAM532W3+IiNEU8k2t5aeL733KK0zsrtxUhCT9wQUv7ZxXazt6fEZIK
        CZaUTEkyZ5CEQtKPjU5lSqxryqcxerwuflv+qsFE9Dw1bi7J9w==
X-Google-Smtp-Source: ABdhPJyl3RFDveQe2b7zVB2oNOk4vCI90qCJOWvxo0vOUlM0a1zz3l4pDI7D6lHjf/cR9zlpFf7ndHSfjqmtdotOXCk=
X-Received: by 2002:a67:ffc1:: with SMTP id w1mr131077vsq.52.1601908486248;
 Mon, 05 Oct 2020 07:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201005134813.2051883-1-eric.dumazet@gmail.com>
In-Reply-To: <20201005134813.2051883-1-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 5 Oct 2020 10:34:29 -0400
Message-ID: <CADVnQy=jQAWvvfOm8DAtWhHHYq-dLbvxVZSL5fdxLQZ_sM30ZQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix receive window update in tcp_add_backlog()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 5, 2020 at 9:48 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> We got reports from GKE customers flows being reset by netfilter
> conntrack unless nf_conntrack_tcp_be_liberal is set to 1.
>
> Traces seemed to suggest ACK packet being dropped by the
> packet capture, or more likely that ACK were received in the
> wrong order.
>
>  wscale=7, SYN and SYNACK not shown here.
>
>  This ACK allows the sender to send 1871*128 bytes from seq 51359321 :
>  New right edge of the window -> 51359321+1871*128=51598809
>
>  09:17:23.389210 IP A > B: Flags [.], ack 51359321, win 1871, options [nop,nop,TS val 10 ecr 999], length 0
>
>  09:17:23.389212 IP B > A: Flags [.], seq 51422681:51424089, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 1408
>  09:17:23.389214 IP A > B: Flags [.], ack 51422681, win 1376, options [nop,nop,TS val 10 ecr 999], length 0
>  09:17:23.389253 IP B > A: Flags [.], seq 51424089:51488857, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 64768
>  09:17:23.389272 IP A > B: Flags [.], ack 51488857, win 859, options [nop,nop,TS val 10 ecr 999], length 0
>  09:17:23.389275 IP B > A: Flags [.], seq 51488857:51521241, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 32384
>
>  Receiver now allows to send 606*128=77568 from seq 51521241 :
>  New right edge of the window -> 51521241+606*128=51598809
>
>  09:17:23.389296 IP A > B: Flags [.], ack 51521241, win 606, options [nop,nop,TS val 10 ecr 999], length 0
>
>  09:17:23.389308 IP B > A: Flags [.], seq 51521241:51553625, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 32384
>
>  It seems the sender exceeds RWIN allowance, since 51611353 > 51598809
>
>  09:17:23.389346 IP B > A: Flags [.], seq 51553625:51611353, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 57728
>  09:17:23.389356 IP B > A: Flags [.], seq 51611353:51618393, ack 1577, win 268, options [nop,nop,TS val 999 ecr 10], length 7040
>
>  09:17:23.389367 IP A > B: Flags [.], ack 51611353, win 0, options [nop,nop,TS val 10 ecr 999], length 0
>
>  netfilter conntrack is not happy and sends RST
>
>  09:17:23.389389 IP A > B: Flags [R], seq 92176528, win 0, length 0
>  09:17:23.389488 IP B > A: Flags [R], seq 174478967, win 0, length 0
>
>  Now imagine ACK were delivered out of order and tcp_add_backlog() sets window based on wrong packet.
>  New right edge of the window -> 51521241+859*128=51631193
>
> Normally TCP stack handles OOO packets just fine, but it
> turns out tcp_add_backlog() does not. It can update the window
> field of the aggregated packet even if the ACK sequence
> of the last received packet is too old.
>
> Many thanks to Alexandre Ferrieux for independently reporting the issue
> and suggesting a fix.
>
> Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
> ---
>  net/ipv4/tcp_ipv4.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Nice detective work, as always. Thanks for the fix!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
