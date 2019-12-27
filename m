Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A19512B545
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL0Oqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:46:44 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35372 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0Oqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 09:46:44 -0500
Received: by mail-ot1-f65.google.com with SMTP id k16so32036712otb.2
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 06:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhXrzCvZQ65KKdhpOcWs6LewzCl6qEKiputIxaA+kgU=;
        b=bqF++DNKgj3AzdKr9v7npNXP6WZkKXI602I7QRL2H2oG/7da12QrBkI2lzvDxpG3Vr
         ngpybwttQ5lEQKFg8hq2oRkdvEO6uQ0g9vzreUisXGGNKiq7Pi72U1cB3DSLPcB6hmpy
         SuSeYVjsU6YiXVC7udTI+42Dh8UvOH78ia+FQMH+qSsXH51IakI45YQKx39G+kC05uGh
         u2dmF8kQ4nbE2UYQFE5ZQG5LbAQTwyF1hBkKZRRBbrB3aj+PTYYEOse6q/uC8LYCAgqa
         Bq5ovocqoI4XeMa8ExgdzMmdPlae46Ik0jaVyRNZu5/mTwqdSkgVS+Zqs4z5Dy3m8gPn
         5Hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhXrzCvZQ65KKdhpOcWs6LewzCl6qEKiputIxaA+kgU=;
        b=eLCmD1VS6YEIuTl9Yl0nmeKZjbqKSm7vQgmdNpAGIBA4ThldWJ3sNL7qDiuQSj780x
         bJMx1BvBjVC/oOcE4IsRNP85DJY2Xb4V62+zd1AZWJHHvt2CcJZCW8uJNVztOv5IcL00
         irIs3r6afgdRUBJi6hOJ7cKP084OmzoG97PTRlEeYYr768KHVST8WQo5j0iTrvALH7Kf
         rJXj5i4SyB9sXjHuDQmbdi7jyognol7tBHMlRbdX3lSU46sAM6hZklZ58Xp+SzTEkzUL
         rFx8DsNnEs+cVkIhIfYy6kk5Yl2iFducmyyQ7BIOgL66947NL7SjJaRWpZ9I32XOsSzo
         pb/g==
X-Gm-Message-State: APjAAAV3L05nCc9J/SFHyDnqLeSj/03e2qeQ3dxsCdL/HZlf8+7aoWDv
        /WObDmUtbKjy5ePIn7cuLdqTqzDfIgbdiEgjEjucTQ==
X-Google-Smtp-Source: APXvYqweUN90JfWRxSARAM+142y3SsKSVVW4Iw16nno/Qh+XwMWD/EBEDna+nzxnfUolCsm8aEG/NUfAPayMT5t4VV8=
X-Received: by 2002:a9d:4c94:: with SMTP id m20mr54153054otf.341.1577458002839;
 Fri, 27 Dec 2019 06:46:42 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-4-edumazet@google.com>
In-Reply-To: <20191223202754.127546-4-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 Dec 2019 09:46:26 -0500
Message-ID: <CADVnQynXwSoG4mjAnpy_LrLpR0RGur2ZjayNMM-TX7vGo6BxuA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/5] tcp_cubic: switch bictcp_clock() to usec resolution
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Current 1ms clock feeds ca->round_start, ca->delay_min,
> ca->last_ack.
>
> This is quite problematic for data-center flows, where delay_min
> is way below 1 ms.
>
> This means Hystart Train detection triggers every time jiffies value
> is updated, since "((s32)(now - ca->round_start) > ca->delay_min >> 4)"
> expression becomes true.
>
> This kind of random behavior can be solved by reusing the existing
> usec timestamp that TCP keeps in tp->tcp_mstamp
...
> @@ -438,7 +431,7 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
>         if (ca->epoch_start && (s32)(tcp_jiffies32 - ca->epoch_start) < HZ)
>                 return;
>
> -       delay = (sample->rtt_us << 3) / USEC_PER_MSEC;
> +       delay = sample->rtt_us;

It seems there is a bug in this patch: it changes the code to not
shift the RTT samples left by 3 bits, and adjusts the
HYSTART_ACK_TRAIN code path to expect the new behavior, but does not
change the HYSTART_DELAY code path to expect the new behavior, so the
HYSTART_DELAY code path is still shifting right by 3 bits, when it
should not... the HYSTART_DELAY remains like this at the end of the
patch series:

        if (hystart_detect & HYSTART_DELAY) {
...
                        if (ca->curr_rtt > ca->delay_min +
                            HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {

AFAICT the patch also should have:

-                            HYSTART_DELAY_THRESH(ca->delay_min >> 3)) {
+                           HYSTART_DELAY_THRESH(ca->delay_min)) {

Otherwise this patch looks great to me.

best,
neal
