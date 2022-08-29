Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2417B5A576F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiH2XML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2XMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:12:10 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8A7870A2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:12:09 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-33dba2693d0so232452017b3.12
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 16:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9cWtk/8xwxmskWq7iR5u0VvNk2xKEaZ6Z/BMharCeHs=;
        b=QSSfMHjLa4G5EAxGuIPiMaZ6tYO8N9Qo+jrbi1lzU29rd5jqJU6zP3Ml6Mz4iGGaY9
         93WBUdt70IO4f5khILACs+sL/u7tMUY2jGbIGxTi1VCDXT0J9x1iDHtTV10Scadb00Oi
         uGn9xLoBEApikTX0Jtonu93Nj2sHS/OQ8AtdAArbP0gWDKLevjbRLRJ+WwswUDX5RKIu
         P4E2NIgchaiUkGu5vW+SHcQM/yiGvkJS+HDlyRQB/9QYN8bQFXkxEk2aQTnts2gxi63i
         sEHUzNwH15mOzYN2sFyXV2yXbFKzL+P2QHaXB/mgHrnUDQ5RM2GiZGL4E+U0EIaxw7qx
         3fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9cWtk/8xwxmskWq7iR5u0VvNk2xKEaZ6Z/BMharCeHs=;
        b=h/6xh5Bw8TDz3tNikdtG3Nq3YIrS6KhdZZNoAVAHDE4o+a8OsVzZwbb5v4xyz0AuFK
         RMTzMzmiecbpbL90dXsFECqHSNLrsiLM9Uox5QLlSrhHL90OQpzQWdqwz19ZtTDFx8Am
         Z9syol+n6esmJefg6OsG9LygMwQkXcFo41SVsLoZciKcWRzO4K3HEVhwtkkUmhWzhMda
         LsNs1r0sy0AN5svakdG9wN/fdAz6AjNiOE3UOlvbUVWl4hhfJLLRBg7mtpUm9FT0ma76
         Mst+wUoeRzA7bxQM/I5ZjExrSAiNNN6B7DmfabjDKXMD1xAlhNwB2hdjTv2IXrjLbPUz
         lqQw==
X-Gm-Message-State: ACgBeo3QqeT6d3hYivVhZhdyvL7uK+RPw8IGv/0Vqd5h7ZYMyJU0+B9S
        le9PcouQl2FE/GGam7/Vn99eIGkyzesVXBb2Qzu/1zBpdrkpKw==
X-Google-Smtp-Source: AA6agR4DxexxFE4LxjtxqSRdHK4y8e8Sxfv02gbETRvW0Yy0XyVy6RSzlb+AEoVNKBFR/EZSQaKcvD/6knPDHT6XMyg=
X-Received: by 2002:a25:7cc6:0:b0:67a:6a2e:3d42 with SMTP id
 x189-20020a257cc6000000b0067a6a2e3d42mr9913002ybc.231.1661814728015; Mon, 29
 Aug 2022 16:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220829161920.99409-1-kuniyu@amazon.com> <20220829161920.99409-5-kuniyu@amazon.com>
In-Reply-To: <20220829161920.99409-5-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 16:11:57 -0700
Message-ID: <CANn89iKbG9njkZGEbL1xX45ErFWAv11oFUsXGF-dYsp8TJnhQA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/5] tcp: Save unnecessary inet_twsk_purge() calls.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
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

On Mon, Aug 29, 2022 at 9:21 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> While destroying netns, we call inet_twsk_purge() in tcp_sk_exit_batch()
> and tcpv6_net_exit_batch() for AF_INET and AF_INET6.  These commands
> trigger the kernel to walk through the potentially big ehash twice even
> though the netns has no TIME_WAIT sockets.
>
>   # ip netns add test
>   # ip netns del test
>
> AF_INET6 uses module_init() to be loaded after AF_INET which uses
> fs_initcall(), so tcpv6_net_ops is always registered after tcp_sk_ops.
> Also, we clean up netns in the reverse order, so tcpv6_net_exit_batch()
> is always called before tcp_sk_exit_batch().
>
> The characteristic enables us to save such unneeded iterations.  This
> change eliminates the tax by the additional unshare() described in the
> next patch to guarantee the per-netns ehash size.

