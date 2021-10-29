Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BF43FD9E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 15:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhJ2N5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 09:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhJ2N5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 09:57:03 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF91C061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 06:54:26 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id h20so9293949qko.13
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 06:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rs3HwEFfU6Z7vHqEji5AukCQpCLRjDuimkf+/klAhKw=;
        b=TVZfA7vrFEB4mNvRxaTXCXkYWCi2a1qg1+yUMupA9iJQhvAF07VWssqGay4ERWsv0w
         ZPkOnsqr03ft7qJkSztUwsi9SBh49BgjP8gehXxaMBvmNgfZb4av72TxXFbCq0nv0rFe
         3urpz7ptSjZUBpMVayDvHv97u92PBZn30iLYFgnMMX5MlLtSrbdNLyBASM8z/aymqil1
         VdlMxzpwVqYEpOTAmlCEM+LypOCFRXN0pNzq4ea/VfJ2nhauby71ykWVQ0+x3o6Q+hzr
         8twyMGwdrNRwHYxMgGTlqwAFgS0DN29l5yCN7a/pqTR+pmjB+jfNysSI+AKNTEtQF0W4
         QPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rs3HwEFfU6Z7vHqEji5AukCQpCLRjDuimkf+/klAhKw=;
        b=mu9hVI1JdRScdGrvanqLaydXsW/MzDkpJ/+MXlZ596jvfGLvr+J857I1AlL86CAGTU
         Q6Ok6eEnRsL81kUkIvEFD4OFwaHqgmekE6EdBo5JLA93aEn5D2aHy6w8nXe9giV0EtY9
         hcDHBkTX4S/VG0NHHZ4kHCBbhJASzp+XXit97wUJJ1RH45NsPZwBNFFew3bnid1ehurh
         nWk26c5Vw7wB67nLRmRwoTPWjzUit25UCjMbbhZhsrn6Om/L7eLd2PBkwBq1v3kNiQOL
         VNBJNYXriLWmXlckWufppLMOlzxTFbyOttH/1dhHj1ZH8Xr5Gy4uBJEa+t/+FrtgIZhT
         DO+g==
X-Gm-Message-State: AOAM5339U4gTWs/tQA+03Z1Pw2CBccFiXEuhDXjL3Fn4Xw/Lh/P7ervX
        Z0DRt/6tjsWZHLfArbMLYiHuX4h1l32HppDvxn6HIA==
X-Google-Smtp-Source: ABdhPJyKainBW6Wt8LBvlor1PpBhtlQ/5O53RXt6OLpPNE0HojJBa+CuvS3oV/5oT722BHBURoOC3XFG3HnuA25PqtY=
X-Received: by 2002:a05:620a:1031:: with SMTP id a17mr9035018qkk.339.1635515665715;
 Fri, 29 Oct 2021 06:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191500.47377-1-asadsa@ifi.uio.no>
In-Reply-To: <20211028191500.47377-1-asadsa@ifi.uio.no>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 29 Oct 2021 09:54:09 -0400
Message-ID: <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
Subject: Re: [PATCH net-next] fq_codel: avoid under-utilization with
 ce_threshold at low link rates
To:     Asad Sajjad Ahmed <asadsa@ifi.uio.no>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        Bob Briscoe <research@bobbriscoe.net>,
        Olga Albisser <olga@albisser.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 3:15 PM Asad Sajjad Ahmed <asadsa@ifi.uio.no> wrote:
>
> Commit "fq_codel: generalise ce_threshold marking for subset of traffic"
> [1] enables ce_threshold to be used in the Internet, not just in data
> centres.
>
> Because ce_threshold is in time units, it can cause poor utilization at
> low link rates when it represents <1 packet.
> E.g., if link rate <12Mb/s ce_threshold=1ms is <1500B packet.
>
> So, suppress ECN marking unless the backlog is also > 1 MTU.
>
> A similar patch to [1] was tested on an earlier kernel, and a similar
> one-packet check prevented poor utilization at low link rates [2].
>
> [1] commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset of traffic")
>
> [2] See right hand column of plots at the end of:
> https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf
>
> Signed-off-by: Asad Sajjad Ahmed <asadsa@ifi.uio.no>
> Signed-off-by: Olga Albisser <olga@albisser.org>
> ---
>  include/net/codel_impl.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> index 137d40d8cbeb..4e3e8473e776 100644
> --- a/include/net/codel_impl.h
> +++ b/include/net/codel_impl.h
> @@ -248,7 +248,8 @@ static struct sk_buff *codel_dequeue(void *ctx,
>                                                     vars->rec_inv_sqrt);
>         }
>  end:
> -       if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
> +       if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
> +           *backlog > params->mtu) {
>                 bool set_ce = true;
>
>                 if (params->ce_threshold_mask) {
> --

Sounds like a good idea, and looks good to me.

Acked-by: Neal Cardwell <ncardwell@google.com>

Eric, what do you think?

neal
