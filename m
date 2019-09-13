Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6741B28EF
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 01:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390597AbfIMXgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 19:36:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36458 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388993AbfIMXgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 19:36:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so33566444wrd.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 16:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3sYGtiABdKyuigJnLR2bKk5LSRWtHvWkbuf2UEj+7w=;
        b=Mp5QAfd9qhFIRd+jMW4VT8al6vtu42vi6DdxcVBeskc19OjUmkJEnikP4bRKf6mqDS
         Bt7AjNrJIcg5379oyH5mFNNxXS1rzWvvDK4j0vCc7PeaEcd7rlIkxEgbAcaw10jVlljA
         /qYB1wCLT56MKv4DEwIuWxZ7cswD8lZbVX774vcoQQTU3JIOGnnuTENE1uaLHr7q+DYD
         hMLaxYMIxDsbRUdQX2me7IEzLFFMGVe3jdvO+DjvKeNlZtHVnNqQL8YQGTmUi5dUh5AY
         SYSLpDNIFncM13Lwpk3NLAb/UlfpbdoQu1jO96n6a3uetK3ClL1O+Tq2LOTPYTKt55p+
         LQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3sYGtiABdKyuigJnLR2bKk5LSRWtHvWkbuf2UEj+7w=;
        b=RL1mGP6NfInedtWFSVdFGCccTkNfLLd3gbMJyE3omg8aRQEUa1nUY5cnVpaUKVOOb7
         83FZPVDvZJmzN+Rg+2DHKxDfMpIWav8stakQsUt575RDgFQZzxMaGXYSVsrq0Dh7snmF
         SinNQpPh+3k4eNnSQ/nck5aCcO/OMxDlO8l7aNsJZgFW/Zlt20xIovCymd9KX8/ICJjs
         npteoAQbVzEBKNJ5o7ZLObMA8n8BsR2C6w0Lbu9jcSgeaj7saYTQzsdPE+ll2i03q7je
         Vr/mK2IdBdQnmbLidh/KKEng8HlqMQ5ur8qWt6HKs4srN8KCn/zYfMZj+oJqdY0eAlv/
         Xy5w==
X-Gm-Message-State: APjAAAV3e9z87vRjFFGxaexqz65c1M2e8G3BGZQXsYX+J4bA/bzWeuOG
        oxU1rC52I1osB9cUUe45gSrjK6mspvbZfZTHxvgvMg==
X-Google-Smtp-Source: APXvYqzey8GIAz4kwfrTgKOuFAa47m0oXB3UEr6NEmscIF7Uw6aTnETsvOnkQHOdt5bCPIqz61MXdQvQ/L+CpHs7+Aw=
X-Received: by 2002:adf:f284:: with SMTP id k4mr5641045wro.294.1568417803195;
 Fri, 13 Sep 2019 16:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190913232332.44036-1-tph@fb.com> <20190913232332.44036-2-tph@fb.com>
In-Reply-To: <20190913232332.44036-2-tph@fb.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 13 Sep 2019 16:36:04 -0700
Message-ID: <CAK6E8=fWgjRjpkL=Mvp5OtqD-mEQ_p_0PhZ+JBEcif1bqo1-Xw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Thomas Higdon <tph@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 4:23 PM Thomas Higdon <tph@fb.com> wrote:
>
> Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
> performance problems --
> > (1) Usually when we're diagnosing TCP performance problems, we do so
> > from the sender, since the sender makes most of the
> > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > From the sender-side the thing that would be most useful is to see
> > tp->snd_wnd, the receive window that the receiver has advertised to
> > the sender.
>
> This serves the purpose of adding an additional __u32 to avoid the
> would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---
Acked-by: Yuchung Cheng <ycheng@google.com>

> changes since v4:
>  - clarify comment
>  include/uapi/linux/tcp.h | 4 ++++
>  net/ipv4/tcp.c           | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 20237987ccc8..81e697978e8b 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -272,6 +272,10 @@ struct tcp_info {
>         __u32   tcpi_reord_seen;     /* reordering events seen */
>
>         __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */
> +
> +       __u32   tcpi_snd_wnd;        /* peer's advertised receive window after
> +                                     * scaling (bytes)
> +                                     */
>  };
>
>  /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 4cf58208270e..79c325a07ba5 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3297,6 +3297,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
>         info->tcpi_dsack_dups = tp->dsack_dups;
>         info->tcpi_reord_seen = tp->reord_seen;
>         info->tcpi_rcv_ooopack = tp->rcv_ooopack;
> +       info->tcpi_snd_wnd = tp->snd_wnd;
>         unlock_sock_fast(sk, slow);
>  }
>  EXPORT_SYMBOL_GPL(tcp_get_info);
> --
> 2.17.1
>
