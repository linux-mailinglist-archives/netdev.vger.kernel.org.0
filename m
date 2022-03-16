Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F3C4DAA42
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 07:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351610AbiCPGEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 02:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353747AbiCPGEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 02:04:10 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E161D80;
        Tue, 15 Mar 2022 23:02:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id p15so1962884ejc.7;
        Tue, 15 Mar 2022 23:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=At97fA0HmKfWfV8mwVNkglbXerPcXccwlj7t+RjkhDI=;
        b=Ri99XcB8MavGs4BcqLM8NYg/fbh6nsMzXFCUVObxdBlv8wvb8CNP1FQF7RnOx+g/vc
         5Cove3Kl6cYuDn1s9bpx7ULhTEGvdMJZibCAoCSzePOePFjEV/WZOlq1w2PMbcUWCPfN
         76EL8ppxkeSlZA+d6gJ77IcygoSCLLygz+ifuBIZmoZd+rAOR1sCng3FqlseX+C8+LPz
         dVLG1af69yP2+GyeMBMWIg3YkxedVLwqJT4jW0h+s0Seey+bsuwm4V27ayC8aYdBAzrS
         98p4zbIbgdnE2CesVllweZ5DYEOIFNKYnkGousEYD7kZgw7sG68P705MspE0c3GvWyTN
         p1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=At97fA0HmKfWfV8mwVNkglbXerPcXccwlj7t+RjkhDI=;
        b=X5F4li04XzaqnDcWUXJdcLCLr5t8Ox1WeQwq6STbI55vj27UqpFCO0pYcojf4We0sx
         DF/IAP/mOiUN5YJugGblsBP9BUsY9QeL1Nh2TQFAUQ2frUnqBJl0HkKQlIiahwlLMnRo
         W4NNS/JedIMqXI3eELBUi+5HIQFUsp+enLkG8QiGpADZQG0axDkGjh+xzytbhH02K/FC
         clwpwtQhcYZhMUvkxjCPJz3MRT8ouVWqLtoi/BSWylUmtN7VmNpIDhMNKKdgGNWrMMWA
         pbEvQM/qVwaAD+q1OMVG+lmhzarjHfrCxwUScczxmIIIYyM5Si2DBQ0LpcmKGrehDNAs
         igRw==
X-Gm-Message-State: AOAM532gNslCcZF3nOKB6BwODDnrNgk2EXm80Gvlb6wdmkDFM8roWIvT
        H/bGWeLzTx4qktsluM+F4iLHp8DLPsR7q/xrEyY=
X-Google-Smtp-Source: ABdhPJzONdUb/QZQW4LZbMP3hqXpsftHqyD2wTz1/CdxfoE7sPbmt6tQbce52e+RlGtXWRFqzJoFzVWfX/4tbSXuMRA=
X-Received: by 2002:a17:907:2d29:b0:6db:2b1f:333a with SMTP id
 gs41-20020a1709072d2900b006db2b1f333amr25583477ejc.704.1647410574646; Tue, 15
 Mar 2022 23:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220316024606.689731-1-imagedong@tencent.com> <20220316024606.689731-3-imagedong@tencent.com>
In-Reply-To: <20220316024606.689731-3-imagedong@tencent.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Mar 2022 14:02:42 +0800
Message-ID: <CADxym3aLgg+ALDHmPx6Zonznn2MYqiU+feP-UeQ10WO5i72wVA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: icmp: introduce __ping_queue_rcv_skb()
 to report drop reasons
To:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 10:47 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> In order to avoid to change the return value of ping_queue_rcv_skb(),
> introduce the function __ping_queue_rcv_skb(), which is able to report
> the reasons of skb drop as its return value, as Paolo suggested.
>
> Meanwhile, make ping_queue_rcv_skb() a simple call to
> __ping_queue_rcv_skb().
>
> The kfree_skb() and sock_queue_rcv_skb() used in ping_queue_rcv_skb()
> are replaced with kfree_skb_reason() and sock_queue_rcv_skb_reason()
> now.
>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Biao Jiang <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v2:
> - introduce __ping_queue_rcv_skb() instead of change the return value
>   of ping_queue_rcv_skb()
> ---
>  net/ipv4/ping.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 3ee947557b88..138eeed7727b 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -934,16 +934,24 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
>  }
>  EXPORT_SYMBOL_GPL(ping_recvmsg);
>
> -int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> +static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
> +                                         struct sk_buff *skb)

Oops, there is an alignment problem here...I'll send a new version.

>  {
> +       enum skb_drop_reason reason;
> +
>         pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
>                  inet_sk(sk), inet_sk(sk)->inet_num, skb);
> -       if (sock_queue_rcv_skb(sk, skb) < 0) {
> -               kfree_skb(skb);
> +       if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
> +               kfree_skb_reason(skb, reason);
>                 pr_debug("ping_queue_rcv_skb -> failed\n");
> -               return -1;
> +               return reason;
>         }
> -       return 0;
> +       return SKB_NOT_DROPPED_YET;
> +}
> +
> +int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +       return __ping_queue_rcv_skb(sk, skb) ?: -1;
>  }
>  EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
>
> --
> 2.35.1
>
