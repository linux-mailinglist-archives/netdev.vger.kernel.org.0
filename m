Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13C158E1C7
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiHIV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiHIV3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:29:16 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA53367CBA
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 14:29:13 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id s11so2852628qtx.6
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 14:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aX6ITTLIpOJpEyMZ6gr0hNentDS0pw4+7wwlwAWZwHM=;
        b=ERMwqJjl3QbRrikFFgWhJ6060Q9X/z19Ugm+GeYU/AxaFAe+/f0K3TAFvWcr5/zXq4
         iyPCPA1U2X2z0kM72KSbSYD4sVN4NXCRDeXGquu/XaaSgnPqim7z6m1nTRgVBWivgQLc
         lU0kB/dgTiZ5E7UxhQsLUDiYlI2u86Mtl/F3qHtLm/PrAdn9CgeUUkvVoqXFd0dEd0ei
         aS/lyBroPXbFRySYvq4jd2E3Ior1Fncs504eeoknaLq/snpuHPKk4twTS9tVVNioiKzJ
         OUKabOJpokem7pUwXHb6yFryB0aQJWAQVAif7NcWNHNP3xaSUhV6X7DEfgSgAgplAeOg
         rscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aX6ITTLIpOJpEyMZ6gr0hNentDS0pw4+7wwlwAWZwHM=;
        b=m+S8Jwf6HFUmt91xgTS1jNIUjluhfti/XCPsfmqfjyETYzqpyTDAogPl1hwGbuqY/O
         W6UKQmLDcyz7PkqVNOVyxec9fAkjB192vwWHEaT4Iqy3NcKKoQTV7SImPHOtS+I8BUkF
         9CvsEmkbnMLGEwf2OCsa6zqYrSjpTAO7zR6G20ST6XZ7elbyhNLyqzHniAINhehbZUtu
         QQvIT2gDzyIDs3/+ZJH542Yn9RSquAjdrCwbc9VE8rCdQdOt7OT+LRtOYVTk6pznTmss
         DVpGa5apErQEzRIxexewMofMXp+tFR3UnOmc5oNNxe8k+yz3trMK3uzu4RNDi5YjOXIi
         MWeA==
X-Gm-Message-State: ACgBeo1J9iI+dF5ytEsroipbqd6XeBW7MtcV9prBmph/4k8cvq9JjEVn
        BCLQM4UH+PHx8p6OXCYBknpF1on5WGHoGWDIc3wg8Q==
X-Google-Smtp-Source: AA6agR7Td891FXU6QZkjIokNG+scKTJM3TaU2KL/5YCRcl3nNvzwHRrarmqRe9y8V5HpNd8h+W4g50lRsyD/agMRfZ8=
X-Received: by 2002:a05:622a:1984:b0:342:ea3d:696e with SMTP id
 u4-20020a05622a198400b00342ea3d696emr15006739qtc.7.1660080552657; Tue, 09 Aug
 2022 14:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <1660034866-1844-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1660034866-1844-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 9 Aug 2022 17:28:56 -0400
Message-ID: <CADVnQykvc1oXP=jLeimcRuZRHoN+q7S9VPFky7otYdbEedom7w@mail.gmail.com>
Subject: Re: [PATCH] tcp: adjust rcvbuff according copied rate of user space
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 4:48 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> it is more reasonable to adjust rcvbuff by copied rate instead
> of copied buff len.
>
> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> ---

Thanks for sending out the patch. My sense is that this would need a
more detailed commit description describing the algorithm change, the
motivation for the change, and justifying the added complexity and
state by showing some meaningful performance test results that
demonstrate some improvement.

>  include/linux/tcp.h  |  1 +
>  net/ipv4/tcp_input.c | 16 +++++++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index a9fbe22..18e091c 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -410,6 +410,7 @@ struct tcp_sock {
>                 u32     space;
>                 u32     seq;
>                 u64     time;
> +               u32     prior_rate;
>         } rcvq_space;
>
>  /* TCP-specific MTU probe information. */
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index ab5f0ea..2bdf2a5 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -544,6 +544,7 @@ static void tcp_init_buffer_space(struct sock *sk)
>         tcp_mstamp_refresh(tp);
>         tp->rcvq_space.time = tp->tcp_mstamp;
>         tp->rcvq_space.seq = tp->copied_seq;
> +       tp->rcvq_space.prior_rate = 0;
>
>         maxwin = tcp_full_space(sk);
>
> @@ -701,6 +702,7 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
>  void tcp_rcv_space_adjust(struct sock *sk)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
> +       u64 pre_copied_rate, copied_rate;
>         u32 copied;
>         int time;
>
> @@ -713,7 +715,14 @@ void tcp_rcv_space_adjust(struct sock *sk)
>
>         /* Number of bytes copied to user in last RTT */
>         copied = tp->copied_seq - tp->rcvq_space.seq;
> -       if (copied <= tp->rcvq_space.space)
> +       copied_rate = copied * USEC_PER_SEC;
> +       do_div(copied_rate, time);
> +       pre_copied_rate = tp->rcvq_space.prior_rate;
> +       if (!tp->rcvq_space.prior_rate) {
> +               pre_copied_rate = tp->rcvq_space.space * USEC_PER_SEC;
> +               do_div(pre_copied_rate, time);
> +       }
> +       if (copied_rate <= pre_copied_rate || !pre_copied_rate)
>                 goto new_measure;
>
>         /* A bit of theory :
> @@ -736,8 +745,8 @@ void tcp_rcv_space_adjust(struct sock *sk)
>                 rcvwin = ((u64)copied << 1) + 16 * tp->advmss;
>
>                 /* Accommodate for sender rate increase (eg. slow start) */
> -               grow = rcvwin * (copied - tp->rcvq_space.space);
> -               do_div(grow, tp->rcvq_space.space);
> +               grow = rcvwin * (copied_rate - pre_copied_rate);
> +               do_div(grow, pre_copied_rate);
>                 rcvwin += (grow << 1);
>
>                 rcvmem = SKB_TRUESIZE(tp->advmss + MAX_TCP_HEADER);
> @@ -755,6 +764,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
>                 }
>         }
>         tp->rcvq_space.space = copied;
> +       tp->rcvq_space.prior_rate = pre_copied_rate;

Shouldn't that line be:

   tp->rcvq_space.prior_rate = copied_rate;

Otherwise, AFAICT the patch could preserve forever in
tp->rcvq_space.prior_rate the very first rate that was computed, since
the top of the patch does:

 +       pre_copied_rate = tp->rcvq_space.prior_rate;

and the bottom of the patch does:

 +       tp->rcvq_space.prior_rate = pre_copied_rate;

best regards,
neal
