Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB061242F
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiJ2Pa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJ2PaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:30:25 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9462057DD1
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:30:23 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r3so9204689yba.5
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8dYAr+qr1R6Xo9zoSFNEOc560F/LbrOVb8a+d7kwqp4=;
        b=SFBCqSFcPyEKhaC6bkuFqJYnUd9DED1eyM0qEKYKOdozhtCgd966FWyCAL95L0D80h
         50sNgHFjWZZw0Yq12HL9aG2X8zwmhWvBIZJdN7jY9P8/4PHIFaSwZ3dT3pLwa2TYYTb0
         Sae9dgnu11OQwrC3KqFpHDK5AFeZk0ilcz8TIhucXVVf75orNE4l0S4SfiIZK93wnh82
         vuUA8W5fJT1WZuWsWujX8kjO2m5ksrQ2hpxUeEeYTBmWdM6TJXz8KrLxwnbIsFcObwcN
         ehnw/G0cLjpCe8k/EeeNAZ7Nh4YfHUn9JB3dVrZF4pZHkbQQIKm5tVYh90J6Dpa1kbDn
         TKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dYAr+qr1R6Xo9zoSFNEOc560F/LbrOVb8a+d7kwqp4=;
        b=uGwtDhj4lUzzHPnPaMyA76d6s/KGcxhhZ7icpKQgy7LfbDFtrdCWpj0wW4SypzQtbC
         ZMZfonAdj1xPIvllYbsi1uY3gQO9kR5kwbFXwU8v95GXPOGDTSzlYiupXErccx8j0bN6
         BFSxAPbTKioJ/vb2gtS2t2wh/sD4xnw+qMeFcim8+HeENYDDeNiuHomtaDtWYiCYkIl+
         nn0pjgkFatgKazvGmpiqUooN8gL+wmJ2SLX4peVUiSBALmXrxE+uH+Dls9e/fzdWN3W/
         jxdXlBd82MLGGbWYDQRUvGJp0mUAIJA0KDmPwb6HUq1tRZp1xvecnh4t5zGfdH9961zu
         xmPA==
X-Gm-Message-State: ACrzQf0C0IsEBA+N9fl/PApnicm5JqcXAT751InJrTylA9bR/7rg2SBy
        qJ2gjJ6UxMVeEKzPo8qYNQGBWjJ2LnoCwb7BHTJE9w==
X-Google-Smtp-Source: AMsMyM73h7ZbDekt1hGMupZsp2EZn7x4uoWxgNh4bzc3kG6F/X45BUXmzYgl+V85DoMiyRh+L1t/mCN+hZqE7itClSE=
X-Received: by 2002:a25:aa2c:0:b0:6cc:16c2:5385 with SMTP id
 s41-20020a25aa2c000000b006cc16c25385mr4201849ybi.55.1667057422552; Sat, 29
 Oct 2022 08:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221029130957.1292060-1-imagedong@tencent.com> <20221029130957.1292060-2-imagedong@tencent.com>
In-Reply-To: <20221029130957.1292060-2-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 29 Oct 2022 08:30:11 -0700
Message-ID: <CANn89iK60VLmy3Y_7TZC-pXMZCho=W=uKPV2uf2tUmLdzJ1oFg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/9] net: skb: introduce try_kfree_skb()
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        kafai@fb.com, asml.silence@gmail.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Sat, Oct 29, 2022 at 6:11 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> In order to simply the code, introduce try_kfree_skb(), which allow
> SKB_NOT_DROPPED_YET to be passed. When the reason is SKB_NOT_DROPPED_YET,
> consume_skb() will be called to free the skb normally. Otherwise,
> kfree_skb_reason() will be called.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 59c9fd55699d..f722accc054e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1236,6 +1236,15 @@ static inline void consume_skb(struct sk_buff *skb)
>  }
>  #endif
>
> +static inline void try_kfree_skb(struct sk_buff *skb,
> +                                enum skb_drop_reason reason)
> +{
> +       if (reason != SKB_NOT_DROPPED_YET)
> +               kfree_skb_reason(skb, reason);
> +       else
> +               consume_skb(skb);
> +}
> +

My proposal looks better IMO

https://patchwork.kernel.org/project/netdevbpf/patch/20221028133043.2312984-2-edumazet@google.com/