Patch seems wrong to me, or not complete at least...

It seems you missed an existing check in inet_twsk_purge():

if ((tw->tw_family != family) ||
    refcount_read(&twsk_net(tw)->ns.count))
    continue;

To get rid of both IPv6 and IPv6 tw sockets, we currently need to call
inet_twsk_purge() twice,
with AF_INET and AF_INET6.


>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/tcp.h        |  1 +
>  net/ipv4/tcp_ipv4.c      |  6 ++++--
>  net/ipv4/tcp_minisocks.c | 24 ++++++++++++++++++++++++
>  net/ipv6/tcp_ipv6.c      |  2 +-
>  4 files changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index d10962b9f0d0..f60996c1d7b3 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -346,6 +346,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb);
>  void tcp_rcv_space_adjust(struct sock *sk);
>  int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp);
>  void tcp_twsk_destructor(struct sock *sk);
> +void tcp_twsk_purge(struct list_head *net_exit_list, int family);
>  ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
>                         struct pipe_inode_info *pipe, size_t len,
>                         unsigned int flags);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b07930643b11..f4a502d57d45 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -3109,8 +3109,10 @@ static void __net_exit tcp_sk_exit(struct net *net)
>         if (net->ipv4.tcp_congestion_control)
>                 bpf_module_put(net->ipv4.tcp_congestion_control,
>                                net->ipv4.tcp_congestion_control->owner);
> -       if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
> +       if (refcount_dec_and_test(&tcp_death_row->tw_refcount)) {
>                 kfree(tcp_death_row);
> +               net->ipv4.tcp_death_row = NULL;
> +       }
>  }
>
>  static int __net_init tcp_sk_init(struct net *net)
> @@ -3210,7 +3212,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
>  {
>         struct net *net;
>
> -       inet_twsk_purge(&tcp_hashinfo, AF_INET);
> +       tcp_twsk_purge(net_exit_list, AF_INET);
>
>         list_for_each_entry(net, net_exit_list, exit_list)
>                 tcp_fastopen_ctx_destroy(net);
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 361aad67c6d6..9168c5a33344 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -347,6 +347,30 @@ void tcp_twsk_destructor(struct sock *sk)
>  }
>  EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
>
> +void tcp_twsk_purge(struct list_head *net_exit_list, int family)
> +{
> +       struct net *net;
> +
> +       list_for_each_entry(net, net_exit_list, exit_list) {
> +               if (!net->ipv4.tcp_death_row)
> +                       continue;
> +
> +               /* AF_INET6 using module_init() is always registered after
> +                * AF_INET using fs_initcall() and cleaned up in the reverse
> +                * order.
> +                *
> +                * The last refcount is decremented later in tcp_sk_exit().
> +                */
> +               if (IS_ENABLED(CONFIG_IPV6) && family == AF_INET6 &&
> +                   refcount_read(&net->ipv4.tcp_death_row->tw_refcount) == 1)
> +                       continue;
> +
> +               inet_twsk_purge(&tcp_hashinfo, family);
> +               break;
> +       }
> +}
> +EXPORT_SYMBOL_GPL(tcp_twsk_purge);
> +
>  /* Warning : This function is called without sk_listener being locked.
>   * Be sure to read socket fields once, as their value could change under us.
>   */
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 27b2fd98a2c4..9cbc7f0d7149 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -2229,7 +2229,7 @@ static void __net_exit tcpv6_net_exit(struct net *net)
>
>  static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
>  {
> -       inet_twsk_purge(&tcp_hashinfo, AF_INET6);
> +       tcp_twsk_purge(net_exit_list, AF_INET6);
>  }
>
>  static struct pernet_operations tcpv6_net_ops = {
> --
> 2.30.2
>
