Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4EE4097ED
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbhIMPxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbhIMPx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:53:26 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF9C06119C
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 08:49:54 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id m70so20313195ybm.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 08:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ck/JoeqBfAG5Qwan2vhamlBtmJkxVYHQWsrDPF21rO8=;
        b=Y1qegMxY5Is6Pu6UdJghi9oO7V0m4IFUE5xwLn0QMgEci3r+L1FaOusWG2WQqKxHkH
         5ZSpHUlX7yqphW0PprfmhFdHvzVW45nDsNnlfKtietjosiajXBedX/jVP6wcgLL+jv1X
         OHJqLq6g2t2z2wMZYRw1Oa+9huyMbaQ+7CMk0taISaVPEfYi2Cn6mJ/ykw3WB5ko+Iph
         oWNtZSJK7IMUEa2RsGCjOTO8fTlZjPELLxZp3kKLTF+QYTKZYSNzZQAfxit4qVYd0n2M
         2u0PBiOwHFScHrT+SDAtCeRtpjuLwBQf7lwDf4ztvUI/maVpa0stU1IqbuY6NP9kyjf+
         fE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ck/JoeqBfAG5Qwan2vhamlBtmJkxVYHQWsrDPF21rO8=;
        b=OOMaSyx6XrUx3qhfq6gEI03CB/hOM5jTmMiNWwPWz/civPV71VXXte52RgD/IMhdzn
         rjCCZjz+5Kjz/ZpFWUXKMkx9ZVQTRl1qneQ4W85d2ACIBdLBRKLb41Mq1SjtkiaZvwm8
         Oj+uGWTAxWKlSc7vyAomMt+FQjasGYnTPn6Dz2EXvjHgduoEsgD+pePoUKIBUm7chuYU
         96CCPkcCl3Iw3L+AUujVlFTFIUNJbNedPtYG17qF4MT5QSv+0cY43qokwTPS+vyrumB3
         EnA5to43YJ9OQCMWc6iWctj+wVm+Lxre2kOiT5rCPENhNNqB3fQN5nexsuZ4+qEyR1VT
         ARpQ==
X-Gm-Message-State: AOAM531f/TIHO8Rzbv1qId+Qoqoi5OXRI7B25YkGtNrD3fZ/pX3vEx3X
        8edA/w3V6gEQOmcJyQDYEbwtN8OaNq6rXsytWQcaUA==
X-Google-Smtp-Source: ABdhPJzzpfXAq7AiBooKqs1nuULG6+n6zg33NDJnM7Cj2NQRq0sYSvHLsb6d+DI8IVLLiKE1JDkdBZJc4FpcrtEKE4Q=
X-Received: by 2002:a25:2b07:: with SMTP id r7mr15094190ybr.296.1631548193609;
 Mon, 13 Sep 2021 08:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn>
In-Reply-To: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Sep 2021 08:49:42 -0700
Message-ID: <CANn89iLMDQqVmhq38OhD3X1D93qzAye0AsQpZYdCi=fsLEuNsg@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     zhenggy <zhenggy@chinatelecom.cn>
Cc:     Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>, qitiepeng@chinatelecom.cn,
        wujianguo@chinatelecom.cn, liyonglong@chinatelecom.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 3:51 AM zhenggy <zhenggy@chinatelecom.cn> wrote:
>
> Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
> time") may directly retrans a multiple segments TSO/GSO packet without
> split, Since this commit, we can no longer assume that a retransmitted
> packet is a single segment.
>
> This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
> that use the actual segments(pcount) of the retransmitted packet.
>
> Before that commit (10d3be569243), the assumption underlying the
> tp->undo_retrans-- seems correct.
>
> Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
>

nit: We normally do not add an empty line between Fixes: tag and others.

Reviewed-by: Eric Dumazet <edumazet@google.com>

> Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
> ---
>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3f7bd7a..141e85e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1346,7 +1346,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
>         if (dup_sack && (sacked & TCPCB_RETRANS)) {
>                 if (tp->undo_marker && tp->undo_retrans > 0 &&
>                     after(end_seq, tp->undo_marker))
> -                       tp->undo_retrans--;
> +                       tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
>                 if ((sacked & TCPCB_SACKED_ACKED) &&
>                     before(start_seq, state->reord))
>                                 state->reord = start_seq;
> --
> 1.8.3.1
>
