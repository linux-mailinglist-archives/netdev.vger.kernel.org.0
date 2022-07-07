Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BD6569BE1
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiGGHln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiGGHlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:41:40 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885DC13E39
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:41:39 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-31c86fe1dddso114622197b3.1
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 00:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9eyyTqtIIkulv9gQfR4CtcRsXRhWw/yH02kMqdRM/do=;
        b=gfaombR7LiK3khQhkRxL3yOZDsNumwGmw/97FGNW8CXTh/lelia1l8ZXUv0b9BMvot
         SmCBti21PoHYJObRF3tJcrmMRPQN0qc245uM1RclpR+BtclBHVDtKTmFBQeXAU03kkE1
         xVK0sq32XtBe7igK8cXodJDAw0eLSrQnFtIk3n/KKCvrj8Jro5KbvBVzug8X9w13hN5P
         Zhfe5I5sKfst/X8g7d4sDRY13+TrjEl9VWQMxyeGJ5FujUw7i4fA5jCQh5WRqz2tt+zb
         rrvdwuhla/35w5BfD6Kz98JrFFdW5U/tWONKqHGmYL64eqwzxURgy8RJcvkM8EEPJr0r
         aUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9eyyTqtIIkulv9gQfR4CtcRsXRhWw/yH02kMqdRM/do=;
        b=lWQY4r0+B2giM/mLmPqQP3DUuiUn9O3AkPgAlHJsym5SlM2puNG09J7ZEIBOJbStx9
         crUMoz65uYTGtXnUZwi5wksrxZd+fwiZ99bspswus2G2ERji9mx3yur2D1s61FJQCj0i
         /Inh5t7r3uyJ4CopwH+YagJfp0xcRwqti3Ows0eLlCqo7w9/w0DXzan5tKOAAytQUg0x
         x2EBLxy4x1EkNHVey9kSuu5mcqKG/ICa7BevHs+fW0tQZz/3tw7m8hyVYYcZeXjiKnOf
         Gv3Jk7vBMvh30C+TGpx0ZU4WXPqZXv1MlcysT+0LH7O1ckHlpH3+Biwb7/NIX6hcD7lr
         a8EA==
X-Gm-Message-State: AJIora9tAZoPN9Je1lzq8XkGjdyioMRcaPPyLNO7Q0xB6IolojuFSMsf
        qQiftjL2nP2TYotTdMQSj9sC/fgJmDacjRAFHmJvSg==
X-Google-Smtp-Source: AGRyM1sl834btKCxGlLAL+ZSW/HXLduHzuuMztwjLx1S/OoaENMFb9RfqVnexf7j0s4hP78bzEwQCTwToiPbHHOd1kc=
X-Received: by 2002:a81:4994:0:b0:31c:d036:d0b1 with SMTP id
 w142-20020a814994000000b0031cd036d0b1mr13999275ywa.255.1657179698498; Thu, 07
 Jul 2022 00:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220706063243.2782818-1-ssewook@gmail.com> <20220707054008.3471371-1-ssewook@gmail.com>
In-Reply-To: <20220707054008.3471371-1-ssewook@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jul 2022 09:41:27 +0200
Message-ID: <CANn89iKih_MW7xfJWxAd3Sui+jzeS7R-ePDbzB4mBCYHDGA6OQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: Find dst with sk's xfrm policy not ctl_sk
To:     Sewook Seo <ssewook@gmail.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
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

On Thu, Jul 7, 2022 at 7:41 AM Sewook Seo <ssewook@gmail.com> wrote:
>
> From: sewookseo <sewookseo@google.com>
>
> If we set XFRM security policy by calling setsockopt with option
> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> struct. However tcp_v6_send_response doesn't look up dst_entry with the
> actual socket but looks up with tcp control socket. This may cause a
> problem that a RST packet is sent without ESP encryption & peer's TCP
> socket can't receive it.
> This patch will make the function look up dest_entry with actual socket,
> if the socket has XFRM policy(sock_policy), so that the TCP response
> packet via this function can be encrypted, & aligned on the encrypted
> TCP socket.
>


> +++ b/net/ipv6/tcp_ipv6.c
> @@ -952,7 +952,10 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>          * Underlying function will use this to retrieve the network
>          * namespace
>          */
> -       dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
> +       if (sk && sk->sk_state != TCP_TIME_WAIT)
> +               dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL); /*sk's xfrm_policy can be referred.*/
> +       else
> +               dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);

Please use net instead of sock_net(ctl_sk) for consistency.

Also, if a RST is sent on behalf of a timewait socket, it will be sent
without ESP encryption.

This calls for not creating timewait sockets in the first place from
TCP established sockets
which were using XFRM.

(timewait is really best effort, I am not sure we want to extend their
size and complexity
for XFRM sake)
