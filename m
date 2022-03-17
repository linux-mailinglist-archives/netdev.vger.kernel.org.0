Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539AD4DCB97
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiCQQmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiCQQms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:42:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FE41FE562
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:41:31 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j17so8232604wrc.0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FtyCFHKTjJ/cNZ6M8Zwv+bkgifY/oMoUc9tuSAPLstY=;
        b=bgHw1JWDP886pJjwfWWnWEmzEy27aSDH/7p9I6Lc5G4MdB1UyDopJKG9FKc86s+ovh
         oDd9RdVGOwfxZxtsQgHDtGijl/JJ/UT6Bi/oyNi3pDQ3bV6qcj43a6bG3cIv0wEzwmst
         TTj/U8XOIH3z17FrhO7kNTNu7GR8RpUvmWKay/0fOS/WQe83O6mnc+0si9lx1+O9Zb5L
         2QL3h6Pb4LOJX3SU+nfCx2iASXnuNwjpLxex7NuOmq8Tni7m7we0WweBTXgjdUlezMVg
         U9J9Uwl0D9tXYnHZ7xSDdG3GJ8awJls2H5jXfTM/vJa8CDdfFCnH8G/DMn9/9mmyvOux
         wKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FtyCFHKTjJ/cNZ6M8Zwv+bkgifY/oMoUc9tuSAPLstY=;
        b=ub5NnV1tzVHlADnj++6bp87OuqeYSEmGYQKAm9ckuP0xCe8tVYstkzlp2AgMKZkp/k
         7Lq4U+AVKmmliPlSf3BE0NBCACp/++d577uUg6ruMIyfHw9b6eyeKrgbmJrC+T6+oHnA
         1KSRSfGfs1ZIvacz1Px2MSBi8vWvYaO6SoIp6U2+PguVOmHVvJLblxvoor9GQmHI8d4t
         lZPqomWNIQv/6XFZVihW3RlF34OiNZGTn4oHjPOQC6kVy67OwlOPrF64iOiosVGgHVPt
         ADcOSKvvVrju5T+nZk2t2itEbuF15qQ0ykH3RaHKZve4rarmP6lBCwigIE+bnasLAab6
         KJKQ==
X-Gm-Message-State: AOAM531wGvaVnGSWyQIGecll4PyhbdxnNw1le/ho1gdwLaCWwclWOpxJ
        orpYCMbGBzgmgE22fWOjV4uETPmsTcBn14HH0P/5S+GyLGk=
X-Google-Smtp-Source: ABdhPJz9Qm3dGbfRwThau3HEn7qjgEfAWEmtjFnJL3HuXA6cWzVIZ1IIDXa4l69Zh9gSM34e4KhijU8n3lJ/IjnJUk8=
X-Received: by 2002:a05:6000:1a89:b0:203:706f:7c67 with SMTP id
 f9-20020a0560001a8900b00203706f7c67mr4821329wry.471.1647535289965; Thu, 17
 Mar 2022 09:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220316235908.1246615-1-kuba@kernel.org>
In-Reply-To: <20220316235908.1246615-1-kuba@kernel.org>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Thu, 17 Mar 2022 09:40:53 -0700
Message-ID: <CAK6E8=cGVkB4=yZMQ5eOBHRzNSyrO7ZwqkRvjVAuspTJOJTW=Q@mail.gmail.com>
Subject: Re: [RFC net] tcp: ensure PMTU updates are processed during fastopen
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, weiwan@google.com,
        netdev@vger.kernel.org, ntspring@fb.com
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

On Wed, Mar 16, 2022 at 4:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> tp->rx_opt.mss_clamp is not populated, yet, during TFO send so we
> rise it to the local MSS. tp->mss_cache is not updated, however:
>
> tcp_v6_connect():
>   tp->rx_opt.mss_clamp = IPV6_MIN_MTU - headers;
>   tcp_connect():
>      tcp_connect_init():
>        tp->mss_cache = min(mtu, tp->rx_opt.mss_clamp)
>      tcp_send_syn_data():
>        tp->rx_opt.mss_clamp = tp->advmss
>
> After recent fixes to ICMPv6 PTB handling we started dropping
> PMTU updates higher than tp->mss_cache. Because of the stale
> tp->mss_cache value PMTU updates during TFO are always dropped.
>
> Thanks to Wei for helping zero in on the problem and the fix!
>
> Fixes: c7bb4b89033b ("ipv6: tcp: drop silly ICMPv6 packet too big messages")
> Reported-by: Andre Nash <alnash@fb.com>
> Reported-by: Neil Spring <ntspring@fb.com>
> Reviewed-by: Wei Wang <weiwan@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>

Thanks for the fix.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv4/tcp_output.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 5079832af5c1..257780f93305 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3719,6 +3719,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
>   */
>  static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
>  {
> +       struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct tcp_fastopen_request *fo = tp->fastopen_req;
>         int space, err = 0;
> @@ -3733,8 +3734,10 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
>          * private TCP options. The cost is reduced data space in SYN :(
>          */
>         tp->rx_opt.mss_clamp = tcp_mss_clamp(tp, tp->rx_opt.mss_clamp);
> +       /* Sync mss_cache after updating the mss_clamp */
> +       tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
>
> -       space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
> +       space = __tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) -
>                 MAX_TCP_OPTION_SPACE;
>
>         space = min_t(size_t, space, fo->size);
> --
> 2.34.1
>
