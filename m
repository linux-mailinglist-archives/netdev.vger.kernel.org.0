Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD472C60CC
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgK0IXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK0IXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:23:19 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA90C0613D1;
        Fri, 27 Nov 2020 00:23:19 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id l17so3774816pgk.1;
        Fri, 27 Nov 2020 00:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ofnRM1vPxs6Z1Dh5RlbJ6mIhU4Yv5EcitgSCPhDD/xo=;
        b=NopATpg0UMa9XOyN/DeJE4gTE8VQKs/j7vUCHqEvkGgXQOanCReUUXtgW3QtEPyWse
         EcY75QZDB1lu9PZFSJSSRGsOoIz+omuHjMerXQV5/qh84Hr/y/a93uX8hJaLkqesNrz6
         X+XPlTF+mIWbQd+mswDebDzD4NIqe+USkOUaFgNVoq8BysnnYiXu90vfUjACjP7P0NhY
         w68hj2koPDc6Ef58l1kGxk9DiXfeinSJ/1DvTEbbb7k9VUSH3ZIohSfPO8vNdDzEnri1
         pkj3QklDikg6x9uL9r6fq1/yiSjS7RX6cNpvS8LH+agxb9ze8J+bOcQ7pksyz3woFHjW
         ciLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ofnRM1vPxs6Z1Dh5RlbJ6mIhU4Yv5EcitgSCPhDD/xo=;
        b=LtBwbhhhHQvw3Cnv9rAR0NzpqvFr++yo3FFmV9a1WCXeimMMrRRpKYy9ktf/8iWGR1
         +e73doPpzFLYQkVE05Te+QITSnWxn6/OeHtFtUe4SJN7cTzVloPM7ECcoW/aPjvD3316
         6UDDoqPA1pkO9lHN8c774XCZCCm06t8NNQqblJtp0qEPSiUX5FX9fsYsp9eNDhGX3Oon
         ZIJvtCd57qOuNgQgsaaygORLqvikKjZfHlgeupTv2EKCHcfj7JvNMat3hsvlVYUcSA+D
         bpw6TnuFI4iv1O1veM/bX+XC2wbSbSnypBYUDO65ROG63siraolTEt6/yLH6OjdsnwfB
         t5pA==
X-Gm-Message-State: AOAM532ihRJe12EACYAMC+ajnl1vuXdGuUj+Q/nXZeC8qXDyMashrv/g
        3eE9E7rh3fIToTzB3kq4jvCCjgyP8wnJJ5pec+8=
X-Google-Smtp-Source: ABdhPJxFJOBZnbN7FpTKABJ39x+G42tG+0PF+3rJJT+CJRju6ebRKrIKD0kjgWByPUd+0/J3tugX53HP846kNJ6YVYA=
X-Received: by 2002:aa7:9521:0:b029:18b:b43:6cc with SMTP id
 c1-20020aa795210000b029018b0b4306ccmr6126287pfp.73.1606465399522; Fri, 27 Nov
 2020 00:23:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605686678.git.xuanzhuo@linux.alibaba.com>
 <cover.1606285978.git.xuanzhuo@linux.alibaba.com> <01f59423cad1b634fe704fe238a0038fd74df3ba.1606285978.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <01f59423cad1b634fe704fe238a0038fd74df3ba.1606285978.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 27 Nov 2020 09:23:08 +0100
Message-ID: <CAJ8uoz2snP+nMMnDSZOMx2-xD9ZSfBCVuqvRZhoV5tRjR5r0Xg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] xsk: replace datagram_poll by sock_poll_wait
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 7:49 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
> based on the traditional socket information (eg: sk_wmem_alloc), but
> this does not apply to xsk. So this patch uses sock_poll_wait instead of
> datagram_poll, and the mask is calculated by xsk_poll.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  net/xdp/xsk.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index b014197..0df8651 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -534,11 +534,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  static __poll_t xsk_poll(struct file *file, struct socket *sock,
>                              struct poll_table_struct *wait)
>  {
> -       __poll_t mask = datagram_poll(file, sock, wait);
> +       __poll_t mask = 0;
>         struct sock *sk = sock->sk;
>         struct xdp_sock *xs = xdp_sk(sk);
>         struct xsk_buff_pool *pool;
>
> +       sock_poll_wait(file, sock, wait);
> +
>         if (unlikely(!xsk_is_bound(xs)))
>                 return mask;
>
> --
> 1.8.3.1
>
