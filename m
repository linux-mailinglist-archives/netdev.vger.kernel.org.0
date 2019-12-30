Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8670D12D066
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 14:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfL3NlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 08:41:02 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43187 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfL3NlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 08:41:02 -0500
Received: by mail-yw1-f65.google.com with SMTP id v126so14053539ywc.10
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 05:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IGzPYKUVu3c/nY8lDHX/WpdNFa7rqqFtVUQ1GhvvgzI=;
        b=HMOl0NfUe59KNPwN3rupWGM8NTgeAGnLbF8B+75zNeLMinYwPYyBGeTiOYeEfBVG8U
         8bsaODv1BEVilvRyBhNKYAnUXCFYZzo/l1I+PHjKoQEex2+6LFdna+PwZT9Fweb4KlLs
         KtJQMtABuZ6+SnNhJgkazDVzycJHeln59myv+yix7QHE8Du9dGXmylFtJEW0y4ok4TfY
         TZ93Hat0NzifmKpnoP6A1XRxxrxzs2cTNi5Ha6jz9qGWQctBkTQ4n2Mxay5/sIMim2+B
         bRaSX3R9XCtrQw7qoowBaiN7ma3GLoYhhQp7RaT/87JgHX4n0VkIFd/JNGtdfu4I4yjT
         Cvog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IGzPYKUVu3c/nY8lDHX/WpdNFa7rqqFtVUQ1GhvvgzI=;
        b=kE6Z8x2qfkxV6+/uW8U/sVNTatdL6Y9x3n3c/rRhMsFpICALJ7jlR4MVCF3PmsCyLh
         59aXfCYrm2Hg6cOCc0RuxXIzkBPjxC7kt6FBmemMQWLybEDQxB9Z/f/7hZj34nGzPrNW
         yPPoX5Td5lq/AUTlNcFCiYoX2X5dfXatcZfvqP/uwnRSMyY232XAALoSv502hPPhUa1h
         y2L/XUiS4VdpRKvQTUhfYhjpdPZ0pg16+lpjy7fc/Uwy+n6IueVUSQZ2p/RMefO2z9DA
         wogLMiStnhReNDgQ1BBuKdboh+smmOYFhJX5HEBR5Aq8p9jiefLb+3ebrJfnQLim0uhI
         M1cA==
X-Gm-Message-State: APjAAAUY+WcYLd+jsAzznODfSofYsoW/LRufVkyy2gRB1xfwCHWVLp6A
        an0froEsVML0BbM2dzfwPbolwGzmWwy8PdyjXtCSMQ==
X-Google-Smtp-Source: APXvYqx6bOTVgBVKKmvRBKRsSSejeEIXGEv/OtIei+OyNv+ywEt+Y+J2w4HSX1ofnaDDNnritsQe2ng9xWOZbupLlWQ=
X-Received: by 2002:a0d:dd56:: with SMTP id g83mr47756883ywe.174.1577713260439;
 Mon, 30 Dec 2019 05:41:00 -0800 (PST)
MIME-Version: 1.0
References: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1577699681-14748-1-git-send-email-yangpc@wangsu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Dec 2019 05:40:49 -0800
Message-ID: <CANn89iLq6Tt5TZj9SXxK02y=3f35kRSsR2zGBL=1QmFmJBpvXQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 30, 2019 at 1:55 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> When we receive a D-SACK, where the sequence number satisfies:
>         undo_marker <= start_seq < end_seq <= prior_snd_una
> we consider this is a valid D-SACK and tcp_is_sackblock_valid()
> returns true, then this D-SACK is discarded as "old stuff",
> but the variable first_sack_index is not marked as negative
> in tcp_sacktag_write_queue().
>
> If this D-SACK also carries a SACK that needs to be processed
> (for example, the previous SACK segment was lost),

What do you mean by ' previous sack segment was lost'  ?

 this SACK
> will be treated as a D-SACK in the following processing of
> tcp_sacktag_write_queue(), which will eventually lead to
> incorrect updates of undo_retrans and reordering.
>
> Fixes: fd6dad616d4f ("[TCP]: Earlier SACK block verification & simplify access to them")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_input.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 88b987c..0238b55 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1727,8 +1727,11 @@ static int tcp_sack_cache_ok(const struct tcp_sock *tp, const struct tcp_sack_bl
>                 }
>
>                 /* Ignore very old stuff early */
> -               if (!after(sp[used_sacks].end_seq, prior_snd_una))
> +               if (!after(sp[used_sacks].end_seq, prior_snd_una)) {
> +                       if (i == 0)
> +                               first_sack_index = -1;
>                         continue;
> +               }
>
>                 used_sacks++;
>         }


Hi Pengcheng Yang

This corner case deserves a packetdrill test so that we understand the
issue, can you provide one ?

Thanks.
