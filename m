Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC16696D3
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjAMMWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbjAMMWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:22:01 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63453D5DD
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:16:33 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id l139so22091888ybl.12
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 04:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+PtZnNS70XnntmnTOZy027lj3AuB4jtCCxH9ncjY8es=;
        b=taE3+ILiaxDnaLaoP7hhjNDlyCmeAS1Ea6O0cbhB3nYeaiL+auDT7eShoUNDqu7idQ
         TkB2svZoeXd4C7V8qrxxHG1/bsV+JvjJzDUomhRJa+sYEVmrufFML8PZ9Sf+PJdVtEnP
         P8wgiX+huEmNwcMvZ3WQ5ECWawz+4zaIAUPm4CZWx6VfOdVqIcbrmO427wfn/ic4IE5/
         dGfx8i8yzi9rCYzq5JhsnTojbQWhzkBTlQJvWD2cNqPk0JNJq1J71VJJ0fWsysmhVtDA
         NAQSHl8ornL4fLxaAIK1xwLstPy+Fp/C/oX6zJo23qUsnj93H4ermFn3H2HzFyHJRWAV
         HmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+PtZnNS70XnntmnTOZy027lj3AuB4jtCCxH9ncjY8es=;
        b=IT+rYXawd8ISqsG7HfoDm4BfBmX3tBgyMbuRGC2ReIeHkNbRtA1Yb1bEGxuYcMgt0h
         U4F7UI4baI0B/V2QsRjxP3LzIvT+isM0B8HAXYIGekmlo+iZ2mi5uGqAQsVjM41epSPr
         O+raIo8wibReOvCvUKNJBJ/FOO/32ZFzlSCVndV7hPG0XjMgeNjdOa5FGVqeRRP5aEIe
         6TAjddS45NbJNxaLSyU4khNDoP6EWiLoZ315am4mId1ZX4pIK+HA4vRPxF+gF1eJ3Ipc
         NLvdjPjOgMUpjKNOjQOLM7KCTbQwry7EYmImgaedDzwz9sau7lqvcwB2Bzppbya0038n
         0jWw==
X-Gm-Message-State: AFqh2kqLa5veHOBcMm1/9SpJny7Aa0y2QvlvTdvChD36YYt661W/TmgN
        kvrFjarawP5/NC2VeOTItgyuYI8l955H4Wu6LJmB8w==
X-Google-Smtp-Source: AMrXdXt0Y+QjUw/o9mD1oQ+G3Pi3+hxyuaceEp5S65q86Ac7MDswDFZkH6r9B84JF9Msych+He0D+l0AZ/zNaF5ndRI=
X-Received: by 2002:a25:46c6:0:b0:7b8:a0b8:f7ec with SMTP id
 t189-20020a2546c6000000b007b8a0b8f7ecmr3315906yba.36.1673612192479; Fri, 13
 Jan 2023 04:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it>
In-Reply-To: <20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 13 Jan 2023 13:16:20 +0100
Message-ID: <CANn89iJekPT_HsJ6vfQf=Vk8AXqgQjoU=FscBHGVSRcvdfaKDA@mail.gmail.com>
Subject: Re: [PATCH v2] inet: fix fast path in __inet_hash_connect()
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>
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

On Fri, Jan 13, 2023 at 12:40 PM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> __inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
> equal to the sk parameter.
> sk_head() returns the hlist_entry() with respect to the sk_node field.
> However entries in the tb->owners list are inserted with respect to the
> sk_bind_node field with sk_add_bind_node().
> Thus the check would never pass and the fast path never execute.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
> Changes in v2:
> - nit: s/list_entry/hlist_entry/
> - Link to v1: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it
> ---
>  include/net/sock.h         | 10 ++++++++++
>  net/ipv4/inet_hashtables.c |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..23fc403284db 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -860,6 +860,16 @@ static inline void sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_hea
>         __sk_nulls_add_node_rcu(sk, list);
>  }
>
> +static inline struct sock *__sk_bind_head(const struct hlist_head *head)
> +{
> +       return hlist_entry(head->first, struct sock, sk_bind_node);
> +}
> +
> +static inline struct sock *sk_bind_head(const struct hlist_head *head)
> +{
> +       return hlist_empty(head) ? NULL : __sk_bind_head(head);
> +}
> +
>  static inline void __sk_del_bind_node(struct sock *sk)
>  {
>         __hlist_del(&sk->sk_bind_node);
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index d039b4e732a3..a805e086fb48 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -998,7 +998,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>                                                   hinfo->bhash_size)];
>                 tb = inet_csk(sk)->icsk_bind_hash;
>                 spin_lock_bh(&head->lock);
> -               if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
> +               if (sk_bind_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
>                         inet_ehash_nolisten(sk, NULL, NULL);

1) Given this path was never really used, we have no coverage.

2) Given that we do not check inet_ehash_nolisten() return code here.

I would recommend _not_ adding the Fixes: tag, and target net-next tree

In fact, I would remove this dead code, and reduce complexity.

I doubt the difference is going to be noticed.
(We have to access the ehash bucket anyway)


>                         spin_unlock_bh(&head->lock);
>                         return 0;
>
> ---
> base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
> change-id: 20230112-inet_hash_connect_bind_head-8f2dc98f08b1
>
> Best regards,
> --
> Pietro Borrello <borrello@diag.uniroma1.it>
