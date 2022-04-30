Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2D5159E9
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376634AbiD3CvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiD3CvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:51:22 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4295D0815
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:48:01 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id m20so18496050ejj.10
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXznhmzqeQVMniJSLymEHuowqPj6xKPsPEyEFNQbj9Y=;
        b=Qb+BVOyqmoA6Bv3F+gBBFS+7D+DDb4R1vWzA/gFOFV534ZoemTMW8ZyEwUotW8gQOd
         zd6RXee6ay+wIdgopluXFXOZrrKmeYxXWfLR/7ioJ1au1IEMzuSELH+i+EenSdFte9p7
         99aL3wRwptH0ztwN4IB76g3K6zYTZ8t5XYTPuc2FJlKH/0IhtYjcQTmirOOQ8eEZ8qhP
         xwi759U6EvXmGg3BBOT1Sj8T7Ocx0hGBfQjmHG0G0AvB0HnXMrcUQMNyItwaqPeZWVAg
         6Kb7uewqmyCl0o3JhBBYGnkod6wG6cWd5XR2ZVJC01GwmRVx8zEhjlRc3d9KTP2vl1pG
         cDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXznhmzqeQVMniJSLymEHuowqPj6xKPsPEyEFNQbj9Y=;
        b=uWmj7HYB1zNx4tnG9Bp0D649LZhPyXhIJbxCuX6NqDZ57jptV/jnyG2g4eW99cC30l
         V5bPmSRkcnJxJDPOC1VuUzX95gomM35Hy3cswLhA6d4lOc+taiXSZq8W07KDRwXhdvoe
         myv4ZJFzAnwhjSCfJY6g8SmSyigVyJJ+CXHNxsmya4Isge3qcul4jZ98cdrSzKTgmYHA
         Q2oiOsLo6G743AYykQpYL/WZ/kAjxtb/V+IHv1wAsVrxnDlIqLfmqxTw+P192tFtkbiE
         ydNRTt3dQ43luLgWItbnKXxwmdoSo2V1yloVwLSCIWuINr2G7z/QsxWNOO9E5tfcO9gs
         0E+Q==
X-Gm-Message-State: AOAM533mym+vVOUJ2ShBT6Jjtlg5bA8rP+20eNTy0lilecUF7Cmn27NX
        oQ+TICfW6jUiCJPeOagp9WBaHc0jejdny5HEo1rjSw==
X-Google-Smtp-Source: ABdhPJwEnhqtml5gNZxI1dJC+qkckkIaDCxXjayBdFx9nvV578KNKmCSq+FicPFYi/T2Iu1WsasQkW2GGC6HNiajhG4=
X-Received: by 2002:a17:907:3f8f:b0:6f3:d4a0:e80c with SMTP id
 hr15-20020a1709073f8f00b006f3d4a0e80cmr1992931ejc.709.1651286879835; Fri, 29
 Apr 2022 19:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220430011523.3004693-1-eric.dumazet@gmail.com> <CADVnQynFW-6MQX2DYQ8SgZ3NLVc7yLZbDa9_+fKMv_tB5cPqsg@mail.gmail.com>
In-Reply-To: <CADVnQynFW-6MQX2DYQ8SgZ3NLVc7yLZbDa9_+fKMv_tB5cPqsg@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 29 Apr 2022 22:47:23 -0400
Message-ID: <CACSApvZqxfzzkHiMZ=r5+uZurPnF0Rty2zb8R9eh9Hyr-y7waQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: drop skb dst in tcp_rcv_established()
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
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

On Fri, Apr 29, 2022 at 10:20 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Apr 29, 2022 at 9:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > In commit f84af32cbca7 ("net: ip_queue_rcv_skb() helper")
> > I dropped the skb dst in tcp_data_queue().
> >
> > This only dealt with so-called TCP input slow path.
> >
> > When fast path is taken, tcp_rcv_established() calls
> > tcp_queue_rcv() while skb still has a dst.
> >
> > This was mostly fine, because most dsts at this point
> > are not refcounted (thanks to early demux)
> >
> > However, TCP packets sent over loopback have refcounted dst.
> >
> > Then commit 68822bdf76f1 ("net: generalize skb freeing
> > deferral to per-cpu lists") came and had the effect
> > of delaying skb freeing for an arbitrary time.
> >
> > If during this time the involved netns is dismantled, cleanup_net()
> > frees the struct net with embedded net->ipv6.ip6_dst_ops.
> >
> > Then when eventually dst_destroy_rcu() is called,
> > if (dst->ops->destroy) ... triggers an use-after-free.
> >
> > It is not clear if ip6_route_net_exit() lacks a rcu_barrier()
> > as syzbot reported similar issues before the blamed commit.
> >
> > ( https://groups.google.com/g/syzkaller-bugs/c/CofzW4eeA9A/m/009WjumTAAAJ )
> >
> > Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/ipv4/tcp_input.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index cc3de8dc57970c97316ad1591cac0ca5f1a24c47..97cfcd85f84e6f873c3e60c388e6c27628451a7d 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5928,6 +5928,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
> >                         NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPHITS);
> >
> >                         /* Bulk data transfer: receiver */
> > +                       skb_dst_drop(skb);
> >                         __skb_pull(skb, tcp_header_len);
> >                         eaten = tcp_queue_rcv(sk, skb, &fragstolen);
> >
> > --
>
> Nice catch. Thanks, Eric!
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>
> neal

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the fix!
