Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9CDAE044
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfIIV1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 17:27:06 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37418 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfIIV1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 17:27:06 -0400
Received: by mail-yb1-f194.google.com with SMTP id t5so5276558ybt.4
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 14:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RdmJq+X6Eql3hahtVdgxjTIS+jl2kpJtyltn1JtqD6I=;
        b=B+drRcRQ17dpHTPyXWMyWFXBjMJuWTYd685I6t2FBJV7OOpKkkAS13mVIS4GYNsfoe
         ZTken7SrnW8A47ms2dP+MSr93S9HKYeUzCg6jSfLPn2szs7r2smfQpsStsurPGCN4IW/
         q67beT5w0LNfLT0qhKb7ymmnxl7Twsz1mIBnDu31xbNnGbKjj7peyY2MeksQCwQipkSR
         sqXkTttSwmrZh1ZRA0xsdv0LYeNYotoNxXE5xsj7xVV3H7+3IjHZmUW9v1KHLXicdrfS
         MVFut1Ga9ZLTryzbSxcL/ar92Gjw0rtPsG3oSU9IzRGrNT0fvIKdvDKh7VvVmlK/FEnS
         Z0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RdmJq+X6Eql3hahtVdgxjTIS+jl2kpJtyltn1JtqD6I=;
        b=aygZnA5bADwGumrcwYFw1M14oVuIzBt5Yyz/lSralsFZxV1kUDAJukyRl/yc3Lvw5a
         bfqqgcT6We7F10MICBHRB7sPf/JofwjUoL1rB2xnw6m8fp9fdqCuD3i9d/5hK9E60wxU
         yw/u/3XHQn5vGKav16UW+5XRXaEVgngCTh0sqwfGzngeALqtYhHD9LqZKuD6M4qgZBnN
         c/SgQdXs2htoFKhqEra+3GlQlpJXl6PUvcTRN7VdWZVtbSi/4U8lvCoG8otA/mZhR7Yi
         Wfd7E+BKUwzihyGC+yuZjctXZgtCxuyHY7HTB0+h8G6ldq4TZ8HQa88loVZGhR+kMSWj
         83zA==
X-Gm-Message-State: APjAAAXajS2wc85zaTT4xX6YjRB2ry1eSOfNAAHmwjSEBL6jEjqDoTzT
        iZCqgdfi8EJbQBuC0HSeyyoEgYicWdqwI0l+Hin/Vw==
X-Google-Smtp-Source: APXvYqzh7yRXvNNIw0jzoSaWFDtRqEntaQWbapwM+FxAXVWoBYi9+Pt4PGjPAfP4deBSxR8JbwXv4IprJ78GRfXlKfI=
X-Received: by 2002:a25:910:: with SMTP id 16mr6332317ybj.504.1568064424657;
 Mon, 09 Sep 2019 14:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190909205602.248472-1-ncardwell@google.com>
In-Reply-To: <20190909205602.248472-1-ncardwell@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Sep 2019 23:26:52 +0200
Message-ID: <CANn89iK2D_AWxbpZE+FgU_3=PR4QBPwOtpKO_3aJ1uzic=yVZw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
To:     Neal Cardwell <ncardwell@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 9, 2019 at 10:56 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> Fix tcp_ecn_withdraw_cwr() to clear the correct bit:
> TCP_ECN_QUEUE_CWR.
>
> Rationale: basically, TCP_ECN_DEMAND_CWR is a bit that is purely about
> the behavior of data receivers, and deciding whether to reflect
> incoming IP ECN CE marks as outgoing TCP th->ece marks. The
> TCP_ECN_QUEUE_CWR bit is purely about the behavior of data senders,
> and deciding whether to send CWR. The tcp_ecn_withdraw_cwr() function
> is only called from tcp_undo_cwnd_reduction() by data senders during
> an undo, so it should zero the sender-side state,
> TCP_ECN_QUEUE_CWR. It does not make sense to stop the reflection of
> incoming CE bits on incoming data packets just because outgoing
> packets were spuriously retransmitted.
>
> The bug has been reproduced with packetdrill to manifest in a scenario
> with RFC3168 ECN, with an incoming data packet with CE bit set and
> carrying a TCP timestamp value that causes cwnd undo. Before this fix,
> the IP CE bit was ignored and not reflected in the TCP ECE header bit,
> and sender sent a TCP CWR ('W') bit on the next outgoing data packet,
> even though the cwnd reduction had been undone.  After this fix, the
> sender properly reflects the CE bit and does not set the W bit.
>
> Note: the bug actually predates 2005 git history; this Fixes footer is
> chosen to be the oldest SHA1 I have tested (from Sep 2007) for which
> the patch applies cleanly (since before this commit the code was in a
> .h file).
>
> Fixes: bdf1ee5d3bd3 ("[TCP]: Move code from tcp_ecn.h to tcp*.c and tcp.h & remove it")
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks Neal
