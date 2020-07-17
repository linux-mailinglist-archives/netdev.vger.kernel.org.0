Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EB0223E81
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 16:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgGQOpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 10:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgGQOpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 10:45:06 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD99BC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 07:45:05 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id d11so4979212vsq.3
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 07:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YUU+l/uugMm05I2TDTU4x3lCFRy5lxHAsg55wxkbx7k=;
        b=WL38k5Hbtl/qknAsRuM4lkja5dGLEVx6l52pRHq6owLQ8UupcFU0aVR0IokgqHDZ16
         fx4zVT6gmPE8s42LSrXJ9t5Wjw1VysRi+eP3IGWUVIGuHuKXon2gFeQPwWaB2IqAsck0
         E583jKf/4xtKAQBJO4G5Bvf6+vrEwTDZF7uB+LnJK25ZjItbThpxSUWRJ3uiNzpdiznY
         3rVgcvpZg4xM3UyVynufmZZra+3eJwOYETvpFkQippGl6dW/ncZezgtUw8Nns7UnkZZW
         k327rI1t7br4YHlZyz+XJ6G/aK9X/o7cD3cC0ZD1P1hKT2+s1mYGD5hVXcBh8uEfbuxV
         JRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YUU+l/uugMm05I2TDTU4x3lCFRy5lxHAsg55wxkbx7k=;
        b=ucQ/Cfaa8aP6/kdHUSSiU9FxUWDHy9Xq1ocw4rSmoMp4lledqQepviPFtIcXdhxweE
         7Dtr2iho0O17c75u37yexAYT51TFcOh3tHn6HNzUkfQQEcOFAGK/fwxnxaYjo5QcweJ9
         fsEuqRBLZIqzOlDejyuqvb8sMZZgcX0MJGMtUxxPkyGYxSUUOsYUR8MMMPIdpEoPMlO7
         aRBtgkKxRBrK+JS0txIUl/5zNWTcaFORTDJN9EGdvmzfnuxcn0delnWzX0FqclO5TJYP
         nOAwNOyVrNAz0Ofwiowp9Z90yMA9xdm6ocpVUKP1AqaWc9kQzGJ1EuN5M9k7sbB4I19s
         nR1w==
X-Gm-Message-State: AOAM530DN5VxDf1ALz/BqDKbWuTBQ8hyeqkjWkufgR2z18m7i1uZEhvt
        uhOLnVmBSC6UmIf4csV4u/6xRtnQSNERg95aEBc2Lw==
X-Google-Smtp-Source: ABdhPJy8ShFuoC6t0O8FYtZkHIPqF4iIyWQIjnRkfdvEERvVKHI7hLe5OYr0HFUhXmsTqMlbceujZRc/pvi1yYYekro=
X-Received: by 2002:a67:cf88:: with SMTP id g8mr7074120vsm.25.1594997104396;
 Fri, 17 Jul 2020 07:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <66945532-2470-4240-b213-bc36791b934b@huawei.com>
In-Reply-To: <66945532-2470-4240-b213-bc36791b934b@huawei.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 17 Jul 2020 10:44:47 -0400
Message-ID: <CADVnQyksf4Nt2hHsWaAs3wLOK+rDp79ph5TZywMqfEAPOVgzww@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Optimize the recovery of tcp when lack of SACK
To:     hujunwei <hujunwei4@huawei.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, wangxiaogang3@huawei.com,
        jinyiting@huawei.com, xuhanbing@huawei.com, zhengshaoyu@huawei.com,
        Yuchung Cheng <ycheng@google.com>,
        Ilpo Jarvinen <ilpo.jarvinen@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 7:43 AM hujunwei <hujunwei4@huawei.com> wrote:
>
> From: Junwei Hu <hujunwei4@huawei.com>
>
> In the document of RFC2582(https://tools.ietf.org/html/rfc2582)
> introduced two separate scenarios for tcp congestion control:
> There are two separate scenarios in which the TCP sender could
> receive three duplicate acknowledgements acknowledging "send_high"
> but no more than "send_high".  One scenario would be that the data
> sender transmitted four packets with sequence numbers higher than
> "send_high", that the first packet was dropped in the network, and
> the following three packets triggered three duplicate
> acknowledgements acknowledging "send_high".  The second scenario
> would be that the sender unnecessarily retransmitted three packets
> below "send_high", and that these three packets triggered three
> duplicate acknowledgements acknowledging "send_high".  In the absence
> of SACK, the TCP sender in unable to distinguish between these two
> scenarios.
>
> We encountered the second scenario when the third-party switches
> does not support SACK, and I use kprobes to find that tcp kept in
> CA_Loss state when high_seq equal to snd_nxt.
>
> All of the packets is acked if high_seq equal to snd_nxt, the TCP
> sender is able to distinguish between these two scenarios in
> described RFC2582. So the current state can be switched.

Can you please elaborate on how the sender is able to distinguish
between the two scenarios, after your patch?

It seems to me that with this proposed patch, there is the risk of
spurious fast recoveries due to 3 dupacks in the second second
scenario (the sender unnecessarily retransmitted three packets below
"send_high"). Can you please post a packetdrill test to demonstrate
that with this patch the TCP sender does not spuriously enter fast
recovery in such a scenario?

> This patch enhance the TCP congestion control algorithm for lack
> of SACK.

You describe this as an enhancement. Can you please elaborate on the
drawback/downside of staying in CA_Loss in this case you are
describing (where you used kprobes to find that TCP stayed in CA_Loss
state when high_seq was equal to snd_nxt)?

> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> Reviewed-by: XiaoGang Wang <wangxiaogang3@huawei.com>
> Reviewed-by: Yiting Jin <jinyiting@huawei.com>
> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 9615e72..d5573123 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -2385,7 +2385,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
>         } else if (tp->rack.reo_wnd_persist) {
>                 tp->rack.reo_wnd_persist--;
>         }
> -       if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
> +       if (tp->snd_una == tp->high_seq &&
> +           tcp_is_reno(tp) && tp->snd_nxt > tp->high_seq) {

To deal with sequence number wrap-around, sequence number comparisons
in TCP need to use the before() and after() helpers, rather than
comparison operators. Here it seems the patch should use after()
rather than >. However,  I think the larger concern is the concern
mentioned above.

best,
neal
