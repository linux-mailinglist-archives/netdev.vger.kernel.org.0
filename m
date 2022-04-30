Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9DD5159C8
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382032AbiD3CYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358207AbiD3CX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:23:56 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62B036142
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:20:35 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 1so6561929qvs.8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gm4yl9TNon9vtXXWOEMEtXNR3v8j+EyxhbpGXuJBtn8=;
        b=Mj82C2Ryz0RG6e0In/INQ+5zoAvBsjx27dqTsf+sw2UcFpVEWGKpO1kiHQX0DSYccl
         mJPGBwH/48gIQgv+VBZw9sRLjk0ZJqsaUwAxMD7tKyGQJyme8PhMGHC7ElGkzx63Rt5A
         QYWSCiUoNxDkQGFPpyqDG1A/1JV4uXPGBO6J7zkQVx/7xPaPJfKBKZxXjZpJA3EW+gjK
         MdU3ZBHha+Eb+DhFA6Y5GD/OJ/68r7ytvMvvwUtPvwpPIE8Z6CEFuvgKaOjiimRzRYjy
         TcKjA3l4h37Yz6NJhHx1HwmH8qtGcZ1kp1R55eNjPi/gFKCOnynkdj3EE37mMNyVbSoW
         V6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gm4yl9TNon9vtXXWOEMEtXNR3v8j+EyxhbpGXuJBtn8=;
        b=3Z2f9/OK8ePFaII4KXCsGKcYBJoljn8FoEXczWhLVEMMgutxSDd7JVLHZ6/q8J5n/D
         nCxHdM/6g/TI8YNa6fIWT4xB45h0FervjtIHXf/TB+Khsr2uH2XNB/q5MSMAHLIil3Na
         KHLEqpD1VKvwHiL+ttWOes0Tj9lBZEhpBxUKMXgsKr1WrvQvo6Ol6ybeD+tN1mJEpkKH
         dJ534zTxVmDEM4cZ/uCFydANdsVxbfnpCNU2AJJ+CjOKV29So6HlKc/LAgpkYvWewgL2
         VgDsPcvb5QtOCsk+2J2415EUQ5Bp1NvE3/KvUfl8p2sMELJ1RIvWFU6ehei8Oq7ufa28
         pKVg==
X-Gm-Message-State: AOAM530iWqxlzIdAI2qgdeCL1RPcUXQL7A2YfTEmo692mbkUWaZU5TPw
        5QS/GfaiX8AOZDXguX6PFfgD2iYGmTI9u1myXqXVww==
X-Google-Smtp-Source: ABdhPJx7rUtbNkwHy5EWBsV5xf2IQlVwo4hcQD02BrtW47n0cOSlO07SAVCE/SRx/UZdUkkptm1qviNo8wq30fW/HpE=
X-Received: by 2002:a05:6214:27c5:b0:458:12c2:ebea with SMTP id
 ge5-20020a05621427c500b0045812c2ebeamr1821200qvb.62.1651285234443; Fri, 29
 Apr 2022 19:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220430011523.3004693-1-eric.dumazet@gmail.com>
In-Reply-To: <20220430011523.3004693-1-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 29 Apr 2022 22:20:17 -0400
Message-ID: <CADVnQynFW-6MQX2DYQ8SgZ3NLVc7yLZbDa9_+fKMv_tB5cPqsg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: drop skb dst in tcp_rcv_established()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
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

On Fri, Apr 29, 2022 at 9:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> In commit f84af32cbca7 ("net: ip_queue_rcv_skb() helper")
> I dropped the skb dst in tcp_data_queue().
>
> This only dealt with so-called TCP input slow path.
>
> When fast path is taken, tcp_rcv_established() calls
> tcp_queue_rcv() while skb still has a dst.
>
> This was mostly fine, because most dsts at this point
> are not refcounted (thanks to early demux)
>
> However, TCP packets sent over loopback have refcounted dst.
>
> Then commit 68822bdf76f1 ("net: generalize skb freeing
> deferral to per-cpu lists") came and had the effect
> of delaying skb freeing for an arbitrary time.
>
> If during this time the involved netns is dismantled, cleanup_net()
> frees the struct net with embedded net->ipv6.ip6_dst_ops.
>
> Then when eventually dst_destroy_rcu() is called,
> if (dst->ops->destroy) ... triggers an use-after-free.
>
> It is not clear if ip6_route_net_exit() lacks a rcu_barrier()
> as syzbot reported similar issues before the blamed commit.
>
> ( https://groups.google.com/g/syzkaller-bugs/c/CofzW4eeA9A/m/009WjumTAAAJ )
>
> Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/tcp_input.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cc3de8dc57970c97316ad1591cac0ca5f1a24c47..97cfcd85f84e6f873c3e60c388e6c27628451a7d 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5928,6 +5928,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
>                         NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPHITS);
>
>                         /* Bulk data transfer: receiver */
> +                       skb_dst_drop(skb);
>                         __skb_pull(skb, tcp_header_len);
>                         eaten = tcp_queue_rcv(sk, skb, &fragstolen);
>
> --

Nice catch. Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
