Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149B712B5C7
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 17:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfL0QIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 11:08:49 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44862 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfL0QIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 11:08:48 -0500
Received: by mail-oi1-f196.google.com with SMTP id d62so9567460oia.11
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 08:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RB95nY4q8CYDJKoS9GOqjprLy6mrtZtjov0PtpqffPA=;
        b=BRgFc3TT54/gDLyyol6G7EmUVQcH8/30DK4Svgno99nes4v0eqFxy/C1E9/m0BoHCD
         ri5D66JShdHolnZ44kHJmGqHfmYC5gRa0fb9EIg2EzpEG+LpFturtjJhLMNm5pvAJGEt
         JSWTsHVfxJvg2PJM0VSnsl5Rl2G8+/WblVAsKOpDHdvcABEjp0UhYUjvBoQO7TIIQtGV
         jNAvBm8UxyCPMswQtCawj3ia+kJi2H0kBo0GKZhXkrTEr2pIGrnzeZnkY4brPbkiMl3a
         s6B0/7nyyzQc+JUwZT2gakuj0yPR+JH0XJlWExiOFe8EpHplvNdH8x9PU4L3JH90iFq8
         NrZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RB95nY4q8CYDJKoS9GOqjprLy6mrtZtjov0PtpqffPA=;
        b=or3c9zFO826aVtBCHwfMKgLEfpfMwDk4/cR7mA5CwNy65zlwJ15BSVOEyLHKDYiVD3
         ZIkpu4bH+bYsPlkNigkI373rsaPEySLX33vx4Gg4p8J46GGz0faQDGeTaTZFFEczrlP6
         X5HnNal2hzuJGzlhzgiTnENBs7kvU8IVA9frWxc2q3DLooELEL96WABIj+x+Pz+mxm5W
         0Mj2RMlGodyR+e0tyDrMSTMXdqSQ9oMDLKKJiudAV8taOu33GT4yDdA7/JKkG0q5Sn4S
         e+FGUVoY+hEHxsfqQD9PAVdNp979EmoqYQhh+/xwB44f16+C+JBXtu0iVnN99y+kQY9b
         XORA==
X-Gm-Message-State: APjAAAUe1Z6tOysYfSRxecFq39bh1JRdwELcsH9TK5TGGdoCa9zVVOZf
        rSWQb1q7ZPkCh6ZeBOm8NbpQCuk3tJP93xa5cS2lFQ==
X-Google-Smtp-Source: APXvYqyQVrNXmh/w4xe//294bOqR1DwHxSYPs4xIRyjeUEeWcFYJfxbE3t3MpgQrnGHKY2x8C543OC1Twf+7LYxjjQM=
X-Received: by 2002:aca:dfd5:: with SMTP id w204mr3808948oig.95.1577462927616;
 Fri, 27 Dec 2019 08:08:47 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-4-edumazet@google.com>
In-Reply-To: <20191223202754.127546-4-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 Dec 2019 11:08:31 -0500
Message-ID: <CADVnQy=xpsFCcMbbDnYwSjTd3CCY-auG_VMyV_L9v_iQsRYaiQ@mail.gmail.com>
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
>
> Note that a followup patch will tweak things a bit, because
> during slow start, GRO aggregation on receivers naturally
> increases the RTT as TSO packets gradually come to ~64KB size.
>
> To recap, right after this patch CUBIC Hystart train detection
> is more aggressive, since short RTT flows might exit slow start at
> cwnd = 20, instead of being possibly unbounded.
>
> Following patch will address this problem.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks!
neal
