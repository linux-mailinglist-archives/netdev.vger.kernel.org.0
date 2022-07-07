Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D473B56A1D2
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 14:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiGGMRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 08:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbiGGMRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 08:17:37 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80C3205DC
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 05:17:36 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id g4so32187484ybg.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 05:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uwig/AHabCZBic+c+FvsMRVZZoiP33d9oouIS8HHdQs=;
        b=rzqLKFWBqKJo6pvg6JS9BPeCvkVwPG3NCG4A6MwTvKn+Tbmx4K1zF24wkcjCZ2Swrz
         1Zop5IppFxinFymXZRKQf5enZNhzroHfXGleeAhWglfHN5mXlw6RSZlYtFJNvP/6Elbm
         iyHEVX/qtQpAdtHuoTEGmty+Gt8Ph9Li1ZgmYwGY8S+aipsNX8DqiLSBgu06WDr72Kbf
         4/gUJX5BRy7SgAd3oV1n/cK4CuZ09Vv9P+e0oUY4qMMRJenmKBvW7GkcxNlLnGLHEK5m
         NuJHWs6m3IL9yOacrVH0xCILzN6N/6tqmBNICz82Pqz6S0WpUqPq49s00fprMD09Jhhu
         DH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uwig/AHabCZBic+c+FvsMRVZZoiP33d9oouIS8HHdQs=;
        b=xUlLaW4DDagikWhdGLxZIysS0fReRClaZnKfMRL6hCnjWlWMTYU/ORyA3nN/lY9D6c
         Feb3EDWEAxATEV0kvbaMQtbLSPMcXVDw47lrAXeGzXs7uBtw8uvnUqMJyzerEyIFScgN
         8n+4kybpq6PRwc7pG8dCP5xvcDj1p9asG9HGJAsON3xRq2D1wWPPtj14Z8ddERLluDes
         mxHc+ABxP0bhkgpEn292kGUICfnk5atrWnaJtSBaaUBf9yCSEijlP2IwnMDiHAesbAGg
         LaYTie83LbVwddtNzZuHkPE8Fhq/mWC2XYZbvCBN2/uVRO6ZWAbUKmfW5cfN6x8Orrmt
         9MwA==
X-Gm-Message-State: AJIora/mRkJ1/oyrBfdV69CiAH1zSQ6yMz/PuAAswYQrMH+SLYy+TVkr
        boxkTw7W8vsbYtCXb5EJLN85mwmq1nRfyRG8YDzUUHPhDAm3tQ==
X-Google-Smtp-Source: AGRyM1uU3FrpMuRe1ck63ydqQRuhuXjWSz5CFE/OOGDWmwniq/LkTlbCkQRlgm+BKVaUoyrgFDZxeX9GBEPBcz/nn8g=
X-Received: by 2002:a25:d741:0:b0:66e:5fc1:3001 with SMTP id
 o62-20020a25d741000000b0066e5fc13001mr18998721ybg.231.1657196255528; Thu, 07
 Jul 2022 05:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <1657189155-38222-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1657189155-38222-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jul 2022 14:17:24 +0200
Message-ID: <CANn89iLW5sbPkyySPYCGzAOcTFy24dL4T9xcN7cQ8Nf0MqCX_Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: make retransmitted SKB fit into the send window
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Thu, Jul 7, 2022 at 12:50 PM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> From: liyonglong <liyonglong@chinatelecom.cn>
>
> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
> in send window, it will cause retransmit more than send window data.

This changelog is confusing. I understand the check is already done ?

I think it would be better to explain how a receiver can retract its window,
even if TCP RFCs specifically forbid this.

>
> Signed-off-by: liyonglong <liyonglong@chinatelecom.cn>

This probably needs a Fixes: tag, even if targeting net-next (which I
prefer because this kind of patch is risky)


> ---
>  net/ipv4/tcp_output.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 18c913a..3530d1f 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3176,7 +3176,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>             TCP_SKB_CB(skb)->seq != tp->snd_una)
>                 return -EAGAIN;
>
> -       len = cur_mss * segs;
> +       len = min_t(int, tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq, cur_mss * segs);

I think it is unfortunate to not align len to a multiple of cur_mss,
if possible.

Also this might break so-called zero window probes.
We might need to send some payload, to discover if the ACK the
receiver sent us to re-open its window was lost.


>         if (skb->len > len) {

What happens if len == 0 ?



>                 if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
>                                  cur_mss, GFP_ATOMIC))
> @@ -3190,7 +3190,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>                 diff -= tcp_skb_pcount(skb);
>                 if (diff)
>                         tcp_adjust_pcount(sk, skb, diff);
> -               if (skb->len < cur_mss)
> +               if (skb->len < cur_mss && len >= cur_mss)

This seems to be weak.

I suggest to do it properly in  tcp_retrans_try_collapse() because
there is already a related test there :

if (after(TCP_SKB_CB(skb)->end_seq, tcp_wnd_end(tp)))
      break;

But this seems not done properly.

>                         tcp_retrans_try_collapse(sk, skb, cur_mss);
>         }
>
> --
> 1.8.3.1
>
