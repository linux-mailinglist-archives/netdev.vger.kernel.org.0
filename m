Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C263485C1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhCYALy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhCYALe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 20:11:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397FBC06174A;
        Wed, 24 Mar 2021 17:11:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so1961137pjq.5;
        Wed, 24 Mar 2021 17:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L88O0BW7wQbwhjCdIIhzzEKl+qvvq9wqufLgOCyN/mI=;
        b=leqxAWb3Qyz33DMTBFPpgq8dQE4KfUtyyEkXyP5nghdztcV6W+ZuzcPinKiQByCaol
         1XEYpXv1nDPc2RQs1VVmV9mKJOrYO7cHo3tRPDv+GaqE1zZKRpe701qnPKJ512szzxSS
         AGvq+JVmMtOcHfedR34tGApy6lzaVlDKWdAQEFilsyNj7f2mRRhDmWLZn6VSV9I+0sxe
         weUisbTaa5CnpBmrymVAf96M8hnWwuYHFjl8PDyJuABCoI9x3Y1Us+iBMC9PeQ6X2KNe
         Avi7414I9jvZwLRIdcvWkAhT3ICC7leJDs7RXn7WjXLJtq7rmUboJTeyKiw7zxnz85qK
         Xz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L88O0BW7wQbwhjCdIIhzzEKl+qvvq9wqufLgOCyN/mI=;
        b=EXvHqO9f+FHblKJRQzOaNXc+WaVqnz/+mqm796Bsl+8TI3s5M8JpL29Auo+nzJdqTt
         Bns+PbEwCnPt5P1FhIBgPLvVogPw7OJlCNteRzQ8F6ixnrgMa8/0MzD3F5/2JeawiJK3
         3BA9wjl8dpd8ZLyxaaQyMJmo4RztAZD8JQRW2NbRfE2TArAkqP8GeAgKXVT/DDq5VaUI
         RQE6jM4fBzH35mBaqXd2M4OXdJdWiGb790woICOsSmldWkeCFhdMkSu73UIFj2lU3TL5
         Vt+5eKpnxQTWmaWb1YrvcX2zke3TVP/r50G/3LOLa4n2Il4QeS4HC77VDYzyhlagQ5rc
         /2Zg==
X-Gm-Message-State: AOAM533HZDWBC4KJoDyq/F/0TJ2T8Su5qphpEaOd+sFu5UjVqviJzNCR
        uZYr3EqrE1Cs4DhzBRJRP8zw2VJmNkO347wbwog=
X-Google-Smtp-Source: ABdhPJw9A7YtieUzAo/LOSxFJvLCv92K8ZswZbRrmTdjBCVefpnsmm4Exwa0JomZ57IDemxpdqtMjGxTILpUo+S4MOc=
X-Received: by 2002:a17:90a:7061:: with SMTP id f88mr6038598pjk.56.1616631093769;
 Wed, 24 Mar 2021 17:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661956953.28508.2297266338306692603.stgit@john-Precision-5820-Tower>
In-Reply-To: <161661956953.28508.2297266338306692603.stgit@john-Precision-5820-Tower>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 24 Mar 2021 17:11:22 -0700
Message-ID: <CAM_iQpUNUE8cmyNaALG1dZtCfJGah2pggDNk-eVbyxexnA4o_g@mail.gmail.com>
Subject: Re: [bpf PATCH 1/2] bpf, sockmap: fix sk->prot unhash op reset
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 1:59 PM John Fastabend <john.fastabend@gmail.com> wrote:
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 47b7c5334c34..ecb5634b4c4a 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -754,6 +754,12 @@ static void tls_update(struct sock *sk, struct proto *p,
>
>         ctx = tls_get_ctx(sk);
>         if (likely(ctx)) {
> +               /* TLS does not have an unhash proto in SW cases, but we need
> +                * to ensure we stop using the sock_map unhash routine because
> +                * the associated psock is being removed. So use the original
> +                * unhash handler.
> +                */
> +               WRITE_ONCE(sk->sk_prot->unhash, p->unhash);
>                 ctx->sk_write_space = write_space;
>                 ctx->sk_proto = p;

It looks awkward to update sk->sk_proto inside tls_update(),
at least when ctx!=NULL.

What is wrong with updating it in sk_psock_restore_proto()
when inet_csk_has_ulp() is true? It looks better to me.

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6c09d94be2e9..da5dc3ef0ee3 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -360,8 +360,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
                                          struct sk_psock *psock)
 {
-       sk->sk_prot->unhash = psock->saved_unhash;
        if (inet_csk_has_ulp(sk)) {
+               sk->sk_prot->unhash = psock->sk_proto->unhash;
                tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
        } else {
                sk->sk_write_space = psock->saved_write_space;


sk_psock_restore_proto() is the only caller of tcp_update_ulp()
so should be equivalent.

Thanks.
