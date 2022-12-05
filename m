Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE16431BD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiLETRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiLETQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:16:19 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3889A24F24
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:15:24 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id v19-20020a9d5a13000000b0066e82a3872dso5855257oth.5
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 11:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hcBdvoHg691jHOFKHwuWlLKsEYm+rxMZx93OjZXwe5g=;
        b=hBlBJfrmsbPdQQiHuel4S12lDHftQQFlIIh9l51SvHOmn+IT4DWVE3PyjsELBBPgCX
         7QK/FzPd4uyI4+XJYU5TyKiGlgU38oJ7UdAIF+mCObn5NeiyeJnp4nwYhNNLqpKndNGp
         t6Xa1rpEQRZosvFz0dTWFRFPLQ5FeqvJ5ryE3426aPw22nMQT3rd+cZkWr1Re4EtgYfx
         6ac0Ya5WmRBNnsEMiG6DFialJzFHtKjrA66VVqJoFdEfgDYos2YbjKL/+1us82C6V6Yf
         ImSQ+6I9r7EPbfmVZdXGCIXIPL0rg+NW5FMWU3VmBuIAhUK6R9t3LyFNZcqHAZ+F4mrg
         YJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcBdvoHg691jHOFKHwuWlLKsEYm+rxMZx93OjZXwe5g=;
        b=Z67s8V+ecLirTqg6uE+WRfEDscsCi1r7PvqdkM6ufgJ8vsDhVHhmtyDUW5baKKbaIQ
         sgj+MoT+Jiiblcrqu5Fu0PYcWyRKl2LxUp9PW7P9Hfl5m//JX73Q5ACN41VY1oIdkKob
         A4UYPmZohcXE3sXmrXihe0N0oLck9739QS4eIP5KH+5gqyhlVJPlxqZZ1dtpu0GO7trE
         6uYoA0Q2T0ugiy4YwqKRZweCNsUGHcP+9aHymAys0u8HNlfkZRWgGSUWACBUZBehHC+0
         CKJTgXYyKH0Sajo9qE1PDkzBhL7qtY1v04pshbEYGP08JuVGrqm+vU7o0o9JrijrCCVW
         tMww==
X-Gm-Message-State: ANoB5pmihBZ2pL48xajX2XtQl5jj8VttJBbRkC0u2O4j9fJ2hDRXhb00
        ilHiWNweOqSZr8HYWKqHfb8E80fZJT3dsHcGOCt9lw==
X-Google-Smtp-Source: AA0mqf7kIQXgNqtTfeXQfN7nvM9fWkY35cyBMym4tSBF0+yVcnPcC7aqn4LYFbP49/1b6z4EMq7qGv+E4zEWrnNaAlU=
X-Received: by 2002:a05:6830:618b:b0:66d:a939:9baf with SMTP id
 cb11-20020a056830618b00b0066da9399bafmr32834257otb.161.1670267723338; Mon, 05
 Dec 2022 11:15:23 -0800 (PST)
MIME-Version: 1.0
References: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
In-Reply-To: <Y44xdN3zH4f+BZCD@zwp-5820-Tower>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 5 Dec 2022 14:15:06 -0500
Message-ID: <CADVnQykvAWHFOec_=DyU9GMLppK6mpeK-GqUVbktJffj1XA5rQ@mail.gmail.com>
Subject: Re: [RFC PATCH] tcp: correct srtt and mdev_us calculation
To:     Weiping Zhang <zhangweiping@didiglobal.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, zwp10758@gmail.com
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

On Mon, Dec 5, 2022 at 1:02 PM Weiping Zhang
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

Please note that this analysis and this test program do not take
account of the fact that srtt in the Linux kernel is maintained in a
form where it is shifted left by 3 bits, to maintain a 3-bit
fractional part. That is why at first glance it would seem there is a
missing multiplication of the new sample by 1/8. By not shifting the
new sample when it is added to srtt, the new sample is *implicitly*
multiplied by 1/8.

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

AFAICT this proposed patch does not change the behavior of the code
but merely expresses the same operations with slightly different
syntax. Am I missing something?  :-)

thanks,
neal
