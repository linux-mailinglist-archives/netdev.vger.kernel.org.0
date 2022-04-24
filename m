Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF95050D4E2
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 21:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbiDXTkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiDXTkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:40:10 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5552336E14
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 12:37:09 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p65so23584787ybp.9
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 12:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YnAouN3/QaYFQRA8k13sFCBqmUwn7Rgk9ylA4812FH8=;
        b=c6Em+6CnMcjxwIpmPMF3mQtrjKK1n945ZGOqB2TSqSUOMdIcu6cu/8GQFKj9K02tht
         wTmKciCz18mtlFc/a4tRAO5YLUunRb99GWyqzWupZi0PwIVgqtTivE5mEL29JvKLE4Bm
         /BM/rUBriv3TzWh94cx/POpRvspabs4G6hBqjYKdMRC74S25kqA2ApVPtkmnUNYMg4aK
         q6bUvpH8of+oT8hzjDTBhniZDOPN8r8idVPwaCMlDzgKQarSo8BRRv/v/c97/Q5uPYRq
         ucMcz+oI/DNPTjsnwjXrDSH07+aGOR6NX4qv8QrASThiwosqMIT+ECB4dXvZyU0DtRjo
         7+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnAouN3/QaYFQRA8k13sFCBqmUwn7Rgk9ylA4812FH8=;
        b=b67GFN+Zky8wi7avxkO3y9SrHhkmMJB+EddJql1HaGjgU8gqyOvy94vDTCmYdXvti0
         1LvbAjCaqhLGnZKhxXlm0iZfxjdVrCKsU3vud8978XQWlpnVxwZ07pewWALmmnULxjdf
         pTvudienXoWIDEkuEBiNGzAw6R8NvKrlVPgS74TWv6FTHLKgpa1/bf77mzxGWQBl5p0Z
         XkpCm/PJAhh5F+T1h93rPrTDi3jkURPzaXRqjLE1PN2tHWyPRamV3gBYBncA+HAURtpT
         yjQl3zkigUguOOd9RoxOiOyfgZNQgdlvhbDpoOkRQkIoVoLYS2WNJ0eM+zmkk22d68Z6
         OwcA==
X-Gm-Message-State: AOAM532cITaC3iTvUwr9cS5jSinvzLue0LqriitbJu+QxaPyBR3Mj/Zl
        4j+Z47Rb1QwAuiTBsVwQbRmaaEDjT0gpGH0+motZOXSL0CSKolaR
X-Google-Smtp-Source: ABdhPJxPee0rQQxRVcJIKv7ARIsp8dN+dBXkPrOltW7JPYE4strNgNlr+7QNfAU8CKBa6dZD3jpZYe8+5LsV3O60wBM=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr13153900ybs.427.1650829028283; Sun, 24
 Apr 2022 12:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com>
In-Reply-To: <20220421005026.686A45EC01F2@us226.sjc.aristanetworks.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 24 Apr 2022 12:36:57 -0700
Message-ID: <CANn89iKM-f=VLfwb9wq8+_bmaLjP_Xg5CanqJWhans2DXE=v5w@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp: md5: incorrect tcp_header_len for incoming connections
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 5:50 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> In tcp_create_openreq_child we adjust tcp_header_len for md5 using the
> remote address in newsk. But that address is still 0 in newsk at this
> point, and it is only set later by the callers (tcp_v[46]_syn_recv_sock).
> Use the address from the request socket instead.
>
> v2: Added "Fixes:" line.
>
> Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> ---
>  net/ipv4/tcp_minisocks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 6366df7aaf2a..6854bb1fb32b 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -531,7 +531,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
>         newtp->tsoffset = treq->ts_off;
>  #ifdef CONFIG_TCP_MD5SIG
>         newtp->md5sig_info = NULL;      /*XXX*/
> -       if (newtp->af_specific->md5_lookup(sk, newsk))
> +       if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))

Wait a minute.

Are you sure treq->af_specific is initialized at this point ?

I should have tested this one liner patch really :/

I think that for syncookies, treq->af_specific is not initialized,
because we do not go through
tcp_conn_request() helper, but instead use cookie_tcp_reqsk_alloc()

Before your patch treq->af_specific was only used during SYNACK
generation, which does not happen in syncookie more while receiving
the third packet.

I will test something like this patch. We could move the init after
cookie_tcp_reqsk_alloc() has been called, but I prefer using the same
construct than tcp_conn_request()

diff --git a/include/net/tcp.h b/include/net/tcp.h
index be712fb9ddd71b2b320356677f3aa1c6759e2698..9987b3fba9f202632916cc439af9d17f1e68bcd3
100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -480,6 +480,7 @@ int __cookie_v4_check(const struct iphdr *iph,
const struct tcphdr *th,
                      u32 cookie);
 struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb);
 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+                                           const struct
tcp_request_sock_ops *af_ops,
                                            struct sock *sk, struct
sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 2cb3b852d14861231ac47f0b3e4daeb57682ffd2..f191bfa996d71f11ef786a0a3bcb8f737622d37a
100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -281,6 +281,7 @@ bool cookie_ecn_ok(const struct
tcp_options_received *tcp_opt,
 EXPORT_SYMBOL(cookie_ecn_ok);

 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+                                           const struct
tcp_request_sock_ops *af_ops,
                                            struct sock *sk,
                                            struct sk_buff *skb)
 {
@@ -297,6 +298,8 @@ struct request_sock *cookie_tcp_reqsk_alloc(const
struct request_sock_ops *ops,
                return NULL;

        treq = tcp_rsk(req);
+       /* treq->af_specific might be used to perform TCP_MD5 lookup */
+       treq->af_specific = af_ops;
        treq->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
 #if IS_ENABLED(CONFIG_MPTCP)
        treq->is_mptcp = sk_is_mptcp(sk);
@@ -364,7 +367,8 @@ struct sock *cookie_v4_check(struct sock *sk,
struct sk_buff *skb)
                goto out;

        ret = NULL;
-       req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops, sk, skb);
+       req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops,
+                                    &tcp_request_sock_ipv4_ops, sk, skb);
        if (!req)
                goto out;

diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index d1b61d00368e1f58725e9997f74a0b144901277e..9cc123f000fbcfbeff7728bfee5339d6dd6470f9
100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -170,7 +170,8 @@ struct sock *cookie_v6_check(struct sock *sk,
struct sk_buff *skb)
                goto out;

        ret = NULL;
-       req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops, sk, skb);
+       req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops,
+                                    &tcp_request_sock_ipv6_ops, sk, skb);
        if (!req)
                goto out;
