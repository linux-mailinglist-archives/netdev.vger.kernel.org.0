Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1F45018F3
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbiDNQo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240202AbiDNQlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:41:36 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E46A94EC
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:11:53 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id i14so4305929qvk.13
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RKJjwZqakebRNMvdJVatBDHDCzigtGzmWkeGzrW1kyM=;
        b=nkcownW5Zj+q/KNdXF7DQLwOkSgBQpaFnSLRs3DWCVy0Ot3LkpR64gABBhz1+8UNsP
         f9h0vt775mcDmPhglxOT1CQwrI/ZBUWTQ82fB8GxO1IniB8Qjt91eccEUAJkjsK/AxQY
         NKlOzXJbj8qy+fSyhrsVZp6rvsRQerndI0iW/Xny8s1gkmZs0rinxtdZE8SnMHo29Wfv
         lE7GZZrNqCxUqUdibvgeQ3Jm0EootgBGXLPv4bs7TIScKj4pyekrg+0oNzcsybvEPJUU
         6QCpM3ko+jBP8iw394SVK+tNjZVq5iz/cLgUJ8UUHOGu8GZDbFxps1wSUvEVd3ILvSyG
         fjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RKJjwZqakebRNMvdJVatBDHDCzigtGzmWkeGzrW1kyM=;
        b=KwmrQ9ANEx2LX4rvKtHb7qOdMUtslmO6rzd9akFmTZlYa/xVJxoOQx8tp56ejiJVZX
         6c+BKHhLqOAGvd3OryqndlgiOjm40IcTxqix5JrskfKAuTCz3rn7Z+m/N+KmV93/aZHg
         6aMEe/FKeNVdkor8wtCOEBBs/R/BezYl+dsH7Z07wol7uSePQlBgl+Dd2OZt1NXsFWAz
         u9zVRZNvuJaG4nxLpexxvVY6gxDYZsI6L0KLlT3FfmxLfji6+rGAsCOL2lUo8xq3aYsT
         NH0cPI55eLnYMLPf0BQfozhT6bIWAAs9N6osGIgM73CB7N7boCRSBhB0uURfpmuZmjlm
         giQQ==
X-Gm-Message-State: AOAM530KHkc8HNnYP/vPKzI47jfJTxzOacjnV99qCFx6yS2VM3ykB6zu
        khFMS3ta4uvx7FDougrcM42gMEwYs/dgh/KNxIHP2kXQYWctZQ==
X-Google-Smtp-Source: ABdhPJwJxX5v2Zqgh15I+hStW8yxJLwTAobBmevWaTt23CLdbGjbGHynNW6qZBshlcnxzlCrddFcW7o4c60PQvO8IbM=
X-Received: by 2002:ad4:4351:0:b0:444:46fe:6cf with SMTP id
 q17-20020ad44351000000b0044446fe06cfmr13631615qvs.47.1649952712458; Thu, 14
 Apr 2022 09:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <1649847244-5738-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1649847244-5738-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 14 Apr 2022 12:11:36 -0400
Message-ID: <CADVnQymBgfzsyqdnm81bGiA6j=Kb96Ekz0XcYiUR2p-+tLbO6g@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: ensure to use the most recently sent skb
 when filling the rate sample
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org
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

On Wed, Apr 13, 2022 at 6:54 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> If an ACK (s)acks multiple skbs, we favor the information
> from the most recently sent skb by choosing the skb with
> the highest prior_delivered count.
> But prior_delivered may be equal, because tp->delivered only
> changes when receiving, which requires further comparison of
> skb timestamp.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_rate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
> index 617b818..ad893ad 100644
> --- a/net/ipv4/tcp_rate.c
> +++ b/net/ipv4/tcp_rate.c
> @@ -86,7 +86,9 @@ void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
>                 return;
>
>         if (!rs->prior_delivered ||
> -           after(scb->tx.delivered, rs->prior_delivered)) {
> +           after(scb->tx.delivered, rs->prior_delivered) ||
> +           (scb->tx.delivered == rs->prior_delivered &&
> +            tcp_skb_timestamp_us(skb) > tp->first_tx_mstamp)) {
>                 rs->prior_delivered_ce  = scb->tx.delivered_ce;
>                 rs->prior_delivered  = scb->tx.delivered;
>                 rs->prior_mstamp     = scb->tx.delivered_mstamp;
> --

Thank you for posting this patch! I agree there is a bug there, and
your patch is an improvement. However, I think this patch is not a
complete solution, since it does not handle the case where there are
multiple skbs with the tcp_skb_timestamp_us() (which can happen if a
outgoing buffered TSO/GSO skb is later split into multiple skbs with
the same timestamp).

RACK has to deal with the same question "which skb was sent first?",
and already has a solution in tcp_rack_sent_after(). I suggest we
share code between RACK and tcp_rate_skb_delivered() to make this
check. This might involve making a copy of tcp_rack_sent_after() in
include/net/tcp.h, naming the .h copy to tcp_skb_sent_after(), and
reworking this logic to save and use the sequence number and timestamp
so that it can use the new tcp_skb_sent_after() helper. After this fix
propagates to net-next we could later then change RACK to use the new
tcp_skb_sent_after() function, so we have a single helper used in two
places.

If you want to post a version of this patch that uses some approach
like that, IMHO that would be welcome. If you do not have cycles, I am
happy to post one when I get a moment.

thanks,
neal
