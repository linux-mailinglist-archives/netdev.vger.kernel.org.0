Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5100F643072
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiLEScy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiLEScf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:32:35 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23A45FE4
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:27:51 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3c21d6e2f3aso126917727b3.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 10:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jgHTNoclBo7XcdqsDEYBgw3XYE3gmdvuSaq1OLPx4sE=;
        b=ZTO1JWwXrLTIK80q8gpuay0KF+eOQ16dO4jaVAHpn/eCgsmHppAj6y1963h6YFwFL8
         k5os3RBS5B7axNC1jmt60h3YY9b7sl/z62b7pEFyJzsg4Vgk61KcrQDRqNS9uxxb18qb
         kr7CHNvHbJ1u+ahh/iezDjZgSZjEBFM4EyyNGu7a2IHpIRfAO8LwcnM2qDOEahj9FyJa
         Ffa0JoCcg3V8RkN2SI0y0STpP54HdaBy+wbPs0P7oR731XY928aGf/wxEERNXavgjO7I
         GBYvp609E4K/RgA+6p2ZTgwH5epn30YemO0NGPZhjEZPrqxfb5QkubtVQjWk3R1ZI6dv
         mNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgHTNoclBo7XcdqsDEYBgw3XYE3gmdvuSaq1OLPx4sE=;
        b=ZNRBNluQ285RzJE1+F+L8f77x/i6gR0YvaFA4XisaT9pUWFKj4kuEoKQyBvDMeKYwu
         iUDaC90MkvwmdnkKJzh/X5y7mqK0gVUqjEPS3X/1KRuLFqYwvPzcgcUSZ6g49JJrYXsY
         Z11wIf9v5t/Y/6+kfyhFU3eNmay+4fcnp3gKZR5so+F4AfHIU8K/Gp4xs+MkDLYFsKlv
         zYK7+bcjVxyfuAqCxPYG+xZXs00z6IlsxjDZr+p5cneO67+vpXPe32afUDOZbtQSOEHN
         FazHJWK1fRr5NJQOTxVHIgPsAVJRax/S5OYBtSgFYUM4UBRJ2+sj1IdQ+3CzTHS6trOw
         ptXw==
X-Gm-Message-State: ANoB5pnGWletLuDPhAgmGMGjiSHJ8mHUtuifKcaWXJclaQo7UahwPooL
        Alwj+yDlF1Z7Gb+3Sb86aWUni0Jo3oFh1RIVQJc9Aw==
X-Google-Smtp-Source: AA0mqf7eGlChvtKv5NiRNv+t1QAbY6+gQ6kPTdKa7x4EHmB7mE7vxaEDm07A4DfGV/nfu4rFS/9ldj4qJT1wd9JAWd0=
X-Received: by 2002:a81:1e44:0:b0:370:7a9a:564 with SMTP id
 e65-20020a811e44000000b003707a9a0564mr13360302ywe.278.1670264844243; Mon, 05
 Dec 2022 10:27:24 -0800 (PST)
MIME-Version: 1.0
References: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
In-Reply-To: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 19:27:12 +0100
Message-ID: <CANn89iKF5+8=-jDm3j=A65egYt=BY-er7YzJ32NcWPFKYv9Ckw@mail.gmail.com>
Subject: Re: [RFC PATCH] tcp: correct srtt and mdev_us calculation
To:     Weiping Zhang <zhangweiping@didiglobal.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        zwp10758@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 5, 2022 at 6:59 PM Weiping Zhang
<zhangweiping@didiglobal.com> wrote:
>
> From the comments we can see that, rtt = 7/8 rtt + 1/8 new,
> but there is an mistake,
>
> m -= (srtt >> 3);
> srtt += m;
>
> explain:
> m -= (srtt >> 3); //use t stands for new m
> t = m - srtt/8;
>
> srtt = srtt + t
> = srtt + m - srtt/8
> = srtt 7/8 + m
>
> Test code:
>
>  #include<stdio.h>
>
>  #define u32 unsigned int
>
> static void test_old(u32 srtt, long mrtt_us)
> {
>         long m = mrtt_us;
>         u32 old = srtt;
>
>         m -= (srtt >> 3);
>         srtt += m;
>
>         printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__,  old, mrtt_us, srtt);
> }
>
> static void test_new(u32 srtt, long mrtt_us)
> {
>         long m = mrtt_us;
>         u32 old = srtt;
>
>         m = ((m - srtt) >> 3);
>         srtt += m;
>
>         printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__,  old, mrtt_us, srtt);
> }
>
> int main(int argc, char **argv)
> {
>         u32 srtt = 100;
>         long mrtt_us = 90;
>
>         test_old(srtt, mrtt_us);
>         test_new(srtt, mrtt_us);
>
>         return 0;
> }
>
> ./a.out
> test_old old_srtt: 100 mrtt_us: 90 new_srtt: 178
> test_new old_srtt: 100 mrtt_us: 90 new_srtt: 98
>
> Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
> ---
>  net/ipv4/tcp_input.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 0640453fce54..0242bb31e1ce 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -848,7 +848,7 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
>          * that VJ failed to avoid. 8)
>          */
>         if (srtt != 0) {
> -               m -= (srtt >> 3);       /* m is now error in rtt est */
> +               m = (m - srtt >> 3);    /* m is now error in rtt est */
>                 srtt += m;              /* rtt = 7/8 rtt + 1/8 new */
>                 if (m < 0) {
>                         m = -m;         /* m is now abs(error) */
> @@ -864,7 +864,7 @@ static void tcp_rtt_estimator(struct sock *sk, long mrtt_us)
>                         if (m > 0)
>                                 m >>= 3;
>                 } else {
> -                       m -= (tp->mdev_us >> 2);   /* similar update on mdev */
> +                       m = (m - tp->mdev_us >> 2);   /* similar update on mdev */
>                 }
>                 tp->mdev_us += m;               /* mdev = 3/4 mdev + 1/4 new */
>                 if (tp->mdev_us > tp->mdev_max_us) {
> --
> 2.34.1
>

Sorry, this makes no sense to me.
