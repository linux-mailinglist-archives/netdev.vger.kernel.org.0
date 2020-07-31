Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8793D233D36
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 04:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgGaChO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 22:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgGaChN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 22:37:13 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D97C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 19:37:13 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id j23so8784874vsq.7
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 19:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yntLOYPthgAI6aE7mtyDEjpEB11195o3JPL2SOGJFSY=;
        b=F6fW/7J2UgbJpWOBZIzn572WOtBDygNeDC8J+DXzsdUjmQgXZzwAw1MZAhT0u7Zi6d
         C2NsJYTEXsLzXzB9DfrtMv0KUK3EDo5HrYcRe8wPOJCLEW6amtbLuhRIqhIEGNYVoOQy
         I0fpj5mDyE3/Yu0lf1rPrOwCHM38oPX1aALfB9NOO30NP3J2GW0rwg/1j4v1JCuNI1/S
         qD5FaVn5Mm0e9JWy1vcI3iu3cilIuZfL6t0pnR5sWPEuYVpEpM7Kq0o8SOgrOZQaJjBM
         8DtxfqeYB90BSFbGwxTdah1Rgs59ELllXnf3JOQKjjAR2VJU6T/D1BDuD5Owqhm0uwkD
         rlxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yntLOYPthgAI6aE7mtyDEjpEB11195o3JPL2SOGJFSY=;
        b=WVLKV53OJKt6dc7nvQU1ggdSoCxv0n9HkP9fuv1ojDj0O7BX49hlnc0me663Jt9lY8
         urJeSRWKai6sI5QJw8m4we/A0Bu/y6gJcLl9qkWXbrSTIavFg9aNR5raJCCXXiqmRFyH
         fW2eRu7HL+cw1FJ5A2e1y09ZEode/JkAajPIarJlf+yy4cTLcwFoUYPIG6cx6JJLfC4o
         8PLao0v+GpNngK6fZp3kfLr+cKZ3gsLVZmEGGeo17KgijePOBjLygmpT4fL/M0qsLpBu
         UAy4m+G1GXdworYsEk8ci8X/kDtYaPlClBy0MiyzlmFeL/0wZXB33ghGd/AzZPjdNhDS
         4ElA==
X-Gm-Message-State: AOAM533Tm960gVLHwekqwhTJgIEt9sjltr0L2xt9K34KSMqLKDyTiDtD
        bq8TIfZDTOsvOBJ322W7015dKbUxzHwNch962m71gw==
X-Google-Smtp-Source: ABdhPJzq0nSKNv+G0bRObe+GhHdhDvWGn2nAF1dkUA8jM7Aw4lHTnJiFvi5gNjK7qw2+cfg4nC0gKMpi4KCora5Nb1M=
X-Received: by 2002:a67:2043:: with SMTP id g64mr241141vsg.25.1596163031857;
 Thu, 30 Jul 2020 19:37:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200730234916.2708735-1-jfwang@google.com>
In-Reply-To: <20200730234916.2708735-1-jfwang@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 30 Jul 2020 22:36:55 -0400
Message-ID: <CADVnQym04+QQU3WZ+qgSycZ_2TWJGwChN_jN1ZY_t65fxuWL-A@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: apply a floor of 1 for RTT samples from TCP timestamps
To:     Jianfeng Wang <jfwang@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kevin Yang <yyd@google.com>, Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 7:53 PM Jianfeng Wang <jfwang@google.com> wrote:
>
> For retransmitted packets, TCP needs to resort to using TCP timestamps
> for computing RTT samples. In the common case where the data and ACK
> fall in the same 1-millisecond interval, TCP senders with millisecond-
> granularity TCP timestamps compute a ca_rtt_us of 0. This ca_rtt_us
> of 0 propagates to rs->rtt_us.
>
> This value of 0 can cause performance problems for congestion control
> modules. For example, in BBR, the zero min_rtt sample can bring the
> min_rtt and BDP estimate down to 0, reduce snd_cwnd and result in a
> low throughput. It would be hard to mitigate this with filtering in
> the congestion control module, because the proper floor to apply would
> depend on the method of RTT sampling (using timestamp options or
> internally-saved transmission timestamps).
>
> This fix applies a floor of 1 for the RTT sample delta from TCP
> timestamps, so that seq_rtt_us, ca_rtt_us, and rs->rtt_us will be at
> least 1 * (USEC_PER_SEC / TCP_TS_HZ).
>
> Note that the receiver RTT computation in tcp_rcv_rtt_measure() and
> min_rtt computation in tcp_update_rtt_min() both already apply a floor
> of 1 timestamp tick, so this commit makes the code more consistent in
> avoiding this edge case of a value of 0.
>
> Signed-off-by: Jianfeng Wang <jfwang@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Kevin Yang <yyd@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> ---

One extra note on this patch: IMHO this is a bug fix that is worth
backporting to stable releases. Normally we would submit a patch like
this to the net branch, but we submitted this to the net-next branch
since Eric advised that this was the best approach, given how late it
is in the v5.8 development cycle.

Apologies that a note to this effect is not in the commit message itself.

best,
neal
