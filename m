Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A88D12AFA7
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfLZXX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:23:58 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40841 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:23:58 -0500
Received: by mail-ot1-f65.google.com with SMTP id w21so26325450otj.7
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 15:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B9pSxCrx4iSXxkLrPV1OK2pG5D6zX1D1MSTVLjkn3e0=;
        b=SepOt7X6SKMh+mSXHhVW+mwMixlEMOZo2MFwzOHGuOPNK4ib56LVkoCpESvfnWz38/
         2DEdCqblaoyzWeCfUN8YAB316nLtHDT4VX8fTin/nhFKGzNQR6V/YOCew7L3nJjy6OpQ
         sN24mz6V7OAs8rpjjSoKmRMlBswi3rgd3y0sVYZWcN/EMwK0A8zf/jsVxT8lBIOXRh+w
         A7EXFv4ejqab4DXcw5vwuyQe+oJ0aPAe+EIlwDDtD/Us//JviWrS4NHZ7YIZxoFoDclo
         4I60l83u+AecWBQhrUWmEj+6qxYIeGfgURZgmygPVpeSrnxJnyWf1o/iSvEUpF+UUDGZ
         oBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B9pSxCrx4iSXxkLrPV1OK2pG5D6zX1D1MSTVLjkn3e0=;
        b=B3RkY0tBtiWhk7TuneThsd4JSPr5vf5uPQrcBHjmIgKvV74t9ztepQTAlFDbKCYUz4
         eOV3wAzzU44M/w7P89boqWaKtH+vB79Gf2VvDhkjKgzkazg++LOi0FqUW9OIrYevcY+i
         d7UmvqyWAGnWAJY1IJOXeGq/CrpnlJRXQOCyVSR9lM/Qh/rZSuNoS5+yzIkm+MnEDJbm
         HzTGkeJgq9ulfUnDaOq2gTjhP7w58B7FGD78thbRd15H5e4O/FZRPsu8zw4iuc5h+5Ho
         tpsxAIIWhy1tSZpFbolJhPue31twqjeMHbdwZxGTMpdEIQ4KMEnKT6Fefv5JABdEAUx9
         Hahg==
X-Gm-Message-State: APjAAAUa9HtXVZaMAR4iqvbYtsycPn4NhaDuHi4iozKD1MrFP8D4lhzT
        vnJW6VdohaJlH6lFs25Xe/ByEfulWd7o5Tj8HKVPtQ==
X-Google-Smtp-Source: APXvYqzQPwddhRDdoA+thoNyS8z8rxe3Hiix3bM26ACx/nf5vZksgNaQRjAREFTOalHl0d18WGD+tcyYIpiaK8vFkbo=
X-Received: by 2002:a9d:624e:: with SMTP id i14mr54406390otk.371.1577402637340;
 Thu, 26 Dec 2019 15:23:57 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-2-edumazet@google.com>
In-Reply-To: <20191223202754.127546-2-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 26 Dec 2019 18:23:41 -0500
Message-ID: <CADVnQyknyvPfjgRXrWpG2_4A4yVPiwbtA68Om9PuiRO9ymfJjw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/5] tcp_cubic: optimize hystart_update()
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
> We do not care which bit in ca->found is set.
>
> We avoid accessing hystart and hystart_detect unless really needed,
> possibly avoiding one cache line miss.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Thanks, good idea.

> @@ -450,7 +447,7 @@ static void bictcp_acked(struct sock *sk, const struct ack_sample *sample)
>                 ca->delay_min = delay;
>
>         /* hystart triggers when cwnd is larger than some threshold */
> -       if (hystart && tcp_in_slow_start(tp) &&
> +       if (!ca->found && hystart && tcp_in_slow_start(tp) &&
>             tp->snd_cwnd >= hystart_low_window)
>                 hystart_update(sk, delay);
>  }

For the many connections that exit the initial slow start due to loss
or ECN marks, it seems ca->found would always be 0, so such
connections will be at risk for taking a cache miss to fetch
'hystart'. WDYT about further reordering the logic to avoid that risk
for such connections, e.g.:

  -       if (hystart && tcp_in_slow_start(tp) &&
  +       if (!ca->found && tcp_in_slow_start(tp) && hystart &&

neal
